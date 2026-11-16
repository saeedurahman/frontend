// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_shift_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterShiftModel {

 String get id;@JsonKey(name: 'cash_register_id') String get cashRegisterId;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'opened_by') String? get openedBy;@JsonKey(name: 'closed_by') String? get closedBy;@JsonKey(name: 'opened_by_name') String? get openedByName;@JsonKey(name: 'closed_by_name') String? get closedByName;@JsonKey(name: 'opening_float') String get openingFloat;@JsonKey(name: 'expected_cash') String? get expectedCash;@JsonKey(name: 'actual_cash') String? get actualCash;@JsonKey(name: 'cash_difference') String? get cashDifference;@JsonKey(name: 'opened_at') String? get openedAt;@JsonKey(name: 'closed_at') String? get closedAt; String get status; String? get notes; CashRegisterModel? get register;
/// Create a copy of RegisterShiftModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<RegisterShiftModel> get copyWith => _$RegisterShiftModelCopyWithImpl<RegisterShiftModel>(this as RegisterShiftModel, _$identity);

  /// Serializes this RegisterShiftModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegisterShiftModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterShiftModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.cashRegisterId, _this.cashRegisterId) || other.cashRegisterId == _this.cashRegisterId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.openedBy, _this.openedBy) || other.openedBy == _this.openedBy)&&(identical(other.closedBy, _this.closedBy) || other.closedBy == _this.closedBy)&&(identical(other.openedByName, _this.openedByName) || other.openedByName == _this.openedByName)&&(identical(other.closedByName, _this.closedByName) || other.closedByName == _this.closedByName)&&(identical(other.openingFloat, _this.openingFloat) || other.openingFloat == _this.openingFloat)&&(identical(other.expectedCash, _this.expectedCash) || other.expectedCash == _this.expectedCash)&&(identical(other.actualCash, _this.actualCash) || other.actualCash == _this.actualCash)&&(identical(other.cashDifference, _this.cashDifference) || other.cashDifference == _this.cashDifference)&&(identical(other.openedAt, _this.openedAt) || other.openedAt == _this.openedAt)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.register, _this.register) || other.register == _this.register));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegisterShiftModel;
  return Object.hash(runtimeType,_this.id,_this.cashRegisterId,_this.branchId,_this.openedBy,_this.closedBy,_this.openedByName,_this.closedByName,_this.openingFloat,_this.expectedCash,_this.actualCash,_this.cashDifference,_this.openedAt,_this.closedAt,_this.status,_this.notes,_this.register);
}

@override
String toString() {
  final _this = this as RegisterShiftModel;
  return 'RegisterShiftModel(id: ${_this.id}, cashRegisterId: ${_this.cashRegisterId}, branchId: ${_this.branchId}, openedBy: ${_this.openedBy}, closedBy: ${_this.closedBy}, openedByName: ${_this.openedByName}, closedByName: ${_this.closedByName}, openingFloat: ${_this.openingFloat}, expectedCash: ${_this.expectedCash}, actualCash: ${_this.actualCash}, cashDifference: ${_this.cashDifference}, openedAt: ${_this.openedAt}, closedAt: ${_this.closedAt}, status: ${_this.status}, notes: ${_this.notes}, register: ${_this.register})';
}


}

/// @nodoc
abstract mixin class $RegisterShiftModelCopyWith<$Res>  {
  factory $RegisterShiftModelCopyWith(RegisterShiftModel value, $Res Function(RegisterShiftModel) _then) = _$RegisterShiftModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'cash_register_id') String cashRegisterId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'opened_by') String? openedBy,@JsonKey(name: 'closed_by') String? closedBy,@JsonKey(name: 'opened_by_name') String? openedByName,@JsonKey(name: 'closed_by_name') String? closedByName,@JsonKey(name: 'opening_float') String openingFloat,@JsonKey(name: 'expected_cash') String? expectedCash,@JsonKey(name: 'actual_cash') String? actualCash,@JsonKey(name: 'cash_difference') String? cashDifference,@JsonKey(name: 'opened_at') String? openedAt,@JsonKey(name: 'closed_at') String? closedAt, String status, String? notes, CashRegisterModel? register
});


$CashRegisterModelCopyWith<$Res>? get register;

}
/// @nodoc
class _$RegisterShiftModelCopyWithImpl<$Res>
    implements $RegisterShiftModelCopyWith<$Res> {
  _$RegisterShiftModelCopyWithImpl(this._self, this._then);

  final RegisterShiftModel _self;
  final $Res Function(RegisterShiftModel) _then;

/// Create a copy of RegisterShiftModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cashRegisterId = null,Object? branchId = freezed,Object? openedBy = freezed,Object? closedBy = freezed,Object? openedByName = freezed,Object? closedByName = freezed,Object? openingFloat = null,Object? expectedCash = freezed,Object? actualCash = freezed,Object? cashDifference = freezed,Object? openedAt = freezed,Object? closedAt = freezed,Object? status = null,Object? notes = freezed,Object? register = freezed,}) {
  return _then(RegisterShiftModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cashRegisterId: null == cashRegisterId ? _self.cashRegisterId : cashRegisterId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,openedBy: freezed == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,openedByName: freezed == openedByName ? _self.openedByName : openedByName // ignore: cast_nullable_to_non_nullable
as String?,closedByName: freezed == closedByName ? _self.closedByName : closedByName // ignore: cast_nullable_to_non_nullable
as String?,openingFloat: null == openingFloat ? _self.openingFloat : openingFloat // ignore: cast_nullable_to_non_nullable
as String,expectedCash: freezed == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as String?,actualCash: freezed == actualCash ? _self.actualCash : actualCash // ignore: cast_nullable_to_non_nullable
as String?,cashDifference: freezed == cashDifference ? _self.cashDifference : cashDifference // ignore: cast_nullable_to_non_nullable
as String?,openedAt: freezed == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,register: freezed == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as CashRegisterModel?,
  ));
}
/// Create a copy of RegisterShiftModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<$Res>? get register {
    if (_self.register == null) {
    return null;
  }

  return $CashRegisterModelCopyWith<$Res>(_self.register!, (value) {
    return _then(_self.copyWith(register: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterShiftModel].
extension RegisterShiftModelPatterns on RegisterShiftModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterShiftModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterShiftModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterShiftModel value)  $default,){
final _that = this;
switch (_that) {
case _RegisterShiftModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterShiftModel value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterShiftModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'cash_register_id')  String cashRegisterId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'opened_by')  String? openedBy, @JsonKey(name: 'closed_by')  String? closedBy, @JsonKey(name: 'opened_by_name')  String? openedByName, @JsonKey(name: 'closed_by_name')  String? closedByName, @JsonKey(name: 'opening_float')  String openingFloat, @JsonKey(name: 'expected_cash')  String? expectedCash, @JsonKey(name: 'actual_cash')  String? actualCash, @JsonKey(name: 'cash_difference')  String? cashDifference, @JsonKey(name: 'opened_at')  String? openedAt, @JsonKey(name: 'closed_at')  String? closedAt,  String status,  String? notes,  CashRegisterModel? register)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterShiftModel() when $default != null:
return $default(_that.id,_that.cashRegisterId,_that.branchId,_that.openedBy,_that.closedBy,_that.openedByName,_that.closedByName,_that.openingFloat,_that.expectedCash,_that.actualCash,_that.cashDifference,_that.openedAt,_that.closedAt,_that.status,_that.notes,_that.register);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'cash_register_id')  String cashRegisterId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'opened_by')  String? openedBy, @JsonKey(name: 'closed_by')  String? closedBy, @JsonKey(name: 'opened_by_name')  String? openedByName, @JsonKey(name: 'closed_by_name')  String? closedByName, @JsonKey(name: 'opening_float')  String openingFloat, @JsonKey(name: 'expected_cash')  String? expectedCash, @JsonKey(name: 'actual_cash')  String? actualCash, @JsonKey(name: 'cash_difference')  String? cashDifference, @JsonKey(name: 'opened_at')  String? openedAt, @JsonKey(name: 'closed_at')  String? closedAt,  String status,  String? notes,  CashRegisterModel? register)  $default,) {final _that = this;
switch (_that) {
case _RegisterShiftModel():
return $default(_that.id,_that.cashRegisterId,_that.branchId,_that.openedBy,_that.closedBy,_that.openedByName,_that.closedByName,_that.openingFloat,_that.expectedCash,_that.actualCash,_that.cashDifference,_that.openedAt,_that.closedAt,_that.status,_that.notes,_that.register);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'cash_register_id')  String cashRegisterId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'opened_by')  String? openedBy, @JsonKey(name: 'closed_by')  String? closedBy, @JsonKey(name: 'opened_by_name')  String? openedByName, @JsonKey(name: 'closed_by_name')  String? closedByName, @JsonKey(name: 'opening_float')  String openingFloat, @JsonKey(name: 'expected_cash')  String? expectedCash, @JsonKey(name: 'actual_cash')  String? actualCash, @JsonKey(name: 'cash_difference')  String? cashDifference, @JsonKey(name: 'opened_at')  String? openedAt, @JsonKey(name: 'closed_at')  String? closedAt,  String status,  String? notes,  CashRegisterModel? register)?  $default,) {final _that = this;
switch (_that) {
case _RegisterShiftModel() when $default != null:
return $default(_that.id,_that.cashRegisterId,_that.branchId,_that.openedBy,_that.closedBy,_that.openedByName,_that.closedByName,_that.openingFloat,_that.expectedCash,_that.actualCash,_that.cashDifference,_that.openedAt,_that.closedAt,_that.status,_that.notes,_that.register);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterShiftModel implements RegisterShiftModel {
  const _RegisterShiftModel({required this.id, @JsonKey(name: 'cash_register_id') required this.cashRegisterId, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'opened_by') this.openedBy, @JsonKey(name: 'closed_by') this.closedBy, @JsonKey(name: 'opened_by_name') this.openedByName, @JsonKey(name: 'closed_by_name') this.closedByName, @JsonKey(name: 'opening_float') this.openingFloat = '0', @JsonKey(name: 'expected_cash') this.expectedCash, @JsonKey(name: 'actual_cash') this.actualCash, @JsonKey(name: 'cash_difference') this.cashDifference, @JsonKey(name: 'opened_at') this.openedAt, @JsonKey(name: 'closed_at') this.closedAt, this.status = 'open', this.notes, this.register});
  factory _RegisterShiftModel.fromJson(Map<String, dynamic> json) => _$RegisterShiftModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'cash_register_id') final  String cashRegisterId;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'opened_by') final  String? openedBy;
@override@JsonKey(name: 'closed_by') final  String? closedBy;
@override@JsonKey(name: 'opened_by_name') final  String? openedByName;
@override@JsonKey(name: 'closed_by_name') final  String? closedByName;
@override@JsonKey(name: 'opening_float') final  String openingFloat;
@override@JsonKey(name: 'expected_cash') final  String? expectedCash;
@override@JsonKey(name: 'actual_cash') final  String? actualCash;
@override@JsonKey(name: 'cash_difference') final  String? cashDifference;
@override@JsonKey(name: 'opened_at') final  String? openedAt;
@override@JsonKey(name: 'closed_at') final  String? closedAt;
@override@JsonKey() final  String status;
@override final  String? notes;
@override final  CashRegisterModel? register;

/// Create a copy of RegisterShiftModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterShiftModelCopyWith<_RegisterShiftModel> get copyWith => __$RegisterShiftModelCopyWithImpl<_RegisterShiftModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterShiftModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterShiftModel&&(identical(other.id, id) || other.id == id)&&(identical(other.cashRegisterId, cashRegisterId) || other.cashRegisterId == cashRegisterId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.openedBy, openedBy) || other.openedBy == openedBy)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.openedByName, openedByName) || other.openedByName == openedByName)&&(identical(other.closedByName, closedByName) || other.closedByName == closedByName)&&(identical(other.openingFloat, openingFloat) || other.openingFloat == openingFloat)&&(identical(other.expectedCash, expectedCash) || other.expectedCash == expectedCash)&&(identical(other.actualCash, actualCash) || other.actualCash == actualCash)&&(identical(other.cashDifference, cashDifference) || other.cashDifference == cashDifference)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.register, register) || other.register == register));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,cashRegisterId,branchId,openedBy,closedBy,openedByName,closedByName,openingFloat,expectedCash,actualCash,cashDifference,openedAt,closedAt,status,notes,register);
}

@override
String toString() {
    return 'RegisterShiftModel(id: $id, cashRegisterId: $cashRegisterId, branchId: $branchId, openedBy: $openedBy, closedBy: $closedBy, openedByName: $openedByName, closedByName: $closedByName, openingFloat: $openingFloat, expectedCash: $expectedCash, actualCash: $actualCash, cashDifference: $cashDifference, openedAt: $openedAt, closedAt: $closedAt, status: $status, notes: $notes, register: $register)';
}


}

/// @nodoc
abstract mixin class _$RegisterShiftModelCopyWith<$Res> implements $RegisterShiftModelCopyWith<$Res> {
  factory _$RegisterShiftModelCopyWith(_RegisterShiftModel value, $Res Function(_RegisterShiftModel) _then) = __$RegisterShiftModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'cash_register_id') String cashRegisterId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'opened_by') String? openedBy,@JsonKey(name: 'closed_by') String? closedBy,@JsonKey(name: 'opened_by_name') String? openedByName,@JsonKey(name: 'closed_by_name') String? closedByName,@JsonKey(name: 'opening_float') String openingFloat,@JsonKey(name: 'expected_cash') String? expectedCash,@JsonKey(name: 'actual_cash') String? actualCash,@JsonKey(name: 'cash_difference') String? cashDifference,@JsonKey(name: 'opened_at') String? openedAt,@JsonKey(name: 'closed_at') String? closedAt, String status, String? notes, CashRegisterModel? register
});


@override $CashRegisterModelCopyWith<$Res>? get register;

}
/// @nodoc
class __$RegisterShiftModelCopyWithImpl<$Res>
    implements _$RegisterShiftModelCopyWith<$Res> {
  __$RegisterShiftModelCopyWithImpl(this._self, this._then);

  final _RegisterShiftModel _self;
  final $Res Function(_RegisterShiftModel) _then;

/// Create a copy of RegisterShiftModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cashRegisterId = null,Object? branchId = freezed,Object? openedBy = freezed,Object? closedBy = freezed,Object? openedByName = freezed,Object? closedByName = freezed,Object? openingFloat = null,Object? expectedCash = freezed,Object? actualCash = freezed,Object? cashDifference = freezed,Object? openedAt = freezed,Object? closedAt = freezed,Object? status = null,Object? notes = freezed,Object? register = freezed,}) {
  return _then(_RegisterShiftModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cashRegisterId: null == cashRegisterId ? _self.cashRegisterId : cashRegisterId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,openedBy: freezed == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,openedByName: freezed == openedByName ? _self.openedByName : openedByName // ignore: cast_nullable_to_non_nullable
as String?,closedByName: freezed == closedByName ? _self.closedByName : closedByName // ignore: cast_nullable_to_non_nullable
as String?,openingFloat: null == openingFloat ? _self.openingFloat : openingFloat // ignore: cast_nullable_to_non_nullable
as String,expectedCash: freezed == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as String?,actualCash: freezed == actualCash ? _self.actualCash : actualCash // ignore: cast_nullable_to_non_nullable
as String?,cashDifference: freezed == cashDifference ? _self.cashDifference : cashDifference // ignore: cast_nullable_to_non_nullable
as String?,openedAt: freezed == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,register: freezed == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as CashRegisterModel?,
  ));
}

/// Create a copy of RegisterShiftModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<$Res>? get register {
    if (_self.register == null) {
    return null;
  }

  return $CashRegisterModelCopyWith<$Res>(_self.register!, (value) {
    return _then(_self.copyWith(register: value));
  });
}
}

// dart format on
