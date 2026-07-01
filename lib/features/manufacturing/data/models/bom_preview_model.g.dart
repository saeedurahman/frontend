// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bom_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BomPreviewLineModelImpl _$$BomPreviewLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$BomPreviewLineModelImpl(
  ingredientProductId: json['ingredient_product_id'] as String,
  ingredientProductName: json['ingredient_product_name'] as String,
  ingredientVariationId: json['ingredient_variation_id'] as String?,
  qtyPerOutputUnit: json['qty_per_output_unit'] as String,
  totalQtyRequired: json['total_qty_required'] as String,
  wastagePct: json['wastage_pct'] as String? ?? '0',
);

Map<String, dynamic> _$$BomPreviewLineModelImplToJson(
  _$BomPreviewLineModelImpl instance,
) => <String, dynamic>{
  'ingredient_product_id': instance.ingredientProductId,
  'ingredient_product_name': instance.ingredientProductName,
  'ingredient_variation_id': instance.ingredientVariationId,
  'qty_per_output_unit': instance.qtyPerOutputUnit,
  'total_qty_required': instance.totalQtyRequired,
  'wastage_pct': instance.wastagePct,
};

_$BomPreviewModelImpl _$$BomPreviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$BomPreviewModelImpl(
  bomHeaderId: json['bom_header_id'] as String,
  productId: json['product_id'] as String,
  outputQty: json['output_qty'] as String,
  qtyToProduce: json['qty_to_produce'] as String,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => BomPreviewLineModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BomPreviewModelImplToJson(
  _$BomPreviewModelImpl instance,
) => <String, dynamic>{
  'bom_header_id': instance.bomHeaderId,
  'product_id': instance.productId,
  'output_qty': instance.outputQty,
  'qty_to_produce': instance.qtyToProduce,
  'lines': instance.lines,
};
