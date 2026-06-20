import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
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
    @JsonKey(name: 'shelf_life_days') int? shelfLifeDays,
    @JsonKey(name: 'min_stock_level') String? minStockLevel,
    @JsonKey(name: 'max_stock_level') String? maxStockLevel,
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
