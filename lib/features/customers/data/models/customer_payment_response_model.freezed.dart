// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_payment_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerPaymentResponseModel {

@JsonKey(name: 'ledger_entry_id') String get ledgerEntryId;@JsonKey(name: 'customer_id') String get customerId; String get amount;@JsonKey(name: 'new_balance') String get newBalance;@JsonKey(name: 'previous_balance') String? get previousBalance;@JsonKey(name: 'payment_source') String? get paymentSource;@JsonKey(name: 'register_shift_id') String? get registerShiftId;@JsonKey(name: 'register_transaction_id') String? get registerTransactionId;
/// Create a copy of CustomerPaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerPaymentResponseModelCopyWith<CustomerPaymentResponseModel> get copyWith => _$CustomerPaymentResponseModelCopyWithImpl<CustomerPaymentResponseModel>(this as CustomerPaymentResponseModel, _$identity);

  /// Serializes this CustomerPaymentResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerPaymentResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerPaymentResponseModel&&(identical(other.ledgerEntryId, _this.ledgerEntryId) || other.ledgerEntryId == _this.ledgerEntryId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.newBalance, _this.newBalance) || other.newBalance == _this.newBalance)&&(identical(other.previousBalance, _this.previousBalance) || other.previousBalance == _this.previousBalance)&&(identical(other.paymentSource, _this.paymentSource) || other.paymentSource == _this.paymentSource)&&(identical(other.registerShiftId, _this.registerShiftId) || other.registerShiftId == _this.registerShiftId)&&(identical(other.registerTransactionId, _this.registerTransactionId) || other.registerTransactionId == _this.registerTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerPaymentResponseModel;
  return Object.hash(runtimeType,_this.ledgerEntryId,_this.customerId,_this.amount,_this.newBalance,_this.previousBalance,_this.paymentSource,_this.registerShiftId,_this.registerTransactionId);
}

@override
String toString() {
  final _this = this as CustomerPaymentResponseModel;
  return 'CustomerPaymentResponseModel(ledgerEntryId: ${_this.ledgerEntryId}, customerId: ${_this.customerId}, amount: ${_this.amount}, newBalance: ${_this.newBalance}, previousBalance: ${_this.previousBalance}, paymentSource: ${_this.paymentSource}, registerShiftId: ${_this.registerShiftId}, registerTransactionId: ${_this.registerTransactionId})';
}


}

/// @nodoc
abstract mixin class $CustomerPaymentResponseModelCopyWith<$Res>  {
  factory $CustomerPaymentResponseModelCopyWith(CustomerPaymentResponseModel value, $Res Function(CustomerPaymentResponseModel) _then) = _$CustomerPaymentResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ledger_entry_id') String ledgerEntryId,@JsonKey(name: 'customer_id') String customerId, String amount,@JsonKey(name: 'new_balance') String newBalance,@JsonKey(name: 'previous_balance') String? previousBalance,@JsonKey(name: 'payment_source') String? paymentSource,@JsonKey(name: 'register_shift_id') String? registerShiftId,@JsonKey(name: 'register_transaction_id') String? registerTransactionId
});




}
/// @nodoc
class _$CustomerPaymentResponseModelCopyWithImpl<$Res>
    implements $CustomerPaymentResponseModelCopyWith<$Res> {
  _$CustomerPaymentResponseModelCopyWithImpl(this._self, this._then);

  final CustomerPaymentResponseModel _self;
  final $Res Function(CustomerPaymentResponseModel) _then;

/// Create a copy of CustomerPaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ledgerEntryId = null,Object? customerId = null,Object? amount = null,Object? newBalance = null,Object? previousBalance = freezed,Object? paymentSource = freezed,Object? registerShiftId = freezed,Object? registerTransactionId = freezed,}) {
  return _then(CustomerPaymentResponseModel(
ledgerEntryId: null == ledgerEntryId ? _self.ledgerEntryId : ledgerEntryId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,newBalance: null == newBalance ? _self.newBalance : newBalance // ignore: cast_nullable_to_non_nullable
as String,previousBalance: freezed == previousBalance ? _self.previousBalance : previousBalance // ignore: cast_nullable_to_non_nullable
as String?,paymentSource: freezed == paymentSource ? _self.paymentSource : paymentSource // ignore: cast_nullable_to_non_nullable
as String?,registerShiftId: freezed == registerShiftId ? _self.registerShiftId : registerShiftId // ignore: cast_nullable_to_non_nullable
as String?,registerTransactionId: freezed == registerTransactionId ? _self.registerTransactionId : registerTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerPaymentResponseModel].
extension CustomerPaymentResponseModelPatterns on CustomerPaymentResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerPaymentResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerPaymentResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerPaymentResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerPaymentResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerPaymentResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerPaymentResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ledger_entry_id')  String ledgerEntryId, @JsonKey(name: 'customer_id')  String customerId,  String amount, @JsonKey(name: 'new_balance')  String newBalance, @JsonKey(name: 'previous_balance')  String? previousBalance, @JsonKey(name: 'payment_source')  String? paymentSource, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'register_transaction_id')  String? registerTransactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerPaymentResponseModel() when $default != null:
return $default(_that.ledgerEntryId,_that.customerId,_that.amount,_that.newBalance,_that.previousBalance,_that.paymentSource,_that.registerShiftId,_that.registerTransactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ledger_entry_id')  String ledgerEntryId, @JsonKey(name: 'customer_id')  String customerId,  String amount, @JsonKey(name: 'new_balance')  String newBalance, @JsonKey(name: 'previous_balance')  String? previousBalance, @JsonKey(name: 'payment_source')  String? paymentSource, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'register_transaction_id')  String? registerTransactionId)  $default,) {final _that = this;
switch (_that) {
case _CustomerPaymentResponseModel():
return $default(_that.ledgerEntryId,_that.customerId,_that.amount,_that.newBalance,_that.previousBalance,_that.paymentSource,_that.registerShiftId,_that.registerTransactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ledger_entry_id')  String ledgerEntryId, @JsonKey(name: 'customer_id')  String customerId,  String amount, @JsonKey(name: 'new_balance')  String newBalance, @JsonKey(name: 'previous_balance')  String? previousBalance, @JsonKey(name: 'payment_source')  String? paymentSource, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'register_transaction_id')  String? registerTransactionId)?  $default,) {final _that = this;
switch (_that) {
case _CustomerPaymentResponseModel() when $default != null:
return $default(_that.ledgerEntryId,_that.customerId,_that.amount,_that.newBalance,_that.previousBalance,_that.paymentSource,_that.registerShiftId,_that.registerTransactionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerPaymentResponseModel implements CustomerPaymentResponseModel {
  const _CustomerPaymentResponseModel({@JsonKey(name: 'ledger_entry_id') required this.ledgerEntryId, @JsonKey(name: 'customer_id') required this.customerId, required this.amount, @JsonKey(name: 'new_balance') required this.newBalance, @JsonKey(name: 'previous_balance') this.previousBalance, @JsonKey(name: 'payment_source') this.paymentSource, @JsonKey(name: 'register_shift_id') this.registerShiftId, @JsonKey(name: 'register_transaction_id') this.registerTransactionId});
  factory _CustomerPaymentResponseModel.fromJson(Map<String, dynamic> json) => _$CustomerPaymentResponseModelFromJson(json);

@override@JsonKey(name: 'ledger_entry_id') final  String ledgerEntryId;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override final  String amount;
@override@JsonKey(name: 'new_balance') final  String newBalance;
@override@JsonKey(name: 'previous_balance') final  String? previousBalance;
@override@JsonKey(name: 'payment_source') final  String? paymentSource;
@override@JsonKey(name: 'register_shift_id') final  String? registerShiftId;
@override@JsonKey(name: 'register_transaction_id') final  String? registerTransactionId;

/// Create a copy of CustomerPaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerPaymentResponseModelCopyWith<_CustomerPaymentResponseModel> get copyWith => __$CustomerPaymentResponseModelCopyWithImpl<_CustomerPaymentResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerPaymentResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerPaymentResponseModel&&(identical(other.ledgerEntryId, ledgerEntryId) || other.ledgerEntryId == ledgerEntryId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.newBalance, newBalance) || other.newBalance == newBalance)&&(identical(other.previousBalance, previousBalance) || other.previousBalance == previousBalance)&&(identical(other.paymentSource, paymentSource) || other.paymentSource == paymentSource)&&(identical(other.registerShiftId, registerShiftId) || other.registerShiftId == registerShiftId)&&(identical(other.registerTransactionId, registerTransactionId) || other.registerTransactionId == registerTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ledgerEntryId,customerId,amount,newBalance,previousBalance,paymentSource,registerShiftId,registerTransactionId);
}

@override
String toString() {
    return 'CustomerPaymentResponseModel(ledgerEntryId: $ledgerEntryId, customerId: $customerId, amount: $amount, newBalance: $newBalance, previousBalance: $previousBalance, paymentSource: $paymentSource, registerShiftId: $registerShiftId, registerTransactionId: $registerTransactionId)';
}


}

/// @nodoc
abstract mixin class _$CustomerPaymentResponseModelCopyWith<$Res> implements $CustomerPaymentResponseModelCopyWith<$Res> {
  factory _$CustomerPaymentResponseModelCopyWith(_CustomerPaymentResponseModel value, $Res Function(_CustomerPaymentResponseModel) _then) = __$CustomerPaymentResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ledger_entry_id') String ledgerEntryId,@JsonKey(name: 'customer_id') String customerId, String amount,@JsonKey(name: 'new_balance') String newBalance,@JsonKey(name: 'previous_balance') String? previousBalance,@JsonKey(name: 'payment_source') String? paymentSource,@JsonKey(name: 'register_shift_id') String? registerShiftId,@JsonKey(name: 'register_transaction_id') String? registerTransactionId
});




}
/// @nodoc
class __$CustomerPaymentResponseModelCopyWithImpl<$Res>
    implements _$CustomerPaymentResponseModelCopyWith<$Res> {
  __$CustomerPaymentResponseModelCopyWithImpl(this._self, this._then);

  final _CustomerPaymentResponseModel _self;
  final $Res Function(_CustomerPaymentResponseModel) _then;

/// Create a copy of CustomerPaymentResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ledgerEntryId = null,Object? customerId = null,Object? amount = null,Object? newBalance = null,Object? previousBalance = freezed,Object? paymentSource = freezed,Object? registerShiftId = freezed,Object? registerTransactionId = freezed,}) {
  return _then(_CustomerPaymentResponseModel(
ledgerEntryId: null == ledgerEntryId ? _self.ledgerEntryId : ledgerEntryId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,newBalance: null == newBalance ? _self.newBalance : newBalance // ignore: cast_nullable_to_non_nullable
as String,previousBalance: freezed == previousBalance ? _self.previousBalance : previousBalance // ignore: cast_nullable_to_non_nullable
as String?,paymentSource: freezed == paymentSource ? _self.paymentSource : paymentSource // ignore: cast_nullable_to_non_nullable
as String?,registerShiftId: freezed == registerShiftId ? _self.registerShiftId : registerShiftId // ignore: cast_nullable_to_non_nullable
as String?,registerTransactionId: freezed == registerTransactionId ? _self.registerTransactionId : registerTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
