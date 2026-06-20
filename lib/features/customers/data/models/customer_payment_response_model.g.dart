// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_payment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerPaymentResponseModelImpl _$$CustomerPaymentResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerPaymentResponseModelImpl(
  ledgerEntryId: json['ledger_entry_id'] as String,
  customerId: json['customer_id'] as String,
  amount: json['amount'] as String,
  newBalance: json['new_balance'] as String,
);

Map<String, dynamic> _$$CustomerPaymentResponseModelImplToJson(
  _$CustomerPaymentResponseModelImpl instance,
) => <String, dynamic>{
  'ledger_entry_id': instance.ledgerEntryId,
  'customer_id': instance.customerId,
  'amount': instance.amount,
  'new_balance': instance.newBalance,
};
