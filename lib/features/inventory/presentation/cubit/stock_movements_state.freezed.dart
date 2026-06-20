// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movements_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StockMovementRow {
  StockMovementModel get movement => throw _privateConstructorUsedError;
  double get runningBalance => throw _privateConstructorUsedError;

  /// Create a copy of StockMovementRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMovementRowCopyWith<StockMovementRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMovementRowCopyWith<$Res> {
  factory $StockMovementRowCopyWith(
    StockMovementRow value,
    $Res Function(StockMovementRow) then,
  ) = _$StockMovementRowCopyWithImpl<$Res, StockMovementRow>;
  @useResult
  $Res call({StockMovementModel movement, double runningBalance});

  $StockMovementModelCopyWith<$Res> get movement;
}

/// @nodoc
class _$StockMovementRowCopyWithImpl<$Res, $Val extends StockMovementRow>
    implements $StockMovementRowCopyWith<$Res> {
  _$StockMovementRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMovementRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? movement = null, Object? runningBalance = null}) {
    return _then(
      _value.copyWith(
            movement: null == movement
                ? _value.movement
                : movement // ignore: cast_nullable_to_non_nullable
                      as StockMovementModel,
            runningBalance: null == runningBalance
                ? _value.runningBalance
                : runningBalance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of StockMovementRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockMovementModelCopyWith<$Res> get movement {
    return $StockMovementModelCopyWith<$Res>(_value.movement, (value) {
      return _then(_value.copyWith(movement: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockMovementRowImplCopyWith<$Res>
    implements $StockMovementRowCopyWith<$Res> {
  factory _$$StockMovementRowImplCopyWith(
    _$StockMovementRowImpl value,
    $Res Function(_$StockMovementRowImpl) then,
  ) = __$$StockMovementRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({StockMovementModel movement, double runningBalance});

  @override
  $StockMovementModelCopyWith<$Res> get movement;
}

/// @nodoc
class __$$StockMovementRowImplCopyWithImpl<$Res>
    extends _$StockMovementRowCopyWithImpl<$Res, _$StockMovementRowImpl>
    implements _$$StockMovementRowImplCopyWith<$Res> {
  __$$StockMovementRowImplCopyWithImpl(
    _$StockMovementRowImpl _value,
    $Res Function(_$StockMovementRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? movement = null, Object? runningBalance = null}) {
    return _then(
      _$StockMovementRowImpl(
        movement: null == movement
            ? _value.movement
            : movement // ignore: cast_nullable_to_non_nullable
                  as StockMovementModel,
        runningBalance: null == runningBalance
            ? _value.runningBalance
            : runningBalance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$StockMovementRowImpl implements _StockMovementRow {
  const _$StockMovementRowImpl({
    required this.movement,
    required this.runningBalance,
  });

  @override
  final StockMovementModel movement;
  @override
  final double runningBalance;

  @override
  String toString() {
    return 'StockMovementRow(movement: $movement, runningBalance: $runningBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementRowImpl &&
            (identical(other.movement, movement) ||
                other.movement == movement) &&
            (identical(other.runningBalance, runningBalance) ||
                other.runningBalance == runningBalance));
  }

  @override
  int get hashCode => Object.hash(runtimeType, movement, runningBalance);

  /// Create a copy of StockMovementRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementRowImplCopyWith<_$StockMovementRowImpl> get copyWith =>
      __$$StockMovementRowImplCopyWithImpl<_$StockMovementRowImpl>(
        this,
        _$identity,
      );
}

abstract class _StockMovementRow implements StockMovementRow {
  const factory _StockMovementRow({
    required final StockMovementModel movement,
    required final double runningBalance,
  }) = _$StockMovementRowImpl;

  @override
  StockMovementModel get movement;
  @override
  double get runningBalance;

  /// Create a copy of StockMovementRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMovementRowImplCopyWith<_$StockMovementRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockMovementsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockMovementsInitial value) initial,
    required TResult Function(StockMovementsLoading value) loading,
    required TResult Function(StockMovementsLoaded value) loaded,
    required TResult Function(StockMovementsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockMovementsInitial value)? initial,
    TResult? Function(StockMovementsLoading value)? loading,
    TResult? Function(StockMovementsLoaded value)? loaded,
    TResult? Function(StockMovementsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockMovementsInitial value)? initial,
    TResult Function(StockMovementsLoading value)? loading,
    TResult Function(StockMovementsLoaded value)? loaded,
    TResult Function(StockMovementsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMovementsStateCopyWith<$Res> {
  factory $StockMovementsStateCopyWith(
    StockMovementsState value,
    $Res Function(StockMovementsState) then,
  ) = _$StockMovementsStateCopyWithImpl<$Res, StockMovementsState>;
}

/// @nodoc
class _$StockMovementsStateCopyWithImpl<$Res, $Val extends StockMovementsState>
    implements $StockMovementsStateCopyWith<$Res> {
  _$StockMovementsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StockMovementsInitialImplCopyWith<$Res> {
  factory _$$StockMovementsInitialImplCopyWith(
    _$StockMovementsInitialImpl value,
    $Res Function(_$StockMovementsInitialImpl) then,
  ) = __$$StockMovementsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StockMovementsInitialImplCopyWithImpl<$Res>
    extends _$StockMovementsStateCopyWithImpl<$Res, _$StockMovementsInitialImpl>
    implements _$$StockMovementsInitialImplCopyWith<$Res> {
  __$$StockMovementsInitialImplCopyWithImpl(
    _$StockMovementsInitialImpl _value,
    $Res Function(_$StockMovementsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StockMovementsInitialImpl implements StockMovementsInitial {
  const _$StockMovementsInitialImpl();

  @override
  String toString() {
    return 'StockMovementsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
    required TResult Function(StockMovementsInitial value) initial,
    required TResult Function(StockMovementsLoading value) loading,
    required TResult Function(StockMovementsLoaded value) loaded,
    required TResult Function(StockMovementsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockMovementsInitial value)? initial,
    TResult? Function(StockMovementsLoading value)? loading,
    TResult? Function(StockMovementsLoaded value)? loaded,
    TResult? Function(StockMovementsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockMovementsInitial value)? initial,
    TResult Function(StockMovementsLoading value)? loading,
    TResult Function(StockMovementsLoaded value)? loaded,
    TResult Function(StockMovementsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class StockMovementsInitial implements StockMovementsState {
  const factory StockMovementsInitial() = _$StockMovementsInitialImpl;
}

/// @nodoc
abstract class _$$StockMovementsLoadingImplCopyWith<$Res> {
  factory _$$StockMovementsLoadingImplCopyWith(
    _$StockMovementsLoadingImpl value,
    $Res Function(_$StockMovementsLoadingImpl) then,
  ) = __$$StockMovementsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StockMovementsLoadingImplCopyWithImpl<$Res>
    extends _$StockMovementsStateCopyWithImpl<$Res, _$StockMovementsLoadingImpl>
    implements _$$StockMovementsLoadingImplCopyWith<$Res> {
  __$$StockMovementsLoadingImplCopyWithImpl(
    _$StockMovementsLoadingImpl _value,
    $Res Function(_$StockMovementsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StockMovementsLoadingImpl implements StockMovementsLoading {
  const _$StockMovementsLoadingImpl();

  @override
  String toString() {
    return 'StockMovementsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
    required TResult Function(StockMovementsInitial value) initial,
    required TResult Function(StockMovementsLoading value) loading,
    required TResult Function(StockMovementsLoaded value) loaded,
    required TResult Function(StockMovementsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockMovementsInitial value)? initial,
    TResult? Function(StockMovementsLoading value)? loading,
    TResult? Function(StockMovementsLoaded value)? loaded,
    TResult? Function(StockMovementsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockMovementsInitial value)? initial,
    TResult Function(StockMovementsLoading value)? loading,
    TResult Function(StockMovementsLoaded value)? loaded,
    TResult Function(StockMovementsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class StockMovementsLoading implements StockMovementsState {
  const factory StockMovementsLoading() = _$StockMovementsLoadingImpl;
}

/// @nodoc
abstract class _$$StockMovementsLoadedImplCopyWith<$Res> {
  factory _$$StockMovementsLoadedImplCopyWith(
    _$StockMovementsLoadedImpl value,
    $Res Function(_$StockMovementsLoadedImpl) then,
  ) = __$$StockMovementsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<StockMovementRow> rows,
    int total,
    int skip,
    int limit,
    String? productId,
    String? branchId,
    bool isLoadingMore,
  });
}

/// @nodoc
class __$$StockMovementsLoadedImplCopyWithImpl<$Res>
    extends _$StockMovementsStateCopyWithImpl<$Res, _$StockMovementsLoadedImpl>
    implements _$$StockMovementsLoadedImplCopyWith<$Res> {
  __$$StockMovementsLoadedImplCopyWithImpl(
    _$StockMovementsLoadedImpl _value,
    $Res Function(_$StockMovementsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? productId = freezed,
    Object? branchId = freezed,
    Object? isLoadingMore = null,
  }) {
    return _then(
      _$StockMovementsLoadedImpl(
        rows: null == rows
            ? _value._rows
            : rows // ignore: cast_nullable_to_non_nullable
                  as List<StockMovementRow>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$StockMovementsLoadedImpl implements StockMovementsLoaded {
  const _$StockMovementsLoadedImpl({
    required final List<StockMovementRow> rows,
    required this.total,
    required this.skip,
    required this.limit,
    this.productId,
    this.branchId,
    this.isLoadingMore = false,
  }) : _rows = rows;

  final List<StockMovementRow> _rows;
  @override
  List<StockMovementRow> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  @override
  final String? productId;
  @override
  final String? branchId;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'StockMovementsState.loaded(rows: $rows, total: $total, skip: $skip, limit: $limit, productId: $productId, branchId: $branchId, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementsLoadedImpl &&
            const DeepCollectionEquality().equals(other._rows, _rows) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_rows),
    total,
    skip,
    limit,
    productId,
    branchId,
    isLoadingMore,
  );

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementsLoadedImplCopyWith<_$StockMovementsLoadedImpl>
  get copyWith =>
      __$$StockMovementsLoadedImplCopyWithImpl<_$StockMovementsLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(rows, total, skip, limit, productId, branchId, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      rows,
      total,
      skip,
      limit,
      productId,
      branchId,
      isLoadingMore,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        rows,
        total,
        skip,
        limit,
        productId,
        branchId,
        isLoadingMore,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockMovementsInitial value) initial,
    required TResult Function(StockMovementsLoading value) loading,
    required TResult Function(StockMovementsLoaded value) loaded,
    required TResult Function(StockMovementsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockMovementsInitial value)? initial,
    TResult? Function(StockMovementsLoading value)? loading,
    TResult? Function(StockMovementsLoaded value)? loaded,
    TResult? Function(StockMovementsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockMovementsInitial value)? initial,
    TResult Function(StockMovementsLoading value)? loading,
    TResult Function(StockMovementsLoaded value)? loaded,
    TResult Function(StockMovementsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class StockMovementsLoaded implements StockMovementsState {
  const factory StockMovementsLoaded({
    required final List<StockMovementRow> rows,
    required final int total,
    required final int skip,
    required final int limit,
    final String? productId,
    final String? branchId,
    final bool isLoadingMore,
  }) = _$StockMovementsLoadedImpl;

  List<StockMovementRow> get rows;
  int get total;
  int get skip;
  int get limit;
  String? get productId;
  String? get branchId;
  bool get isLoadingMore;

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMovementsLoadedImplCopyWith<_$StockMovementsLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StockMovementsErrorImplCopyWith<$Res> {
  factory _$$StockMovementsErrorImplCopyWith(
    _$StockMovementsErrorImpl value,
    $Res Function(_$StockMovementsErrorImpl) then,
  ) = __$$StockMovementsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StockMovementsErrorImplCopyWithImpl<$Res>
    extends _$StockMovementsStateCopyWithImpl<$Res, _$StockMovementsErrorImpl>
    implements _$$StockMovementsErrorImplCopyWith<$Res> {
  __$$StockMovementsErrorImplCopyWithImpl(
    _$StockMovementsErrorImpl _value,
    $Res Function(_$StockMovementsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$StockMovementsErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$StockMovementsErrorImpl implements StockMovementsError {
  const _$StockMovementsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'StockMovementsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementsErrorImplCopyWith<_$StockMovementsErrorImpl> get copyWith =>
      __$$StockMovementsErrorImplCopyWithImpl<_$StockMovementsErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
      List<StockMovementRow> rows,
      int total,
      int skip,
      int limit,
      String? productId,
      String? branchId,
      bool isLoadingMore,
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
    required TResult Function(StockMovementsInitial value) initial,
    required TResult Function(StockMovementsLoading value) loading,
    required TResult Function(StockMovementsLoaded value) loaded,
    required TResult Function(StockMovementsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockMovementsInitial value)? initial,
    TResult? Function(StockMovementsLoading value)? loading,
    TResult? Function(StockMovementsLoaded value)? loaded,
    TResult? Function(StockMovementsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockMovementsInitial value)? initial,
    TResult Function(StockMovementsLoading value)? loading,
    TResult Function(StockMovementsLoaded value)? loaded,
    TResult Function(StockMovementsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class StockMovementsError implements StockMovementsState {
  const factory StockMovementsError(final String message) =
      _$StockMovementsErrorImpl;

  String get message;

  /// Create a copy of StockMovementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMovementsErrorImplCopyWith<_$StockMovementsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
