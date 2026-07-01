import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/restaurant/presentation/cubit/kitchen_display_state.dart';
import 'package:frantend/features/restaurant/presentation/utils/kot_status_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class KitchenDisplayCubit extends Cubit<KitchenDisplayState> {
  KitchenDisplayCubit({
    required GetActiveKotOrdersUseCase getActiveKotOrdersUseCase,
    required UpdateKotStatusUseCase updateKotStatusUseCase,
    required AuthLocalDataSource authLocalDataSource,
    required BusinessSessionCubit businessSession,
  })  : _getActiveKotOrders = getActiveKotOrdersUseCase,
        _updateKotStatus = updateKotStatusUseCase,
        _authLocal = authLocalDataSource,
        _businessSession = businessSession,
        super(const KitchenDisplayState());

  static const _refreshInterval = Duration(seconds: 10);

  final GetActiveKotOrdersUseCase _getActiveKotOrders;
  final UpdateKotStatusUseCase _updateKotStatus;
  final AuthLocalDataSource _authLocal;
  final BusinessSessionCubit _businessSession;

  Timer? _refreshTimer;
  String? _branchId;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    final flags = _businessSession.state.flags;

    if (!flags.showKitchenNav ||
        !UserRoleUtils.canViewKot(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        )) {
      emit(state.copyWith(accessDenied: true));
      return;
    }

    final selector = sl<BranchSelectorCubit>().state;
    _branchId = selector.isInitialized && selector.selectedBranchId != null
        ? selector.selectedBranchId
        : user?.branchId;

    await loadTickets();
    _startAutoRefresh();
  }

  Future<void> loadTickets({bool isRefresh = false}) async {
    if (state.accessDenied) return;

    if (!isRefresh) {
      emit(
        state.copyWith(
          status: KitchenDisplayStatus.loading,
          errorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(isRefreshing: true, errorMessage: null));
    }

    final result = await _getActiveKotOrders(branchId: _branchId);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: KitchenDisplayStatus.error,
            isRefreshing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (tickets) {
        emit(
          state.copyWith(
            status: KitchenDisplayStatus.loaded,
            tickets: tickets,
            isRefreshing: false,
            errorMessage: null,
            lastRefreshedAt: DateTime.now(),
          ),
        );
      },
    );
  }

  Future<void> refresh() => loadTickets(isRefresh: true);

  Future<void> onBranchChanged(String? branchId) async {
    if (branchId == null || branchId == _branchId) return;
    _branchId = branchId;
    await loadTickets(isRefresh: true);
  }

  Future<String?> advanceTicketStatus(String kotId) async {
    KotOrderModel? ticket;
    for (final candidate in state.tickets) {
      if (candidate.id == kotId) {
        ticket = candidate;
        break;
      }
    }
    if (ticket == null) return 'Ticket not found';

    final next = KotStatusUtils.nextStatus(ticket.status);
    if (next == null) return 'No further status for this ticket';

    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canUpdateKot(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      return 'You do not have permission to update kitchen tickets';
    }

    emit(
      state.copyWith(
        isUpdatingStatus: true,
        updatingTicketId: kotId,
        errorMessage: null,
      ),
    );

    final result = await _updateKotStatus(
      kotId,
      UpdateKotStatusRequest(status: next),
    );

    if (isClosed) return null;

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUpdatingStatus: false,
            updatingTicketId: null,
            errorMessage: failure.message,
          ),
        );
        return failure.message;
      },
      (updated) async {
        final tickets = state.tickets.map((ticket) {
          return ticket.id == updated.id ? updated : ticket;
        }).where((ticket) {
          return KotStatusUtils.activeStatuses.contains(ticket.status);
        }).toList();

        emit(
          state.copyWith(
            tickets: tickets,
            isUpdatingStatus: false,
            updatingTicketId: null,
            errorMessage: null,
          ),
        );
        return null;
      },
    );
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (state.status == KitchenDisplayStatus.loaded && !state.isRefreshing) {
        unawaited(refresh());
      }
    });
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
