// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ShiftHistoryState {
  List<RegisterShiftModel> get shifts => throw _privateConstructorUsedError;
  List<CashRegisterModel> get registers => throw _privateConstructorUsedError;
  String? get selectedRegisterId => throw _privateConstructorUsedError;
  ShiftDatePreset get datePreset => throw _privateConstructorUsedError;
  DateTime? get customDateFrom => throw _privateConstructorUsedError;
  DateTime? get customDateTo => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ShiftHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftHistoryStateCopyWith<ShiftHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftHistoryStateCopyWith<$Res> {
  factory $ShiftHistoryStateCopyWith(
    ShiftHistoryState value,
    $Res Function(ShiftHistoryState) then,
  ) = _$ShiftHistoryStateCopyWithImpl<$Res, ShiftHistoryState>;
  @useResult
  $Res call({
    List<RegisterShiftModel> shifts,
    List<CashRegisterModel> registers,
    String? selectedRegisterId,
    ShiftDatePreset datePreset,
    DateTime? customDateFrom,
    DateTime? customDateTo,
    int skip,
    int limit,
    bool hasMore,
    bool isLoading,
    bool isLoadingMore,
    String? error,
  });
}

/// @nodoc
class _$ShiftHistoryStateCopyWithImpl<$Res, $Val extends ShiftHistoryState>
    implements $ShiftHistoryStateCopyWith<$Res> {
  _$ShiftHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shifts = null,
    Object? registers = null,
    Object? selectedRegisterId = freezed,
    Object? datePreset = null,
    Object? customDateFrom = freezed,
    Object? customDateTo = freezed,
    Object? skip = null,
    Object? limit = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            shifts: null == shifts
                ? _value.shifts
                : shifts // ignore: cast_nullable_to_non_nullable
                      as List<RegisterShiftModel>,
            registers: null == registers
                ? _value.registers
                : registers // ignore: cast_nullable_to_non_nullable
                      as List<CashRegisterModel>,
            selectedRegisterId: freezed == selectedRegisterId
                ? _value.selectedRegisterId
                : selectedRegisterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            datePreset: null == datePreset
                ? _value.datePreset
                : datePreset // ignore: cast_nullable_to_non_nullable
                      as ShiftDatePreset,
            customDateFrom: freezed == customDateFrom
                ? _value.customDateFrom
                : customDateFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            customDateTo: freezed == customDateTo
                ? _value.customDateTo
                : customDateTo // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            skip: null == skip
                ? _value.skip
                : skip // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShiftHistoryStateImplCopyWith<$Res>
    implements $ShiftHistoryStateCopyWith<$Res> {
  factory _$$ShiftHistoryStateImplCopyWith(
    _$ShiftHistoryStateImpl value,
    $Res Function(_$ShiftHistoryStateImpl) then,
  ) = __$$ShiftHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<RegisterShiftModel> shifts,
    List<CashRegisterModel> registers,
    String? selectedRegisterId,
    ShiftDatePreset datePreset,
    DateTime? customDateFrom,
    DateTime? customDateTo,
    int skip,
    int limit,
    bool hasMore,
    bool isLoading,
    bool isLoadingMore,
    String? error,
  });
}

/// @nodoc
class __$$ShiftHistoryStateImplCopyWithImpl<$Res>
    extends _$ShiftHistoryStateCopyWithImpl<$Res, _$ShiftHistoryStateImpl>
    implements _$$ShiftHistoryStateImplCopyWith<$Res> {
  __$$ShiftHistoryStateImplCopyWithImpl(
    _$ShiftHistoryStateImpl _value,
    $Res Function(_$ShiftHistoryStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShiftHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shifts = null,
    Object? registers = null,
    Object? selectedRegisterId = freezed,
    Object? datePreset = null,
    Object? customDateFrom = freezed,
    Object? customDateTo = freezed,
    Object? skip = null,
    Object? limit = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
  }) {
    return _then(
      _$ShiftHistoryStateImpl(
        shifts: null == shifts
            ? _value._shifts
            : shifts // ignore: cast_nullable_to_non_nullable
                  as List<RegisterShiftModel>,
        registers: null == registers
            ? _value._registers
            : registers // ignore: cast_nullable_to_non_nullable
                  as List<CashRegisterModel>,
        selectedRegisterId: freezed == selectedRegisterId
            ? _value.selectedRegisterId
            : selectedRegisterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        datePreset: null == datePreset
            ? _value.datePreset
            : datePreset // ignore: cast_nullable_to_non_nullable
                  as ShiftDatePreset,
        customDateFrom: freezed == customDateFrom
            ? _value.customDateFrom
            : customDateFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        customDateTo: freezed == customDateTo
            ? _value.customDateTo
            : customDateTo // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ShiftHistoryStateImpl implements _ShiftHistoryState {
  const _$ShiftHistoryStateImpl({
    final List<RegisterShiftModel> shifts = const [],
    final List<CashRegisterModel> registers = const [],
    this.selectedRegisterId,
    this.datePreset = ShiftDatePreset.last30Days,
    this.customDateFrom,
    this.customDateTo,
    this.skip = 0,
    this.limit = 50,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  }) : _shifts = shifts,
       _registers = registers;

  final List<RegisterShiftModel> _shifts;
  @override
  @JsonKey()
  List<RegisterShiftModel> get shifts {
    if (_shifts is EqualUnmodifiableListView) return _shifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shifts);
  }

  final List<CashRegisterModel> _registers;
  @override
  @JsonKey()
  List<CashRegisterModel> get registers {
    if (_registers is EqualUnmodifiableListView) return _registers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_registers);
  }

  @override
  final String? selectedRegisterId;
  @override
  @JsonKey()
  final ShiftDatePreset datePreset;
  @override
  final DateTime? customDateFrom;
  @override
  final DateTime? customDateTo;
  @override
  @JsonKey()
  final int skip;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  final String? error;

  @override
  String toString() {
    return 'ShiftHistoryState(shifts: $shifts, registers: $registers, selectedRegisterId: $selectedRegisterId, datePreset: $datePreset, customDateFrom: $customDateFrom, customDateTo: $customDateTo, skip: $skip, limit: $limit, hasMore: $hasMore, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftHistoryStateImpl &&
            const DeepCollectionEquality().equals(other._shifts, _shifts) &&
            const DeepCollectionEquality().equals(
              other._registers,
              _registers,
            ) &&
            (identical(other.selectedRegisterId, selectedRegisterId) ||
                other.selectedRegisterId == selectedRegisterId) &&
            (identical(other.datePreset, datePreset) ||
                other.datePreset == datePreset) &&
            (identical(other.customDateFrom, customDateFrom) ||
                other.customDateFrom == customDateFrom) &&
            (identical(other.customDateTo, customDateTo) ||
                other.customDateTo == customDateTo) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_shifts),
    const DeepCollectionEquality().hash(_registers),
    selectedRegisterId,
    datePreset,
    customDateFrom,
    customDateTo,
    skip,
    limit,
    hasMore,
    isLoading,
    isLoadingMore,
    error,
  );

  /// Create a copy of ShiftHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftHistoryStateImplCopyWith<_$ShiftHistoryStateImpl> get copyWith =>
      __$$ShiftHistoryStateImplCopyWithImpl<_$ShiftHistoryStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ShiftHistoryState implements ShiftHistoryState {
  const factory _ShiftHistoryState({
    final List<RegisterShiftModel> shifts,
    final List<CashRegisterModel> registers,
    final String? selectedRegisterId,
    final ShiftDatePreset datePreset,
    final DateTime? customDateFrom,
    final DateTime? customDateTo,
    final int skip,
    final int limit,
    final bool hasMore,
    final bool isLoading,
    final bool isLoadingMore,
    final String? error,
  }) = _$ShiftHistoryStateImpl;

  @override
  List<RegisterShiftModel> get shifts;
  @override
  List<CashRegisterModel> get registers;
  @override
  String? get selectedRegisterId;
  @override
  ShiftDatePreset get datePreset;
  @override
  DateTime? get customDateFrom;
  @override
  DateTime? get customDateTo;
  @override
  int get skip;
  @override
  int get limit;
  @override
  bool get hasMore;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  String? get error;

  /// Create a copy of ShiftHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftHistoryStateImplCopyWith<_$ShiftHistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
