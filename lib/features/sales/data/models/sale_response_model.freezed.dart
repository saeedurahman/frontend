// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleLineModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId; String get qty;@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'discount_pct') String get discountPct;@JsonKey(name: 'discount_amount') String get discountAmount;@JsonKey(name: 'tax_rate') String get taxRate;@JsonKey(name: 'tax_amount') String? get taxAmount;@JsonKey(name: 'net_amount') String? get netAmount;@JsonKey(name: 'line_total') String? get lineTotal; String? get notes;@JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull) int? get lineOrder;@JsonKey(name: 'product_name') String? get productName;@JsonKey(name: 'variation_name') String? get variationName;@JsonKey(name: 'returned_qty') String get returnedQty;
/// Create a copy of SaleLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleLineModelCopyWith<SaleLineModel> get copyWith => _$SaleLineModelCopyWithImpl<SaleLineModel>(this as SaleLineModel, _$identity);

  /// Serializes this SaleLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.discountPct, _this.discountPct) || other.discountPct == _this.discountPct)&&(identical(other.discountAmount, _this.discountAmount) || other.discountAmount == _this.discountAmount)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount)&&(identical(other.netAmount, _this.netAmount) || other.netAmount == _this.netAmount)&&(identical(other.lineTotal, _this.lineTotal) || other.lineTotal == _this.lineTotal)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.lineOrder, _this.lineOrder) || other.lineOrder == _this.lineOrder)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationName, _this.variationName) || other.variationName == _this.variationName)&&(identical(other.returnedQty, _this.returnedQty) || other.returnedQty == _this.returnedQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleLineModel;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.variationId,_this.qty,_this.unitPrice,_this.discountPct,_this.discountAmount,_this.taxRate,_this.taxAmount,_this.netAmount,_this.lineTotal,_this.notes,_this.lineOrder,_this.productName,_this.variationName,_this.returnedQty);
}

@override
String toString() {
  final _this = this as SaleLineModel;
  return 'SaleLineModel(id: ${_this.id}, productId: ${_this.productId}, variationId: ${_this.variationId}, qty: ${_this.qty}, unitPrice: ${_this.unitPrice}, discountPct: ${_this.discountPct}, discountAmount: ${_this.discountAmount}, taxRate: ${_this.taxRate}, taxAmount: ${_this.taxAmount}, netAmount: ${_this.netAmount}, lineTotal: ${_this.lineTotal}, notes: ${_this.notes}, lineOrder: ${_this.lineOrder}, productName: ${_this.productName}, variationName: ${_this.variationName}, returnedQty: ${_this.returnedQty})';
}


}

/// @nodoc
abstract mixin class $SaleLineModelCopyWith<$Res>  {
  factory $SaleLineModelCopyWith(SaleLineModel value, $Res Function(SaleLineModel) _then) = _$SaleLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'discount_pct') String discountPct,@JsonKey(name: 'discount_amount') String discountAmount,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'tax_amount') String? taxAmount,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'line_total') String? lineTotal, String? notes,@JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull) int? lineOrder,@JsonKey(name: 'product_name') String? productName,@JsonKey(name: 'variation_name') String? variationName,@JsonKey(name: 'returned_qty') String returnedQty
});




}
/// @nodoc
class _$SaleLineModelCopyWithImpl<$Res>
    implements $SaleLineModelCopyWith<$Res> {
  _$SaleLineModelCopyWithImpl(this._self, this._then);

  final SaleLineModel _self;
  final $Res Function(SaleLineModel) _then;

/// Create a copy of SaleLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? variationId = freezed,Object? qty = null,Object? unitPrice = null,Object? discountPct = null,Object? discountAmount = null,Object? taxRate = null,Object? taxAmount = freezed,Object? netAmount = freezed,Object? lineTotal = freezed,Object? notes = freezed,Object? lineOrder = freezed,Object? productName = freezed,Object? variationName = freezed,Object? returnedQty = null,}) {
  return _then(SaleLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String?,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,lineTotal: freezed == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lineOrder: freezed == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,returnedQty: null == returnedQty ? _self.returnedQty : returnedQty // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleLineModel].
extension SaleLineModelPatterns on SaleLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleLineModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'discount_pct')  String discountPct, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'tax_amount')  String? taxAmount, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'line_total')  String? lineTotal,  String? notes, @JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull)  int? lineOrder, @JsonKey(name: 'product_name')  String? productName, @JsonKey(name: 'variation_name')  String? variationName, @JsonKey(name: 'returned_qty')  String returnedQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleLineModel() when $default != null:
return $default(_that.id,_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.discountPct,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.netAmount,_that.lineTotal,_that.notes,_that.lineOrder,_that.productName,_that.variationName,_that.returnedQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'discount_pct')  String discountPct, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'tax_amount')  String? taxAmount, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'line_total')  String? lineTotal,  String? notes, @JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull)  int? lineOrder, @JsonKey(name: 'product_name')  String? productName, @JsonKey(name: 'variation_name')  String? variationName, @JsonKey(name: 'returned_qty')  String returnedQty)  $default,) {final _that = this;
switch (_that) {
case _SaleLineModel():
return $default(_that.id,_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.discountPct,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.netAmount,_that.lineTotal,_that.notes,_that.lineOrder,_that.productName,_that.variationName,_that.returnedQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'discount_pct')  String discountPct, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'tax_amount')  String? taxAmount, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'line_total')  String? lineTotal,  String? notes, @JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull)  int? lineOrder, @JsonKey(name: 'product_name')  String? productName, @JsonKey(name: 'variation_name')  String? variationName, @JsonKey(name: 'returned_qty')  String returnedQty)?  $default,) {final _that = this;
switch (_that) {
case _SaleLineModel() when $default != null:
return $default(_that.id,_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.discountPct,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.netAmount,_that.lineTotal,_that.notes,_that.lineOrder,_that.productName,_that.variationName,_that.returnedQty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleLineModel implements SaleLineModel {
  const _SaleLineModel({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, required this.qty, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'discount_pct') this.discountPct = '0', @JsonKey(name: 'discount_amount') this.discountAmount = '0', @JsonKey(name: 'tax_rate') this.taxRate = '0', @JsonKey(name: 'tax_amount') this.taxAmount, @JsonKey(name: 'net_amount') this.netAmount, @JsonKey(name: 'line_total') this.lineTotal, this.notes, @JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull) this.lineOrder, @JsonKey(name: 'product_name') this.productName, @JsonKey(name: 'variation_name') this.variationName, @JsonKey(name: 'returned_qty') this.returnedQty = '0'});
  factory _SaleLineModel.fromJson(Map<String, dynamic> json) => _$SaleLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override final  String qty;
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'discount_pct') final  String discountPct;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;
@override@JsonKey(name: 'tax_rate') final  String taxRate;
@override@JsonKey(name: 'tax_amount') final  String? taxAmount;
@override@JsonKey(name: 'net_amount') final  String? netAmount;
@override@JsonKey(name: 'line_total') final  String? lineTotal;
@override final  String? notes;
@override@JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull) final  int? lineOrder;
@override@JsonKey(name: 'product_name') final  String? productName;
@override@JsonKey(name: 'variation_name') final  String? variationName;
@override@JsonKey(name: 'returned_qty') final  String returnedQty;

/// Create a copy of SaleLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleLineModelCopyWith<_SaleLineModel> get copyWith => __$SaleLineModelCopyWithImpl<_SaleLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discountPct, discountPct) || other.discountPct == discountPct)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.lineOrder, lineOrder) || other.lineOrder == lineOrder)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationName, variationName) || other.variationName == variationName)&&(identical(other.returnedQty, returnedQty) || other.returnedQty == returnedQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,variationId,qty,unitPrice,discountPct,discountAmount,taxRate,taxAmount,netAmount,lineTotal,notes,lineOrder,productName,variationName,returnedQty);
}

@override
String toString() {
    return 'SaleLineModel(id: $id, productId: $productId, variationId: $variationId, qty: $qty, unitPrice: $unitPrice, discountPct: $discountPct, discountAmount: $discountAmount, taxRate: $taxRate, taxAmount: $taxAmount, netAmount: $netAmount, lineTotal: $lineTotal, notes: $notes, lineOrder: $lineOrder, productName: $productName, variationName: $variationName, returnedQty: $returnedQty)';
}


}

/// @nodoc
abstract mixin class _$SaleLineModelCopyWith<$Res> implements $SaleLineModelCopyWith<$Res> {
  factory _$SaleLineModelCopyWith(_SaleLineModel value, $Res Function(_SaleLineModel) _then) = __$SaleLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'discount_pct') String discountPct,@JsonKey(name: 'discount_amount') String discountAmount,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'tax_amount') String? taxAmount,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'line_total') String? lineTotal, String? notes,@JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull) int? lineOrder,@JsonKey(name: 'product_name') String? productName,@JsonKey(name: 'variation_name') String? variationName,@JsonKey(name: 'returned_qty') String returnedQty
});




}
/// @nodoc
class __$SaleLineModelCopyWithImpl<$Res>
    implements _$SaleLineModelCopyWith<$Res> {
  __$SaleLineModelCopyWithImpl(this._self, this._then);

  final _SaleLineModel _self;
  final $Res Function(_SaleLineModel) _then;

/// Create a copy of SaleLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? variationId = freezed,Object? qty = null,Object? unitPrice = null,Object? discountPct = null,Object? discountAmount = null,Object? taxRate = null,Object? taxAmount = freezed,Object? netAmount = freezed,Object? lineTotal = freezed,Object? notes = freezed,Object? lineOrder = freezed,Object? productName = freezed,Object? variationName = freezed,Object? returnedQty = null,}) {
  return _then(_SaleLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String?,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,lineTotal: freezed == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lineOrder: freezed == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,returnedQty: null == returnedQty ? _self.returnedQty : returnedQty // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaleTaxBreakdownModel {

@JsonKey(name: 'tax_label') String? get taxLabel;@JsonKey(name: 'tax_rate') String get taxRate;@JsonKey(name: 'net_amount') String get netAmount;@JsonKey(name: 'tax_amount') String get taxAmount;
/// Create a copy of SaleTaxBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleTaxBreakdownModelCopyWith<SaleTaxBreakdownModel> get copyWith => _$SaleTaxBreakdownModelCopyWithImpl<SaleTaxBreakdownModel>(this as SaleTaxBreakdownModel, _$identity);

  /// Serializes this SaleTaxBreakdownModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleTaxBreakdownModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleTaxBreakdownModel&&(identical(other.taxLabel, _this.taxLabel) || other.taxLabel == _this.taxLabel)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.netAmount, _this.netAmount) || other.netAmount == _this.netAmount)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleTaxBreakdownModel;
  return Object.hash(runtimeType,_this.taxLabel,_this.taxRate,_this.netAmount,_this.taxAmount);
}

@override
String toString() {
  final _this = this as SaleTaxBreakdownModel;
  return 'SaleTaxBreakdownModel(taxLabel: ${_this.taxLabel}, taxRate: ${_this.taxRate}, netAmount: ${_this.netAmount}, taxAmount: ${_this.taxAmount})';
}


}

/// @nodoc
abstract mixin class $SaleTaxBreakdownModelCopyWith<$Res>  {
  factory $SaleTaxBreakdownModelCopyWith(SaleTaxBreakdownModel value, $Res Function(SaleTaxBreakdownModel) _then) = _$SaleTaxBreakdownModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tax_label') String? taxLabel,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'net_amount') String netAmount,@JsonKey(name: 'tax_amount') String taxAmount
});




}
/// @nodoc
class _$SaleTaxBreakdownModelCopyWithImpl<$Res>
    implements $SaleTaxBreakdownModelCopyWith<$Res> {
  _$SaleTaxBreakdownModelCopyWithImpl(this._self, this._then);

  final SaleTaxBreakdownModel _self;
  final $Res Function(SaleTaxBreakdownModel) _then;

/// Create a copy of SaleTaxBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taxLabel = freezed,Object? taxRate = null,Object? netAmount = null,Object? taxAmount = null,}) {
  return _then(SaleTaxBreakdownModel(
taxLabel: freezed == taxLabel ? _self.taxLabel : taxLabel // ignore: cast_nullable_to_non_nullable
as String?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleTaxBreakdownModel].
extension SaleTaxBreakdownModelPatterns on SaleTaxBreakdownModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleTaxBreakdownModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleTaxBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleTaxBreakdownModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleTaxBreakdownModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleTaxBreakdownModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleTaxBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tax_label')  String? taxLabel, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'net_amount')  String netAmount, @JsonKey(name: 'tax_amount')  String taxAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleTaxBreakdownModel() when $default != null:
return $default(_that.taxLabel,_that.taxRate,_that.netAmount,_that.taxAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tax_label')  String? taxLabel, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'net_amount')  String netAmount, @JsonKey(name: 'tax_amount')  String taxAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleTaxBreakdownModel():
return $default(_that.taxLabel,_that.taxRate,_that.netAmount,_that.taxAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tax_label')  String? taxLabel, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'net_amount')  String netAmount, @JsonKey(name: 'tax_amount')  String taxAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleTaxBreakdownModel() when $default != null:
return $default(_that.taxLabel,_that.taxRate,_that.netAmount,_that.taxAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleTaxBreakdownModel implements SaleTaxBreakdownModel {
  const _SaleTaxBreakdownModel({@JsonKey(name: 'tax_label') this.taxLabel, @JsonKey(name: 'tax_rate') this.taxRate = '0', @JsonKey(name: 'net_amount') this.netAmount = '0', @JsonKey(name: 'tax_amount') this.taxAmount = '0'});
  factory _SaleTaxBreakdownModel.fromJson(Map<String, dynamic> json) => _$SaleTaxBreakdownModelFromJson(json);

@override@JsonKey(name: 'tax_label') final  String? taxLabel;
@override@JsonKey(name: 'tax_rate') final  String taxRate;
@override@JsonKey(name: 'net_amount') final  String netAmount;
@override@JsonKey(name: 'tax_amount') final  String taxAmount;

/// Create a copy of SaleTaxBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleTaxBreakdownModelCopyWith<_SaleTaxBreakdownModel> get copyWith => __$SaleTaxBreakdownModelCopyWithImpl<_SaleTaxBreakdownModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleTaxBreakdownModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleTaxBreakdownModel&&(identical(other.taxLabel, taxLabel) || other.taxLabel == taxLabel)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,taxLabel,taxRate,netAmount,taxAmount);
}

@override
String toString() {
    return 'SaleTaxBreakdownModel(taxLabel: $taxLabel, taxRate: $taxRate, netAmount: $netAmount, taxAmount: $taxAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleTaxBreakdownModelCopyWith<$Res> implements $SaleTaxBreakdownModelCopyWith<$Res> {
  factory _$SaleTaxBreakdownModelCopyWith(_SaleTaxBreakdownModel value, $Res Function(_SaleTaxBreakdownModel) _then) = __$SaleTaxBreakdownModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tax_label') String? taxLabel,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'net_amount') String netAmount,@JsonKey(name: 'tax_amount') String taxAmount
});




}
/// @nodoc
class __$SaleTaxBreakdownModelCopyWithImpl<$Res>
    implements _$SaleTaxBreakdownModelCopyWith<$Res> {
  __$SaleTaxBreakdownModelCopyWithImpl(this._self, this._then);

  final _SaleTaxBreakdownModel _self;
  final $Res Function(_SaleTaxBreakdownModel) _then;

/// Create a copy of SaleTaxBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taxLabel = freezed,Object? taxRate = null,Object? netAmount = null,Object? taxAmount = null,}) {
  return _then(_SaleTaxBreakdownModel(
taxLabel: freezed == taxLabel ? _self.taxLabel : taxLabel // ignore: cast_nullable_to_non_nullable
as String?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SalePaymentModel {

 String get id;@JsonKey(name: 'payment_method') String get paymentMethod; String get amount;@JsonKey(name: 'reference_no') String? get referenceNo;@JsonKey(name: 'paid_at') String? get paidAt;
/// Create a copy of SalePaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalePaymentModelCopyWith<SalePaymentModel> get copyWith => _$SalePaymentModelCopyWithImpl<SalePaymentModel>(this as SalePaymentModel, _$identity);

  /// Serializes this SalePaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalePaymentModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalePaymentModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.referenceNo, _this.referenceNo) || other.referenceNo == _this.referenceNo)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalePaymentModel;
  return Object.hash(runtimeType,_this.id,_this.paymentMethod,_this.amount,_this.referenceNo,_this.paidAt);
}

@override
String toString() {
  final _this = this as SalePaymentModel;
  return 'SalePaymentModel(id: ${_this.id}, paymentMethod: ${_this.paymentMethod}, amount: ${_this.amount}, referenceNo: ${_this.referenceNo}, paidAt: ${_this.paidAt})';
}


}

/// @nodoc
abstract mixin class $SalePaymentModelCopyWith<$Res>  {
  factory $SalePaymentModelCopyWith(SalePaymentModel value, $Res Function(SalePaymentModel) _then) = _$SalePaymentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'payment_method') String paymentMethod, String amount,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'paid_at') String? paidAt
});




}
/// @nodoc
class _$SalePaymentModelCopyWithImpl<$Res>
    implements $SalePaymentModelCopyWith<$Res> {
  _$SalePaymentModelCopyWithImpl(this._self, this._then);

  final SalePaymentModel _self;
  final $Res Function(SalePaymentModel) _then;

/// Create a copy of SalePaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? paymentMethod = null,Object? amount = null,Object? referenceNo = freezed,Object? paidAt = freezed,}) {
  return _then(SalePaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalePaymentModel].
extension SalePaymentModelPatterns on SalePaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalePaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalePaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalePaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _SalePaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalePaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalePaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalePaymentModel() when $default != null:
return $default(_that.id,_that.paymentMethod,_that.amount,_that.referenceNo,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt)  $default,) {final _that = this;
switch (_that) {
case _SalePaymentModel():
return $default(_that.id,_that.paymentMethod,_that.amount,_that.referenceNo,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _SalePaymentModel() when $default != null:
return $default(_that.id,_that.paymentMethod,_that.amount,_that.referenceNo,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalePaymentModel implements SalePaymentModel {
  const _SalePaymentModel({required this.id, @JsonKey(name: 'payment_method') required this.paymentMethod, required this.amount, @JsonKey(name: 'reference_no') this.referenceNo, @JsonKey(name: 'paid_at') this.paidAt});
  factory _SalePaymentModel.fromJson(Map<String, dynamic> json) => _$SalePaymentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override final  String amount;
@override@JsonKey(name: 'reference_no') final  String? referenceNo;
@override@JsonKey(name: 'paid_at') final  String? paidAt;

/// Create a copy of SalePaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalePaymentModelCopyWith<_SalePaymentModel> get copyWith => __$SalePaymentModelCopyWithImpl<_SalePaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalePaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalePaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,paymentMethod,amount,referenceNo,paidAt);
}

@override
String toString() {
    return 'SalePaymentModel(id: $id, paymentMethod: $paymentMethod, amount: $amount, referenceNo: $referenceNo, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$SalePaymentModelCopyWith<$Res> implements $SalePaymentModelCopyWith<$Res> {
  factory _$SalePaymentModelCopyWith(_SalePaymentModel value, $Res Function(_SalePaymentModel) _then) = __$SalePaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'payment_method') String paymentMethod, String amount,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'paid_at') String? paidAt
});




}
/// @nodoc
class __$SalePaymentModelCopyWithImpl<$Res>
    implements _$SalePaymentModelCopyWith<$Res> {
  __$SalePaymentModelCopyWithImpl(this._self, this._then);

  final _SalePaymentModel _self;
  final $Res Function(_SalePaymentModel) _then;

/// Create a copy of SalePaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paymentMethod = null,Object? amount = null,Object? referenceNo = freezed,Object? paidAt = freezed,}) {
  return _then(_SalePaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SaleResponseModel {

 String get id;@JsonKey(name: 'sale_number') String? get saleNumber;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'customer_id') String? get customerId;@JsonKey(name: 'table_id') String? get tableId;@JsonKey(name: 'sale_type') String get saleType;@JsonKey(name: 'sale_status', readValue: _readSaleStatus) String get saleStatus;@JsonKey(name: 'register_shift_id') String? get registerShiftId;@JsonKey(name: 'subtotal') String? get subtotal;@JsonKey(name: 'total_discount') String? get totalDiscount;@JsonKey(name: 'total_tax') String? get totalTax;@JsonKey(name: 'net_amount') String? get netAmount;@JsonKey(name: 'exact_total') String? get exactTotal;@JsonKey(name: 'rounding_amount') String get roundingAmount;@JsonKey(name: 'tax_inclusive', readValue: _readBool) bool get taxInclusive;@JsonKey(name: 'tax_rounding_mode') String get taxRoundingMode;@JsonKey(name: 'tax_label') String? get taxLabel;@JsonKey(name: 'show_tax_breakdown') bool? get showTaxBreakdown;@JsonKey(name: 'tax_breakdown') List<SaleTaxBreakdownModel> get taxBreakdown;@JsonKey(name: 'total_amount') String get totalAmount;@JsonKey(name: 'total_paid') String? get totalPaid; String? get notes;@JsonKey(name: 'sold_at') String? get soldAt;@JsonKey(name: 'created_at') String? get createdAt; CustomerModel? get customer; List<SaleLineModel> get lines; List<SalePaymentModel> get payments;@JsonKey(name: 'offline') bool get offline;
/// Create a copy of SaleResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleResponseModelCopyWith<SaleResponseModel> get copyWith => _$SaleResponseModelCopyWithImpl<SaleResponseModel>(this as SaleResponseModel, _$identity);

  /// Serializes this SaleResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleResponseModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.saleNumber, _this.saleNumber) || other.saleNumber == _this.saleNumber)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.saleType, _this.saleType) || other.saleType == _this.saleType)&&(identical(other.saleStatus, _this.saleStatus) || other.saleStatus == _this.saleStatus)&&(identical(other.registerShiftId, _this.registerShiftId) || other.registerShiftId == _this.registerShiftId)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.totalDiscount, _this.totalDiscount) || other.totalDiscount == _this.totalDiscount)&&(identical(other.totalTax, _this.totalTax) || other.totalTax == _this.totalTax)&&(identical(other.netAmount, _this.netAmount) || other.netAmount == _this.netAmount)&&(identical(other.exactTotal, _this.exactTotal) || other.exactTotal == _this.exactTotal)&&(identical(other.roundingAmount, _this.roundingAmount) || other.roundingAmount == _this.roundingAmount)&&(identical(other.taxInclusive, _this.taxInclusive) || other.taxInclusive == _this.taxInclusive)&&(identical(other.taxRoundingMode, _this.taxRoundingMode) || other.taxRoundingMode == _this.taxRoundingMode)&&(identical(other.taxLabel, _this.taxLabel) || other.taxLabel == _this.taxLabel)&&(identical(other.showTaxBreakdown, _this.showTaxBreakdown) || other.showTaxBreakdown == _this.showTaxBreakdown)&&const DeepCollectionEquality().equals(other.taxBreakdown, _this.taxBreakdown)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.totalPaid, _this.totalPaid) || other.totalPaid == _this.totalPaid)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.soldAt, _this.soldAt) || other.soldAt == _this.soldAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&(identical(other.offline, _this.offline) || other.offline == _this.offline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleResponseModel;
  return Object.hashAll([runtimeType,_this.id,_this.saleNumber,_this.branchId,_this.customerId,_this.tableId,_this.saleType,_this.saleStatus,_this.registerShiftId,_this.subtotal,_this.totalDiscount,_this.totalTax,_this.netAmount,_this.exactTotal,_this.roundingAmount,_this.taxInclusive,_this.taxRoundingMode,_this.taxLabel,_this.showTaxBreakdown,const DeepCollectionEquality().hash(_this.taxBreakdown),_this.totalAmount,_this.totalPaid,_this.notes,_this.soldAt,_this.createdAt,_this.customer,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.payments),_this.offline]);
}

@override
String toString() {
  final _this = this as SaleResponseModel;
  return 'SaleResponseModel(id: ${_this.id}, saleNumber: ${_this.saleNumber}, branchId: ${_this.branchId}, customerId: ${_this.customerId}, tableId: ${_this.tableId}, saleType: ${_this.saleType}, saleStatus: ${_this.saleStatus}, registerShiftId: ${_this.registerShiftId}, subtotal: ${_this.subtotal}, totalDiscount: ${_this.totalDiscount}, totalTax: ${_this.totalTax}, netAmount: ${_this.netAmount}, exactTotal: ${_this.exactTotal}, roundingAmount: ${_this.roundingAmount}, taxInclusive: ${_this.taxInclusive}, taxRoundingMode: ${_this.taxRoundingMode}, taxLabel: ${_this.taxLabel}, showTaxBreakdown: ${_this.showTaxBreakdown}, taxBreakdown: ${_this.taxBreakdown}, totalAmount: ${_this.totalAmount}, totalPaid: ${_this.totalPaid}, notes: ${_this.notes}, soldAt: ${_this.soldAt}, createdAt: ${_this.createdAt}, customer: ${_this.customer}, lines: ${_this.lines}, payments: ${_this.payments}, offline: ${_this.offline})';
}


}

/// @nodoc
abstract mixin class $SaleResponseModelCopyWith<$Res>  {
  factory $SaleResponseModelCopyWith(SaleResponseModel value, $Res Function(SaleResponseModel) _then) = _$SaleResponseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sale_number') String? saleNumber,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'table_id') String? tableId,@JsonKey(name: 'sale_type') String saleType,@JsonKey(name: 'sale_status', readValue: _readSaleStatus) String saleStatus,@JsonKey(name: 'register_shift_id') String? registerShiftId,@JsonKey(name: 'subtotal') String? subtotal,@JsonKey(name: 'total_discount') String? totalDiscount,@JsonKey(name: 'total_tax') String? totalTax,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'exact_total') String? exactTotal,@JsonKey(name: 'rounding_amount') String roundingAmount,@JsonKey(name: 'tax_inclusive', readValue: _readBool) bool taxInclusive,@JsonKey(name: 'tax_rounding_mode') String taxRoundingMode,@JsonKey(name: 'tax_label') String? taxLabel,@JsonKey(name: 'show_tax_breakdown') bool? showTaxBreakdown,@JsonKey(name: 'tax_breakdown') List<SaleTaxBreakdownModel> taxBreakdown,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'total_paid') String? totalPaid, String? notes,@JsonKey(name: 'sold_at') String? soldAt,@JsonKey(name: 'created_at') String? createdAt, CustomerModel? customer, List<SaleLineModel> lines, List<SalePaymentModel> payments,@JsonKey(name: 'offline') bool offline
});


$CustomerModelCopyWith<$Res>? get customer;

}
/// @nodoc
class _$SaleResponseModelCopyWithImpl<$Res>
    implements $SaleResponseModelCopyWith<$Res> {
  _$SaleResponseModelCopyWithImpl(this._self, this._then);

  final SaleResponseModel _self;
  final $Res Function(SaleResponseModel) _then;

/// Create a copy of SaleResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleNumber = freezed,Object? branchId = null,Object? customerId = freezed,Object? tableId = freezed,Object? saleType = null,Object? saleStatus = null,Object? registerShiftId = freezed,Object? subtotal = freezed,Object? totalDiscount = freezed,Object? totalTax = freezed,Object? netAmount = freezed,Object? exactTotal = freezed,Object? roundingAmount = null,Object? taxInclusive = null,Object? taxRoundingMode = null,Object? taxLabel = freezed,Object? showTaxBreakdown = freezed,Object? taxBreakdown = null,Object? totalAmount = null,Object? totalPaid = freezed,Object? notes = freezed,Object? soldAt = freezed,Object? createdAt = freezed,Object? customer = freezed,Object? lines = null,Object? payments = null,Object? offline = null,}) {
  return _then(SaleResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleNumber: freezed == saleNumber ? _self.saleNumber : saleNumber // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,saleType: null == saleType ? _self.saleType : saleType // ignore: cast_nullable_to_non_nullable
as String,saleStatus: null == saleStatus ? _self.saleStatus : saleStatus // ignore: cast_nullable_to_non_nullable
as String,registerShiftId: freezed == registerShiftId ? _self.registerShiftId : registerShiftId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String?,totalDiscount: freezed == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as String?,totalTax: freezed == totalTax ? _self.totalTax : totalTax // ignore: cast_nullable_to_non_nullable
as String?,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,exactTotal: freezed == exactTotal ? _self.exactTotal : exactTotal // ignore: cast_nullable_to_non_nullable
as String?,roundingAmount: null == roundingAmount ? _self.roundingAmount : roundingAmount // ignore: cast_nullable_to_non_nullable
as String,taxInclusive: null == taxInclusive ? _self.taxInclusive : taxInclusive // ignore: cast_nullable_to_non_nullable
as bool,taxRoundingMode: null == taxRoundingMode ? _self.taxRoundingMode : taxRoundingMode // ignore: cast_nullable_to_non_nullable
as String,taxLabel: freezed == taxLabel ? _self.taxLabel : taxLabel // ignore: cast_nullable_to_non_nullable
as String?,showTaxBreakdown: freezed == showTaxBreakdown ? _self.showTaxBreakdown : showTaxBreakdown // ignore: cast_nullable_to_non_nullable
as bool?,taxBreakdown: null == taxBreakdown ? _self.taxBreakdown : taxBreakdown // ignore: cast_nullable_to_non_nullable
as List<SaleTaxBreakdownModel>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,totalPaid: freezed == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,soldAt: freezed == soldAt ? _self.soldAt : soldAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerModel?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleLineModel>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<SalePaymentModel>,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SaleResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerModelCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [SaleResponseModel].
extension SaleResponseModelPatterns on SaleResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_number')  String? saleNumber, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'table_id')  String? tableId, @JsonKey(name: 'sale_type')  String saleType, @JsonKey(name: 'sale_status', readValue: _readSaleStatus)  String saleStatus, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'subtotal')  String? subtotal, @JsonKey(name: 'total_discount')  String? totalDiscount, @JsonKey(name: 'total_tax')  String? totalTax, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'exact_total')  String? exactTotal, @JsonKey(name: 'rounding_amount')  String roundingAmount, @JsonKey(name: 'tax_inclusive', readValue: _readBool)  bool taxInclusive, @JsonKey(name: 'tax_rounding_mode')  String taxRoundingMode, @JsonKey(name: 'tax_label')  String? taxLabel, @JsonKey(name: 'show_tax_breakdown')  bool? showTaxBreakdown, @JsonKey(name: 'tax_breakdown')  List<SaleTaxBreakdownModel> taxBreakdown, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'total_paid')  String? totalPaid,  String? notes, @JsonKey(name: 'sold_at')  String? soldAt, @JsonKey(name: 'created_at')  String? createdAt,  CustomerModel? customer,  List<SaleLineModel> lines,  List<SalePaymentModel> payments, @JsonKey(name: 'offline')  bool offline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleResponseModel() when $default != null:
return $default(_that.id,_that.saleNumber,_that.branchId,_that.customerId,_that.tableId,_that.saleType,_that.saleStatus,_that.registerShiftId,_that.subtotal,_that.totalDiscount,_that.totalTax,_that.netAmount,_that.exactTotal,_that.roundingAmount,_that.taxInclusive,_that.taxRoundingMode,_that.taxLabel,_that.showTaxBreakdown,_that.taxBreakdown,_that.totalAmount,_that.totalPaid,_that.notes,_that.soldAt,_that.createdAt,_that.customer,_that.lines,_that.payments,_that.offline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_number')  String? saleNumber, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'table_id')  String? tableId, @JsonKey(name: 'sale_type')  String saleType, @JsonKey(name: 'sale_status', readValue: _readSaleStatus)  String saleStatus, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'subtotal')  String? subtotal, @JsonKey(name: 'total_discount')  String? totalDiscount, @JsonKey(name: 'total_tax')  String? totalTax, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'exact_total')  String? exactTotal, @JsonKey(name: 'rounding_amount')  String roundingAmount, @JsonKey(name: 'tax_inclusive', readValue: _readBool)  bool taxInclusive, @JsonKey(name: 'tax_rounding_mode')  String taxRoundingMode, @JsonKey(name: 'tax_label')  String? taxLabel, @JsonKey(name: 'show_tax_breakdown')  bool? showTaxBreakdown, @JsonKey(name: 'tax_breakdown')  List<SaleTaxBreakdownModel> taxBreakdown, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'total_paid')  String? totalPaid,  String? notes, @JsonKey(name: 'sold_at')  String? soldAt, @JsonKey(name: 'created_at')  String? createdAt,  CustomerModel? customer,  List<SaleLineModel> lines,  List<SalePaymentModel> payments, @JsonKey(name: 'offline')  bool offline)  $default,) {final _that = this;
switch (_that) {
case _SaleResponseModel():
return $default(_that.id,_that.saleNumber,_that.branchId,_that.customerId,_that.tableId,_that.saleType,_that.saleStatus,_that.registerShiftId,_that.subtotal,_that.totalDiscount,_that.totalTax,_that.netAmount,_that.exactTotal,_that.roundingAmount,_that.taxInclusive,_that.taxRoundingMode,_that.taxLabel,_that.showTaxBreakdown,_that.taxBreakdown,_that.totalAmount,_that.totalPaid,_that.notes,_that.soldAt,_that.createdAt,_that.customer,_that.lines,_that.payments,_that.offline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sale_number')  String? saleNumber, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'table_id')  String? tableId, @JsonKey(name: 'sale_type')  String saleType, @JsonKey(name: 'sale_status', readValue: _readSaleStatus)  String saleStatus, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'subtotal')  String? subtotal, @JsonKey(name: 'total_discount')  String? totalDiscount, @JsonKey(name: 'total_tax')  String? totalTax, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'exact_total')  String? exactTotal, @JsonKey(name: 'rounding_amount')  String roundingAmount, @JsonKey(name: 'tax_inclusive', readValue: _readBool)  bool taxInclusive, @JsonKey(name: 'tax_rounding_mode')  String taxRoundingMode, @JsonKey(name: 'tax_label')  String? taxLabel, @JsonKey(name: 'show_tax_breakdown')  bool? showTaxBreakdown, @JsonKey(name: 'tax_breakdown')  List<SaleTaxBreakdownModel> taxBreakdown, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'total_paid')  String? totalPaid,  String? notes, @JsonKey(name: 'sold_at')  String? soldAt, @JsonKey(name: 'created_at')  String? createdAt,  CustomerModel? customer,  List<SaleLineModel> lines,  List<SalePaymentModel> payments, @JsonKey(name: 'offline')  bool offline)?  $default,) {final _that = this;
switch (_that) {
case _SaleResponseModel() when $default != null:
return $default(_that.id,_that.saleNumber,_that.branchId,_that.customerId,_that.tableId,_that.saleType,_that.saleStatus,_that.registerShiftId,_that.subtotal,_that.totalDiscount,_that.totalTax,_that.netAmount,_that.exactTotal,_that.roundingAmount,_that.taxInclusive,_that.taxRoundingMode,_that.taxLabel,_that.showTaxBreakdown,_that.taxBreakdown,_that.totalAmount,_that.totalPaid,_that.notes,_that.soldAt,_that.createdAt,_that.customer,_that.lines,_that.payments,_that.offline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleResponseModel implements SaleResponseModel {
  const _SaleResponseModel({required this.id, @JsonKey(name: 'sale_number') this.saleNumber, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'customer_id') this.customerId, @JsonKey(name: 'table_id') this.tableId, @JsonKey(name: 'sale_type') required this.saleType, @JsonKey(name: 'sale_status', readValue: _readSaleStatus) required this.saleStatus, @JsonKey(name: 'register_shift_id') this.registerShiftId, @JsonKey(name: 'subtotal') this.subtotal, @JsonKey(name: 'total_discount') this.totalDiscount, @JsonKey(name: 'total_tax') this.totalTax, @JsonKey(name: 'net_amount') this.netAmount, @JsonKey(name: 'exact_total') this.exactTotal, @JsonKey(name: 'rounding_amount') this.roundingAmount = '0', @JsonKey(name: 'tax_inclusive', readValue: _readBool) this.taxInclusive = false, @JsonKey(name: 'tax_rounding_mode') this.taxRoundingMode = 'none', @JsonKey(name: 'tax_label') this.taxLabel, @JsonKey(name: 'show_tax_breakdown') this.showTaxBreakdown, @JsonKey(name: 'tax_breakdown')  List<SaleTaxBreakdownModel> taxBreakdown = const [], @JsonKey(name: 'total_amount') this.totalAmount = '0', @JsonKey(name: 'total_paid') this.totalPaid, this.notes, @JsonKey(name: 'sold_at') this.soldAt, @JsonKey(name: 'created_at') this.createdAt, this.customer,  List<SaleLineModel> lines = const [],  List<SalePaymentModel> payments = const [], @JsonKey(name: 'offline') this.offline = false}): _taxBreakdown = taxBreakdown,_lines = lines,_payments = payments;
  factory _SaleResponseModel.fromJson(Map<String, dynamic> json) => _$SaleResponseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sale_number') final  String? saleNumber;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'customer_id') final  String? customerId;
@override@JsonKey(name: 'table_id') final  String? tableId;
@override@JsonKey(name: 'sale_type') final  String saleType;
@override@JsonKey(name: 'sale_status', readValue: _readSaleStatus) final  String saleStatus;
@override@JsonKey(name: 'register_shift_id') final  String? registerShiftId;
@override@JsonKey(name: 'subtotal') final  String? subtotal;
@override@JsonKey(name: 'total_discount') final  String? totalDiscount;
@override@JsonKey(name: 'total_tax') final  String? totalTax;
@override@JsonKey(name: 'net_amount') final  String? netAmount;
@override@JsonKey(name: 'exact_total') final  String? exactTotal;
@override@JsonKey(name: 'rounding_amount') final  String roundingAmount;
@override@JsonKey(name: 'tax_inclusive', readValue: _readBool) final  bool taxInclusive;
@override@JsonKey(name: 'tax_rounding_mode') final  String taxRoundingMode;
@override@JsonKey(name: 'tax_label') final  String? taxLabel;
@override@JsonKey(name: 'show_tax_breakdown') final  bool? showTaxBreakdown;
 final  List<SaleTaxBreakdownModel> _taxBreakdown;
@override@JsonKey(name: 'tax_breakdown') List<SaleTaxBreakdownModel> get taxBreakdown {
  if (_taxBreakdown is EqualUnmodifiableListView) return _taxBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taxBreakdown);
}

@override@JsonKey(name: 'total_amount') final  String totalAmount;
@override@JsonKey(name: 'total_paid') final  String? totalPaid;
@override final  String? notes;
@override@JsonKey(name: 'sold_at') final  String? soldAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override final  CustomerModel? customer;
 final  List<SaleLineModel> _lines;
@override@JsonKey() List<SaleLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<SalePaymentModel> _payments;
@override@JsonKey() List<SalePaymentModel> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override@JsonKey(name: 'offline') final  bool offline;

/// Create a copy of SaleResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleResponseModelCopyWith<_SaleResponseModel> get copyWith => __$SaleResponseModelCopyWithImpl<_SaleResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.saleNumber, saleNumber) || other.saleNumber == saleNumber)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.saleType, saleType) || other.saleType == saleType)&&(identical(other.saleStatus, saleStatus) || other.saleStatus == saleStatus)&&(identical(other.registerShiftId, registerShiftId) || other.registerShiftId == registerShiftId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.totalTax, totalTax) || other.totalTax == totalTax)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.exactTotal, exactTotal) || other.exactTotal == exactTotal)&&(identical(other.roundingAmount, roundingAmount) || other.roundingAmount == roundingAmount)&&(identical(other.taxInclusive, taxInclusive) || other.taxInclusive == taxInclusive)&&(identical(other.taxRoundingMode, taxRoundingMode) || other.taxRoundingMode == taxRoundingMode)&&(identical(other.taxLabel, taxLabel) || other.taxLabel == taxLabel)&&(identical(other.showTaxBreakdown, showTaxBreakdown) || other.showTaxBreakdown == showTaxBreakdown)&&const DeepCollectionEquality().equals(other.taxBreakdown, _taxBreakdown)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.soldAt, soldAt) || other.soldAt == soldAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.payments, _payments)&&(identical(other.offline, offline) || other.offline == offline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,saleNumber,branchId,customerId,tableId,saleType,saleStatus,registerShiftId,subtotal,totalDiscount,totalTax,netAmount,exactTotal,roundingAmount,taxInclusive,taxRoundingMode,taxLabel,showTaxBreakdown,const DeepCollectionEquality().hash(_taxBreakdown),totalAmount,totalPaid,notes,soldAt,createdAt,customer,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_payments),offline]);
}

@override
String toString() {
    return 'SaleResponseModel(id: $id, saleNumber: $saleNumber, branchId: $branchId, customerId: $customerId, tableId: $tableId, saleType: $saleType, saleStatus: $saleStatus, registerShiftId: $registerShiftId, subtotal: $subtotal, totalDiscount: $totalDiscount, totalTax: $totalTax, netAmount: $netAmount, exactTotal: $exactTotal, roundingAmount: $roundingAmount, taxInclusive: $taxInclusive, taxRoundingMode: $taxRoundingMode, taxLabel: $taxLabel, showTaxBreakdown: $showTaxBreakdown, taxBreakdown: $taxBreakdown, totalAmount: $totalAmount, totalPaid: $totalPaid, notes: $notes, soldAt: $soldAt, createdAt: $createdAt, customer: $customer, lines: $lines, payments: $payments, offline: $offline)';
}


}

/// @nodoc
abstract mixin class _$SaleResponseModelCopyWith<$Res> implements $SaleResponseModelCopyWith<$Res> {
  factory _$SaleResponseModelCopyWith(_SaleResponseModel value, $Res Function(_SaleResponseModel) _then) = __$SaleResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sale_number') String? saleNumber,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'table_id') String? tableId,@JsonKey(name: 'sale_type') String saleType,@JsonKey(name: 'sale_status', readValue: _readSaleStatus) String saleStatus,@JsonKey(name: 'register_shift_id') String? registerShiftId,@JsonKey(name: 'subtotal') String? subtotal,@JsonKey(name: 'total_discount') String? totalDiscount,@JsonKey(name: 'total_tax') String? totalTax,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'exact_total') String? exactTotal,@JsonKey(name: 'rounding_amount') String roundingAmount,@JsonKey(name: 'tax_inclusive', readValue: _readBool) bool taxInclusive,@JsonKey(name: 'tax_rounding_mode') String taxRoundingMode,@JsonKey(name: 'tax_label') String? taxLabel,@JsonKey(name: 'show_tax_breakdown') bool? showTaxBreakdown,@JsonKey(name: 'tax_breakdown') List<SaleTaxBreakdownModel> taxBreakdown,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'total_paid') String? totalPaid, String? notes,@JsonKey(name: 'sold_at') String? soldAt,@JsonKey(name: 'created_at') String? createdAt, CustomerModel? customer, List<SaleLineModel> lines, List<SalePaymentModel> payments,@JsonKey(name: 'offline') bool offline
});


@override $CustomerModelCopyWith<$Res>? get customer;

}
/// @nodoc
class __$SaleResponseModelCopyWithImpl<$Res>
    implements _$SaleResponseModelCopyWith<$Res> {
  __$SaleResponseModelCopyWithImpl(this._self, this._then);

  final _SaleResponseModel _self;
  final $Res Function(_SaleResponseModel) _then;

/// Create a copy of SaleResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleNumber = freezed,Object? branchId = null,Object? customerId = freezed,Object? tableId = freezed,Object? saleType = null,Object? saleStatus = null,Object? registerShiftId = freezed,Object? subtotal = freezed,Object? totalDiscount = freezed,Object? totalTax = freezed,Object? netAmount = freezed,Object? exactTotal = freezed,Object? roundingAmount = null,Object? taxInclusive = null,Object? taxRoundingMode = null,Object? taxLabel = freezed,Object? showTaxBreakdown = freezed,Object? taxBreakdown = null,Object? totalAmount = null,Object? totalPaid = freezed,Object? notes = freezed,Object? soldAt = freezed,Object? createdAt = freezed,Object? customer = freezed,Object? lines = null,Object? payments = null,Object? offline = null,}) {
  return _then(_SaleResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleNumber: freezed == saleNumber ? _self.saleNumber : saleNumber // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,saleType: null == saleType ? _self.saleType : saleType // ignore: cast_nullable_to_non_nullable
as String,saleStatus: null == saleStatus ? _self.saleStatus : saleStatus // ignore: cast_nullable_to_non_nullable
as String,registerShiftId: freezed == registerShiftId ? _self.registerShiftId : registerShiftId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String?,totalDiscount: freezed == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as String?,totalTax: freezed == totalTax ? _self.totalTax : totalTax // ignore: cast_nullable_to_non_nullable
as String?,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,exactTotal: freezed == exactTotal ? _self.exactTotal : exactTotal // ignore: cast_nullable_to_non_nullable
as String?,roundingAmount: null == roundingAmount ? _self.roundingAmount : roundingAmount // ignore: cast_nullable_to_non_nullable
as String,taxInclusive: null == taxInclusive ? _self.taxInclusive : taxInclusive // ignore: cast_nullable_to_non_nullable
as bool,taxRoundingMode: null == taxRoundingMode ? _self.taxRoundingMode : taxRoundingMode // ignore: cast_nullable_to_non_nullable
as String,taxLabel: freezed == taxLabel ? _self.taxLabel : taxLabel // ignore: cast_nullable_to_non_nullable
as String?,showTaxBreakdown: freezed == showTaxBreakdown ? _self.showTaxBreakdown : showTaxBreakdown // ignore: cast_nullable_to_non_nullable
as bool?,taxBreakdown: null == taxBreakdown ? _self._taxBreakdown : taxBreakdown // ignore: cast_nullable_to_non_nullable
as List<SaleTaxBreakdownModel>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,totalPaid: freezed == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,soldAt: freezed == soldAt ? _self.soldAt : soldAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerModel?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleLineModel>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<SalePaymentModel>,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SaleResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerModelCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on
