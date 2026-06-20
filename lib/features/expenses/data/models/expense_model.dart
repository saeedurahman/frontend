import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/expenses/data/models/expense_payment_model.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'expense_category_id') required String expenseCategoryId,
    @JsonKey(name: 'supplier_id') String? supplierId,
    @JsonKey(name: 'expense_number') required String expenseNumber,
    String? description,
    @JsonKey(name: 'expense_date') required String expenseDate,
    required String amount,
    @JsonKey(name: 'tax_amount') @Default('0') String taxAmount,
    @Default([]) List<ExpensePaymentModel> payments,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
