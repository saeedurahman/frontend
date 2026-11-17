import 'package:frantend/core/utils/json_num.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    String? sku,
    @JsonKey(name: 'product_type') required String productType,
    @JsonKey(name: 'tracking_type') required String trackingType,
    @JsonKey(name: 'is_sellable') @Default(true) bool isSellable,
    @JsonKey(name: 'is_purchasable') @Default(true) bool isPurchasable,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'tax_rate_id') String? taxRateId,
    @JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull) String? taxRate,
    @JsonKey(name: 'is_tax_exempt') @Default(false) bool isTaxExempt,
    @JsonKey(name: 'track_expiry') @Default(false) bool trackExpiry,
    @JsonKey(name: 'name_secondary') String? nameSecondary,
    @JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull) int? shelfLifeDays,
    @JsonKey(name: 'min_stock_level', fromJson: JsonNum.stringOrNull) String? minStockLevel,
    @JsonKey(name: 'max_stock_level', fromJson: JsonNum.stringOrNull) String? maxStockLevel,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    CategoryModel? category,
    BrandModel? brand,
    @JsonKey(name: 'base_unit') UnitModel? baseUnit,
    @Default([]) List<VariationModel> variations,
    @Default([]) List<BarcodeModel> barcodes,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
