import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_list_item_model.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'expenses_list_state.freezed.dart';

@freezed
sealed class ExpensesListState with _$ExpensesListState {
  const factory ExpensesListState.initial() = ExpensesListInitial;

  const factory ExpensesListState.loading() = ExpensesListLoading;

  const factory ExpensesListState.loaded({
    required List<ExpenseListItemModel> items,
    required int total,
    required int skip,
    required int limit,
    required List<ExpenseCategoryModel> categories,
    required List<SupplierModel> suppliers,
    String? categoryIdFilter,
    String? supplierIdFilter,
    String? branchIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasActiveFilters,
  }) = ExpensesListLoaded;

  const factory ExpensesListState.error(String message) = ExpensesListError;
}
