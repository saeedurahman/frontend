// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      productType: json['product_type'] as String,
      trackingType: json['tracking_type'] as String,
      isSellable: json['is_sellable'] as bool? ?? true,
      isPurchasable: json['is_purchasable'] as bool? ?? true,
      isActive: json['is_active'] as bool? ?? true,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      taxRateId: json['tax_rate_id'] as String?,
      taxRate: JsonNum.stringOrNull(json['tax_rate']),
      isTaxExempt: json['is_tax_exempt'] as bool? ?? false,
      trackExpiry: json['track_expiry'] as bool? ?? false,
      nameSecondary: json['name_secondary'] as String?,
      shelfLifeDays: JsonNum.intOrNull(json['shelf_life_days']),
      minStockLevel: JsonNum.stringOrNull(json['min_stock_level']),
      maxStockLevel: JsonNum.stringOrNull(json['max_stock_level']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      brand: json['brand'] == null
          ? null
          : BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      baseUnit: json['base_unit'] == null
          ? null
          : UnitModel.fromJson(json['base_unit'] as Map<String, dynamic>),
      variations:
          (json['variations'] as List<dynamic>?)
              ?.map((e) => VariationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      barcodes:
          (json['barcodes'] as List<dynamic>?)
              ?.map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'sku': instance.sku,
      'product_type': instance.productType,
      'tracking_type': instance.trackingType,
      'is_sellable': instance.isSellable,
      'is_purchasable': instance.isPurchasable,
      'is_active': instance.isActive,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'tax_rate_id': instance.taxRateId,
      'tax_rate': instance.taxRate,
      'is_tax_exempt': instance.isTaxExempt,
      'track_expiry': instance.trackExpiry,
      'name_secondary': instance.nameSecondary,
      'shelf_life_days': instance.shelfLifeDays,
      'min_stock_level': instance.minStockLevel,
      'max_stock_level': instance.maxStockLevel,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'category': instance.category,
      'brand': instance.brand,
      'base_unit': instance.baseUnit,
      'variations': instance.variations,
      'barcodes': instance.barcodes,
    };
