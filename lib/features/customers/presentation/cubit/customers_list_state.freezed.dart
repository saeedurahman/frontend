// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customers_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CustomerListRow {
  CustomerModel get customer => throw _privateConstructorUsedError;
  String? get balance => throw _privateConstructorUsedError;
  bool get balanceLoading => throw _privateConstructorUsedError;

  /// Create a copy of CustomerListRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerListRowCopyWith<CustomerListRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerListRowCopyWith<$Res> {
  factory $CustomerListRowCopyWith(
    CustomerListRow value,
    $Res Function(CustomerListRow) then,
  ) = _$CustomerListRowCopyWithImpl<$Res, CustomerListRow>;
  @useResult
  $Res call({CustomerModel customer, String? balance, bool balanceLoading});

  $CustomerModelCopyWith<$Res> get customer;
}

/// @nodoc
class _$CustomerListRowCopyWithImpl<$Res, $Val extends CustomerListRow>
    implements $CustomerListRowCopyWith<$Res> {
  _$CustomerListRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerListRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? balance = freezed,
    Object? balanceLoading = null,
  }) {
    return _then(
      _value.copyWith(
            customer: null == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as CustomerModel,
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

  /// Create a copy of CustomerListRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res> get customer {
    return $CustomerModelCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerListRowImplCopyWith<$Res>
    implements $CustomerListRowCopyWith<$Res> {
  factory _$$CustomerListRowImplCopyWith(
    _$CustomerListRowImpl value,
    $Res Function(_$CustomerListRowImpl) then,
  ) = __$$CustomerListRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CustomerModel customer, String? balance, bool balanceLoading});

  @override
  $CustomerModelCopyWith<$Res> get customer;
}

/// @nodoc
class __$$CustomerListRowImplCopyWithImpl<$Res>
    extends _$CustomerListRowCopyWithImpl<$Res, _$CustomerListRowImpl>
    implements _$$CustomerListRowImplCopyWith<$Res> {
  __$$CustomerListRowImplCopyWithImpl(
    _$CustomerListRowImpl _value,
    $Res Function(_$CustomerListRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerListRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? balance = freezed,
    Object? balanceLoading = null,
  }) {
    return _then(
      _$CustomerListRowImpl(
        customer: null == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel,
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

class _$CustomerListRowImpl implements _CustomerListRow {
  const _$CustomerListRowImpl({
    required this.customer,
    this.balance,
    this.balanceLoading = false,
  });

  @override
  final CustomerModel customer;
  @override
  final String? balance;
  @override
  @JsonKey()
  final bool balanceLoading;

  @override
  String toString() {
    return 'CustomerListRow(customer: $customer, balance: $balance, balanceLoading: $balanceLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerListRowImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.balanceLoading, balanceLoading) ||
                other.balanceLoading == balanceLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, customer, balance, balanceLoading);

  /// Create a copy of CustomerListRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerListRowImplCopyWith<_$CustomerListRowImpl> get copyWith =>
      __$$CustomerListRowImplCopyWithImpl<_$CustomerListRowImpl>(
        this,
        _$identity,
      );
}

abstract class _CustomerListRow implements CustomerListRow {
  const factory _CustomerListRow({
    required final CustomerModel customer,
    final String? balance,
    final bool balanceLoading,
  }) = _$CustomerListRowImpl;

  @override
  CustomerModel get customer;
  @override
  String? get balance;
  @override
  bool get balanceLoading;

  /// Create a copy of CustomerListRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerListRowImplCopyWith<_$CustomerListRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CustomersListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomersListInitial value) initial,
    required TResult Function(CustomersListLoading value) loading,
    required TResult Function(CustomersListLoaded value) loaded,
    required TResult Function(CustomersListError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomersListInitial value)? initial,
    TResult? Function(CustomersListLoading value)? loading,
    TResult? Function(CustomersListLoaded value)? loaded,
    TResult? Function(CustomersListError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomersListInitial value)? initial,
    TResult Function(CustomersListLoading value)? loading,
    TResult Function(CustomersListLoaded value)? loaded,
    TResult Function(CustomersListError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomersListStateCopyWith<$Res> {
  factory $CustomersListStateCopyWith(
    CustomersListState value,
    $Res Function(CustomersListState) then,
  ) = _$CustomersListStateCopyWithImpl<$Res, CustomersListState>;
}

/// @nodoc
class _$CustomersListStateCopyWithImpl<$Res, $Val extends CustomersListState>
    implements $CustomersListStateCopyWith<$Res> {
  _$CustomersListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CustomersListInitialImplCopyWith<$Res> {
  factory _$$CustomersListInitialImplCopyWith(
    _$CustomersListInitialImpl value,
    $Res Function(_$CustomersListInitialImpl) then,
  ) = __$$CustomersListInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CustomersListInitialImplCopyWithImpl<$Res>
    extends _$CustomersListStateCopyWithImpl<$Res, _$CustomersListInitialImpl>
    implements _$$CustomersListInitialImplCopyWith<$Res> {
  __$$CustomersListInitialImplCopyWithImpl(
    _$CustomersListInitialImpl _value,
    $Res Function(_$CustomersListInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CustomersListInitialImpl implements CustomersListInitial {
  const _$CustomersListInitialImpl();

  @override
  String toString() {
    return 'CustomersListState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomersListInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
    required TResult Function(CustomersListInitial value) initial,
    required TResult Function(CustomersListLoading value) loading,
    required TResult Function(CustomersListLoaded value) loaded,
    required TResult Function(CustomersListError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomersListInitial value)? initial,
    TResult? Function(CustomersListLoading value)? loading,
    TResult? Function(CustomersListLoaded value)? loaded,
    TResult? Function(CustomersListError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomersListInitial value)? initial,
    TResult Function(CustomersListLoading value)? loading,
    TResult Function(CustomersListLoaded value)? loaded,
    TResult Function(CustomersListError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CustomersListInitial implements CustomersListState {
  const factory CustomersListInitial() = _$CustomersListInitialImpl;
}

/// @nodoc
abstract class _$$CustomersListLoadingImplCopyWith<$Res> {
  factory _$$CustomersListLoadingImplCopyWith(
    _$CustomersListLoadingImpl value,
    $Res Function(_$CustomersListLoadingImpl) then,
  ) = __$$CustomersListLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CustomersListLoadingImplCopyWithImpl<$Res>
    extends _$CustomersListStateCopyWithImpl<$Res, _$CustomersListLoadingImpl>
    implements _$$CustomersListLoadingImplCopyWith<$Res> {
  __$$CustomersListLoadingImplCopyWithImpl(
    _$CustomersListLoadingImpl _value,
    $Res Function(_$CustomersListLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CustomersListLoadingImpl implements CustomersListLoading {
  const _$CustomersListLoadingImpl();

  @override
  String toString() {
    return 'CustomersListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomersListLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
    required TResult Function(CustomersListInitial value) initial,
    required TResult Function(CustomersListLoading value) loading,
    required TResult Function(CustomersListLoaded value) loaded,
    required TResult Function(CustomersListError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomersListInitial value)? initial,
    TResult? Function(CustomersListLoading value)? loading,
    TResult? Function(CustomersListLoaded value)? loaded,
    TResult? Function(CustomersListError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomersListInitial value)? initial,
    TResult Function(CustomersListLoading value)? loading,
    TResult Function(CustomersListLoaded value)? loaded,
    TResult Function(CustomersListError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CustomersListLoading implements CustomersListState {
  const factory CustomersListLoading() = _$CustomersListLoadingImpl;
}

/// @nodoc
abstract class _$$CustomersListLoadedImplCopyWith<$Res> {
  factory _$$CustomersListLoadedImplCopyWith(
    _$CustomersListLoadedImpl value,
    $Res Function(_$CustomersListLoadedImpl) then,
  ) = __$$CustomersListLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<CustomerListRow> allItems,
    List<CustomerListRow> filteredItems,
    String? searchQuery,
    CustomerActiveFilter activeFilter,
    bool hasOutstandingOnly,
  });
}

/// @nodoc
class __$$CustomersListLoadedImplCopyWithImpl<$Res>
    extends _$CustomersListStateCopyWithImpl<$Res, _$CustomersListLoadedImpl>
    implements _$$CustomersListLoadedImplCopyWith<$Res> {
  __$$CustomersListLoadedImplCopyWithImpl(
    _$CustomersListLoadedImpl _value,
    $Res Function(_$CustomersListLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allItems = null,
    Object? filteredItems = null,
    Object? searchQuery = freezed,
    Object? activeFilter = null,
    Object? hasOutstandingOnly = null,
  }) {
    return _then(
      _$CustomersListLoadedImpl(
        allItems: null == allItems
            ? _value._allItems
            : allItems // ignore: cast_nullable_to_non_nullable
                  as List<CustomerListRow>,
        filteredItems: null == filteredItems
            ? _value._filteredItems
            : filteredItems // ignore: cast_nullable_to_non_nullable
                  as List<CustomerListRow>,
        searchQuery: freezed == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
        activeFilter: null == activeFilter
            ? _value.activeFilter
            : activeFilter // ignore: cast_nullable_to_non_nullable
                  as CustomerActiveFilter,
        hasOutstandingOnly: null == hasOutstandingOnly
            ? _value.hasOutstandingOnly
            : hasOutstandingOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CustomersListLoadedImpl implements CustomersListLoaded {
  const _$CustomersListLoadedImpl({
    required final List<CustomerListRow> allItems,
    required final List<CustomerListRow> filteredItems,
    this.searchQuery,
    this.activeFilter = CustomerActiveFilter.all,
    this.hasOutstandingOnly = false,
  }) : _allItems = allItems,
       _filteredItems = filteredItems;

  final List<CustomerListRow> _allItems;
  @override
  List<CustomerListRow> get allItems {
    if (_allItems is EqualUnmodifiableListView) return _allItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allItems);
  }

  final List<CustomerListRow> _filteredItems;
  @override
  List<CustomerListRow> get filteredItems {
    if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredItems);
  }

  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final CustomerActiveFilter activeFilter;
  @override
  @JsonKey()
  final bool hasOutstandingOnly;

  @override
  String toString() {
    return 'CustomersListState.loaded(allItems: $allItems, filteredItems: $filteredItems, searchQuery: $searchQuery, activeFilter: $activeFilter, hasOutstandingOnly: $hasOutstandingOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomersListLoadedImpl &&
            const DeepCollectionEquality().equals(other._allItems, _allItems) &&
            const DeepCollectionEquality().equals(
              other._filteredItems,
              _filteredItems,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.activeFilter, activeFilter) ||
                other.activeFilter == activeFilter) &&
            (identical(other.hasOutstandingOnly, hasOutstandingOnly) ||
                other.hasOutstandingOnly == hasOutstandingOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_allItems),
    const DeepCollectionEquality().hash(_filteredItems),
    searchQuery,
    activeFilter,
    hasOutstandingOnly,
  );

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomersListLoadedImplCopyWith<_$CustomersListLoadedImpl> get copyWith =>
      __$$CustomersListLoadedImplCopyWithImpl<_$CustomersListLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
      allItems,
      filteredItems,
      searchQuery,
      activeFilter,
      hasOutstandingOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      allItems,
      filteredItems,
      searchQuery,
      activeFilter,
      hasOutstandingOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        allItems,
        filteredItems,
        searchQuery,
        activeFilter,
        hasOutstandingOnly,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CustomersListInitial value) initial,
    required TResult Function(CustomersListLoading value) loading,
    required TResult Function(CustomersListLoaded value) loaded,
    required TResult Function(CustomersListError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomersListInitial value)? initial,
    TResult? Function(CustomersListLoading value)? loading,
    TResult? Function(CustomersListLoaded value)? loaded,
    TResult? Function(CustomersListError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomersListInitial value)? initial,
    TResult Function(CustomersListLoading value)? loading,
    TResult Function(CustomersListLoaded value)? loaded,
    TResult Function(CustomersListError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CustomersListLoaded implements CustomersListState {
  const factory CustomersListLoaded({
    required final List<CustomerListRow> allItems,
    required final List<CustomerListRow> filteredItems,
    final String? searchQuery,
    final CustomerActiveFilter activeFilter,
    final bool hasOutstandingOnly,
  }) = _$CustomersListLoadedImpl;

  List<CustomerListRow> get allItems;
  List<CustomerListRow> get filteredItems;
  String? get searchQuery;
  CustomerActiveFilter get activeFilter;
  bool get hasOutstandingOnly;

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomersListLoadedImplCopyWith<_$CustomersListLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CustomersListErrorImplCopyWith<$Res> {
  factory _$$CustomersListErrorImplCopyWith(
    _$CustomersListErrorImpl value,
    $Res Function(_$CustomersListErrorImpl) then,
  ) = __$$CustomersListErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CustomersListErrorImplCopyWithImpl<$Res>
    extends _$CustomersListStateCopyWithImpl<$Res, _$CustomersListErrorImpl>
    implements _$$CustomersListErrorImplCopyWith<$Res> {
  __$$CustomersListErrorImplCopyWithImpl(
    _$CustomersListErrorImpl _value,
    $Res Function(_$CustomersListErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$CustomersListErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CustomersListErrorImpl implements CustomersListError {
  const _$CustomersListErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CustomersListState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomersListErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomersListErrorImplCopyWith<_$CustomersListErrorImpl> get copyWith =>
      __$$CustomersListErrorImplCopyWithImpl<_$CustomersListErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
      List<CustomerListRow> allItems,
      List<CustomerListRow> filteredItems,
      String? searchQuery,
      CustomerActiveFilter activeFilter,
      bool hasOutstandingOnly,
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
    required TResult Function(CustomersListInitial value) initial,
    required TResult Function(CustomersListLoading value) loading,
    required TResult Function(CustomersListLoaded value) loaded,
    required TResult Function(CustomersListError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CustomersListInitial value)? initial,
    TResult? Function(CustomersListLoading value)? loading,
    TResult? Function(CustomersListLoaded value)? loaded,
    TResult? Function(CustomersListError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CustomersListInitial value)? initial,
    TResult Function(CustomersListLoading value)? loading,
    TResult Function(CustomersListLoaded value)? loaded,
    TResult Function(CustomersListError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CustomersListError implements CustomersListState {
  const factory CustomersListError(final String message) =
      _$CustomersListErrorImpl;

  String get message;

  /// Create a copy of CustomersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomersListErrorImplCopyWith<_$CustomersListErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
