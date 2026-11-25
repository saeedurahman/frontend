// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerBalanceModel _$CustomerBalanceModelFromJson(
  Map<String, dynamic> json,
) => _CustomerBalanceModel(
  customerId: json['customer_id'] as String,
  balance: json['balance'] as String,
  balanceOwed: json['balance_owed'] as String?,
  creditLimit: json['credit_limit'] as String?,
  creditAvailable: json['credit_available'] as String?,
);

Map<String, dynamic> _$CustomerBalanceModelToJson(
  _CustomerBalanceModel instance,
) => <String, dynamic>{
  'customer_id': instance.customerId,
  'balance': instance.balance,
  'balance_owed': instance.balanceOwed,
  'credit_limit': instance.creditLimit,
  'credit_available': instance.creditAvailable,
};
