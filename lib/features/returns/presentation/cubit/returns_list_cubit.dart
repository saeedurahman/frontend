import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/offline/pending_records.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReturnsListCubit extends Cubit<ReturnsListState>
    with AutoRefresh<ReturnsListState> {
  ReturnsListCubit({
    required GetReturnsUseCase getReturnsUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getReturns = getReturnsUseCase,
        _authLocal = authLocalDataSource,
        super(const ReturnsListState.initial()) {
    watchData(const {DataTopic.returns}, _reload);
  }

  static const _defaultLimit = 25;
  static const _maxLimit = 200;

  final GetReturnsUseCase _getReturns;
  final AuthLocalDataSource _authLocal;

  String? _branchId;
  int _limit = _defaultLimit;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewReturns(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const ReturnsListState.accessDenied());
      return;
    }

    final selector = sl<BranchSelectorCubit>().state;
    _branchId = selector.isInitialized && selector.selectedBranchId != null
        ? selector.selectedBranchId
        : user?.branchId;
    await loadReturns();
  }

  /// A quiet re-read after a change: no spinner, as many rows as were showing,
  /// and they stay when it fails.
  Future<void> _reload() async {
    final current = state;
    if (current is ReturnsListInitial || current is ReturnsListAccessDenied) {
      return;
    }
    if (current is! ReturnsListLoaded) return loadReturns();
    final read = beginRead();
    final wanted =
        current.items.length > _limit ? current.items.length : _limit;
    final rows = <SaleReturnResponseModel>[];
    var hasMore = false;
    while (rows.length < wanted) {
      final size = (wanted - rows.length).clamp(1, _maxLimit);
      final result = await _getReturns(
        branchId: _branchId,
        skip: _serverRows(rows),
        limit: size,
      );
      if (isStale(read)) return;
      final page = result.fold((_) => null, (p) => p);
      if (page == null) {
        await _showUnsent(read);
        return;
      }
      rows.addAll(page);
      hasMore = _serverRows(page) >= size;
      if (!hasMore) break;
    }
    emit(
      ReturnsListLoaded(
        items: newestFirst(rows, (r) => r.id),
        skip: current.skip,
        limit: _limit,
        branchIdFilter: _branchId,
        hasMore: hasMore,
      ),
    );
  }

  static int _serverRows(List<SaleReturnResponseModel> rows) =>
      rows.where((r) => !PendingRecords.isPendingId(r.id)).length;

  /// The server cannot be read: the rows on screen stay, and what was saved on
  /// this device is still shown on top of them.
  Future<void> _showUnsent(int read) async {
    final unsent = await _getReturns.pending(branchId: _branchId);
    final now = state;
    if (isStale(read) || now is! ReturnsListLoaded) return;
    emit(
      now.copyWith(
        items: [
          ...unsent,
          ...now.items.where((r) => !PendingRecords.isPendingId(r.id)),
        ],
        // This read replaced a "load more" in flight.
        isLoadingMore: false,
      ),
    );
  }

  /// The id of the new return on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! ReturnsListLoaded) return null;
    return createdOnTop(current.items, (r) => r.id);
  }

  Future<void> loadReturns({bool reset = true}) async {
    final read = beginRead();
    if (reset) {
      emit(const ReturnsListState.loading());
    } else {
      final current = state;
      if (current is ReturnsListLoaded) {
        emit(current.copyWith(isLoadingMore: true));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            ReturnsListLoaded(:final items) => _serverRows(items),
            _ => 0,
          };

    final result = await _getReturns(
      branchId: _branchId,
      skip: skip,
      limit: _limit,
    );
    if (isStale(read)) return;

    result.fold(
      (failure) => emit(ReturnsListState.error(failure.message)),
      (page) {
        final hasMore = _serverRows(page) >= _limit;
        if (!reset && state is ReturnsListLoaded) {
          final prev = state as ReturnsListLoaded;
          emit(
            ReturnsListLoaded(
              items: [
                ...prev.items,
                ...page.where((r) => !prev.items.any((e) => e.id == r.id)),
              ],
              skip: skip,
              limit: _limit,
              branchIdFilter: _branchId,
              hasMore: hasMore,
            ),
          );
        } else {
          emit(
            ReturnsListLoaded(
              items: page,
              skip: skip,
              limit: _limit,
              branchIdFilter: _branchId,
              hasMore: hasMore,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ReturnsListLoaded) return;
    if (current.isLoadingMore || !current.hasMore) return;
    await loadReturns(reset: false);
  }

  Future<void> refresh() =>
      state is ReturnsListLoaded ? _reload() : loadReturns();

  void applyBranchFilter(String? branchId) {
    _branchId = branchId;
    loadReturns();
  }
}
