// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarcodeModelImpl _$$BarcodeModelImplFromJson(Map<String, dynamic> json) =>
    _$BarcodeModelImpl(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      barcode: json['barcode'] as String,
      barcodeType: json['barcode_type'] as String? ?? 'EAN13',
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$$BarcodeModelImplToJson(_$BarcodeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'variation_id': instance.variationId,
      'barcode': instance.barcode,
      'barcode_type': instance.barcodeType,
      'is_primary': instance.isPrimary,
    };
