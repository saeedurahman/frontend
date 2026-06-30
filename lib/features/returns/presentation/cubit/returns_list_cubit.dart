import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReturnsListCubit extends Cubit<ReturnsListState> {
  ReturnsListCubit({
    required GetReturnsUseCase getReturnsUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getReturns = getReturnsUseCase,
        _authLocal = authLocalDataSource,
        super(const ReturnsListState.initial());

  static const _defaultLimit = 25;

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

  Future<void> loadReturns({bool reset = true}) async {
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
            ReturnsListLoaded(:final items) => items.length,
            _ => 0,
          };

    final result = await _getReturns(
      branchId: _branchId,
      skip: skip,
      limit: _limit,
    );

    result.fold(
      (failure) => emit(ReturnsListState.error(failure.message)),
      (page) {
        final hasMore = page.length >= _limit;
        if (!reset && state is ReturnsListLoaded) {
          final prev = state as ReturnsListLoaded;
          emit(
            ReturnsListLoaded(
              items: [...prev.items, ...page],
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

  Future<void> refresh() => loadReturns();

  void applyBranchFilter(String? branchId) {
    _branchId = branchId;
    loadReturns();
  }
}
