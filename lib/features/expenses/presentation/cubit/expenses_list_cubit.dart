import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/offline/pending_records.dart';
import 'package:frantend/features/expenses/data/models/expense_list_item_model.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpensesListCubit extends Cubit<ExpensesListState>
    with AutoRefresh<ExpensesListState> {
  ExpensesListCubit({
    required GetExpensesUseCase getExpensesUseCase,
    required GetExpenseCategoriesUseCase getExpenseCategoriesUseCase,
    required GetSuppliersUseCase getSuppliersUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getExpenses = getExpensesUseCase,
        _getCategories = getExpenseCategoriesUseCase,
        _getSuppliers = getSuppliersUseCase,
        _deleteExpense = deleteExpenseUseCase,
        _authLocal = authLocalDataSource,
        super(const ExpensesListState.initial()) {
    watchData(
      const {DataTopic.expenses, DataTopic.expenseCategories},
      _reload,
    );
  }

  static const _pageSize = 50;

  final GetExpensesUseCase _getExpenses;
  final GetExpenseCategoriesUseCase _getCategories;
  final GetSuppliersUseCase _getSuppliers;
  final DeleteExpenseUseCase _deleteExpense;
  final AuthLocalDataSource _authLocal;

  String? _categoryId;
  String? _supplierId;
  String? _branchId;
  late DateTime _dateFrom;
  late DateTime _dateTo;

  Future<void> init() async {
    final now = DateTime.now();
    _dateFrom = DateTime(now.year, now.month, 1);
    _dateTo = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    final user = await _authLocal.getCachedUser();
    _branchId = user?.branchId;
    await loadExpenses();
  }

  @override
  bool remembersCreated(DataChange change) =>
      change.topics.contains(DataTopic.expenses);

  /// A quiet re-read after a change: same dates and filters, as many rows as
  /// were showing, no spinner, and they stay when it fails.
  Future<void> _reload() async {
    final current = state;
    if (current is ExpensesListInitial) return;
    if (current is! ExpensesListLoaded) return loadExpenses();
    final read = beginRead();
    final wanted =
        current.items.length > _pageSize ? current.items.length : _pageSize;
    final categoriesResult = await _getCategories();
    final suppliersResult = await _getSuppliers();
    final rows = <ExpenseListItemModel>[];
    var total = 0;
    while (rows.length < wanted) {
      final result = await _getExpenses(
        branchId: _branchId,
        categoryId: _categoryId,
        supplierId: _supplierId,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        skip: _serverRows(rows),
        limit: _pageSize,
      );
      if (isStale(read)) return;
      final page = result.fold((_) => null, (p) => p);
      if (page == null) {
        await _showUnsent(read);
        return;
      }
      total = page.total;
      rows.addAll(page.items);
      if (page.items.isEmpty || rows.length >= total) break;
    }
    final serverRows = _serverRows(rows);
    final items = await _withCreated(rows);
    final now = state;
    if (isStale(read) || now is! ExpensesListLoaded) return;
    emit(
      now.copyWith(
        items: items,
        total: total,
        skip: serverRows == 0
            ? 0
            : ((serverRows - 1) ~/ _pageSize) * _pageSize,
        limit: _pageSize,
        categories: categoriesResult.fold((_) => now.categories, (c) => c),
        suppliers: suppliersResult.fold((_) => now.suppliers, (s) => s),
        isLoadingMore: false,
      ),
    );
  }

  static int _serverRows(List<ExpenseListItemModel> rows) =>
      rows.where((e) => !PendingRecords.isPendingId(e.id)).length;

  /// The server cannot be read: the rows on screen stay, and what was saved on
  /// this device is still shown on top of them.
  Future<void> _showUnsent(int read) async {
    final unsent = await _getExpenses.pending(
      branchId: _branchId,
      categoryId: _categoryId,
      supplierId: _supplierId,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );
    final now = state;
    if (isStale(read) || now is! ExpensesListLoaded) return;
    final kept = now.items
        .where((e) => !PendingRecords.isPendingId(e.id))
        .toList();
    emit(
      now.copyWith(
        items: [...unsent, ...kept],
        total: now.total - (now.items.length - kept.length) + unsent.length,
        // This read replaced a "load more" in flight.
        isLoadingMore: false,
      ),
    );
  }

  /// Reads again behind the rows on screen (back from a form or a detail).
  Future<void> refresh() =>
      state is ExpensesListLoaded ? _reload() : loadExpenses();

  /// An expense just created goes on top, even when a filter chosen earlier
  /// would hide it.
  Future<List<ExpenseListItemModel>> _withCreated(
    List<ExpenseListItemModel> items,
  ) async {
    if (createdIds.isEmpty) return items;
    final missing = createdIds.toSet()..removeAll(items.map((e) => e.id));
    var all = items;
    if (missing.isNotEmpty && (_categoryId != null || _supplierId != null)) {
      final result = await _getExpenses(
        branchId: _branchId,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        skip: 0,
        limit: _pageSize,
      );
      all = [
        ...items,
        ...result.fold(
          (_) => const <ExpenseListItemModel>[],
          (p) => p.items.where((e) => missing.contains(e.id)),
        ),
      ];
    }
    return newestFirst(all, (e) => e.id);
  }

  /// The id of the new expense on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! ExpensesListLoaded) return null;
    return createdOnTop(current.items, (e) => e.id);
  }

  Future<void> loadExpenses({bool reset = true}) async {
    final read = beginRead();
    if (reset) {
      emit(const ExpensesListState.loading());
    } else {
      final current = state;
      if (current is ExpensesListLoaded) {
        emit(current.copyWith(isLoadingMore: true));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            ExpensesListLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    final categoriesResult = await _getCategories();
    final suppliersResult = await _getSuppliers();
    final expensesResult = await _getExpenses(
      branchId: _branchId,
      categoryId: _categoryId,
      supplierId: _supplierId,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      skip: skip,
      limit: _pageSize,
    );
    if (isStale(read)) return;
    final first = reset
        ? await expensesResult.fold(
            (_) async => const <ExpenseListItemModel>[],
            (page) => _withCreated(page.items),
          )
        : const <ExpenseListItemModel>[];
    if (isStale(read)) return;

    expensesResult.fold(
      (failure) => emit(ExpensesListState.error(failure.message)),
      (page) {
        final categories = categoriesResult.fold(
          (_) => <ExpenseCategoryModel>[],
          (c) => c,
        );
        final suppliers = suppliersResult.fold(
          (_) => <SupplierModel>[],
          (s) => s,
        );
        final hasFilters = _categoryId != null ||
            _supplierId != null ||
            _branchId != null;

        if (!reset && state is ExpensesListLoaded) {
          final prev = state as ExpensesListLoaded;
          emit(
            ExpensesListLoaded(
              items: [
                ...prev.items,
                ...page.items
                    .where((e) => !prev.items.any((p) => p.id == e.id)),
              ],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              categories: categories,
              suppliers: suppliers,
              categoryIdFilter: _categoryId,
              supplierIdFilter: _supplierId,
              branchIdFilter: _branchId,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              hasActiveFilters: hasFilters,
            ),
          );
        } else {
          emit(
            ExpensesListLoaded(
              items: first,
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              categories: categories,
              suppliers: suppliers,
              categoryIdFilter: _categoryId,
              supplierIdFilter: _supplierId,
              branchIdFilter: _branchId,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              hasActiveFilters: hasFilters,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ExpensesListLoaded) return;
    if (current.items.length >= current.total) return;
    await loadExpenses(reset: false);
  }

  Future<void> setDateRange(DateTime from, DateTime to) async {
    _dateFrom = from;
    _dateTo = to;
    await loadExpenses();
  }

  Future<void> setCategoryFilter(String? categoryId) async {
    _categoryId = categoryId;
    forgetCreated();
    await loadExpenses();
  }

  Future<void> setSupplierFilter(String? supplierId) async {
    _supplierId = supplierId;
    forgetCreated();
    await loadExpenses();
  }

  Future<void> clearFilters() async {
    _categoryId = null;
    _supplierId = null;
    forgetCreated();
    await init();
  }

  Future<bool> deleteExpense(String id) async {
    final result = await _deleteExpense(id);
    return result.fold(
      (failure) {
        emit(ExpensesListState.error(failure.message));
        return false;
      },
      (_) {
        final current = state;
        if (current is ExpensesListLoaded) {
          final updated = current.items.where((e) => e.id != id).toList();
          emit(
            current.copyWith(
              items: updated,
              total: current.total > 0 ? current.total - 1 : 0,
            ),
          );
        }
        return true;
      },
    );
  }

  String pageTotalAmount(ExpensesListLoaded state) {
    return ExpenseCalculations.sumAmounts(
      state.items.map((e) => e.amount),
    ).toString();
  }
}
