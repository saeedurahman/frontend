import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_list_item_model.freezed.dart';
part 'product_list_item_model.g.dart';

@freezed
class ProductListItemModel with _$ProductListItemModel {
  const factory ProductListItemModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    String? sku,
    @JsonKey(name: 'product_type') required String productType,
    @JsonKey(name: 'tracking_type') required String trackingType,
    @JsonKey(name: 'is_sellable') @Default(true) bool isSellable,
    @JsonKey(name: 'is_purchasable') @Default(true) bool isPurchasable,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? categoryName,
    String? brandName,
  }) = _ProductListItemModel;

  factory ProductListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListItemModelFromJson(json);
}
