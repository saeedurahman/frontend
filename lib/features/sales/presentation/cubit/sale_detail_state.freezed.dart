// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaleDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SaleDetailState()';
}


}

/// @nodoc
class $SaleDetailStateCopyWith<$Res>  {
$SaleDetailStateCopyWith(SaleDetailState _, $Res Function(SaleDetailState) __);
}


/// Adds pattern-matching-related methods to [SaleDetailState].
extension SaleDetailStatePatterns on SaleDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SaleDetailInitial value)?  initial,TResult Function( SaleDetailLoading value)?  loading,TResult Function( SaleDetailLoaded value)?  loaded,TResult Function( SaleDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SaleDetailInitial() when initial != null:
return initial(_that);case SaleDetailLoading() when loading != null:
return loading(_that);case SaleDetailLoaded() when loaded != null:
return loaded(_that);case SaleDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SaleDetailInitial value)  initial,required TResult Function( SaleDetailLoading value)  loading,required TResult Function( SaleDetailLoaded value)  loaded,required TResult Function( SaleDetailError value)  error,}){
final _that = this;
switch (_that) {
case SaleDetailInitial():
return initial(_that);case SaleDetailLoading():
return loading(_that);case SaleDetailLoaded():
return loaded(_that);case SaleDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SaleDetailInitial value)?  initial,TResult? Function( SaleDetailLoading value)?  loading,TResult? Function( SaleDetailLoaded value)?  loaded,TResult? Function( SaleDetailError value)?  error,}){
final _that = this;
switch (_that) {
case SaleDetailInitial() when initial != null:
return initial(_that);case SaleDetailLoading() when loading != null:
return loading(_that);case SaleDetailLoaded() when loaded != null:
return loaded(_that);case SaleDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( SaleResponseModel sale,  CustomerModel? customer,  bool isCancelling,  bool isVoiding,  String? voidError,  bool? registerShiftOpen,  bool canCancelSales,  bool canCreateReturn)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SaleDetailInitial() when initial != null:
return initial();case SaleDetailLoading() when loading != null:
return loading();case SaleDetailLoaded() when loaded != null:
return loaded(_that.sale,_that.customer,_that.isCancelling,_that.isVoiding,_that.voidError,_that.registerShiftOpen,_that.canCancelSales,_that.canCreateReturn);case SaleDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( SaleResponseModel sale,  CustomerModel? customer,  bool isCancelling,  bool isVoiding,  String? voidError,  bool? registerShiftOpen,  bool canCancelSales,  bool canCreateReturn)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SaleDetailInitial():
return initial();case SaleDetailLoading():
return loading();case SaleDetailLoaded():
return loaded(_that.sale,_that.customer,_that.isCancelling,_that.isVoiding,_that.voidError,_that.registerShiftOpen,_that.canCancelSales,_that.canCreateReturn);case SaleDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( SaleResponseModel sale,  CustomerModel? customer,  bool isCancelling,  bool isVoiding,  String? voidError,  bool? registerShiftOpen,  bool canCancelSales,  bool canCreateReturn)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SaleDetailInitial() when initial != null:
return initial();case SaleDetailLoading() when loading != null:
return loading();case SaleDetailLoaded() when loaded != null:
return loaded(_that.sale,_that.customer,_that.isCancelling,_that.isVoiding,_that.voidError,_that.registerShiftOpen,_that.canCancelSales,_that.canCreateReturn);case SaleDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SaleDetailInitial implements SaleDetailState {
  const SaleDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SaleDetailState.initial()';
}


}




/// @nodoc


class SaleDetailLoading implements SaleDetailState {
  const SaleDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SaleDetailState.loading()';
}


}




/// @nodoc


class SaleDetailLoaded implements SaleDetailState {
  const SaleDetailLoaded({required this.sale, this.customer, this.isCancelling = false, this.isVoiding = false, this.voidError, this.registerShiftOpen, this.canCancelSales = false, this.canCreateReturn = false});
  

 final  SaleResponseModel sale;
 final  CustomerModel? customer;
@JsonKey() final  bool isCancelling;
@JsonKey() final  bool isVoiding;
 final  String? voidError;
 final  bool? registerShiftOpen;
@JsonKey() final  bool canCancelSales;
@JsonKey() final  bool canCreateReturn;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleDetailLoadedCopyWith<SaleDetailLoaded> get copyWith => _$SaleDetailLoadedCopyWithImpl<SaleDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDetailLoaded&&(identical(other.sale, sale) || other.sale == sale)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.isCancelling, isCancelling) || other.isCancelling == isCancelling)&&(identical(other.isVoiding, isVoiding) || other.isVoiding == isVoiding)&&(identical(other.voidError, voidError) || other.voidError == voidError)&&(identical(other.registerShiftOpen, registerShiftOpen) || other.registerShiftOpen == registerShiftOpen)&&(identical(other.canCancelSales, canCancelSales) || other.canCancelSales == canCancelSales)&&(identical(other.canCreateReturn, canCreateReturn) || other.canCreateReturn == canCreateReturn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sale,customer,isCancelling,isVoiding,voidError,registerShiftOpen,canCancelSales,canCreateReturn);
}

@override
String toString() {
    return 'SaleDetailState.loaded(sale: $sale, customer: $customer, isCancelling: $isCancelling, isVoiding: $isVoiding, voidError: $voidError, registerShiftOpen: $registerShiftOpen, canCancelSales: $canCancelSales, canCreateReturn: $canCreateReturn)';
}


}

/// @nodoc
abstract mixin class $SaleDetailLoadedCopyWith<$Res> implements $SaleDetailStateCopyWith<$Res> {
  factory $SaleDetailLoadedCopyWith(SaleDetailLoaded value, $Res Function(SaleDetailLoaded) _then) = _$SaleDetailLoadedCopyWithImpl;
@useResult
$Res call({
 SaleResponseModel sale, CustomerModel? customer, bool isCancelling, bool isVoiding, String? voidError, bool? registerShiftOpen, bool canCancelSales, bool canCreateReturn
});


$SaleResponseModelCopyWith<$Res> get sale;$CustomerModelCopyWith<$Res>? get customer;

}
/// @nodoc
class _$SaleDetailLoadedCopyWithImpl<$Res>
    implements $SaleDetailLoadedCopyWith<$Res> {
  _$SaleDetailLoadedCopyWithImpl(this._self, this._then);

  final SaleDetailLoaded _self;
  final $Res Function(SaleDetailLoaded) _then;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sale = null,Object? customer = freezed,Object? isCancelling = null,Object? isVoiding = null,Object? voidError = freezed,Object? registerShiftOpen = freezed,Object? canCancelSales = null,Object? canCreateReturn = null,}) {
  return _then(SaleDetailLoaded(
sale: null == sale ? _self.sale : sale // ignore: cast_nullable_to_non_nullable
as SaleResponseModel,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerModel?,isCancelling: null == isCancelling ? _self.isCancelling : isCancelling // ignore: cast_nullable_to_non_nullable
as bool,isVoiding: null == isVoiding ? _self.isVoiding : isVoiding // ignore: cast_nullable_to_non_nullable
as bool,voidError: freezed == voidError ? _self.voidError : voidError // ignore: cast_nullable_to_non_nullable
as String?,registerShiftOpen: freezed == registerShiftOpen ? _self.registerShiftOpen : registerShiftOpen // ignore: cast_nullable_to_non_nullable
as bool?,canCancelSales: null == canCancelSales ? _self.canCancelSales : canCancelSales // ignore: cast_nullable_to_non_nullable
as bool,canCreateReturn: null == canCreateReturn ? _self.canCreateReturn : canCreateReturn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaleResponseModelCopyWith<$Res> get sale {
  
  return $SaleResponseModelCopyWith<$Res>(_self.sale, (value) {
    return _then(_self.copyWith(sale: value));
  });
}/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerModelCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

/// @nodoc


class SaleDetailError implements SaleDetailState {
  const SaleDetailError(this.message);
  

 final  String message;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleDetailErrorCopyWith<SaleDetailError> get copyWith => _$SaleDetailErrorCopyWithImpl<SaleDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SaleDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SaleDetailErrorCopyWith<$Res> implements $SaleDetailStateCopyWith<$Res> {
  factory $SaleDetailErrorCopyWith(SaleDetailError value, $Res Function(SaleDetailError) _then) = _$SaleDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SaleDetailErrorCopyWithImpl<$Res>
    implements $SaleDetailErrorCopyWith<$Res> {
  _$SaleDetailErrorCopyWithImpl(this._self, this._then);

  final SaleDetailError _self;
  final $Res Function(SaleDetailError) _then;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SaleDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
