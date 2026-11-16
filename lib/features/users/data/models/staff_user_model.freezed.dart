// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffUserModel {

 String get id;@JsonKey(name: 'full_name') String get fullName; String? get phone;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'branch_name') String? get branchName; List<StaffRoleModel> get roles;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_login_at') String? get lastLoginAt;
/// Create a copy of StaffUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffUserModelCopyWith<StaffUserModel> get copyWith => _$StaffUserModelCopyWithImpl<StaffUserModel>(this as StaffUserModel, _$identity);

  /// Serializes this StaffUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffUserModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffUserModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.branchName, _this.branchName) || other.branchName == _this.branchName)&&const DeepCollectionEquality().equals(other.roles, _this.roles)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.lastLoginAt, _this.lastLoginAt) || other.lastLoginAt == _this.lastLoginAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffUserModel;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.phone,_this.branchId,_this.branchName,const DeepCollectionEquality().hash(_this.roles),_this.isActive,_this.lastLoginAt);
}

@override
String toString() {
  final _this = this as StaffUserModel;
  return 'StaffUserModel(id: ${_this.id}, fullName: ${_this.fullName}, phone: ${_this.phone}, branchId: ${_this.branchId}, branchName: ${_this.branchName}, roles: ${_this.roles}, isActive: ${_this.isActive}, lastLoginAt: ${_this.lastLoginAt})';
}


}

/// @nodoc
abstract mixin class $StaffUserModelCopyWith<$Res>  {
  factory $StaffUserModelCopyWith(StaffUserModel value, $Res Function(StaffUserModel) _then) = _$StaffUserModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName, String? phone,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'branch_name') String? branchName, List<StaffRoleModel> roles,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_login_at') String? lastLoginAt
});




}
/// @nodoc
class _$StaffUserModelCopyWithImpl<$Res>
    implements $StaffUserModelCopyWith<$Res> {
  _$StaffUserModelCopyWithImpl(this._self, this._then);

  final StaffUserModel _self;
  final $Res Function(StaffUserModel) _then;

/// Create a copy of StaffUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? branchId = freezed,Object? branchName = freezed,Object? roles = null,Object? isActive = null,Object? lastLoginAt = freezed,}) {
  return _then(StaffUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<StaffRoleModel>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffUserModel].
extension StaffUserModelPatterns on StaffUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffUserModel value)  $default,){
final _that = this;
switch (_that) {
case _StaffUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _StaffUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName,  String? phone, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'branch_name')  String? branchName,  List<StaffRoleModel> roles, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')  String? lastLoginAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.branchId,_that.branchName,_that.roles,_that.isActive,_that.lastLoginAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName,  String? phone, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'branch_name')  String? branchName,  List<StaffRoleModel> roles, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')  String? lastLoginAt)  $default,) {final _that = this;
switch (_that) {
case _StaffUserModel():
return $default(_that.id,_that.fullName,_that.phone,_that.branchId,_that.branchName,_that.roles,_that.isActive,_that.lastLoginAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String fullName,  String? phone, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'branch_name')  String? branchName,  List<StaffRoleModel> roles, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')  String? lastLoginAt)?  $default,) {final _that = this;
switch (_that) {
case _StaffUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.branchId,_that.branchName,_that.roles,_that.isActive,_that.lastLoginAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffUserModel implements StaffUserModel {
  const _StaffUserModel({required this.id, @JsonKey(name: 'full_name') required this.fullName, this.phone, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'branch_name') this.branchName,  List<StaffRoleModel> roles = const [], @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_login_at') this.lastLoginAt}): _roles = roles;
  factory _StaffUserModel.fromJson(Map<String, dynamic> json) => _$StaffUserModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String? phone;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'branch_name') final  String? branchName;
 final  List<StaffRoleModel> _roles;
@override@JsonKey() List<StaffRoleModel> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_login_at') final  String? lastLoginAt;

/// Create a copy of StaffUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffUserModelCopyWith<_StaffUserModel> get copyWith => __$StaffUserModelCopyWithImpl<_StaffUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&const DeepCollectionEquality().equals(other.roles, _roles)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,phone,branchId,branchName,const DeepCollectionEquality().hash(_roles),isActive,lastLoginAt);
}

@override
String toString() {
    return 'StaffUserModel(id: $id, fullName: $fullName, phone: $phone, branchId: $branchId, branchName: $branchName, roles: $roles, isActive: $isActive, lastLoginAt: $lastLoginAt)';
}


}

/// @nodoc
abstract mixin class _$StaffUserModelCopyWith<$Res> implements $StaffUserModelCopyWith<$Res> {
  factory _$StaffUserModelCopyWith(_StaffUserModel value, $Res Function(_StaffUserModel) _then) = __$StaffUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName, String? phone,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'branch_name') String? branchName, List<StaffRoleModel> roles,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_login_at') String? lastLoginAt
});




}
/// @nodoc
class __$StaffUserModelCopyWithImpl<$Res>
    implements _$StaffUserModelCopyWith<$Res> {
  __$StaffUserModelCopyWithImpl(this._self, this._then);

  final _StaffUserModel _self;
  final $Res Function(_StaffUserModel) _then;

/// Create a copy of StaffUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? branchId = freezed,Object? branchName = freezed,Object? roles = null,Object? isActive = null,Object? lastLoginAt = freezed,}) {
  return _then(_StaffUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<StaffRoleModel>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
