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
);

Map<String, dynamic> _$CustomerBalanceModelToJson(
  _CustomerBalanceModel instance,
) => <String, dynamic>{
  'customer_id': instance.customerId,
  'balance': instance.balance,
};
