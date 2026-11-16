// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'units_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnitsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UnitsState()';
}


}

/// @nodoc
class $UnitsStateCopyWith<$Res>  {
$UnitsStateCopyWith(UnitsState _, $Res Function(UnitsState) __);
}


/// Adds pattern-matching-related methods to [UnitsState].
extension UnitsStatePatterns on UnitsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UnitsInitial value)?  initial,TResult Function( UnitsLoading value)?  loading,TResult Function( UnitsLoaded value)?  loaded,TResult Function( UnitsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UnitsInitial() when initial != null:
return initial(_that);case UnitsLoading() when loading != null:
return loading(_that);case UnitsLoaded() when loaded != null:
return loaded(_that);case UnitsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UnitsInitial value)  initial,required TResult Function( UnitsLoading value)  loading,required TResult Function( UnitsLoaded value)  loaded,required TResult Function( UnitsError value)  error,}){
final _that = this;
switch (_that) {
case UnitsInitial():
return initial(_that);case UnitsLoading():
return loading(_that);case UnitsLoaded():
return loaded(_that);case UnitsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UnitsInitial value)?  initial,TResult? Function( UnitsLoading value)?  loading,TResult? Function( UnitsLoaded value)?  loaded,TResult? Function( UnitsError value)?  error,}){
final _that = this;
switch (_that) {
case UnitsInitial() when initial != null:
return initial(_that);case UnitsLoading() when loading != null:
return loading(_that);case UnitsLoaded() when loaded != null:
return loaded(_that);case UnitsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<UnitModel> units)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UnitsInitial() when initial != null:
return initial();case UnitsLoading() when loading != null:
return loading();case UnitsLoaded() when loaded != null:
return loaded(_that.units);case UnitsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<UnitModel> units)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UnitsInitial():
return initial();case UnitsLoading():
return loading();case UnitsLoaded():
return loaded(_that.units);case UnitsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<UnitModel> units)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UnitsInitial() when initial != null:
return initial();case UnitsLoading() when loading != null:
return loading();case UnitsLoaded() when loaded != null:
return loaded(_that.units);case UnitsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UnitsInitial implements UnitsState {
  const UnitsInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UnitsState.initial()';
}


}




/// @nodoc


class UnitsLoading implements UnitsState {
  const UnitsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UnitsState.loading()';
}


}




/// @nodoc


class UnitsLoaded implements UnitsState {
  const UnitsLoaded( List<UnitModel> units): _units = units;
  

 final  List<UnitModel> _units;
 List<UnitModel> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}


/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitsLoadedCopyWith<UnitsLoaded> get copyWith => _$UnitsLoadedCopyWithImpl<UnitsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsLoaded&&const DeepCollectionEquality().equals(other.units, _units));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_units));
}

@override
String toString() {
    return 'UnitsState.loaded(units: $units)';
}


}

/// @nodoc
abstract mixin class $UnitsLoadedCopyWith<$Res> implements $UnitsStateCopyWith<$Res> {
  factory $UnitsLoadedCopyWith(UnitsLoaded value, $Res Function(UnitsLoaded) _then) = _$UnitsLoadedCopyWithImpl;
@useResult
$Res call({
 List<UnitModel> units
});




}
/// @nodoc
class _$UnitsLoadedCopyWithImpl<$Res>
    implements $UnitsLoadedCopyWith<$Res> {
  _$UnitsLoadedCopyWithImpl(this._self, this._then);

  final UnitsLoaded _self;
  final $Res Function(UnitsLoaded) _then;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? units = null,}) {
  return _then(UnitsLoaded(
null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<UnitModel>,
  ));
}


}

/// @nodoc


class UnitsError implements UnitsState {
  const UnitsError(this.message);
  

 final  String message;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitsErrorCopyWith<UnitsError> get copyWith => _$UnitsErrorCopyWithImpl<UnitsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'UnitsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnitsErrorCopyWith<$Res> implements $UnitsStateCopyWith<$Res> {
  factory $UnitsErrorCopyWith(UnitsError value, $Res Function(UnitsError) _then) = _$UnitsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnitsErrorCopyWithImpl<$Res>
    implements $UnitsErrorCopyWith<$Res> {
  _$UnitsErrorCopyWithImpl(this._self, this._then);

  final UnitsError _self;
  final $Res Function(UnitsError) _then;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnitsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
