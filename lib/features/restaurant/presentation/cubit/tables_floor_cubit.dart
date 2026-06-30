import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TablesFloorCubit extends Cubit<TablesFloorState> {
  TablesFloorCubit({
    required GetFloorLayoutUseCase getFloorLayoutUseCase,
    required AuthLocalDataSource authLocalDataSource,
    required BusinessSessionCubit businessSession,
  })  : _getFloorLayout = getFloorLayoutUseCase,
        _authLocal = authLocalDataSource,
        _businessSession = businessSession,
        super(const TablesFloorState());

  static const _refreshInterval = Duration(seconds: 15);

  final GetFloorLayoutUseCase _getFloorLayout;
  final AuthLocalDataSource _authLocal;
  final BusinessSessionCubit _businessSession;

  Timer? _refreshTimer;
  String? _branchId;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    final flags = _businessSession.state.flags;

    if (!flags.showTablesNav ||
        !UserRoleUtils.canViewTables(
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

    await loadLayout();
    _startAutoRefresh();
  }

  Future<void> loadLayout({bool isRefresh = false}) async {
    if (state.accessDenied) return;

    if (!isRefresh) {
      emit(
        state.copyWith(
          status: TablesFloorStatus.loading,
          errorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(isRefreshing: true, errorMessage: null));
    }

    final result = await _getFloorLayout(branchId: _branchId);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TablesFloorStatus.error,
            isRefreshing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (layout) {
        final selectedId = _resolveSelectedFloorPlanId(layout);
        emit(
          state.copyWith(
            status: TablesFloorStatus.loaded,
            layout: layout,
            selectedFloorPlanId: selectedId,
            isRefreshing: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> refresh() => loadLayout(isRefresh: true);

  void selectFloorPlan(String floorPlanId) {
    emit(state.copyWith(selectedFloorPlanId: floorPlanId));
  }

  String? _resolveSelectedFloorPlanId(FloorLayoutModel layout) {
    final current = state.selectedFloorPlanId;
    if (current != null &&
        layout.floorPlans.any((plan) => plan.id == current)) {
      return current;
    }
    if (layout.floorPlans.isEmpty) return null;
    return layout.floorPlans.first.id;
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (state.status == TablesFloorStatus.loaded && !state.isRefreshing) {
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
