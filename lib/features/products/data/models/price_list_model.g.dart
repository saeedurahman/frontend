// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceListModelImpl _$$PriceListModelImplFromJson(Map<String, dynamic> json) =>
    _$PriceListModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      listType: json['list_type'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      validFrom: json['valid_from'] as String?,
      validTo: json['valid_to'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$PriceListModelImplToJson(
  _$PriceListModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'name': instance.name,
  'list_type': instance.listType,
  'is_default': instance.isDefault,
  'valid_from': instance.validFrom,
  'valid_to': instance.validTo,
  'is_active': instance.isActive,
};

_$PriceListItemModelImpl _$$PriceListItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$PriceListItemModelImpl(
  id: json['id'] as String,
  priceListId: json['price_list_id'] as String,
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  unitPrice: json['unit_price'] as String,
  minQty: json['min_qty'] as String?,
);

Map<String, dynamic> _$$PriceListItemModelImplToJson(
  _$PriceListItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'price_list_id': instance.priceListId,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'unit_price': instance.unitPrice,
  'min_qty': instance.minQty,
};

_$ProductPriceModelImpl _$$ProductPriceModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductPriceModelImpl(
  id: json['id'] as String?,
  unitPrice: json['unit_price'] as String?,
  minQty: json['min_qty'] as String?,
  priceListId: json['price_list_id'] as String?,
  variationId: json['variation_id'] as String?,
);

Map<String, dynamic> _$$ProductPriceModelImplToJson(
  _$ProductPriceModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'unit_price': instance.unitPrice,
  'min_qty': instance.minQty,
  'price_list_id': instance.priceListId,
  'variation_id': instance.variationId,
};
