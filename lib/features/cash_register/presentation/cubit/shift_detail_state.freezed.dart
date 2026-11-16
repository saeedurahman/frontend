// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShiftDetailState {

 RegisterShiftModel? get shift; ShiftSummaryModel? get summary; CashRegisterModel? get register; bool get isLoading; String? get error;
/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftDetailStateCopyWith<ShiftDetailState> get copyWith => _$ShiftDetailStateCopyWithImpl<ShiftDetailState>(this as ShiftDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShiftDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftDetailState&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.register, _this.register) || other.register == _this.register)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ShiftDetailState;
  return Object.hash(runtimeType,_this.shift,_this.summary,_this.register,_this.isLoading,_this.error);
}

@override
String toString() {
  final _this = this as ShiftDetailState;
  return 'ShiftDetailState(shift: ${_this.shift}, summary: ${_this.summary}, register: ${_this.register}, isLoading: ${_this.isLoading}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ShiftDetailStateCopyWith<$Res>  {
  factory $ShiftDetailStateCopyWith(ShiftDetailState value, $Res Function(ShiftDetailState) _then) = _$ShiftDetailStateCopyWithImpl;
@useResult
$Res call({
 RegisterShiftModel? shift, ShiftSummaryModel? summary, CashRegisterModel? register, bool isLoading, String? error
});


$RegisterShiftModelCopyWith<$Res>? get shift;$ShiftSummaryModelCopyWith<$Res>? get summary;$CashRegisterModelCopyWith<$Res>? get register;

}
/// @nodoc
class _$ShiftDetailStateCopyWithImpl<$Res>
    implements $ShiftDetailStateCopyWith<$Res> {
  _$ShiftDetailStateCopyWithImpl(this._self, this._then);

  final ShiftDetailState _self;
  final $Res Function(ShiftDetailState) _then;

/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shift = freezed,Object? summary = freezed,Object? register = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(ShiftDetailState(
shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as RegisterShiftModel?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ShiftSummaryModel?,register: freezed == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as CashRegisterModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<$Res>? get shift {
    if (_self.shift == null) {
    return null;
  }

  return $RegisterShiftModelCopyWith<$Res>(_self.shift!, (value) {
    return _then(_self.copyWith(shift: value));
  });
}/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShiftSummaryModelCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $ShiftSummaryModelCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<$Res>? get register {
    if (_self.register == null) {
    return null;
  }

  return $CashRegisterModelCopyWith<$Res>(_self.register!, (value) {
    return _then(_self.copyWith(register: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShiftDetailState].
extension ShiftDetailStatePatterns on ShiftDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ShiftDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RegisterShiftModel? shift,  ShiftSummaryModel? summary,  CashRegisterModel? register,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftDetailState() when $default != null:
return $default(_that.shift,_that.summary,_that.register,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RegisterShiftModel? shift,  ShiftSummaryModel? summary,  CashRegisterModel? register,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ShiftDetailState():
return $default(_that.shift,_that.summary,_that.register,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RegisterShiftModel? shift,  ShiftSummaryModel? summary,  CashRegisterModel? register,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ShiftDetailState() when $default != null:
return $default(_that.shift,_that.summary,_that.register,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ShiftDetailState implements ShiftDetailState {
  const _ShiftDetailState({this.shift, this.summary, this.register, this.isLoading = false, this.error});
  

@override final  RegisterShiftModel? shift;
@override final  ShiftSummaryModel? summary;
@override final  CashRegisterModel? register;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftDetailStateCopyWith<_ShiftDetailState> get copyWith => __$ShiftDetailStateCopyWithImpl<_ShiftDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftDetailState&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.register, register) || other.register == register)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,shift,summary,register,isLoading,error);
}

@override
String toString() {
    return 'ShiftDetailState(shift: $shift, summary: $summary, register: $register, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ShiftDetailStateCopyWith<$Res> implements $ShiftDetailStateCopyWith<$Res> {
  factory _$ShiftDetailStateCopyWith(_ShiftDetailState value, $Res Function(_ShiftDetailState) _then) = __$ShiftDetailStateCopyWithImpl;
@override @useResult
$Res call({
 RegisterShiftModel? shift, ShiftSummaryModel? summary, CashRegisterModel? register, bool isLoading, String? error
});


@override $RegisterShiftModelCopyWith<$Res>? get shift;@override $ShiftSummaryModelCopyWith<$Res>? get summary;@override $CashRegisterModelCopyWith<$Res>? get register;

}
/// @nodoc
class __$ShiftDetailStateCopyWithImpl<$Res>
    implements _$ShiftDetailStateCopyWith<$Res> {
  __$ShiftDetailStateCopyWithImpl(this._self, this._then);

  final _ShiftDetailState _self;
  final $Res Function(_ShiftDetailState) _then;

/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shift = freezed,Object? summary = freezed,Object? register = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_ShiftDetailState(
shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as RegisterShiftModel?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ShiftSummaryModel?,register: freezed == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as CashRegisterModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<$Res>? get shift {
    if (_self.shift == null) {
    return null;
  }

  return $RegisterShiftModelCopyWith<$Res>(_self.shift!, (value) {
    return _then(_self.copyWith(shift: value));
  });
}/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShiftSummaryModelCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $ShiftSummaryModelCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of ShiftDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<$Res>? get register {
    if (_self.register == null) {
    return null;
  }

  return $CashRegisterModelCopyWith<$Res>(_self.register!, (value) {
    return _then(_self.copyWith(register: value));
  });
}
}

// dart format on
