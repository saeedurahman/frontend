// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VariationFormItem {

 String? get id; String get name; String? get sku; String? get unitId; bool get isDefault; String? get weightGrams; bool get isActive;
/// Create a copy of VariationFormItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VariationFormItemCopyWith<VariationFormItem> get copyWith => _$VariationFormItemCopyWithImpl<VariationFormItem>(this as VariationFormItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VariationFormItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VariationFormItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.weightGrams, _this.weightGrams) || other.weightGrams == _this.weightGrams)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}


@override
int get hashCode {
  final _this = this as VariationFormItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.sku,_this.unitId,_this.isDefault,_this.weightGrams,_this.isActive);
}

@override
String toString() {
  final _this = this as VariationFormItem;
  return 'VariationFormItem(id: ${_this.id}, name: ${_this.name}, sku: ${_this.sku}, unitId: ${_this.unitId}, isDefault: ${_this.isDefault}, weightGrams: ${_this.weightGrams}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $VariationFormItemCopyWith<$Res>  {
  factory $VariationFormItemCopyWith(VariationFormItem value, $Res Function(VariationFormItem) _then) = _$VariationFormItemCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String? sku, String? unitId, bool isDefault, String? weightGrams, bool isActive
});




}
/// @nodoc
class _$VariationFormItemCopyWithImpl<$Res>
    implements $VariationFormItemCopyWith<$Res> {
  _$VariationFormItemCopyWithImpl(this._self, this._then);

  final VariationFormItem _self;
  final $Res Function(VariationFormItem) _then;

/// Create a copy of VariationFormItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? sku = freezed,Object? unitId = freezed,Object? isDefault = null,Object? weightGrams = freezed,Object? isActive = null,}) {
  return _then(VariationFormItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VariationFormItem].
extension VariationFormItemPatterns on VariationFormItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VariationFormItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VariationFormItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VariationFormItem value)  $default,){
final _that = this;
switch (_that) {
case _VariationFormItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VariationFormItem value)?  $default,){
final _that = this;
switch (_that) {
case _VariationFormItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  String? sku,  String? unitId,  bool isDefault,  String? weightGrams,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VariationFormItem() when $default != null:
return $default(_that.id,_that.name,_that.sku,_that.unitId,_that.isDefault,_that.weightGrams,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  String? sku,  String? unitId,  bool isDefault,  String? weightGrams,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _VariationFormItem():
return $default(_that.id,_that.name,_that.sku,_that.unitId,_that.isDefault,_that.weightGrams,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  String? sku,  String? unitId,  bool isDefault,  String? weightGrams,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _VariationFormItem() when $default != null:
return $default(_that.id,_that.name,_that.sku,_that.unitId,_that.isDefault,_that.weightGrams,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _VariationFormItem implements VariationFormItem {
  const _VariationFormItem({this.id, this.name = '', this.sku, this.unitId, this.isDefault = false, this.weightGrams, this.isActive = true});
  

@override final  String? id;
@override@JsonKey() final  String name;
@override final  String? sku;
@override final  String? unitId;
@override@JsonKey() final  bool isDefault;
@override final  String? weightGrams;
@override@JsonKey() final  bool isActive;

/// Create a copy of VariationFormItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VariationFormItemCopyWith<_VariationFormItem> get copyWith => __$VariationFormItemCopyWithImpl<_VariationFormItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VariationFormItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,sku,unitId,isDefault,weightGrams,isActive);
}

@override
String toString() {
    return 'VariationFormItem(id: $id, name: $name, sku: $sku, unitId: $unitId, isDefault: $isDefault, weightGrams: $weightGrams, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$VariationFormItemCopyWith<$Res> implements $VariationFormItemCopyWith<$Res> {
  factory _$VariationFormItemCopyWith(_VariationFormItem value, $Res Function(_VariationFormItem) _then) = __$VariationFormItemCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String? sku, String? unitId, bool isDefault, String? weightGrams, bool isActive
});




}
/// @nodoc
class __$VariationFormItemCopyWithImpl<$Res>
    implements _$VariationFormItemCopyWith<$Res> {
  __$VariationFormItemCopyWithImpl(this._self, this._then);

  final _VariationFormItem _self;
  final $Res Function(_VariationFormItem) _then;

/// Create a copy of VariationFormItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? sku = freezed,Object? unitId = freezed,Object? isDefault = null,Object? weightGrams = freezed,Object? isActive = null,}) {
  return _then(_VariationFormItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$BarcodeFormItem {

 String? get id; String get barcode; String get barcodeType; String? get variationId; bool get isPrimary;
/// Create a copy of BarcodeFormItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarcodeFormItemCopyWith<BarcodeFormItem> get copyWith => _$BarcodeFormItemCopyWithImpl<BarcodeFormItem>(this as BarcodeFormItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BarcodeFormItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarcodeFormItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.barcodeType, _this.barcodeType) || other.barcodeType == _this.barcodeType)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.isPrimary, _this.isPrimary) || other.isPrimary == _this.isPrimary));
}


@override
int get hashCode {
  final _this = this as BarcodeFormItem;
  return Object.hash(runtimeType,_this.id,_this.barcode,_this.barcodeType,_this.variationId,_this.isPrimary);
}

@override
String toString() {
  final _this = this as BarcodeFormItem;
  return 'BarcodeFormItem(id: ${_this.id}, barcode: ${_this.barcode}, barcodeType: ${_this.barcodeType}, variationId: ${_this.variationId}, isPrimary: ${_this.isPrimary})';
}


}

/// @nodoc
abstract mixin class $BarcodeFormItemCopyWith<$Res>  {
  factory $BarcodeFormItemCopyWith(BarcodeFormItem value, $Res Function(BarcodeFormItem) _then) = _$BarcodeFormItemCopyWithImpl;
@useResult
$Res call({
 String? id, String barcode, String barcodeType, String? variationId, bool isPrimary
});




}
/// @nodoc
class _$BarcodeFormItemCopyWithImpl<$Res>
    implements $BarcodeFormItemCopyWith<$Res> {
  _$BarcodeFormItemCopyWithImpl(this._self, this._then);

  final BarcodeFormItem _self;
  final $Res Function(BarcodeFormItem) _then;

/// Create a copy of BarcodeFormItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? barcode = null,Object? barcodeType = null,Object? variationId = freezed,Object? isPrimary = null,}) {
  return _then(BarcodeFormItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BarcodeFormItem].
extension BarcodeFormItemPatterns on BarcodeFormItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarcodeFormItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarcodeFormItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarcodeFormItem value)  $default,){
final _that = this;
switch (_that) {
case _BarcodeFormItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarcodeFormItem value)?  $default,){
final _that = this;
switch (_that) {
case _BarcodeFormItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String barcode,  String barcodeType,  String? variationId,  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarcodeFormItem() when $default != null:
return $default(_that.id,_that.barcode,_that.barcodeType,_that.variationId,_that.isPrimary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String barcode,  String barcodeType,  String? variationId,  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _BarcodeFormItem():
return $default(_that.id,_that.barcode,_that.barcodeType,_that.variationId,_that.isPrimary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String barcode,  String barcodeType,  String? variationId,  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _BarcodeFormItem() when $default != null:
return $default(_that.id,_that.barcode,_that.barcodeType,_that.variationId,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc


class _BarcodeFormItem implements BarcodeFormItem {
  const _BarcodeFormItem({this.id, this.barcode = '', this.barcodeType = 'EAN13', this.variationId, this.isPrimary = false});
  

@override final  String? id;
@override@JsonKey() final  String barcode;
@override@JsonKey() final  String barcodeType;
@override final  String? variationId;
@override@JsonKey() final  bool isPrimary;

/// Create a copy of BarcodeFormItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarcodeFormItemCopyWith<_BarcodeFormItem> get copyWith => __$BarcodeFormItemCopyWithImpl<_BarcodeFormItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarcodeFormItem&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,barcode,barcodeType,variationId,isPrimary);
}

@override
String toString() {
    return 'BarcodeFormItem(id: $id, barcode: $barcode, barcodeType: $barcodeType, variationId: $variationId, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$BarcodeFormItemCopyWith<$Res> implements $BarcodeFormItemCopyWith<$Res> {
  factory _$BarcodeFormItemCopyWith(_BarcodeFormItem value, $Res Function(_BarcodeFormItem) _then) = __$BarcodeFormItemCopyWithImpl;
@override @useResult
$Res call({
 String? id, String barcode, String barcodeType, String? variationId, bool isPrimary
});




}
/// @nodoc
class __$BarcodeFormItemCopyWithImpl<$Res>
    implements _$BarcodeFormItemCopyWith<$Res> {
  __$BarcodeFormItemCopyWithImpl(this._self, this._then);

  final _BarcodeFormItem _self;
  final $Res Function(_BarcodeFormItem) _then;

/// Create a copy of BarcodeFormItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? barcode = null,Object? barcodeType = null,Object? variationId = freezed,Object? isPrimary = null,}) {
  return _then(_BarcodeFormItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ProductFormState {

 String get mode; String? get productId; String get name; String? get sku; String? get description; String? get imageUrl; String? get localImagePath; String? get selectedCategoryId; String? get selectedBrandId; String? get selectedBaseUnitId; String get productType; String get trackingType; bool get isSellable; bool get isPurchasable; bool get isActive; String? get taxRateId; bool get isTaxExempt; bool get trackExpiry; int? get shelfLifeDays; String? get minStockLevel; String? get maxStockLevel; List<VariationFormItem> get variations; List<BarcodeFormItem> get barcodes; bool get isLoading; bool get isSubmitting; bool get isUploadingImage; String? get imageUploadError; bool get canManagePrices; String? get retailUnitPrice; String? get minQty; String? get defaultPriceListId; String? get priceListItemId; bool get isLoadingPrice; bool get isSavingPrice; String? get priceError; bool get priceSaveSuccess; Map<String, String> get errors;
/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductFormStateCopyWith<ProductFormState> get copyWith => _$ProductFormStateCopyWithImpl<ProductFormState>(this as ProductFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.localImagePath, _this.localImagePath) || other.localImagePath == _this.localImagePath)&&(identical(other.selectedCategoryId, _this.selectedCategoryId) || other.selectedCategoryId == _this.selectedCategoryId)&&(identical(other.selectedBrandId, _this.selectedBrandId) || other.selectedBrandId == _this.selectedBrandId)&&(identical(other.selectedBaseUnitId, _this.selectedBaseUnitId) || other.selectedBaseUnitId == _this.selectedBaseUnitId)&&(identical(other.productType, _this.productType) || other.productType == _this.productType)&&(identical(other.trackingType, _this.trackingType) || other.trackingType == _this.trackingType)&&(identical(other.isSellable, _this.isSellable) || other.isSellable == _this.isSellable)&&(identical(other.isPurchasable, _this.isPurchasable) || other.isPurchasable == _this.isPurchasable)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.taxRateId, _this.taxRateId) || other.taxRateId == _this.taxRateId)&&(identical(other.isTaxExempt, _this.isTaxExempt) || other.isTaxExempt == _this.isTaxExempt)&&(identical(other.trackExpiry, _this.trackExpiry) || other.trackExpiry == _this.trackExpiry)&&(identical(other.shelfLifeDays, _this.shelfLifeDays) || other.shelfLifeDays == _this.shelfLifeDays)&&(identical(other.minStockLevel, _this.minStockLevel) || other.minStockLevel == _this.minStockLevel)&&(identical(other.maxStockLevel, _this.maxStockLevel) || other.maxStockLevel == _this.maxStockLevel)&&const DeepCollectionEquality().equals(other.variations, _this.variations)&&const DeepCollectionEquality().equals(other.barcodes, _this.barcodes)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isUploadingImage, _this.isUploadingImage) || other.isUploadingImage == _this.isUploadingImage)&&(identical(other.imageUploadError, _this.imageUploadError) || other.imageUploadError == _this.imageUploadError)&&(identical(other.canManagePrices, _this.canManagePrices) || other.canManagePrices == _this.canManagePrices)&&(identical(other.retailUnitPrice, _this.retailUnitPrice) || other.retailUnitPrice == _this.retailUnitPrice)&&(identical(other.minQty, _this.minQty) || other.minQty == _this.minQty)&&(identical(other.defaultPriceListId, _this.defaultPriceListId) || other.defaultPriceListId == _this.defaultPriceListId)&&(identical(other.priceListItemId, _this.priceListItemId) || other.priceListItemId == _this.priceListItemId)&&(identical(other.isLoadingPrice, _this.isLoadingPrice) || other.isLoadingPrice == _this.isLoadingPrice)&&(identical(other.isSavingPrice, _this.isSavingPrice) || other.isSavingPrice == _this.isSavingPrice)&&(identical(other.priceError, _this.priceError) || other.priceError == _this.priceError)&&(identical(other.priceSaveSuccess, _this.priceSaveSuccess) || other.priceSaveSuccess == _this.priceSaveSuccess)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as ProductFormState;
  return Object.hashAll([runtimeType,_this.mode,_this.productId,_this.name,_this.sku,_this.description,_this.imageUrl,_this.localImagePath,_this.selectedCategoryId,_this.selectedBrandId,_this.selectedBaseUnitId,_this.productType,_this.trackingType,_this.isSellable,_this.isPurchasable,_this.isActive,_this.taxRateId,_this.isTaxExempt,_this.trackExpiry,_this.shelfLifeDays,_this.minStockLevel,_this.maxStockLevel,const DeepCollectionEquality().hash(_this.variations),const DeepCollectionEquality().hash(_this.barcodes),_this.isLoading,_this.isSubmitting,_this.isUploadingImage,_this.imageUploadError,_this.canManagePrices,_this.retailUnitPrice,_this.minQty,_this.defaultPriceListId,_this.priceListItemId,_this.isLoadingPrice,_this.isSavingPrice,_this.priceError,_this.priceSaveSuccess,const DeepCollectionEquality().hash(_this.errors)]);
}

@override
String toString() {
  final _this = this as ProductFormState;
  return 'ProductFormState(mode: ${_this.mode}, productId: ${_this.productId}, name: ${_this.name}, sku: ${_this.sku}, description: ${_this.description}, imageUrl: ${_this.imageUrl}, localImagePath: ${_this.localImagePath}, selectedCategoryId: ${_this.selectedCategoryId}, selectedBrandId: ${_this.selectedBrandId}, selectedBaseUnitId: ${_this.selectedBaseUnitId}, productType: ${_this.productType}, trackingType: ${_this.trackingType}, isSellable: ${_this.isSellable}, isPurchasable: ${_this.isPurchasable}, isActive: ${_this.isActive}, taxRateId: ${_this.taxRateId}, isTaxExempt: ${_this.isTaxExempt}, trackExpiry: ${_this.trackExpiry}, shelfLifeDays: ${_this.shelfLifeDays}, minStockLevel: ${_this.minStockLevel}, maxStockLevel: ${_this.maxStockLevel}, variations: ${_this.variations}, barcodes: ${_this.barcodes}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, isUploadingImage: ${_this.isUploadingImage}, imageUploadError: ${_this.imageUploadError}, canManagePrices: ${_this.canManagePrices}, retailUnitPrice: ${_this.retailUnitPrice}, minQty: ${_this.minQty}, defaultPriceListId: ${_this.defaultPriceListId}, priceListItemId: ${_this.priceListItemId}, isLoadingPrice: ${_this.isLoadingPrice}, isSavingPrice: ${_this.isSavingPrice}, priceError: ${_this.priceError}, priceSaveSuccess: ${_this.priceSaveSuccess}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ProductFormStateCopyWith<$Res>  {
  factory $ProductFormStateCopyWith(ProductFormState value, $Res Function(ProductFormState) _then) = _$ProductFormStateCopyWithImpl;
@useResult
$Res call({
 String mode, String? productId, String name, String? sku, String? description, String? imageUrl, String? localImagePath, String? selectedCategoryId, String? selectedBrandId, String? selectedBaseUnitId, String productType, String trackingType, bool isSellable, bool isPurchasable, bool isActive, String? taxRateId, bool isTaxExempt, bool trackExpiry, int? shelfLifeDays, String? minStockLevel, String? maxStockLevel, List<VariationFormItem> variations, List<BarcodeFormItem> barcodes, bool isLoading, bool isSubmitting, bool isUploadingImage, String? imageUploadError, bool canManagePrices, String? retailUnitPrice, String? minQty, String? defaultPriceListId, String? priceListItemId, bool isLoadingPrice, bool isSavingPrice, String? priceError, bool priceSaveSuccess, Map<String, String> errors
});




}
/// @nodoc
class _$ProductFormStateCopyWithImpl<$Res>
    implements $ProductFormStateCopyWith<$Res> {
  _$ProductFormStateCopyWithImpl(this._self, this._then);

  final ProductFormState _self;
  final $Res Function(ProductFormState) _then;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? productId = freezed,Object? name = null,Object? sku = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? localImagePath = freezed,Object? selectedCategoryId = freezed,Object? selectedBrandId = freezed,Object? selectedBaseUnitId = freezed,Object? productType = null,Object? trackingType = null,Object? isSellable = null,Object? isPurchasable = null,Object? isActive = null,Object? taxRateId = freezed,Object? isTaxExempt = null,Object? trackExpiry = null,Object? shelfLifeDays = freezed,Object? minStockLevel = freezed,Object? maxStockLevel = freezed,Object? variations = null,Object? barcodes = null,Object? isLoading = null,Object? isSubmitting = null,Object? isUploadingImage = null,Object? imageUploadError = freezed,Object? canManagePrices = null,Object? retailUnitPrice = freezed,Object? minQty = freezed,Object? defaultPriceListId = freezed,Object? priceListItemId = freezed,Object? isLoadingPrice = null,Object? isSavingPrice = null,Object? priceError = freezed,Object? priceSaveSuccess = null,Object? errors = null,}) {
  return _then(ProductFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,selectedBrandId: freezed == selectedBrandId ? _self.selectedBrandId : selectedBrandId // ignore: cast_nullable_to_non_nullable
as String?,selectedBaseUnitId: freezed == selectedBaseUnitId ? _self.selectedBaseUnitId : selectedBaseUnitId // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as String,isSellable: null == isSellable ? _self.isSellable : isSellable // ignore: cast_nullable_to_non_nullable
as bool,isPurchasable: null == isPurchasable ? _self.isPurchasable : isPurchasable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,taxRateId: freezed == taxRateId ? _self.taxRateId : taxRateId // ignore: cast_nullable_to_non_nullable
as String?,isTaxExempt: null == isTaxExempt ? _self.isTaxExempt : isTaxExempt // ignore: cast_nullable_to_non_nullable
as bool,trackExpiry: null == trackExpiry ? _self.trackExpiry : trackExpiry // ignore: cast_nullable_to_non_nullable
as bool,shelfLifeDays: freezed == shelfLifeDays ? _self.shelfLifeDays : shelfLifeDays // ignore: cast_nullable_to_non_nullable
as int?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as String?,maxStockLevel: freezed == maxStockLevel ? _self.maxStockLevel : maxStockLevel // ignore: cast_nullable_to_non_nullable
as String?,variations: null == variations ? _self.variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationFormItem>,barcodes: null == barcodes ? _self.barcodes : barcodes // ignore: cast_nullable_to_non_nullable
as List<BarcodeFormItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isUploadingImage: null == isUploadingImage ? _self.isUploadingImage : isUploadingImage // ignore: cast_nullable_to_non_nullable
as bool,imageUploadError: freezed == imageUploadError ? _self.imageUploadError : imageUploadError // ignore: cast_nullable_to_non_nullable
as String?,canManagePrices: null == canManagePrices ? _self.canManagePrices : canManagePrices // ignore: cast_nullable_to_non_nullable
as bool,retailUnitPrice: freezed == retailUnitPrice ? _self.retailUnitPrice : retailUnitPrice // ignore: cast_nullable_to_non_nullable
as String?,minQty: freezed == minQty ? _self.minQty : minQty // ignore: cast_nullable_to_non_nullable
as String?,defaultPriceListId: freezed == defaultPriceListId ? _self.defaultPriceListId : defaultPriceListId // ignore: cast_nullable_to_non_nullable
as String?,priceListItemId: freezed == priceListItemId ? _self.priceListItemId : priceListItemId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingPrice: null == isLoadingPrice ? _self.isLoadingPrice : isLoadingPrice // ignore: cast_nullable_to_non_nullable
as bool,isSavingPrice: null == isSavingPrice ? _self.isSavingPrice : isSavingPrice // ignore: cast_nullable_to_non_nullable
as bool,priceError: freezed == priceError ? _self.priceError : priceError // ignore: cast_nullable_to_non_nullable
as String?,priceSaveSuccess: null == priceSaveSuccess ? _self.priceSaveSuccess : priceSaveSuccess // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductFormState].
extension ProductFormStatePatterns on ProductFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductFormState value)  $default,){
final _that = this;
switch (_that) {
case _ProductFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  String? productId,  String name,  String? sku,  String? description,  String? imageUrl,  String? localImagePath,  String? selectedCategoryId,  String? selectedBrandId,  String? selectedBaseUnitId,  String productType,  String trackingType,  bool isSellable,  bool isPurchasable,  bool isActive,  String? taxRateId,  bool isTaxExempt,  bool trackExpiry,  int? shelfLifeDays,  String? minStockLevel,  String? maxStockLevel,  List<VariationFormItem> variations,  List<BarcodeFormItem> barcodes,  bool isLoading,  bool isSubmitting,  bool isUploadingImage,  String? imageUploadError,  bool canManagePrices,  String? retailUnitPrice,  String? minQty,  String? defaultPriceListId,  String? priceListItemId,  bool isLoadingPrice,  bool isSavingPrice,  String? priceError,  bool priceSaveSuccess,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductFormState() when $default != null:
return $default(_that.mode,_that.productId,_that.name,_that.sku,_that.description,_that.imageUrl,_that.localImagePath,_that.selectedCategoryId,_that.selectedBrandId,_that.selectedBaseUnitId,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.taxRateId,_that.isTaxExempt,_that.trackExpiry,_that.shelfLifeDays,_that.minStockLevel,_that.maxStockLevel,_that.variations,_that.barcodes,_that.isLoading,_that.isSubmitting,_that.isUploadingImage,_that.imageUploadError,_that.canManagePrices,_that.retailUnitPrice,_that.minQty,_that.defaultPriceListId,_that.priceListItemId,_that.isLoadingPrice,_that.isSavingPrice,_that.priceError,_that.priceSaveSuccess,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  String? productId,  String name,  String? sku,  String? description,  String? imageUrl,  String? localImagePath,  String? selectedCategoryId,  String? selectedBrandId,  String? selectedBaseUnitId,  String productType,  String trackingType,  bool isSellable,  bool isPurchasable,  bool isActive,  String? taxRateId,  bool isTaxExempt,  bool trackExpiry,  int? shelfLifeDays,  String? minStockLevel,  String? maxStockLevel,  List<VariationFormItem> variations,  List<BarcodeFormItem> barcodes,  bool isLoading,  bool isSubmitting,  bool isUploadingImage,  String? imageUploadError,  bool canManagePrices,  String? retailUnitPrice,  String? minQty,  String? defaultPriceListId,  String? priceListItemId,  bool isLoadingPrice,  bool isSavingPrice,  String? priceError,  bool priceSaveSuccess,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _ProductFormState():
return $default(_that.mode,_that.productId,_that.name,_that.sku,_that.description,_that.imageUrl,_that.localImagePath,_that.selectedCategoryId,_that.selectedBrandId,_that.selectedBaseUnitId,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.taxRateId,_that.isTaxExempt,_that.trackExpiry,_that.shelfLifeDays,_that.minStockLevel,_that.maxStockLevel,_that.variations,_that.barcodes,_that.isLoading,_that.isSubmitting,_that.isUploadingImage,_that.imageUploadError,_that.canManagePrices,_that.retailUnitPrice,_that.minQty,_that.defaultPriceListId,_that.priceListItemId,_that.isLoadingPrice,_that.isSavingPrice,_that.priceError,_that.priceSaveSuccess,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  String? productId,  String name,  String? sku,  String? description,  String? imageUrl,  String? localImagePath,  String? selectedCategoryId,  String? selectedBrandId,  String? selectedBaseUnitId,  String productType,  String trackingType,  bool isSellable,  bool isPurchasable,  bool isActive,  String? taxRateId,  bool isTaxExempt,  bool trackExpiry,  int? shelfLifeDays,  String? minStockLevel,  String? maxStockLevel,  List<VariationFormItem> variations,  List<BarcodeFormItem> barcodes,  bool isLoading,  bool isSubmitting,  bool isUploadingImage,  String? imageUploadError,  bool canManagePrices,  String? retailUnitPrice,  String? minQty,  String? defaultPriceListId,  String? priceListItemId,  bool isLoadingPrice,  bool isSavingPrice,  String? priceError,  bool priceSaveSuccess,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _ProductFormState() when $default != null:
return $default(_that.mode,_that.productId,_that.name,_that.sku,_that.description,_that.imageUrl,_that.localImagePath,_that.selectedCategoryId,_that.selectedBrandId,_that.selectedBaseUnitId,_that.productType,_that.trackingType,_that.isSellable,_that.isPurchasable,_that.isActive,_that.taxRateId,_that.isTaxExempt,_that.trackExpiry,_that.shelfLifeDays,_that.minStockLevel,_that.maxStockLevel,_that.variations,_that.barcodes,_that.isLoading,_that.isSubmitting,_that.isUploadingImage,_that.imageUploadError,_that.canManagePrices,_that.retailUnitPrice,_that.minQty,_that.defaultPriceListId,_that.priceListItemId,_that.isLoadingPrice,_that.isSavingPrice,_that.priceError,_that.priceSaveSuccess,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ProductFormState implements ProductFormState {
  const _ProductFormState({this.mode = 'create', this.productId, this.name = '', this.sku, this.description, this.imageUrl, this.localImagePath, this.selectedCategoryId, this.selectedBrandId, this.selectedBaseUnitId, this.productType = 'standard', this.trackingType = 'none', this.isSellable = true, this.isPurchasable = true, this.isActive = true, this.taxRateId, this.isTaxExempt = false, this.trackExpiry = false, this.shelfLifeDays, this.minStockLevel, this.maxStockLevel,  List<VariationFormItem> variations = const [],  List<BarcodeFormItem> barcodes = const [], this.isLoading = false, this.isSubmitting = false, this.isUploadingImage = false, this.imageUploadError, this.canManagePrices = false, this.retailUnitPrice, this.minQty, this.defaultPriceListId, this.priceListItemId, this.isLoadingPrice = false, this.isSavingPrice = false, this.priceError, this.priceSaveSuccess = false,  Map<String, String> errors = const {}}): _variations = variations,_barcodes = barcodes,_errors = errors;
  

@override@JsonKey() final  String mode;
@override final  String? productId;
@override@JsonKey() final  String name;
@override final  String? sku;
@override final  String? description;
@override final  String? imageUrl;
@override final  String? localImagePath;
@override final  String? selectedCategoryId;
@override final  String? selectedBrandId;
@override final  String? selectedBaseUnitId;
@override@JsonKey() final  String productType;
@override@JsonKey() final  String trackingType;
@override@JsonKey() final  bool isSellable;
@override@JsonKey() final  bool isPurchasable;
@override@JsonKey() final  bool isActive;
@override final  String? taxRateId;
@override@JsonKey() final  bool isTaxExempt;
@override@JsonKey() final  bool trackExpiry;
@override final  int? shelfLifeDays;
@override final  String? minStockLevel;
@override final  String? maxStockLevel;
 final  List<VariationFormItem> _variations;
@override@JsonKey() List<VariationFormItem> get variations {
  if (_variations is EqualUnmodifiableListView) return _variations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variations);
}

 final  List<BarcodeFormItem> _barcodes;
@override@JsonKey() List<BarcodeFormItem> get barcodes {
  if (_barcodes is EqualUnmodifiableListView) return _barcodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barcodes);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isUploadingImage;
@override final  String? imageUploadError;
@override@JsonKey() final  bool canManagePrices;
@override final  String? retailUnitPrice;
@override final  String? minQty;
@override final  String? defaultPriceListId;
@override final  String? priceListItemId;
@override@JsonKey() final  bool isLoadingPrice;
@override@JsonKey() final  bool isSavingPrice;
@override final  String? priceError;
@override@JsonKey() final  bool priceSaveSuccess;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductFormStateCopyWith<_ProductFormState> get copyWith => __$ProductFormStateCopyWithImpl<_ProductFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&(identical(other.selectedBrandId, selectedBrandId) || other.selectedBrandId == selectedBrandId)&&(identical(other.selectedBaseUnitId, selectedBaseUnitId) || other.selectedBaseUnitId == selectedBaseUnitId)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.trackingType, trackingType) || other.trackingType == trackingType)&&(identical(other.isSellable, isSellable) || other.isSellable == isSellable)&&(identical(other.isPurchasable, isPurchasable) || other.isPurchasable == isPurchasable)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.taxRateId, taxRateId) || other.taxRateId == taxRateId)&&(identical(other.isTaxExempt, isTaxExempt) || other.isTaxExempt == isTaxExempt)&&(identical(other.trackExpiry, trackExpiry) || other.trackExpiry == trackExpiry)&&(identical(other.shelfLifeDays, shelfLifeDays) || other.shelfLifeDays == shelfLifeDays)&&(identical(other.minStockLevel, minStockLevel) || other.minStockLevel == minStockLevel)&&(identical(other.maxStockLevel, maxStockLevel) || other.maxStockLevel == maxStockLevel)&&const DeepCollectionEquality().equals(other.variations, _variations)&&const DeepCollectionEquality().equals(other.barcodes, _barcodes)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isUploadingImage, isUploadingImage) || other.isUploadingImage == isUploadingImage)&&(identical(other.imageUploadError, imageUploadError) || other.imageUploadError == imageUploadError)&&(identical(other.canManagePrices, canManagePrices) || other.canManagePrices == canManagePrices)&&(identical(other.retailUnitPrice, retailUnitPrice) || other.retailUnitPrice == retailUnitPrice)&&(identical(other.minQty, minQty) || other.minQty == minQty)&&(identical(other.defaultPriceListId, defaultPriceListId) || other.defaultPriceListId == defaultPriceListId)&&(identical(other.priceListItemId, priceListItemId) || other.priceListItemId == priceListItemId)&&(identical(other.isLoadingPrice, isLoadingPrice) || other.isLoadingPrice == isLoadingPrice)&&(identical(other.isSavingPrice, isSavingPrice) || other.isSavingPrice == isSavingPrice)&&(identical(other.priceError, priceError) || other.priceError == priceError)&&(identical(other.priceSaveSuccess, priceSaveSuccess) || other.priceSaveSuccess == priceSaveSuccess)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,mode,productId,name,sku,description,imageUrl,localImagePath,selectedCategoryId,selectedBrandId,selectedBaseUnitId,productType,trackingType,isSellable,isPurchasable,isActive,taxRateId,isTaxExempt,trackExpiry,shelfLifeDays,minStockLevel,maxStockLevel,const DeepCollectionEquality().hash(_variations),const DeepCollectionEquality().hash(_barcodes),isLoading,isSubmitting,isUploadingImage,imageUploadError,canManagePrices,retailUnitPrice,minQty,defaultPriceListId,priceListItemId,isLoadingPrice,isSavingPrice,priceError,priceSaveSuccess,const DeepCollectionEquality().hash(_errors)]);
}

@override
String toString() {
    return 'ProductFormState(mode: $mode, productId: $productId, name: $name, sku: $sku, description: $description, imageUrl: $imageUrl, localImagePath: $localImagePath, selectedCategoryId: $selectedCategoryId, selectedBrandId: $selectedBrandId, selectedBaseUnitId: $selectedBaseUnitId, productType: $productType, trackingType: $trackingType, isSellable: $isSellable, isPurchasable: $isPurchasable, isActive: $isActive, taxRateId: $taxRateId, isTaxExempt: $isTaxExempt, trackExpiry: $trackExpiry, shelfLifeDays: $shelfLifeDays, minStockLevel: $minStockLevel, maxStockLevel: $maxStockLevel, variations: $variations, barcodes: $barcodes, isLoading: $isLoading, isSubmitting: $isSubmitting, isUploadingImage: $isUploadingImage, imageUploadError: $imageUploadError, canManagePrices: $canManagePrices, retailUnitPrice: $retailUnitPrice, minQty: $minQty, defaultPriceListId: $defaultPriceListId, priceListItemId: $priceListItemId, isLoadingPrice: $isLoadingPrice, isSavingPrice: $isSavingPrice, priceError: $priceError, priceSaveSuccess: $priceSaveSuccess, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ProductFormStateCopyWith<$Res> implements $ProductFormStateCopyWith<$Res> {
  factory _$ProductFormStateCopyWith(_ProductFormState value, $Res Function(_ProductFormState) _then) = __$ProductFormStateCopyWithImpl;
@override @useResult
$Res call({
 String mode, String? productId, String name, String? sku, String? description, String? imageUrl, String? localImagePath, String? selectedCategoryId, String? selectedBrandId, String? selectedBaseUnitId, String productType, String trackingType, bool isSellable, bool isPurchasable, bool isActive, String? taxRateId, bool isTaxExempt, bool trackExpiry, int? shelfLifeDays, String? minStockLevel, String? maxStockLevel, List<VariationFormItem> variations, List<BarcodeFormItem> barcodes, bool isLoading, bool isSubmitting, bool isUploadingImage, String? imageUploadError, bool canManagePrices, String? retailUnitPrice, String? minQty, String? defaultPriceListId, String? priceListItemId, bool isLoadingPrice, bool isSavingPrice, String? priceError, bool priceSaveSuccess, Map<String, String> errors
});




}
/// @nodoc
class __$ProductFormStateCopyWithImpl<$Res>
    implements _$ProductFormStateCopyWith<$Res> {
  __$ProductFormStateCopyWithImpl(this._self, this._then);

  final _ProductFormState _self;
  final $Res Function(_ProductFormState) _then;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? productId = freezed,Object? name = null,Object? sku = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? localImagePath = freezed,Object? selectedCategoryId = freezed,Object? selectedBrandId = freezed,Object? selectedBaseUnitId = freezed,Object? productType = null,Object? trackingType = null,Object? isSellable = null,Object? isPurchasable = null,Object? isActive = null,Object? taxRateId = freezed,Object? isTaxExempt = null,Object? trackExpiry = null,Object? shelfLifeDays = freezed,Object? minStockLevel = freezed,Object? maxStockLevel = freezed,Object? variations = null,Object? barcodes = null,Object? isLoading = null,Object? isSubmitting = null,Object? isUploadingImage = null,Object? imageUploadError = freezed,Object? canManagePrices = null,Object? retailUnitPrice = freezed,Object? minQty = freezed,Object? defaultPriceListId = freezed,Object? priceListItemId = freezed,Object? isLoadingPrice = null,Object? isSavingPrice = null,Object? priceError = freezed,Object? priceSaveSuccess = null,Object? errors = null,}) {
  return _then(_ProductFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,selectedBrandId: freezed == selectedBrandId ? _self.selectedBrandId : selectedBrandId // ignore: cast_nullable_to_non_nullable
as String?,selectedBaseUnitId: freezed == selectedBaseUnitId ? _self.selectedBaseUnitId : selectedBaseUnitId // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as String,isSellable: null == isSellable ? _self.isSellable : isSellable // ignore: cast_nullable_to_non_nullable
as bool,isPurchasable: null == isPurchasable ? _self.isPurchasable : isPurchasable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,taxRateId: freezed == taxRateId ? _self.taxRateId : taxRateId // ignore: cast_nullable_to_non_nullable
as String?,isTaxExempt: null == isTaxExempt ? _self.isTaxExempt : isTaxExempt // ignore: cast_nullable_to_non_nullable
as bool,trackExpiry: null == trackExpiry ? _self.trackExpiry : trackExpiry // ignore: cast_nullable_to_non_nullable
as bool,shelfLifeDays: freezed == shelfLifeDays ? _self.shelfLifeDays : shelfLifeDays // ignore: cast_nullable_to_non_nullable
as int?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as String?,maxStockLevel: freezed == maxStockLevel ? _self.maxStockLevel : maxStockLevel // ignore: cast_nullable_to_non_nullable
as String?,variations: null == variations ? _self._variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationFormItem>,barcodes: null == barcodes ? _self._barcodes : barcodes // ignore: cast_nullable_to_non_nullable
as List<BarcodeFormItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isUploadingImage: null == isUploadingImage ? _self.isUploadingImage : isUploadingImage // ignore: cast_nullable_to_non_nullable
as bool,imageUploadError: freezed == imageUploadError ? _self.imageUploadError : imageUploadError // ignore: cast_nullable_to_non_nullable
as String?,canManagePrices: null == canManagePrices ? _self.canManagePrices : canManagePrices // ignore: cast_nullable_to_non_nullable
as bool,retailUnitPrice: freezed == retailUnitPrice ? _self.retailUnitPrice : retailUnitPrice // ignore: cast_nullable_to_non_nullable
as String?,minQty: freezed == minQty ? _self.minQty : minQty // ignore: cast_nullable_to_non_nullable
as String?,defaultPriceListId: freezed == defaultPriceListId ? _self.defaultPriceListId : defaultPriceListId // ignore: cast_nullable_to_non_nullable
as String?,priceListItemId: freezed == priceListItemId ? _self.priceListItemId : priceListItemId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingPrice: null == isLoadingPrice ? _self.isLoadingPrice : isLoadingPrice // ignore: cast_nullable_to_non_nullable
as bool,isSavingPrice: null == isSavingPrice ? _self.isSavingPrice : isSavingPrice // ignore: cast_nullable_to_non_nullable
as bool,priceError: freezed == priceError ? _self.priceError : priceError // ignore: cast_nullable_to_non_nullable
as String?,priceSaveSuccess: null == priceSaveSuccess ? _self.priceSaveSuccess : priceSaveSuccess // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
