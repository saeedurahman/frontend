// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bom_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BomLineModelImpl _$$BomLineModelImplFromJson(Map<String, dynamic> json) =>
    _$BomLineModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      bomHeaderId: json['bom_header_id'] as String,
      ingredientProductId: json['ingredient_product_id'] as String,
      ingredientProductName: json['ingredient_product_name'] as String,
      ingredientVariationId: json['ingredient_variation_id'] as String?,
      qtyRequired: json['qty_required'] as String,
      unitId: json['unit_id'] as String?,
      wastagePct: json['wastage_pct'] as String? ?? '0',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BomLineModelImplToJson(_$BomLineModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'bom_header_id': instance.bomHeaderId,
      'ingredient_product_id': instance.ingredientProductId,
      'ingredient_product_name': instance.ingredientProductName,
      'ingredient_variation_id': instance.ingredientVariationId,
      'qty_required': instance.qtyRequired,
      'unit_id': instance.unitId,
      'wastage_pct': instance.wastagePct,
      'sort_order': instance.sortOrder,
    };
