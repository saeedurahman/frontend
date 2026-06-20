// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_ledger_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LedgerDisplayRow {
  CustomerLedgerEntryModel get entry => throw _privateConstructorUsedError;
  String get runningBalance => throw _privateConstructorUsedError;

  /// Create a copy of LedgerDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerDisplayRowCopyWith<LedgerDisplayRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerDisplayRowCopyWith<$Res> {
  factory $LedgerDisplayRowCopyWith(
    LedgerDisplayRow value,
    $Res Function(LedgerDisplayRow) then,
  ) = _$LedgerDisplayRowCopyWithImpl<$Res, LedgerDisplayRow>;
  @useResult
  $Res call({CustomerLedgerEntryModel entry, String runningBalance});

  $CustomerLedgerEntryModelCopyWith<$Res> get entry;
}

/// @nodoc
class _$LedgerDisplayRowCopyWithImpl<$Res, $Val extends LedgerDisplayRow>
    implements $LedgerDisplayRowCopyWith<$Res> {
  _$LedgerDisplayRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LedgerDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? entry = null, Object? runningBalance = null}) {
    return _then(
      _value.copyWith(
            entry: null == entry
                ? _value.entry
                : entry // ignore: cast_nullable_to_non_nullable
                      as CustomerLedgerEntryModel,
            runningBalance: null == runningBalance
                ? _value.runningBalance
                : runningBalance // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of LedgerDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerLedgerEntryModelCopyWith<$Res> get entry {
    return $CustomerLedgerEntryModelCopyWith<$Res>(_value.entry, (value) {
      return _then(_value.copyWith(entry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LedgerDisplayRowImplCopyWith<$Res>
    implements $LedgerDisplayRowCopyWith<$Res> {
  factory _$$LedgerDisplayRowImplCopyWith(
    _$LedgerDisplayRowImpl value,
    $Res Function(_$LedgerDisplayRowImpl) then,
  ) = __$$LedgerDisplayRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CustomerLedgerEntryModel entry, String runningBalance});

  @override
  $CustomerLedgerEntryModelCopyWith<$Res> get entry;
}

/// @nodoc
class __$$LedgerDisplayRowImplCopyWithImpl<$Res>
    extends _$LedgerDisplayRowCopyWithImpl<$Res, _$LedgerDisplayRowImpl>
    implements _$$LedgerDisplayRowImplCopyWith<$Res> {
  __$$LedgerDisplayRowImplCopyWithImpl(
    _$LedgerDisplayRowImpl _value,
    $Res Function(_$LedgerDisplayRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LedgerDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? entry = null, Object? runningBalance = null}) {
    return _then(
      _$LedgerDisplayRowImpl(
        entry: null == entry
            ? _value.entry
            : entry // ignore: cast_nullable_to_non_nullable
                  as CustomerLedgerEntryModel,
        runningBalance: null == runningBalance
            ? _value.runningBalance
            : runningBalance // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LedgerDisplayRowImpl implements _LedgerDisplayRow {
  const _$LedgerDisplayRowImpl({
    required this.entry,
    required this.runningBalance,
  });

  @override
  final CustomerLedgerEntryModel entry;
  @override
  final String runningBalance;

  @override
  String toString() {
    return 'LedgerDisplayRow(entry: $entry, runningBalance: $runningBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerDisplayRowImpl &&
            (identical(other.entry, entry) || other.entry == entry) &&
            (identical(other.runningBalance, runningBalance) ||
                other.runningBalance == runningBalance));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entry, runningBalance);

  /// Create a copy of LedgerDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerDisplayRowImplCopyWith<_$LedgerDisplayRowImpl> get copyWith =>
      __$$LedgerDisplayRowImplCopyWithImpl<_$LedgerDisplayRowImpl>(
        this,
        _$identity,
      );
}

abstract class _LedgerDisplayRow implements LedgerDisplayRow {
  const factory _LedgerDisplayRow({
    required final CustomerLedgerEntryModel entry,
    required final String runningBalance,
  }) = _$LedgerDisplayRowImpl;

  @override
  CustomerLedgerEntryModel get entry;
  @override
  String get runningBalance;

  /// Create a copy of LedgerDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerDisplayRowImplCopyWith<_$LedgerDisplayRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CustomerLedgerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomerLedgerInitial value) initial,
    required TResult Function(CustomerLedgerLoading value) loading,
    required TResult Function(CustomerLedgerLoaded value) loaded,
    required TResult Function(CustomerLedgerError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomerLedgerInitial value)? initial,
    TResult? Function(CustomerLedgerLoading value)? loading,
    TResult? Function(CustomerLedgerLoaded value)? loaded,
    TResult? Function(CustomerLedgerError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomerLedgerInitial value)? initial,
    TResult Function(CustomerLedgerLoading value)? loading,
    TResult Function(CustomerLedgerLoaded value)? loaded,
    TResult Function(CustomerLedgerError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerLedgerStateCopyWith<$Res> {
  factory $CustomerLedgerStateCopyWith(
    CustomerLedgerState value,
    $Res Function(CustomerLedgerState) then,
  ) = _$CustomerLedgerStateCopyWithImpl<$Res, CustomerLedgerState>;
}

/// @nodoc
class _$CustomerLedgerStateCopyWithImpl<$Res, $Val extends CustomerLedgerState>
    implements $CustomerLedgerStateCopyWith<$Res> {
  _$CustomerLedgerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CustomerLedgerInitialImplCopyWith<$Res> {
  factory _$$CustomerLedgerInitialImplCopyWith(
    _$CustomerLedgerInitialImpl value,
    $Res Function(_$CustomerLedgerInitialImpl) then,
  ) = __$$CustomerLedgerInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CustomerLedgerInitialImplCopyWithImpl<$Res>
    extends _$CustomerLedgerStateCopyWithImpl<$Res, _$CustomerLedgerInitialImpl>
    implements _$$CustomerLedgerInitialImplCopyWith<$Res> {
  __$$CustomerLedgerInitialImplCopyWithImpl(
    _$CustomerLedgerInitialImpl _value,
    $Res Function(_$CustomerLedgerInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CustomerLedgerInitialImpl implements CustomerLedgerInitial {
  const _$CustomerLedgerInitialImpl();

  @override
  String toString() {
    return 'CustomerLedgerState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLedgerInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomerLedgerInitial value) initial,
    required TResult Function(CustomerLedgerLoading value) loading,
    required TResult Function(CustomerLedgerLoaded value) loaded,
    required TResult Function(CustomerLedgerError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomerLedgerInitial value)? initial,
    TResult? Function(CustomerLedgerLoading value)? loading,
    TResult? Function(CustomerLedgerLoaded value)? loaded,
    TResult? Function(CustomerLedgerError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomerLedgerInitial value)? initial,
    TResult Function(CustomerLedgerLoading value)? loading,
    TResult Function(CustomerLedgerLoaded value)? loaded,
    TResult Function(CustomerLedgerError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CustomerLedgerInitial implements CustomerLedgerState {
  const factory CustomerLedgerInitial() = _$CustomerLedgerInitialImpl;
}

/// @nodoc
abstract class _$$CustomerLedgerLoadingImplCopyWith<$Res> {
  factory _$$CustomerLedgerLoadingImplCopyWith(
    _$CustomerLedgerLoadingImpl value,
    $Res Function(_$CustomerLedgerLoadingImpl) then,
  ) = __$$CustomerLedgerLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CustomerLedgerLoadingImplCopyWithImpl<$Res>
    extends _$CustomerLedgerStateCopyWithImpl<$Res, _$CustomerLedgerLoadingImpl>
    implements _$$CustomerLedgerLoadingImplCopyWith<$Res> {
  __$$CustomerLedgerLoadingImplCopyWithImpl(
    _$CustomerLedgerLoadingImpl _value,
    $Res Function(_$CustomerLedgerLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CustomerLedgerLoadingImpl implements CustomerLedgerLoading {
  const _$CustomerLedgerLoadingImpl();

  @override
  String toString() {
    return 'CustomerLedgerState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLedgerLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomerLedgerInitial value) initial,
    required TResult Function(CustomerLedgerLoading value) loading,
    required TResult Function(CustomerLedgerLoaded value) loaded,
    required TResult Function(CustomerLedgerError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomerLedgerInitial value)? initial,
    TResult? Function(CustomerLedgerLoading value)? loading,
    TResult? Function(CustomerLedgerLoaded value)? loaded,
    TResult? Function(CustomerLedgerError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomerLedgerInitial value)? initial,
    TResult Function(CustomerLedgerLoading value)? loading,
    TResult Function(CustomerLedgerLoaded value)? loaded,
    TResult Function(CustomerLedgerError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CustomerLedgerLoading implements CustomerLedgerState {
  const factory CustomerLedgerLoading() = _$CustomerLedgerLoadingImpl;
}

/// @nodoc
abstract class _$$CustomerLedgerLoadedImplCopyWith<$Res> {
  factory _$$CustomerLedgerLoadedImplCopyWith(
    _$CustomerLedgerLoadedImpl value,
    $Res Function(_$CustomerLedgerLoadedImpl) then,
  ) = __$$CustomerLedgerLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    CustomerModel customer,
    String balance,
    List<LedgerDisplayRow> entries,
    bool isLoadingMore,
    bool hasMore,
    bool isRecordingPayment,
    String? paymentError,
    bool isCheckingPaymentShift,
    String? activePaymentShiftId,
  });

  $CustomerModelCopyWith<$Res> get customer;
}

/// @nodoc
class __$$CustomerLedgerLoadedImplCopyWithImpl<$Res>
    extends _$CustomerLedgerStateCopyWithImpl<$Res, _$CustomerLedgerLoadedImpl>
    implements _$$CustomerLedgerLoadedImplCopyWith<$Res> {
  __$$CustomerLedgerLoadedImplCopyWithImpl(
    _$CustomerLedgerLoadedImpl _value,
    $Res Function(_$CustomerLedgerLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? balance = null,
    Object? entries = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? isRecordingPayment = null,
    Object? paymentError = freezed,
    Object? isCheckingPaymentShift = null,
    Object? activePaymentShiftId = freezed,
  }) {
    return _then(
      _$CustomerLedgerLoadedImpl(
        customer: null == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as String,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<LedgerDisplayRow>,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRecordingPayment: null == isRecordingPayment
            ? _value.isRecordingPayment
            : isRecordingPayment // ignore: cast_nullable_to_non_nullable
                  as bool,
        paymentError: freezed == paymentError
            ? _value.paymentError
            : paymentError // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCheckingPaymentShift: null == isCheckingPaymentShift
            ? _value.isCheckingPaymentShift
            : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        activePaymentShiftId: freezed == activePaymentShiftId
            ? _value.activePaymentShiftId
            : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res> get customer {
    return $CustomerModelCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value));
    });
  }
}

/// @nodoc

class _$CustomerLedgerLoadedImpl implements CustomerLedgerLoaded {
  const _$CustomerLedgerLoadedImpl({
    required this.customer,
    required this.balance,
    required final List<LedgerDisplayRow> entries,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.isRecordingPayment = false,
    this.paymentError,
    this.isCheckingPaymentShift = false,
    this.activePaymentShiftId,
  }) : _entries = entries;

  @override
  final CustomerModel customer;
  @override
  final String balance;
  final List<LedgerDisplayRow> _entries;
  @override
  List<LedgerDisplayRow> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isRecordingPayment;
  @override
  final String? paymentError;
  @override
  @JsonKey()
  final bool isCheckingPaymentShift;
  @override
  final String? activePaymentShiftId;

  @override
  String toString() {
    return 'CustomerLedgerState.loaded(customer: $customer, balance: $balance, entries: $entries, isLoadingMore: $isLoadingMore, hasMore: $hasMore, isRecordingPayment: $isRecordingPayment, paymentError: $paymentError, isCheckingPaymentShift: $isCheckingPaymentShift, activePaymentShiftId: $activePaymentShiftId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLedgerLoadedImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isRecordingPayment, isRecordingPayment) ||
                other.isRecordingPayment == isRecordingPayment) &&
            (identical(other.paymentError, paymentError) ||
                other.paymentError == paymentError) &&
            (identical(other.isCheckingPaymentShift, isCheckingPaymentShift) ||
                other.isCheckingPaymentShift == isCheckingPaymentShift) &&
            (identical(other.activePaymentShiftId, activePaymentShiftId) ||
                other.activePaymentShiftId == activePaymentShiftId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    customer,
    balance,
    const DeepCollectionEquality().hash(_entries),
    isLoadingMore,
    hasMore,
    isRecordingPayment,
    paymentError,
    isCheckingPaymentShift,
    activePaymentShiftId,
  );

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerLedgerLoadedImplCopyWith<_$CustomerLedgerLoadedImpl>
  get copyWith =>
      __$$CustomerLedgerLoadedImplCopyWithImpl<_$CustomerLedgerLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
      customer,
      balance,
      entries,
      isLoadingMore,
      hasMore,
      isRecordingPayment,
      paymentError,
      isCheckingPaymentShift,
      activePaymentShiftId,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      customer,
      balance,
      entries,
      isLoadingMore,
      hasMore,
      isRecordingPayment,
      paymentError,
      isCheckingPaymentShift,
      activePaymentShiftId,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        customer,
        balance,
        entries,
        isLoadingMore,
        hasMore,
        isRecordingPayment,
        paymentError,
        isCheckingPaymentShift,
        activePaymentShiftId,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomerLedgerInitial value) initial,
    required TResult Function(CustomerLedgerLoading value) loading,
    required TResult Function(CustomerLedgerLoaded value) loaded,
    required TResult Function(CustomerLedgerError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomerLedgerInitial value)? initial,
    TResult? Function(CustomerLedgerLoading value)? loading,
    TResult? Function(CustomerLedgerLoaded value)? loaded,
    TResult? Function(CustomerLedgerError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomerLedgerInitial value)? initial,
    TResult Function(CustomerLedgerLoading value)? loading,
    TResult Function(CustomerLedgerLoaded value)? loaded,
    TResult Function(CustomerLedgerError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CustomerLedgerLoaded implements CustomerLedgerState {
  const factory CustomerLedgerLoaded({
    required final CustomerModel customer,
    required final String balance,
    required final List<LedgerDisplayRow> entries,
    final bool isLoadingMore,
    final bool hasMore,
    final bool isRecordingPayment,
    final String? paymentError,
    final bool isCheckingPaymentShift,
    final String? activePaymentShiftId,
  }) = _$CustomerLedgerLoadedImpl;

  CustomerModel get customer;
  String get balance;
  List<LedgerDisplayRow> get entries;
  bool get isLoadingMore;
  bool get hasMore;
  bool get isRecordingPayment;
  String? get paymentError;
  bool get isCheckingPaymentShift;
  String? get activePaymentShiftId;

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerLedgerLoadedImplCopyWith<_$CustomerLedgerLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CustomerLedgerErrorImplCopyWith<$Res> {
  factory _$$CustomerLedgerErrorImplCopyWith(
    _$CustomerLedgerErrorImpl value,
    $Res Function(_$CustomerLedgerErrorImpl) then,
  ) = __$$CustomerLedgerErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CustomerLedgerErrorImplCopyWithImpl<$Res>
    extends _$CustomerLedgerStateCopyWithImpl<$Res, _$CustomerLedgerErrorImpl>
    implements _$$CustomerLedgerErrorImplCopyWith<$Res> {
  __$$CustomerLedgerErrorImplCopyWithImpl(
    _$CustomerLedgerErrorImpl _value,
    $Res Function(_$CustomerLedgerErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$CustomerLedgerErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CustomerLedgerErrorImpl implements CustomerLedgerError {
  const _$CustomerLedgerErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CustomerLedgerState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLedgerErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerLedgerErrorImplCopyWith<_$CustomerLedgerErrorImpl> get copyWith =>
      __$$CustomerLedgerErrorImplCopyWithImpl<_$CustomerLedgerErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      CustomerModel customer,
      String balance,
      List<LedgerDisplayRow> entries,
      bool isLoadingMore,
      bool hasMore,
      bool isRecordingPayment,
      String? paymentError,
      bool isCheckingPaymentShift,
      String? activePaymentShiftId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomerLedgerInitial value) initial,
    required TResult Function(CustomerLedgerLoading value) loading,
    required TResult Function(CustomerLedgerLoaded value) loaded,
    required TResult Function(CustomerLedgerError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomerLedgerInitial value)? initial,
    TResult? Function(CustomerLedgerLoading value)? loading,
    TResult? Function(CustomerLedgerLoaded value)? loaded,
    TResult? Function(CustomerLedgerError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomerLedgerInitial value)? initial,
    TResult Function(CustomerLedgerLoading value)? loading,
    TResult Function(CustomerLedgerLoaded value)? loaded,
    TResult Function(CustomerLedgerError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CustomerLedgerError implements CustomerLedgerState {
  const factory CustomerLedgerError(final String message) =
      _$CustomerLedgerErrorImpl;

  String get message;

  /// Create a copy of CustomerLedgerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerLedgerErrorImplCopyWith<_$CustomerLedgerErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
