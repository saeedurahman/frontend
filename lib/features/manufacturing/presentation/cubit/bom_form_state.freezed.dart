// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BomLineFormItem {

 String? get ingredientProductId; String? get ingredientProductName; String? get ingredientVariationId; String? get ingredientVariationName; String get qtyRequired; String get wastagePct; List<VariationModel> get variations;
/// Create a copy of BomLineFormItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomLineFormItemCopyWith<BomLineFormItem> get copyWith => _$BomLineFormItemCopyWithImpl<BomLineFormItem>(this as BomLineFormItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BomLineFormItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BomLineFormItem&&(identical(other.ingredientProductId, _this.ingredientProductId) || other.ingredientProductId == _this.ingredientProductId)&&(identical(other.ingredientProductName, _this.ingredientProductName) || other.ingredientProductName == _this.ingredientProductName)&&(identical(other.ingredientVariationId, _this.ingredientVariationId) || other.ingredientVariationId == _this.ingredientVariationId)&&(identical(other.ingredientVariationName, _this.ingredientVariationName) || other.ingredientVariationName == _this.ingredientVariationName)&&(identical(other.qtyRequired, _this.qtyRequired) || other.qtyRequired == _this.qtyRequired)&&(identical(other.wastagePct, _this.wastagePct) || other.wastagePct == _this.wastagePct)&&const DeepCollectionEquality().equals(other.variations, _this.variations));
}


@override
int get hashCode {
  final _this = this as BomLineFormItem;
  return Object.hash(runtimeType,_this.ingredientProductId,_this.ingredientProductName,_this.ingredientVariationId,_this.ingredientVariationName,_this.qtyRequired,_this.wastagePct,const DeepCollectionEquality().hash(_this.variations));
}

@override
String toString() {
  final _this = this as BomLineFormItem;
  return 'BomLineFormItem(ingredientProductId: ${_this.ingredientProductId}, ingredientProductName: ${_this.ingredientProductName}, ingredientVariationId: ${_this.ingredientVariationId}, ingredientVariationName: ${_this.ingredientVariationName}, qtyRequired: ${_this.qtyRequired}, wastagePct: ${_this.wastagePct}, variations: ${_this.variations})';
}


}

/// @nodoc
abstract mixin class $BomLineFormItemCopyWith<$Res>  {
  factory $BomLineFormItemCopyWith(BomLineFormItem value, $Res Function(BomLineFormItem) _then) = _$BomLineFormItemCopyWithImpl;
@useResult
$Res call({
 String? ingredientProductId, String? ingredientProductName, String? ingredientVariationId, String? ingredientVariationName, String qtyRequired, String wastagePct, List<VariationModel> variations
});




}
/// @nodoc
class _$BomLineFormItemCopyWithImpl<$Res>
    implements $BomLineFormItemCopyWith<$Res> {
  _$BomLineFormItemCopyWithImpl(this._self, this._then);

  final BomLineFormItem _self;
  final $Res Function(BomLineFormItem) _then;

/// Create a copy of BomLineFormItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingredientProductId = freezed,Object? ingredientProductName = freezed,Object? ingredientVariationId = freezed,Object? ingredientVariationName = freezed,Object? qtyRequired = null,Object? wastagePct = null,Object? variations = null,}) {
  return _then(BomLineFormItem(
ingredientProductId: freezed == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String?,ingredientProductName: freezed == ingredientProductName ? _self.ingredientProductName : ingredientProductName // ignore: cast_nullable_to_non_nullable
as String?,ingredientVariationId: freezed == ingredientVariationId ? _self.ingredientVariationId : ingredientVariationId // ignore: cast_nullable_to_non_nullable
as String?,ingredientVariationName: freezed == ingredientVariationName ? _self.ingredientVariationName : ingredientVariationName // ignore: cast_nullable_to_non_nullable
as String?,qtyRequired: null == qtyRequired ? _self.qtyRequired : qtyRequired // ignore: cast_nullable_to_non_nullable
as String,wastagePct: null == wastagePct ? _self.wastagePct : wastagePct // ignore: cast_nullable_to_non_nullable
as String,variations: null == variations ? _self.variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BomLineFormItem].
extension BomLineFormItemPatterns on BomLineFormItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BomLineFormItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BomLineFormItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BomLineFormItem value)  $default,){
final _that = this;
switch (_that) {
case _BomLineFormItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BomLineFormItem value)?  $default,){
final _that = this;
switch (_that) {
case _BomLineFormItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ingredientProductId,  String? ingredientProductName,  String? ingredientVariationId,  String? ingredientVariationName,  String qtyRequired,  String wastagePct,  List<VariationModel> variations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BomLineFormItem() when $default != null:
return $default(_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.ingredientVariationName,_that.qtyRequired,_that.wastagePct,_that.variations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ingredientProductId,  String? ingredientProductName,  String? ingredientVariationId,  String? ingredientVariationName,  String qtyRequired,  String wastagePct,  List<VariationModel> variations)  $default,) {final _that = this;
switch (_that) {
case _BomLineFormItem():
return $default(_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.ingredientVariationName,_that.qtyRequired,_that.wastagePct,_that.variations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ingredientProductId,  String? ingredientProductName,  String? ingredientVariationId,  String? ingredientVariationName,  String qtyRequired,  String wastagePct,  List<VariationModel> variations)?  $default,) {final _that = this;
switch (_that) {
case _BomLineFormItem() when $default != null:
return $default(_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.ingredientVariationName,_that.qtyRequired,_that.wastagePct,_that.variations);case _:
  return null;

}
}

}

/// @nodoc


class _BomLineFormItem extends BomLineFormItem {
  const _BomLineFormItem({this.ingredientProductId, this.ingredientProductName, this.ingredientVariationId, this.ingredientVariationName, this.qtyRequired = '', this.wastagePct = '0',  List<VariationModel> variations = const []}): _variations = variations,super._();
  

@override final  String? ingredientProductId;
@override final  String? ingredientProductName;
@override final  String? ingredientVariationId;
@override final  String? ingredientVariationName;
@override@JsonKey() final  String qtyRequired;
@override@JsonKey() final  String wastagePct;
 final  List<VariationModel> _variations;
@override@JsonKey() List<VariationModel> get variations {
  if (_variations is EqualUnmodifiableListView) return _variations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variations);
}


/// Create a copy of BomLineFormItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BomLineFormItemCopyWith<_BomLineFormItem> get copyWith => __$BomLineFormItemCopyWithImpl<_BomLineFormItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BomLineFormItem&&(identical(other.ingredientProductId, ingredientProductId) || other.ingredientProductId == ingredientProductId)&&(identical(other.ingredientProductName, ingredientProductName) || other.ingredientProductName == ingredientProductName)&&(identical(other.ingredientVariationId, ingredientVariationId) || other.ingredientVariationId == ingredientVariationId)&&(identical(other.ingredientVariationName, ingredientVariationName) || other.ingredientVariationName == ingredientVariationName)&&(identical(other.qtyRequired, qtyRequired) || other.qtyRequired == qtyRequired)&&(identical(other.wastagePct, wastagePct) || other.wastagePct == wastagePct)&&const DeepCollectionEquality().equals(other.variations, _variations));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ingredientProductId,ingredientProductName,ingredientVariationId,ingredientVariationName,qtyRequired,wastagePct,const DeepCollectionEquality().hash(_variations));
}

@override
String toString() {
    return 'BomLineFormItem(ingredientProductId: $ingredientProductId, ingredientProductName: $ingredientProductName, ingredientVariationId: $ingredientVariationId, ingredientVariationName: $ingredientVariationName, qtyRequired: $qtyRequired, wastagePct: $wastagePct, variations: $variations)';
}


}

/// @nodoc
abstract mixin class _$BomLineFormItemCopyWith<$Res> implements $BomLineFormItemCopyWith<$Res> {
  factory _$BomLineFormItemCopyWith(_BomLineFormItem value, $Res Function(_BomLineFormItem) _then) = __$BomLineFormItemCopyWithImpl;
@override @useResult
$Res call({
 String? ingredientProductId, String? ingredientProductName, String? ingredientVariationId, String? ingredientVariationName, String qtyRequired, String wastagePct, List<VariationModel> variations
});




}
/// @nodoc
class __$BomLineFormItemCopyWithImpl<$Res>
    implements _$BomLineFormItemCopyWith<$Res> {
  __$BomLineFormItemCopyWithImpl(this._self, this._then);

  final _BomLineFormItem _self;
  final $Res Function(_BomLineFormItem) _then;

/// Create a copy of BomLineFormItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingredientProductId = freezed,Object? ingredientProductName = freezed,Object? ingredientVariationId = freezed,Object? ingredientVariationName = freezed,Object? qtyRequired = null,Object? wastagePct = null,Object? variations = null,}) {
  return _then(_BomLineFormItem(
ingredientProductId: freezed == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String?,ingredientProductName: freezed == ingredientProductName ? _self.ingredientProductName : ingredientProductName // ignore: cast_nullable_to_non_nullable
as String?,ingredientVariationId: freezed == ingredientVariationId ? _self.ingredientVariationId : ingredientVariationId // ignore: cast_nullable_to_non_nullable
as String?,ingredientVariationName: freezed == ingredientVariationName ? _self.ingredientVariationName : ingredientVariationName // ignore: cast_nullable_to_non_nullable
as String?,qtyRequired: null == qtyRequired ? _self.qtyRequired : qtyRequired // ignore: cast_nullable_to_non_nullable
as String,wastagePct: null == wastagePct ? _self.wastagePct : wastagePct // ignore: cast_nullable_to_non_nullable
as String,variations: null == variations ? _self._variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,
  ));
}


}

/// @nodoc
mixin _$BomFormState {

 String? get bomId; String? get productId; String? get productName; String? get variationId; String? get variationName; List<VariationModel> get finishedVariations; String get name; String get outputQty; bool get isActive; List<BomLineFormItem> get lines; List<ProductListItemModel> get manufacturedProducts; List<ProductListItemModel> get ingredientProducts; String get previewBatchQty; List<BomQtyPreviewLine> get previewLines; bool get isLoading; bool get isSubmitting; bool get isDeleting; Map<String, String> get errors;
/// Create a copy of BomFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomFormStateCopyWith<BomFormState> get copyWith => _$BomFormStateCopyWithImpl<BomFormState>(this as BomFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BomFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BomFormState&&(identical(other.bomId, _this.bomId) || other.bomId == _this.bomId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.variationName, _this.variationName) || other.variationName == _this.variationName)&&const DeepCollectionEquality().equals(other.finishedVariations, _this.finishedVariations)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.outputQty, _this.outputQty) || other.outputQty == _this.outputQty)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.manufacturedProducts, _this.manufacturedProducts)&&const DeepCollectionEquality().equals(other.ingredientProducts, _this.ingredientProducts)&&(identical(other.previewBatchQty, _this.previewBatchQty) || other.previewBatchQty == _this.previewBatchQty)&&const DeepCollectionEquality().equals(other.previewLines, _this.previewLines)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as BomFormState;
  return Object.hash(runtimeType,_this.bomId,_this.productId,_this.productName,_this.variationId,_this.variationName,const DeepCollectionEquality().hash(_this.finishedVariations),_this.name,_this.outputQty,_this.isActive,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.manufacturedProducts),const DeepCollectionEquality().hash(_this.ingredientProducts),_this.previewBatchQty,const DeepCollectionEquality().hash(_this.previewLines),_this.isLoading,_this.isSubmitting,_this.isDeleting,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as BomFormState;
  return 'BomFormState(bomId: ${_this.bomId}, productId: ${_this.productId}, productName: ${_this.productName}, variationId: ${_this.variationId}, variationName: ${_this.variationName}, finishedVariations: ${_this.finishedVariations}, name: ${_this.name}, outputQty: ${_this.outputQty}, isActive: ${_this.isActive}, lines: ${_this.lines}, manufacturedProducts: ${_this.manufacturedProducts}, ingredientProducts: ${_this.ingredientProducts}, previewBatchQty: ${_this.previewBatchQty}, previewLines: ${_this.previewLines}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, isDeleting: ${_this.isDeleting}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $BomFormStateCopyWith<$Res>  {
  factory $BomFormStateCopyWith(BomFormState value, $Res Function(BomFormState) _then) = _$BomFormStateCopyWithImpl;
@useResult
$Res call({
 String? bomId, String? productId, String? productName, String? variationId, String? variationName, List<VariationModel> finishedVariations, String name, String outputQty, bool isActive, List<BomLineFormItem> lines, List<ProductListItemModel> manufacturedProducts, List<ProductListItemModel> ingredientProducts, String previewBatchQty, List<BomQtyPreviewLine> previewLines, bool isLoading, bool isSubmitting, bool isDeleting, Map<String, String> errors
});




}
/// @nodoc
class _$BomFormStateCopyWithImpl<$Res>
    implements $BomFormStateCopyWith<$Res> {
  _$BomFormStateCopyWithImpl(this._self, this._then);

  final BomFormState _self;
  final $Res Function(BomFormState) _then;

/// Create a copy of BomFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bomId = freezed,Object? productId = freezed,Object? productName = freezed,Object? variationId = freezed,Object? variationName = freezed,Object? finishedVariations = null,Object? name = null,Object? outputQty = null,Object? isActive = null,Object? lines = null,Object? manufacturedProducts = null,Object? ingredientProducts = null,Object? previewBatchQty = null,Object? previewLines = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? errors = null,}) {
  return _then(BomFormState(
bomId: freezed == bomId ? _self.bomId : bomId // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,finishedVariations: null == finishedVariations ? _self.finishedVariations : finishedVariations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<BomLineFormItem>,manufacturedProducts: null == manufacturedProducts ? _self.manufacturedProducts : manufacturedProducts // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,ingredientProducts: null == ingredientProducts ? _self.ingredientProducts : ingredientProducts // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,previewBatchQty: null == previewBatchQty ? _self.previewBatchQty : previewBatchQty // ignore: cast_nullable_to_non_nullable
as String,previewLines: null == previewLines ? _self.previewLines : previewLines // ignore: cast_nullable_to_non_nullable
as List<BomQtyPreviewLine>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BomFormState].
extension BomFormStatePatterns on BomFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BomFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BomFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BomFormState value)  $default,){
final _that = this;
switch (_that) {
case _BomFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BomFormState value)?  $default,){
final _that = this;
switch (_that) {
case _BomFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? bomId,  String? productId,  String? productName,  String? variationId,  String? variationName,  List<VariationModel> finishedVariations,  String name,  String outputQty,  bool isActive,  List<BomLineFormItem> lines,  List<ProductListItemModel> manufacturedProducts,  List<ProductListItemModel> ingredientProducts,  String previewBatchQty,  List<BomQtyPreviewLine> previewLines,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BomFormState() when $default != null:
return $default(_that.bomId,_that.productId,_that.productName,_that.variationId,_that.variationName,_that.finishedVariations,_that.name,_that.outputQty,_that.isActive,_that.lines,_that.manufacturedProducts,_that.ingredientProducts,_that.previewBatchQty,_that.previewLines,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? bomId,  String? productId,  String? productName,  String? variationId,  String? variationName,  List<VariationModel> finishedVariations,  String name,  String outputQty,  bool isActive,  List<BomLineFormItem> lines,  List<ProductListItemModel> manufacturedProducts,  List<ProductListItemModel> ingredientProducts,  String previewBatchQty,  List<BomQtyPreviewLine> previewLines,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _BomFormState():
return $default(_that.bomId,_that.productId,_that.productName,_that.variationId,_that.variationName,_that.finishedVariations,_that.name,_that.outputQty,_that.isActive,_that.lines,_that.manufacturedProducts,_that.ingredientProducts,_that.previewBatchQty,_that.previewLines,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? bomId,  String? productId,  String? productName,  String? variationId,  String? variationName,  List<VariationModel> finishedVariations,  String name,  String outputQty,  bool isActive,  List<BomLineFormItem> lines,  List<ProductListItemModel> manufacturedProducts,  List<ProductListItemModel> ingredientProducts,  String previewBatchQty,  List<BomQtyPreviewLine> previewLines,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _BomFormState() when $default != null:
return $default(_that.bomId,_that.productId,_that.productName,_that.variationId,_that.variationName,_that.finishedVariations,_that.name,_that.outputQty,_that.isActive,_that.lines,_that.manufacturedProducts,_that.ingredientProducts,_that.previewBatchQty,_that.previewLines,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _BomFormState extends BomFormState {
  const _BomFormState({this.bomId, this.productId, this.productName, this.variationId, this.variationName,  List<VariationModel> finishedVariations = const [], this.name = '', this.outputQty = '1', this.isActive = true,  List<BomLineFormItem> lines = const [],  List<ProductListItemModel> manufacturedProducts = const [],  List<ProductListItemModel> ingredientProducts = const [], this.previewBatchQty = '1',  List<BomQtyPreviewLine> previewLines = const [], this.isLoading = false, this.isSubmitting = false, this.isDeleting = false,  Map<String, String> errors = const {}}): _finishedVariations = finishedVariations,_lines = lines,_manufacturedProducts = manufacturedProducts,_ingredientProducts = ingredientProducts,_previewLines = previewLines,_errors = errors,super._();
  

@override final  String? bomId;
@override final  String? productId;
@override final  String? productName;
@override final  String? variationId;
@override final  String? variationName;
 final  List<VariationModel> _finishedVariations;
@override@JsonKey() List<VariationModel> get finishedVariations {
  if (_finishedVariations is EqualUnmodifiableListView) return _finishedVariations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finishedVariations);
}

@override@JsonKey() final  String name;
@override@JsonKey() final  String outputQty;
@override@JsonKey() final  bool isActive;
 final  List<BomLineFormItem> _lines;
@override@JsonKey() List<BomLineFormItem> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<ProductListItemModel> _manufacturedProducts;
@override@JsonKey() List<ProductListItemModel> get manufacturedProducts {
  if (_manufacturedProducts is EqualUnmodifiableListView) return _manufacturedProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_manufacturedProducts);
}

 final  List<ProductListItemModel> _ingredientProducts;
@override@JsonKey() List<ProductListItemModel> get ingredientProducts {
  if (_ingredientProducts is EqualUnmodifiableListView) return _ingredientProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientProducts);
}

@override@JsonKey() final  String previewBatchQty;
 final  List<BomQtyPreviewLine> _previewLines;
@override@JsonKey() List<BomQtyPreviewLine> get previewLines {
  if (_previewLines is EqualUnmodifiableListView) return _previewLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_previewLines);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isDeleting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of BomFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BomFormStateCopyWith<_BomFormState> get copyWith => __$BomFormStateCopyWithImpl<_BomFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BomFormState&&(identical(other.bomId, bomId) || other.bomId == bomId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.variationName, variationName) || other.variationName == variationName)&&const DeepCollectionEquality().equals(other.finishedVariations, _finishedVariations)&&(identical(other.name, name) || other.name == name)&&(identical(other.outputQty, outputQty) || other.outputQty == outputQty)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.manufacturedProducts, _manufacturedProducts)&&const DeepCollectionEquality().equals(other.ingredientProducts, _ingredientProducts)&&(identical(other.previewBatchQty, previewBatchQty) || other.previewBatchQty == previewBatchQty)&&const DeepCollectionEquality().equals(other.previewLines, _previewLines)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bomId,productId,productName,variationId,variationName,const DeepCollectionEquality().hash(_finishedVariations),name,outputQty,isActive,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_manufacturedProducts),const DeepCollectionEquality().hash(_ingredientProducts),previewBatchQty,const DeepCollectionEquality().hash(_previewLines),isLoading,isSubmitting,isDeleting,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'BomFormState(bomId: $bomId, productId: $productId, productName: $productName, variationId: $variationId, variationName: $variationName, finishedVariations: $finishedVariations, name: $name, outputQty: $outputQty, isActive: $isActive, lines: $lines, manufacturedProducts: $manufacturedProducts, ingredientProducts: $ingredientProducts, previewBatchQty: $previewBatchQty, previewLines: $previewLines, isLoading: $isLoading, isSubmitting: $isSubmitting, isDeleting: $isDeleting, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$BomFormStateCopyWith<$Res> implements $BomFormStateCopyWith<$Res> {
  factory _$BomFormStateCopyWith(_BomFormState value, $Res Function(_BomFormState) _then) = __$BomFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? bomId, String? productId, String? productName, String? variationId, String? variationName, List<VariationModel> finishedVariations, String name, String outputQty, bool isActive, List<BomLineFormItem> lines, List<ProductListItemModel> manufacturedProducts, List<ProductListItemModel> ingredientProducts, String previewBatchQty, List<BomQtyPreviewLine> previewLines, bool isLoading, bool isSubmitting, bool isDeleting, Map<String, String> errors
});




}
/// @nodoc
class __$BomFormStateCopyWithImpl<$Res>
    implements _$BomFormStateCopyWith<$Res> {
  __$BomFormStateCopyWithImpl(this._self, this._then);

  final _BomFormState _self;
  final $Res Function(_BomFormState) _then;

/// Create a copy of BomFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bomId = freezed,Object? productId = freezed,Object? productName = freezed,Object? variationId = freezed,Object? variationName = freezed,Object? finishedVariations = null,Object? name = null,Object? outputQty = null,Object? isActive = null,Object? lines = null,Object? manufacturedProducts = null,Object? ingredientProducts = null,Object? previewBatchQty = null,Object? previewLines = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? errors = null,}) {
  return _then(_BomFormState(
bomId: freezed == bomId ? _self.bomId : bomId // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,finishedVariations: null == finishedVariations ? _self._finishedVariations : finishedVariations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<BomLineFormItem>,manufacturedProducts: null == manufacturedProducts ? _self._manufacturedProducts : manufacturedProducts // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,ingredientProducts: null == ingredientProducts ? _self._ingredientProducts : ingredientProducts // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,previewBatchQty: null == previewBatchQty ? _self.previewBatchQty : previewBatchQty // ignore: cast_nullable_to_non_nullable
as String,previewLines: null == previewLines ? _self._previewLines : previewLines // ignore: cast_nullable_to_non_nullable
as List<BomQtyPreviewLine>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
