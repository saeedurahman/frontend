// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_return_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleReturnPaymentModelImpl _$$SaleReturnPaymentModelImplFromJson(
  Map<String, dynamic> json,
) => _$SaleReturnPaymentModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  saleReturnId: json['sale_return_id'] as String,
  paymentMethod: json['payment_method'] as String,
  amount: json['amount'] as String,
  status: json['status'] as String,
  refundedAt: json['refunded_at'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$SaleReturnPaymentModelImplToJson(
  _$SaleReturnPaymentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'sale_return_id': instance.saleReturnId,
  'payment_method': instance.paymentMethod,
  'amount': instance.amount,
  'status': instance.status,
  'refunded_at': instance.refundedAt,
  'created_at': instance.createdAt,
};
