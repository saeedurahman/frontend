// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name; String? get sku;@JsonKey(name: 'product_type') String get productType;@JsonKey(name: 'tracking_type') String get trackingType;@JsonKey(name: 'is_sellable') bool get isSellable;@JsonKey(name: 'is_purchasable') bool get isPurchasable;@JsonKey(name: 'is_active') bool get isActive; String? get description;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'tax_rate_id') String? get taxRateId;@JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull) String? get taxRate;@JsonKey(name: 'is_tax_exempt') bool get isTaxExempt;@JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull) int? get shelfLifeDays;@JsonKey(name: 'min_stock_level') String? get minStockLevel;@JsonKey(name: 'max_stock_level') String? get maxStockLevel;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; CategoryModel? get category; BrandModel? get brand;@JsonKey(name: 'base_unit') UnitModel? get baseUnit; List<VariationModel> get variations; List<BarcodeModel> get barcodes;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.productType, _this.productType) || other.productType == _this.productType)&&(identical(other.trackingType, _this.trackingType) || other.trackingType == _this.trackingType)&&(identical(other.isSellable, _this.isSellable) || other.isSellable == _this.isSellable)&&(identical(other.isPurchasable, _this.isPurchasable) || other.isPurchasable == _this.isPurchasable)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.taxRateId, _this.taxRateId) || other.taxRateId == _this.taxRateId)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.isTaxExempt, _this.isTaxExempt) || other.isTaxExempt == _this.isTaxExempt)&&(identical(other.shelfLifeDays, _this.shelfLifeDays) || other.shelfLifeDays == _this.shelfLifeDays)&&(identical(other.minStockLevel, _this.minStockLevel) || other.minStockLevel == _this.minStockLevel)&&(identical(other.maxStockLevel, _this.maxStockLevel) || other.maxStockLevel == _this.maxStockLevel)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.baseUnit, _this.baseUnit) || other.baseUnit == _this.baseUnit)&&const DeepCollectionEquality().equals(other.variations, _this.variations)&&const DeepCollectionEquality().equals(other.barcodes, _this.barcodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductModel;
  return Object.hashAll([runtimeType,_this.id,_this.businessId,_this.name,_this.sku,_this.productType,_this.trackingType,_this.isSellable,_this.isPurchasable,_this.isActive,_this.description,_this.imageUrl,_this.taxRateId,_this.taxRate,_this.isTaxExempt,_this.shelfLifeDays,_this.minStockLevel,_this.maxStockLevel,_this.createdAt,_this.updatedAt,_this.category,_this.brand,_this.baseUnit,const DeepCollectionEquality().hash(_this.variations),const DeepCollectionEquality().hash(_this.barcodes)]);
}

@override
String toString() {
  final _this = this as ProductModel;
  return 'ProductModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, sku: ${_this.sku}, productType: ${_this.productType}, trackingType: ${_this.trackingType}, isSellable: ${_this.isSellable}, isPurchasable: ${_this.isPurchasable}, isActive: ${_this.isActive}, description: ${_this.description}, imageUrl: ${_this.imageUrl}, taxRateId: ${_this.taxRateId}, taxRate: ${_this.taxRate}, isTaxExempt: ${_this.isTaxExempt}, shelfLifeDays: ${_this.shelfLifeDays}, minStockLevel: ${_this.minStockLevel}, maxStockLevel: ${_this.maxStockLevel}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, category: ${_this.category}, brand: ${_this.brand}, baseUnit: ${_this.baseUnit}, variations: ${_this.variations}, barcodes: ${_this.barcodes})';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String? sku,@JsonKey(name: 'product_type') String productType,@JsonKey(name: 'tracking_type') String trackingType,@JsonKey(name: 'is_sellable') bool isSellable,@JsonKey(name: 'is_purchasable') bool isPurchasable,@JsonKey(name: 'is_active') bool isActive, String? description,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'tax_rate_id') String? taxRateId,@JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull) String? taxRate,@JsonKey(name: 'is_tax_exempt') bool isTaxExempt,@JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull) int? shelfLifeDays,@JsonKey(name: 'min_stock_level') String? minStockLevel,@JsonKey(name: 'max_stock_level') String? maxStockLevel,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, CategoryModel? category, BrandModel? brand,@JsonKey(name: 'base_unit') UnitModel? baseUnit, List<VariationModel> variations, List<BarcodeModel> barcodes
});


$CategoryModelCopyWith<$Res>? get category;$BrandModelCopyWith<$Res>? get brand;$UnitModelCopyWith<$Res>? get baseUnit;

}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? sku = freezed,Object? productType = null,Object? trackingType = null,Object? isSellable = null,Object? isPurchasable = null,Object? isActive = null,Object? description = freezed,Object? imageUrl = freezed,Object? taxRateId = freezed,Object? taxRate = freezed,Object? isTaxExempt = null,Object? shelfLifeDays = freezed,Object? minStockLevel = freezed,Object? maxStockLevel = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? category = freezed,Object? brand = freezed,Object? baseUnit = freezed,Object? variations = null,Object? barcodes = null,}) {
  return _then(ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as String,isSellable: null == isSellable ? _self.isSellable : isSellable // ignore: cast_nullable_to_non_nullable
as bool,isPurchasable: null == isPurchasable ? _self.isPurchasable : isPurchasable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,taxRateId: freezed == taxRateId ? _self.taxRateId : taxRateId // ignore: cast_nullable_to_non_nullable
as String?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String?,isTaxExempt: null == isTaxExempt ? _self.isTaxExempt : isTaxExempt // ignore: cast_nullable_to_non_nullable
as bool,shelfLifeDays: freezed == shelfLifeDays ? _self.shelfLifeDays : shelfLifeDays // ignore: cast_nullable_to_non_nullable
as int?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as String?,maxStockLevel: freezed == maxStockLevel ? _self.maxStockLevel : maxStockLevel // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandModel?,baseUnit: freezed == baseUnit ? _self.baseUnit : baseUnit // ignore: cast_nullable_to_non_nullable
as UnitModel?,variations: null == variations ? _self.variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,barcodes: null == barcodes ? _self.barcodes : barcodes // ignore: cast_nullable_to_non_nullable
as List<BarcodeModel>,
  ));
}
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandModelCopyWith<$Res>? get brand {
    if (_self.brand == null) {
    return null;
  }

  return $BrandModelCopyWith<$Res>(_self.brand!, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitModelCopyWith<$Res>? get baseUnit {
    if (_self.baseUnit == null) {
    return null;
  }

  return $UnitModelCopyWith<$Res>(_self.baseUnit!, (value) {
    return _then(_self.copyWith(baseUnit: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? sku, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'tracking_type')  String trackingType, @JsonKey(name: 'is_sellable')  bool isSellable, @JsonKey(name: 'is_purchasable')  bool isPurchasable, @JsonKey(name: 'is_active')  bool isActive,  String? description, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'tax_rate_id')  String? taxRateId, @JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull)  String? taxRate, @JsonKey(name: 'is_tax_exempt')  bool isTaxExempt, @JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull)  int? shelfLifeDays, @JsonKey(name: 'min_stock_level')  String? minStockLevel, @JsonKey(name: 'max_stock_level')  String? maxStockLevel, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  CategoryModel? category,  BrandModel? brand, @JsonKey(name: 'base_unit')  UnitModel? baseUnit,  List<VariationModel> variations,  List<BarcodeModel> barcodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.sku,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.description,_that.imageUrl,_that.taxRateId,_that.taxRate,_that.isTaxExempt,_that.shelfLifeDays,_that.minStockLevel,_that.maxStockLevel,_that.createdAt,_that.updatedAt,_that.category,_that.brand,_that.baseUnit,_that.variations,_that.barcodes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? sku, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'tracking_type')  String trackingType, @JsonKey(name: 'is_sellable')  bool isSellable, @JsonKey(name: 'is_purchasable')  bool isPurchasable, @JsonKey(name: 'is_active')  bool isActive,  String? description, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'tax_rate_id')  String? taxRateId, @JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull)  String? taxRate, @JsonKey(name: 'is_tax_exempt')  bool isTaxExempt, @JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull)  int? shelfLifeDays, @JsonKey(name: 'min_stock_level')  String? minStockLevel, @JsonKey(name: 'max_stock_level')  String? maxStockLevel, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  CategoryModel? category,  BrandModel? brand, @JsonKey(name: 'base_unit')  UnitModel? baseUnit,  List<VariationModel> variations,  List<BarcodeModel> barcodes)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.businessId,_that.name,_that.sku,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.description,_that.imageUrl,_that.taxRateId,_that.taxRate,_that.isTaxExempt,_that.shelfLifeDays,_that.minStockLevel,_that.maxStockLevel,_that.createdAt,_that.updatedAt,_that.category,_that.brand,_that.baseUnit,_that.variations,_that.barcodes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? sku, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'tracking_type')  String trackingType, @JsonKey(name: 'is_sellable')  bool isSellable, @JsonKey(name: 'is_purchasable')  bool isPurchasable, @JsonKey(name: 'is_active')  bool isActive,  String? description, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'tax_rate_id')  String? taxRateId, @JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull)  String? taxRate, @JsonKey(name: 'is_tax_exempt')  bool isTaxExempt, @JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull)  int? shelfLifeDays, @JsonKey(name: 'min_stock_level')  String? minStockLevel, @JsonKey(name: 'max_stock_level')  String? maxStockLevel, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  CategoryModel? category,  BrandModel? brand, @JsonKey(name: 'base_unit')  UnitModel? baseUnit,  List<VariationModel> variations,  List<BarcodeModel> barcodes)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.sku,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.description,_that.imageUrl,_that.taxRateId,_that.taxRate,_that.isTaxExempt,_that.shelfLifeDays,_that.minStockLevel,_that.maxStockLevel,_that.createdAt,_that.updatedAt,_that.category,_that.brand,_that.baseUnit,_that.variations,_that.barcodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel implements ProductModel {
  const _ProductModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, this.sku, @JsonKey(name: 'product_type') required this.productType, @JsonKey(name: 'tracking_type') required this.trackingType, @JsonKey(name: 'is_sellable') this.isSellable = true, @JsonKey(name: 'is_purchasable') this.isPurchasable = true, @JsonKey(name: 'is_active') this.isActive = true, this.description, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'tax_rate_id') this.taxRateId, @JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull) this.taxRate, @JsonKey(name: 'is_tax_exempt') this.isTaxExempt = false, @JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull) this.shelfLifeDays, @JsonKey(name: 'min_stock_level') this.minStockLevel, @JsonKey(name: 'max_stock_level') this.maxStockLevel, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.category, this.brand, @JsonKey(name: 'base_unit') this.baseUnit,  List<VariationModel> variations = const [],  List<BarcodeModel> barcodes = const []}): _variations = variations,_barcodes = barcodes;
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override final  String? sku;
@override@JsonKey(name: 'product_type') final  String productType;
@override@JsonKey(name: 'tracking_type') final  String trackingType;
@override@JsonKey(name: 'is_sellable') final  bool isSellable;
@override@JsonKey(name: 'is_purchasable') final  bool isPurchasable;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override final  String? description;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'tax_rate_id') final  String? taxRateId;
@override@JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull) final  String? taxRate;
@override@JsonKey(name: 'is_tax_exempt') final  bool isTaxExempt;
@override@JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull) final  int? shelfLifeDays;
@override@JsonKey(name: 'min_stock_level') final  String? minStockLevel;
@override@JsonKey(name: 'max_stock_level') final  String? maxStockLevel;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  CategoryModel? category;
@override final  BrandModel? brand;
@override@JsonKey(name: 'base_unit') final  UnitModel? baseUnit;
 final  List<VariationModel> _variations;
@override@JsonKey() List<VariationModel> get variations {
  if (_variations is EqualUnmodifiableListView) return _variations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variations);
}

 final  List<BarcodeModel> _barcodes;
@override@JsonKey() List<BarcodeModel> get barcodes {
  if (_barcodes is EqualUnmodifiableListView) return _barcodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barcodes);
}


/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.trackingType, trackingType) || other.trackingType == trackingType)&&(identical(other.isSellable, isSellable) || other.isSellable == isSellable)&&(identical(other.isPurchasable, isPurchasable) || other.isPurchasable == isPurchasable)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.taxRateId, taxRateId) || other.taxRateId == taxRateId)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.isTaxExempt, isTaxExempt) || other.isTaxExempt == isTaxExempt)&&(identical(other.shelfLifeDays, shelfLifeDays) || other.shelfLifeDays == shelfLifeDays)&&(identical(other.minStockLevel, minStockLevel) || other.minStockLevel == minStockLevel)&&(identical(other.maxStockLevel, maxStockLevel) || other.maxStockLevel == maxStockLevel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.baseUnit, baseUnit) || other.baseUnit == baseUnit)&&const DeepCollectionEquality().equals(other.variations, _variations)&&const DeepCollectionEquality().equals(other.barcodes, _barcodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,businessId,name,sku,productType,trackingType,isSellable,isPurchasable,isActive,description,imageUrl,taxRateId,taxRate,isTaxExempt,shelfLifeDays,minStockLevel,maxStockLevel,createdAt,updatedAt,category,brand,baseUnit,const DeepCollectionEquality().hash(_variations),const DeepCollectionEquality().hash(_barcodes)]);
}

@override
String toString() {
    return 'ProductModel(id: $id, businessId: $businessId, name: $name, sku: $sku, productType: $productType, trackingType: $trackingType, isSellable: $isSellable, isPurchasable: $isPurchasable, isActive: $isActive, description: $description, imageUrl: $imageUrl, taxRateId: $taxRateId, taxRate: $taxRate, isTaxExempt: $isTaxExempt, shelfLifeDays: $shelfLifeDays, minStockLevel: $minStockLevel, maxStockLevel: $maxStockLevel, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, brand: $brand, baseUnit: $baseUnit, variations: $variations, barcodes: $barcodes)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String? sku,@JsonKey(name: 'product_type') String productType,@JsonKey(name: 'tracking_type') String trackingType,@JsonKey(name: 'is_sellable') bool isSellable,@JsonKey(name: 'is_purchasable') bool isPurchasable,@JsonKey(name: 'is_active') bool isActive, String? description,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'tax_rate_id') String? taxRateId,@JsonKey(name: 'tax_rate', fromJson: JsonNum.stringOrNull) String? taxRate,@JsonKey(name: 'is_tax_exempt') bool isTaxExempt,@JsonKey(name: 'shelf_life_days', fromJson: JsonNum.intOrNull) int? shelfLifeDays,@JsonKey(name: 'min_stock_level') String? minStockLevel,@JsonKey(name: 'max_stock_level') String? maxStockLevel,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, CategoryModel? category, BrandModel? brand,@JsonKey(name: 'base_unit') UnitModel? baseUnit, List<VariationModel> variations, List<BarcodeModel> barcodes
});


@override $CategoryModelCopyWith<$Res>? get category;@override $BrandModelCopyWith<$Res>? get brand;@override $UnitModelCopyWith<$Res>? get baseUnit;

}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? sku = freezed,Object? productType = null,Object? trackingType = null,Object? isSellable = null,Object? isPurchasable = null,Object? isActive = null,Object? description = freezed,Object? imageUrl = freezed,Object? taxRateId = freezed,Object? taxRate = freezed,Object? isTaxExempt = null,Object? shelfLifeDays = freezed,Object? minStockLevel = freezed,Object? maxStockLevel = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? category = freezed,Object? brand = freezed,Object? baseUnit = freezed,Object? variations = null,Object? barcodes = null,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as String,isSellable: null == isSellable ? _self.isSellable : isSellable // ignore: cast_nullable_to_non_nullable
as bool,isPurchasable: null == isPurchasable ? _self.isPurchasable : isPurchasable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,taxRateId: freezed == taxRateId ? _self.taxRateId : taxRateId // ignore: cast_nullable_to_non_nullable
as String?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String?,isTaxExempt: null == isTaxExempt ? _self.isTaxExempt : isTaxExempt // ignore: cast_nullable_to_non_nullable
as bool,shelfLifeDays: freezed == shelfLifeDays ? _self.shelfLifeDays : shelfLifeDays // ignore: cast_nullable_to_non_nullable
as int?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as String?,maxStockLevel: freezed == maxStockLevel ? _self.maxStockLevel : maxStockLevel // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandModel?,baseUnit: freezed == baseUnit ? _self.baseUnit : baseUnit // ignore: cast_nullable_to_non_nullable
as UnitModel?,variations: null == variations ? _self._variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,barcodes: null == barcodes ? _self._barcodes : barcodes // ignore: cast_nullable_to_non_nullable
as List<BarcodeModel>,
  ));
}

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandModelCopyWith<$Res>? get brand {
    if (_self.brand == null) {
    return null;
  }

  return $BrandModelCopyWith<$Res>(_self.brand!, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitModelCopyWith<$Res>? get baseUnit {
    if (_self.baseUnit == null) {
    return null;
  }

  return $UnitModelCopyWith<$Res>(_self.baseUnit!, (value) {
    return _then(_self.copyWith(baseUnit: value));
  });
}
}

// dart format on
