// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductListItemModelImpl _$$ProductListItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductListItemModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  name: json['name'] as String,
  sku: json['sku'] as String?,
  productType: json['product_type'] as String,
  trackingType: json['tracking_type'] as String,
  isSellable: json['is_sellable'] as bool? ?? true,
  isPurchasable: json['is_purchasable'] as bool? ?? true,
  isActive: json['is_active'] as bool? ?? true,
  categoryId: json['category_id'] as String?,
  brandId: json['brand_id'] as String?,
  imageUrl: json['image_url'] as String?,
  categoryName: json['categoryName'] as String?,
  brandName: json['brandName'] as String?,
);

Map<String, dynamic> _$$ProductListItemModelImplToJson(
  _$ProductListItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'name': instance.name,
  'sku': instance.sku,
  'product_type': instance.productType,
  'tracking_type': instance.trackingType,
  'is_sellable': instance.isSellable,
  'is_purchasable': instance.isPurchasable,
  'is_active': instance.isActive,
  'category_id': instance.categoryId,
  'brand_id': instance.brandId,
  'image_url': instance.imageUrl,
  'categoryName': instance.categoryName,
  'brandName': instance.brandName,
};
