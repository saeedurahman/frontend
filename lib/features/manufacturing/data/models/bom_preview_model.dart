import 'package:freezed_annotation/freezed_annotation.dart';

part 'bom_preview_model.freezed.dart';
part 'bom_preview_model.g.dart';

@freezed
class BomPreviewLineModel with _$BomPreviewLineModel {
  const factory BomPreviewLineModel({
    @JsonKey(name: 'ingredient_product_id') required String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name') required String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,
    @JsonKey(name: 'qty_per_output_unit') required String qtyPerOutputUnit,
    @JsonKey(name: 'total_qty_required') required String totalQtyRequired,
    @JsonKey(name: 'wastage_pct') @Default('0') String wastagePct,
  }) = _BomPreviewLineModel;

  factory BomPreviewLineModel.fromJson(Map<String, dynamic> json) =>
      _$BomPreviewLineModelFromJson(json);
}

@freezed
class BomPreviewModel with _$BomPreviewModel {
  const factory BomPreviewModel({
    @JsonKey(name: 'bom_header_id') required String bomHeaderId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'output_qty') required String outputQty,
    @JsonKey(name: 'qty_to_produce') required String qtyToProduce,
    @Default([]) List<BomPreviewLineModel> lines,
  }) = _BomPreviewModel;

  factory BomPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$BomPreviewModelFromJson(json);
}
