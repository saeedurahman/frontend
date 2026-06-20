import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_list_item_model.freezed.dart';
part 'expense_list_item_model.g.dart';

@freezed
class ExpenseListItemModel with _$ExpenseListItemModel {
  const factory ExpenseListItemModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'expense_category_id') required String expenseCategoryId,
    @JsonKey(name: 'supplier_id') String? supplierId,
    @JsonKey(name: 'expense_number') required String expenseNumber,
    String? description,
    @JsonKey(name: 'expense_date') required String expenseDate,
    required String amount,
    @JsonKey(name: 'tax_amount') @Default('0') String taxAmount,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ExpenseListItemModel;

  factory ExpenseListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseListItemModelFromJson(json);
}
