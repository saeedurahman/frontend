// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BarcodeModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId; String get barcode;@JsonKey(name: 'barcode_type') String get barcodeType;@JsonKey(name: 'is_primary') bool get isPrimary;
/// Create a copy of BarcodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarcodeModelCopyWith<BarcodeModel> get copyWith => _$BarcodeModelCopyWithImpl<BarcodeModel>(this as BarcodeModel, _$identity);

  /// Serializes this BarcodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BarcodeModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarcodeModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.barcodeType, _this.barcodeType) || other.barcodeType == _this.barcodeType)&&(identical(other.isPrimary, _this.isPrimary) || other.isPrimary == _this.isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BarcodeModel;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.variationId,_this.barcode,_this.barcodeType,_this.isPrimary);
}

@override
String toString() {
  final _this = this as BarcodeModel;
  return 'BarcodeModel(id: ${_this.id}, productId: ${_this.productId}, variationId: ${_this.variationId}, barcode: ${_this.barcode}, barcodeType: ${_this.barcodeType}, isPrimary: ${_this.isPrimary})';
}


}

/// @nodoc
abstract mixin class $BarcodeModelCopyWith<$Res>  {
  factory $BarcodeModelCopyWith(BarcodeModel value, $Res Function(BarcodeModel) _then) = _$BarcodeModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String barcode,@JsonKey(name: 'barcode_type') String barcodeType,@JsonKey(name: 'is_primary') bool isPrimary
});




}
/// @nodoc
class _$BarcodeModelCopyWithImpl<$Res>
    implements $BarcodeModelCopyWith<$Res> {
  _$BarcodeModelCopyWithImpl(this._self, this._then);

  final BarcodeModel _self;
  final $Res Function(BarcodeModel) _then;

/// Create a copy of BarcodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? variationId = freezed,Object? barcode = null,Object? barcodeType = null,Object? isPrimary = null,}) {
  return _then(BarcodeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BarcodeModel].
extension BarcodeModelPatterns on BarcodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarcodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarcodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarcodeModel value)  $default,){
final _that = this;
switch (_that) {
case _BarcodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarcodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _BarcodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String barcode, @JsonKey(name: 'barcode_type')  String barcodeType, @JsonKey(name: 'is_primary')  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarcodeModel() when $default != null:
return $default(_that.id,_that.productId,_that.variationId,_that.barcode,_that.barcodeType,_that.isPrimary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String barcode, @JsonKey(name: 'barcode_type')  String barcodeType, @JsonKey(name: 'is_primary')  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _BarcodeModel():
return $default(_that.id,_that.productId,_that.variationId,_that.barcode,_that.barcodeType,_that.isPrimary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String barcode, @JsonKey(name: 'barcode_type')  String barcodeType, @JsonKey(name: 'is_primary')  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _BarcodeModel() when $default != null:
return $default(_that.id,_that.productId,_that.variationId,_that.barcode,_that.barcodeType,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BarcodeModel implements BarcodeModel {
  const _BarcodeModel({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, required this.barcode, @JsonKey(name: 'barcode_type') this.barcodeType = 'EAN13', @JsonKey(name: 'is_primary') this.isPrimary = false});
  factory _BarcodeModel.fromJson(Map<String, dynamic> json) => _$BarcodeModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override final  String barcode;
@override@JsonKey(name: 'barcode_type') final  String barcodeType;
@override@JsonKey(name: 'is_primary') final  bool isPrimary;

/// Create a copy of BarcodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarcodeModelCopyWith<_BarcodeModel> get copyWith => __$BarcodeModelCopyWithImpl<_BarcodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BarcodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarcodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,variationId,barcode,barcodeType,isPrimary);
}

@override
String toString() {
    return 'BarcodeModel(id: $id, productId: $productId, variationId: $variationId, barcode: $barcode, barcodeType: $barcodeType, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$BarcodeModelCopyWith<$Res> implements $BarcodeModelCopyWith<$Res> {
  factory _$BarcodeModelCopyWith(_BarcodeModel value, $Res Function(_BarcodeModel) _then) = __$BarcodeModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String barcode,@JsonKey(name: 'barcode_type') String barcodeType,@JsonKey(name: 'is_primary') bool isPrimary
});




}
/// @nodoc
class __$BarcodeModelCopyWithImpl<$Res>
    implements _$BarcodeModelCopyWith<$Res> {
  __$BarcodeModelCopyWithImpl(this._self, this._then);

  final _BarcodeModel _self;
  final $Res Function(_BarcodeModel) _then;

/// Create a copy of BarcodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? variationId = freezed,Object? barcode = null,Object? barcodeType = null,Object? isPrimary = null,}) {
  return _then(_BarcodeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
