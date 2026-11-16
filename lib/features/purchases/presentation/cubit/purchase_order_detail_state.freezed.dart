// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchaseOrderDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PurchaseOrderDetailState()';
}


}

/// @nodoc
class $PurchaseOrderDetailStateCopyWith<$Res>  {
$PurchaseOrderDetailStateCopyWith(PurchaseOrderDetailState _, $Res Function(PurchaseOrderDetailState) __);
}


/// Adds pattern-matching-related methods to [PurchaseOrderDetailState].
extension PurchaseOrderDetailStatePatterns on PurchaseOrderDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PurchaseOrderDetailInitial value)?  initial,TResult Function( PurchaseOrderDetailLoading value)?  loading,TResult Function( PurchaseOrderDetailLoaded value)?  loaded,TResult Function( PurchaseOrderDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PurchaseOrderDetailInitial() when initial != null:
return initial(_that);case PurchaseOrderDetailLoading() when loading != null:
return loading(_that);case PurchaseOrderDetailLoaded() when loaded != null:
return loaded(_that);case PurchaseOrderDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PurchaseOrderDetailInitial value)  initial,required TResult Function( PurchaseOrderDetailLoading value)  loading,required TResult Function( PurchaseOrderDetailLoaded value)  loaded,required TResult Function( PurchaseOrderDetailError value)  error,}){
final _that = this;
switch (_that) {
case PurchaseOrderDetailInitial():
return initial(_that);case PurchaseOrderDetailLoading():
return loading(_that);case PurchaseOrderDetailLoaded():
return loaded(_that);case PurchaseOrderDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PurchaseOrderDetailInitial value)?  initial,TResult? Function( PurchaseOrderDetailLoading value)?  loading,TResult? Function( PurchaseOrderDetailLoaded value)?  loaded,TResult? Function( PurchaseOrderDetailError value)?  error,}){
final _that = this;
switch (_that) {
case PurchaseOrderDetailInitial() when initial != null:
return initial(_that);case PurchaseOrderDetailLoading() when loading != null:
return loading(_that);case PurchaseOrderDetailLoaded() when loaded != null:
return loaded(_that);case PurchaseOrderDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PurchaseOrderModel order,  bool isUpdating)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PurchaseOrderDetailInitial() when initial != null:
return initial();case PurchaseOrderDetailLoading() when loading != null:
return loading();case PurchaseOrderDetailLoaded() when loaded != null:
return loaded(_that.order,_that.isUpdating);case PurchaseOrderDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PurchaseOrderModel order,  bool isUpdating)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PurchaseOrderDetailInitial():
return initial();case PurchaseOrderDetailLoading():
return loading();case PurchaseOrderDetailLoaded():
return loaded(_that.order,_that.isUpdating);case PurchaseOrderDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PurchaseOrderModel order,  bool isUpdating)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PurchaseOrderDetailInitial() when initial != null:
return initial();case PurchaseOrderDetailLoading() when loading != null:
return loading();case PurchaseOrderDetailLoaded() when loaded != null:
return loaded(_that.order,_that.isUpdating);case PurchaseOrderDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PurchaseOrderDetailInitial implements PurchaseOrderDetailState {
  const PurchaseOrderDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PurchaseOrderDetailState.initial()';
}


}




/// @nodoc


class PurchaseOrderDetailLoading implements PurchaseOrderDetailState {
  const PurchaseOrderDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PurchaseOrderDetailState.loading()';
}


}




/// @nodoc


class PurchaseOrderDetailLoaded implements PurchaseOrderDetailState {
  const PurchaseOrderDetailLoaded({required this.order, this.isUpdating = false});
  

 final  PurchaseOrderModel order;
@JsonKey() final  bool isUpdating;

/// Create a copy of PurchaseOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderDetailLoadedCopyWith<PurchaseOrderDetailLoaded> get copyWith => _$PurchaseOrderDetailLoadedCopyWithImpl<PurchaseOrderDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetailLoaded&&(identical(other.order, order) || other.order == order)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating));
}


@override
int get hashCode {
    return Object.hash(runtimeType,order,isUpdating);
}

@override
String toString() {
    return 'PurchaseOrderDetailState.loaded(order: $order, isUpdating: $isUpdating)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderDetailLoadedCopyWith<$Res> implements $PurchaseOrderDetailStateCopyWith<$Res> {
  factory $PurchaseOrderDetailLoadedCopyWith(PurchaseOrderDetailLoaded value, $Res Function(PurchaseOrderDetailLoaded) _then) = _$PurchaseOrderDetailLoadedCopyWithImpl;
@useResult
$Res call({
 PurchaseOrderModel order, bool isUpdating
});


$PurchaseOrderModelCopyWith<$Res> get order;

}
/// @nodoc
class _$PurchaseOrderDetailLoadedCopyWithImpl<$Res>
    implements $PurchaseOrderDetailLoadedCopyWith<$Res> {
  _$PurchaseOrderDetailLoadedCopyWithImpl(this._self, this._then);

  final PurchaseOrderDetailLoaded _self;
  final $Res Function(PurchaseOrderDetailLoaded) _then;

/// Create a copy of PurchaseOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,Object? isUpdating = null,}) {
  return _then(PurchaseOrderDetailLoaded(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PurchaseOrderModel,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PurchaseOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOrderModelCopyWith<$Res> get order {
  
  return $PurchaseOrderModelCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc


class PurchaseOrderDetailError implements PurchaseOrderDetailState {
  const PurchaseOrderDetailError(this.message);
  

 final  String message;

/// Create a copy of PurchaseOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderDetailErrorCopyWith<PurchaseOrderDetailError> get copyWith => _$PurchaseOrderDetailErrorCopyWithImpl<PurchaseOrderDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'PurchaseOrderDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderDetailErrorCopyWith<$Res> implements $PurchaseOrderDetailStateCopyWith<$Res> {
  factory $PurchaseOrderDetailErrorCopyWith(PurchaseOrderDetailError value, $Res Function(PurchaseOrderDetailError) _then) = _$PurchaseOrderDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PurchaseOrderDetailErrorCopyWithImpl<$Res>
    implements $PurchaseOrderDetailErrorCopyWith<$Res> {
  _$PurchaseOrderDetailErrorCopyWithImpl(this._self, this._then);

  final PurchaseOrderDetailError _self;
  final $Res Function(PurchaseOrderDetailError) _then;

/// Create a copy of PurchaseOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PurchaseOrderDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
