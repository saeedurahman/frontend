// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ShiftDetailState {
  RegisterShiftModel? get shift => throw _privateConstructorUsedError;
  ShiftSummaryModel? get summary => throw _privateConstructorUsedError;
  CashRegisterModel? get register => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftDetailStateCopyWith<ShiftDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftDetailStateCopyWith<$Res> {
  factory $ShiftDetailStateCopyWith(
    ShiftDetailState value,
    $Res Function(ShiftDetailState) then,
  ) = _$ShiftDetailStateCopyWithImpl<$Res, ShiftDetailState>;
  @useResult
  $Res call({
    RegisterShiftModel? shift,
    ShiftSummaryModel? summary,
    CashRegisterModel? register,
    bool isLoading,
    String? error,
  });

  $RegisterShiftModelCopyWith<$Res>? get shift;
  $ShiftSummaryModelCopyWith<$Res>? get summary;
  $CashRegisterModelCopyWith<$Res>? get register;
}

/// @nodoc
class _$ShiftDetailStateCopyWithImpl<$Res, $Val extends ShiftDetailState>
    implements $ShiftDetailStateCopyWith<$Res> {
  _$ShiftDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = freezed,
    Object? summary = freezed,
    Object? register = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as RegisterShiftModel?,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as ShiftSummaryModel?,
            register: freezed == register
                ? _value.register
                : register // ignore: cast_nullable_to_non_nullable
                      as CashRegisterModel?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterShiftModelCopyWith<$Res>? get shift {
    if (_value.shift == null) {
      return null;
    }

    return $RegisterShiftModelCopyWith<$Res>(_value.shift!, (value) {
      return _then(_value.copyWith(shift: value) as $Val);
    });
  }

  /// Create a copy of ShiftDetailState
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

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashRegisterModelCopyWith<$Res>? get register {
    if (_value.register == null) {
      return null;
    }

    return $CashRegisterModelCopyWith<$Res>(_value.register!, (value) {
      return _then(_value.copyWith(register: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftDetailStateImplCopyWith<$Res>
    implements $ShiftDetailStateCopyWith<$Res> {
  factory _$$ShiftDetailStateImplCopyWith(
    _$ShiftDetailStateImpl value,
    $Res Function(_$ShiftDetailStateImpl) then,
  ) = __$$ShiftDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RegisterShiftModel? shift,
    ShiftSummaryModel? summary,
    CashRegisterModel? register,
    bool isLoading,
    String? error,
  });

  @override
  $RegisterShiftModelCopyWith<$Res>? get shift;
  @override
  $ShiftSummaryModelCopyWith<$Res>? get summary;
  @override
  $CashRegisterModelCopyWith<$Res>? get register;
}

/// @nodoc
class __$$ShiftDetailStateImplCopyWithImpl<$Res>
    extends _$ShiftDetailStateCopyWithImpl<$Res, _$ShiftDetailStateImpl>
    implements _$$ShiftDetailStateImplCopyWith<$Res> {
  __$$ShiftDetailStateImplCopyWithImpl(
    _$ShiftDetailStateImpl _value,
    $Res Function(_$ShiftDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = freezed,
    Object? summary = freezed,
    Object? register = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$ShiftDetailStateImpl(
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as RegisterShiftModel?,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as ShiftSummaryModel?,
        register: freezed == register
            ? _value.register
            : register // ignore: cast_nullable_to_non_nullable
                  as CashRegisterModel?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
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

class _$ShiftDetailStateImpl implements _ShiftDetailState {
  const _$ShiftDetailStateImpl({
    this.shift,
    this.summary,
    this.register,
    this.isLoading = false,
    this.error,
  });

  @override
  final RegisterShiftModel? shift;
  @override
  final ShiftSummaryModel? summary;
  @override
  final CashRegisterModel? register;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ShiftDetailState(shift: $shift, summary: $summary, register: $register, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftDetailStateImpl &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.register, register) ||
                other.register == register) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, shift, summary, register, isLoading, error);

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftDetailStateImplCopyWith<_$ShiftDetailStateImpl> get copyWith =>
      __$$ShiftDetailStateImplCopyWithImpl<_$ShiftDetailStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ShiftDetailState implements ShiftDetailState {
  const factory _ShiftDetailState({
    final RegisterShiftModel? shift,
    final ShiftSummaryModel? summary,
    final CashRegisterModel? register,
    final bool isLoading,
    final String? error,
  }) = _$ShiftDetailStateImpl;

  @override
  RegisterShiftModel? get shift;
  @override
  ShiftSummaryModel? get summary;
  @override
  CashRegisterModel? get register;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of ShiftDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftDetailStateImplCopyWith<_$ShiftDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
