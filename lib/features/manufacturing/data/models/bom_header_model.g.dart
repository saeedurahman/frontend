// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bom_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BomHeaderModelImpl _$$BomHeaderModelImplFromJson(Map<String, dynamic> json) =>
    _$BomHeaderModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      variationId: json['variation_id'] as String?,
      name: json['name'] as String,
      outputQty: json['output_qty'] as String,
      isActive: json['is_active'] as bool? ?? true,
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map((e) => BomLineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BomHeaderModelImplToJson(
  _$BomHeaderModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'variation_id': instance.variationId,
  'name': instance.name,
  'output_qty': instance.outputQty,
  'is_active': instance.isActive,
  'version': instance.version,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
  'lines': instance.lines,
};
