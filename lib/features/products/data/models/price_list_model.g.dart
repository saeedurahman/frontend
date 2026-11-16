// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceListModel _$PriceListModelFromJson(Map<String, dynamic> json) =>
    _PriceListModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      listType: json['list_type'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      validFrom: json['valid_from'] as String?,
      validTo: json['valid_to'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      customerCount: (json['customer_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PriceListModelToJson(_PriceListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'list_type': instance.listType,
      'is_default': instance.isDefault,
      'valid_from': instance.validFrom,
      'valid_to': instance.validTo,
      'is_active': instance.isActive,
      'item_count': instance.itemCount,
      'customer_count': instance.customerCount,
    };

_PriceListItemModel _$PriceListItemModelFromJson(Map<String, dynamic> json) =>
    _PriceListItemModel(
      id: json['id'] as String,
      priceListId: json['price_list_id'] as String,
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      unitPrice: json['unit_price'] as String,
      minQty: json['min_qty'] as String?,
    );

Map<String, dynamic> _$PriceListItemModelToJson(_PriceListItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price_list_id': instance.priceListId,
      'product_id': instance.productId,
      'variation_id': instance.variationId,
      'unit_price': instance.unitPrice,
      'min_qty': instance.minQty,
    };

_ProductPriceModel _$ProductPriceModelFromJson(Map<String, dynamic> json) =>
    _ProductPriceModel(
      id: json['id'] as String?,
      unitPrice: json['unit_price'] as String?,
      minQty: json['min_qty'] as String?,
      priceListId: json['price_list_id'] as String?,
      variationId: json['variation_id'] as String?,
    );

Map<String, dynamic> _$ProductPriceModelToJson(_ProductPriceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit_price': instance.unitPrice,
      'min_qty': instance.minQty,
      'price_list_id': instance.priceListId,
      'variation_id': instance.variationId,
    };
