// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShiftHistoryState {

 List<RegisterShiftModel> get shifts; List<CashRegisterModel> get registers; String? get selectedRegisterId; ShiftDatePreset get datePreset; DateTime? get customDateFrom; DateTime? get customDateTo; int get skip; int get limit; bool get hasMore; bool get isLoading; bool get isLoadingMore; bool get accessDenied; String? get error;
/// Create a copy of ShiftHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftHistoryStateCopyWith<ShiftHistoryState> get copyWith => _$ShiftHistoryStateCopyWithImpl<ShiftHistoryState>(this as ShiftHistoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShiftHistoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftHistoryState&&const DeepCollectionEquality().equals(other.shifts, _this.shifts)&&const DeepCollectionEquality().equals(other.registers, _this.registers)&&(identical(other.selectedRegisterId, _this.selectedRegisterId) || other.selectedRegisterId == _this.selectedRegisterId)&&(identical(other.datePreset, _this.datePreset) || other.datePreset == _this.datePreset)&&(identical(other.customDateFrom, _this.customDateFrom) || other.customDateFrom == _this.customDateFrom)&&(identical(other.customDateTo, _this.customDateTo) || other.customDateTo == _this.customDateTo)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.accessDenied, _this.accessDenied) || other.accessDenied == _this.accessDenied)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ShiftHistoryState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.shifts),const DeepCollectionEquality().hash(_this.registers),_this.selectedRegisterId,_this.datePreset,_this.customDateFrom,_this.customDateTo,_this.skip,_this.limit,_this.hasMore,_this.isLoading,_this.isLoadingMore,_this.accessDenied,_this.error);
}

@override
String toString() {
  final _this = this as ShiftHistoryState;
  return 'ShiftHistoryState(shifts: ${_this.shifts}, registers: ${_this.registers}, selectedRegisterId: ${_this.selectedRegisterId}, datePreset: ${_this.datePreset}, customDateFrom: ${_this.customDateFrom}, customDateTo: ${_this.customDateTo}, skip: ${_this.skip}, limit: ${_this.limit}, hasMore: ${_this.hasMore}, isLoading: ${_this.isLoading}, isLoadingMore: ${_this.isLoadingMore}, accessDenied: ${_this.accessDenied}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ShiftHistoryStateCopyWith<$Res>  {
  factory $ShiftHistoryStateCopyWith(ShiftHistoryState value, $Res Function(ShiftHistoryState) _then) = _$ShiftHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<RegisterShiftModel> shifts, List<CashRegisterModel> registers, String? selectedRegisterId, ShiftDatePreset datePreset, DateTime? customDateFrom, DateTime? customDateTo, int skip, int limit, bool hasMore, bool isLoading, bool isLoadingMore, bool accessDenied, String? error
});




}
/// @nodoc
class _$ShiftHistoryStateCopyWithImpl<$Res>
    implements $ShiftHistoryStateCopyWith<$Res> {
  _$ShiftHistoryStateCopyWithImpl(this._self, this._then);

  final ShiftHistoryState _self;
  final $Res Function(ShiftHistoryState) _then;

/// Create a copy of ShiftHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shifts = null,Object? registers = null,Object? selectedRegisterId = freezed,Object? datePreset = null,Object? customDateFrom = freezed,Object? customDateTo = freezed,Object? skip = null,Object? limit = null,Object? hasMore = null,Object? isLoading = null,Object? isLoadingMore = null,Object? accessDenied = null,Object? error = freezed,}) {
  return _then(ShiftHistoryState(
shifts: null == shifts ? _self.shifts : shifts // ignore: cast_nullable_to_non_nullable
as List<RegisterShiftModel>,registers: null == registers ? _self.registers : registers // ignore: cast_nullable_to_non_nullable
as List<CashRegisterModel>,selectedRegisterId: freezed == selectedRegisterId ? _self.selectedRegisterId : selectedRegisterId // ignore: cast_nullable_to_non_nullable
as String?,datePreset: null == datePreset ? _self.datePreset : datePreset // ignore: cast_nullable_to_non_nullable
as ShiftDatePreset,customDateFrom: freezed == customDateFrom ? _self.customDateFrom : customDateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,customDateTo: freezed == customDateTo ? _self.customDateTo : customDateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftHistoryState].
extension ShiftHistoryStatePatterns on ShiftHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _ShiftHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RegisterShiftModel> shifts,  List<CashRegisterModel> registers,  String? selectedRegisterId,  ShiftDatePreset datePreset,  DateTime? customDateFrom,  DateTime? customDateTo,  int skip,  int limit,  bool hasMore,  bool isLoading,  bool isLoadingMore,  bool accessDenied,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftHistoryState() when $default != null:
return $default(_that.shifts,_that.registers,_that.selectedRegisterId,_that.datePreset,_that.customDateFrom,_that.customDateTo,_that.skip,_that.limit,_that.hasMore,_that.isLoading,_that.isLoadingMore,_that.accessDenied,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RegisterShiftModel> shifts,  List<CashRegisterModel> registers,  String? selectedRegisterId,  ShiftDatePreset datePreset,  DateTime? customDateFrom,  DateTime? customDateTo,  int skip,  int limit,  bool hasMore,  bool isLoading,  bool isLoadingMore,  bool accessDenied,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ShiftHistoryState():
return $default(_that.shifts,_that.registers,_that.selectedRegisterId,_that.datePreset,_that.customDateFrom,_that.customDateTo,_that.skip,_that.limit,_that.hasMore,_that.isLoading,_that.isLoadingMore,_that.accessDenied,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RegisterShiftModel> shifts,  List<CashRegisterModel> registers,  String? selectedRegisterId,  ShiftDatePreset datePreset,  DateTime? customDateFrom,  DateTime? customDateTo,  int skip,  int limit,  bool hasMore,  bool isLoading,  bool isLoadingMore,  bool accessDenied,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ShiftHistoryState() when $default != null:
return $default(_that.shifts,_that.registers,_that.selectedRegisterId,_that.datePreset,_that.customDateFrom,_that.customDateTo,_that.skip,_that.limit,_that.hasMore,_that.isLoading,_that.isLoadingMore,_that.accessDenied,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ShiftHistoryState implements ShiftHistoryState {
  const _ShiftHistoryState({ List<RegisterShiftModel> shifts = const [],  List<CashRegisterModel> registers = const [], this.selectedRegisterId, this.datePreset = ShiftDatePreset.last30Days, this.customDateFrom, this.customDateTo, this.skip = 0, this.limit = 50, this.hasMore = false, this.isLoading = false, this.isLoadingMore = false, this.accessDenied = false, this.error}): _shifts = shifts,_registers = registers;
  

 final  List<RegisterShiftModel> _shifts;
@override@JsonKey() List<RegisterShiftModel> get shifts {
  if (_shifts is EqualUnmodifiableListView) return _shifts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shifts);
}

 final  List<CashRegisterModel> _registers;
@override@JsonKey() List<CashRegisterModel> get registers {
  if (_registers is EqualUnmodifiableListView) return _registers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registers);
}

@override final  String? selectedRegisterId;
@override@JsonKey() final  ShiftDatePreset datePreset;
@override final  DateTime? customDateFrom;
@override final  DateTime? customDateTo;
@override@JsonKey() final  int skip;
@override@JsonKey() final  int limit;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool accessDenied;
@override final  String? error;

/// Create a copy of ShiftHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftHistoryStateCopyWith<_ShiftHistoryState> get copyWith => __$ShiftHistoryStateCopyWithImpl<_ShiftHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftHistoryState&&const DeepCollectionEquality().equals(other.shifts, _shifts)&&const DeepCollectionEquality().equals(other.registers, _registers)&&(identical(other.selectedRegisterId, selectedRegisterId) || other.selectedRegisterId == selectedRegisterId)&&(identical(other.datePreset, datePreset) || other.datePreset == datePreset)&&(identical(other.customDateFrom, customDateFrom) || other.customDateFrom == customDateFrom)&&(identical(other.customDateTo, customDateTo) || other.customDateTo == customDateTo)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.accessDenied, accessDenied) || other.accessDenied == accessDenied)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_shifts),const DeepCollectionEquality().hash(_registers),selectedRegisterId,datePreset,customDateFrom,customDateTo,skip,limit,hasMore,isLoading,isLoadingMore,accessDenied,error);
}

@override
String toString() {
    return 'ShiftHistoryState(shifts: $shifts, registers: $registers, selectedRegisterId: $selectedRegisterId, datePreset: $datePreset, customDateFrom: $customDateFrom, customDateTo: $customDateTo, skip: $skip, limit: $limit, hasMore: $hasMore, isLoading: $isLoading, isLoadingMore: $isLoadingMore, accessDenied: $accessDenied, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ShiftHistoryStateCopyWith<$Res> implements $ShiftHistoryStateCopyWith<$Res> {
  factory _$ShiftHistoryStateCopyWith(_ShiftHistoryState value, $Res Function(_ShiftHistoryState) _then) = __$ShiftHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<RegisterShiftModel> shifts, List<CashRegisterModel> registers, String? selectedRegisterId, ShiftDatePreset datePreset, DateTime? customDateFrom, DateTime? customDateTo, int skip, int limit, bool hasMore, bool isLoading, bool isLoadingMore, bool accessDenied, String? error
});




}
/// @nodoc
class __$ShiftHistoryStateCopyWithImpl<$Res>
    implements _$ShiftHistoryStateCopyWith<$Res> {
  __$ShiftHistoryStateCopyWithImpl(this._self, this._then);

  final _ShiftHistoryState _self;
  final $Res Function(_ShiftHistoryState) _then;

/// Create a copy of ShiftHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shifts = null,Object? registers = null,Object? selectedRegisterId = freezed,Object? datePreset = null,Object? customDateFrom = freezed,Object? customDateTo = freezed,Object? skip = null,Object? limit = null,Object? hasMore = null,Object? isLoading = null,Object? isLoadingMore = null,Object? accessDenied = null,Object? error = freezed,}) {
  return _then(_ShiftHistoryState(
shifts: null == shifts ? _self._shifts : shifts // ignore: cast_nullable_to_non_nullable
as List<RegisterShiftModel>,registers: null == registers ? _self._registers : registers // ignore: cast_nullable_to_non_nullable
as List<CashRegisterModel>,selectedRegisterId: freezed == selectedRegisterId ? _self.selectedRegisterId : selectedRegisterId // ignore: cast_nullable_to_non_nullable
as String?,datePreset: null == datePreset ? _self.datePreset : datePreset // ignore: cast_nullable_to_non_nullable
as ShiftDatePreset,customDateFrom: freezed == customDateFrom ? _self.customDateFrom : customDateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,customDateTo: freezed == customDateTo ? _self.customDateTo : customDateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
