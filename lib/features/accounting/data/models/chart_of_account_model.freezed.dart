// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_of_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChartOfAccountModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'parent_id') String? get parentId;@JsonKey(name: 'account_code') String get accountCode;@JsonKey(name: 'account_name') String get accountName;@JsonKey(name: 'account_type') String get accountType;@JsonKey(name: 'account_subtype') String? get accountSubtype;@JsonKey(name: 'is_system') bool get isSystem;@JsonKey(name: 'is_active') bool get isActive; String? get description;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt; List<ChartOfAccountModel> get children;
/// Create a copy of ChartOfAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartOfAccountModelCopyWith<ChartOfAccountModel> get copyWith => _$ChartOfAccountModelCopyWithImpl<ChartOfAccountModel>(this as ChartOfAccountModel, _$identity);

  /// Serializes this ChartOfAccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChartOfAccountModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartOfAccountModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.accountCode, _this.accountCode) || other.accountCode == _this.accountCode)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.accountType, _this.accountType) || other.accountType == _this.accountType)&&(identical(other.accountSubtype, _this.accountSubtype) || other.accountSubtype == _this.accountSubtype)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&const DeepCollectionEquality().equals(other.children, _this.children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChartOfAccountModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.parentId,_this.accountCode,_this.accountName,_this.accountType,_this.accountSubtype,_this.isSystem,_this.isActive,_this.description,_this.createdAt,_this.updatedAt,_this.deletedAt,const DeepCollectionEquality().hash(_this.children));
}

@override
String toString() {
  final _this = this as ChartOfAccountModel;
  return 'ChartOfAccountModel(id: ${_this.id}, businessId: ${_this.businessId}, parentId: ${_this.parentId}, accountCode: ${_this.accountCode}, accountName: ${_this.accountName}, accountType: ${_this.accountType}, accountSubtype: ${_this.accountSubtype}, isSystem: ${_this.isSystem}, isActive: ${_this.isActive}, description: ${_this.description}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt}, children: ${_this.children})';
}


}

/// @nodoc
abstract mixin class $ChartOfAccountModelCopyWith<$Res>  {
  factory $ChartOfAccountModelCopyWith(ChartOfAccountModel value, $Res Function(ChartOfAccountModel) _then) = _$ChartOfAccountModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'account_code') String accountCode,@JsonKey(name: 'account_name') String accountName,@JsonKey(name: 'account_type') String accountType,@JsonKey(name: 'account_subtype') String? accountSubtype,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(name: 'is_active') bool isActive, String? description,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt, List<ChartOfAccountModel> children
});




}
/// @nodoc
class _$ChartOfAccountModelCopyWithImpl<$Res>
    implements $ChartOfAccountModelCopyWith<$Res> {
  _$ChartOfAccountModelCopyWithImpl(this._self, this._then);

  final ChartOfAccountModel _self;
  final $Res Function(ChartOfAccountModel) _then;

/// Create a copy of ChartOfAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? parentId = freezed,Object? accountCode = null,Object? accountName = null,Object? accountType = null,Object? accountSubtype = freezed,Object? isSystem = null,Object? isActive = null,Object? description = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? children = null,}) {
  return _then(ChartOfAccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,accountSubtype: freezed == accountSubtype ? _self.accountSubtype : accountSubtype // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartOfAccountModel].
extension ChartOfAccountModelPatterns on ChartOfAccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartOfAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartOfAccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartOfAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _ChartOfAccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartOfAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChartOfAccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'account_code')  String accountCode, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'account_type')  String accountType, @JsonKey(name: 'account_subtype')  String? accountSubtype, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_active')  bool isActive,  String? description, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<ChartOfAccountModel> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartOfAccountModel() when $default != null:
return $default(_that.id,_that.businessId,_that.parentId,_that.accountCode,_that.accountName,_that.accountType,_that.accountSubtype,_that.isSystem,_that.isActive,_that.description,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'account_code')  String accountCode, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'account_type')  String accountType, @JsonKey(name: 'account_subtype')  String? accountSubtype, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_active')  bool isActive,  String? description, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<ChartOfAccountModel> children)  $default,) {final _that = this;
switch (_that) {
case _ChartOfAccountModel():
return $default(_that.id,_that.businessId,_that.parentId,_that.accountCode,_that.accountName,_that.accountType,_that.accountSubtype,_that.isSystem,_that.isActive,_that.description,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'account_code')  String accountCode, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'account_type')  String accountType, @JsonKey(name: 'account_subtype')  String? accountSubtype, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_active')  bool isActive,  String? description, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<ChartOfAccountModel> children)?  $default,) {final _that = this;
switch (_that) {
case _ChartOfAccountModel() when $default != null:
return $default(_that.id,_that.businessId,_that.parentId,_that.accountCode,_that.accountName,_that.accountType,_that.accountSubtype,_that.isSystem,_that.isActive,_that.description,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChartOfAccountModel implements ChartOfAccountModel {
  const _ChartOfAccountModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'account_code') required this.accountCode, @JsonKey(name: 'account_name') required this.accountName, @JsonKey(name: 'account_type') required this.accountType, @JsonKey(name: 'account_subtype') this.accountSubtype, @JsonKey(name: 'is_system') this.isSystem = false, @JsonKey(name: 'is_active') this.isActive = true, this.description, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt,  List<ChartOfAccountModel> children = const []}): _children = children;
  factory _ChartOfAccountModel.fromJson(Map<String, dynamic> json) => _$ChartOfAccountModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey(name: 'account_code') final  String accountCode;
@override@JsonKey(name: 'account_name') final  String accountName;
@override@JsonKey(name: 'account_type') final  String accountType;
@override@JsonKey(name: 'account_subtype') final  String? accountSubtype;
@override@JsonKey(name: 'is_system') final  bool isSystem;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override final  String? description;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;
 final  List<ChartOfAccountModel> _children;
@override@JsonKey() List<ChartOfAccountModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of ChartOfAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartOfAccountModelCopyWith<_ChartOfAccountModel> get copyWith => __$ChartOfAccountModelCopyWithImpl<_ChartOfAccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartOfAccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartOfAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.accountSubtype, accountSubtype) || other.accountSubtype == accountSubtype)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other.children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,parentId,accountCode,accountName,accountType,accountSubtype,isSystem,isActive,description,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(_children));
}

@override
String toString() {
    return 'ChartOfAccountModel(id: $id, businessId: $businessId, parentId: $parentId, accountCode: $accountCode, accountName: $accountName, accountType: $accountType, accountSubtype: $accountSubtype, isSystem: $isSystem, isActive: $isActive, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, children: $children)';
}


}

/// @nodoc
abstract mixin class _$ChartOfAccountModelCopyWith<$Res> implements $ChartOfAccountModelCopyWith<$Res> {
  factory _$ChartOfAccountModelCopyWith(_ChartOfAccountModel value, $Res Function(_ChartOfAccountModel) _then) = __$ChartOfAccountModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'account_code') String accountCode,@JsonKey(name: 'account_name') String accountName,@JsonKey(name: 'account_type') String accountType,@JsonKey(name: 'account_subtype') String? accountSubtype,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(name: 'is_active') bool isActive, String? description,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt, List<ChartOfAccountModel> children
});




}
/// @nodoc
class __$ChartOfAccountModelCopyWithImpl<$Res>
    implements _$ChartOfAccountModelCopyWith<$Res> {
  __$ChartOfAccountModelCopyWithImpl(this._self, this._then);

  final _ChartOfAccountModel _self;
  final $Res Function(_ChartOfAccountModel) _then;

/// Create a copy of ChartOfAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? parentId = freezed,Object? accountCode = null,Object? accountName = null,Object? accountType = null,Object? accountSubtype = freezed,Object? isSystem = null,Object? isActive = null,Object? description = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? children = null,}) {
  return _then(_ChartOfAccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,accountSubtype: freezed == accountSubtype ? _self.accountSubtype : accountSubtype // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,
  ));
}


}

// dart format on
