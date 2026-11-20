import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_list_item_model.freezed.dart';
part 'product_list_item_model.g.dart';

@freezed
abstract class ProductListItemModel with _$ProductListItemModel {
  const factory ProductListItemModel({
    required String id,
    @JsonKey(name: 'business_id') @Default('') String businessId,
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
    @JsonKey(name: 'tax_rate_id') String? taxRateId,
    @JsonKey(name: 'is_tax_exempt') @Default(false) bool isTaxExempt,
    @JsonKey(name: 'track_expiry') @Default(false) bool trackExpiry,
    @JsonKey(name: 'name_secondary') String? nameSecondary,
    // Set by the server (and the local copy): what the product still lacks to
    // sell well. `missing` holds `category`, `image` and/or `price`.
    @JsonKey(name: 'needs_attention') @Default(false) bool needsAttention,
    @Default(<String>[]) List<String> missing,
    String? categoryName,
    String? brandName,
  }) = _ProductListItemModel;

  factory ProductListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListItemModelFromJson(json);
}
