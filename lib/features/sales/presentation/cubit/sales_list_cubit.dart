import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/sales/data/models/sale_list_item_model.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_state.dart';
import 'package:frantend/features/sales/presentation/utils/sale_product_enrichment.dart';
import 'package:injectable/injectable.dart';

@injectable
class SalesListCubit extends Cubit<SalesListState>
    with AutoRefresh<SalesListState> {
  SalesListCubit({
    required GetSalesUseCase getSalesUseCase,
    required GetSaleByIdUseCase getSaleByIdUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getSales = getSalesUseCase,
        _getSaleById = getSaleByIdUseCase,
        _getProductById = getProductByIdUseCase,
        _authLocal = authLocalDataSource,
        super(const SalesListState.initial()) {
    watchData(const {DataTopic.sales, DataTopic.returns}, _reload);
  }

  static const _maxLimit = 200;
  static const _defaultPageSize = 10;
  int _pageSize = _defaultPageSize;

  final GetSalesUseCase _getSales;
  final GetSaleByIdUseCase _getSaleById;
  final GetProductByIdUseCase _getProductById;
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

  /// A quiet re-read after a change: same dates, filters and page, no spinner,
  /// and the rows stay when it fails.
  Future<void> _reload() async {
    final current = state;
    if (current is SalesListInitial) return;
    if (current is! SalesListLoaded) return loadSales();
    final read = beginRead();
    final appended = current.items.length > current.limit;
    final from = appended ? 0 : current.skip;
    final wanted = appended ? current.items.length : current.limit;
    final rows = <SaleListItemModel>[];
    var total = 0;
    while (rows.length < wanted) {
      final result = await _getSales(
        branchId: _branchId,
        status: _status,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        search: _search,
        skip: from + rows.length,
        limit: (wanted - rows.length).clamp(1, _maxLimit),
      );
      if (isStale(read)) return;
      final page = result.fold((_) => null, (p) => p);
      if (page == null) {
        // This read replaced a "load more" in flight.
        final now = state;
        if (now is SalesListLoaded) {
          emit(now.copyWith(isLoadingMore: false));
        }
        return;
      }
      total = page.total;
      rows.addAll(page.items);
      if (page.items.isEmpty || from + rows.length >= total) break;
    }
    final now = state;
    if (now is! SalesListLoaded) return;
    final names = {for (final s in now.items) s.id: s.productNames};
    emit(
      now.copyWith(
        items: [
          for (final s in rows)
            s.productNames.isEmpty && (names[s.id]?.isNotEmpty ?? false)
                ? s.copyWith(productNames: names[s.id]!)
                : s,
        ],
        total: total,
        isLoadingMore: false,
      ),
    );
    await _enrichProductNamesAsync();
  }

  Future<void> loadSales({bool reset = true}) async {
    final read = beginRead();
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
    if (isStale(read)) return;

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
        _enrichProductNamesAsync();
      },
    );
  }

  Future<void> _enrichProductNamesAsync() async {
    final current = state;
    if (current is! SalesListLoaded) return;

    final targets =
        current.items.where((item) => item.productNames.isEmpty).toList();
    if (targets.isEmpty) return;

    final enrichedById = <String, List<String>>{};
    await Future.wait(
      targets.map((item) async {
        final result = await _getSaleById(item.id);
        await result.fold((_) async {}, (sale) async {
          final names = await SaleProductEnrichment.productNamesForSale(
            sale,
            _getProductById.call,
          );
          if (names.isNotEmpty) enrichedById[item.id] = names;
        });
      }),
    );

    if (isClosed) return;
    final latest = state;
    if (latest is! SalesListLoaded) return;

    emit(
      latest.copyWith(
        items: latest.items
            .map(
              (item) => enrichedById.containsKey(item.id)
                  ? item.copyWith(productNames: enrichedById[item.id]!)
                  : item,
            )
            .toList(),
      ),
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

    final read = beginRead();
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
    if (isStale(read)) return;

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
        _enrichProductNamesAsync();
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

  Future<void> refresh() =>
      state is SalesListLoaded ? _reload() : loadSales();

  void clearFilters() {
    _status = null;
    _search = null;
    final now = DateTime.now();
    _dateTo = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _dateFrom = _dateTo.subtract(const Duration(days: 6));
    loadSales();
  }
}
