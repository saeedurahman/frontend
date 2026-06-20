// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VariationModelImpl _$$VariationModelImplFromJson(Map<String, dynamic> json) =>
    _$VariationModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      unitId: json['unit_id'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      weightGrams: json['weight_grams'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      barcodes:
          (json['barcodes'] as List<dynamic>?)
              ?.map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      unit: json['unit'] == null
          ? null
          : UnitModel.fromJson(json['unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VariationModelImplToJson(
  _$VariationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'product_id': instance.productId,
  'name': instance.name,
  'sku': instance.sku,
  'unit_id': instance.unitId,
  'is_default': instance.isDefault,
  'is_active': instance.isActive,
  'weight_grams': instance.weightGrams,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'barcodes': instance.barcodes,
  'unit': instance.unit,
};
