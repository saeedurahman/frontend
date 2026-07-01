import 'package:freezed_annotation/freezed_annotation.dart';

part 'bom_line_model.freezed.dart';
part 'bom_line_model.g.dart';

@freezed
class BomLineModel with _$BomLineModel {
  const factory BomLineModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'bom_header_id') required String bomHeaderId,
    @JsonKey(name: 'ingredient_product_id') required String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name') required String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,
    @JsonKey(name: 'qty_required') required String qtyRequired,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'wastage_pct') @Default('0') String wastagePct,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _BomLineModel;

  factory BomLineModel.fromJson(Map<String, dynamic> json) =>
      _$BomLineModelFromJson(json);
}
