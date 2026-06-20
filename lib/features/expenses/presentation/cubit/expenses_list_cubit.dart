import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpensesListCubit extends Cubit<ExpensesListState> {
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
        super(const ExpensesListState.initial());

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

  Future<void> loadExpenses({bool reset = true}) async {
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
              items: [...prev.items, ...page.items],
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
              items: page.items,
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
    await loadExpenses();
  }

  Future<void> setSupplierFilter(String? supplierId) async {
    _supplierId = supplierId;
    await loadExpenses();
  }

  Future<void> clearFilters() async {
    _categoryId = null;
    _supplierId = null;
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
