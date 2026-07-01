// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductionOrderBomSummaryModelImpl
_$$ProductionOrderBomSummaryModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductionOrderBomSummaryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      variationId: json['variation_id'] as String?,
      outputQty: json['output_qty'] as String,
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$ProductionOrderBomSummaryModelImplToJson(
  _$ProductionOrderBomSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'variation_id': instance.variationId,
  'output_qty': instance.outputQty,
  'version': instance.version,
};

_$ProductionLineModelImpl _$$ProductionLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductionLineModelImpl(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  variationId: json['variation_id'] as String?,
  qtyConsumed: json['qty_consumed'] as String,
  costPerUnit: json['cost_per_unit'] as String,
);

Map<String, dynamic> _$$ProductionLineModelImplToJson(
  _$ProductionLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'variation_id': instance.variationId,
  'qty_consumed': instance.qtyConsumed,
  'cost_per_unit': instance.costPerUnit,
};

_$ProductionOrderModelImpl _$$ProductionOrderModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductionOrderModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  bomHeaderId: json['bom_header_id'] as String,
  productionNumber: json['production_number'] as String,
  status: json['status'] as String,
  qtyToProduce: json['qty_to_produce'] as String,
  qtyProduced: json['qty_produced'] as String? ?? '0',
  startedAt: json['started_at'] as String?,
  completedAt: json['completed_at'] as String?,
  notes: json['notes'] as String?,
  bom: ProductionOrderBomSummaryModel.fromJson(
    json['bom'] as Map<String, dynamic>,
  ),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => ProductionLineModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductionOrderModelImplToJson(
  _$ProductionOrderModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'bom_header_id': instance.bomHeaderId,
  'production_number': instance.productionNumber,
  'status': instance.status,
  'qty_to_produce': instance.qtyToProduce,
  'qty_produced': instance.qtyProduced,
  'started_at': instance.startedAt,
  'completed_at': instance.completedAt,
  'notes': instance.notes,
  'bom': instance.bom,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
  'lines': instance.lines,
};
