import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@freezed
class StockBalanceModel with _$StockBalanceModel {
  const factory StockBalanceModel({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'current_qty') required String currentQty,
    @JsonKey(name: 'last_movement_at') String? lastMovementAt,
  }) = _StockBalanceModel;

  factory StockBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$StockBalanceModelFromJson(json);
}

@freezed
class StockMovementModel with _$StockMovementModel {
  const factory StockMovementModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'movement_type') required String movementType,
    required String qty,
    @JsonKey(name: 'cost_per_unit') required String costPerUnit,
    @JsonKey(name: 'reference_type') required String referenceType,
    @JsonKey(name: 'reference_id') required String referenceId,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    String? notes,
    @JsonKey(name: 'movement_at') required String movementAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _StockMovementModel;

  factory StockMovementModel.fromJson(Map<String, dynamic> json) =>
      _$StockMovementModelFromJson(json);
}

@freezed
class PaginatedStockMovementsModel with _$PaginatedStockMovementsModel {
  const factory PaginatedStockMovementsModel({
    required int total,
    required int skip,
    required int limit,
    required List<StockMovementModel> items,
  }) = _PaginatedStockMovementsModel;

  factory PaginatedStockMovementsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedStockMovementsModelFromJson(json);
}

@freezed
class StockAdjustmentLineModel with _$StockAdjustmentLineModel {
  const factory StockAdjustmentLineModel({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_delta') required String qtyDelta,
    @JsonKey(name: 'cost_per_unit') required String costPerUnit,
    String? notes,
  }) = _StockAdjustmentLineModel;

  factory StockAdjustmentLineModel.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentLineModelFromJson(json);
}

@freezed
class StockAdjustmentModel with _$StockAdjustmentModel {
  const factory StockAdjustmentModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'adjustment_number') required String adjustmentNumber,
    required String reason,
    @JsonKey(name: 'adjusted_at') required String adjustedAt,
    String? notes,
    @Default([]) List<StockAdjustmentLineModel> lines,
  }) = _StockAdjustmentModel;

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentModelFromJson(json);
}

/// Backend AdjustmentReasonEnum values.
abstract final class AdjustmentReasons {
  static const countCorrection = 'count_correction';
  static const damage = 'damage';
  static const theft = 'theft';
  static const expiry = 'expiry';
  static const openingBalance = 'opening_balance';
  static const other = 'other';
}
