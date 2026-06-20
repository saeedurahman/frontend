import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';

part 'variation_model.freezed.dart';
part 'variation_model.g.dart';

@freezed
class VariationModel with _$VariationModel {
  const factory VariationModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'product_id') required String productId,
    required String name,
    String? sku,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'weight_grams') String? weightGrams,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @Default([]) List<BarcodeModel> barcodes,
    UnitModel? unit,
  }) = _VariationModel;

  factory VariationModel.fromJson(Map<String, dynamic> json) =>
      _$VariationModelFromJson(json);
}
