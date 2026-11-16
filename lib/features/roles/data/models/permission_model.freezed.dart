// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermissionModel {

@JsonKey(name: 'permission_key') String get permissionKey; String get description;
/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionModelCopyWith<PermissionModel> get copyWith => _$PermissionModelCopyWithImpl<PermissionModel>(this as PermissionModel, _$identity);

  /// Serializes this PermissionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PermissionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionModel&&(identical(other.permissionKey, _this.permissionKey) || other.permissionKey == _this.permissionKey)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PermissionModel;
  return Object.hash(runtimeType,_this.permissionKey,_this.description);
}

@override
String toString() {
  final _this = this as PermissionModel;
  return 'PermissionModel(permissionKey: ${_this.permissionKey}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $PermissionModelCopyWith<$Res>  {
  factory $PermissionModelCopyWith(PermissionModel value, $Res Function(PermissionModel) _then) = _$PermissionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'permission_key') String permissionKey, String description
});




}
/// @nodoc
class _$PermissionModelCopyWithImpl<$Res>
    implements $PermissionModelCopyWith<$Res> {
  _$PermissionModelCopyWithImpl(this._self, this._then);

  final PermissionModel _self;
  final $Res Function(PermissionModel) _then;

/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permissionKey = null,Object? description = null,}) {
  return _then(PermissionModel(
permissionKey: null == permissionKey ? _self.permissionKey : permissionKey // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionModel].
extension PermissionModelPatterns on PermissionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'permission_key')  String permissionKey,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
return $default(_that.permissionKey,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'permission_key')  String permissionKey,  String description)  $default,) {final _that = this;
switch (_that) {
case _PermissionModel():
return $default(_that.permissionKey,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'permission_key')  String permissionKey,  String description)?  $default,) {final _that = this;
switch (_that) {
case _PermissionModel() when $default != null:
return $default(_that.permissionKey,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionModel implements PermissionModel {
  const _PermissionModel({@JsonKey(name: 'permission_key') required this.permissionKey, required this.description});
  factory _PermissionModel.fromJson(Map<String, dynamic> json) => _$PermissionModelFromJson(json);

@override@JsonKey(name: 'permission_key') final  String permissionKey;
@override final  String description;

/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionModelCopyWith<_PermissionModel> get copyWith => __$PermissionModelCopyWithImpl<_PermissionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionModel&&(identical(other.permissionKey, permissionKey) || other.permissionKey == permissionKey)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,permissionKey,description);
}

@override
String toString() {
    return 'PermissionModel(permissionKey: $permissionKey, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PermissionModelCopyWith<$Res> implements $PermissionModelCopyWith<$Res> {
  factory _$PermissionModelCopyWith(_PermissionModel value, $Res Function(_PermissionModel) _then) = __$PermissionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'permission_key') String permissionKey, String description
});




}
/// @nodoc
class __$PermissionModelCopyWithImpl<$Res>
    implements _$PermissionModelCopyWith<$Res> {
  __$PermissionModelCopyWithImpl(this._self, this._then);

  final _PermissionModel _self;
  final $Res Function(_PermissionModel) _then;

/// Create a copy of PermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permissionKey = null,Object? description = null,}) {
  return _then(_PermissionModel(
permissionKey: null == permissionKey ? _self.permissionKey : permissionKey // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PermissionModuleModel {

 String get module; List<PermissionModel> get permissions;
/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionModuleModelCopyWith<PermissionModuleModel> get copyWith => _$PermissionModuleModelCopyWithImpl<PermissionModuleModel>(this as PermissionModuleModel, _$identity);

  /// Serializes this PermissionModuleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PermissionModuleModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionModuleModel&&(identical(other.module, _this.module) || other.module == _this.module)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PermissionModuleModel;
  return Object.hash(runtimeType,_this.module,const DeepCollectionEquality().hash(_this.permissions));
}

@override
String toString() {
  final _this = this as PermissionModuleModel;
  return 'PermissionModuleModel(module: ${_this.module}, permissions: ${_this.permissions})';
}


}

/// @nodoc
abstract mixin class $PermissionModuleModelCopyWith<$Res>  {
  factory $PermissionModuleModelCopyWith(PermissionModuleModel value, $Res Function(PermissionModuleModel) _then) = _$PermissionModuleModelCopyWithImpl;
@useResult
$Res call({
 String module, List<PermissionModel> permissions
});




}
/// @nodoc
class _$PermissionModuleModelCopyWithImpl<$Res>
    implements $PermissionModuleModelCopyWith<$Res> {
  _$PermissionModuleModelCopyWithImpl(this._self, this._then);

  final PermissionModuleModel _self;
  final $Res Function(PermissionModuleModel) _then;

/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? module = null,Object? permissions = null,}) {
  return _then(PermissionModuleModel(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<PermissionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionModuleModel].
extension PermissionModuleModelPatterns on PermissionModuleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionModuleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionModuleModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionModuleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionModuleModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String module,  List<PermissionModel> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
return $default(_that.module,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String module,  List<PermissionModel> permissions)  $default,) {final _that = this;
switch (_that) {
case _PermissionModuleModel():
return $default(_that.module,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String module,  List<PermissionModel> permissions)?  $default,) {final _that = this;
switch (_that) {
case _PermissionModuleModel() when $default != null:
return $default(_that.module,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionModuleModel implements PermissionModuleModel {
  const _PermissionModuleModel({required this.module,  List<PermissionModel> permissions = const []}): _permissions = permissions;
  factory _PermissionModuleModel.fromJson(Map<String, dynamic> json) => _$PermissionModuleModelFromJson(json);

@override final  String module;
 final  List<PermissionModel> _permissions;
@override@JsonKey() List<PermissionModel> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}


/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionModuleModelCopyWith<_PermissionModuleModel> get copyWith => __$PermissionModuleModelCopyWithImpl<_PermissionModuleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionModuleModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionModuleModel&&(identical(other.module, module) || other.module == module)&&const DeepCollectionEquality().equals(other.permissions, _permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,module,const DeepCollectionEquality().hash(_permissions));
}

@override
String toString() {
    return 'PermissionModuleModel(module: $module, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$PermissionModuleModelCopyWith<$Res> implements $PermissionModuleModelCopyWith<$Res> {
  factory _$PermissionModuleModelCopyWith(_PermissionModuleModel value, $Res Function(_PermissionModuleModel) _then) = __$PermissionModuleModelCopyWithImpl;
@override @useResult
$Res call({
 String module, List<PermissionModel> permissions
});




}
/// @nodoc
class __$PermissionModuleModelCopyWithImpl<$Res>
    implements _$PermissionModuleModelCopyWith<$Res> {
  __$PermissionModuleModelCopyWithImpl(this._self, this._then);

  final _PermissionModuleModel _self;
  final $Res Function(_PermissionModuleModel) _then;

/// Create a copy of PermissionModuleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? module = null,Object? permissions = null,}) {
  return _then(_PermissionModuleModel(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<PermissionModel>,
  ));
}


}


/// @nodoc
mixin _$PermissionsCatalogModel {

 List<PermissionModuleModel> get modules;
/// Create a copy of PermissionsCatalogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionsCatalogModelCopyWith<PermissionsCatalogModel> get copyWith => _$PermissionsCatalogModelCopyWithImpl<PermissionsCatalogModel>(this as PermissionsCatalogModel, _$identity);

  /// Serializes this PermissionsCatalogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PermissionsCatalogModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionsCatalogModel&&const DeepCollectionEquality().equals(other.modules, _this.modules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PermissionsCatalogModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.modules));
}

@override
String toString() {
  final _this = this as PermissionsCatalogModel;
  return 'PermissionsCatalogModel(modules: ${_this.modules})';
}


}

/// @nodoc
abstract mixin class $PermissionsCatalogModelCopyWith<$Res>  {
  factory $PermissionsCatalogModelCopyWith(PermissionsCatalogModel value, $Res Function(PermissionsCatalogModel) _then) = _$PermissionsCatalogModelCopyWithImpl;
@useResult
$Res call({
 List<PermissionModuleModel> modules
});




}
/// @nodoc
class _$PermissionsCatalogModelCopyWithImpl<$Res>
    implements $PermissionsCatalogModelCopyWith<$Res> {
  _$PermissionsCatalogModelCopyWithImpl(this._self, this._then);

  final PermissionsCatalogModel _self;
  final $Res Function(PermissionsCatalogModel) _then;

/// Create a copy of PermissionsCatalogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modules = null,}) {
  return _then(PermissionsCatalogModel(
modules: null == modules ? _self.modules : modules // ignore: cast_nullable_to_non_nullable
as List<PermissionModuleModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionsCatalogModel].
extension PermissionsCatalogModelPatterns on PermissionsCatalogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionsCatalogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionsCatalogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionsCatalogModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionsCatalogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionsCatalogModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionsCatalogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PermissionModuleModel> modules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionsCatalogModel() when $default != null:
return $default(_that.modules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PermissionModuleModel> modules)  $default,) {final _that = this;
switch (_that) {
case _PermissionsCatalogModel():
return $default(_that.modules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PermissionModuleModel> modules)?  $default,) {final _that = this;
switch (_that) {
case _PermissionsCatalogModel() when $default != null:
return $default(_that.modules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionsCatalogModel implements PermissionsCatalogModel {
  const _PermissionsCatalogModel({ List<PermissionModuleModel> modules = const []}): _modules = modules;
  factory _PermissionsCatalogModel.fromJson(Map<String, dynamic> json) => _$PermissionsCatalogModelFromJson(json);

 final  List<PermissionModuleModel> _modules;
@override@JsonKey() List<PermissionModuleModel> get modules {
  if (_modules is EqualUnmodifiableListView) return _modules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modules);
}


/// Create a copy of PermissionsCatalogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionsCatalogModelCopyWith<_PermissionsCatalogModel> get copyWith => __$PermissionsCatalogModelCopyWithImpl<_PermissionsCatalogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionsCatalogModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionsCatalogModel&&const DeepCollectionEquality().equals(other.modules, _modules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_modules));
}

@override
String toString() {
    return 'PermissionsCatalogModel(modules: $modules)';
}


}

/// @nodoc
abstract mixin class _$PermissionsCatalogModelCopyWith<$Res> implements $PermissionsCatalogModelCopyWith<$Res> {
  factory _$PermissionsCatalogModelCopyWith(_PermissionsCatalogModel value, $Res Function(_PermissionsCatalogModel) _then) = __$PermissionsCatalogModelCopyWithImpl;
@override @useResult
$Res call({
 List<PermissionModuleModel> modules
});




}
/// @nodoc
class __$PermissionsCatalogModelCopyWithImpl<$Res>
    implements _$PermissionsCatalogModelCopyWith<$Res> {
  __$PermissionsCatalogModelCopyWithImpl(this._self, this._then);

  final _PermissionsCatalogModel _self;
  final $Res Function(_PermissionsCatalogModel) _then;

/// Create a copy of PermissionsCatalogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modules = null,}) {
  return _then(_PermissionsCatalogModel(
modules: null == modules ? _self._modules : modules // ignore: cast_nullable_to_non_nullable
as List<PermissionModuleModel>,
  ));
}


}

// dart format on
