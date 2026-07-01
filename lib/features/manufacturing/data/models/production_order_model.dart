import 'package:freezed_annotation/freezed_annotation.dart';

part 'production_order_model.freezed.dart';
part 'production_order_model.g.dart';

@freezed
class ProductionOrderBomSummaryModel with _$ProductionOrderBomSummaryModel {
  const factory ProductionOrderBomSummaryModel({
    required String id,
    required String name,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'output_qty') required String outputQty,
    @Default(1) int version,
  }) = _ProductionOrderBomSummaryModel;

  factory ProductionOrderBomSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionOrderBomSummaryModelFromJson(json);
}

@freezed
class ProductionLineModel with _$ProductionLineModel {
  const factory ProductionLineModel({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_consumed') required String qtyConsumed,
    @JsonKey(name: 'cost_per_unit') required String costPerUnit,
  }) = _ProductionLineModel;

  factory ProductionLineModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionLineModelFromJson(json);
}

@freezed
class ProductionOrderModel with _$ProductionOrderModel {
  const factory ProductionOrderModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'bom_header_id') required String bomHeaderId,
    @JsonKey(name: 'production_number') required String productionNumber,
    required String status,
    @JsonKey(name: 'qty_to_produce') required String qtyToProduce,
    @JsonKey(name: 'qty_produced') @Default('0') String qtyProduced,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'completed_at') String? completedAt,
    String? notes,
    required ProductionOrderBomSummaryModel bom,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @Default([]) List<ProductionLineModel> lines,
  }) = _ProductionOrderModel;

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionOrderModelFromJson(json);
}

/// Production order lifecycle statuses from backend.
abstract final class ProductionOrderStatus {
  static const draft = 'draft';
  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
}
