// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_shift_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OpenShiftEntry {
  RegisterShiftModel get shift => throw _privateConstructorUsedError;
  CashRegisterModel get register => throw _privateConstructorUsedError;
  ShiftSummaryModel? get summary => throw _privateConstructorUsedError;

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenShiftEntryCopyWith<OpenShiftEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenShiftEntryCopyWith<$Res> {
  factory $OpenShiftEntryCopyWith(
    OpenShiftEntry value,
    $Res Function(OpenShiftEntry) then,
  ) = _$OpenShiftEntryCopyWithImpl<$Res, OpenShiftEntry>;
  @useResult
  $Res call({
    RegisterShiftModel shift,
    CashRegisterModel register,
    ShiftSummaryModel? summary,
  });

  $RegisterShiftModelCopyWith<$Res> get shift;
  $CashRegisterModelCopyWith<$Res> get register;
  $ShiftSummaryModelCopyWith<$Res>? get summary;
}

/// @nodoc
class _$OpenShiftEntryCopyWithImpl<$Res, $Val extends OpenShiftEntry>
    implements $OpenShiftEntryCopyWith<$Res> {
  _$OpenShiftEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = null,
    Object? register = null,
    Object? summary = freezed,
  }) {
    return _then(
      _value.copyWith(
            shift: null == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as RegisterShiftModel,
            register: null == register
                ? _value.register
                : register // ignore: cast_nullable_to_non_nullable
                      as CashRegisterModel,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as ShiftSummaryModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterShiftModelCopyWith<$Res> get shift {
    return $RegisterShiftModelCopyWith<$Res>(_value.shift, (value) {
      return _then(_value.copyWith(shift: value) as $Val);
    });
  }

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashRegisterModelCopyWith<$Res> get register {
    return $CashRegisterModelCopyWith<$Res>(_value.register, (value) {
      return _then(_value.copyWith(register: value) as $Val);
    });
  }

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftSummaryModelCopyWith<$Res>? get summary {
    if (_value.summary == null) {
      return null;
    }

    return $ShiftSummaryModelCopyWith<$Res>(_value.summary!, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenShiftEntryImplCopyWith<$Res>
    implements $OpenShiftEntryCopyWith<$Res> {
  factory _$$OpenShiftEntryImplCopyWith(
    _$OpenShiftEntryImpl value,
    $Res Function(_$OpenShiftEntryImpl) then,
  ) = __$$OpenShiftEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RegisterShiftModel shift,
    CashRegisterModel register,
    ShiftSummaryModel? summary,
  });

  @override
  $RegisterShiftModelCopyWith<$Res> get shift;
  @override
  $CashRegisterModelCopyWith<$Res> get register;
  @override
  $ShiftSummaryModelCopyWith<$Res>? get summary;
}

/// @nodoc
class __$$OpenShiftEntryImplCopyWithImpl<$Res>
    extends _$OpenShiftEntryCopyWithImpl<$Res, _$OpenShiftEntryImpl>
    implements _$$OpenShiftEntryImplCopyWith<$Res> {
  __$$OpenShiftEntryImplCopyWithImpl(
    _$OpenShiftEntryImpl _value,
    $Res Function(_$OpenShiftEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = null,
    Object? register = null,
    Object? summary = freezed,
  }) {
    return _then(
      _$OpenShiftEntryImpl(
        shift: null == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as RegisterShiftModel,
        register: null == register
            ? _value.register
            : register // ignore: cast_nullable_to_non_nullable
                  as CashRegisterModel,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as ShiftSummaryModel?,
      ),
    );
  }
}

/// @nodoc

class _$OpenShiftEntryImpl implements _OpenShiftEntry {
  const _$OpenShiftEntryImpl({
    required this.shift,
    required this.register,
    this.summary,
  });

  @override
  final RegisterShiftModel shift;
  @override
  final CashRegisterModel register;
  @override
  final ShiftSummaryModel? summary;

  @override
  String toString() {
    return 'OpenShiftEntry(shift: $shift, register: $register, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenShiftEntryImpl &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.register, register) ||
                other.register == register) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shift, register, summary);

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenShiftEntryImplCopyWith<_$OpenShiftEntryImpl> get copyWith =>
      __$$OpenShiftEntryImplCopyWithImpl<_$OpenShiftEntryImpl>(
        this,
        _$identity,
      );
}

abstract class _OpenShiftEntry implements OpenShiftEntry {
  const factory _OpenShiftEntry({
    required final RegisterShiftModel shift,
    required final CashRegisterModel register,
    final ShiftSummaryModel? summary,
  }) = _$OpenShiftEntryImpl;

  @override
  RegisterShiftModel get shift;
  @override
  CashRegisterModel get register;
  @override
  ShiftSummaryModel? get summary;

  /// Create a copy of OpenShiftEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenShiftEntryImplCopyWith<_$OpenShiftEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CurrentShiftState {
  List<CashRegisterModel> get registers => throw _privateConstructorUsedError;
  List<OpenShiftEntry> get openShifts => throw _privateConstructorUsedError;
  OpenShiftEntry? get selectedShift => throw _privateConstructorUsedError;
  String? get cashierName => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  bool get accessDenied => throw _privateConstructorUsedError;
  bool get canCloseShift => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentShiftStateCopyWith<CurrentShiftState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentShiftStateCopyWith<$Res> {
  factory $CurrentShiftStateCopyWith(
    CurrentShiftState value,
    $Res Function(CurrentShiftState) then,
  ) = _$CurrentShiftStateCopyWithImpl<$Res, CurrentShiftState>;
  @useResult
  $Res call({
    List<CashRegisterModel> registers,
    List<OpenShiftEntry> openShifts,
    OpenShiftEntry? selectedShift,
    String? cashierName,
    bool isLoading,
    bool isRefreshing,
    bool accessDenied,
    bool canCloseShift,
    String? error,
  });

  $OpenShiftEntryCopyWith<$Res>? get selectedShift;
}

/// @nodoc
class _$CurrentShiftStateCopyWithImpl<$Res, $Val extends CurrentShiftState>
    implements $CurrentShiftStateCopyWith<$Res> {
  _$CurrentShiftStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registers = null,
    Object? openShifts = null,
    Object? selectedShift = freezed,
    Object? cashierName = freezed,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? accessDenied = null,
    Object? canCloseShift = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            registers: null == registers
                ? _value.registers
                : registers // ignore: cast_nullable_to_non_nullable
                      as List<CashRegisterModel>,
            openShifts: null == openShifts
                ? _value.openShifts
                : openShifts // ignore: cast_nullable_to_non_nullable
                      as List<OpenShiftEntry>,
            selectedShift: freezed == selectedShift
                ? _value.selectedShift
                : selectedShift // ignore: cast_nullable_to_non_nullable
                      as OpenShiftEntry?,
            cashierName: freezed == cashierName
                ? _value.cashierName
                : cashierName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRefreshing: null == isRefreshing
                ? _value.isRefreshing
                : isRefreshing // ignore: cast_nullable_to_non_nullable
                      as bool,
            accessDenied: null == accessDenied
                ? _value.accessDenied
                : accessDenied // ignore: cast_nullable_to_non_nullable
                      as bool,
            canCloseShift: null == canCloseShift
                ? _value.canCloseShift
                : canCloseShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenShiftEntryCopyWith<$Res>? get selectedShift {
    if (_value.selectedShift == null) {
      return null;
    }

    return $OpenShiftEntryCopyWith<$Res>(_value.selectedShift!, (value) {
      return _then(_value.copyWith(selectedShift: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CurrentShiftStateImplCopyWith<$Res>
    implements $CurrentShiftStateCopyWith<$Res> {
  factory _$$CurrentShiftStateImplCopyWith(
    _$CurrentShiftStateImpl value,
    $Res Function(_$CurrentShiftStateImpl) then,
  ) = __$$CurrentShiftStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CashRegisterModel> registers,
    List<OpenShiftEntry> openShifts,
    OpenShiftEntry? selectedShift,
    String? cashierName,
    bool isLoading,
    bool isRefreshing,
    bool accessDenied,
    bool canCloseShift,
    String? error,
  });

  @override
  $OpenShiftEntryCopyWith<$Res>? get selectedShift;
}

/// @nodoc
class __$$CurrentShiftStateImplCopyWithImpl<$Res>
    extends _$CurrentShiftStateCopyWithImpl<$Res, _$CurrentShiftStateImpl>
    implements _$$CurrentShiftStateImplCopyWith<$Res> {
  __$$CurrentShiftStateImplCopyWithImpl(
    _$CurrentShiftStateImpl _value,
    $Res Function(_$CurrentShiftStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registers = null,
    Object? openShifts = null,
    Object? selectedShift = freezed,
    Object? cashierName = freezed,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? accessDenied = null,
    Object? canCloseShift = null,
    Object? error = freezed,
  }) {
    return _then(
      _$CurrentShiftStateImpl(
        registers: null == registers
            ? _value._registers
            : registers // ignore: cast_nullable_to_non_nullable
                  as List<CashRegisterModel>,
        openShifts: null == openShifts
            ? _value._openShifts
            : openShifts // ignore: cast_nullable_to_non_nullable
                  as List<OpenShiftEntry>,
        selectedShift: freezed == selectedShift
            ? _value.selectedShift
            : selectedShift // ignore: cast_nullable_to_non_nullable
                  as OpenShiftEntry?,
        cashierName: freezed == cashierName
            ? _value.cashierName
            : cashierName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                  as bool,
        accessDenied: null == accessDenied
            ? _value.accessDenied
            : accessDenied // ignore: cast_nullable_to_non_nullable
                  as bool,
        canCloseShift: null == canCloseShift
            ? _value.canCloseShift
            : canCloseShift // ignore: cast_nullable_to_non_nullable
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

class _$CurrentShiftStateImpl implements _CurrentShiftState {
  const _$CurrentShiftStateImpl({
    final List<CashRegisterModel> registers = const [],
    final List<OpenShiftEntry> openShifts = const [],
    this.selectedShift,
    this.cashierName,
    this.isLoading = false,
    this.isRefreshing = false,
    this.accessDenied = false,
    this.canCloseShift = false,
    this.error,
  }) : _registers = registers,
       _openShifts = openShifts;

  final List<CashRegisterModel> _registers;
  @override
  @JsonKey()
  List<CashRegisterModel> get registers {
    if (_registers is EqualUnmodifiableListView) return _registers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_registers);
  }

  final List<OpenShiftEntry> _openShifts;
  @override
  @JsonKey()
  List<OpenShiftEntry> get openShifts {
    if (_openShifts is EqualUnmodifiableListView) return _openShifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_openShifts);
  }

  @override
  final OpenShiftEntry? selectedShift;
  @override
  final String? cashierName;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final bool accessDenied;
  @override
  @JsonKey()
  final bool canCloseShift;
  @override
  final String? error;

  @override
  String toString() {
    return 'CurrentShiftState(registers: $registers, openShifts: $openShifts, selectedShift: $selectedShift, cashierName: $cashierName, isLoading: $isLoading, isRefreshing: $isRefreshing, accessDenied: $accessDenied, canCloseShift: $canCloseShift, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentShiftStateImpl &&
            const DeepCollectionEquality().equals(
              other._registers,
              _registers,
            ) &&
            const DeepCollectionEquality().equals(
              other._openShifts,
              _openShifts,
            ) &&
            (identical(other.selectedShift, selectedShift) ||
                other.selectedShift == selectedShift) &&
            (identical(other.cashierName, cashierName) ||
                other.cashierName == cashierName) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.accessDenied, accessDenied) ||
                other.accessDenied == accessDenied) &&
            (identical(other.canCloseShift, canCloseShift) ||
                other.canCloseShift == canCloseShift) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_registers),
    const DeepCollectionEquality().hash(_openShifts),
    selectedShift,
    cashierName,
    isLoading,
    isRefreshing,
    accessDenied,
    canCloseShift,
    error,
  );

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentShiftStateImplCopyWith<_$CurrentShiftStateImpl> get copyWith =>
      __$$CurrentShiftStateImplCopyWithImpl<_$CurrentShiftStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CurrentShiftState implements CurrentShiftState {
  const factory _CurrentShiftState({
    final List<CashRegisterModel> registers,
    final List<OpenShiftEntry> openShifts,
    final OpenShiftEntry? selectedShift,
    final String? cashierName,
    final bool isLoading,
    final bool isRefreshing,
    final bool accessDenied,
    final bool canCloseShift,
    final String? error,
  }) = _$CurrentShiftStateImpl;

  @override
  List<CashRegisterModel> get registers;
  @override
  List<OpenShiftEntry> get openShifts;
  @override
  OpenShiftEntry? get selectedShift;
  @override
  String? get cashierName;
  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  bool get accessDenied;
  @override
  bool get canCloseShift;
  @override
  String? get error;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentShiftStateImplCopyWith<_$CurrentShiftStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
