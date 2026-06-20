// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_payment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpensePaymentResponseModelImpl _$$ExpensePaymentResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpensePaymentResponseModelImpl(
  id: json['id'] as String,
  expenseId: json['expense_id'] as String,
  amount: json['amount'] as String,
  paymentMethod: json['payment_method'] as String,
  referenceNo: json['reference_no'] as String?,
  paidAt: json['paid_at'] as String?,
  totalPaid: json['total_paid'] as String,
  remainingBalance: json['remaining_balance'] as String,
);

Map<String, dynamic> _$$ExpensePaymentResponseModelImplToJson(
  _$ExpensePaymentResponseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'expense_id': instance.expenseId,
  'amount': instance.amount,
  'payment_method': instance.paymentMethod,
  'reference_no': instance.referenceNo,
  'paid_at': instance.paidAt,
  'total_paid': instance.totalPaid,
  'remaining_balance': instance.remainingBalance,
};
