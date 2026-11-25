// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_payment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerPaymentResponseModel _$CustomerPaymentResponseModelFromJson(
  Map<String, dynamic> json,
) => _CustomerPaymentResponseModel(
  ledgerEntryId: json['ledger_entry_id'] as String,
  customerId: json['customer_id'] as String,
  amount: json['amount'] as String,
  newBalance: json['new_balance'] as String,
  previousBalance: json['previous_balance'] as String?,
  paymentSource: json['payment_source'] as String?,
  registerShiftId: json['register_shift_id'] as String?,
  registerTransactionId: json['register_transaction_id'] as String?,
);

Map<String, dynamic> _$CustomerPaymentResponseModelToJson(
  _CustomerPaymentResponseModel instance,
) => <String, dynamic>{
  'ledger_entry_id': instance.ledgerEntryId,
  'customer_id': instance.customerId,
  'amount': instance.amount,
  'new_balance': instance.newBalance,
  'previous_balance': instance.previousBalance,
  'payment_source': instance.paymentSource,
  'register_shift_id': instance.registerShiftId,
  'register_transaction_id': instance.registerTransactionId,
};
