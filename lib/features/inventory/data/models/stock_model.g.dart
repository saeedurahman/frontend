// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockBalanceModel _$StockBalanceModelFromJson(Map<String, dynamic> json) =>
    _StockBalanceModel(
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      branchId: json['branch_id'] as String,
      currentQty: json['current_qty'] as String,
      lastMovementAt: json['last_movement_at'] as String?,
    );

Map<String, dynamic> _$StockBalanceModelToJson(_StockBalanceModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'variation_id': instance.variationId,
      'branch_id': instance.branchId,
      'current_qty': instance.currentQty,
      'last_movement_at': instance.lastMovementAt,
    };

_StockMovementModel _$StockMovementModelFromJson(Map<String, dynamic> json) =>
    _StockMovementModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      movementType: json['movement_type'] as String,
      qty: json['qty'] as String,
      costPerUnit: json['cost_per_unit'] as String,
      referenceType: json['reference_type'] as String,
      referenceId: json['reference_id'] as String,
      batchNumber: json['batch_number'] as String?,
      expiryDate: json['expiry_date'] as String?,
      notes: json['notes'] as String?,
      movementAt: json['movement_at'] as String,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$StockMovementModelToJson(_StockMovementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch_id': instance.branchId,
      'product_id': instance.productId,
      'variation_id': instance.variationId,
      'movement_type': instance.movementType,
      'qty': instance.qty,
      'cost_per_unit': instance.costPerUnit,
      'reference_type': instance.referenceType,
      'reference_id': instance.referenceId,
      'batch_number': instance.batchNumber,
      'expiry_date': instance.expiryDate,
      'notes': instance.notes,
      'movement_at': instance.movementAt,
      'created_at': instance.createdAt,
    };

_PaginatedStockMovementsModel _$PaginatedStockMovementsModelFromJson(
  Map<String, dynamic> json,
) => _PaginatedStockMovementsModel(
  total: JsonNum.intOr(json['total']),
  skip: JsonNum.intOr(json['skip']),
  limit: JsonNum.intOr(json['limit']),
  items: (json['items'] as List<dynamic>)
      .map((e) => StockMovementModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PaginatedStockMovementsModelToJson(
  _PaginatedStockMovementsModel instance,
) => <String, dynamic>{
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};

_StockAdjustmentLineModel _$StockAdjustmentLineModelFromJson(
  Map<String, dynamic> json,
) => _StockAdjustmentLineModel(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  qtyDelta: json['qty_delta'] as String,
  costPerUnit: json['cost_per_unit'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$StockAdjustmentLineModelToJson(
  _StockAdjustmentLineModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'qty_delta': instance.qtyDelta,
  'cost_per_unit': instance.costPerUnit,
  'notes': instance.notes,
};

_StockAdjustmentModel _$StockAdjustmentModelFromJson(
  Map<String, dynamic> json,
) => _StockAdjustmentModel(
  id: json['id'] as String,
  branchId: json['branch_id'] as String,
  adjustmentNumber: json['adjustment_number'] as String,
  reason: json['reason'] as String,
  adjustedAt: json['adjusted_at'] as String,
  notes: json['notes'] as String?,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map(
            (e) => StockAdjustmentLineModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$StockAdjustmentModelToJson(
  _StockAdjustmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'branch_id': instance.branchId,
  'adjustment_number': instance.adjustmentNumber,
  'reason': instance.reason,
  'adjusted_at': instance.adjustedAt,
  'notes': instance.notes,
  'lines': instance.lines,
};
