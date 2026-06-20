// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseListItemModelImpl _$$ExpenseListItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpenseListItemModelImpl(
  id: json['id'] as String,
  branchId: json['branch_id'] as String,
  expenseCategoryId: json['expense_category_id'] as String,
  supplierId: json['supplier_id'] as String?,
  expenseNumber: json['expense_number'] as String,
  description: json['description'] as String?,
  expenseDate: json['expense_date'] as String,
  amount: json['amount'] as String,
  taxAmount: json['tax_amount'] as String? ?? '0',
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$ExpenseListItemModelImplToJson(
  _$ExpenseListItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'branch_id': instance.branchId,
  'expense_category_id': instance.expenseCategoryId,
  'supplier_id': instance.supplierId,
  'expense_number': instance.expenseNumber,
  'description': instance.description,
  'expense_date': instance.expenseDate,
  'amount': instance.amount,
  'tax_amount': instance.taxAmount,
  'created_at': instance.createdAt,
};
