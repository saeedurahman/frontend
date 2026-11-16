// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_shift_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenShiftEntry {

 RegisterShiftModel get shift; CashRegisterModel get register; ShiftSummaryModel? get summary;
/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenShiftEntryCopyWith<OpenShiftEntry> get copyWith => _$OpenShiftEntryCopyWithImpl<OpenShiftEntry>(this as OpenShiftEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OpenShiftEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenShiftEntry&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.register, _this.register) || other.register == _this.register)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}


@override
int get hashCode {
  final _this = this as OpenShiftEntry;
  return Object.hash(runtimeType,_this.shift,_this.register,_this.summary);
}

@override
String toString() {
  final _this = this as OpenShiftEntry;
  return 'OpenShiftEntry(shift: ${_this.shift}, register: ${_this.register}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $OpenShiftEntryCopyWith<$Res>  {
  factory $OpenShiftEntryCopyWith(OpenShiftEntry value, $Res Function(OpenShiftEntry) _then) = _$OpenShiftEntryCopyWithImpl;
@useResult
$Res call({
 RegisterShiftModel shift, CashRegisterModel register, ShiftSummaryModel? summary
});


$RegisterShiftModelCopyWith<$Res> get shift;$CashRegisterModelCopyWith<$Res> get register;$ShiftSummaryModelCopyWith<$Res>? get summary;

}
/// @nodoc
class _$OpenShiftEntryCopyWithImpl<$Res>
    implements $OpenShiftEntryCopyWith<$Res> {
  _$OpenShiftEntryCopyWithImpl(this._self, this._then);

  final OpenShiftEntry _self;
  final $Res Function(OpenShiftEntry) _then;

/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shift = null,Object? register = null,Object? summary = freezed,}) {
  return _then(OpenShiftEntry(
shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as RegisterShiftModel,register: null == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as CashRegisterModel,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ShiftSummaryModel?,
  ));
}
/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<$Res> get shift {
  
  return $RegisterShiftModelCopyWith<$Res>(_self.shift, (value) {
    return _then(_self.copyWith(shift: value));
  });
}/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<$Res> get register {
  
  return $CashRegisterModelCopyWith<$Res>(_self.register, (value) {
    return _then(_self.copyWith(register: value));
  });
}/// Create a copy of OpenShiftEntry
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
}
}


/// Adds pattern-matching-related methods to [OpenShiftEntry].
extension OpenShiftEntryPatterns on OpenShiftEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenShiftEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenShiftEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenShiftEntry value)  $default,){
final _that = this;
switch (_that) {
case _OpenShiftEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenShiftEntry value)?  $default,){
final _that = this;
switch (_that) {
case _OpenShiftEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RegisterShiftModel shift,  CashRegisterModel register,  ShiftSummaryModel? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenShiftEntry() when $default != null:
return $default(_that.shift,_that.register,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RegisterShiftModel shift,  CashRegisterModel register,  ShiftSummaryModel? summary)  $default,) {final _that = this;
switch (_that) {
case _OpenShiftEntry():
return $default(_that.shift,_that.register,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RegisterShiftModel shift,  CashRegisterModel register,  ShiftSummaryModel? summary)?  $default,) {final _that = this;
switch (_that) {
case _OpenShiftEntry() when $default != null:
return $default(_that.shift,_that.register,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _OpenShiftEntry implements OpenShiftEntry {
  const _OpenShiftEntry({required this.shift, required this.register, this.summary});
  

@override final  RegisterShiftModel shift;
@override final  CashRegisterModel register;
@override final  ShiftSummaryModel? summary;

/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenShiftEntryCopyWith<_OpenShiftEntry> get copyWith => __$OpenShiftEntryCopyWithImpl<_OpenShiftEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenShiftEntry&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.register, register) || other.register == register)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode {
    return Object.hash(runtimeType,shift,register,summary);
}

@override
String toString() {
    return 'OpenShiftEntry(shift: $shift, register: $register, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$OpenShiftEntryCopyWith<$Res> implements $OpenShiftEntryCopyWith<$Res> {
  factory _$OpenShiftEntryCopyWith(_OpenShiftEntry value, $Res Function(_OpenShiftEntry) _then) = __$OpenShiftEntryCopyWithImpl;
@override @useResult
$Res call({
 RegisterShiftModel shift, CashRegisterModel register, ShiftSummaryModel? summary
});


@override $RegisterShiftModelCopyWith<$Res> get shift;@override $CashRegisterModelCopyWith<$Res> get register;@override $ShiftSummaryModelCopyWith<$Res>? get summary;

}
/// @nodoc
class __$OpenShiftEntryCopyWithImpl<$Res>
    implements _$OpenShiftEntryCopyWith<$Res> {
  __$OpenShiftEntryCopyWithImpl(this._self, this._then);

  final _OpenShiftEntry _self;
  final $Res Function(_OpenShiftEntry) _then;

/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shift = null,Object? register = null,Object? summary = freezed,}) {
  return _then(_OpenShiftEntry(
shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as RegisterShiftModel,register: null == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as CashRegisterModel,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ShiftSummaryModel?,
  ));
}

/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegisterShiftModelCopyWith<$Res> get shift {
  
  return $RegisterShiftModelCopyWith<$Res>(_self.shift, (value) {
    return _then(_self.copyWith(shift: value));
  });
}/// Create a copy of OpenShiftEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashRegisterModelCopyWith<$Res> get register {
  
  return $CashRegisterModelCopyWith<$Res>(_self.register, (value) {
    return _then(_self.copyWith(register: value));
  });
}/// Create a copy of OpenShiftEntry
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
}
}

/// @nodoc
mixin _$CurrentShiftState {

 List<CashRegisterModel> get registers; List<OpenShiftEntry> get openShifts; OpenShiftEntry? get selectedShift; String? get cashierName; bool get isLoading; bool get isRefreshing; bool get accessDenied; bool get canCloseShift; String? get error;
/// Create a copy of CurrentShiftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentShiftStateCopyWith<CurrentShiftState> get copyWith => _$CurrentShiftStateCopyWithImpl<CurrentShiftState>(this as CurrentShiftState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CurrentShiftState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentShiftState&&const DeepCollectionEquality().equals(other.registers, _this.registers)&&const DeepCollectionEquality().equals(other.openShifts, _this.openShifts)&&(identical(other.selectedShift, _this.selectedShift) || other.selectedShift == _this.selectedShift)&&(identical(other.cashierName, _this.cashierName) || other.cashierName == _this.cashierName)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.accessDenied, _this.accessDenied) || other.accessDenied == _this.accessDenied)&&(identical(other.canCloseShift, _this.canCloseShift) || other.canCloseShift == _this.canCloseShift)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as CurrentShiftState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.registers),const DeepCollectionEquality().hash(_this.openShifts),_this.selectedShift,_this.cashierName,_this.isLoading,_this.isRefreshing,_this.accessDenied,_this.canCloseShift,_this.error);
}

@override
String toString() {
  final _this = this as CurrentShiftState;
  return 'CurrentShiftState(registers: ${_this.registers}, openShifts: ${_this.openShifts}, selectedShift: ${_this.selectedShift}, cashierName: ${_this.cashierName}, isLoading: ${_this.isLoading}, isRefreshing: ${_this.isRefreshing}, accessDenied: ${_this.accessDenied}, canCloseShift: ${_this.canCloseShift}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $CurrentShiftStateCopyWith<$Res>  {
  factory $CurrentShiftStateCopyWith(CurrentShiftState value, $Res Function(CurrentShiftState) _then) = _$CurrentShiftStateCopyWithImpl;
@useResult
$Res call({
 List<CashRegisterModel> registers, List<OpenShiftEntry> openShifts, OpenShiftEntry? selectedShift, String? cashierName, bool isLoading, bool isRefreshing, bool accessDenied, bool canCloseShift, String? error
});


$OpenShiftEntryCopyWith<$Res>? get selectedShift;

}
/// @nodoc
class _$CurrentShiftStateCopyWithImpl<$Res>
    implements $CurrentShiftStateCopyWith<$Res> {
  _$CurrentShiftStateCopyWithImpl(this._self, this._then);

  final CurrentShiftState _self;
  final $Res Function(CurrentShiftState) _then;

/// Create a copy of CurrentShiftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registers = null,Object? openShifts = null,Object? selectedShift = freezed,Object? cashierName = freezed,Object? isLoading = null,Object? isRefreshing = null,Object? accessDenied = null,Object? canCloseShift = null,Object? error = freezed,}) {
  return _then(CurrentShiftState(
registers: null == registers ? _self.registers : registers // ignore: cast_nullable_to_non_nullable
as List<CashRegisterModel>,openShifts: null == openShifts ? _self.openShifts : openShifts // ignore: cast_nullable_to_non_nullable
as List<OpenShiftEntry>,selectedShift: freezed == selectedShift ? _self.selectedShift : selectedShift // ignore: cast_nullable_to_non_nullable
as OpenShiftEntry?,cashierName: freezed == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,canCloseShift: null == canCloseShift ? _self.canCloseShift : canCloseShift // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CurrentShiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpenShiftEntryCopyWith<$Res>? get selectedShift {
    if (_self.selectedShift == null) {
    return null;
  }

  return $OpenShiftEntryCopyWith<$Res>(_self.selectedShift!, (value) {
    return _then(_self.copyWith(selectedShift: value));
  });
}
}


/// Adds pattern-matching-related methods to [CurrentShiftState].
extension CurrentShiftStatePatterns on CurrentShiftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentShiftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentShiftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentShiftState value)  $default,){
final _that = this;
switch (_that) {
case _CurrentShiftState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentShiftState value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentShiftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CashRegisterModel> registers,  List<OpenShiftEntry> openShifts,  OpenShiftEntry? selectedShift,  String? cashierName,  bool isLoading,  bool isRefreshing,  bool accessDenied,  bool canCloseShift,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentShiftState() when $default != null:
return $default(_that.registers,_that.openShifts,_that.selectedShift,_that.cashierName,_that.isLoading,_that.isRefreshing,_that.accessDenied,_that.canCloseShift,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CashRegisterModel> registers,  List<OpenShiftEntry> openShifts,  OpenShiftEntry? selectedShift,  String? cashierName,  bool isLoading,  bool isRefreshing,  bool accessDenied,  bool canCloseShift,  String? error)  $default,) {final _that = this;
switch (_that) {
case _CurrentShiftState():
return $default(_that.registers,_that.openShifts,_that.selectedShift,_that.cashierName,_that.isLoading,_that.isRefreshing,_that.accessDenied,_that.canCloseShift,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CashRegisterModel> registers,  List<OpenShiftEntry> openShifts,  OpenShiftEntry? selectedShift,  String? cashierName,  bool isLoading,  bool isRefreshing,  bool accessDenied,  bool canCloseShift,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _CurrentShiftState() when $default != null:
return $default(_that.registers,_that.openShifts,_that.selectedShift,_that.cashierName,_that.isLoading,_that.isRefreshing,_that.accessDenied,_that.canCloseShift,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _CurrentShiftState implements CurrentShiftState {
  const _CurrentShiftState({ List<CashRegisterModel> registers = const [],  List<OpenShiftEntry> openShifts = const [], this.selectedShift, this.cashierName, this.isLoading = false, this.isRefreshing = false, this.accessDenied = false, this.canCloseShift = false, this.error}): _registers = registers,_openShifts = openShifts;
  

 final  List<CashRegisterModel> _registers;
@override@JsonKey() List<CashRegisterModel> get registers {
  if (_registers is EqualUnmodifiableListView) return _registers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registers);
}

 final  List<OpenShiftEntry> _openShifts;
@override@JsonKey() List<OpenShiftEntry> get openShifts {
  if (_openShifts is EqualUnmodifiableListView) return _openShifts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openShifts);
}

@override final  OpenShiftEntry? selectedShift;
@override final  String? cashierName;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isRefreshing;
@override@JsonKey() final  bool accessDenied;
@override@JsonKey() final  bool canCloseShift;
@override final  String? error;

/// Create a copy of CurrentShiftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentShiftStateCopyWith<_CurrentShiftState> get copyWith => __$CurrentShiftStateCopyWithImpl<_CurrentShiftState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentShiftState&&const DeepCollectionEquality().equals(other.registers, _registers)&&const DeepCollectionEquality().equals(other.openShifts, _openShifts)&&(identical(other.selectedShift, selectedShift) || other.selectedShift == selectedShift)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.accessDenied, accessDenied) || other.accessDenied == accessDenied)&&(identical(other.canCloseShift, canCloseShift) || other.canCloseShift == canCloseShift)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_registers),const DeepCollectionEquality().hash(_openShifts),selectedShift,cashierName,isLoading,isRefreshing,accessDenied,canCloseShift,error);
}

@override
String toString() {
    return 'CurrentShiftState(registers: $registers, openShifts: $openShifts, selectedShift: $selectedShift, cashierName: $cashierName, isLoading: $isLoading, isRefreshing: $isRefreshing, accessDenied: $accessDenied, canCloseShift: $canCloseShift, error: $error)';
}


}

/// @nodoc
abstract mixin class _$CurrentShiftStateCopyWith<$Res> implements $CurrentShiftStateCopyWith<$Res> {
  factory _$CurrentShiftStateCopyWith(_CurrentShiftState value, $Res Function(_CurrentShiftState) _then) = __$CurrentShiftStateCopyWithImpl;
@override @useResult
$Res call({
 List<CashRegisterModel> registers, List<OpenShiftEntry> openShifts, OpenShiftEntry? selectedShift, String? cashierName, bool isLoading, bool isRefreshing, bool accessDenied, bool canCloseShift, String? error
});


@override $OpenShiftEntryCopyWith<$Res>? get selectedShift;

}
/// @nodoc
class __$CurrentShiftStateCopyWithImpl<$Res>
    implements _$CurrentShiftStateCopyWith<$Res> {
  __$CurrentShiftStateCopyWithImpl(this._self, this._then);

  final _CurrentShiftState _self;
  final $Res Function(_CurrentShiftState) _then;

/// Create a copy of CurrentShiftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registers = null,Object? openShifts = null,Object? selectedShift = freezed,Object? cashierName = freezed,Object? isLoading = null,Object? isRefreshing = null,Object? accessDenied = null,Object? canCloseShift = null,Object? error = freezed,}) {
  return _then(_CurrentShiftState(
registers: null == registers ? _self._registers : registers // ignore: cast_nullable_to_non_nullable
as List<CashRegisterModel>,openShifts: null == openShifts ? _self._openShifts : openShifts // ignore: cast_nullable_to_non_nullable
as List<OpenShiftEntry>,selectedShift: freezed == selectedShift ? _self.selectedShift : selectedShift // ignore: cast_nullable_to_non_nullable
as OpenShiftEntry?,cashierName: freezed == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,canCloseShift: null == canCloseShift ? _self.canCloseShift : canCloseShift // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CurrentShiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpenShiftEntryCopyWith<$Res>? get selectedShift {
    if (_self.selectedShift == null) {
    return null;
  }

  return $OpenShiftEntryCopyWith<$Res>(_self.selectedShift!, (value) {
    return _then(_self.copyWith(selectedShift: value));
  });
}
}

// dart format on
