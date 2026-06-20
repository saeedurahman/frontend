// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_return_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleReturnResponseModelImpl _$$SaleReturnResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$SaleReturnResponseModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  saleId: json['sale_id'] as String?,
  customerId: json['customer_id'] as String?,
  returnNumber: json['return_number'] as String,
  returnedAt: json['returned_at'] as String?,
  reason: json['reason'] as String?,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => SaleReturnLineModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map(
            (e) => SaleReturnPaymentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$SaleReturnResponseModelImplToJson(
  _$SaleReturnResponseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'sale_id': instance.saleId,
  'customer_id': instance.customerId,
  'return_number': instance.returnNumber,
  'returned_at': instance.returnedAt,
  'reason': instance.reason,
  'lines': instance.lines,
  'payments': instance.payments,
  'created_at': instance.createdAt,
};
