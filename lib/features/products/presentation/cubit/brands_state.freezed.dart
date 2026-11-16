// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brands_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrandsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BrandsState()';
}


}

/// @nodoc
class $BrandsStateCopyWith<$Res>  {
$BrandsStateCopyWith(BrandsState _, $Res Function(BrandsState) __);
}


/// Adds pattern-matching-related methods to [BrandsState].
extension BrandsStatePatterns on BrandsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BrandsInitial value)?  initial,TResult Function( BrandsLoading value)?  loading,TResult Function( BrandsLoaded value)?  loaded,TResult Function( BrandsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BrandsInitial() when initial != null:
return initial(_that);case BrandsLoading() when loading != null:
return loading(_that);case BrandsLoaded() when loaded != null:
return loaded(_that);case BrandsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BrandsInitial value)  initial,required TResult Function( BrandsLoading value)  loading,required TResult Function( BrandsLoaded value)  loaded,required TResult Function( BrandsError value)  error,}){
final _that = this;
switch (_that) {
case BrandsInitial():
return initial(_that);case BrandsLoading():
return loading(_that);case BrandsLoaded():
return loaded(_that);case BrandsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BrandsInitial value)?  initial,TResult? Function( BrandsLoading value)?  loading,TResult? Function( BrandsLoaded value)?  loaded,TResult? Function( BrandsError value)?  error,}){
final _that = this;
switch (_that) {
case BrandsInitial() when initial != null:
return initial(_that);case BrandsLoading() when loading != null:
return loading(_that);case BrandsLoaded() when loaded != null:
return loaded(_that);case BrandsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BrandModel> brands)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BrandsInitial() when initial != null:
return initial();case BrandsLoading() when loading != null:
return loading();case BrandsLoaded() when loaded != null:
return loaded(_that.brands);case BrandsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BrandModel> brands)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case BrandsInitial():
return initial();case BrandsLoading():
return loading();case BrandsLoaded():
return loaded(_that.brands);case BrandsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BrandModel> brands)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case BrandsInitial() when initial != null:
return initial();case BrandsLoading() when loading != null:
return loading();case BrandsLoaded() when loaded != null:
return loaded(_that.brands);case BrandsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class BrandsInitial implements BrandsState {
  const BrandsInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BrandsState.initial()';
}


}




/// @nodoc


class BrandsLoading implements BrandsState {
  const BrandsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BrandsState.loading()';
}


}




/// @nodoc


class BrandsLoaded implements BrandsState {
  const BrandsLoaded( List<BrandModel> brands): _brands = brands;
  

 final  List<BrandModel> _brands;
 List<BrandModel> get brands {
  if (_brands is EqualUnmodifiableListView) return _brands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brands);
}


/// Create a copy of BrandsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandsLoadedCopyWith<BrandsLoaded> get copyWith => _$BrandsLoadedCopyWithImpl<BrandsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandsLoaded&&const DeepCollectionEquality().equals(other.brands, _brands));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_brands));
}

@override
String toString() {
    return 'BrandsState.loaded(brands: $brands)';
}


}

/// @nodoc
abstract mixin class $BrandsLoadedCopyWith<$Res> implements $BrandsStateCopyWith<$Res> {
  factory $BrandsLoadedCopyWith(BrandsLoaded value, $Res Function(BrandsLoaded) _then) = _$BrandsLoadedCopyWithImpl;
@useResult
$Res call({
 List<BrandModel> brands
});




}
/// @nodoc
class _$BrandsLoadedCopyWithImpl<$Res>
    implements $BrandsLoadedCopyWith<$Res> {
  _$BrandsLoadedCopyWithImpl(this._self, this._then);

  final BrandsLoaded _self;
  final $Res Function(BrandsLoaded) _then;

/// Create a copy of BrandsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? brands = null,}) {
  return _then(BrandsLoaded(
null == brands ? _self._brands : brands // ignore: cast_nullable_to_non_nullable
as List<BrandModel>,
  ));
}


}

/// @nodoc


class BrandsError implements BrandsState {
  const BrandsError(this.message);
  

 final  String message;

/// Create a copy of BrandsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandsErrorCopyWith<BrandsError> get copyWith => _$BrandsErrorCopyWithImpl<BrandsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'BrandsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BrandsErrorCopyWith<$Res> implements $BrandsStateCopyWith<$Res> {
  factory $BrandsErrorCopyWith(BrandsError value, $Res Function(BrandsError) _then) = _$BrandsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BrandsErrorCopyWithImpl<$Res>
    implements $BrandsErrorCopyWith<$Res> {
  _$BrandsErrorCopyWithImpl(this._self, this._then);

  final BrandsError _self;
  final $Res Function(BrandsError) _then;

/// Create a copy of BrandsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BrandsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
