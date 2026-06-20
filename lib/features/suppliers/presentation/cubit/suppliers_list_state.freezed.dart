// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suppliers_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SupplierListRow {
  SupplierModel get supplier => throw _privateConstructorUsedError;
  String? get balance => throw _privateConstructorUsedError;
  bool get balanceLoading => throw _privateConstructorUsedError;

  /// Create a copy of SupplierListRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplierListRowCopyWith<SupplierListRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierListRowCopyWith<$Res> {
  factory $SupplierListRowCopyWith(
    SupplierListRow value,
    $Res Function(SupplierListRow) then,
  ) = _$SupplierListRowCopyWithImpl<$Res, SupplierListRow>;
  @useResult
  $Res call({SupplierModel supplier, String? balance, bool balanceLoading});

  $SupplierModelCopyWith<$Res> get supplier;
}

/// @nodoc
class _$SupplierListRowCopyWithImpl<$Res, $Val extends SupplierListRow>
    implements $SupplierListRowCopyWith<$Res> {
  _$SupplierListRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplierListRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supplier = null,
    Object? balance = freezed,
    Object? balanceLoading = null,
  }) {
    return _then(
      _value.copyWith(
            supplier: null == supplier
                ? _value.supplier
                : supplier // ignore: cast_nullable_to_non_nullable
                      as SupplierModel,
            balance: freezed == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as String?,
            balanceLoading: null == balanceLoading
                ? _value.balanceLoading
                : balanceLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SupplierListRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupplierModelCopyWith<$Res> get supplier {
    return $SupplierModelCopyWith<$Res>(_value.supplier, (value) {
      return _then(_value.copyWith(supplier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SupplierListRowImplCopyWith<$Res>
    implements $SupplierListRowCopyWith<$Res> {
  factory _$$SupplierListRowImplCopyWith(
    _$SupplierListRowImpl value,
    $Res Function(_$SupplierListRowImpl) then,
  ) = __$$SupplierListRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SupplierModel supplier, String? balance, bool balanceLoading});

  @override
  $SupplierModelCopyWith<$Res> get supplier;
}

/// @nodoc
class __$$SupplierListRowImplCopyWithImpl<$Res>
    extends _$SupplierListRowCopyWithImpl<$Res, _$SupplierListRowImpl>
    implements _$$SupplierListRowImplCopyWith<$Res> {
  __$$SupplierListRowImplCopyWithImpl(
    _$SupplierListRowImpl _value,
    $Res Function(_$SupplierListRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplierListRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supplier = null,
    Object? balance = freezed,
    Object? balanceLoading = null,
  }) {
    return _then(
      _$SupplierListRowImpl(
        supplier: null == supplier
            ? _value.supplier
            : supplier // ignore: cast_nullable_to_non_nullable
                  as SupplierModel,
        balance: freezed == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as String?,
        balanceLoading: null == balanceLoading
            ? _value.balanceLoading
            : balanceLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SupplierListRowImpl implements _SupplierListRow {
  const _$SupplierListRowImpl({
    required this.supplier,
    this.balance,
    this.balanceLoading = false,
  });

  @override
  final SupplierModel supplier;
  @override
  final String? balance;
  @override
  @JsonKey()
  final bool balanceLoading;

  @override
  String toString() {
    return 'SupplierListRow(supplier: $supplier, balance: $balance, balanceLoading: $balanceLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierListRowImpl &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.balanceLoading, balanceLoading) ||
                other.balanceLoading == balanceLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, supplier, balance, balanceLoading);

  /// Create a copy of SupplierListRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierListRowImplCopyWith<_$SupplierListRowImpl> get copyWith =>
      __$$SupplierListRowImplCopyWithImpl<_$SupplierListRowImpl>(
        this,
        _$identity,
      );
}

abstract class _SupplierListRow implements SupplierListRow {
  const factory _SupplierListRow({
    required final SupplierModel supplier,
    final String? balance,
    final bool balanceLoading,
  }) = _$SupplierListRowImpl;

  @override
  SupplierModel get supplier;
  @override
  String? get balance;
  @override
  bool get balanceLoading;

  /// Create a copy of SupplierListRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplierListRowImplCopyWith<_$SupplierListRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SuppliersListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuppliersListInitial value) initial,
    required TResult Function(SuppliersListLoading value) loading,
    required TResult Function(SuppliersListLoaded value) loaded,
    required TResult Function(SuppliersListError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuppliersListInitial value)? initial,
    TResult? Function(SuppliersListLoading value)? loading,
    TResult? Function(SuppliersListLoaded value)? loaded,
    TResult? Function(SuppliersListError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuppliersListInitial value)? initial,
    TResult Function(SuppliersListLoading value)? loading,
    TResult Function(SuppliersListLoaded value)? loaded,
    TResult Function(SuppliersListError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuppliersListStateCopyWith<$Res> {
  factory $SuppliersListStateCopyWith(
    SuppliersListState value,
    $Res Function(SuppliersListState) then,
  ) = _$SuppliersListStateCopyWithImpl<$Res, SuppliersListState>;
}

/// @nodoc
class _$SuppliersListStateCopyWithImpl<$Res, $Val extends SuppliersListState>
    implements $SuppliersListStateCopyWith<$Res> {
  _$SuppliersListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SuppliersListInitialImplCopyWith<$Res> {
  factory _$$SuppliersListInitialImplCopyWith(
    _$SuppliersListInitialImpl value,
    $Res Function(_$SuppliersListInitialImpl) then,
  ) = __$$SuppliersListInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SuppliersListInitialImplCopyWithImpl<$Res>
    extends _$SuppliersListStateCopyWithImpl<$Res, _$SuppliersListInitialImpl>
    implements _$$SuppliersListInitialImplCopyWith<$Res> {
  __$$SuppliersListInitialImplCopyWithImpl(
    _$SuppliersListInitialImpl _value,
    $Res Function(_$SuppliersListInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SuppliersListInitialImpl implements SuppliersListInitial {
  const _$SuppliersListInitialImpl();

  @override
  String toString() {
    return 'SuppliersListState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuppliersListInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
    required TResult Function(SuppliersListInitial value) initial,
    required TResult Function(SuppliersListLoading value) loading,
    required TResult Function(SuppliersListLoaded value) loaded,
    required TResult Function(SuppliersListError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuppliersListInitial value)? initial,
    TResult? Function(SuppliersListLoading value)? loading,
    TResult? Function(SuppliersListLoaded value)? loaded,
    TResult? Function(SuppliersListError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuppliersListInitial value)? initial,
    TResult Function(SuppliersListLoading value)? loading,
    TResult Function(SuppliersListLoaded value)? loaded,
    TResult Function(SuppliersListError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SuppliersListInitial implements SuppliersListState {
  const factory SuppliersListInitial() = _$SuppliersListInitialImpl;
}

/// @nodoc
abstract class _$$SuppliersListLoadingImplCopyWith<$Res> {
  factory _$$SuppliersListLoadingImplCopyWith(
    _$SuppliersListLoadingImpl value,
    $Res Function(_$SuppliersListLoadingImpl) then,
  ) = __$$SuppliersListLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SuppliersListLoadingImplCopyWithImpl<$Res>
    extends _$SuppliersListStateCopyWithImpl<$Res, _$SuppliersListLoadingImpl>
    implements _$$SuppliersListLoadingImplCopyWith<$Res> {
  __$$SuppliersListLoadingImplCopyWithImpl(
    _$SuppliersListLoadingImpl _value,
    $Res Function(_$SuppliersListLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SuppliersListLoadingImpl implements SuppliersListLoading {
  const _$SuppliersListLoadingImpl();

  @override
  String toString() {
    return 'SuppliersListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuppliersListLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
    required TResult Function(SuppliersListInitial value) initial,
    required TResult Function(SuppliersListLoading value) loading,
    required TResult Function(SuppliersListLoaded value) loaded,
    required TResult Function(SuppliersListError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuppliersListInitial value)? initial,
    TResult? Function(SuppliersListLoading value)? loading,
    TResult? Function(SuppliersListLoaded value)? loaded,
    TResult? Function(SuppliersListError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuppliersListInitial value)? initial,
    TResult Function(SuppliersListLoading value)? loading,
    TResult Function(SuppliersListLoaded value)? loaded,
    TResult Function(SuppliersListError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SuppliersListLoading implements SuppliersListState {
  const factory SuppliersListLoading() = _$SuppliersListLoadingImpl;
}

/// @nodoc
abstract class _$$SuppliersListLoadedImplCopyWith<$Res> {
  factory _$$SuppliersListLoadedImplCopyWith(
    _$SuppliersListLoadedImpl value,
    $Res Function(_$SuppliersListLoadedImpl) then,
  ) = __$$SuppliersListLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<SupplierListRow> allItems,
    List<SupplierListRow> filteredItems,
    String? searchQuery,
  });
}

/// @nodoc
class __$$SuppliersListLoadedImplCopyWithImpl<$Res>
    extends _$SuppliersListStateCopyWithImpl<$Res, _$SuppliersListLoadedImpl>
    implements _$$SuppliersListLoadedImplCopyWith<$Res> {
  __$$SuppliersListLoadedImplCopyWithImpl(
    _$SuppliersListLoadedImpl _value,
    $Res Function(_$SuppliersListLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allItems = null,
    Object? filteredItems = null,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _$SuppliersListLoadedImpl(
        allItems: null == allItems
            ? _value._allItems
            : allItems // ignore: cast_nullable_to_non_nullable
                  as List<SupplierListRow>,
        filteredItems: null == filteredItems
            ? _value._filteredItems
            : filteredItems // ignore: cast_nullable_to_non_nullable
                  as List<SupplierListRow>,
        searchQuery: freezed == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SuppliersListLoadedImpl implements SuppliersListLoaded {
  const _$SuppliersListLoadedImpl({
    required final List<SupplierListRow> allItems,
    required final List<SupplierListRow> filteredItems,
    this.searchQuery,
  }) : _allItems = allItems,
       _filteredItems = filteredItems;

  final List<SupplierListRow> _allItems;
  @override
  List<SupplierListRow> get allItems {
    if (_allItems is EqualUnmodifiableListView) return _allItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allItems);
  }

  final List<SupplierListRow> _filteredItems;
  @override
  List<SupplierListRow> get filteredItems {
    if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredItems);
  }

  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'SuppliersListState.loaded(allItems: $allItems, filteredItems: $filteredItems, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuppliersListLoadedImpl &&
            const DeepCollectionEquality().equals(other._allItems, _allItems) &&
            const DeepCollectionEquality().equals(
              other._filteredItems,
              _filteredItems,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_allItems),
    const DeepCollectionEquality().hash(_filteredItems),
    searchQuery,
  );

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuppliersListLoadedImplCopyWith<_$SuppliersListLoadedImpl> get copyWith =>
      __$$SuppliersListLoadedImplCopyWithImpl<_$SuppliersListLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(allItems, filteredItems, searchQuery);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(allItems, filteredItems, searchQuery);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(allItems, filteredItems, searchQuery);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuppliersListInitial value) initial,
    required TResult Function(SuppliersListLoading value) loading,
    required TResult Function(SuppliersListLoaded value) loaded,
    required TResult Function(SuppliersListError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuppliersListInitial value)? initial,
    TResult? Function(SuppliersListLoading value)? loading,
    TResult? Function(SuppliersListLoaded value)? loaded,
    TResult? Function(SuppliersListError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuppliersListInitial value)? initial,
    TResult Function(SuppliersListLoading value)? loading,
    TResult Function(SuppliersListLoaded value)? loaded,
    TResult Function(SuppliersListError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SuppliersListLoaded implements SuppliersListState {
  const factory SuppliersListLoaded({
    required final List<SupplierListRow> allItems,
    required final List<SupplierListRow> filteredItems,
    final String? searchQuery,
  }) = _$SuppliersListLoadedImpl;

  List<SupplierListRow> get allItems;
  List<SupplierListRow> get filteredItems;
  String? get searchQuery;

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuppliersListLoadedImplCopyWith<_$SuppliersListLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuppliersListErrorImplCopyWith<$Res> {
  factory _$$SuppliersListErrorImplCopyWith(
    _$SuppliersListErrorImpl value,
    $Res Function(_$SuppliersListErrorImpl) then,
  ) = __$$SuppliersListErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SuppliersListErrorImplCopyWithImpl<$Res>
    extends _$SuppliersListStateCopyWithImpl<$Res, _$SuppliersListErrorImpl>
    implements _$$SuppliersListErrorImplCopyWith<$Res> {
  __$$SuppliersListErrorImplCopyWithImpl(
    _$SuppliersListErrorImpl _value,
    $Res Function(_$SuppliersListErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SuppliersListErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SuppliersListErrorImpl implements SuppliersListError {
  const _$SuppliersListErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SuppliersListState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuppliersListErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuppliersListErrorImplCopyWith<_$SuppliersListErrorImpl> get copyWith =>
      __$$SuppliersListErrorImplCopyWithImpl<_$SuppliersListErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
      List<SupplierListRow> allItems,
      List<SupplierListRow> filteredItems,
      String? searchQuery,
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
    required TResult Function(SuppliersListInitial value) initial,
    required TResult Function(SuppliersListLoading value) loading,
    required TResult Function(SuppliersListLoaded value) loaded,
    required TResult Function(SuppliersListError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuppliersListInitial value)? initial,
    TResult? Function(SuppliersListLoading value)? loading,
    TResult? Function(SuppliersListLoaded value)? loaded,
    TResult? Function(SuppliersListError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuppliersListInitial value)? initial,
    TResult Function(SuppliersListLoading value)? loading,
    TResult Function(SuppliersListLoaded value)? loaded,
    TResult Function(SuppliersListError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SuppliersListError implements SuppliersListState {
  const factory SuppliersListError(final String message) =
      _$SuppliersListErrorImpl;

  String get message;

  /// Create a copy of SuppliersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuppliersListErrorImplCopyWith<_$SuppliersListErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
