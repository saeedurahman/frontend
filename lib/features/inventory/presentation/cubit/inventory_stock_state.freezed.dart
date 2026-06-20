// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_stock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StockDisplayRow {
  ProductListItemModel get product => throw _privateConstructorUsedError;
  StockBalanceModel get balance => throw _privateConstructorUsedError;
  String? get variationName => throw _privateConstructorUsedError;
  String? get unitName => throw _privateConstructorUsedError;
  String? get minStockLevel => throw _privateConstructorUsedError;

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockDisplayRowCopyWith<StockDisplayRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockDisplayRowCopyWith<$Res> {
  factory $StockDisplayRowCopyWith(
    StockDisplayRow value,
    $Res Function(StockDisplayRow) then,
  ) = _$StockDisplayRowCopyWithImpl<$Res, StockDisplayRow>;
  @useResult
  $Res call({
    ProductListItemModel product,
    StockBalanceModel balance,
    String? variationName,
    String? unitName,
    String? minStockLevel,
  });

  $ProductListItemModelCopyWith<$Res> get product;
  $StockBalanceModelCopyWith<$Res> get balance;
}

/// @nodoc
class _$StockDisplayRowCopyWithImpl<$Res, $Val extends StockDisplayRow>
    implements $StockDisplayRowCopyWith<$Res> {
  _$StockDisplayRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
    Object? balance = null,
    Object? variationName = freezed,
    Object? unitName = freezed,
    Object? minStockLevel = freezed,
  }) {
    return _then(
      _value.copyWith(
            product: null == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as ProductListItemModel,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as StockBalanceModel,
            variationName: freezed == variationName
                ? _value.variationName
                : variationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitName: freezed == unitName
                ? _value.unitName
                : unitName // ignore: cast_nullable_to_non_nullable
                      as String?,
            minStockLevel: freezed == minStockLevel
                ? _value.minStockLevel
                : minStockLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductListItemModelCopyWith<$Res> get product {
    return $ProductListItemModelCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockBalanceModelCopyWith<$Res> get balance {
    return $StockBalanceModelCopyWith<$Res>(_value.balance, (value) {
      return _then(_value.copyWith(balance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockDisplayRowImplCopyWith<$Res>
    implements $StockDisplayRowCopyWith<$Res> {
  factory _$$StockDisplayRowImplCopyWith(
    _$StockDisplayRowImpl value,
    $Res Function(_$StockDisplayRowImpl) then,
  ) = __$$StockDisplayRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ProductListItemModel product,
    StockBalanceModel balance,
    String? variationName,
    String? unitName,
    String? minStockLevel,
  });

  @override
  $ProductListItemModelCopyWith<$Res> get product;
  @override
  $StockBalanceModelCopyWith<$Res> get balance;
}

/// @nodoc
class __$$StockDisplayRowImplCopyWithImpl<$Res>
    extends _$StockDisplayRowCopyWithImpl<$Res, _$StockDisplayRowImpl>
    implements _$$StockDisplayRowImplCopyWith<$Res> {
  __$$StockDisplayRowImplCopyWithImpl(
    _$StockDisplayRowImpl _value,
    $Res Function(_$StockDisplayRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
    Object? balance = null,
    Object? variationName = freezed,
    Object? unitName = freezed,
    Object? minStockLevel = freezed,
  }) {
    return _then(
      _$StockDisplayRowImpl(
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as ProductListItemModel,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as StockBalanceModel,
        variationName: freezed == variationName
            ? _value.variationName
            : variationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitName: freezed == unitName
            ? _value.unitName
            : unitName // ignore: cast_nullable_to_non_nullable
                  as String?,
        minStockLevel: freezed == minStockLevel
            ? _value.minStockLevel
            : minStockLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$StockDisplayRowImpl extends _StockDisplayRow {
  const _$StockDisplayRowImpl({
    required this.product,
    required this.balance,
    this.variationName,
    this.unitName,
    this.minStockLevel,
  }) : super._();

  @override
  final ProductListItemModel product;
  @override
  final StockBalanceModel balance;
  @override
  final String? variationName;
  @override
  final String? unitName;
  @override
  final String? minStockLevel;

  @override
  String toString() {
    return 'StockDisplayRow(product: $product, balance: $balance, variationName: $variationName, unitName: $unitName, minStockLevel: $minStockLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockDisplayRowImpl &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.variationName, variationName) ||
                other.variationName == variationName) &&
            (identical(other.unitName, unitName) ||
                other.unitName == unitName) &&
            (identical(other.minStockLevel, minStockLevel) ||
                other.minStockLevel == minStockLevel));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    product,
    balance,
    variationName,
    unitName,
    minStockLevel,
  );

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockDisplayRowImplCopyWith<_$StockDisplayRowImpl> get copyWith =>
      __$$StockDisplayRowImplCopyWithImpl<_$StockDisplayRowImpl>(
        this,
        _$identity,
      );
}

abstract class _StockDisplayRow extends StockDisplayRow {
  const factory _StockDisplayRow({
    required final ProductListItemModel product,
    required final StockBalanceModel balance,
    final String? variationName,
    final String? unitName,
    final String? minStockLevel,
  }) = _$StockDisplayRowImpl;
  const _StockDisplayRow._() : super._();

  @override
  ProductListItemModel get product;
  @override
  StockBalanceModel get balance;
  @override
  String? get variationName;
  @override
  String? get unitName;
  @override
  String? get minStockLevel;

  /// Create a copy of StockDisplayRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockDisplayRowImplCopyWith<_$StockDisplayRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InventoryStockState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InventoryStockInitial value) initial,
    required TResult Function(InventoryStockLoading value) loading,
    required TResult Function(InventoryStockLoaded value) loaded,
    required TResult Function(InventoryStockError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InventoryStockInitial value)? initial,
    TResult? Function(InventoryStockLoading value)? loading,
    TResult? Function(InventoryStockLoaded value)? loaded,
    TResult? Function(InventoryStockError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InventoryStockInitial value)? initial,
    TResult Function(InventoryStockLoading value)? loading,
    TResult Function(InventoryStockLoaded value)? loaded,
    TResult Function(InventoryStockError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStockStateCopyWith<$Res> {
  factory $InventoryStockStateCopyWith(
    InventoryStockState value,
    $Res Function(InventoryStockState) then,
  ) = _$InventoryStockStateCopyWithImpl<$Res, InventoryStockState>;
}

/// @nodoc
class _$InventoryStockStateCopyWithImpl<$Res, $Val extends InventoryStockState>
    implements $InventoryStockStateCopyWith<$Res> {
  _$InventoryStockStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InventoryStockInitialImplCopyWith<$Res> {
  factory _$$InventoryStockInitialImplCopyWith(
    _$InventoryStockInitialImpl value,
    $Res Function(_$InventoryStockInitialImpl) then,
  ) = __$$InventoryStockInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InventoryStockInitialImplCopyWithImpl<$Res>
    extends _$InventoryStockStateCopyWithImpl<$Res, _$InventoryStockInitialImpl>
    implements _$$InventoryStockInitialImplCopyWith<$Res> {
  __$$InventoryStockInitialImplCopyWithImpl(
    _$InventoryStockInitialImpl _value,
    $Res Function(_$InventoryStockInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InventoryStockInitialImpl implements InventoryStockInitial {
  const _$InventoryStockInitialImpl();

  @override
  String toString() {
    return 'InventoryStockState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStockInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
    required TResult Function(InventoryStockInitial value) initial,
    required TResult Function(InventoryStockLoading value) loading,
    required TResult Function(InventoryStockLoaded value) loaded,
    required TResult Function(InventoryStockError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InventoryStockInitial value)? initial,
    TResult? Function(InventoryStockLoading value)? loading,
    TResult? Function(InventoryStockLoaded value)? loaded,
    TResult? Function(InventoryStockError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InventoryStockInitial value)? initial,
    TResult Function(InventoryStockLoading value)? loading,
    TResult Function(InventoryStockLoaded value)? loaded,
    TResult Function(InventoryStockError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InventoryStockInitial implements InventoryStockState {
  const factory InventoryStockInitial() = _$InventoryStockInitialImpl;
}

/// @nodoc
abstract class _$$InventoryStockLoadingImplCopyWith<$Res> {
  factory _$$InventoryStockLoadingImplCopyWith(
    _$InventoryStockLoadingImpl value,
    $Res Function(_$InventoryStockLoadingImpl) then,
  ) = __$$InventoryStockLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InventoryStockLoadingImplCopyWithImpl<$Res>
    extends _$InventoryStockStateCopyWithImpl<$Res, _$InventoryStockLoadingImpl>
    implements _$$InventoryStockLoadingImplCopyWith<$Res> {
  __$$InventoryStockLoadingImplCopyWithImpl(
    _$InventoryStockLoadingImpl _value,
    $Res Function(_$InventoryStockLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InventoryStockLoadingImpl implements InventoryStockLoading {
  const _$InventoryStockLoadingImpl();

  @override
  String toString() {
    return 'InventoryStockState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStockLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
    required TResult Function(InventoryStockInitial value) initial,
    required TResult Function(InventoryStockLoading value) loading,
    required TResult Function(InventoryStockLoaded value) loaded,
    required TResult Function(InventoryStockError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InventoryStockInitial value)? initial,
    TResult? Function(InventoryStockLoading value)? loading,
    TResult? Function(InventoryStockLoaded value)? loaded,
    TResult? Function(InventoryStockError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InventoryStockInitial value)? initial,
    TResult Function(InventoryStockLoading value)? loading,
    TResult Function(InventoryStockLoaded value)? loaded,
    TResult Function(InventoryStockError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class InventoryStockLoading implements InventoryStockState {
  const factory InventoryStockLoading() = _$InventoryStockLoadingImpl;
}

/// @nodoc
abstract class _$$InventoryStockLoadedImplCopyWith<$Res> {
  factory _$$InventoryStockLoadedImplCopyWith(
    _$InventoryStockLoadedImpl value,
    $Res Function(_$InventoryStockLoadedImpl) then,
  ) = __$$InventoryStockLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<StockDisplayRow> allRows,
    List<StockDisplayRow> filteredRows,
    String? branchId,
    String? searchQuery,
    String? categoryFilter,
    bool lowStockOnly,
    bool outOfStockOnly,
  });
}

/// @nodoc
class __$$InventoryStockLoadedImplCopyWithImpl<$Res>
    extends _$InventoryStockStateCopyWithImpl<$Res, _$InventoryStockLoadedImpl>
    implements _$$InventoryStockLoadedImplCopyWith<$Res> {
  __$$InventoryStockLoadedImplCopyWithImpl(
    _$InventoryStockLoadedImpl _value,
    $Res Function(_$InventoryStockLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allRows = null,
    Object? filteredRows = null,
    Object? branchId = freezed,
    Object? searchQuery = freezed,
    Object? categoryFilter = freezed,
    Object? lowStockOnly = null,
    Object? outOfStockOnly = null,
  }) {
    return _then(
      _$InventoryStockLoadedImpl(
        allRows: null == allRows
            ? _value._allRows
            : allRows // ignore: cast_nullable_to_non_nullable
                  as List<StockDisplayRow>,
        filteredRows: null == filteredRows
            ? _value._filteredRows
            : filteredRows // ignore: cast_nullable_to_non_nullable
                  as List<StockDisplayRow>,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchQuery: freezed == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryFilter: freezed == categoryFilter
            ? _value.categoryFilter
            : categoryFilter // ignore: cast_nullable_to_non_nullable
                  as String?,
        lowStockOnly: null == lowStockOnly
            ? _value.lowStockOnly
            : lowStockOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
        outOfStockOnly: null == outOfStockOnly
            ? _value.outOfStockOnly
            : outOfStockOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$InventoryStockLoadedImpl implements InventoryStockLoaded {
  const _$InventoryStockLoadedImpl({
    required final List<StockDisplayRow> allRows,
    required final List<StockDisplayRow> filteredRows,
    this.branchId,
    this.searchQuery,
    this.categoryFilter,
    this.lowStockOnly = false,
    this.outOfStockOnly = false,
  }) : _allRows = allRows,
       _filteredRows = filteredRows;

  final List<StockDisplayRow> _allRows;
  @override
  List<StockDisplayRow> get allRows {
    if (_allRows is EqualUnmodifiableListView) return _allRows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allRows);
  }

  final List<StockDisplayRow> _filteredRows;
  @override
  List<StockDisplayRow> get filteredRows {
    if (_filteredRows is EqualUnmodifiableListView) return _filteredRows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredRows);
  }

  @override
  final String? branchId;
  @override
  final String? searchQuery;
  @override
  final String? categoryFilter;
  @override
  @JsonKey()
  final bool lowStockOnly;
  @override
  @JsonKey()
  final bool outOfStockOnly;

  @override
  String toString() {
    return 'InventoryStockState.loaded(allRows: $allRows, filteredRows: $filteredRows, branchId: $branchId, searchQuery: $searchQuery, categoryFilter: $categoryFilter, lowStockOnly: $lowStockOnly, outOfStockOnly: $outOfStockOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStockLoadedImpl &&
            const DeepCollectionEquality().equals(other._allRows, _allRows) &&
            const DeepCollectionEquality().equals(
              other._filteredRows,
              _filteredRows,
            ) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.categoryFilter, categoryFilter) ||
                other.categoryFilter == categoryFilter) &&
            (identical(other.lowStockOnly, lowStockOnly) ||
                other.lowStockOnly == lowStockOnly) &&
            (identical(other.outOfStockOnly, outOfStockOnly) ||
                other.outOfStockOnly == outOfStockOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_allRows),
    const DeepCollectionEquality().hash(_filteredRows),
    branchId,
    searchQuery,
    categoryFilter,
    lowStockOnly,
    outOfStockOnly,
  );

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStockLoadedImplCopyWith<_$InventoryStockLoadedImpl>
  get copyWith =>
      __$$InventoryStockLoadedImplCopyWithImpl<_$InventoryStockLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
      allRows,
      filteredRows,
      branchId,
      searchQuery,
      categoryFilter,
      lowStockOnly,
      outOfStockOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      allRows,
      filteredRows,
      branchId,
      searchQuery,
      categoryFilter,
      lowStockOnly,
      outOfStockOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        allRows,
        filteredRows,
        branchId,
        searchQuery,
        categoryFilter,
        lowStockOnly,
        outOfStockOnly,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InventoryStockInitial value) initial,
    required TResult Function(InventoryStockLoading value) loading,
    required TResult Function(InventoryStockLoaded value) loaded,
    required TResult Function(InventoryStockError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InventoryStockInitial value)? initial,
    TResult? Function(InventoryStockLoading value)? loading,
    TResult? Function(InventoryStockLoaded value)? loaded,
    TResult? Function(InventoryStockError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InventoryStockInitial value)? initial,
    TResult Function(InventoryStockLoading value)? loading,
    TResult Function(InventoryStockLoaded value)? loaded,
    TResult Function(InventoryStockError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class InventoryStockLoaded implements InventoryStockState {
  const factory InventoryStockLoaded({
    required final List<StockDisplayRow> allRows,
    required final List<StockDisplayRow> filteredRows,
    final String? branchId,
    final String? searchQuery,
    final String? categoryFilter,
    final bool lowStockOnly,
    final bool outOfStockOnly,
  }) = _$InventoryStockLoadedImpl;

  List<StockDisplayRow> get allRows;
  List<StockDisplayRow> get filteredRows;
  String? get branchId;
  String? get searchQuery;
  String? get categoryFilter;
  bool get lowStockOnly;
  bool get outOfStockOnly;

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStockLoadedImplCopyWith<_$InventoryStockLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InventoryStockErrorImplCopyWith<$Res> {
  factory _$$InventoryStockErrorImplCopyWith(
    _$InventoryStockErrorImpl value,
    $Res Function(_$InventoryStockErrorImpl) then,
  ) = __$$InventoryStockErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InventoryStockErrorImplCopyWithImpl<$Res>
    extends _$InventoryStockStateCopyWithImpl<$Res, _$InventoryStockErrorImpl>
    implements _$$InventoryStockErrorImplCopyWith<$Res> {
  __$$InventoryStockErrorImplCopyWithImpl(
    _$InventoryStockErrorImpl _value,
    $Res Function(_$InventoryStockErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$InventoryStockErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InventoryStockErrorImpl implements InventoryStockError {
  const _$InventoryStockErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'InventoryStockState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStockErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStockErrorImplCopyWith<_$InventoryStockErrorImpl> get copyWith =>
      __$$InventoryStockErrorImplCopyWithImpl<_$InventoryStockErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
      List<StockDisplayRow> allRows,
      List<StockDisplayRow> filteredRows,
      String? branchId,
      String? searchQuery,
      String? categoryFilter,
      bool lowStockOnly,
      bool outOfStockOnly,
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
    required TResult Function(InventoryStockInitial value) initial,
    required TResult Function(InventoryStockLoading value) loading,
    required TResult Function(InventoryStockLoaded value) loaded,
    required TResult Function(InventoryStockError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InventoryStockInitial value)? initial,
    TResult? Function(InventoryStockLoading value)? loading,
    TResult? Function(InventoryStockLoaded value)? loaded,
    TResult? Function(InventoryStockError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InventoryStockInitial value)? initial,
    TResult Function(InventoryStockLoading value)? loading,
    TResult Function(InventoryStockLoaded value)? loaded,
    TResult Function(InventoryStockError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class InventoryStockError implements InventoryStockState {
  const factory InventoryStockError(final String message) =
      _$InventoryStockErrorImpl;

  String get message;

  /// Create a copy of InventoryStockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStockErrorImplCopyWith<_$InventoryStockErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
