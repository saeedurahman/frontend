// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleReturnLineModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'sale_return_id') String get saleReturnId;@JsonKey(name: 'sale_line_id') String? get saleLineId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId; String get qty;@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'tax_amount') String get taxAmount;
/// Create a copy of SaleReturnLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnLineModelCopyWith<SaleReturnLineModel> get copyWith => _$SaleReturnLineModelCopyWithImpl<SaleReturnLineModel>(this as SaleReturnLineModel, _$identity);

  /// Serializes this SaleReturnLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleReturnLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.saleReturnId, _this.saleReturnId) || other.saleReturnId == _this.saleReturnId)&&(identical(other.saleLineId, _this.saleLineId) || other.saleLineId == _this.saleLineId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleReturnLineModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.saleReturnId,_this.saleLineId,_this.productId,_this.variationId,_this.qty,_this.unitPrice,_this.taxAmount);
}

@override
String toString() {
  final _this = this as SaleReturnLineModel;
  return 'SaleReturnLineModel(id: ${_this.id}, businessId: ${_this.businessId}, saleReturnId: ${_this.saleReturnId}, saleLineId: ${_this.saleLineId}, productId: ${_this.productId}, variationId: ${_this.variationId}, qty: ${_this.qty}, unitPrice: ${_this.unitPrice}, taxAmount: ${_this.taxAmount})';
}


}

/// @nodoc
abstract mixin class $SaleReturnLineModelCopyWith<$Res>  {
  factory $SaleReturnLineModelCopyWith(SaleReturnLineModel value, $Res Function(SaleReturnLineModel) _then) = _$SaleReturnLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'sale_return_id') String saleReturnId,@JsonKey(name: 'sale_line_id') String? saleLineId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'tax_amount') String taxAmount
});




}
/// @nodoc
class _$SaleReturnLineModelCopyWithImpl<$Res>
    implements $SaleReturnLineModelCopyWith<$Res> {
  _$SaleReturnLineModelCopyWithImpl(this._self, this._then);

  final SaleReturnLineModel _self;
  final $Res Function(SaleReturnLineModel) _then;

/// Create a copy of SaleReturnLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? saleReturnId = null,Object? saleLineId = freezed,Object? productId = null,Object? variationId = freezed,Object? qty = null,Object? unitPrice = null,Object? taxAmount = null,}) {
  return _then(SaleReturnLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,saleReturnId: null == saleReturnId ? _self.saleReturnId : saleReturnId // ignore: cast_nullable_to_non_nullable
as String,saleLineId: freezed == saleLineId ? _self.saleLineId : saleLineId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnLineModel].
extension SaleReturnLineModelPatterns on SaleReturnLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnLineModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'sale_line_id')  String? saleLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'tax_amount')  String taxAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnLineModel() when $default != null:
return $default(_that.id,_that.businessId,_that.saleReturnId,_that.saleLineId,_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.taxAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'sale_line_id')  String? saleLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'tax_amount')  String taxAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnLineModel():
return $default(_that.id,_that.businessId,_that.saleReturnId,_that.saleLineId,_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.taxAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'sale_line_id')  String? saleLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'tax_amount')  String taxAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnLineModel() when $default != null:
return $default(_that.id,_that.businessId,_that.saleReturnId,_that.saleLineId,_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.taxAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnLineModel implements SaleReturnLineModel {
  const _SaleReturnLineModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'sale_return_id') required this.saleReturnId, @JsonKey(name: 'sale_line_id') this.saleLineId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, required this.qty, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'tax_amount') this.taxAmount = '0'});
  factory _SaleReturnLineModel.fromJson(Map<String, dynamic> json) => _$SaleReturnLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'sale_return_id') final  String saleReturnId;
@override@JsonKey(name: 'sale_line_id') final  String? saleLineId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override final  String qty;
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'tax_amount') final  String taxAmount;

/// Create a copy of SaleReturnLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnLineModelCopyWith<_SaleReturnLineModel> get copyWith => __$SaleReturnLineModelCopyWithImpl<_SaleReturnLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.saleReturnId, saleReturnId) || other.saleReturnId == saleReturnId)&&(identical(other.saleLineId, saleLineId) || other.saleLineId == saleLineId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,saleReturnId,saleLineId,productId,variationId,qty,unitPrice,taxAmount);
}

@override
String toString() {
    return 'SaleReturnLineModel(id: $id, businessId: $businessId, saleReturnId: $saleReturnId, saleLineId: $saleLineId, productId: $productId, variationId: $variationId, qty: $qty, unitPrice: $unitPrice, taxAmount: $taxAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnLineModelCopyWith<$Res> implements $SaleReturnLineModelCopyWith<$Res> {
  factory _$SaleReturnLineModelCopyWith(_SaleReturnLineModel value, $Res Function(_SaleReturnLineModel) _then) = __$SaleReturnLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'sale_return_id') String saleReturnId,@JsonKey(name: 'sale_line_id') String? saleLineId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'tax_amount') String taxAmount
});




}
/// @nodoc
class __$SaleReturnLineModelCopyWithImpl<$Res>
    implements _$SaleReturnLineModelCopyWith<$Res> {
  __$SaleReturnLineModelCopyWithImpl(this._self, this._then);

  final _SaleReturnLineModel _self;
  final $Res Function(_SaleReturnLineModel) _then;

/// Create a copy of SaleReturnLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? saleReturnId = null,Object? saleLineId = freezed,Object? productId = null,Object? variationId = freezed,Object? qty = null,Object? unitPrice = null,Object? taxAmount = null,}) {
  return _then(_SaleReturnLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,saleReturnId: null == saleReturnId ? _self.saleReturnId : saleReturnId // ignore: cast_nullable_to_non_nullable
as String,saleLineId: freezed == saleLineId ? _self.saleLineId : saleLineId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
