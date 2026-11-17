// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_price_preview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalePricePreviewLineModel {

@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId; String get qty;@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) int get lineOrder;@JsonKey(name: 'line_subtotal') String get lineSubtotal;@JsonKey(name: 'discount_pct') String get discountPct;@JsonKey(name: 'discount_amount') String get discountAmount;@JsonKey(name: 'tax_rate') String get taxRate;@JsonKey(name: 'tax_amount') String get taxAmount;@JsonKey(name: 'net_amount') String? get netAmount;@JsonKey(name: 'line_total') String get lineTotal;
/// Create a copy of SalePricePreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalePricePreviewLineModelCopyWith<SalePricePreviewLineModel> get copyWith => _$SalePricePreviewLineModelCopyWithImpl<SalePricePreviewLineModel>(this as SalePricePreviewLineModel, _$identity);

  /// Serializes this SalePricePreviewLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalePricePreviewLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalePricePreviewLineModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.lineOrder, _this.lineOrder) || other.lineOrder == _this.lineOrder)&&(identical(other.lineSubtotal, _this.lineSubtotal) || other.lineSubtotal == _this.lineSubtotal)&&(identical(other.discountPct, _this.discountPct) || other.discountPct == _this.discountPct)&&(identical(other.discountAmount, _this.discountAmount) || other.discountAmount == _this.discountAmount)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount)&&(identical(other.netAmount, _this.netAmount) || other.netAmount == _this.netAmount)&&(identical(other.lineTotal, _this.lineTotal) || other.lineTotal == _this.lineTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalePricePreviewLineModel;
  return Object.hash(runtimeType,_this.productId,_this.variationId,_this.qty,_this.unitPrice,_this.lineOrder,_this.lineSubtotal,_this.discountPct,_this.discountAmount,_this.taxRate,_this.taxAmount,_this.netAmount,_this.lineTotal);
}

@override
String toString() {
  final _this = this as SalePricePreviewLineModel;
  return 'SalePricePreviewLineModel(productId: ${_this.productId}, variationId: ${_this.variationId}, qty: ${_this.qty}, unitPrice: ${_this.unitPrice}, lineOrder: ${_this.lineOrder}, lineSubtotal: ${_this.lineSubtotal}, discountPct: ${_this.discountPct}, discountAmount: ${_this.discountAmount}, taxRate: ${_this.taxRate}, taxAmount: ${_this.taxAmount}, netAmount: ${_this.netAmount}, lineTotal: ${_this.lineTotal})';
}


}

/// @nodoc
abstract mixin class $SalePricePreviewLineModelCopyWith<$Res>  {
  factory $SalePricePreviewLineModelCopyWith(SalePricePreviewLineModel value, $Res Function(SalePricePreviewLineModel) _then) = _$SalePricePreviewLineModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) int lineOrder,@JsonKey(name: 'line_subtotal') String lineSubtotal,@JsonKey(name: 'discount_pct') String discountPct,@JsonKey(name: 'discount_amount') String discountAmount,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'tax_amount') String taxAmount,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'line_total') String lineTotal
});




}
/// @nodoc
class _$SalePricePreviewLineModelCopyWithImpl<$Res>
    implements $SalePricePreviewLineModelCopyWith<$Res> {
  _$SalePricePreviewLineModelCopyWithImpl(this._self, this._then);

  final SalePricePreviewLineModel _self;
  final $Res Function(SalePricePreviewLineModel) _then;

/// Create a copy of SalePricePreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? variationId = freezed,Object? qty = null,Object? unitPrice = null,Object? lineOrder = null,Object? lineSubtotal = null,Object? discountPct = null,Object? discountAmount = null,Object? taxRate = null,Object? taxAmount = null,Object? netAmount = freezed,Object? lineTotal = null,}) {
  return _then(SalePricePreviewLineModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,lineOrder: null == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int,lineSubtotal: null == lineSubtotal ? _self.lineSubtotal : lineSubtotal // ignore: cast_nullable_to_non_nullable
as String,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SalePricePreviewLineModel].
extension SalePricePreviewLineModelPatterns on SalePricePreviewLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalePricePreviewLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalePricePreviewLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalePricePreviewLineModel value)  $default,){
final _that = this;
switch (_that) {
case _SalePricePreviewLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalePricePreviewLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalePricePreviewLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr)  int lineOrder, @JsonKey(name: 'line_subtotal')  String lineSubtotal, @JsonKey(name: 'discount_pct')  String discountPct, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'tax_amount')  String taxAmount, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'line_total')  String lineTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalePricePreviewLineModel() when $default != null:
return $default(_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.lineOrder,_that.lineSubtotal,_that.discountPct,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.netAmount,_that.lineTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr)  int lineOrder, @JsonKey(name: 'line_subtotal')  String lineSubtotal, @JsonKey(name: 'discount_pct')  String discountPct, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'tax_amount')  String taxAmount, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'line_total')  String lineTotal)  $default,) {final _that = this;
switch (_that) {
case _SalePricePreviewLineModel():
return $default(_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.lineOrder,_that.lineSubtotal,_that.discountPct,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.netAmount,_that.lineTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr)  int lineOrder, @JsonKey(name: 'line_subtotal')  String lineSubtotal, @JsonKey(name: 'discount_pct')  String discountPct, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'tax_amount')  String taxAmount, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'line_total')  String lineTotal)?  $default,) {final _that = this;
switch (_that) {
case _SalePricePreviewLineModel() when $default != null:
return $default(_that.productId,_that.variationId,_that.qty,_that.unitPrice,_that.lineOrder,_that.lineSubtotal,_that.discountPct,_that.discountAmount,_that.taxRate,_that.taxAmount,_that.netAmount,_that.lineTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalePricePreviewLineModel implements SalePricePreviewLineModel {
  const _SalePricePreviewLineModel({@JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, required this.qty, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr) this.lineOrder = 0, @JsonKey(name: 'line_subtotal') required this.lineSubtotal, @JsonKey(name: 'discount_pct') this.discountPct = '0', @JsonKey(name: 'discount_amount') this.discountAmount = '0', @JsonKey(name: 'tax_rate') this.taxRate = '0', @JsonKey(name: 'tax_amount') this.taxAmount = '0', @JsonKey(name: 'net_amount') this.netAmount, @JsonKey(name: 'line_total') required this.lineTotal});
  factory _SalePricePreviewLineModel.fromJson(Map<String, dynamic> json) => _$SalePricePreviewLineModelFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override final  String qty;
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) final  int lineOrder;
@override@JsonKey(name: 'line_subtotal') final  String lineSubtotal;
@override@JsonKey(name: 'discount_pct') final  String discountPct;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;
@override@JsonKey(name: 'tax_rate') final  String taxRate;
@override@JsonKey(name: 'tax_amount') final  String taxAmount;
@override@JsonKey(name: 'net_amount') final  String? netAmount;
@override@JsonKey(name: 'line_total') final  String lineTotal;

/// Create a copy of SalePricePreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalePricePreviewLineModelCopyWith<_SalePricePreviewLineModel> get copyWith => __$SalePricePreviewLineModelCopyWithImpl<_SalePricePreviewLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalePricePreviewLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalePricePreviewLineModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineOrder, lineOrder) || other.lineOrder == lineOrder)&&(identical(other.lineSubtotal, lineSubtotal) || other.lineSubtotal == lineSubtotal)&&(identical(other.discountPct, discountPct) || other.discountPct == discountPct)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,variationId,qty,unitPrice,lineOrder,lineSubtotal,discountPct,discountAmount,taxRate,taxAmount,netAmount,lineTotal);
}

@override
String toString() {
    return 'SalePricePreviewLineModel(productId: $productId, variationId: $variationId, qty: $qty, unitPrice: $unitPrice, lineOrder: $lineOrder, lineSubtotal: $lineSubtotal, discountPct: $discountPct, discountAmount: $discountAmount, taxRate: $taxRate, taxAmount: $taxAmount, netAmount: $netAmount, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class _$SalePricePreviewLineModelCopyWith<$Res> implements $SalePricePreviewLineModelCopyWith<$Res> {
  factory _$SalePricePreviewLineModelCopyWith(_SalePricePreviewLineModel value, $Res Function(_SalePricePreviewLineModel) _then) = __$SalePricePreviewLineModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) int lineOrder,@JsonKey(name: 'line_subtotal') String lineSubtotal,@JsonKey(name: 'discount_pct') String discountPct,@JsonKey(name: 'discount_amount') String discountAmount,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'tax_amount') String taxAmount,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'line_total') String lineTotal
});




}
/// @nodoc
class __$SalePricePreviewLineModelCopyWithImpl<$Res>
    implements _$SalePricePreviewLineModelCopyWith<$Res> {
  __$SalePricePreviewLineModelCopyWithImpl(this._self, this._then);

  final _SalePricePreviewLineModel _self;
  final $Res Function(_SalePricePreviewLineModel) _then;

/// Create a copy of SalePricePreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? variationId = freezed,Object? qty = null,Object? unitPrice = null,Object? lineOrder = null,Object? lineSubtotal = null,Object? discountPct = null,Object? discountAmount = null,Object? taxRate = null,Object? taxAmount = null,Object? netAmount = freezed,Object? lineTotal = null,}) {
  return _then(_SalePricePreviewLineModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,lineOrder: null == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int,lineSubtotal: null == lineSubtotal ? _self.lineSubtotal : lineSubtotal // ignore: cast_nullable_to_non_nullable
as String,discountPct: null == discountPct ? _self.discountPct : discountPct // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SalePricePreviewModel {

@JsonKey(name: 'discount_scheme_id') String? get discountSchemeId; String get subtotal;@JsonKey(name: 'total_discount') String get totalDiscount;@JsonKey(name: 'total_tax') String get totalTax;@JsonKey(name: 'net_amount') String? get netAmount;@JsonKey(name: 'exact_total') String? get exactTotal;@JsonKey(name: 'rounding_amount') String get roundingAmount;@JsonKey(name: 'tax_inclusive') bool get taxInclusive;@JsonKey(name: 'tax_rounding_mode') String get taxRoundingMode;@JsonKey(name: 'tax_label') String get taxLabel;@JsonKey(name: 'total_amount') String get totalAmount; List<SalePricePreviewLineModel> get lines;
/// Create a copy of SalePricePreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalePricePreviewModelCopyWith<SalePricePreviewModel> get copyWith => _$SalePricePreviewModelCopyWithImpl<SalePricePreviewModel>(this as SalePricePreviewModel, _$identity);

  /// Serializes this SalePricePreviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalePricePreviewModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalePricePreviewModel&&(identical(other.discountSchemeId, _this.discountSchemeId) || other.discountSchemeId == _this.discountSchemeId)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.totalDiscount, _this.totalDiscount) || other.totalDiscount == _this.totalDiscount)&&(identical(other.totalTax, _this.totalTax) || other.totalTax == _this.totalTax)&&(identical(other.netAmount, _this.netAmount) || other.netAmount == _this.netAmount)&&(identical(other.exactTotal, _this.exactTotal) || other.exactTotal == _this.exactTotal)&&(identical(other.roundingAmount, _this.roundingAmount) || other.roundingAmount == _this.roundingAmount)&&(identical(other.taxInclusive, _this.taxInclusive) || other.taxInclusive == _this.taxInclusive)&&(identical(other.taxRoundingMode, _this.taxRoundingMode) || other.taxRoundingMode == _this.taxRoundingMode)&&(identical(other.taxLabel, _this.taxLabel) || other.taxLabel == _this.taxLabel)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalePricePreviewModel;
  return Object.hash(runtimeType,_this.discountSchemeId,_this.subtotal,_this.totalDiscount,_this.totalTax,_this.netAmount,_this.exactTotal,_this.roundingAmount,_this.taxInclusive,_this.taxRoundingMode,_this.taxLabel,_this.totalAmount,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as SalePricePreviewModel;
  return 'SalePricePreviewModel(discountSchemeId: ${_this.discountSchemeId}, subtotal: ${_this.subtotal}, totalDiscount: ${_this.totalDiscount}, totalTax: ${_this.totalTax}, netAmount: ${_this.netAmount}, exactTotal: ${_this.exactTotal}, roundingAmount: ${_this.roundingAmount}, taxInclusive: ${_this.taxInclusive}, taxRoundingMode: ${_this.taxRoundingMode}, taxLabel: ${_this.taxLabel}, totalAmount: ${_this.totalAmount}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $SalePricePreviewModelCopyWith<$Res>  {
  factory $SalePricePreviewModelCopyWith(SalePricePreviewModel value, $Res Function(SalePricePreviewModel) _then) = _$SalePricePreviewModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'discount_scheme_id') String? discountSchemeId, String subtotal,@JsonKey(name: 'total_discount') String totalDiscount,@JsonKey(name: 'total_tax') String totalTax,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'exact_total') String? exactTotal,@JsonKey(name: 'rounding_amount') String roundingAmount,@JsonKey(name: 'tax_inclusive') bool taxInclusive,@JsonKey(name: 'tax_rounding_mode') String taxRoundingMode,@JsonKey(name: 'tax_label') String taxLabel,@JsonKey(name: 'total_amount') String totalAmount, List<SalePricePreviewLineModel> lines
});




}
/// @nodoc
class _$SalePricePreviewModelCopyWithImpl<$Res>
    implements $SalePricePreviewModelCopyWith<$Res> {
  _$SalePricePreviewModelCopyWithImpl(this._self, this._then);

  final SalePricePreviewModel _self;
  final $Res Function(SalePricePreviewModel) _then;

/// Create a copy of SalePricePreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? discountSchemeId = freezed,Object? subtotal = null,Object? totalDiscount = null,Object? totalTax = null,Object? netAmount = freezed,Object? exactTotal = freezed,Object? roundingAmount = null,Object? taxInclusive = null,Object? taxRoundingMode = null,Object? taxLabel = null,Object? totalAmount = null,Object? lines = null,}) {
  return _then(SalePricePreviewModel(
discountSchemeId: freezed == discountSchemeId ? _self.discountSchemeId : discountSchemeId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as String,totalTax: null == totalTax ? _self.totalTax : totalTax // ignore: cast_nullable_to_non_nullable
as String,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,exactTotal: freezed == exactTotal ? _self.exactTotal : exactTotal // ignore: cast_nullable_to_non_nullable
as String?,roundingAmount: null == roundingAmount ? _self.roundingAmount : roundingAmount // ignore: cast_nullable_to_non_nullable
as String,taxInclusive: null == taxInclusive ? _self.taxInclusive : taxInclusive // ignore: cast_nullable_to_non_nullable
as bool,taxRoundingMode: null == taxRoundingMode ? _self.taxRoundingMode : taxRoundingMode // ignore: cast_nullable_to_non_nullable
as String,taxLabel: null == taxLabel ? _self.taxLabel : taxLabel // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<SalePricePreviewLineModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalePricePreviewModel].
extension SalePricePreviewModelPatterns on SalePricePreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalePricePreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalePricePreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalePricePreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _SalePricePreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalePricePreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalePricePreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'discount_scheme_id')  String? discountSchemeId,  String subtotal, @JsonKey(name: 'total_discount')  String totalDiscount, @JsonKey(name: 'total_tax')  String totalTax, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'exact_total')  String? exactTotal, @JsonKey(name: 'rounding_amount')  String roundingAmount, @JsonKey(name: 'tax_inclusive')  bool taxInclusive, @JsonKey(name: 'tax_rounding_mode')  String taxRoundingMode, @JsonKey(name: 'tax_label')  String taxLabel, @JsonKey(name: 'total_amount')  String totalAmount,  List<SalePricePreviewLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalePricePreviewModel() when $default != null:
return $default(_that.discountSchemeId,_that.subtotal,_that.totalDiscount,_that.totalTax,_that.netAmount,_that.exactTotal,_that.roundingAmount,_that.taxInclusive,_that.taxRoundingMode,_that.taxLabel,_that.totalAmount,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'discount_scheme_id')  String? discountSchemeId,  String subtotal, @JsonKey(name: 'total_discount')  String totalDiscount, @JsonKey(name: 'total_tax')  String totalTax, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'exact_total')  String? exactTotal, @JsonKey(name: 'rounding_amount')  String roundingAmount, @JsonKey(name: 'tax_inclusive')  bool taxInclusive, @JsonKey(name: 'tax_rounding_mode')  String taxRoundingMode, @JsonKey(name: 'tax_label')  String taxLabel, @JsonKey(name: 'total_amount')  String totalAmount,  List<SalePricePreviewLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _SalePricePreviewModel():
return $default(_that.discountSchemeId,_that.subtotal,_that.totalDiscount,_that.totalTax,_that.netAmount,_that.exactTotal,_that.roundingAmount,_that.taxInclusive,_that.taxRoundingMode,_that.taxLabel,_that.totalAmount,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'discount_scheme_id')  String? discountSchemeId,  String subtotal, @JsonKey(name: 'total_discount')  String totalDiscount, @JsonKey(name: 'total_tax')  String totalTax, @JsonKey(name: 'net_amount')  String? netAmount, @JsonKey(name: 'exact_total')  String? exactTotal, @JsonKey(name: 'rounding_amount')  String roundingAmount, @JsonKey(name: 'tax_inclusive')  bool taxInclusive, @JsonKey(name: 'tax_rounding_mode')  String taxRoundingMode, @JsonKey(name: 'tax_label')  String taxLabel, @JsonKey(name: 'total_amount')  String totalAmount,  List<SalePricePreviewLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _SalePricePreviewModel() when $default != null:
return $default(_that.discountSchemeId,_that.subtotal,_that.totalDiscount,_that.totalTax,_that.netAmount,_that.exactTotal,_that.roundingAmount,_that.taxInclusive,_that.taxRoundingMode,_that.taxLabel,_that.totalAmount,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalePricePreviewModel extends SalePricePreviewModel {
  const _SalePricePreviewModel({@JsonKey(name: 'discount_scheme_id') this.discountSchemeId, required this.subtotal, @JsonKey(name: 'total_discount') this.totalDiscount = '0', @JsonKey(name: 'total_tax') this.totalTax = '0', @JsonKey(name: 'net_amount') this.netAmount, @JsonKey(name: 'exact_total') this.exactTotal, @JsonKey(name: 'rounding_amount') this.roundingAmount = '0', @JsonKey(name: 'tax_inclusive') this.taxInclusive = false, @JsonKey(name: 'tax_rounding_mode') this.taxRoundingMode = 'none', @JsonKey(name: 'tax_label') this.taxLabel = 'GST', @JsonKey(name: 'total_amount') required this.totalAmount,  List<SalePricePreviewLineModel> lines = const []}): _lines = lines,super._();
  factory _SalePricePreviewModel.fromJson(Map<String, dynamic> json) => _$SalePricePreviewModelFromJson(json);

@override@JsonKey(name: 'discount_scheme_id') final  String? discountSchemeId;
@override final  String subtotal;
@override@JsonKey(name: 'total_discount') final  String totalDiscount;
@override@JsonKey(name: 'total_tax') final  String totalTax;
@override@JsonKey(name: 'net_amount') final  String? netAmount;
@override@JsonKey(name: 'exact_total') final  String? exactTotal;
@override@JsonKey(name: 'rounding_amount') final  String roundingAmount;
@override@JsonKey(name: 'tax_inclusive') final  bool taxInclusive;
@override@JsonKey(name: 'tax_rounding_mode') final  String taxRoundingMode;
@override@JsonKey(name: 'tax_label') final  String taxLabel;
@override@JsonKey(name: 'total_amount') final  String totalAmount;
 final  List<SalePricePreviewLineModel> _lines;
@override@JsonKey() List<SalePricePreviewLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of SalePricePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalePricePreviewModelCopyWith<_SalePricePreviewModel> get copyWith => __$SalePricePreviewModelCopyWithImpl<_SalePricePreviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalePricePreviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalePricePreviewModel&&(identical(other.discountSchemeId, discountSchemeId) || other.discountSchemeId == discountSchemeId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.totalTax, totalTax) || other.totalTax == totalTax)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.exactTotal, exactTotal) || other.exactTotal == exactTotal)&&(identical(other.roundingAmount, roundingAmount) || other.roundingAmount == roundingAmount)&&(identical(other.taxInclusive, taxInclusive) || other.taxInclusive == taxInclusive)&&(identical(other.taxRoundingMode, taxRoundingMode) || other.taxRoundingMode == taxRoundingMode)&&(identical(other.taxLabel, taxLabel) || other.taxLabel == taxLabel)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,discountSchemeId,subtotal,totalDiscount,totalTax,netAmount,exactTotal,roundingAmount,taxInclusive,taxRoundingMode,taxLabel,totalAmount,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'SalePricePreviewModel(discountSchemeId: $discountSchemeId, subtotal: $subtotal, totalDiscount: $totalDiscount, totalTax: $totalTax, netAmount: $netAmount, exactTotal: $exactTotal, roundingAmount: $roundingAmount, taxInclusive: $taxInclusive, taxRoundingMode: $taxRoundingMode, taxLabel: $taxLabel, totalAmount: $totalAmount, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$SalePricePreviewModelCopyWith<$Res> implements $SalePricePreviewModelCopyWith<$Res> {
  factory _$SalePricePreviewModelCopyWith(_SalePricePreviewModel value, $Res Function(_SalePricePreviewModel) _then) = __$SalePricePreviewModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'discount_scheme_id') String? discountSchemeId, String subtotal,@JsonKey(name: 'total_discount') String totalDiscount,@JsonKey(name: 'total_tax') String totalTax,@JsonKey(name: 'net_amount') String? netAmount,@JsonKey(name: 'exact_total') String? exactTotal,@JsonKey(name: 'rounding_amount') String roundingAmount,@JsonKey(name: 'tax_inclusive') bool taxInclusive,@JsonKey(name: 'tax_rounding_mode') String taxRoundingMode,@JsonKey(name: 'tax_label') String taxLabel,@JsonKey(name: 'total_amount') String totalAmount, List<SalePricePreviewLineModel> lines
});




}
/// @nodoc
class __$SalePricePreviewModelCopyWithImpl<$Res>
    implements _$SalePricePreviewModelCopyWith<$Res> {
  __$SalePricePreviewModelCopyWithImpl(this._self, this._then);

  final _SalePricePreviewModel _self;
  final $Res Function(_SalePricePreviewModel) _then;

/// Create a copy of SalePricePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? discountSchemeId = freezed,Object? subtotal = null,Object? totalDiscount = null,Object? totalTax = null,Object? netAmount = freezed,Object? exactTotal = freezed,Object? roundingAmount = null,Object? taxInclusive = null,Object? taxRoundingMode = null,Object? taxLabel = null,Object? totalAmount = null,Object? lines = null,}) {
  return _then(_SalePricePreviewModel(
discountSchemeId: freezed == discountSchemeId ? _self.discountSchemeId : discountSchemeId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as String,totalTax: null == totalTax ? _self.totalTax : totalTax // ignore: cast_nullable_to_non_nullable
as String,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String?,exactTotal: freezed == exactTotal ? _self.exactTotal : exactTotal // ignore: cast_nullable_to_non_nullable
as String?,roundingAmount: null == roundingAmount ? _self.roundingAmount : roundingAmount // ignore: cast_nullable_to_non_nullable
as String,taxInclusive: null == taxInclusive ? _self.taxInclusive : taxInclusive // ignore: cast_nullable_to_non_nullable
as bool,taxRoundingMode: null == taxRoundingMode ? _self.taxRoundingMode : taxRoundingMode // ignore: cast_nullable_to_non_nullable
as String,taxLabel: null == taxLabel ? _self.taxLabel : taxLabel // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<SalePricePreviewLineModel>,
  ));
}


}

// dart format on
