// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpensePaymentModelImpl _$$ExpensePaymentModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpensePaymentModelImpl(
  id: json['id'] as String,
  expenseId: json['expense_id'] as String,
  paymentMethod: json['payment_method'] as String,
  amount: json['amount'] as String,
  status: json['status'] as String? ?? 'completed',
  referenceNo: json['reference_no'] as String?,
  paidAt: json['paid_at'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$ExpensePaymentModelImplToJson(
  _$ExpensePaymentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'expense_id': instance.expenseId,
  'payment_method': instance.paymentMethod,
  'amount': instance.amount,
  'status': instance.status,
  'reference_no': instance.referenceNo,
  'paid_at': instance.paidAt,
  'created_at': instance.createdAt,
};
