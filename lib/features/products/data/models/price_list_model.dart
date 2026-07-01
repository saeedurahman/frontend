import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_list_model.freezed.dart';
part 'price_list_model.g.dart';

@freezed
class PriceListModel with _$PriceListModel {
  const factory PriceListModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    @JsonKey(name: 'list_type') required String listType,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_to') String? validTo,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _PriceListModel;

  factory PriceListModel.fromJson(Map<String, dynamic> json) =>
      _$PriceListModelFromJson(json);
}

@freezed
class PriceListItemModel with _$PriceListItemModel {
  const factory PriceListItemModel({
    required String id,
    @JsonKey(name: 'price_list_id') required String priceListId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'min_qty') String? minQty,
  }) = _PriceListItemModel;

  factory PriceListItemModel.fromJson(Map<String, dynamic> json) =>
      _$PriceListItemModelFromJson(json);
}

@freezed
class ProductPriceModel with _$ProductPriceModel {
  const factory ProductPriceModel({
    String? id,
    @JsonKey(name: 'unit_price') String? unitPrice,
    @JsonKey(name: 'min_qty') String? minQty,
    @JsonKey(name: 'price_list_id') String? priceListId,
    @JsonKey(name: 'variation_id') String? variationId,
  }) = _ProductPriceModel;

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPriceModelFromJson(json);
}
