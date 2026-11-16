// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roles_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RolesListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RolesListState()';
}


}

/// @nodoc
class $RolesListStateCopyWith<$Res>  {
$RolesListStateCopyWith(RolesListState _, $Res Function(RolesListState) __);
}


/// Adds pattern-matching-related methods to [RolesListState].
extension RolesListStatePatterns on RolesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RolesListInitial value)?  initial,TResult Function( RolesListLoading value)?  loading,TResult Function( RolesListLoaded value)?  loaded,TResult Function( RolesListAccessDenied value)?  accessDenied,TResult Function( RolesListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RolesListInitial() when initial != null:
return initial(_that);case RolesListLoading() when loading != null:
return loading(_that);case RolesListLoaded() when loaded != null:
return loaded(_that);case RolesListAccessDenied() when accessDenied != null:
return accessDenied(_that);case RolesListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RolesListInitial value)  initial,required TResult Function( RolesListLoading value)  loading,required TResult Function( RolesListLoaded value)  loaded,required TResult Function( RolesListAccessDenied value)  accessDenied,required TResult Function( RolesListError value)  error,}){
final _that = this;
switch (_that) {
case RolesListInitial():
return initial(_that);case RolesListLoading():
return loading(_that);case RolesListLoaded():
return loaded(_that);case RolesListAccessDenied():
return accessDenied(_that);case RolesListError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RolesListInitial value)?  initial,TResult? Function( RolesListLoading value)?  loading,TResult? Function( RolesListLoaded value)?  loaded,TResult? Function( RolesListAccessDenied value)?  accessDenied,TResult? Function( RolesListError value)?  error,}){
final _that = this;
switch (_that) {
case RolesListInitial() when initial != null:
return initial(_that);case RolesListLoading() when loading != null:
return loading(_that);case RolesListLoaded() when loaded != null:
return loaded(_that);case RolesListAccessDenied() when accessDenied != null:
return accessDenied(_that);case RolesListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<RoleModel> roles)?  loaded,TResult Function()?  accessDenied,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RolesListInitial() when initial != null:
return initial();case RolesListLoading() when loading != null:
return loading();case RolesListLoaded() when loaded != null:
return loaded(_that.roles);case RolesListAccessDenied() when accessDenied != null:
return accessDenied();case RolesListError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<RoleModel> roles)  loaded,required TResult Function()  accessDenied,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case RolesListInitial():
return initial();case RolesListLoading():
return loading();case RolesListLoaded():
return loaded(_that.roles);case RolesListAccessDenied():
return accessDenied();case RolesListError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<RoleModel> roles)?  loaded,TResult? Function()?  accessDenied,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case RolesListInitial() when initial != null:
return initial();case RolesListLoading() when loading != null:
return loading();case RolesListLoaded() when loaded != null:
return loaded(_that.roles);case RolesListAccessDenied() when accessDenied != null:
return accessDenied();case RolesListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class RolesListInitial implements RolesListState {
  const RolesListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RolesListState.initial()';
}


}




/// @nodoc


class RolesListLoading implements RolesListState {
  const RolesListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RolesListState.loading()';
}


}




/// @nodoc


class RolesListLoaded implements RolesListState {
  const RolesListLoaded({required  List<RoleModel> roles}): _roles = roles;
  

 final  List<RoleModel> _roles;
 List<RoleModel> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}


/// Create a copy of RolesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RolesListLoadedCopyWith<RolesListLoaded> get copyWith => _$RolesListLoadedCopyWithImpl<RolesListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesListLoaded&&const DeepCollectionEquality().equals(other.roles, _roles));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_roles));
}

@override
String toString() {
    return 'RolesListState.loaded(roles: $roles)';
}


}

/// @nodoc
abstract mixin class $RolesListLoadedCopyWith<$Res> implements $RolesListStateCopyWith<$Res> {
  factory $RolesListLoadedCopyWith(RolesListLoaded value, $Res Function(RolesListLoaded) _then) = _$RolesListLoadedCopyWithImpl;
@useResult
$Res call({
 List<RoleModel> roles
});




}
/// @nodoc
class _$RolesListLoadedCopyWithImpl<$Res>
    implements $RolesListLoadedCopyWith<$Res> {
  _$RolesListLoadedCopyWithImpl(this._self, this._then);

  final RolesListLoaded _self;
  final $Res Function(RolesListLoaded) _then;

/// Create a copy of RolesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roles = null,}) {
  return _then(RolesListLoaded(
roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<RoleModel>,
  ));
}


}

/// @nodoc


class RolesListAccessDenied implements RolesListState {
  const RolesListAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesListAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RolesListState.accessDenied()';
}


}




/// @nodoc


class RolesListError implements RolesListState {
  const RolesListError(this.message);
  

 final  String message;

/// Create a copy of RolesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RolesListErrorCopyWith<RolesListError> get copyWith => _$RolesListErrorCopyWithImpl<RolesListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'RolesListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $RolesListErrorCopyWith<$Res> implements $RolesListStateCopyWith<$Res> {
  factory $RolesListErrorCopyWith(RolesListError value, $Res Function(RolesListError) _then) = _$RolesListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RolesListErrorCopyWithImpl<$Res>
    implements $RolesListErrorCopyWith<$Res> {
  _$RolesListErrorCopyWithImpl(this._self, this._then);

  final RolesListError _self;
  final $Res Function(RolesListError) _then;

/// Create a copy of RolesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RolesListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
