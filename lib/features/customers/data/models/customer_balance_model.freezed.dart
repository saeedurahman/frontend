// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_balance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerBalanceModel {

@JsonKey(name: 'customer_id') String get customerId; String get balance;
/// Create a copy of CustomerBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerBalanceModelCopyWith<CustomerBalanceModel> get copyWith => _$CustomerBalanceModelCopyWithImpl<CustomerBalanceModel>(this as CustomerBalanceModel, _$identity);

  /// Serializes this CustomerBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerBalanceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerBalanceModel&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.balance, _this.balance) || other.balance == _this.balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerBalanceModel;
  return Object.hash(runtimeType,_this.customerId,_this.balance);
}

@override
String toString() {
  final _this = this as CustomerBalanceModel;
  return 'CustomerBalanceModel(customerId: ${_this.customerId}, balance: ${_this.balance})';
}


}

/// @nodoc
abstract mixin class $CustomerBalanceModelCopyWith<$Res>  {
  factory $CustomerBalanceModelCopyWith(CustomerBalanceModel value, $Res Function(CustomerBalanceModel) _then) = _$CustomerBalanceModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'customer_id') String customerId, String balance
});




}
/// @nodoc
class _$CustomerBalanceModelCopyWithImpl<$Res>
    implements $CustomerBalanceModelCopyWith<$Res> {
  _$CustomerBalanceModelCopyWithImpl(this._self, this._then);

  final CustomerBalanceModel _self;
  final $Res Function(CustomerBalanceModel) _then;

/// Create a copy of CustomerBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = null,Object? balance = null,}) {
  return _then(CustomerBalanceModel(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerBalanceModel].
extension CustomerBalanceModelPatterns on CustomerBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String customerId,  String balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerBalanceModel() when $default != null:
return $default(_that.customerId,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String customerId,  String balance)  $default,) {final _that = this;
switch (_that) {
case _CustomerBalanceModel():
return $default(_that.customerId,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'customer_id')  String customerId,  String balance)?  $default,) {final _that = this;
switch (_that) {
case _CustomerBalanceModel() when $default != null:
return $default(_that.customerId,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerBalanceModel implements CustomerBalanceModel {
  const _CustomerBalanceModel({@JsonKey(name: 'customer_id') required this.customerId, required this.balance});
  factory _CustomerBalanceModel.fromJson(Map<String, dynamic> json) => _$CustomerBalanceModelFromJson(json);

@override@JsonKey(name: 'customer_id') final  String customerId;
@override final  String balance;

/// Create a copy of CustomerBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerBalanceModelCopyWith<_CustomerBalanceModel> get copyWith => __$CustomerBalanceModelCopyWithImpl<_CustomerBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerBalanceModel&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,customerId,balance);
}

@override
String toString() {
    return 'CustomerBalanceModel(customerId: $customerId, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$CustomerBalanceModelCopyWith<$Res> implements $CustomerBalanceModelCopyWith<$Res> {
  factory _$CustomerBalanceModelCopyWith(_CustomerBalanceModel value, $Res Function(_CustomerBalanceModel) _then) = __$CustomerBalanceModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'customer_id') String customerId, String balance
});




}
/// @nodoc
class __$CustomerBalanceModelCopyWithImpl<$Res>
    implements _$CustomerBalanceModelCopyWith<$Res> {
  __$CustomerBalanceModelCopyWithImpl(this._self, this._then);

  final _CustomerBalanceModel _self;
  final $Res Function(_CustomerBalanceModel) _then;

/// Create a copy of CustomerBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = null,Object? balance = null,}) {
  return _then(_CustomerBalanceModel(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
