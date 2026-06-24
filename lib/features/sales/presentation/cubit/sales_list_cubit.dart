import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SalesListCubit extends Cubit<SalesListState> {
  SalesListCubit({
    required GetSalesUseCase getSalesUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getSales = getSalesUseCase,
        _authLocal = authLocalDataSource,
        super(const SalesListState.initial());

  static const _defaultPageSize = 10;
  int _pageSize = _defaultPageSize;

  final GetSalesUseCase _getSales;
  final AuthLocalDataSource _authLocal;

  Timer? _searchDebounce;

  String? _search;
  String? _status;
  String? _branchId;
  late DateTime _dateFrom;
  late DateTime _dateTo;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> init() async {
    final now = DateTime.now();
    _dateTo = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _dateFrom = _dateTo.subtract(const Duration(days: 6));
    final selector = sl<BranchSelectorCubit>().state;
    _branchId = selector.isInitialized && selector.selectedBranchId != null
        ? selector.selectedBranchId
        : (await _authLocal.getCachedUser())?.branchId;
    await loadSales();
  }

  Future<void> loadSales({bool reset = true}) async {
    if (reset) {
      emit(const SalesListState.loading());
    } else {
      final current = state;
      if (current is SalesListLoaded) {
        emit(current.copyWith(isLoadingMore: true));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            SalesListLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    final result = await _getSales(
      branchId: _branchId,
      status: _status,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      search: _search,
      skip: skip,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(SalesListState.error(failure.message)),
      (page) {
        final hasFilters = _status != null ||
            (_search != null && _search!.isNotEmpty) ||
            _branchId != null;

        if (!reset && state is SalesListLoaded) {
          final prev = state as SalesListLoaded;
          emit(
            SalesListLoaded(
              items: [...prev.items, ...page.items],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              statusFilter: _status,
              branchIdFilter: _branchId,
              searchQuery: _search,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              hasActiveFilters: hasFilters,
            ),
          );
        } else {
          emit(
            SalesListLoaded(
              items: page.items,
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              statusFilter: _status,
              branchIdFilter: _branchId,
              searchQuery: _search,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              hasActiveFilters: hasFilters,
            ),
          );
        }
      },
    );
  }

  int get pageSize => _pageSize;

  int currentPage(SalesListLoaded state) => (state.skip ~/ state.limit) + 1;

  int totalPages(SalesListLoaded state) {
    if (state.total == 0) return 1;
    return (state.total / state.limit).ceil();
  }

  Future<void> setPageSize(int size) async {
    if (size < 1 || _pageSize == size) return;
    _pageSize = size;
    await loadSales();
  }

  Future<void> goToPage(int page) async {
    final current = state;
    if (current is! SalesListLoaded) return;
    final totalPages = this.totalPages(current);
    final target = page.clamp(1, totalPages);
    if (target == currentPage(current)) return;

    emit(const SalesListState.loading());
    final skip = (target - 1) * _pageSize;
    final result = await _getSales(
      branchId: _branchId,
      status: _status,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      search: _search,
      skip: skip,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(SalesListState.error(failure.message)),
      (page) {
        final hasFilters = _status != null ||
            (_search != null && _search!.isNotEmpty) ||
            _branchId != null;
        emit(
          SalesListLoaded(
            items: page.items,
            total: page.total,
            skip: page.skip,
            limit: page.limit,
            statusFilter: _status,
            branchIdFilter: _branchId,
            searchQuery: _search,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            hasActiveFilters: hasFilters,
          ),
        );
      },
    );
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
      loadSales();
    });
  }

  void applyStatusFilter(String? status) {
    _status = status;
    loadSales();
  }

  void applyDateRange(DateTime from, DateTime to) {
    _dateFrom = DateTime(from.year, from.month, from.day);
    _dateTo = DateTime(to.year, to.month, to.day, 23, 59, 59);
    loadSales();
  }

  void applyBranchFilter(String? branchId) {
    _branchId = branchId;
    loadSales();
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! SalesListLoaded) return;
    if (current.isLoadingMore) return;
    if (current.items.length >= current.total) return;
    await loadSales(reset: false);
  }

  Future<void> refresh() => loadSales();

  void clearFilters() {
    _status = null;
    _search = null;
    final now = DateTime.now();
    _dateTo = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _dateFrom = _dateTo.subtract(const Duration(days: 6));
    loadSales();
  }
}
