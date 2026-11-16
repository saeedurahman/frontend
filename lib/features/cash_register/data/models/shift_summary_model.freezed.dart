// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShiftSummaryModel {

@JsonKey(name: 'shift_id') String? get shiftId; String? get status;@JsonKey(name: 'opening_float') String get openingFloat;@JsonKey(name: 'total_cash_sales') String get totalCashSales;@JsonKey(name: 'total_card_sales') String get totalCardSales;@JsonKey(name: 'total_wallet_sales') String get totalWalletSales;@JsonKey(name: 'total_other_sales') String get totalOtherSales;@JsonKey(name: 'total_returns') String get totalReturns;@JsonKey(name: 'total_cash_in') String get totalCashIn;@JsonKey(name: 'total_cash_out') String get totalCashOut;@JsonKey(name: 'total_expenses') String get totalExpenses;@JsonKey(name: 'expected_cash') String get expectedCash;@JsonKey(name: 'actual_cash') String? get actualCash;@JsonKey(name: 'cash_difference') String? get cashDifference;
/// Create a copy of ShiftSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftSummaryModelCopyWith<ShiftSummaryModel> get copyWith => _$ShiftSummaryModelCopyWithImpl<ShiftSummaryModel>(this as ShiftSummaryModel, _$identity);

  /// Serializes this ShiftSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ShiftSummaryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftSummaryModel&&(identical(other.shiftId, _this.shiftId) || other.shiftId == _this.shiftId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.openingFloat, _this.openingFloat) || other.openingFloat == _this.openingFloat)&&(identical(other.totalCashSales, _this.totalCashSales) || other.totalCashSales == _this.totalCashSales)&&(identical(other.totalCardSales, _this.totalCardSales) || other.totalCardSales == _this.totalCardSales)&&(identical(other.totalWalletSales, _this.totalWalletSales) || other.totalWalletSales == _this.totalWalletSales)&&(identical(other.totalOtherSales, _this.totalOtherSales) || other.totalOtherSales == _this.totalOtherSales)&&(identical(other.totalReturns, _this.totalReturns) || other.totalReturns == _this.totalReturns)&&(identical(other.totalCashIn, _this.totalCashIn) || other.totalCashIn == _this.totalCashIn)&&(identical(other.totalCashOut, _this.totalCashOut) || other.totalCashOut == _this.totalCashOut)&&(identical(other.totalExpenses, _this.totalExpenses) || other.totalExpenses == _this.totalExpenses)&&(identical(other.expectedCash, _this.expectedCash) || other.expectedCash == _this.expectedCash)&&(identical(other.actualCash, _this.actualCash) || other.actualCash == _this.actualCash)&&(identical(other.cashDifference, _this.cashDifference) || other.cashDifference == _this.cashDifference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShiftSummaryModel;
  return Object.hash(runtimeType,_this.shiftId,_this.status,_this.openingFloat,_this.totalCashSales,_this.totalCardSales,_this.totalWalletSales,_this.totalOtherSales,_this.totalReturns,_this.totalCashIn,_this.totalCashOut,_this.totalExpenses,_this.expectedCash,_this.actualCash,_this.cashDifference);
}

@override
String toString() {
  final _this = this as ShiftSummaryModel;
  return 'ShiftSummaryModel(shiftId: ${_this.shiftId}, status: ${_this.status}, openingFloat: ${_this.openingFloat}, totalCashSales: ${_this.totalCashSales}, totalCardSales: ${_this.totalCardSales}, totalWalletSales: ${_this.totalWalletSales}, totalOtherSales: ${_this.totalOtherSales}, totalReturns: ${_this.totalReturns}, totalCashIn: ${_this.totalCashIn}, totalCashOut: ${_this.totalCashOut}, totalExpenses: ${_this.totalExpenses}, expectedCash: ${_this.expectedCash}, actualCash: ${_this.actualCash}, cashDifference: ${_this.cashDifference})';
}


}

/// @nodoc
abstract mixin class $ShiftSummaryModelCopyWith<$Res>  {
  factory $ShiftSummaryModelCopyWith(ShiftSummaryModel value, $Res Function(ShiftSummaryModel) _then) = _$ShiftSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'shift_id') String? shiftId, String? status,@JsonKey(name: 'opening_float') String openingFloat,@JsonKey(name: 'total_cash_sales') String totalCashSales,@JsonKey(name: 'total_card_sales') String totalCardSales,@JsonKey(name: 'total_wallet_sales') String totalWalletSales,@JsonKey(name: 'total_other_sales') String totalOtherSales,@JsonKey(name: 'total_returns') String totalReturns,@JsonKey(name: 'total_cash_in') String totalCashIn,@JsonKey(name: 'total_cash_out') String totalCashOut,@JsonKey(name: 'total_expenses') String totalExpenses,@JsonKey(name: 'expected_cash') String expectedCash,@JsonKey(name: 'actual_cash') String? actualCash,@JsonKey(name: 'cash_difference') String? cashDifference
});




}
/// @nodoc
class _$ShiftSummaryModelCopyWithImpl<$Res>
    implements $ShiftSummaryModelCopyWith<$Res> {
  _$ShiftSummaryModelCopyWithImpl(this._self, this._then);

  final ShiftSummaryModel _self;
  final $Res Function(ShiftSummaryModel) _then;

/// Create a copy of ShiftSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shiftId = freezed,Object? status = freezed,Object? openingFloat = null,Object? totalCashSales = null,Object? totalCardSales = null,Object? totalWalletSales = null,Object? totalOtherSales = null,Object? totalReturns = null,Object? totalCashIn = null,Object? totalCashOut = null,Object? totalExpenses = null,Object? expectedCash = null,Object? actualCash = freezed,Object? cashDifference = freezed,}) {
  return _then(ShiftSummaryModel(
shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,openingFloat: null == openingFloat ? _self.openingFloat : openingFloat // ignore: cast_nullable_to_non_nullable
as String,totalCashSales: null == totalCashSales ? _self.totalCashSales : totalCashSales // ignore: cast_nullable_to_non_nullable
as String,totalCardSales: null == totalCardSales ? _self.totalCardSales : totalCardSales // ignore: cast_nullable_to_non_nullable
as String,totalWalletSales: null == totalWalletSales ? _self.totalWalletSales : totalWalletSales // ignore: cast_nullable_to_non_nullable
as String,totalOtherSales: null == totalOtherSales ? _self.totalOtherSales : totalOtherSales // ignore: cast_nullable_to_non_nullable
as String,totalReturns: null == totalReturns ? _self.totalReturns : totalReturns // ignore: cast_nullable_to_non_nullable
as String,totalCashIn: null == totalCashIn ? _self.totalCashIn : totalCashIn // ignore: cast_nullable_to_non_nullable
as String,totalCashOut: null == totalCashOut ? _self.totalCashOut : totalCashOut // ignore: cast_nullable_to_non_nullable
as String,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as String,expectedCash: null == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as String,actualCash: freezed == actualCash ? _self.actualCash : actualCash // ignore: cast_nullable_to_non_nullable
as String?,cashDifference: freezed == cashDifference ? _self.cashDifference : cashDifference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftSummaryModel].
extension ShiftSummaryModelPatterns on ShiftSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _ShiftSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'shift_id')  String? shiftId,  String? status, @JsonKey(name: 'opening_float')  String openingFloat, @JsonKey(name: 'total_cash_sales')  String totalCashSales, @JsonKey(name: 'total_card_sales')  String totalCardSales, @JsonKey(name: 'total_wallet_sales')  String totalWalletSales, @JsonKey(name: 'total_other_sales')  String totalOtherSales, @JsonKey(name: 'total_returns')  String totalReturns, @JsonKey(name: 'total_cash_in')  String totalCashIn, @JsonKey(name: 'total_cash_out')  String totalCashOut, @JsonKey(name: 'total_expenses')  String totalExpenses, @JsonKey(name: 'expected_cash')  String expectedCash, @JsonKey(name: 'actual_cash')  String? actualCash, @JsonKey(name: 'cash_difference')  String? cashDifference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftSummaryModel() when $default != null:
return $default(_that.shiftId,_that.status,_that.openingFloat,_that.totalCashSales,_that.totalCardSales,_that.totalWalletSales,_that.totalOtherSales,_that.totalReturns,_that.totalCashIn,_that.totalCashOut,_that.totalExpenses,_that.expectedCash,_that.actualCash,_that.cashDifference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'shift_id')  String? shiftId,  String? status, @JsonKey(name: 'opening_float')  String openingFloat, @JsonKey(name: 'total_cash_sales')  String totalCashSales, @JsonKey(name: 'total_card_sales')  String totalCardSales, @JsonKey(name: 'total_wallet_sales')  String totalWalletSales, @JsonKey(name: 'total_other_sales')  String totalOtherSales, @JsonKey(name: 'total_returns')  String totalReturns, @JsonKey(name: 'total_cash_in')  String totalCashIn, @JsonKey(name: 'total_cash_out')  String totalCashOut, @JsonKey(name: 'total_expenses')  String totalExpenses, @JsonKey(name: 'expected_cash')  String expectedCash, @JsonKey(name: 'actual_cash')  String? actualCash, @JsonKey(name: 'cash_difference')  String? cashDifference)  $default,) {final _that = this;
switch (_that) {
case _ShiftSummaryModel():
return $default(_that.shiftId,_that.status,_that.openingFloat,_that.totalCashSales,_that.totalCardSales,_that.totalWalletSales,_that.totalOtherSales,_that.totalReturns,_that.totalCashIn,_that.totalCashOut,_that.totalExpenses,_that.expectedCash,_that.actualCash,_that.cashDifference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'shift_id')  String? shiftId,  String? status, @JsonKey(name: 'opening_float')  String openingFloat, @JsonKey(name: 'total_cash_sales')  String totalCashSales, @JsonKey(name: 'total_card_sales')  String totalCardSales, @JsonKey(name: 'total_wallet_sales')  String totalWalletSales, @JsonKey(name: 'total_other_sales')  String totalOtherSales, @JsonKey(name: 'total_returns')  String totalReturns, @JsonKey(name: 'total_cash_in')  String totalCashIn, @JsonKey(name: 'total_cash_out')  String totalCashOut, @JsonKey(name: 'total_expenses')  String totalExpenses, @JsonKey(name: 'expected_cash')  String expectedCash, @JsonKey(name: 'actual_cash')  String? actualCash, @JsonKey(name: 'cash_difference')  String? cashDifference)?  $default,) {final _that = this;
switch (_that) {
case _ShiftSummaryModel() when $default != null:
return $default(_that.shiftId,_that.status,_that.openingFloat,_that.totalCashSales,_that.totalCardSales,_that.totalWalletSales,_that.totalOtherSales,_that.totalReturns,_that.totalCashIn,_that.totalCashOut,_that.totalExpenses,_that.expectedCash,_that.actualCash,_that.cashDifference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShiftSummaryModel extends ShiftSummaryModel {
  const _ShiftSummaryModel({@JsonKey(name: 'shift_id') this.shiftId, this.status, @JsonKey(name: 'opening_float') this.openingFloat = '0', @JsonKey(name: 'total_cash_sales') this.totalCashSales = '0', @JsonKey(name: 'total_card_sales') this.totalCardSales = '0', @JsonKey(name: 'total_wallet_sales') this.totalWalletSales = '0', @JsonKey(name: 'total_other_sales') this.totalOtherSales = '0', @JsonKey(name: 'total_returns') this.totalReturns = '0', @JsonKey(name: 'total_cash_in') this.totalCashIn = '0', @JsonKey(name: 'total_cash_out') this.totalCashOut = '0', @JsonKey(name: 'total_expenses') this.totalExpenses = '0', @JsonKey(name: 'expected_cash') this.expectedCash = '0', @JsonKey(name: 'actual_cash') this.actualCash, @JsonKey(name: 'cash_difference') this.cashDifference}): super._();
  factory _ShiftSummaryModel.fromJson(Map<String, dynamic> json) => _$ShiftSummaryModelFromJson(json);

@override@JsonKey(name: 'shift_id') final  String? shiftId;
@override final  String? status;
@override@JsonKey(name: 'opening_float') final  String openingFloat;
@override@JsonKey(name: 'total_cash_sales') final  String totalCashSales;
@override@JsonKey(name: 'total_card_sales') final  String totalCardSales;
@override@JsonKey(name: 'total_wallet_sales') final  String totalWalletSales;
@override@JsonKey(name: 'total_other_sales') final  String totalOtherSales;
@override@JsonKey(name: 'total_returns') final  String totalReturns;
@override@JsonKey(name: 'total_cash_in') final  String totalCashIn;
@override@JsonKey(name: 'total_cash_out') final  String totalCashOut;
@override@JsonKey(name: 'total_expenses') final  String totalExpenses;
@override@JsonKey(name: 'expected_cash') final  String expectedCash;
@override@JsonKey(name: 'actual_cash') final  String? actualCash;
@override@JsonKey(name: 'cash_difference') final  String? cashDifference;

/// Create a copy of ShiftSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftSummaryModelCopyWith<_ShiftSummaryModel> get copyWith => __$ShiftSummaryModelCopyWithImpl<_ShiftSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShiftSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftSummaryModel&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.status, status) || other.status == status)&&(identical(other.openingFloat, openingFloat) || other.openingFloat == openingFloat)&&(identical(other.totalCashSales, totalCashSales) || other.totalCashSales == totalCashSales)&&(identical(other.totalCardSales, totalCardSales) || other.totalCardSales == totalCardSales)&&(identical(other.totalWalletSales, totalWalletSales) || other.totalWalletSales == totalWalletSales)&&(identical(other.totalOtherSales, totalOtherSales) || other.totalOtherSales == totalOtherSales)&&(identical(other.totalReturns, totalReturns) || other.totalReturns == totalReturns)&&(identical(other.totalCashIn, totalCashIn) || other.totalCashIn == totalCashIn)&&(identical(other.totalCashOut, totalCashOut) || other.totalCashOut == totalCashOut)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.expectedCash, expectedCash) || other.expectedCash == expectedCash)&&(identical(other.actualCash, actualCash) || other.actualCash == actualCash)&&(identical(other.cashDifference, cashDifference) || other.cashDifference == cashDifference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,shiftId,status,openingFloat,totalCashSales,totalCardSales,totalWalletSales,totalOtherSales,totalReturns,totalCashIn,totalCashOut,totalExpenses,expectedCash,actualCash,cashDifference);
}

@override
String toString() {
    return 'ShiftSummaryModel(shiftId: $shiftId, status: $status, openingFloat: $openingFloat, totalCashSales: $totalCashSales, totalCardSales: $totalCardSales, totalWalletSales: $totalWalletSales, totalOtherSales: $totalOtherSales, totalReturns: $totalReturns, totalCashIn: $totalCashIn, totalCashOut: $totalCashOut, totalExpenses: $totalExpenses, expectedCash: $expectedCash, actualCash: $actualCash, cashDifference: $cashDifference)';
}


}

/// @nodoc
abstract mixin class _$ShiftSummaryModelCopyWith<$Res> implements $ShiftSummaryModelCopyWith<$Res> {
  factory _$ShiftSummaryModelCopyWith(_ShiftSummaryModel value, $Res Function(_ShiftSummaryModel) _then) = __$ShiftSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'shift_id') String? shiftId, String? status,@JsonKey(name: 'opening_float') String openingFloat,@JsonKey(name: 'total_cash_sales') String totalCashSales,@JsonKey(name: 'total_card_sales') String totalCardSales,@JsonKey(name: 'total_wallet_sales') String totalWalletSales,@JsonKey(name: 'total_other_sales') String totalOtherSales,@JsonKey(name: 'total_returns') String totalReturns,@JsonKey(name: 'total_cash_in') String totalCashIn,@JsonKey(name: 'total_cash_out') String totalCashOut,@JsonKey(name: 'total_expenses') String totalExpenses,@JsonKey(name: 'expected_cash') String expectedCash,@JsonKey(name: 'actual_cash') String? actualCash,@JsonKey(name: 'cash_difference') String? cashDifference
});




}
/// @nodoc
class __$ShiftSummaryModelCopyWithImpl<$Res>
    implements _$ShiftSummaryModelCopyWith<$Res> {
  __$ShiftSummaryModelCopyWithImpl(this._self, this._then);

  final _ShiftSummaryModel _self;
  final $Res Function(_ShiftSummaryModel) _then;

/// Create a copy of ShiftSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shiftId = freezed,Object? status = freezed,Object? openingFloat = null,Object? totalCashSales = null,Object? totalCardSales = null,Object? totalWalletSales = null,Object? totalOtherSales = null,Object? totalReturns = null,Object? totalCashIn = null,Object? totalCashOut = null,Object? totalExpenses = null,Object? expectedCash = null,Object? actualCash = freezed,Object? cashDifference = freezed,}) {
  return _then(_ShiftSummaryModel(
shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,openingFloat: null == openingFloat ? _self.openingFloat : openingFloat // ignore: cast_nullable_to_non_nullable
as String,totalCashSales: null == totalCashSales ? _self.totalCashSales : totalCashSales // ignore: cast_nullable_to_non_nullable
as String,totalCardSales: null == totalCardSales ? _self.totalCardSales : totalCardSales // ignore: cast_nullable_to_non_nullable
as String,totalWalletSales: null == totalWalletSales ? _self.totalWalletSales : totalWalletSales // ignore: cast_nullable_to_non_nullable
as String,totalOtherSales: null == totalOtherSales ? _self.totalOtherSales : totalOtherSales // ignore: cast_nullable_to_non_nullable
as String,totalReturns: null == totalReturns ? _self.totalReturns : totalReturns // ignore: cast_nullable_to_non_nullable
as String,totalCashIn: null == totalCashIn ? _self.totalCashIn : totalCashIn // ignore: cast_nullable_to_non_nullable
as String,totalCashOut: null == totalCashOut ? _self.totalCashOut : totalCashOut // ignore: cast_nullable_to_non_nullable
as String,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as String,expectedCash: null == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as String,actualCash: freezed == actualCash ? _self.actualCash : actualCash // ignore: cast_nullable_to_non_nullable
as String?,cashDifference: freezed == cashDifference ? _self.cashDifference : cashDifference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
