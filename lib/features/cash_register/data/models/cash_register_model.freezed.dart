// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_register_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CashRegisterModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId; String get name;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'device_identifier') String? get deviceIdentifier;
/// Create a copy of CashRegisterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<CashRegisterModel> get copyWith => _$CashRegisterModelCopyWithImpl<CashRegisterModel>(this as CashRegisterModel, _$identity);

  /// Serializes this CashRegisterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CashRegisterModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashRegisterModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.deviceIdentifier, _this.deviceIdentifier) || other.deviceIdentifier == _this.deviceIdentifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CashRegisterModel;
  return Object.hash(runtimeType,_this.id,_this.branchId,_this.name,_this.isActive,_this.deviceIdentifier);
}

@override
String toString() {
  final _this = this as CashRegisterModel;
  return 'CashRegisterModel(id: ${_this.id}, branchId: ${_this.branchId}, name: ${_this.name}, isActive: ${_this.isActive}, deviceIdentifier: ${_this.deviceIdentifier})';
}


}

/// @nodoc
abstract mixin class $CashRegisterModelCopyWith<$Res>  {
  factory $CashRegisterModelCopyWith(CashRegisterModel value, $Res Function(CashRegisterModel) _then) = _$CashRegisterModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'device_identifier') String? deviceIdentifier
});




}
/// @nodoc
class _$CashRegisterModelCopyWithImpl<$Res>
    implements $CashRegisterModelCopyWith<$Res> {
  _$CashRegisterModelCopyWithImpl(this._self, this._then);

  final CashRegisterModel _self;
  final $Res Function(CashRegisterModel) _then;

/// Create a copy of CashRegisterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? name = null,Object? isActive = null,Object? deviceIdentifier = freezed,}) {
  return _then(CashRegisterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,deviceIdentifier: freezed == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashRegisterModel].
extension CashRegisterModelPatterns on CashRegisterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashRegisterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashRegisterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashRegisterModel value)  $default,){
final _that = this;
switch (_that) {
case _CashRegisterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashRegisterModel value)?  $default,){
final _that = this;
switch (_that) {
case _CashRegisterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'device_identifier')  String? deviceIdentifier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashRegisterModel() when $default != null:
return $default(_that.id,_that.branchId,_that.name,_that.isActive,_that.deviceIdentifier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'device_identifier')  String? deviceIdentifier)  $default,) {final _that = this;
switch (_that) {
case _CashRegisterModel():
return $default(_that.id,_that.branchId,_that.name,_that.isActive,_that.deviceIdentifier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'device_identifier')  String? deviceIdentifier)?  $default,) {final _that = this;
switch (_that) {
case _CashRegisterModel() when $default != null:
return $default(_that.id,_that.branchId,_that.name,_that.isActive,_that.deviceIdentifier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashRegisterModel implements CashRegisterModel {
  const _CashRegisterModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, required this.name, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'device_identifier') this.deviceIdentifier});
  factory _CashRegisterModel.fromJson(Map<String, dynamic> json) => _$CashRegisterModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'device_identifier') final  String? deviceIdentifier;

/// Create a copy of CashRegisterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashRegisterModelCopyWith<_CashRegisterModel> get copyWith => __$CashRegisterModelCopyWithImpl<_CashRegisterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashRegisterModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashRegisterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.deviceIdentifier, deviceIdentifier) || other.deviceIdentifier == deviceIdentifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,branchId,name,isActive,deviceIdentifier);
}

@override
String toString() {
    return 'CashRegisterModel(id: $id, branchId: $branchId, name: $name, isActive: $isActive, deviceIdentifier: $deviceIdentifier)';
}


}

/// @nodoc
abstract mixin class _$CashRegisterModelCopyWith<$Res> implements $CashRegisterModelCopyWith<$Res> {
  factory _$CashRegisterModelCopyWith(_CashRegisterModel value, $Res Function(_CashRegisterModel) _then) = __$CashRegisterModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'device_identifier') String? deviceIdentifier
});




}
/// @nodoc
class __$CashRegisterModelCopyWithImpl<$Res>
    implements _$CashRegisterModelCopyWith<$Res> {
  __$CashRegisterModelCopyWithImpl(this._self, this._then);

  final _CashRegisterModel _self;
  final $Res Function(_CashRegisterModel) _then;

/// Create a copy of CashRegisterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? name = null,Object? isActive = null,Object? deviceIdentifier = freezed,}) {
  return _then(_CashRegisterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,deviceIdentifier: freezed == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
