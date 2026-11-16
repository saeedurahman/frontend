// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReturnDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnDetailState()';
}


}

/// @nodoc
class $ReturnDetailStateCopyWith<$Res>  {
$ReturnDetailStateCopyWith(ReturnDetailState _, $Res Function(ReturnDetailState) __);
}


/// Adds pattern-matching-related methods to [ReturnDetailState].
extension ReturnDetailStatePatterns on ReturnDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReturnDetailInitial value)?  initial,TResult Function( ReturnDetailLoading value)?  loading,TResult Function( ReturnDetailLoaded value)?  loaded,TResult Function( ReturnDetailAccessDenied value)?  accessDenied,TResult Function( ReturnDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReturnDetailInitial() when initial != null:
return initial(_that);case ReturnDetailLoading() when loading != null:
return loading(_that);case ReturnDetailLoaded() when loaded != null:
return loaded(_that);case ReturnDetailAccessDenied() when accessDenied != null:
return accessDenied(_that);case ReturnDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReturnDetailInitial value)  initial,required TResult Function( ReturnDetailLoading value)  loading,required TResult Function( ReturnDetailLoaded value)  loaded,required TResult Function( ReturnDetailAccessDenied value)  accessDenied,required TResult Function( ReturnDetailError value)  error,}){
final _that = this;
switch (_that) {
case ReturnDetailInitial():
return initial(_that);case ReturnDetailLoading():
return loading(_that);case ReturnDetailLoaded():
return loaded(_that);case ReturnDetailAccessDenied():
return accessDenied(_that);case ReturnDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReturnDetailInitial value)?  initial,TResult? Function( ReturnDetailLoading value)?  loading,TResult? Function( ReturnDetailLoaded value)?  loaded,TResult? Function( ReturnDetailAccessDenied value)?  accessDenied,TResult? Function( ReturnDetailError value)?  error,}){
final _that = this;
switch (_that) {
case ReturnDetailInitial() when initial != null:
return initial(_that);case ReturnDetailLoading() when loading != null:
return loading(_that);case ReturnDetailLoaded() when loaded != null:
return loaded(_that);case ReturnDetailAccessDenied() when accessDenied != null:
return accessDenied(_that);case ReturnDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( SaleReturnResponseModel item)?  loaded,TResult Function()?  accessDenied,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReturnDetailInitial() when initial != null:
return initial();case ReturnDetailLoading() when loading != null:
return loading();case ReturnDetailLoaded() when loaded != null:
return loaded(_that.item);case ReturnDetailAccessDenied() when accessDenied != null:
return accessDenied();case ReturnDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( SaleReturnResponseModel item)  loaded,required TResult Function()  accessDenied,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ReturnDetailInitial():
return initial();case ReturnDetailLoading():
return loading();case ReturnDetailLoaded():
return loaded(_that.item);case ReturnDetailAccessDenied():
return accessDenied();case ReturnDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( SaleReturnResponseModel item)?  loaded,TResult? Function()?  accessDenied,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ReturnDetailInitial() when initial != null:
return initial();case ReturnDetailLoading() when loading != null:
return loading();case ReturnDetailLoaded() when loaded != null:
return loaded(_that.item);case ReturnDetailAccessDenied() when accessDenied != null:
return accessDenied();case ReturnDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ReturnDetailInitial implements ReturnDetailState {
  const ReturnDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnDetailState.initial()';
}


}




/// @nodoc


class ReturnDetailLoading implements ReturnDetailState {
  const ReturnDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnDetailState.loading()';
}


}




/// @nodoc


class ReturnDetailLoaded implements ReturnDetailState {
  const ReturnDetailLoaded({required this.item});
  

 final  SaleReturnResponseModel item;

/// Create a copy of ReturnDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnDetailLoadedCopyWith<ReturnDetailLoaded> get copyWith => _$ReturnDetailLoadedCopyWithImpl<ReturnDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDetailLoaded&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode {
    return Object.hash(runtimeType,item);
}

@override
String toString() {
    return 'ReturnDetailState.loaded(item: $item)';
}


}

/// @nodoc
abstract mixin class $ReturnDetailLoadedCopyWith<$Res> implements $ReturnDetailStateCopyWith<$Res> {
  factory $ReturnDetailLoadedCopyWith(ReturnDetailLoaded value, $Res Function(ReturnDetailLoaded) _then) = _$ReturnDetailLoadedCopyWithImpl;
@useResult
$Res call({
 SaleReturnResponseModel item
});


$SaleReturnResponseModelCopyWith<$Res> get item;

}
/// @nodoc
class _$ReturnDetailLoadedCopyWithImpl<$Res>
    implements $ReturnDetailLoadedCopyWith<$Res> {
  _$ReturnDetailLoadedCopyWithImpl(this._self, this._then);

  final ReturnDetailLoaded _self;
  final $Res Function(ReturnDetailLoaded) _then;

/// Create a copy of ReturnDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(ReturnDetailLoaded(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as SaleReturnResponseModel,
  ));
}

/// Create a copy of ReturnDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaleReturnResponseModelCopyWith<$Res> get item {
  
  return $SaleReturnResponseModelCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class ReturnDetailAccessDenied implements ReturnDetailState {
  const ReturnDetailAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDetailAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnDetailState.accessDenied()';
}


}




/// @nodoc


class ReturnDetailError implements ReturnDetailState {
  const ReturnDetailError(this.message);
  

 final  String message;

/// Create a copy of ReturnDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnDetailErrorCopyWith<ReturnDetailError> get copyWith => _$ReturnDetailErrorCopyWithImpl<ReturnDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ReturnDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ReturnDetailErrorCopyWith<$Res> implements $ReturnDetailStateCopyWith<$Res> {
  factory $ReturnDetailErrorCopyWith(ReturnDetailError value, $Res Function(ReturnDetailError) _then) = _$ReturnDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ReturnDetailErrorCopyWithImpl<$Res>
    implements $ReturnDetailErrorCopyWith<$Res> {
  _$ReturnDetailErrorCopyWithImpl(this._self, this._then);

  final ReturnDetailError _self;
  final $Res Function(ReturnDetailError) _then;

/// Create a copy of ReturnDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ReturnDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
