// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpensePaymentModel {

 String get id;@JsonKey(name: 'expense_id') String get expenseId;@JsonKey(name: 'payment_method') String get paymentMethod; String get amount; String get status;@JsonKey(name: 'reference_no') String? get referenceNo;@JsonKey(name: 'paid_at') String? get paidAt;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of ExpensePaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensePaymentModelCopyWith<ExpensePaymentModel> get copyWith => _$ExpensePaymentModelCopyWithImpl<ExpensePaymentModel>(this as ExpensePaymentModel, _$identity);

  /// Serializes this ExpensePaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpensePaymentModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensePaymentModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.expenseId, _this.expenseId) || other.expenseId == _this.expenseId)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.referenceNo, _this.referenceNo) || other.referenceNo == _this.referenceNo)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpensePaymentModel;
  return Object.hash(runtimeType,_this.id,_this.expenseId,_this.paymentMethod,_this.amount,_this.status,_this.referenceNo,_this.paidAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as ExpensePaymentModel;
  return 'ExpensePaymentModel(id: ${_this.id}, expenseId: ${_this.expenseId}, paymentMethod: ${_this.paymentMethod}, amount: ${_this.amount}, status: ${_this.status}, referenceNo: ${_this.referenceNo}, paidAt: ${_this.paidAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ExpensePaymentModelCopyWith<$Res>  {
  factory $ExpensePaymentModelCopyWith(ExpensePaymentModel value, $Res Function(ExpensePaymentModel) _then) = _$ExpensePaymentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId,@JsonKey(name: 'payment_method') String paymentMethod, String amount, String status,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'paid_at') String? paidAt,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$ExpensePaymentModelCopyWithImpl<$Res>
    implements $ExpensePaymentModelCopyWith<$Res> {
  _$ExpensePaymentModelCopyWithImpl(this._self, this._then);

  final ExpensePaymentModel _self;
  final $Res Function(ExpensePaymentModel) _then;

/// Create a copy of ExpensePaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expenseId = null,Object? paymentMethod = null,Object? amount = null,Object? status = null,Object? referenceNo = freezed,Object? paidAt = freezed,Object? createdAt = freezed,}) {
  return _then(ExpensePaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpensePaymentModel].
extension ExpensePaymentModelPatterns on ExpensePaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpensePaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpensePaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpensePaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpensePaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpensePaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpensePaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount,  String status, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpensePaymentModel() when $default != null:
return $default(_that.id,_that.expenseId,_that.paymentMethod,_that.amount,_that.status,_that.referenceNo,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount,  String status, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExpensePaymentModel():
return $default(_that.id,_that.expenseId,_that.paymentMethod,_that.amount,_that.status,_that.referenceNo,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount,  String status, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'paid_at')  String? paidAt, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExpensePaymentModel() when $default != null:
return $default(_that.id,_that.expenseId,_that.paymentMethod,_that.amount,_that.status,_that.referenceNo,_that.paidAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpensePaymentModel implements ExpensePaymentModel {
  const _ExpensePaymentModel({required this.id, @JsonKey(name: 'expense_id') required this.expenseId, @JsonKey(name: 'payment_method') required this.paymentMethod, required this.amount, this.status = 'completed', @JsonKey(name: 'reference_no') this.referenceNo, @JsonKey(name: 'paid_at') this.paidAt, @JsonKey(name: 'created_at') this.createdAt});
  factory _ExpensePaymentModel.fromJson(Map<String, dynamic> json) => _$ExpensePaymentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'expense_id') final  String expenseId;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override final  String amount;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'reference_no') final  String? referenceNo;
@override@JsonKey(name: 'paid_at') final  String? paidAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of ExpensePaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpensePaymentModelCopyWith<_ExpensePaymentModel> get copyWith => __$ExpensePaymentModelCopyWithImpl<_ExpensePaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpensePaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpensePaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,expenseId,paymentMethod,amount,status,referenceNo,paidAt,createdAt);
}

@override
String toString() {
    return 'ExpensePaymentModel(id: $id, expenseId: $expenseId, paymentMethod: $paymentMethod, amount: $amount, status: $status, referenceNo: $referenceNo, paidAt: $paidAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpensePaymentModelCopyWith<$Res> implements $ExpensePaymentModelCopyWith<$Res> {
  factory _$ExpensePaymentModelCopyWith(_ExpensePaymentModel value, $Res Function(_ExpensePaymentModel) _then) = __$ExpensePaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId,@JsonKey(name: 'payment_method') String paymentMethod, String amount, String status,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'paid_at') String? paidAt,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$ExpensePaymentModelCopyWithImpl<$Res>
    implements _$ExpensePaymentModelCopyWith<$Res> {
  __$ExpensePaymentModelCopyWithImpl(this._self, this._then);

  final _ExpensePaymentModel _self;
  final $Res Function(_ExpensePaymentModel) _then;

/// Create a copy of ExpensePaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expenseId = null,Object? paymentMethod = null,Object? amount = null,Object? status = null,Object? referenceNo = freezed,Object? paidAt = freezed,Object? createdAt = freezed,}) {
  return _then(_ExpensePaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
