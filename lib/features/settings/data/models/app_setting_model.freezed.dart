// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'setting_key') String get settingKey;@JsonKey(name: 'setting_value') Map<String, dynamic> get settingValue;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of AppSettingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingModelCopyWith<AppSettingModel> get copyWith => _$AppSettingModelCopyWithImpl<AppSettingModel>(this as AppSettingModel, _$identity);

  /// Serializes this AppSettingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppSettingModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.settingKey, _this.settingKey) || other.settingKey == _this.settingKey)&&const DeepCollectionEquality().equals(other.settingValue, _this.settingValue)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppSettingModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.settingKey,const DeepCollectionEquality().hash(_this.settingValue),_this.updatedAt);
}

@override
String toString() {
  final _this = this as AppSettingModel;
  return 'AppSettingModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, settingKey: ${_this.settingKey}, settingValue: ${_this.settingValue}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AppSettingModelCopyWith<$Res>  {
  factory $AppSettingModelCopyWith(AppSettingModel value, $Res Function(AppSettingModel) _then) = _$AppSettingModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'setting_key') String settingKey,@JsonKey(name: 'setting_value') Map<String, dynamic> settingValue,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$AppSettingModelCopyWithImpl<$Res>
    implements $AppSettingModelCopyWith<$Res> {
  _$AppSettingModelCopyWithImpl(this._self, this._then);

  final AppSettingModel _self;
  final $Res Function(AppSettingModel) _then;

/// Create a copy of AppSettingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = freezed,Object? settingKey = null,Object? settingValue = null,Object? updatedAt = freezed,}) {
  return _then(AppSettingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,settingKey: null == settingKey ? _self.settingKey : settingKey // ignore: cast_nullable_to_non_nullable
as String,settingValue: null == settingValue ? _self.settingValue : settingValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingModel].
extension AppSettingModelPatterns on AppSettingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingModel value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'setting_key')  String settingKey, @JsonKey(name: 'setting_value')  Map<String, dynamic> settingValue, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.settingKey,_that.settingValue,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'setting_key')  String settingKey, @JsonKey(name: 'setting_value')  Map<String, dynamic> settingValue, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppSettingModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.settingKey,_that.settingValue,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'setting_key')  String settingKey, @JsonKey(name: 'setting_value')  Map<String, dynamic> settingValue, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.settingKey,_that.settingValue,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettingModel implements AppSettingModel {
  const _AppSettingModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'setting_key') required this.settingKey, @JsonKey(name: 'setting_value') required  Map<String, dynamic> settingValue, @JsonKey(name: 'updated_at') this.updatedAt}): _settingValue = settingValue;
  factory _AppSettingModel.fromJson(Map<String, dynamic> json) => _$AppSettingModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'setting_key') final  String settingKey;
 final  Map<String, dynamic> _settingValue;
@override@JsonKey(name: 'setting_value') Map<String, dynamic> get settingValue {
  if (_settingValue is EqualUnmodifiableMapView) return _settingValue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settingValue);
}

@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of AppSettingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingModelCopyWith<_AppSettingModel> get copyWith => __$AppSettingModelCopyWithImpl<_AppSettingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.settingKey, settingKey) || other.settingKey == settingKey)&&const DeepCollectionEquality().equals(other.settingValue, _settingValue)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,settingKey,const DeepCollectionEquality().hash(_settingValue),updatedAt);
}

@override
String toString() {
    return 'AppSettingModel(id: $id, businessId: $businessId, branchId: $branchId, settingKey: $settingKey, settingValue: $settingValue, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppSettingModelCopyWith<$Res> implements $AppSettingModelCopyWith<$Res> {
  factory _$AppSettingModelCopyWith(_AppSettingModel value, $Res Function(_AppSettingModel) _then) = __$AppSettingModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'setting_key') String settingKey,@JsonKey(name: 'setting_value') Map<String, dynamic> settingValue,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$AppSettingModelCopyWithImpl<$Res>
    implements _$AppSettingModelCopyWith<$Res> {
  __$AppSettingModelCopyWithImpl(this._self, this._then);

  final _AppSettingModel _self;
  final $Res Function(_AppSettingModel) _then;

/// Create a copy of AppSettingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = freezed,Object? settingKey = null,Object? settingValue = null,Object? updatedAt = freezed,}) {
  return _then(_AppSettingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,settingKey: null == settingKey ? _self.settingKey : settingKey // ignore: cast_nullable_to_non_nullable
as String,settingValue: null == settingValue ? _self._settingValue : settingValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
