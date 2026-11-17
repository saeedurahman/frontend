// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PosState {

 PosSessionState get session; PosShiftState get shift; PosCatalogState get catalog; PosCartState get cart;
/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosStateCopyWith<PosState> get copyWith => _$PosStateCopyWithImpl<PosState>(this as PosState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PosState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosState&&(identical(other.session, _this.session) || other.session == _this.session)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.catalog, _this.catalog) || other.catalog == _this.catalog)&&(identical(other.cart, _this.cart) || other.cart == _this.cart));
}


@override
int get hashCode {
  final _this = this as PosState;
  return Object.hash(runtimeType,_this.session,_this.shift,_this.catalog,_this.cart);
}

@override
String toString() {
  final _this = this as PosState;
  return 'PosState(session: ${_this.session}, shift: ${_this.shift}, catalog: ${_this.catalog}, cart: ${_this.cart})';
}


}

/// @nodoc
abstract mixin class $PosStateCopyWith<$Res>  {
  factory $PosStateCopyWith(PosState value, $Res Function(PosState) _then) = _$PosStateCopyWithImpl;
@useResult
$Res call({
 PosSessionState session, PosShiftState shift, PosCatalogState catalog, PosCartState cart
});


$PosSessionStateCopyWith<$Res> get session;$PosShiftStateCopyWith<$Res> get shift;$PosCatalogStateCopyWith<$Res> get catalog;$PosCartStateCopyWith<$Res> get cart;

}
/// @nodoc
class _$PosStateCopyWithImpl<$Res>
    implements $PosStateCopyWith<$Res> {
  _$PosStateCopyWithImpl(this._self, this._then);

  final PosState _self;
  final $Res Function(PosState) _then;

/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? shift = null,Object? catalog = null,Object? cart = null,}) {
  return _then(PosState(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PosSessionState,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as PosShiftState,catalog: null == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as PosCatalogState,cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as PosCartState,
  ));
}
/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosSessionStateCopyWith<$Res> get session {
  
  return $PosSessionStateCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosShiftStateCopyWith<$Res> get shift {
  
  return $PosShiftStateCopyWith<$Res>(_self.shift, (value) {
    return _then(_self.copyWith(shift: value));
  });
}/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosCatalogStateCopyWith<$Res> get catalog {
  
  return $PosCatalogStateCopyWith<$Res>(_self.catalog, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosCartStateCopyWith<$Res> get cart {
  
  return $PosCartStateCopyWith<$Res>(_self.cart, (value) {
    return _then(_self.copyWith(cart: value));
  });
}
}


/// Adds pattern-matching-related methods to [PosState].
extension PosStatePatterns on PosState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosState value)  $default,){
final _that = this;
switch (_that) {
case _PosState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosState value)?  $default,){
final _that = this;
switch (_that) {
case _PosState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PosSessionState session,  PosShiftState shift,  PosCatalogState catalog,  PosCartState cart)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosState() when $default != null:
return $default(_that.session,_that.shift,_that.catalog,_that.cart);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PosSessionState session,  PosShiftState shift,  PosCatalogState catalog,  PosCartState cart)  $default,) {final _that = this;
switch (_that) {
case _PosState():
return $default(_that.session,_that.shift,_that.catalog,_that.cart);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PosSessionState session,  PosShiftState shift,  PosCatalogState catalog,  PosCartState cart)?  $default,) {final _that = this;
switch (_that) {
case _PosState() when $default != null:
return $default(_that.session,_that.shift,_that.catalog,_that.cart);case _:
  return null;

}
}

}

/// @nodoc


class _PosState extends PosState {
  const _PosState({this.session = const PosSessionState(), this.shift = const PosShiftState(), this.catalog = const PosCatalogState(), this.cart = const PosCartState()}): super._();
  

@override@JsonKey() final  PosSessionState session;
@override@JsonKey() final  PosShiftState shift;
@override@JsonKey() final  PosCatalogState catalog;
@override@JsonKey() final  PosCartState cart;

/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosStateCopyWith<_PosState> get copyWith => __$PosStateCopyWithImpl<_PosState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosState&&(identical(other.session, session) || other.session == session)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.cart, cart) || other.cart == cart));
}


@override
int get hashCode {
    return Object.hash(runtimeType,session,shift,catalog,cart);
}

@override
String toString() {
    return 'PosState(session: $session, shift: $shift, catalog: $catalog, cart: $cart)';
}


}

/// @nodoc
abstract mixin class _$PosStateCopyWith<$Res> implements $PosStateCopyWith<$Res> {
  factory _$PosStateCopyWith(_PosState value, $Res Function(_PosState) _then) = __$PosStateCopyWithImpl;
@override @useResult
$Res call({
 PosSessionState session, PosShiftState shift, PosCatalogState catalog, PosCartState cart
});


@override $PosSessionStateCopyWith<$Res> get session;@override $PosShiftStateCopyWith<$Res> get shift;@override $PosCatalogStateCopyWith<$Res> get catalog;@override $PosCartStateCopyWith<$Res> get cart;

}
/// @nodoc
class __$PosStateCopyWithImpl<$Res>
    implements _$PosStateCopyWith<$Res> {
  __$PosStateCopyWithImpl(this._self, this._then);

  final _PosState _self;
  final $Res Function(_PosState) _then;

/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? shift = null,Object? catalog = null,Object? cart = null,}) {
  return _then(_PosState(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PosSessionState,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as PosShiftState,catalog: null == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as PosCatalogState,cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as PosCartState,
  ));
}

/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosSessionStateCopyWith<$Res> get session {
  
  return $PosSessionStateCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosShiftStateCopyWith<$Res> get shift {
  
  return $PosShiftStateCopyWith<$Res>(_self.shift, (value) {
    return _then(_self.copyWith(shift: value));
  });
}/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosCatalogStateCopyWith<$Res> get catalog {
  
  return $PosCatalogStateCopyWith<$Res>(_self.catalog, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}/// Create a copy of PosState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosCartStateCopyWith<$Res> get cart {
  
  return $PosCartStateCopyWith<$Res>(_self.cart, (value) {
    return _then(_self.copyWith(cart: value));
  });
}
}

/// @nodoc
mixin _$PosSessionState {

 bool get accessDenied; bool get canOpenShift; bool get canCloseShift; String? get cashierName; String? get branchId; String? get businessName; bool get isOffline; String? get userId; String? get businessId; bool get canEditLineTax; PosDineInContext? get dineIn;
/// Create a copy of PosSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosSessionStateCopyWith<PosSessionState> get copyWith => _$PosSessionStateCopyWithImpl<PosSessionState>(this as PosSessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PosSessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosSessionState&&(identical(other.accessDenied, _this.accessDenied) || other.accessDenied == _this.accessDenied)&&(identical(other.canOpenShift, _this.canOpenShift) || other.canOpenShift == _this.canOpenShift)&&(identical(other.canCloseShift, _this.canCloseShift) || other.canCloseShift == _this.canCloseShift)&&(identical(other.cashierName, _this.cashierName) || other.cashierName == _this.cashierName)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.businessName, _this.businessName) || other.businessName == _this.businessName)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.canEditLineTax, _this.canEditLineTax) || other.canEditLineTax == _this.canEditLineTax)&&(identical(other.dineIn, _this.dineIn) || other.dineIn == _this.dineIn));
}


@override
int get hashCode {
  final _this = this as PosSessionState;
  return Object.hash(runtimeType,_this.accessDenied,_this.canOpenShift,_this.canCloseShift,_this.cashierName,_this.branchId,_this.businessName,_this.isOffline,_this.userId,_this.businessId,_this.canEditLineTax,_this.dineIn);
}

@override
String toString() {
  final _this = this as PosSessionState;
  return 'PosSessionState(accessDenied: ${_this.accessDenied}, canOpenShift: ${_this.canOpenShift}, canCloseShift: ${_this.canCloseShift}, cashierName: ${_this.cashierName}, branchId: ${_this.branchId}, businessName: ${_this.businessName}, isOffline: ${_this.isOffline}, userId: ${_this.userId}, businessId: ${_this.businessId}, canEditLineTax: ${_this.canEditLineTax}, dineIn: ${_this.dineIn})';
}


}

/// @nodoc
abstract mixin class $PosSessionStateCopyWith<$Res>  {
  factory $PosSessionStateCopyWith(PosSessionState value, $Res Function(PosSessionState) _then) = _$PosSessionStateCopyWithImpl;
@useResult
$Res call({
 bool accessDenied, bool canOpenShift, bool canCloseShift, String? cashierName, String? branchId, String? businessName, bool isOffline, String? userId, String? businessId, bool canEditLineTax, PosDineInContext? dineIn
});


$PosDineInContextCopyWith<$Res>? get dineIn;

}
/// @nodoc
class _$PosSessionStateCopyWithImpl<$Res>
    implements $PosSessionStateCopyWith<$Res> {
  _$PosSessionStateCopyWithImpl(this._self, this._then);

  final PosSessionState _self;
  final $Res Function(PosSessionState) _then;

/// Create a copy of PosSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessDenied = null,Object? canOpenShift = null,Object? canCloseShift = null,Object? cashierName = freezed,Object? branchId = freezed,Object? businessName = freezed,Object? isOffline = null,Object? userId = freezed,Object? businessId = freezed,Object? canEditLineTax = null,Object? dineIn = freezed,}) {
  return _then(PosSessionState(
accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,canOpenShift: null == canOpenShift ? _self.canOpenShift : canOpenShift // ignore: cast_nullable_to_non_nullable
as bool,canCloseShift: null == canCloseShift ? _self.canCloseShift : canCloseShift // ignore: cast_nullable_to_non_nullable
as bool,cashierName: freezed == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,businessName: freezed == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String?,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,businessId: freezed == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String?,canEditLineTax: null == canEditLineTax ? _self.canEditLineTax : canEditLineTax // ignore: cast_nullable_to_non_nullable
as bool,dineIn: freezed == dineIn ? _self.dineIn : dineIn // ignore: cast_nullable_to_non_nullable
as PosDineInContext?,
  ));
}
/// Create a copy of PosSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosDineInContextCopyWith<$Res>? get dineIn {
    if (_self.dineIn == null) {
    return null;
  }

  return $PosDineInContextCopyWith<$Res>(_self.dineIn!, (value) {
    return _then(_self.copyWith(dineIn: value));
  });
}
}


/// Adds pattern-matching-related methods to [PosSessionState].
extension PosSessionStatePatterns on PosSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosSessionState value)  $default,){
final _that = this;
switch (_that) {
case _PosSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _PosSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool accessDenied,  bool canOpenShift,  bool canCloseShift,  String? cashierName,  String? branchId,  String? businessName,  bool isOffline,  String? userId,  String? businessId,  bool canEditLineTax,  PosDineInContext? dineIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosSessionState() when $default != null:
return $default(_that.accessDenied,_that.canOpenShift,_that.canCloseShift,_that.cashierName,_that.branchId,_that.businessName,_that.isOffline,_that.userId,_that.businessId,_that.canEditLineTax,_that.dineIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool accessDenied,  bool canOpenShift,  bool canCloseShift,  String? cashierName,  String? branchId,  String? businessName,  bool isOffline,  String? userId,  String? businessId,  bool canEditLineTax,  PosDineInContext? dineIn)  $default,) {final _that = this;
switch (_that) {
case _PosSessionState():
return $default(_that.accessDenied,_that.canOpenShift,_that.canCloseShift,_that.cashierName,_that.branchId,_that.businessName,_that.isOffline,_that.userId,_that.businessId,_that.canEditLineTax,_that.dineIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool accessDenied,  bool canOpenShift,  bool canCloseShift,  String? cashierName,  String? branchId,  String? businessName,  bool isOffline,  String? userId,  String? businessId,  bool canEditLineTax,  PosDineInContext? dineIn)?  $default,) {final _that = this;
switch (_that) {
case _PosSessionState() when $default != null:
return $default(_that.accessDenied,_that.canOpenShift,_that.canCloseShift,_that.cashierName,_that.branchId,_that.businessName,_that.isOffline,_that.userId,_that.businessId,_that.canEditLineTax,_that.dineIn);case _:
  return null;

}
}

}

/// @nodoc


class _PosSessionState implements PosSessionState {
  const _PosSessionState({this.accessDenied = false, this.canOpenShift = false, this.canCloseShift = false, this.cashierName, this.branchId, this.businessName, this.isOffline = false, this.userId, this.businessId, this.canEditLineTax = false, this.dineIn});
  

@override@JsonKey() final  bool accessDenied;
@override@JsonKey() final  bool canOpenShift;
@override@JsonKey() final  bool canCloseShift;
@override final  String? cashierName;
@override final  String? branchId;
@override final  String? businessName;
@override@JsonKey() final  bool isOffline;
@override final  String? userId;
@override final  String? businessId;
@override@JsonKey() final  bool canEditLineTax;
@override final  PosDineInContext? dineIn;

/// Create a copy of PosSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosSessionStateCopyWith<_PosSessionState> get copyWith => __$PosSessionStateCopyWithImpl<_PosSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosSessionState&&(identical(other.accessDenied, accessDenied) || other.accessDenied == accessDenied)&&(identical(other.canOpenShift, canOpenShift) || other.canOpenShift == canOpenShift)&&(identical(other.canCloseShift, canCloseShift) || other.canCloseShift == canCloseShift)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.canEditLineTax, canEditLineTax) || other.canEditLineTax == canEditLineTax)&&(identical(other.dineIn, dineIn) || other.dineIn == dineIn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accessDenied,canOpenShift,canCloseShift,cashierName,branchId,businessName,isOffline,userId,businessId,canEditLineTax,dineIn);
}

@override
String toString() {
    return 'PosSessionState(accessDenied: $accessDenied, canOpenShift: $canOpenShift, canCloseShift: $canCloseShift, cashierName: $cashierName, branchId: $branchId, businessName: $businessName, isOffline: $isOffline, userId: $userId, businessId: $businessId, canEditLineTax: $canEditLineTax, dineIn: $dineIn)';
}


}

/// @nodoc
abstract mixin class _$PosSessionStateCopyWith<$Res> implements $PosSessionStateCopyWith<$Res> {
  factory _$PosSessionStateCopyWith(_PosSessionState value, $Res Function(_PosSessionState) _then) = __$PosSessionStateCopyWithImpl;
@override @useResult
$Res call({
 bool accessDenied, bool canOpenShift, bool canCloseShift, String? cashierName, String? branchId, String? businessName, bool isOffline, String? userId, String? businessId, bool canEditLineTax, PosDineInContext? dineIn
});


@override $PosDineInContextCopyWith<$Res>? get dineIn;

}
/// @nodoc
class __$PosSessionStateCopyWithImpl<$Res>
    implements _$PosSessionStateCopyWith<$Res> {
  __$PosSessionStateCopyWithImpl(this._self, this._then);

  final _PosSessionState _self;
  final $Res Function(_PosSessionState) _then;

/// Create a copy of PosSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessDenied = null,Object? canOpenShift = null,Object? canCloseShift = null,Object? cashierName = freezed,Object? branchId = freezed,Object? businessName = freezed,Object? isOffline = null,Object? userId = freezed,Object? businessId = freezed,Object? canEditLineTax = null,Object? dineIn = freezed,}) {
  return _then(_PosSessionState(
accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,canOpenShift: null == canOpenShift ? _self.canOpenShift : canOpenShift // ignore: cast_nullable_to_non_nullable
as bool,canCloseShift: null == canCloseShift ? _self.canCloseShift : canCloseShift // ignore: cast_nullable_to_non_nullable
as bool,cashierName: freezed == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,businessName: freezed == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String?,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,businessId: freezed == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String?,canEditLineTax: null == canEditLineTax ? _self.canEditLineTax : canEditLineTax // ignore: cast_nullable_to_non_nullable
as bool,dineIn: freezed == dineIn ? _self.dineIn : dineIn // ignore: cast_nullable_to_non_nullable
as PosDineInContext?,
  ));
}

/// Create a copy of PosSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosDineInContextCopyWith<$Res>? get dineIn {
    if (_self.dineIn == null) {
    return null;
  }

  return $PosDineInContextCopyWith<$Res>(_self.dineIn!, (value) {
    return _then(_self.copyWith(dineIn: value));
  });
}
}

/// @nodoc
mixin _$PosDineInContext {

 String get saleId; String get tableId; String get tableLabel; DineInTabStatus get tabStatus; bool get isSyncingLine; String? get syncError;
/// Create a copy of PosDineInContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosDineInContextCopyWith<PosDineInContext> get copyWith => _$PosDineInContextCopyWithImpl<PosDineInContext>(this as PosDineInContext, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PosDineInContext;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosDineInContext&&(identical(other.saleId, _this.saleId) || other.saleId == _this.saleId)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.tableLabel, _this.tableLabel) || other.tableLabel == _this.tableLabel)&&(identical(other.tabStatus, _this.tabStatus) || other.tabStatus == _this.tabStatus)&&(identical(other.isSyncingLine, _this.isSyncingLine) || other.isSyncingLine == _this.isSyncingLine)&&(identical(other.syncError, _this.syncError) || other.syncError == _this.syncError));
}


@override
int get hashCode {
  final _this = this as PosDineInContext;
  return Object.hash(runtimeType,_this.saleId,_this.tableId,_this.tableLabel,_this.tabStatus,_this.isSyncingLine,_this.syncError);
}

@override
String toString() {
  final _this = this as PosDineInContext;
  return 'PosDineInContext(saleId: ${_this.saleId}, tableId: ${_this.tableId}, tableLabel: ${_this.tableLabel}, tabStatus: ${_this.tabStatus}, isSyncingLine: ${_this.isSyncingLine}, syncError: ${_this.syncError})';
}


}

/// @nodoc
abstract mixin class $PosDineInContextCopyWith<$Res>  {
  factory $PosDineInContextCopyWith(PosDineInContext value, $Res Function(PosDineInContext) _then) = _$PosDineInContextCopyWithImpl;
@useResult
$Res call({
 String saleId, String tableId, String tableLabel, DineInTabStatus tabStatus, bool isSyncingLine, String? syncError
});




}
/// @nodoc
class _$PosDineInContextCopyWithImpl<$Res>
    implements $PosDineInContextCopyWith<$Res> {
  _$PosDineInContextCopyWithImpl(this._self, this._then);

  final PosDineInContext _self;
  final $Res Function(PosDineInContext) _then;

/// Create a copy of PosDineInContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? saleId = null,Object? tableId = null,Object? tableLabel = null,Object? tabStatus = null,Object? isSyncingLine = null,Object? syncError = freezed,}) {
  return _then(PosDineInContext(
saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,tableLabel: null == tableLabel ? _self.tableLabel : tableLabel // ignore: cast_nullable_to_non_nullable
as String,tabStatus: null == tabStatus ? _self.tabStatus : tabStatus // ignore: cast_nullable_to_non_nullable
as DineInTabStatus,isSyncingLine: null == isSyncingLine ? _self.isSyncingLine : isSyncingLine // ignore: cast_nullable_to_non_nullable
as bool,syncError: freezed == syncError ? _self.syncError : syncError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PosDineInContext].
extension PosDineInContextPatterns on PosDineInContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosDineInContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosDineInContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosDineInContext value)  $default,){
final _that = this;
switch (_that) {
case _PosDineInContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosDineInContext value)?  $default,){
final _that = this;
switch (_that) {
case _PosDineInContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String saleId,  String tableId,  String tableLabel,  DineInTabStatus tabStatus,  bool isSyncingLine,  String? syncError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosDineInContext() when $default != null:
return $default(_that.saleId,_that.tableId,_that.tableLabel,_that.tabStatus,_that.isSyncingLine,_that.syncError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String saleId,  String tableId,  String tableLabel,  DineInTabStatus tabStatus,  bool isSyncingLine,  String? syncError)  $default,) {final _that = this;
switch (_that) {
case _PosDineInContext():
return $default(_that.saleId,_that.tableId,_that.tableLabel,_that.tabStatus,_that.isSyncingLine,_that.syncError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String saleId,  String tableId,  String tableLabel,  DineInTabStatus tabStatus,  bool isSyncingLine,  String? syncError)?  $default,) {final _that = this;
switch (_that) {
case _PosDineInContext() when $default != null:
return $default(_that.saleId,_that.tableId,_that.tableLabel,_that.tabStatus,_that.isSyncingLine,_that.syncError);case _:
  return null;

}
}

}

/// @nodoc


class _PosDineInContext extends PosDineInContext {
  const _PosDineInContext({required this.saleId, required this.tableId, required this.tableLabel, this.tabStatus = DineInTabStatus.open, this.isSyncingLine = false, this.syncError}): super._();
  

@override final  String saleId;
@override final  String tableId;
@override final  String tableLabel;
@override@JsonKey() final  DineInTabStatus tabStatus;
@override@JsonKey() final  bool isSyncingLine;
@override final  String? syncError;

/// Create a copy of PosDineInContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosDineInContextCopyWith<_PosDineInContext> get copyWith => __$PosDineInContextCopyWithImpl<_PosDineInContext>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosDineInContext&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableLabel, tableLabel) || other.tableLabel == tableLabel)&&(identical(other.tabStatus, tabStatus) || other.tabStatus == tabStatus)&&(identical(other.isSyncingLine, isSyncingLine) || other.isSyncingLine == isSyncingLine)&&(identical(other.syncError, syncError) || other.syncError == syncError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,saleId,tableId,tableLabel,tabStatus,isSyncingLine,syncError);
}

@override
String toString() {
    return 'PosDineInContext(saleId: $saleId, tableId: $tableId, tableLabel: $tableLabel, tabStatus: $tabStatus, isSyncingLine: $isSyncingLine, syncError: $syncError)';
}


}

/// @nodoc
abstract mixin class _$PosDineInContextCopyWith<$Res> implements $PosDineInContextCopyWith<$Res> {
  factory _$PosDineInContextCopyWith(_PosDineInContext value, $Res Function(_PosDineInContext) _then) = __$PosDineInContextCopyWithImpl;
@override @useResult
$Res call({
 String saleId, String tableId, String tableLabel, DineInTabStatus tabStatus, bool isSyncingLine, String? syncError
});




}
/// @nodoc
class __$PosDineInContextCopyWithImpl<$Res>
    implements _$PosDineInContextCopyWith<$Res> {
  __$PosDineInContextCopyWithImpl(this._self, this._then);

  final _PosDineInContext _self;
  final $Res Function(_PosDineInContext) _then;

/// Create a copy of PosDineInContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? saleId = null,Object? tableId = null,Object? tableLabel = null,Object? tabStatus = null,Object? isSyncingLine = null,Object? syncError = freezed,}) {
  return _then(_PosDineInContext(
saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,tableLabel: null == tableLabel ? _self.tableLabel : tableLabel // ignore: cast_nullable_to_non_nullable
as String,tabStatus: null == tabStatus ? _self.tabStatus : tabStatus // ignore: cast_nullable_to_non_nullable
as DineInTabStatus,isSyncingLine: null == isSyncingLine ? _self.isSyncingLine : isSyncingLine // ignore: cast_nullable_to_non_nullable
as bool,syncError: freezed == syncError ? _self.syncError : syncError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PosShiftState {

 RegisterShiftModel? get activeShift; ShiftSummaryModel? get shiftSummary; List<CashRegisterModel> get registers; String? get selectedRegisterId; bool get isCheckingShift; bool get isOpeningShift; bool get isCreatingRegister; String? get registersError;/// Real failure message from the last `openShift` attempt.
 String? get openShiftError;/// Set when the shift summary could not be loaded (retry offered).
 String? get shiftSummaryError;
/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosShiftStateCopyWith<PosShiftState> get copyWith => _$PosShiftStateCopyWithImpl<PosShiftState>(this as PosShiftState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PosShiftState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosShiftState&&(identical(other.activeShift, _this.activeShift) || other.activeShift == _this.activeShift)&&(identical(other.shiftSummary, _this.shiftSummary) || other.shiftSummary == _this.shiftSummary)&&const DeepCollectionEquality().equals(other.registers, _this.registers)&&(identical(other.selectedRegisterId, _this.selectedRegisterId) || other.selectedRegisterId == _this.selectedRegisterId)&&(identical(other.isCheckingShift, _this.isCheckingShift) || other.isCheckingShift == _this.isCheckingShift)&&(identical(other.isOpeningShift, _this.isOpeningShift) || other.isOpeningShift == _this.isOpeningShift)&&(identical(other.isCreatingRegister, _this.isCreatingRegister) || other.isCreatingRegister == _this.isCreatingRegister)&&(identical(other.registersError, _this.registersError) || other.registersError == _this.registersError)&&(identical(other.openShiftError, _this.openShiftError) || other.openShiftError == _this.openShiftError)&&(identical(other.shiftSummaryError, _this.shiftSummaryError) || other.shiftSummaryError == _this.shiftSummaryError));
}


@override
int get hashCode {
  final _this = this as PosShiftState;
  return Object.hash(runtimeType,_this.activeShift,_this.shiftSummary,const DeepCollectionEquality().hash(_this.registers),_this.selectedRegisterId,_this.isCheckingShift,_this.isOpeningShift,_this.isCreatingRegister,_this.registersError,_this.openShiftError,_this.shiftSummaryError);
}

@override
String toString() {
  final _this = this as PosShiftState;
  return 'PosShiftState(activeShift: ${_this.activeShift}, shiftSummary: ${_this.shiftSummary}, registers: ${_this.registers}, selectedRegisterId: ${_this.selectedRegisterId}, isCheckingShift: ${_this.isCheckingShift}, isOpeningShift: ${_this.isOpeningShift}, isCreatingRegister: ${_this.isCreatingRegister}, registersError: ${_this.registersError}, openShiftError: ${_this.openShiftError}, shiftSummaryError: ${_this.shiftSummaryError})';
}


}

/// @nodoc
abstract mixin class $PosShiftStateCopyWith<$Res>  {
  factory $PosShiftStateCopyWith(PosShiftState value, $Res Function(PosShiftState) _then) = _$PosShiftStateCopyWithImpl;
@useResult
$Res call({
 RegisterShiftModel? activeShift, ShiftSummaryModel? shiftSummary, List<CashRegisterModel> registers, String? selectedRegisterId, bool isCheckingShift, bool isOpeningShift, bool isCreatingRegister, String? registersError, String? openShiftError, String? shiftSummaryError
});


$RegisterShiftModelCopyWith<$Res>? get activeShift;$ShiftSummaryModelCopyWith<$Res>? get shiftSummary;

}
/// @nodoc
class _$PosShiftStateCopyWithImpl<$Res>
    implements $PosShiftStateCopyWith<$Res> {
  _$PosShiftStateCopyWithImpl(this._self, this._then);

  final PosShiftState _self;
  final $Res Function(PosShiftState) _then;

/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeShift = freezed,Object? shiftSummary = freezed,Object? registers = null,Object? selectedRegisterId = freezed,Object? isCheckingShift = null,Object? isOpeningShift = null,Object? isCreatingRegister = null,Object? registersError = freezed,Object? openShiftError = freezed,Object? shiftSummaryError = freezed,}) {
  return _then(PosShiftState(
activeShift: freezed == activeShift ? _self.activeShift : activeShift // ignore: cast_nullable_to_non_nullable
as RegisterShiftModel?,shiftSummary: freezed == shiftSummary ? _self.shiftSummary : shiftSummary // ignore: cast_nullable_to_non_nullable
as ShiftSummaryModel?,registers: null == registers ? _self.registers : registers // ignore: cast_nullable_to_non_nullable
as List<CashRegisterModel>,selectedRegisterId: freezed == selectedRegisterId ? _self.selectedRegisterId : selectedRegisterId // ignore: cast_nullable_to_non_nullable
as String?,isCheckingShift: null == isCheckingShift ? _self.isCheckingShift : isCheckingShift // ignore: cast_nullable_to_non_nullable
as bool,isOpeningShift: null == isOpeningShift ? _self.isOpeningShift : isOpeningShift // ignore: cast_nullable_to_non_nullable
as bool,isCreatingRegister: null == isCreatingRegister ? _self.isCreatingRegister : isCreatingRegister // ignore: cast_nullable_to_non_nullable
as bool,registersError: freezed == registersError ? _self.registersError : registersError // ignore: cast_nullable_to_non_nullable
as String?,openShiftError: freezed == openShiftError ? _self.openShiftError : openShiftError // ignore: cast_nullable_to_non_nullable
as String?,shiftSummaryError: freezed == shiftSummaryError ? _self.shiftSummaryError : shiftSummaryError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<$Res>? get activeShift {
    if (_self.activeShift == null) {
    return null;
  }

  return $RegisterShiftModelCopyWith<$Res>(_self.activeShift!, (value) {
    return _then(_self.copyWith(activeShift: value));
  });
}/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShiftSummaryModelCopyWith<$Res>? get shiftSummary {
    if (_self.shiftSummary == null) {
    return null;
  }

  return $ShiftSummaryModelCopyWith<$Res>(_self.shiftSummary!, (value) {
    return _then(_self.copyWith(shiftSummary: value));
  });
}
}


/// Adds pattern-matching-related methods to [PosShiftState].
extension PosShiftStatePatterns on PosShiftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosShiftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosShiftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosShiftState value)  $default,){
final _that = this;
switch (_that) {
case _PosShiftState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosShiftState value)?  $default,){
final _that = this;
switch (_that) {
case _PosShiftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RegisterShiftModel? activeShift,  ShiftSummaryModel? shiftSummary,  List<CashRegisterModel> registers,  String? selectedRegisterId,  bool isCheckingShift,  bool isOpeningShift,  bool isCreatingRegister,  String? registersError,  String? openShiftError,  String? shiftSummaryError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosShiftState() when $default != null:
return $default(_that.activeShift,_that.shiftSummary,_that.registers,_that.selectedRegisterId,_that.isCheckingShift,_that.isOpeningShift,_that.isCreatingRegister,_that.registersError,_that.openShiftError,_that.shiftSummaryError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RegisterShiftModel? activeShift,  ShiftSummaryModel? shiftSummary,  List<CashRegisterModel> registers,  String? selectedRegisterId,  bool isCheckingShift,  bool isOpeningShift,  bool isCreatingRegister,  String? registersError,  String? openShiftError,  String? shiftSummaryError)  $default,) {final _that = this;
switch (_that) {
case _PosShiftState():
return $default(_that.activeShift,_that.shiftSummary,_that.registers,_that.selectedRegisterId,_that.isCheckingShift,_that.isOpeningShift,_that.isCreatingRegister,_that.registersError,_that.openShiftError,_that.shiftSummaryError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RegisterShiftModel? activeShift,  ShiftSummaryModel? shiftSummary,  List<CashRegisterModel> registers,  String? selectedRegisterId,  bool isCheckingShift,  bool isOpeningShift,  bool isCreatingRegister,  String? registersError,  String? openShiftError,  String? shiftSummaryError)?  $default,) {final _that = this;
switch (_that) {
case _PosShiftState() when $default != null:
return $default(_that.activeShift,_that.shiftSummary,_that.registers,_that.selectedRegisterId,_that.isCheckingShift,_that.isOpeningShift,_that.isCreatingRegister,_that.registersError,_that.openShiftError,_that.shiftSummaryError);case _:
  return null;

}
}

}

/// @nodoc


class _PosShiftState implements PosShiftState {
  const _PosShiftState({this.activeShift, this.shiftSummary,  List<CashRegisterModel> registers = const [], this.selectedRegisterId, this.isCheckingShift = true, this.isOpeningShift = false, this.isCreatingRegister = false, this.registersError, this.openShiftError, this.shiftSummaryError}): _registers = registers;
  

@override final  RegisterShiftModel? activeShift;
@override final  ShiftSummaryModel? shiftSummary;
 final  List<CashRegisterModel> _registers;
@override@JsonKey() List<CashRegisterModel> get registers {
  if (_registers is EqualUnmodifiableListView) return _registers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registers);
}

@override final  String? selectedRegisterId;
@override@JsonKey() final  bool isCheckingShift;
@override@JsonKey() final  bool isOpeningShift;
@override@JsonKey() final  bool isCreatingRegister;
@override final  String? registersError;
/// Real failure message from the last `openShift` attempt.
@override final  String? openShiftError;
/// Set when the shift summary could not be loaded (retry offered).
@override final  String? shiftSummaryError;

/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosShiftStateCopyWith<_PosShiftState> get copyWith => __$PosShiftStateCopyWithImpl<_PosShiftState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosShiftState&&(identical(other.activeShift, activeShift) || other.activeShift == activeShift)&&(identical(other.shiftSummary, shiftSummary) || other.shiftSummary == shiftSummary)&&const DeepCollectionEquality().equals(other.registers, _registers)&&(identical(other.selectedRegisterId, selectedRegisterId) || other.selectedRegisterId == selectedRegisterId)&&(identical(other.isCheckingShift, isCheckingShift) || other.isCheckingShift == isCheckingShift)&&(identical(other.isOpeningShift, isOpeningShift) || other.isOpeningShift == isOpeningShift)&&(identical(other.isCreatingRegister, isCreatingRegister) || other.isCreatingRegister == isCreatingRegister)&&(identical(other.registersError, registersError) || other.registersError == registersError)&&(identical(other.openShiftError, openShiftError) || other.openShiftError == openShiftError)&&(identical(other.shiftSummaryError, shiftSummaryError) || other.shiftSummaryError == shiftSummaryError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,activeShift,shiftSummary,const DeepCollectionEquality().hash(_registers),selectedRegisterId,isCheckingShift,isOpeningShift,isCreatingRegister,registersError,openShiftError,shiftSummaryError);
}

@override
String toString() {
    return 'PosShiftState(activeShift: $activeShift, shiftSummary: $shiftSummary, registers: $registers, selectedRegisterId: $selectedRegisterId, isCheckingShift: $isCheckingShift, isOpeningShift: $isOpeningShift, isCreatingRegister: $isCreatingRegister, registersError: $registersError, openShiftError: $openShiftError, shiftSummaryError: $shiftSummaryError)';
}


}

/// @nodoc
abstract mixin class _$PosShiftStateCopyWith<$Res> implements $PosShiftStateCopyWith<$Res> {
  factory _$PosShiftStateCopyWith(_PosShiftState value, $Res Function(_PosShiftState) _then) = __$PosShiftStateCopyWithImpl;
@override @useResult
$Res call({
 RegisterShiftModel? activeShift, ShiftSummaryModel? shiftSummary, List<CashRegisterModel> registers, String? selectedRegisterId, bool isCheckingShift, bool isOpeningShift, bool isCreatingRegister, String? registersError, String? openShiftError, String? shiftSummaryError
});


@override $RegisterShiftModelCopyWith<$Res>? get activeShift;@override $ShiftSummaryModelCopyWith<$Res>? get shiftSummary;

}
/// @nodoc
class __$PosShiftStateCopyWithImpl<$Res>
    implements _$PosShiftStateCopyWith<$Res> {
  __$PosShiftStateCopyWithImpl(this._self, this._then);

  final _PosShiftState _self;
  final $Res Function(_PosShiftState) _then;

/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeShift = freezed,Object? shiftSummary = freezed,Object? registers = null,Object? selectedRegisterId = freezed,Object? isCheckingShift = null,Object? isOpeningShift = null,Object? isCreatingRegister = null,Object? registersError = freezed,Object? openShiftError = freezed,Object? shiftSummaryError = freezed,}) {
  return _then(_PosShiftState(
activeShift: freezed == activeShift ? _self.activeShift : activeShift // ignore: cast_nullable_to_non_nullable
as RegisterShiftModel?,shiftSummary: freezed == shiftSummary ? _self.shiftSummary : shiftSummary // ignore: cast_nullable_to_non_nullable
as ShiftSummaryModel?,registers: null == registers ? _self._registers : registers // ignore: cast_nullable_to_non_nullable
as List<CashRegisterModel>,selectedRegisterId: freezed == selectedRegisterId ? _self.selectedRegisterId : selectedRegisterId // ignore: cast_nullable_to_non_nullable
as String?,isCheckingShift: null == isCheckingShift ? _self.isCheckingShift : isCheckingShift // ignore: cast_nullable_to_non_nullable
as bool,isOpeningShift: null == isOpeningShift ? _self.isOpeningShift : isOpeningShift // ignore: cast_nullable_to_non_nullable
as bool,isCreatingRegister: null == isCreatingRegister ? _self.isCreatingRegister : isCreatingRegister // ignore: cast_nullable_to_non_nullable
as bool,registersError: freezed == registersError ? _self.registersError : registersError // ignore: cast_nullable_to_non_nullable
as String?,openShiftError: freezed == openShiftError ? _self.openShiftError : openShiftError // ignore: cast_nullable_to_non_nullable
as String?,shiftSummaryError: freezed == shiftSummaryError ? _self.shiftSummaryError : shiftSummaryError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<$Res>? get activeShift {
    if (_self.activeShift == null) {
    return null;
  }

  return $RegisterShiftModelCopyWith<$Res>(_self.activeShift!, (value) {
    return _then(_self.copyWith(activeShift: value));
  });
}/// Create a copy of PosShiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShiftSummaryModelCopyWith<$Res>? get shiftSummary {
    if (_self.shiftSummary == null) {
    return null;
  }

  return $ShiftSummaryModelCopyWith<$Res>(_self.shiftSummary!, (value) {
    return _then(_self.copyWith(shiftSummary: value));
  });
}
}

/// @nodoc
mixin _$PosCatalogState {

 List<ProductListItemModel> get products; List<CategoryModel> get categories; String? get selectedCategoryId; String get productSearchQuery; bool get isLoadingProducts; String? get productsError; bool get hasMoreProducts; bool get isLoadingMoreProducts; int get productsTotal; String? get stockError; String? get categoriesError; String? get taxError; Map<String, String> get priceCache; PosPriceContext get priceContext; Map<String, String> get stockCache; Map<String, ProductModel> get productDetailsCache;
/// Create a copy of PosCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosCatalogStateCopyWith<PosCatalogState> get copyWith => _$PosCatalogStateCopyWithImpl<PosCatalogState>(this as PosCatalogState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PosCatalogState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosCatalogState&&const DeepCollectionEquality().equals(other.products, _this.products)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.selectedCategoryId, _this.selectedCategoryId) || other.selectedCategoryId == _this.selectedCategoryId)&&(identical(other.productSearchQuery, _this.productSearchQuery) || other.productSearchQuery == _this.productSearchQuery)&&(identical(other.isLoadingProducts, _this.isLoadingProducts) || other.isLoadingProducts == _this.isLoadingProducts)&&(identical(other.productsError, _this.productsError) || other.productsError == _this.productsError)&&(identical(other.hasMoreProducts, _this.hasMoreProducts) || other.hasMoreProducts == _this.hasMoreProducts)&&(identical(other.isLoadingMoreProducts, _this.isLoadingMoreProducts) || other.isLoadingMoreProducts == _this.isLoadingMoreProducts)&&(identical(other.productsTotal, _this.productsTotal) || other.productsTotal == _this.productsTotal)&&(identical(other.stockError, _this.stockError) || other.stockError == _this.stockError)&&(identical(other.categoriesError, _this.categoriesError) || other.categoriesError == _this.categoriesError)&&(identical(other.taxError, _this.taxError) || other.taxError == _this.taxError)&&const DeepCollectionEquality().equals(other.priceCache, _this.priceCache)&&(identical(other.priceContext, _this.priceContext) || other.priceContext == _this.priceContext)&&const DeepCollectionEquality().equals(other.stockCache, _this.stockCache)&&const DeepCollectionEquality().equals(other.productDetailsCache, _this.productDetailsCache));
}


@override
int get hashCode {
  final _this = this as PosCatalogState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.products),const DeepCollectionEquality().hash(_this.categories),_this.selectedCategoryId,_this.productSearchQuery,_this.isLoadingProducts,_this.productsError,_this.hasMoreProducts,_this.isLoadingMoreProducts,_this.productsTotal,_this.stockError,_this.categoriesError,_this.taxError,const DeepCollectionEquality().hash(_this.priceCache),_this.priceContext,const DeepCollectionEquality().hash(_this.stockCache),const DeepCollectionEquality().hash(_this.productDetailsCache));
}

@override
String toString() {
  final _this = this as PosCatalogState;
  return 'PosCatalogState(products: ${_this.products}, categories: ${_this.categories}, selectedCategoryId: ${_this.selectedCategoryId}, productSearchQuery: ${_this.productSearchQuery}, isLoadingProducts: ${_this.isLoadingProducts}, productsError: ${_this.productsError}, hasMoreProducts: ${_this.hasMoreProducts}, isLoadingMoreProducts: ${_this.isLoadingMoreProducts}, productsTotal: ${_this.productsTotal}, stockError: ${_this.stockError}, categoriesError: ${_this.categoriesError}, taxError: ${_this.taxError}, priceCache: ${_this.priceCache}, priceContext: ${_this.priceContext}, stockCache: ${_this.stockCache}, productDetailsCache: ${_this.productDetailsCache})';
}


}

/// @nodoc
abstract mixin class $PosCatalogStateCopyWith<$Res>  {
  factory $PosCatalogStateCopyWith(PosCatalogState value, $Res Function(PosCatalogState) _then) = _$PosCatalogStateCopyWithImpl;
@useResult
$Res call({
 List<ProductListItemModel> products, List<CategoryModel> categories, String? selectedCategoryId, String productSearchQuery, bool isLoadingProducts, String? productsError, bool hasMoreProducts, bool isLoadingMoreProducts, int productsTotal, String? stockError, String? categoriesError, String? taxError, Map<String, String> priceCache, PosPriceContext priceContext, Map<String, String> stockCache, Map<String, ProductModel> productDetailsCache
});




}
/// @nodoc
class _$PosCatalogStateCopyWithImpl<$Res>
    implements $PosCatalogStateCopyWith<$Res> {
  _$PosCatalogStateCopyWithImpl(this._self, this._then);

  final PosCatalogState _self;
  final $Res Function(PosCatalogState) _then;

/// Create a copy of PosCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,Object? categories = null,Object? selectedCategoryId = freezed,Object? productSearchQuery = null,Object? isLoadingProducts = null,Object? productsError = freezed,Object? hasMoreProducts = null,Object? isLoadingMoreProducts = null,Object? productsTotal = null,Object? stockError = freezed,Object? categoriesError = freezed,Object? taxError = freezed,Object? priceCache = null,Object? priceContext = null,Object? stockCache = null,Object? productDetailsCache = null,}) {
  return _then(PosCatalogState(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,productSearchQuery: null == productSearchQuery ? _self.productSearchQuery : productSearchQuery // ignore: cast_nullable_to_non_nullable
as String,isLoadingProducts: null == isLoadingProducts ? _self.isLoadingProducts : isLoadingProducts // ignore: cast_nullable_to_non_nullable
as bool,productsError: freezed == productsError ? _self.productsError : productsError // ignore: cast_nullable_to_non_nullable
as String?,hasMoreProducts: null == hasMoreProducts ? _self.hasMoreProducts : hasMoreProducts // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMoreProducts: null == isLoadingMoreProducts ? _self.isLoadingMoreProducts : isLoadingMoreProducts // ignore: cast_nullable_to_non_nullable
as bool,productsTotal: null == productsTotal ? _self.productsTotal : productsTotal // ignore: cast_nullable_to_non_nullable
as int,stockError: freezed == stockError ? _self.stockError : stockError // ignore: cast_nullable_to_non_nullable
as String?,categoriesError: freezed == categoriesError ? _self.categoriesError : categoriesError // ignore: cast_nullable_to_non_nullable
as String?,taxError: freezed == taxError ? _self.taxError : taxError // ignore: cast_nullable_to_non_nullable
as String?,priceCache: null == priceCache ? _self.priceCache : priceCache // ignore: cast_nullable_to_non_nullable
as Map<String, String>,priceContext: null == priceContext ? _self.priceContext : priceContext // ignore: cast_nullable_to_non_nullable
as PosPriceContext,stockCache: null == stockCache ? _self.stockCache : stockCache // ignore: cast_nullable_to_non_nullable
as Map<String, String>,productDetailsCache: null == productDetailsCache ? _self.productDetailsCache : productDetailsCache // ignore: cast_nullable_to_non_nullable
as Map<String, ProductModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PosCatalogState].
extension PosCatalogStatePatterns on PosCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _PosCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _PosCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductListItemModel> products,  List<CategoryModel> categories,  String? selectedCategoryId,  String productSearchQuery,  bool isLoadingProducts,  String? productsError,  bool hasMoreProducts,  bool isLoadingMoreProducts,  int productsTotal,  String? stockError,  String? categoriesError,  String? taxError,  Map<String, String> priceCache,  PosPriceContext priceContext,  Map<String, String> stockCache,  Map<String, ProductModel> productDetailsCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosCatalogState() when $default != null:
return $default(_that.products,_that.categories,_that.selectedCategoryId,_that.productSearchQuery,_that.isLoadingProducts,_that.productsError,_that.hasMoreProducts,_that.isLoadingMoreProducts,_that.productsTotal,_that.stockError,_that.categoriesError,_that.taxError,_that.priceCache,_that.priceContext,_that.stockCache,_that.productDetailsCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductListItemModel> products,  List<CategoryModel> categories,  String? selectedCategoryId,  String productSearchQuery,  bool isLoadingProducts,  String? productsError,  bool hasMoreProducts,  bool isLoadingMoreProducts,  int productsTotal,  String? stockError,  String? categoriesError,  String? taxError,  Map<String, String> priceCache,  PosPriceContext priceContext,  Map<String, String> stockCache,  Map<String, ProductModel> productDetailsCache)  $default,) {final _that = this;
switch (_that) {
case _PosCatalogState():
return $default(_that.products,_that.categories,_that.selectedCategoryId,_that.productSearchQuery,_that.isLoadingProducts,_that.productsError,_that.hasMoreProducts,_that.isLoadingMoreProducts,_that.productsTotal,_that.stockError,_that.categoriesError,_that.taxError,_that.priceCache,_that.priceContext,_that.stockCache,_that.productDetailsCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductListItemModel> products,  List<CategoryModel> categories,  String? selectedCategoryId,  String productSearchQuery,  bool isLoadingProducts,  String? productsError,  bool hasMoreProducts,  bool isLoadingMoreProducts,  int productsTotal,  String? stockError,  String? categoriesError,  String? taxError,  Map<String, String> priceCache,  PosPriceContext priceContext,  Map<String, String> stockCache,  Map<String, ProductModel> productDetailsCache)?  $default,) {final _that = this;
switch (_that) {
case _PosCatalogState() when $default != null:
return $default(_that.products,_that.categories,_that.selectedCategoryId,_that.productSearchQuery,_that.isLoadingProducts,_that.productsError,_that.hasMoreProducts,_that.isLoadingMoreProducts,_that.productsTotal,_that.stockError,_that.categoriesError,_that.taxError,_that.priceCache,_that.priceContext,_that.stockCache,_that.productDetailsCache);case _:
  return null;

}
}

}

/// @nodoc


class _PosCatalogState implements PosCatalogState {
  const _PosCatalogState({ List<ProductListItemModel> products = const [],  List<CategoryModel> categories = const [], this.selectedCategoryId, this.productSearchQuery = '', this.isLoadingProducts = true, this.productsError, this.hasMoreProducts = false, this.isLoadingMoreProducts = false, this.productsTotal = 0, this.stockError, this.categoriesError, this.taxError,  Map<String, String> priceCache = const {}, this.priceContext = const PosPriceContext(),  Map<String, String> stockCache = const {},  Map<String, ProductModel> productDetailsCache = const {}}): _products = products,_categories = categories,_priceCache = priceCache,_stockCache = stockCache,_productDetailsCache = productDetailsCache;
  

 final  List<ProductListItemModel> _products;
@override@JsonKey() List<ProductListItemModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<CategoryModel> _categories;
@override@JsonKey() List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  String? selectedCategoryId;
@override@JsonKey() final  String productSearchQuery;
@override@JsonKey() final  bool isLoadingProducts;
@override final  String? productsError;
@override@JsonKey() final  bool hasMoreProducts;
@override@JsonKey() final  bool isLoadingMoreProducts;
@override@JsonKey() final  int productsTotal;
@override final  String? stockError;
@override final  String? categoriesError;
@override final  String? taxError;
 final  Map<String, String> _priceCache;
@override@JsonKey() Map<String, String> get priceCache {
  if (_priceCache is EqualUnmodifiableMapView) return _priceCache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_priceCache);
}

@override@JsonKey() final  PosPriceContext priceContext;
 final  Map<String, String> _stockCache;
@override@JsonKey() Map<String, String> get stockCache {
  if (_stockCache is EqualUnmodifiableMapView) return _stockCache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stockCache);
}

 final  Map<String, ProductModel> _productDetailsCache;
@override@JsonKey() Map<String, ProductModel> get productDetailsCache {
  if (_productDetailsCache is EqualUnmodifiableMapView) return _productDetailsCache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_productDetailsCache);
}


/// Create a copy of PosCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosCatalogStateCopyWith<_PosCatalogState> get copyWith => __$PosCatalogStateCopyWithImpl<_PosCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosCatalogState&&const DeepCollectionEquality().equals(other.products, _products)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&(identical(other.productSearchQuery, productSearchQuery) || other.productSearchQuery == productSearchQuery)&&(identical(other.isLoadingProducts, isLoadingProducts) || other.isLoadingProducts == isLoadingProducts)&&(identical(other.productsError, productsError) || other.productsError == productsError)&&(identical(other.hasMoreProducts, hasMoreProducts) || other.hasMoreProducts == hasMoreProducts)&&(identical(other.isLoadingMoreProducts, isLoadingMoreProducts) || other.isLoadingMoreProducts == isLoadingMoreProducts)&&(identical(other.productsTotal, productsTotal) || other.productsTotal == productsTotal)&&(identical(other.stockError, stockError) || other.stockError == stockError)&&(identical(other.categoriesError, categoriesError) || other.categoriesError == categoriesError)&&(identical(other.taxError, taxError) || other.taxError == taxError)&&const DeepCollectionEquality().equals(other.priceCache, _priceCache)&&(identical(other.priceContext, priceContext) || other.priceContext == priceContext)&&const DeepCollectionEquality().equals(other.stockCache, _stockCache)&&const DeepCollectionEquality().equals(other.productDetailsCache, _productDetailsCache));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_categories),selectedCategoryId,productSearchQuery,isLoadingProducts,productsError,hasMoreProducts,isLoadingMoreProducts,productsTotal,stockError,categoriesError,taxError,const DeepCollectionEquality().hash(_priceCache),priceContext,const DeepCollectionEquality().hash(_stockCache),const DeepCollectionEquality().hash(_productDetailsCache));
}

@override
String toString() {
    return 'PosCatalogState(products: $products, categories: $categories, selectedCategoryId: $selectedCategoryId, productSearchQuery: $productSearchQuery, isLoadingProducts: $isLoadingProducts, productsError: $productsError, hasMoreProducts: $hasMoreProducts, isLoadingMoreProducts: $isLoadingMoreProducts, productsTotal: $productsTotal, stockError: $stockError, categoriesError: $categoriesError, taxError: $taxError, priceCache: $priceCache, priceContext: $priceContext, stockCache: $stockCache, productDetailsCache: $productDetailsCache)';
}


}

/// @nodoc
abstract mixin class _$PosCatalogStateCopyWith<$Res> implements $PosCatalogStateCopyWith<$Res> {
  factory _$PosCatalogStateCopyWith(_PosCatalogState value, $Res Function(_PosCatalogState) _then) = __$PosCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 List<ProductListItemModel> products, List<CategoryModel> categories, String? selectedCategoryId, String productSearchQuery, bool isLoadingProducts, String? productsError, bool hasMoreProducts, bool isLoadingMoreProducts, int productsTotal, String? stockError, String? categoriesError, String? taxError, Map<String, String> priceCache, PosPriceContext priceContext, Map<String, String> stockCache, Map<String, ProductModel> productDetailsCache
});




}
/// @nodoc
class __$PosCatalogStateCopyWithImpl<$Res>
    implements _$PosCatalogStateCopyWith<$Res> {
  __$PosCatalogStateCopyWithImpl(this._self, this._then);

  final _PosCatalogState _self;
  final $Res Function(_PosCatalogState) _then;

/// Create a copy of PosCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,Object? categories = null,Object? selectedCategoryId = freezed,Object? productSearchQuery = null,Object? isLoadingProducts = null,Object? productsError = freezed,Object? hasMoreProducts = null,Object? isLoadingMoreProducts = null,Object? productsTotal = null,Object? stockError = freezed,Object? categoriesError = freezed,Object? taxError = freezed,Object? priceCache = null,Object? priceContext = null,Object? stockCache = null,Object? productDetailsCache = null,}) {
  return _then(_PosCatalogState(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,productSearchQuery: null == productSearchQuery ? _self.productSearchQuery : productSearchQuery // ignore: cast_nullable_to_non_nullable
as String,isLoadingProducts: null == isLoadingProducts ? _self.isLoadingProducts : isLoadingProducts // ignore: cast_nullable_to_non_nullable
as bool,productsError: freezed == productsError ? _self.productsError : productsError // ignore: cast_nullable_to_non_nullable
as String?,hasMoreProducts: null == hasMoreProducts ? _self.hasMoreProducts : hasMoreProducts // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMoreProducts: null == isLoadingMoreProducts ? _self.isLoadingMoreProducts : isLoadingMoreProducts // ignore: cast_nullable_to_non_nullable
as bool,productsTotal: null == productsTotal ? _self.productsTotal : productsTotal // ignore: cast_nullable_to_non_nullable
as int,stockError: freezed == stockError ? _self.stockError : stockError // ignore: cast_nullable_to_non_nullable
as String?,categoriesError: freezed == categoriesError ? _self.categoriesError : categoriesError // ignore: cast_nullable_to_non_nullable
as String?,taxError: freezed == taxError ? _self.taxError : taxError // ignore: cast_nullable_to_non_nullable
as String?,priceCache: null == priceCache ? _self._priceCache : priceCache // ignore: cast_nullable_to_non_nullable
as Map<String, String>,priceContext: null == priceContext ? _self.priceContext : priceContext // ignore: cast_nullable_to_non_nullable
as PosPriceContext,stockCache: null == stockCache ? _self._stockCache : stockCache // ignore: cast_nullable_to_non_nullable
as Map<String, String>,productDetailsCache: null == productDetailsCache ? _self._productDetailsCache : productDetailsCache // ignore: cast_nullable_to_non_nullable
as Map<String, ProductModel>,
  ));
}


}

/// @nodoc
mixin _$PosCartState {

 List<CartItemModel> get cartItems; List<TaxRateModel> get taxRates; TaxRateModel? get defaultTaxRate; CustomerModel? get selectedCustomer; String? get cartDiscountType; String? get cartDiscountValue; String? get cartNote; List<HeldOrderModel> get heldOrders; bool get isHoldingSale; bool get isSubmittingSale; bool get isFiringTab; bool get isRequestingBill; String? get selectedDiscountSchemeId; List<DiscountSchemeModel> get discountSchemes; SalePricePreviewModel? get pricePreview; bool get isLoadingPricePreview; String? get pricePreviewError;/// Bumped when the business's tax or price settings change, so every
/// widget showing prices rebuilds at once.
 int get taxRevision;
/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosCartStateCopyWith<PosCartState> get copyWith => _$PosCartStateCopyWithImpl<PosCartState>(this as PosCartState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PosCartState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosCartState&&const DeepCollectionEquality().equals(other.cartItems, _this.cartItems)&&const DeepCollectionEquality().equals(other.taxRates, _this.taxRates)&&(identical(other.defaultTaxRate, _this.defaultTaxRate) || other.defaultTaxRate == _this.defaultTaxRate)&&(identical(other.selectedCustomer, _this.selectedCustomer) || other.selectedCustomer == _this.selectedCustomer)&&(identical(other.cartDiscountType, _this.cartDiscountType) || other.cartDiscountType == _this.cartDiscountType)&&(identical(other.cartDiscountValue, _this.cartDiscountValue) || other.cartDiscountValue == _this.cartDiscountValue)&&(identical(other.cartNote, _this.cartNote) || other.cartNote == _this.cartNote)&&const DeepCollectionEquality().equals(other.heldOrders, _this.heldOrders)&&(identical(other.isHoldingSale, _this.isHoldingSale) || other.isHoldingSale == _this.isHoldingSale)&&(identical(other.isSubmittingSale, _this.isSubmittingSale) || other.isSubmittingSale == _this.isSubmittingSale)&&(identical(other.isFiringTab, _this.isFiringTab) || other.isFiringTab == _this.isFiringTab)&&(identical(other.isRequestingBill, _this.isRequestingBill) || other.isRequestingBill == _this.isRequestingBill)&&(identical(other.selectedDiscountSchemeId, _this.selectedDiscountSchemeId) || other.selectedDiscountSchemeId == _this.selectedDiscountSchemeId)&&const DeepCollectionEquality().equals(other.discountSchemes, _this.discountSchemes)&&(identical(other.pricePreview, _this.pricePreview) || other.pricePreview == _this.pricePreview)&&(identical(other.isLoadingPricePreview, _this.isLoadingPricePreview) || other.isLoadingPricePreview == _this.isLoadingPricePreview)&&(identical(other.pricePreviewError, _this.pricePreviewError) || other.pricePreviewError == _this.pricePreviewError)&&(identical(other.taxRevision, _this.taxRevision) || other.taxRevision == _this.taxRevision));
}


@override
int get hashCode {
  final _this = this as PosCartState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.cartItems),const DeepCollectionEquality().hash(_this.taxRates),_this.defaultTaxRate,_this.selectedCustomer,_this.cartDiscountType,_this.cartDiscountValue,_this.cartNote,const DeepCollectionEquality().hash(_this.heldOrders),_this.isHoldingSale,_this.isSubmittingSale,_this.isFiringTab,_this.isRequestingBill,_this.selectedDiscountSchemeId,const DeepCollectionEquality().hash(_this.discountSchemes),_this.pricePreview,_this.isLoadingPricePreview,_this.pricePreviewError,_this.taxRevision);
}

@override
String toString() {
  final _this = this as PosCartState;
  return 'PosCartState(cartItems: ${_this.cartItems}, taxRates: ${_this.taxRates}, defaultTaxRate: ${_this.defaultTaxRate}, selectedCustomer: ${_this.selectedCustomer}, cartDiscountType: ${_this.cartDiscountType}, cartDiscountValue: ${_this.cartDiscountValue}, cartNote: ${_this.cartNote}, heldOrders: ${_this.heldOrders}, isHoldingSale: ${_this.isHoldingSale}, isSubmittingSale: ${_this.isSubmittingSale}, isFiringTab: ${_this.isFiringTab}, isRequestingBill: ${_this.isRequestingBill}, selectedDiscountSchemeId: ${_this.selectedDiscountSchemeId}, discountSchemes: ${_this.discountSchemes}, pricePreview: ${_this.pricePreview}, isLoadingPricePreview: ${_this.isLoadingPricePreview}, pricePreviewError: ${_this.pricePreviewError}, taxRevision: ${_this.taxRevision})';
}


}

/// @nodoc
abstract mixin class $PosCartStateCopyWith<$Res>  {
  factory $PosCartStateCopyWith(PosCartState value, $Res Function(PosCartState) _then) = _$PosCartStateCopyWithImpl;
@useResult
$Res call({
 List<CartItemModel> cartItems, List<TaxRateModel> taxRates, TaxRateModel? defaultTaxRate, CustomerModel? selectedCustomer, String? cartDiscountType, String? cartDiscountValue, String? cartNote, List<HeldOrderModel> heldOrders, bool isHoldingSale, bool isSubmittingSale, bool isFiringTab, bool isRequestingBill, String? selectedDiscountSchemeId, List<DiscountSchemeModel> discountSchemes, SalePricePreviewModel? pricePreview, bool isLoadingPricePreview, String? pricePreviewError, int taxRevision
});


$TaxRateModelCopyWith<$Res>? get defaultTaxRate;$CustomerModelCopyWith<$Res>? get selectedCustomer;$SalePricePreviewModelCopyWith<$Res>? get pricePreview;

}
/// @nodoc
class _$PosCartStateCopyWithImpl<$Res>
    implements $PosCartStateCopyWith<$Res> {
  _$PosCartStateCopyWithImpl(this._self, this._then);

  final PosCartState _self;
  final $Res Function(PosCartState) _then;

/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cartItems = null,Object? taxRates = null,Object? defaultTaxRate = freezed,Object? selectedCustomer = freezed,Object? cartDiscountType = freezed,Object? cartDiscountValue = freezed,Object? cartNote = freezed,Object? heldOrders = null,Object? isHoldingSale = null,Object? isSubmittingSale = null,Object? isFiringTab = null,Object? isRequestingBill = null,Object? selectedDiscountSchemeId = freezed,Object? discountSchemes = null,Object? pricePreview = freezed,Object? isLoadingPricePreview = null,Object? pricePreviewError = freezed,Object? taxRevision = null,}) {
  return _then(PosCartState(
cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,taxRates: null == taxRates ? _self.taxRates : taxRates // ignore: cast_nullable_to_non_nullable
as List<TaxRateModel>,defaultTaxRate: freezed == defaultTaxRate ? _self.defaultTaxRate : defaultTaxRate // ignore: cast_nullable_to_non_nullable
as TaxRateModel?,selectedCustomer: freezed == selectedCustomer ? _self.selectedCustomer : selectedCustomer // ignore: cast_nullable_to_non_nullable
as CustomerModel?,cartDiscountType: freezed == cartDiscountType ? _self.cartDiscountType : cartDiscountType // ignore: cast_nullable_to_non_nullable
as String?,cartDiscountValue: freezed == cartDiscountValue ? _self.cartDiscountValue : cartDiscountValue // ignore: cast_nullable_to_non_nullable
as String?,cartNote: freezed == cartNote ? _self.cartNote : cartNote // ignore: cast_nullable_to_non_nullable
as String?,heldOrders: null == heldOrders ? _self.heldOrders : heldOrders // ignore: cast_nullable_to_non_nullable
as List<HeldOrderModel>,isHoldingSale: null == isHoldingSale ? _self.isHoldingSale : isHoldingSale // ignore: cast_nullable_to_non_nullable
as bool,isSubmittingSale: null == isSubmittingSale ? _self.isSubmittingSale : isSubmittingSale // ignore: cast_nullable_to_non_nullable
as bool,isFiringTab: null == isFiringTab ? _self.isFiringTab : isFiringTab // ignore: cast_nullable_to_non_nullable
as bool,isRequestingBill: null == isRequestingBill ? _self.isRequestingBill : isRequestingBill // ignore: cast_nullable_to_non_nullable
as bool,selectedDiscountSchemeId: freezed == selectedDiscountSchemeId ? _self.selectedDiscountSchemeId : selectedDiscountSchemeId // ignore: cast_nullable_to_non_nullable
as String?,discountSchemes: null == discountSchemes ? _self.discountSchemes : discountSchemes // ignore: cast_nullable_to_non_nullable
as List<DiscountSchemeModel>,pricePreview: freezed == pricePreview ? _self.pricePreview : pricePreview // ignore: cast_nullable_to_non_nullable
as SalePricePreviewModel?,isLoadingPricePreview: null == isLoadingPricePreview ? _self.isLoadingPricePreview : isLoadingPricePreview // ignore: cast_nullable_to_non_nullable
as bool,pricePreviewError: freezed == pricePreviewError ? _self.pricePreviewError : pricePreviewError // ignore: cast_nullable_to_non_nullable
as String?,taxRevision: null == taxRevision ? _self.taxRevision : taxRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaxRateModelCopyWith<$Res>? get defaultTaxRate {
    if (_self.defaultTaxRate == null) {
    return null;
  }

  return $TaxRateModelCopyWith<$Res>(_self.defaultTaxRate!, (value) {
    return _then(_self.copyWith(defaultTaxRate: value));
  });
}/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res>? get selectedCustomer {
    if (_self.selectedCustomer == null) {
    return null;
  }

  return $CustomerModelCopyWith<$Res>(_self.selectedCustomer!, (value) {
    return _then(_self.copyWith(selectedCustomer: value));
  });
}/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalePricePreviewModelCopyWith<$Res>? get pricePreview {
    if (_self.pricePreview == null) {
    return null;
  }

  return $SalePricePreviewModelCopyWith<$Res>(_self.pricePreview!, (value) {
    return _then(_self.copyWith(pricePreview: value));
  });
}
}


/// Adds pattern-matching-related methods to [PosCartState].
extension PosCartStatePatterns on PosCartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosCartState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosCartState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosCartState value)  $default,){
final _that = this;
switch (_that) {
case _PosCartState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosCartState value)?  $default,){
final _that = this;
switch (_that) {
case _PosCartState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CartItemModel> cartItems,  List<TaxRateModel> taxRates,  TaxRateModel? defaultTaxRate,  CustomerModel? selectedCustomer,  String? cartDiscountType,  String? cartDiscountValue,  String? cartNote,  List<HeldOrderModel> heldOrders,  bool isHoldingSale,  bool isSubmittingSale,  bool isFiringTab,  bool isRequestingBill,  String? selectedDiscountSchemeId,  List<DiscountSchemeModel> discountSchemes,  SalePricePreviewModel? pricePreview,  bool isLoadingPricePreview,  String? pricePreviewError,  int taxRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosCartState() when $default != null:
return $default(_that.cartItems,_that.taxRates,_that.defaultTaxRate,_that.selectedCustomer,_that.cartDiscountType,_that.cartDiscountValue,_that.cartNote,_that.heldOrders,_that.isHoldingSale,_that.isSubmittingSale,_that.isFiringTab,_that.isRequestingBill,_that.selectedDiscountSchemeId,_that.discountSchemes,_that.pricePreview,_that.isLoadingPricePreview,_that.pricePreviewError,_that.taxRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CartItemModel> cartItems,  List<TaxRateModel> taxRates,  TaxRateModel? defaultTaxRate,  CustomerModel? selectedCustomer,  String? cartDiscountType,  String? cartDiscountValue,  String? cartNote,  List<HeldOrderModel> heldOrders,  bool isHoldingSale,  bool isSubmittingSale,  bool isFiringTab,  bool isRequestingBill,  String? selectedDiscountSchemeId,  List<DiscountSchemeModel> discountSchemes,  SalePricePreviewModel? pricePreview,  bool isLoadingPricePreview,  String? pricePreviewError,  int taxRevision)  $default,) {final _that = this;
switch (_that) {
case _PosCartState():
return $default(_that.cartItems,_that.taxRates,_that.defaultTaxRate,_that.selectedCustomer,_that.cartDiscountType,_that.cartDiscountValue,_that.cartNote,_that.heldOrders,_that.isHoldingSale,_that.isSubmittingSale,_that.isFiringTab,_that.isRequestingBill,_that.selectedDiscountSchemeId,_that.discountSchemes,_that.pricePreview,_that.isLoadingPricePreview,_that.pricePreviewError,_that.taxRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CartItemModel> cartItems,  List<TaxRateModel> taxRates,  TaxRateModel? defaultTaxRate,  CustomerModel? selectedCustomer,  String? cartDiscountType,  String? cartDiscountValue,  String? cartNote,  List<HeldOrderModel> heldOrders,  bool isHoldingSale,  bool isSubmittingSale,  bool isFiringTab,  bool isRequestingBill,  String? selectedDiscountSchemeId,  List<DiscountSchemeModel> discountSchemes,  SalePricePreviewModel? pricePreview,  bool isLoadingPricePreview,  String? pricePreviewError,  int taxRevision)?  $default,) {final _that = this;
switch (_that) {
case _PosCartState() when $default != null:
return $default(_that.cartItems,_that.taxRates,_that.defaultTaxRate,_that.selectedCustomer,_that.cartDiscountType,_that.cartDiscountValue,_that.cartNote,_that.heldOrders,_that.isHoldingSale,_that.isSubmittingSale,_that.isFiringTab,_that.isRequestingBill,_that.selectedDiscountSchemeId,_that.discountSchemes,_that.pricePreview,_that.isLoadingPricePreview,_that.pricePreviewError,_that.taxRevision);case _:
  return null;

}
}

}

/// @nodoc


class _PosCartState extends PosCartState {
  const _PosCartState({ List<CartItemModel> cartItems = const [],  List<TaxRateModel> taxRates = const [], this.defaultTaxRate, this.selectedCustomer, this.cartDiscountType, this.cartDiscountValue, this.cartNote,  List<HeldOrderModel> heldOrders = const [], this.isHoldingSale = false, this.isSubmittingSale = false, this.isFiringTab = false, this.isRequestingBill = false, this.selectedDiscountSchemeId,  List<DiscountSchemeModel> discountSchemes = const [], this.pricePreview, this.isLoadingPricePreview = false, this.pricePreviewError, this.taxRevision = 0}): _cartItems = cartItems,_taxRates = taxRates,_heldOrders = heldOrders,_discountSchemes = discountSchemes,super._();
  

 final  List<CartItemModel> _cartItems;
@override@JsonKey() List<CartItemModel> get cartItems {
  if (_cartItems is EqualUnmodifiableListView) return _cartItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartItems);
}

 final  List<TaxRateModel> _taxRates;
@override@JsonKey() List<TaxRateModel> get taxRates {
  if (_taxRates is EqualUnmodifiableListView) return _taxRates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taxRates);
}

@override final  TaxRateModel? defaultTaxRate;
@override final  CustomerModel? selectedCustomer;
@override final  String? cartDiscountType;
@override final  String? cartDiscountValue;
@override final  String? cartNote;
 final  List<HeldOrderModel> _heldOrders;
@override@JsonKey() List<HeldOrderModel> get heldOrders {
  if (_heldOrders is EqualUnmodifiableListView) return _heldOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heldOrders);
}

@override@JsonKey() final  bool isHoldingSale;
@override@JsonKey() final  bool isSubmittingSale;
@override@JsonKey() final  bool isFiringTab;
@override@JsonKey() final  bool isRequestingBill;
@override final  String? selectedDiscountSchemeId;
 final  List<DiscountSchemeModel> _discountSchemes;
@override@JsonKey() List<DiscountSchemeModel> get discountSchemes {
  if (_discountSchemes is EqualUnmodifiableListView) return _discountSchemes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discountSchemes);
}

@override final  SalePricePreviewModel? pricePreview;
@override@JsonKey() final  bool isLoadingPricePreview;
@override final  String? pricePreviewError;
/// Bumped when the business's tax or price settings change, so every
/// widget showing prices rebuilds at once.
@override@JsonKey() final  int taxRevision;

/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosCartStateCopyWith<_PosCartState> get copyWith => __$PosCartStateCopyWithImpl<_PosCartState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosCartState&&const DeepCollectionEquality().equals(other.cartItems, _cartItems)&&const DeepCollectionEquality().equals(other.taxRates, _taxRates)&&(identical(other.defaultTaxRate, defaultTaxRate) || other.defaultTaxRate == defaultTaxRate)&&(identical(other.selectedCustomer, selectedCustomer) || other.selectedCustomer == selectedCustomer)&&(identical(other.cartDiscountType, cartDiscountType) || other.cartDiscountType == cartDiscountType)&&(identical(other.cartDiscountValue, cartDiscountValue) || other.cartDiscountValue == cartDiscountValue)&&(identical(other.cartNote, cartNote) || other.cartNote == cartNote)&&const DeepCollectionEquality().equals(other.heldOrders, _heldOrders)&&(identical(other.isHoldingSale, isHoldingSale) || other.isHoldingSale == isHoldingSale)&&(identical(other.isSubmittingSale, isSubmittingSale) || other.isSubmittingSale == isSubmittingSale)&&(identical(other.isFiringTab, isFiringTab) || other.isFiringTab == isFiringTab)&&(identical(other.isRequestingBill, isRequestingBill) || other.isRequestingBill == isRequestingBill)&&(identical(other.selectedDiscountSchemeId, selectedDiscountSchemeId) || other.selectedDiscountSchemeId == selectedDiscountSchemeId)&&const DeepCollectionEquality().equals(other.discountSchemes, _discountSchemes)&&(identical(other.pricePreview, pricePreview) || other.pricePreview == pricePreview)&&(identical(other.isLoadingPricePreview, isLoadingPricePreview) || other.isLoadingPricePreview == isLoadingPricePreview)&&(identical(other.pricePreviewError, pricePreviewError) || other.pricePreviewError == pricePreviewError)&&(identical(other.taxRevision, taxRevision) || other.taxRevision == taxRevision));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_cartItems),const DeepCollectionEquality().hash(_taxRates),defaultTaxRate,selectedCustomer,cartDiscountType,cartDiscountValue,cartNote,const DeepCollectionEquality().hash(_heldOrders),isHoldingSale,isSubmittingSale,isFiringTab,isRequestingBill,selectedDiscountSchemeId,const DeepCollectionEquality().hash(_discountSchemes),pricePreview,isLoadingPricePreview,pricePreviewError,taxRevision);
}

@override
String toString() {
    return 'PosCartState(cartItems: $cartItems, taxRates: $taxRates, defaultTaxRate: $defaultTaxRate, selectedCustomer: $selectedCustomer, cartDiscountType: $cartDiscountType, cartDiscountValue: $cartDiscountValue, cartNote: $cartNote, heldOrders: $heldOrders, isHoldingSale: $isHoldingSale, isSubmittingSale: $isSubmittingSale, isFiringTab: $isFiringTab, isRequestingBill: $isRequestingBill, selectedDiscountSchemeId: $selectedDiscountSchemeId, discountSchemes: $discountSchemes, pricePreview: $pricePreview, isLoadingPricePreview: $isLoadingPricePreview, pricePreviewError: $pricePreviewError, taxRevision: $taxRevision)';
}


}

/// @nodoc
abstract mixin class _$PosCartStateCopyWith<$Res> implements $PosCartStateCopyWith<$Res> {
  factory _$PosCartStateCopyWith(_PosCartState value, $Res Function(_PosCartState) _then) = __$PosCartStateCopyWithImpl;
@override @useResult
$Res call({
 List<CartItemModel> cartItems, List<TaxRateModel> taxRates, TaxRateModel? defaultTaxRate, CustomerModel? selectedCustomer, String? cartDiscountType, String? cartDiscountValue, String? cartNote, List<HeldOrderModel> heldOrders, bool isHoldingSale, bool isSubmittingSale, bool isFiringTab, bool isRequestingBill, String? selectedDiscountSchemeId, List<DiscountSchemeModel> discountSchemes, SalePricePreviewModel? pricePreview, bool isLoadingPricePreview, String? pricePreviewError, int taxRevision
});


@override $TaxRateModelCopyWith<$Res>? get defaultTaxRate;@override $CustomerModelCopyWith<$Res>? get selectedCustomer;@override $SalePricePreviewModelCopyWith<$Res>? get pricePreview;

}
/// @nodoc
class __$PosCartStateCopyWithImpl<$Res>
    implements _$PosCartStateCopyWith<$Res> {
  __$PosCartStateCopyWithImpl(this._self, this._then);

  final _PosCartState _self;
  final $Res Function(_PosCartState) _then;

/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cartItems = null,Object? taxRates = null,Object? defaultTaxRate = freezed,Object? selectedCustomer = freezed,Object? cartDiscountType = freezed,Object? cartDiscountValue = freezed,Object? cartNote = freezed,Object? heldOrders = null,Object? isHoldingSale = null,Object? isSubmittingSale = null,Object? isFiringTab = null,Object? isRequestingBill = null,Object? selectedDiscountSchemeId = freezed,Object? discountSchemes = null,Object? pricePreview = freezed,Object? isLoadingPricePreview = null,Object? pricePreviewError = freezed,Object? taxRevision = null,}) {
  return _then(_PosCartState(
cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,taxRates: null == taxRates ? _self._taxRates : taxRates // ignore: cast_nullable_to_non_nullable
as List<TaxRateModel>,defaultTaxRate: freezed == defaultTaxRate ? _self.defaultTaxRate : defaultTaxRate // ignore: cast_nullable_to_non_nullable
as TaxRateModel?,selectedCustomer: freezed == selectedCustomer ? _self.selectedCustomer : selectedCustomer // ignore: cast_nullable_to_non_nullable
as CustomerModel?,cartDiscountType: freezed == cartDiscountType ? _self.cartDiscountType : cartDiscountType // ignore: cast_nullable_to_non_nullable
as String?,cartDiscountValue: freezed == cartDiscountValue ? _self.cartDiscountValue : cartDiscountValue // ignore: cast_nullable_to_non_nullable
as String?,cartNote: freezed == cartNote ? _self.cartNote : cartNote // ignore: cast_nullable_to_non_nullable
as String?,heldOrders: null == heldOrders ? _self._heldOrders : heldOrders // ignore: cast_nullable_to_non_nullable
as List<HeldOrderModel>,isHoldingSale: null == isHoldingSale ? _self.isHoldingSale : isHoldingSale // ignore: cast_nullable_to_non_nullable
as bool,isSubmittingSale: null == isSubmittingSale ? _self.isSubmittingSale : isSubmittingSale // ignore: cast_nullable_to_non_nullable
as bool,isFiringTab: null == isFiringTab ? _self.isFiringTab : isFiringTab // ignore: cast_nullable_to_non_nullable
as bool,isRequestingBill: null == isRequestingBill ? _self.isRequestingBill : isRequestingBill // ignore: cast_nullable_to_non_nullable
as bool,selectedDiscountSchemeId: freezed == selectedDiscountSchemeId ? _self.selectedDiscountSchemeId : selectedDiscountSchemeId // ignore: cast_nullable_to_non_nullable
as String?,discountSchemes: null == discountSchemes ? _self._discountSchemes : discountSchemes // ignore: cast_nullable_to_non_nullable
as List<DiscountSchemeModel>,pricePreview: freezed == pricePreview ? _self.pricePreview : pricePreview // ignore: cast_nullable_to_non_nullable
as SalePricePreviewModel?,isLoadingPricePreview: null == isLoadingPricePreview ? _self.isLoadingPricePreview : isLoadingPricePreview // ignore: cast_nullable_to_non_nullable
as bool,pricePreviewError: freezed == pricePreviewError ? _self.pricePreviewError : pricePreviewError // ignore: cast_nullable_to_non_nullable
as String?,taxRevision: null == taxRevision ? _self.taxRevision : taxRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaxRateModelCopyWith<$Res>? get defaultTaxRate {
    if (_self.defaultTaxRate == null) {
    return null;
  }

  return $TaxRateModelCopyWith<$Res>(_self.defaultTaxRate!, (value) {
    return _then(_self.copyWith(defaultTaxRate: value));
  });
}/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res>? get selectedCustomer {
    if (_self.selectedCustomer == null) {
    return null;
  }

  return $CustomerModelCopyWith<$Res>(_self.selectedCustomer!, (value) {
    return _then(_self.copyWith(selectedCustomer: value));
  });
}/// Create a copy of PosCartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalePricePreviewModelCopyWith<$Res>? get pricePreview {
    if (_self.pricePreview == null) {
    return null;
  }

  return $SalePricePreviewModelCopyWith<$Res>(_self.pricePreview!, (value) {
    return _then(_self.copyWith(pricePreview: value));
  });
}
}

// dart format on
