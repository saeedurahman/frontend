// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_payment_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpensePaymentResponseModel {

 String get id;@JsonKey(name: 'expense_id') String get expenseId; String get amount;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(name: 'reference_no') String? get referenceNo;@JsonKey(name: 'paid_at') String? get paidAt;@JsonKey(name: 'total_paid') String get totalPaid;@JsonKey(name: 'remaining_balance') String get remainingBalance;
/// Create a copy of ExpensePaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensePaymentResponseModelCopyWith<ExpensePaymentResponseModel> get copyWith => _$ExpensePaymentResponseModelCopyWithImpl<ExpensePaymentResponseModel>(this as ExpensePaymentResponseModel, _$identity);

  /// Serializes this ExpensePaymentResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpensePaymentResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensePaymentResponseModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.expenseId, _this.expenseId) || other.expenseId == _this.expenseId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.referenceNo, _this.referenceNo) || other.referenceNo == _this.referenceNo)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.totalPaid, _this.totalPaid) || other.totalPaid == _this.totalPaid)&&(identical(other.remainingBalance, _this.remainingBalance) || other.remainingBalance == _this.remainingBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpensePaymentResponseModel;
  return Object.hash(runtimeType,_this.id,_this.expenseId,_this.amount,_this.paymentMethod,_this.referenceNo,_this.paidAt,_this.totalPaid,_this.remainingBalance);
}

@override
String toString() {
  final _this = this as ExpensePaymentResponseModel;
  return 'ExpensePaymentResponseModel(id: ${_this.id}, expenseId: ${_this.expenseId}, amount: ${_this.amount}, paymentMethod: ${_this.paymentMethod}, referenceNo: ${_this.referenceNo}, paidAt: ${_this.paidAt}, totalPaid: ${_this.totalPaid}, remainingBalance: ${_this.remainingBalance})';
}


}

/// @nodoc
abstract mixin class $ExpensePaymentResponseModelCopyWith<$Res>  {
  factory $ExpensePaymentResponseModelCopyWith(ExpensePaymentResponseModel value, $Res Function(ExpensePaymentResponseModel) _then) = _$ExpensePaymentResponseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId, String amount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'paid_at') String? paidAt,@JsonKey(name: 'total_paid') String totalPaid,@JsonKey(name: 'remaining_balance') String remainingBalance
});




}
/// @nodoc
class _$ExpensePaymentResponseModelCopyWithImpl<$Res>
    implements $ExpensePaymentResponseModelCopyWith<$Res> {
  _$ExpensePaymentResponseModelCopyWithImpl(this._self, this._then);

  final ExpensePaymentResponseModel _self;
  final $Res Function(ExpensePaymentResponseModel) _then;

/// Create a copy of ExpensePaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expenseId = null,Object? amount = null,Object? paymentMethod = null,Object? referenceNo = freezed,Object? paidAt = freezed,Object? totalPaid = null,Object? remainingBalance = null,}) {
  return _then(ExpensePaymentResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String,remainingBalance: null == remainingBalance ? _self.remainingBalance : remainingBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpensePaymentResponseModel].
extension ExpensePaymentResponseModelPatterns on ExpensePaymentResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpensePaymentResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpensePaymentResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpensePaymentResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpensePaymentResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpensePaymentResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpensePaymentResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId,  String amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt, @JsonKey(name: 'total_paid')  String totalPaid, @JsonKey(name: 'remaining_balance')  String remainingBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpensePaymentResponseModel() when $default != null:
return $default(_that.id,_that.expenseId,_that.amount,_that.paymentMethod,_that.referenceNo,_that.paidAt,_that.totalPaid,_that.remainingBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId,  String amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt, @JsonKey(name: 'total_paid')  String totalPaid, @JsonKey(name: 'remaining_balance')  String remainingBalance)  $default,) {final _that = this;
switch (_that) {
case _ExpensePaymentResponseModel():
return $default(_that.id,_that.expenseId,_that.amount,_that.paymentMethod,_that.referenceNo,_that.paidAt,_that.totalPaid,_that.remainingBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'expense_id')  String expenseId,  String amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt, @JsonKey(name: 'total_paid')  String totalPaid, @JsonKey(name: 'remaining_balance')  String remainingBalance)?  $default,) {final _that = this;
switch (_that) {
case _ExpensePaymentResponseModel() when $default != null:
return $default(_that.id,_that.expenseId,_that.amount,_that.paymentMethod,_that.referenceNo,_that.paidAt,_that.totalPaid,_that.remainingBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpensePaymentResponseModel implements ExpensePaymentResponseModel {
  const _ExpensePaymentResponseModel({required this.id, @JsonKey(name: 'expense_id') required this.expenseId, required this.amount, @JsonKey(name: 'payment_method') required this.paymentMethod, @JsonKey(name: 'reference_no') this.referenceNo, @JsonKey(name: 'paid_at') this.paidAt, @JsonKey(name: 'total_paid') required this.totalPaid, @JsonKey(name: 'remaining_balance') required this.remainingBalance});
  factory _ExpensePaymentResponseModel.fromJson(Map<String, dynamic> json) => _$ExpensePaymentResponseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'expense_id') final  String expenseId;
@override final  String amount;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(name: 'reference_no') final  String? referenceNo;
@override@JsonKey(name: 'paid_at') final  String? paidAt;
@override@JsonKey(name: 'total_paid') final  String totalPaid;
@override@JsonKey(name: 'remaining_balance') final  String remainingBalance;

/// Create a copy of ExpensePaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpensePaymentResponseModelCopyWith<_ExpensePaymentResponseModel> get copyWith => __$ExpensePaymentResponseModelCopyWithImpl<_ExpensePaymentResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpensePaymentResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpensePaymentResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.remainingBalance, remainingBalance) || other.remainingBalance == remainingBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,expenseId,amount,paymentMethod,referenceNo,paidAt,totalPaid,remainingBalance);
}

@override
String toString() {
    return 'ExpensePaymentResponseModel(id: $id, expenseId: $expenseId, amount: $amount, paymentMethod: $paymentMethod, referenceNo: $referenceNo, paidAt: $paidAt, totalPaid: $totalPaid, remainingBalance: $remainingBalance)';
}


}

/// @nodoc
abstract mixin class _$ExpensePaymentResponseModelCopyWith<$Res> implements $ExpensePaymentResponseModelCopyWith<$Res> {
  factory _$ExpensePaymentResponseModelCopyWith(_ExpensePaymentResponseModel value, $Res Function(_ExpensePaymentResponseModel) _then) = __$ExpensePaymentResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId, String amount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'paid_at') String? paidAt,@JsonKey(name: 'total_paid') String totalPaid,@JsonKey(name: 'remaining_balance') String remainingBalance
});




}
/// @nodoc
class __$ExpensePaymentResponseModelCopyWithImpl<$Res>
    implements _$ExpensePaymentResponseModelCopyWith<$Res> {
  __$ExpensePaymentResponseModelCopyWithImpl(this._self, this._then);

  final _ExpensePaymentResponseModel _self;
  final $Res Function(_ExpensePaymentResponseModel) _then;

/// Create a copy of ExpensePaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expenseId = null,Object? amount = null,Object? paymentMethod = null,Object? referenceNo = freezed,Object? paidAt = freezed,Object? totalPaid = null,Object? remainingBalance = null,}) {
  return _then(_ExpensePaymentResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String,remainingBalance: null == remainingBalance ? _self.remainingBalance : remainingBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
