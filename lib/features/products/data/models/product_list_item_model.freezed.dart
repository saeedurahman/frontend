// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductListItemModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name; String? get sku;@JsonKey(name: 'product_type') String get productType;@JsonKey(name: 'tracking_type') String get trackingType;@JsonKey(name: 'is_sellable') bool get isSellable;@JsonKey(name: 'is_purchasable') bool get isPurchasable;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'brand_id') String? get brandId;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'tax_rate_id') String? get taxRateId;@JsonKey(name: 'is_tax_exempt') bool get isTaxExempt;@JsonKey(name: 'track_expiry') bool get trackExpiry;@JsonKey(name: 'name_secondary') String? get nameSecondary; String? get categoryName; String? get brandName;
/// Create a copy of ProductListItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductListItemModelCopyWith<ProductListItemModel> get copyWith => _$ProductListItemModelCopyWithImpl<ProductListItemModel>(this as ProductListItemModel, _$identity);

  /// Serializes this ProductListItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductListItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductListItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.productType, _this.productType) || other.productType == _this.productType)&&(identical(other.trackingType, _this.trackingType) || other.trackingType == _this.trackingType)&&(identical(other.isSellable, _this.isSellable) || other.isSellable == _this.isSellable)&&(identical(other.isPurchasable, _this.isPurchasable) || other.isPurchasable == _this.isPurchasable)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.brandId, _this.brandId) || other.brandId == _this.brandId)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.taxRateId, _this.taxRateId) || other.taxRateId == _this.taxRateId)&&(identical(other.isTaxExempt, _this.isTaxExempt) || other.isTaxExempt == _this.isTaxExempt)&&(identical(other.trackExpiry, _this.trackExpiry) || other.trackExpiry == _this.trackExpiry)&&(identical(other.nameSecondary, _this.nameSecondary) || other.nameSecondary == _this.nameSecondary)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductListItemModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.sku,_this.productType,_this.trackingType,_this.isSellable,_this.isPurchasable,_this.isActive,_this.categoryId,_this.brandId,_this.imageUrl,_this.taxRateId,_this.isTaxExempt,_this.trackExpiry,_this.nameSecondary,_this.categoryName,_this.brandName);
}

@override
String toString() {
  final _this = this as ProductListItemModel;
  return 'ProductListItemModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, sku: ${_this.sku}, productType: ${_this.productType}, trackingType: ${_this.trackingType}, isSellable: ${_this.isSellable}, isPurchasable: ${_this.isPurchasable}, isActive: ${_this.isActive}, categoryId: ${_this.categoryId}, brandId: ${_this.brandId}, imageUrl: ${_this.imageUrl}, taxRateId: ${_this.taxRateId}, isTaxExempt: ${_this.isTaxExempt}, trackExpiry: ${_this.trackExpiry}, nameSecondary: ${_this.nameSecondary}, categoryName: ${_this.categoryName}, brandName: ${_this.brandName})';
}


}

/// @nodoc
abstract mixin class $ProductListItemModelCopyWith<$Res>  {
  factory $ProductListItemModelCopyWith(ProductListItemModel value, $Res Function(ProductListItemModel) _then) = _$ProductListItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String? sku,@JsonKey(name: 'product_type') String productType,@JsonKey(name: 'tracking_type') String trackingType,@JsonKey(name: 'is_sellable') bool isSellable,@JsonKey(name: 'is_purchasable') bool isPurchasable,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'brand_id') String? brandId,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'tax_rate_id') String? taxRateId,@JsonKey(name: 'is_tax_exempt') bool isTaxExempt,@JsonKey(name: 'track_expiry') bool trackExpiry,@JsonKey(name: 'name_secondary') String? nameSecondary, String? categoryName, String? brandName
});




}
/// @nodoc
class _$ProductListItemModelCopyWithImpl<$Res>
    implements $ProductListItemModelCopyWith<$Res> {
  _$ProductListItemModelCopyWithImpl(this._self, this._then);

  final ProductListItemModel _self;
  final $Res Function(ProductListItemModel) _then;

/// Create a copy of ProductListItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? sku = freezed,Object? productType = null,Object? trackingType = null,Object? isSellable = null,Object? isPurchasable = null,Object? isActive = null,Object? categoryId = freezed,Object? brandId = freezed,Object? imageUrl = freezed,Object? taxRateId = freezed,Object? isTaxExempt = null,Object? trackExpiry = null,Object? nameSecondary = freezed,Object? categoryName = freezed,Object? brandName = freezed,}) {
  return _then(ProductListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as String,isSellable: null == isSellable ? _self.isSellable : isSellable // ignore: cast_nullable_to_non_nullable
as bool,isPurchasable: null == isPurchasable ? _self.isPurchasable : isPurchasable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,taxRateId: freezed == taxRateId ? _self.taxRateId : taxRateId // ignore: cast_nullable_to_non_nullable
as String?,isTaxExempt: null == isTaxExempt ? _self.isTaxExempt : isTaxExempt // ignore: cast_nullable_to_non_nullable
as bool,trackExpiry: null == trackExpiry ? _self.trackExpiry : trackExpiry // ignore: cast_nullable_to_non_nullable
as bool,nameSecondary: freezed == nameSecondary ? _self.nameSecondary : nameSecondary // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductListItemModel].
extension ProductListItemModelPatterns on ProductListItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductListItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductListItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductListItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductListItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductListItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductListItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? sku, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'tracking_type')  String trackingType, @JsonKey(name: 'is_sellable')  bool isSellable, @JsonKey(name: 'is_purchasable')  bool isPurchasable, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'brand_id')  String? brandId, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'tax_rate_id')  String? taxRateId, @JsonKey(name: 'is_tax_exempt')  bool isTaxExempt, @JsonKey(name: 'track_expiry')  bool trackExpiry, @JsonKey(name: 'name_secondary')  String? nameSecondary,  String? categoryName,  String? brandName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductListItemModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.sku,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.categoryId,_that.brandId,_that.imageUrl,_that.taxRateId,_that.isTaxExempt,_that.trackExpiry,_that.nameSecondary,_that.categoryName,_that.brandName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? sku, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'tracking_type')  String trackingType, @JsonKey(name: 'is_sellable')  bool isSellable, @JsonKey(name: 'is_purchasable')  bool isPurchasable, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'brand_id')  String? brandId, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'tax_rate_id')  String? taxRateId, @JsonKey(name: 'is_tax_exempt')  bool isTaxExempt, @JsonKey(name: 'track_expiry')  bool trackExpiry, @JsonKey(name: 'name_secondary')  String? nameSecondary,  String? categoryName,  String? brandName)  $default,) {final _that = this;
switch (_that) {
case _ProductListItemModel():
return $default(_that.id,_that.businessId,_that.name,_that.sku,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.categoryId,_that.brandId,_that.imageUrl,_that.taxRateId,_that.isTaxExempt,_that.trackExpiry,_that.nameSecondary,_that.categoryName,_that.brandName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? sku, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'tracking_type')  String trackingType, @JsonKey(name: 'is_sellable')  bool isSellable, @JsonKey(name: 'is_purchasable')  bool isPurchasable, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'brand_id')  String? brandId, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'tax_rate_id')  String? taxRateId, @JsonKey(name: 'is_tax_exempt')  bool isTaxExempt, @JsonKey(name: 'track_expiry')  bool trackExpiry, @JsonKey(name: 'name_secondary')  String? nameSecondary,  String? categoryName,  String? brandName)?  $default,) {final _that = this;
switch (_that) {
case _ProductListItemModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.sku,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.categoryId,_that.brandId,_that.imageUrl,_that.taxRateId,_that.isTaxExempt,_that.trackExpiry,_that.nameSecondary,_that.categoryName,_that.brandName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductListItemModel implements ProductListItemModel {
  const _ProductListItemModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, this.sku, @JsonKey(name: 'product_type') required this.productType, @JsonKey(name: 'tracking_type') required this.trackingType, @JsonKey(name: 'is_sellable') this.isSellable = true, @JsonKey(name: 'is_purchasable') this.isPurchasable = true, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'brand_id') this.brandId, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'tax_rate_id') this.taxRateId, @JsonKey(name: 'is_tax_exempt') this.isTaxExempt = false, @JsonKey(name: 'track_expiry') this.trackExpiry = false, @JsonKey(name: 'name_secondary') this.nameSecondary, this.categoryName, this.brandName});
  factory _ProductListItemModel.fromJson(Map<String, dynamic> json) => _$ProductListItemModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override final  String? sku;
@override@JsonKey(name: 'product_type') final  String productType;
@override@JsonKey(name: 'tracking_type') final  String trackingType;
@override@JsonKey(name: 'is_sellable') final  bool isSellable;
@override@JsonKey(name: 'is_purchasable') final  bool isPurchasable;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'brand_id') final  String? brandId;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'tax_rate_id') final  String? taxRateId;
@override@JsonKey(name: 'is_tax_exempt') final  bool isTaxExempt;
@override@JsonKey(name: 'track_expiry') final  bool trackExpiry;
@override@JsonKey(name: 'name_secondary') final  String? nameSecondary;
@override final  String? categoryName;
@override final  String? brandName;

/// Create a copy of ProductListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductListItemModelCopyWith<_ProductListItemModel> get copyWith => __$ProductListItemModelCopyWithImpl<_ProductListItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductListItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.trackingType, trackingType) || other.trackingType == trackingType)&&(identical(other.isSellable, isSellable) || other.isSellable == isSellable)&&(identical(other.isPurchasable, isPurchasable) || other.isPurchasable == isPurchasable)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.taxRateId, taxRateId) || other.taxRateId == taxRateId)&&(identical(other.isTaxExempt, isTaxExempt) || other.isTaxExempt == isTaxExempt)&&(identical(other.trackExpiry, trackExpiry) || other.trackExpiry == trackExpiry)&&(identical(other.nameSecondary, nameSecondary) || other.nameSecondary == nameSecondary)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.brandName, brandName) || other.brandName == brandName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,sku,productType,trackingType,isSellable,isPurchasable,isActive,categoryId,brandId,imageUrl,taxRateId,isTaxExempt,trackExpiry,nameSecondary,categoryName,brandName);
}

@override
String toString() {
    return 'ProductListItemModel(id: $id, businessId: $businessId, name: $name, sku: $sku, productType: $productType, trackingType: $trackingType, isSellable: $isSellable, isPurchasable: $isPurchasable, isActive: $isActive, categoryId: $categoryId, brandId: $brandId, imageUrl: $imageUrl, taxRateId: $taxRateId, isTaxExempt: $isTaxExempt, trackExpiry: $trackExpiry, nameSecondary: $nameSecondary, categoryName: $categoryName, brandName: $brandName)';
}


}

/// @nodoc
abstract mixin class _$ProductListItemModelCopyWith<$Res> implements $ProductListItemModelCopyWith<$Res> {
  factory _$ProductListItemModelCopyWith(_ProductListItemModel value, $Res Function(_ProductListItemModel) _then) = __$ProductListItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String? sku,@JsonKey(name: 'product_type') String productType,@JsonKey(name: 'tracking_type') String trackingType,@JsonKey(name: 'is_sellable') bool isSellable,@JsonKey(name: 'is_purchasable') bool isPurchasable,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'brand_id') String? brandId,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'tax_rate_id') String? taxRateId,@JsonKey(name: 'is_tax_exempt') bool isTaxExempt,@JsonKey(name: 'track_expiry') bool trackExpiry,@JsonKey(name: 'name_secondary') String? nameSecondary, String? categoryName, String? brandName
});




}
/// @nodoc
class __$ProductListItemModelCopyWithImpl<$Res>
    implements _$ProductListItemModelCopyWith<$Res> {
  __$ProductListItemModelCopyWithImpl(this._self, this._then);

  final _ProductListItemModel _self;
  final $Res Function(_ProductListItemModel) _then;

/// Create a copy of ProductListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? sku = freezed,Object? productType = null,Object? trackingType = null,Object? isSellable = null,Object? isPurchasable = null,Object? isActive = null,Object? categoryId = freezed,Object? brandId = freezed,Object? imageUrl = freezed,Object? taxRateId = freezed,Object? isTaxExempt = null,Object? trackExpiry = null,Object? nameSecondary = freezed,Object? categoryName = freezed,Object? brandName = freezed,}) {
  return _then(_ProductListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as String,isSellable: null == isSellable ? _self.isSellable : isSellable // ignore: cast_nullable_to_non_nullable
as bool,isPurchasable: null == isPurchasable ? _self.isPurchasable : isPurchasable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,taxRateId: freezed == taxRateId ? _self.taxRateId : taxRateId // ignore: cast_nullable_to_non_nullable
as String?,isTaxExempt: null == isTaxExempt ? _self.isTaxExempt : isTaxExempt // ignore: cast_nullable_to_non_nullable
as bool,trackExpiry: null == trackExpiry ? _self.trackExpiry : trackExpiry // ignore: cast_nullable_to_non_nullable
as bool,nameSecondary: freezed == nameSecondary ? _self.nameSecondary : nameSecondary // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
