// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockBalanceModelImpl _$$StockBalanceModelImplFromJson(
  Map<String, dynamic> json,
) => _$StockBalanceModelImpl(
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  branchId: json['branch_id'] as String,
  currentQty: json['current_qty'] as String,
  lastMovementAt: json['last_movement_at'] as String?,
);

Map<String, dynamic> _$$StockBalanceModelImplToJson(
  _$StockBalanceModelImpl instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'branch_id': instance.branchId,
  'current_qty': instance.currentQty,
  'last_movement_at': instance.lastMovementAt,
};

_$StockMovementModelImpl _$$StockMovementModelImplFromJson(
  Map<String, dynamic> json,
) => _$StockMovementModelImpl(
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

Map<String, dynamic> _$$StockMovementModelImplToJson(
  _$StockMovementModelImpl instance,
) => <String, dynamic>{
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

_$PaginatedStockMovementsModelImpl _$$PaginatedStockMovementsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedStockMovementsModelImpl(
  total: (json['total'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => StockMovementModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PaginatedStockMovementsModelImplToJson(
  _$PaginatedStockMovementsModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};

_$StockAdjustmentLineModelImpl _$$StockAdjustmentLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$StockAdjustmentLineModelImpl(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  qtyDelta: json['qty_delta'] as String,
  costPerUnit: json['cost_per_unit'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$StockAdjustmentLineModelImplToJson(
  _$StockAdjustmentLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'qty_delta': instance.qtyDelta,
  'cost_per_unit': instance.costPerUnit,
  'notes': instance.notes,
};

_$StockAdjustmentModelImpl _$$StockAdjustmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$StockAdjustmentModelImpl(
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

Map<String, dynamic> _$$StockAdjustmentModelImplToJson(
  _$StockAdjustmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'branch_id': instance.branchId,
  'adjustment_number': instance.adjustmentNumber,
  'reason': instance.reason,
  'adjusted_at': instance.adjustedAt,
  'notes': instance.notes,
  'lines': instance.lines,
};
