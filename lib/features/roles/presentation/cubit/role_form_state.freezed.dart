// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoleFormState {

 String get mode; String? get roleId; String get name; String get description; bool get isSystem; PermissionsCatalogModel? get catalog; List<String> get selectedPermissionKeys; bool get isLoading; bool get isSubmitting; bool get isDeleting; bool get accessDenied; Map<String, String> get errors;
/// Create a copy of RoleFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleFormStateCopyWith<RoleFormState> get copyWith => _$RoleFormStateCopyWithImpl<RoleFormState>(this as RoleFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoleFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.roleId, _this.roleId) || other.roleId == _this.roleId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.catalog, _this.catalog) || other.catalog == _this.catalog)&&const DeepCollectionEquality().equals(other.selectedPermissionKeys, _this.selectedPermissionKeys)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.accessDenied, _this.accessDenied) || other.accessDenied == _this.accessDenied)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as RoleFormState;
  return Object.hash(runtimeType,_this.mode,_this.roleId,_this.name,_this.description,_this.isSystem,_this.catalog,const DeepCollectionEquality().hash(_this.selectedPermissionKeys),_this.isLoading,_this.isSubmitting,_this.isDeleting,_this.accessDenied,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as RoleFormState;
  return 'RoleFormState(mode: ${_this.mode}, roleId: ${_this.roleId}, name: ${_this.name}, description: ${_this.description}, isSystem: ${_this.isSystem}, catalog: ${_this.catalog}, selectedPermissionKeys: ${_this.selectedPermissionKeys}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, isDeleting: ${_this.isDeleting}, accessDenied: ${_this.accessDenied}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $RoleFormStateCopyWith<$Res>  {
  factory $RoleFormStateCopyWith(RoleFormState value, $Res Function(RoleFormState) _then) = _$RoleFormStateCopyWithImpl;
@useResult
$Res call({
 String mode, String? roleId, String name, String description, bool isSystem, PermissionsCatalogModel? catalog, List<String> selectedPermissionKeys, bool isLoading, bool isSubmitting, bool isDeleting, bool accessDenied, Map<String, String> errors
});


$PermissionsCatalogModelCopyWith<$Res>? get catalog;

}
/// @nodoc
class _$RoleFormStateCopyWithImpl<$Res>
    implements $RoleFormStateCopyWith<$Res> {
  _$RoleFormStateCopyWithImpl(this._self, this._then);

  final RoleFormState _self;
  final $Res Function(RoleFormState) _then;

/// Create a copy of RoleFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? roleId = freezed,Object? name = null,Object? description = null,Object? isSystem = null,Object? catalog = freezed,Object? selectedPermissionKeys = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? accessDenied = null,Object? errors = null,}) {
  return _then(RoleFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as PermissionsCatalogModel?,selectedPermissionKeys: null == selectedPermissionKeys ? _self.selectedPermissionKeys : selectedPermissionKeys // ignore: cast_nullable_to_non_nullable
as List<String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of RoleFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionsCatalogModelCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $PermissionsCatalogModelCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoleFormState].
extension RoleFormStatePatterns on RoleFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleFormState value)  $default,){
final _that = this;
switch (_that) {
case _RoleFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleFormState value)?  $default,){
final _that = this;
switch (_that) {
case _RoleFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  String? roleId,  String name,  String description,  bool isSystem,  PermissionsCatalogModel? catalog,  List<String> selectedPermissionKeys,  bool isLoading,  bool isSubmitting,  bool isDeleting,  bool accessDenied,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleFormState() when $default != null:
return $default(_that.mode,_that.roleId,_that.name,_that.description,_that.isSystem,_that.catalog,_that.selectedPermissionKeys,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.accessDenied,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  String? roleId,  String name,  String description,  bool isSystem,  PermissionsCatalogModel? catalog,  List<String> selectedPermissionKeys,  bool isLoading,  bool isSubmitting,  bool isDeleting,  bool accessDenied,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _RoleFormState():
return $default(_that.mode,_that.roleId,_that.name,_that.description,_that.isSystem,_that.catalog,_that.selectedPermissionKeys,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.accessDenied,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  String? roleId,  String name,  String description,  bool isSystem,  PermissionsCatalogModel? catalog,  List<String> selectedPermissionKeys,  bool isLoading,  bool isSubmitting,  bool isDeleting,  bool accessDenied,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _RoleFormState() when $default != null:
return $default(_that.mode,_that.roleId,_that.name,_that.description,_that.isSystem,_that.catalog,_that.selectedPermissionKeys,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.accessDenied,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _RoleFormState implements RoleFormState {
  const _RoleFormState({this.mode = 'create', this.roleId, this.name = '', this.description = '', this.isSystem = false, this.catalog,  List<String> selectedPermissionKeys = const [], this.isLoading = false, this.isSubmitting = false, this.isDeleting = false, this.accessDenied = false,  Map<String, String> errors = const {}}): _selectedPermissionKeys = selectedPermissionKeys,_errors = errors;
  

@override@JsonKey() final  String mode;
@override final  String? roleId;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isSystem;
@override final  PermissionsCatalogModel? catalog;
 final  List<String> _selectedPermissionKeys;
@override@JsonKey() List<String> get selectedPermissionKeys {
  if (_selectedPermissionKeys is EqualUnmodifiableListView) return _selectedPermissionKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedPermissionKeys);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isDeleting;
@override@JsonKey() final  bool accessDenied;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of RoleFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleFormStateCopyWith<_RoleFormState> get copyWith => __$RoleFormStateCopyWithImpl<_RoleFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&const DeepCollectionEquality().equals(other.selectedPermissionKeys, _selectedPermissionKeys)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.accessDenied, accessDenied) || other.accessDenied == accessDenied)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,roleId,name,description,isSystem,catalog,const DeepCollectionEquality().hash(_selectedPermissionKeys),isLoading,isSubmitting,isDeleting,accessDenied,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'RoleFormState(mode: $mode, roleId: $roleId, name: $name, description: $description, isSystem: $isSystem, catalog: $catalog, selectedPermissionKeys: $selectedPermissionKeys, isLoading: $isLoading, isSubmitting: $isSubmitting, isDeleting: $isDeleting, accessDenied: $accessDenied, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$RoleFormStateCopyWith<$Res> implements $RoleFormStateCopyWith<$Res> {
  factory _$RoleFormStateCopyWith(_RoleFormState value, $Res Function(_RoleFormState) _then) = __$RoleFormStateCopyWithImpl;
@override @useResult
$Res call({
 String mode, String? roleId, String name, String description, bool isSystem, PermissionsCatalogModel? catalog, List<String> selectedPermissionKeys, bool isLoading, bool isSubmitting, bool isDeleting, bool accessDenied, Map<String, String> errors
});


@override $PermissionsCatalogModelCopyWith<$Res>? get catalog;

}
/// @nodoc
class __$RoleFormStateCopyWithImpl<$Res>
    implements _$RoleFormStateCopyWith<$Res> {
  __$RoleFormStateCopyWithImpl(this._self, this._then);

  final _RoleFormState _self;
  final $Res Function(_RoleFormState) _then;

/// Create a copy of RoleFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? roleId = freezed,Object? name = null,Object? description = null,Object? isSystem = null,Object? catalog = freezed,Object? selectedPermissionKeys = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? accessDenied = null,Object? errors = null,}) {
  return _then(_RoleFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as PermissionsCatalogModel?,selectedPermissionKeys: null == selectedPermissionKeys ? _self._selectedPermissionKeys : selectedPermissionKeys // ignore: cast_nullable_to_non_nullable
as List<String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of RoleFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionsCatalogModelCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $PermissionsCatalogModelCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}

// dart format on
