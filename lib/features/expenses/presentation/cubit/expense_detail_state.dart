import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'expense_detail_state.freezed.dart';

@freezed
sealed class ExpenseDetailState with _$ExpenseDetailState {
  const factory ExpenseDetailState.initial() = ExpenseDetailInitial;

  const factory ExpenseDetailState.loading() = ExpenseDetailLoading;

  const factory ExpenseDetailState.loaded({
    required ExpenseModel expense,
    required List<ExpenseCategoryModel> categories,
    SupplierModel? supplier,
    String? activePaymentShiftId,
    @Default(false) bool isCheckingPaymentShift,
    @Default(false) bool isDeleting,
    @Default(false) bool isRecordingPayment,
    String? paymentError,
  }) = ExpenseDetailLoaded;

  const factory ExpenseDetailState.error(String message) = ExpenseDetailError;
}
