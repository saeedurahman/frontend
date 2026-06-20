import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'expense_form_state.freezed.dart';

@freezed
class ExpenseFormState with _$ExpenseFormState {
  const factory ExpenseFormState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? expenseId,
    String? branchId,
    String? categoryId,
    String? supplierId,
    @Default('') String amount,
    @Default('0') String taxAmount,
    @Default('') String description,
    DateTime? expenseDate,
    @Default(false) bool recordPaymentNow,
    @Default('cash') String paymentMethod,
    @Default('') String paymentAmount,
    String? referenceNo,
    @Default([]) List<ExpenseCategoryModel> categories,
    @Default([]) List<SupplierModel> suppliers,
    String? activePaymentShiftId,
    @Default(false) bool isCheckingPaymentShift,
    @Default({}) Map<String, String> errors,
  }) = _ExpenseFormState;
}
