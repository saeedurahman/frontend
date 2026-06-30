// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PosState {
  PosSessionState get session => throw _privateConstructorUsedError;
  PosShiftState get shift => throw _privateConstructorUsedError;
  PosCatalogState get catalog => throw _privateConstructorUsedError;
  PosCartState get cart => throw _privateConstructorUsedError;

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosStateCopyWith<PosState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosStateCopyWith<$Res> {
  factory $PosStateCopyWith(PosState value, $Res Function(PosState) then) =
      _$PosStateCopyWithImpl<$Res, PosState>;
  @useResult
  $Res call({
    PosSessionState session,
    PosShiftState shift,
    PosCatalogState catalog,
    PosCartState cart,
  });

  $PosSessionStateCopyWith<$Res> get session;
  $PosShiftStateCopyWith<$Res> get shift;
  $PosCatalogStateCopyWith<$Res> get catalog;
  $PosCartStateCopyWith<$Res> get cart;
}

/// @nodoc
class _$PosStateCopyWithImpl<$Res, $Val extends PosState>
    implements $PosStateCopyWith<$Res> {
  _$PosStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? shift = null,
    Object? catalog = null,
    Object? cart = null,
  }) {
    return _then(
      _value.copyWith(
            session: null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as PosSessionState,
            shift: null == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as PosShiftState,
            catalog: null == catalog
                ? _value.catalog
                : catalog // ignore: cast_nullable_to_non_nullable
                      as PosCatalogState,
            cart: null == cart
                ? _value.cart
                : cart // ignore: cast_nullable_to_non_nullable
                      as PosCartState,
          )
          as $Val,
    );
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PosSessionStateCopyWith<$Res> get session {
    return $PosSessionStateCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PosShiftStateCopyWith<$Res> get shift {
    return $PosShiftStateCopyWith<$Res>(_value.shift, (value) {
      return _then(_value.copyWith(shift: value) as $Val);
    });
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PosCatalogStateCopyWith<$Res> get catalog {
    return $PosCatalogStateCopyWith<$Res>(_value.catalog, (value) {
      return _then(_value.copyWith(catalog: value) as $Val);
    });
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PosCartStateCopyWith<$Res> get cart {
    return $PosCartStateCopyWith<$Res>(_value.cart, (value) {
      return _then(_value.copyWith(cart: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PosStateImplCopyWith<$Res>
    implements $PosStateCopyWith<$Res> {
  factory _$$PosStateImplCopyWith(
    _$PosStateImpl value,
    $Res Function(_$PosStateImpl) then,
  ) = __$$PosStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PosSessionState session,
    PosShiftState shift,
    PosCatalogState catalog,
    PosCartState cart,
  });

  @override
  $PosSessionStateCopyWith<$Res> get session;
  @override
  $PosShiftStateCopyWith<$Res> get shift;
  @override
  $PosCatalogStateCopyWith<$Res> get catalog;
  @override
  $PosCartStateCopyWith<$Res> get cart;
}

/// @nodoc
class __$$PosStateImplCopyWithImpl<$Res>
    extends _$PosStateCopyWithImpl<$Res, _$PosStateImpl>
    implements _$$PosStateImplCopyWith<$Res> {
  __$$PosStateImplCopyWithImpl(
    _$PosStateImpl _value,
    $Res Function(_$PosStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? shift = null,
    Object? catalog = null,
    Object? cart = null,
  }) {
    return _then(
      _$PosStateImpl(
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as PosSessionState,
        shift: null == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as PosShiftState,
        catalog: null == catalog
            ? _value.catalog
            : catalog // ignore: cast_nullable_to_non_nullable
                  as PosCatalogState,
        cart: null == cart
            ? _value.cart
            : cart // ignore: cast_nullable_to_non_nullable
                  as PosCartState,
      ),
    );
  }
}

/// @nodoc

class _$PosStateImpl extends _PosState {
  const _$PosStateImpl({
    this.session = const PosSessionState(),
    this.shift = const PosShiftState(),
    this.catalog = const PosCatalogState(),
    this.cart = const PosCartState(),
  }) : super._();

  @override
  @JsonKey()
  final PosSessionState session;
  @override
  @JsonKey()
  final PosShiftState shift;
  @override
  @JsonKey()
  final PosCatalogState catalog;
  @override
  @JsonKey()
  final PosCartState cart;

  @override
  String toString() {
    return 'PosState(session: $session, shift: $shift, catalog: $catalog, cart: $cart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosStateImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.catalog, catalog) || other.catalog == catalog) &&
            (identical(other.cart, cart) || other.cart == cart));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session, shift, catalog, cart);

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosStateImplCopyWith<_$PosStateImpl> get copyWith =>
      __$$PosStateImplCopyWithImpl<_$PosStateImpl>(this, _$identity);
}

abstract class _PosState extends PosState {
  const factory _PosState({
    final PosSessionState session,
    final PosShiftState shift,
    final PosCatalogState catalog,
    final PosCartState cart,
  }) = _$PosStateImpl;
  const _PosState._() : super._();

  @override
  PosSessionState get session;
  @override
  PosShiftState get shift;
  @override
  PosCatalogState get catalog;
  @override
  PosCartState get cart;

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosStateImplCopyWith<_$PosStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PosSessionState {
  bool get accessDenied => throw _privateConstructorUsedError;
  bool get canOpenShift => throw _privateConstructorUsedError;
  bool get canCloseShift => throw _privateConstructorUsedError;
  String? get cashierName => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  bool get isOffline => throw _privateConstructorUsedError;
  PosDineInContext? get dineIn => throw _privateConstructorUsedError;

  /// Create a copy of PosSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosSessionStateCopyWith<PosSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosSessionStateCopyWith<$Res> {
  factory $PosSessionStateCopyWith(
    PosSessionState value,
    $Res Function(PosSessionState) then,
  ) = _$PosSessionStateCopyWithImpl<$Res, PosSessionState>;
  @useResult
  $Res call({
    bool accessDenied,
    bool canOpenShift,
    bool canCloseShift,
    String? cashierName,
    String? branchId,
    String? businessName,
    bool isOffline,
    PosDineInContext? dineIn,
  });

  $PosDineInContextCopyWith<$Res>? get dineIn;
}

/// @nodoc
class _$PosSessionStateCopyWithImpl<$Res, $Val extends PosSessionState>
    implements $PosSessionStateCopyWith<$Res> {
  _$PosSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessDenied = null,
    Object? canOpenShift = null,
    Object? canCloseShift = null,
    Object? cashierName = freezed,
    Object? branchId = freezed,
    Object? businessName = freezed,
    Object? isOffline = null,
    Object? dineIn = freezed,
  }) {
    return _then(
      _value.copyWith(
            accessDenied: null == accessDenied
                ? _value.accessDenied
                : accessDenied // ignore: cast_nullable_to_non_nullable
                      as bool,
            canOpenShift: null == canOpenShift
                ? _value.canOpenShift
                : canOpenShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            canCloseShift: null == canCloseShift
                ? _value.canCloseShift
                : canCloseShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            cashierName: freezed == cashierName
                ? _value.cashierName
                : cashierName // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            businessName: freezed == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOffline: null == isOffline
                ? _value.isOffline
                : isOffline // ignore: cast_nullable_to_non_nullable
                      as bool,
            dineIn: freezed == dineIn
                ? _value.dineIn
                : dineIn // ignore: cast_nullable_to_non_nullable
                      as PosDineInContext?,
          )
          as $Val,
    );
  }

  /// Create a copy of PosSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PosDineInContextCopyWith<$Res>? get dineIn {
    if (_value.dineIn == null) {
      return null;
    }

    return $PosDineInContextCopyWith<$Res>(_value.dineIn!, (value) {
      return _then(_value.copyWith(dineIn: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PosSessionStateImplCopyWith<$Res>
    implements $PosSessionStateCopyWith<$Res> {
  factory _$$PosSessionStateImplCopyWith(
    _$PosSessionStateImpl value,
    $Res Function(_$PosSessionStateImpl) then,
  ) = __$$PosSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool accessDenied,
    bool canOpenShift,
    bool canCloseShift,
    String? cashierName,
    String? branchId,
    String? businessName,
    bool isOffline,
    PosDineInContext? dineIn,
  });

  @override
  $PosDineInContextCopyWith<$Res>? get dineIn;
}

/// @nodoc
class __$$PosSessionStateImplCopyWithImpl<$Res>
    extends _$PosSessionStateCopyWithImpl<$Res, _$PosSessionStateImpl>
    implements _$$PosSessionStateImplCopyWith<$Res> {
  __$$PosSessionStateImplCopyWithImpl(
    _$PosSessionStateImpl _value,
    $Res Function(_$PosSessionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessDenied = null,
    Object? canOpenShift = null,
    Object? canCloseShift = null,
    Object? cashierName = freezed,
    Object? branchId = freezed,
    Object? businessName = freezed,
    Object? isOffline = null,
    Object? dineIn = freezed,
  }) {
    return _then(
      _$PosSessionStateImpl(
        accessDenied: null == accessDenied
            ? _value.accessDenied
            : accessDenied // ignore: cast_nullable_to_non_nullable
                  as bool,
        canOpenShift: null == canOpenShift
            ? _value.canOpenShift
            : canOpenShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        canCloseShift: null == canCloseShift
            ? _value.canCloseShift
            : canCloseShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        cashierName: freezed == cashierName
            ? _value.cashierName
            : cashierName // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        businessName: freezed == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOffline: null == isOffline
            ? _value.isOffline
            : isOffline // ignore: cast_nullable_to_non_nullable
                  as bool,
        dineIn: freezed == dineIn
            ? _value.dineIn
            : dineIn // ignore: cast_nullable_to_non_nullable
                  as PosDineInContext?,
      ),
    );
  }
}

/// @nodoc

class _$PosSessionStateImpl implements _PosSessionState {
  const _$PosSessionStateImpl({
    this.accessDenied = false,
    this.canOpenShift = false,
    this.canCloseShift = false,
    this.cashierName,
    this.branchId,
    this.businessName,
    this.isOffline = false,
    this.dineIn,
  });

  @override
  @JsonKey()
  final bool accessDenied;
  @override
  @JsonKey()
  final bool canOpenShift;
  @override
  @JsonKey()
  final bool canCloseShift;
  @override
  final String? cashierName;
  @override
  final String? branchId;
  @override
  final String? businessName;
  @override
  @JsonKey()
  final bool isOffline;
  @override
  final PosDineInContext? dineIn;

  @override
  String toString() {
    return 'PosSessionState(accessDenied: $accessDenied, canOpenShift: $canOpenShift, canCloseShift: $canCloseShift, cashierName: $cashierName, branchId: $branchId, businessName: $businessName, isOffline: $isOffline, dineIn: $dineIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosSessionStateImpl &&
            (identical(other.accessDenied, accessDenied) ||
                other.accessDenied == accessDenied) &&
            (identical(other.canOpenShift, canOpenShift) ||
                other.canOpenShift == canOpenShift) &&
            (identical(other.canCloseShift, canCloseShift) ||
                other.canCloseShift == canCloseShift) &&
            (identical(other.cashierName, cashierName) ||
                other.cashierName == cashierName) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.dineIn, dineIn) || other.dineIn == dineIn));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessDenied,
    canOpenShift,
    canCloseShift,
    cashierName,
    branchId,
    businessName,
    isOffline,
    dineIn,
  );

  /// Create a copy of PosSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosSessionStateImplCopyWith<_$PosSessionStateImpl> get copyWith =>
      __$$PosSessionStateImplCopyWithImpl<_$PosSessionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PosSessionState implements PosSessionState {
  const factory _PosSessionState({
    final bool accessDenied,
    final bool canOpenShift,
    final bool canCloseShift,
    final String? cashierName,
    final String? branchId,
    final String? businessName,
    final bool isOffline,
    final PosDineInContext? dineIn,
  }) = _$PosSessionStateImpl;

  @override
  bool get accessDenied;
  @override
  bool get canOpenShift;
  @override
  bool get canCloseShift;
  @override
  String? get cashierName;
  @override
  String? get branchId;
  @override
  String? get businessName;
  @override
  bool get isOffline;
  @override
  PosDineInContext? get dineIn;

  /// Create a copy of PosSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosSessionStateImplCopyWith<_$PosSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PosDineInContext {
  String get saleId => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  String get tableLabel => throw _privateConstructorUsedError;
  DineInTabStatus get tabStatus => throw _privateConstructorUsedError;
  bool get isSyncingLine => throw _privateConstructorUsedError;
  String? get syncError => throw _privateConstructorUsedError;

  /// Create a copy of PosDineInContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosDineInContextCopyWith<PosDineInContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosDineInContextCopyWith<$Res> {
  factory $PosDineInContextCopyWith(
    PosDineInContext value,
    $Res Function(PosDineInContext) then,
  ) = _$PosDineInContextCopyWithImpl<$Res, PosDineInContext>;
  @useResult
  $Res call({
    String saleId,
    String tableId,
    String tableLabel,
    DineInTabStatus tabStatus,
    bool isSyncingLine,
    String? syncError,
  });
}

/// @nodoc
class _$PosDineInContextCopyWithImpl<$Res, $Val extends PosDineInContext>
    implements $PosDineInContextCopyWith<$Res> {
  _$PosDineInContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosDineInContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saleId = null,
    Object? tableId = null,
    Object? tableLabel = null,
    Object? tabStatus = null,
    Object? isSyncingLine = null,
    Object? syncError = freezed,
  }) {
    return _then(
      _value.copyWith(
            saleId: null == saleId
                ? _value.saleId
                : saleId // ignore: cast_nullable_to_non_nullable
                      as String,
            tableId: null == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String,
            tableLabel: null == tableLabel
                ? _value.tableLabel
                : tableLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            tabStatus: null == tabStatus
                ? _value.tabStatus
                : tabStatus // ignore: cast_nullable_to_non_nullable
                      as DineInTabStatus,
            isSyncingLine: null == isSyncingLine
                ? _value.isSyncingLine
                : isSyncingLine // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncError: freezed == syncError
                ? _value.syncError
                : syncError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PosDineInContextImplCopyWith<$Res>
    implements $PosDineInContextCopyWith<$Res> {
  factory _$$PosDineInContextImplCopyWith(
    _$PosDineInContextImpl value,
    $Res Function(_$PosDineInContextImpl) then,
  ) = __$$PosDineInContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String saleId,
    String tableId,
    String tableLabel,
    DineInTabStatus tabStatus,
    bool isSyncingLine,
    String? syncError,
  });
}

/// @nodoc
class __$$PosDineInContextImplCopyWithImpl<$Res>
    extends _$PosDineInContextCopyWithImpl<$Res, _$PosDineInContextImpl>
    implements _$$PosDineInContextImplCopyWith<$Res> {
  __$$PosDineInContextImplCopyWithImpl(
    _$PosDineInContextImpl _value,
    $Res Function(_$PosDineInContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosDineInContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saleId = null,
    Object? tableId = null,
    Object? tableLabel = null,
    Object? tabStatus = null,
    Object? isSyncingLine = null,
    Object? syncError = freezed,
  }) {
    return _then(
      _$PosDineInContextImpl(
        saleId: null == saleId
            ? _value.saleId
            : saleId // ignore: cast_nullable_to_non_nullable
                  as String,
        tableId: null == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String,
        tableLabel: null == tableLabel
            ? _value.tableLabel
            : tableLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        tabStatus: null == tabStatus
            ? _value.tabStatus
            : tabStatus // ignore: cast_nullable_to_non_nullable
                  as DineInTabStatus,
        isSyncingLine: null == isSyncingLine
            ? _value.isSyncingLine
            : isSyncingLine // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncError: freezed == syncError
            ? _value.syncError
            : syncError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PosDineInContextImpl extends _PosDineInContext {
  const _$PosDineInContextImpl({
    required this.saleId,
    required this.tableId,
    required this.tableLabel,
    this.tabStatus = DineInTabStatus.open,
    this.isSyncingLine = false,
    this.syncError,
  }) : super._();

  @override
  final String saleId;
  @override
  final String tableId;
  @override
  final String tableLabel;
  @override
  @JsonKey()
  final DineInTabStatus tabStatus;
  @override
  @JsonKey()
  final bool isSyncingLine;
  @override
  final String? syncError;

  @override
  String toString() {
    return 'PosDineInContext(saleId: $saleId, tableId: $tableId, tableLabel: $tableLabel, tabStatus: $tabStatus, isSyncingLine: $isSyncingLine, syncError: $syncError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosDineInContextImpl &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.tableLabel, tableLabel) ||
                other.tableLabel == tableLabel) &&
            (identical(other.tabStatus, tabStatus) ||
                other.tabStatus == tabStatus) &&
            (identical(other.isSyncingLine, isSyncingLine) ||
                other.isSyncingLine == isSyncingLine) &&
            (identical(other.syncError, syncError) ||
                other.syncError == syncError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    saleId,
    tableId,
    tableLabel,
    tabStatus,
    isSyncingLine,
    syncError,
  );

  /// Create a copy of PosDineInContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosDineInContextImplCopyWith<_$PosDineInContextImpl> get copyWith =>
      __$$PosDineInContextImplCopyWithImpl<_$PosDineInContextImpl>(
        this,
        _$identity,
      );
}

abstract class _PosDineInContext extends PosDineInContext {
  const factory _PosDineInContext({
    required final String saleId,
    required final String tableId,
    required final String tableLabel,
    final DineInTabStatus tabStatus,
    final bool isSyncingLine,
    final String? syncError,
  }) = _$PosDineInContextImpl;
  const _PosDineInContext._() : super._();

  @override
  String get saleId;
  @override
  String get tableId;
  @override
  String get tableLabel;
  @override
  DineInTabStatus get tabStatus;
  @override
  bool get isSyncingLine;
  @override
  String? get syncError;

  /// Create a copy of PosDineInContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosDineInContextImplCopyWith<_$PosDineInContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PosShiftState {
  RegisterShiftModel? get activeShift => throw _privateConstructorUsedError;
  ShiftSummaryModel? get shiftSummary => throw _privateConstructorUsedError;
  List<CashRegisterModel> get registers => throw _privateConstructorUsedError;
  String? get selectedRegisterId => throw _privateConstructorUsedError;
  bool get isCheckingShift => throw _privateConstructorUsedError;
  bool get isOpeningShift => throw _privateConstructorUsedError;
  bool get isCreatingRegister => throw _privateConstructorUsedError;
  String? get registersError => throw _privateConstructorUsedError;

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosShiftStateCopyWith<PosShiftState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosShiftStateCopyWith<$Res> {
  factory $PosShiftStateCopyWith(
    PosShiftState value,
    $Res Function(PosShiftState) then,
  ) = _$PosShiftStateCopyWithImpl<$Res, PosShiftState>;
  @useResult
  $Res call({
    RegisterShiftModel? activeShift,
    ShiftSummaryModel? shiftSummary,
    List<CashRegisterModel> registers,
    String? selectedRegisterId,
    bool isCheckingShift,
    bool isOpeningShift,
    bool isCreatingRegister,
    String? registersError,
  });

  $RegisterShiftModelCopyWith<$Res>? get activeShift;
  $ShiftSummaryModelCopyWith<$Res>? get shiftSummary;
}

/// @nodoc
class _$PosShiftStateCopyWithImpl<$Res, $Val extends PosShiftState>
    implements $PosShiftStateCopyWith<$Res> {
  _$PosShiftStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeShift = freezed,
    Object? shiftSummary = freezed,
    Object? registers = null,
    Object? selectedRegisterId = freezed,
    Object? isCheckingShift = null,
    Object? isOpeningShift = null,
    Object? isCreatingRegister = null,
    Object? registersError = freezed,
  }) {
    return _then(
      _value.copyWith(
            activeShift: freezed == activeShift
                ? _value.activeShift
                : activeShift // ignore: cast_nullable_to_non_nullable
                      as RegisterShiftModel?,
            shiftSummary: freezed == shiftSummary
                ? _value.shiftSummary
                : shiftSummary // ignore: cast_nullable_to_non_nullable
                      as ShiftSummaryModel?,
            registers: null == registers
                ? _value.registers
                : registers // ignore: cast_nullable_to_non_nullable
                      as List<CashRegisterModel>,
            selectedRegisterId: freezed == selectedRegisterId
                ? _value.selectedRegisterId
                : selectedRegisterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCheckingShift: null == isCheckingShift
                ? _value.isCheckingShift
                : isCheckingShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            isOpeningShift: null == isOpeningShift
                ? _value.isOpeningShift
                : isOpeningShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCreatingRegister: null == isCreatingRegister
                ? _value.isCreatingRegister
                : isCreatingRegister // ignore: cast_nullable_to_non_nullable
                      as bool,
            registersError: freezed == registersError
                ? _value.registersError
                : registersError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterShiftModelCopyWith<$Res>? get activeShift {
    if (_value.activeShift == null) {
      return null;
    }

    return $RegisterShiftModelCopyWith<$Res>(_value.activeShift!, (value) {
      return _then(_value.copyWith(activeShift: value) as $Val);
    });
  }

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftSummaryModelCopyWith<$Res>? get shiftSummary {
    if (_value.shiftSummary == null) {
      return null;
    }

    return $ShiftSummaryModelCopyWith<$Res>(_value.shiftSummary!, (value) {
      return _then(_value.copyWith(shiftSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PosShiftStateImplCopyWith<$Res>
    implements $PosShiftStateCopyWith<$Res> {
  factory _$$PosShiftStateImplCopyWith(
    _$PosShiftStateImpl value,
    $Res Function(_$PosShiftStateImpl) then,
  ) = __$$PosShiftStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RegisterShiftModel? activeShift,
    ShiftSummaryModel? shiftSummary,
    List<CashRegisterModel> registers,
    String? selectedRegisterId,
    bool isCheckingShift,
    bool isOpeningShift,
    bool isCreatingRegister,
    String? registersError,
  });

  @override
  $RegisterShiftModelCopyWith<$Res>? get activeShift;
  @override
  $ShiftSummaryModelCopyWith<$Res>? get shiftSummary;
}

/// @nodoc
class __$$PosShiftStateImplCopyWithImpl<$Res>
    extends _$PosShiftStateCopyWithImpl<$Res, _$PosShiftStateImpl>
    implements _$$PosShiftStateImplCopyWith<$Res> {
  __$$PosShiftStateImplCopyWithImpl(
    _$PosShiftStateImpl _value,
    $Res Function(_$PosShiftStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeShift = freezed,
    Object? shiftSummary = freezed,
    Object? registers = null,
    Object? selectedRegisterId = freezed,
    Object? isCheckingShift = null,
    Object? isOpeningShift = null,
    Object? isCreatingRegister = null,
    Object? registersError = freezed,
  }) {
    return _then(
      _$PosShiftStateImpl(
        activeShift: freezed == activeShift
            ? _value.activeShift
            : activeShift // ignore: cast_nullable_to_non_nullable
                  as RegisterShiftModel?,
        shiftSummary: freezed == shiftSummary
            ? _value.shiftSummary
            : shiftSummary // ignore: cast_nullable_to_non_nullable
                  as ShiftSummaryModel?,
        registers: null == registers
            ? _value._registers
            : registers // ignore: cast_nullable_to_non_nullable
                  as List<CashRegisterModel>,
        selectedRegisterId: freezed == selectedRegisterId
            ? _value.selectedRegisterId
            : selectedRegisterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCheckingShift: null == isCheckingShift
            ? _value.isCheckingShift
            : isCheckingShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOpeningShift: null == isOpeningShift
            ? _value.isOpeningShift
            : isOpeningShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCreatingRegister: null == isCreatingRegister
            ? _value.isCreatingRegister
            : isCreatingRegister // ignore: cast_nullable_to_non_nullable
                  as bool,
        registersError: freezed == registersError
            ? _value.registersError
            : registersError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PosShiftStateImpl implements _PosShiftState {
  const _$PosShiftStateImpl({
    this.activeShift,
    this.shiftSummary,
    final List<CashRegisterModel> registers = const [],
    this.selectedRegisterId,
    this.isCheckingShift = true,
    this.isOpeningShift = false,
    this.isCreatingRegister = false,
    this.registersError,
  }) : _registers = registers;

  @override
  final RegisterShiftModel? activeShift;
  @override
  final ShiftSummaryModel? shiftSummary;
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
  final bool isCheckingShift;
  @override
  @JsonKey()
  final bool isOpeningShift;
  @override
  @JsonKey()
  final bool isCreatingRegister;
  @override
  final String? registersError;

  @override
  String toString() {
    return 'PosShiftState(activeShift: $activeShift, shiftSummary: $shiftSummary, registers: $registers, selectedRegisterId: $selectedRegisterId, isCheckingShift: $isCheckingShift, isOpeningShift: $isOpeningShift, isCreatingRegister: $isCreatingRegister, registersError: $registersError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosShiftStateImpl &&
            (identical(other.activeShift, activeShift) ||
                other.activeShift == activeShift) &&
            (identical(other.shiftSummary, shiftSummary) ||
                other.shiftSummary == shiftSummary) &&
            const DeepCollectionEquality().equals(
              other._registers,
              _registers,
            ) &&
            (identical(other.selectedRegisterId, selectedRegisterId) ||
                other.selectedRegisterId == selectedRegisterId) &&
            (identical(other.isCheckingShift, isCheckingShift) ||
                other.isCheckingShift == isCheckingShift) &&
            (identical(other.isOpeningShift, isOpeningShift) ||
                other.isOpeningShift == isOpeningShift) &&
            (identical(other.isCreatingRegister, isCreatingRegister) ||
                other.isCreatingRegister == isCreatingRegister) &&
            (identical(other.registersError, registersError) ||
                other.registersError == registersError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activeShift,
    shiftSummary,
    const DeepCollectionEquality().hash(_registers),
    selectedRegisterId,
    isCheckingShift,
    isOpeningShift,
    isCreatingRegister,
    registersError,
  );

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosShiftStateImplCopyWith<_$PosShiftStateImpl> get copyWith =>
      __$$PosShiftStateImplCopyWithImpl<_$PosShiftStateImpl>(this, _$identity);
}

abstract class _PosShiftState implements PosShiftState {
  const factory _PosShiftState({
    final RegisterShiftModel? activeShift,
    final ShiftSummaryModel? shiftSummary,
    final List<CashRegisterModel> registers,
    final String? selectedRegisterId,
    final bool isCheckingShift,
    final bool isOpeningShift,
    final bool isCreatingRegister,
    final String? registersError,
  }) = _$PosShiftStateImpl;

  @override
  RegisterShiftModel? get activeShift;
  @override
  ShiftSummaryModel? get shiftSummary;
  @override
  List<CashRegisterModel> get registers;
  @override
  String? get selectedRegisterId;
  @override
  bool get isCheckingShift;
  @override
  bool get isOpeningShift;
  @override
  bool get isCreatingRegister;
  @override
  String? get registersError;

  /// Create a copy of PosShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosShiftStateImplCopyWith<_$PosShiftStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PosCatalogState {
  List<ProductListItemModel> get products => throw _privateConstructorUsedError;
  List<CategoryModel> get categories => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;
  String get productSearchQuery => throw _privateConstructorUsedError;
  bool get isLoadingProducts => throw _privateConstructorUsedError;
  String? get productsError => throw _privateConstructorUsedError;
  Map<String, String> get priceCache => throw _privateConstructorUsedError;
  Map<String, String> get stockCache => throw _privateConstructorUsedError;
  Map<String, ProductModel> get productDetailsCache =>
      throw _privateConstructorUsedError;

  /// Create a copy of PosCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosCatalogStateCopyWith<PosCatalogState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosCatalogStateCopyWith<$Res> {
  factory $PosCatalogStateCopyWith(
    PosCatalogState value,
    $Res Function(PosCatalogState) then,
  ) = _$PosCatalogStateCopyWithImpl<$Res, PosCatalogState>;
  @useResult
  $Res call({
    List<ProductListItemModel> products,
    List<CategoryModel> categories,
    String? selectedCategoryId,
    String productSearchQuery,
    bool isLoadingProducts,
    String? productsError,
    Map<String, String> priceCache,
    Map<String, String> stockCache,
    Map<String, ProductModel> productDetailsCache,
  });
}

/// @nodoc
class _$PosCatalogStateCopyWithImpl<$Res, $Val extends PosCatalogState>
    implements $PosCatalogStateCopyWith<$Res> {
  _$PosCatalogStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? categories = null,
    Object? selectedCategoryId = freezed,
    Object? productSearchQuery = null,
    Object? isLoadingProducts = null,
    Object? productsError = freezed,
    Object? priceCache = null,
    Object? stockCache = null,
    Object? productDetailsCache = null,
  }) {
    return _then(
      _value.copyWith(
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<ProductListItemModel>,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<CategoryModel>,
            selectedCategoryId: freezed == selectedCategoryId
                ? _value.selectedCategoryId
                : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            productSearchQuery: null == productSearchQuery
                ? _value.productSearchQuery
                : productSearchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            isLoadingProducts: null == isLoadingProducts
                ? _value.isLoadingProducts
                : isLoadingProducts // ignore: cast_nullable_to_non_nullable
                      as bool,
            productsError: freezed == productsError
                ? _value.productsError
                : productsError // ignore: cast_nullable_to_non_nullable
                      as String?,
            priceCache: null == priceCache
                ? _value.priceCache
                : priceCache // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            stockCache: null == stockCache
                ? _value.stockCache
                : stockCache // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            productDetailsCache: null == productDetailsCache
                ? _value.productDetailsCache
                : productDetailsCache // ignore: cast_nullable_to_non_nullable
                      as Map<String, ProductModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PosCatalogStateImplCopyWith<$Res>
    implements $PosCatalogStateCopyWith<$Res> {
  factory _$$PosCatalogStateImplCopyWith(
    _$PosCatalogStateImpl value,
    $Res Function(_$PosCatalogStateImpl) then,
  ) = __$$PosCatalogStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ProductListItemModel> products,
    List<CategoryModel> categories,
    String? selectedCategoryId,
    String productSearchQuery,
    bool isLoadingProducts,
    String? productsError,
    Map<String, String> priceCache,
    Map<String, String> stockCache,
    Map<String, ProductModel> productDetailsCache,
  });
}

/// @nodoc
class __$$PosCatalogStateImplCopyWithImpl<$Res>
    extends _$PosCatalogStateCopyWithImpl<$Res, _$PosCatalogStateImpl>
    implements _$$PosCatalogStateImplCopyWith<$Res> {
  __$$PosCatalogStateImplCopyWithImpl(
    _$PosCatalogStateImpl _value,
    $Res Function(_$PosCatalogStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? categories = null,
    Object? selectedCategoryId = freezed,
    Object? productSearchQuery = null,
    Object? isLoadingProducts = null,
    Object? productsError = freezed,
    Object? priceCache = null,
    Object? stockCache = null,
    Object? productDetailsCache = null,
  }) {
    return _then(
      _$PosCatalogStateImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<ProductListItemModel>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
        selectedCategoryId: freezed == selectedCategoryId
            ? _value.selectedCategoryId
            : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        productSearchQuery: null == productSearchQuery
            ? _value.productSearchQuery
            : productSearchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        isLoadingProducts: null == isLoadingProducts
            ? _value.isLoadingProducts
            : isLoadingProducts // ignore: cast_nullable_to_non_nullable
                  as bool,
        productsError: freezed == productsError
            ? _value.productsError
            : productsError // ignore: cast_nullable_to_non_nullable
                  as String?,
        priceCache: null == priceCache
            ? _value._priceCache
            : priceCache // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        stockCache: null == stockCache
            ? _value._stockCache
            : stockCache // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        productDetailsCache: null == productDetailsCache
            ? _value._productDetailsCache
            : productDetailsCache // ignore: cast_nullable_to_non_nullable
                  as Map<String, ProductModel>,
      ),
    );
  }
}

/// @nodoc

class _$PosCatalogStateImpl implements _PosCatalogState {
  const _$PosCatalogStateImpl({
    final List<ProductListItemModel> products = const [],
    final List<CategoryModel> categories = const [],
    this.selectedCategoryId,
    this.productSearchQuery = '',
    this.isLoadingProducts = true,
    this.productsError,
    final Map<String, String> priceCache = const {},
    final Map<String, String> stockCache = const {},
    final Map<String, ProductModel> productDetailsCache = const {},
  }) : _products = products,
       _categories = categories,
       _priceCache = priceCache,
       _stockCache = stockCache,
       _productDetailsCache = productDetailsCache;

  final List<ProductListItemModel> _products;
  @override
  @JsonKey()
  List<ProductListItemModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<CategoryModel> _categories;
  @override
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? selectedCategoryId;
  @override
  @JsonKey()
  final String productSearchQuery;
  @override
  @JsonKey()
  final bool isLoadingProducts;
  @override
  final String? productsError;
  final Map<String, String> _priceCache;
  @override
  @JsonKey()
  Map<String, String> get priceCache {
    if (_priceCache is EqualUnmodifiableMapView) return _priceCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_priceCache);
  }

  final Map<String, String> _stockCache;
  @override
  @JsonKey()
  Map<String, String> get stockCache {
    if (_stockCache is EqualUnmodifiableMapView) return _stockCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stockCache);
  }

  final Map<String, ProductModel> _productDetailsCache;
  @override
  @JsonKey()
  Map<String, ProductModel> get productDetailsCache {
    if (_productDetailsCache is EqualUnmodifiableMapView)
      return _productDetailsCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_productDetailsCache);
  }

  @override
  String toString() {
    return 'PosCatalogState(products: $products, categories: $categories, selectedCategoryId: $selectedCategoryId, productSearchQuery: $productSearchQuery, isLoadingProducts: $isLoadingProducts, productsError: $productsError, priceCache: $priceCache, stockCache: $stockCache, productDetailsCache: $productDetailsCache)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosCatalogStateImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.productSearchQuery, productSearchQuery) ||
                other.productSearchQuery == productSearchQuery) &&
            (identical(other.isLoadingProducts, isLoadingProducts) ||
                other.isLoadingProducts == isLoadingProducts) &&
            (identical(other.productsError, productsError) ||
                other.productsError == productsError) &&
            const DeepCollectionEquality().equals(
              other._priceCache,
              _priceCache,
            ) &&
            const DeepCollectionEquality().equals(
              other._stockCache,
              _stockCache,
            ) &&
            const DeepCollectionEquality().equals(
              other._productDetailsCache,
              _productDetailsCache,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    const DeepCollectionEquality().hash(_categories),
    selectedCategoryId,
    productSearchQuery,
    isLoadingProducts,
    productsError,
    const DeepCollectionEquality().hash(_priceCache),
    const DeepCollectionEquality().hash(_stockCache),
    const DeepCollectionEquality().hash(_productDetailsCache),
  );

  /// Create a copy of PosCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosCatalogStateImplCopyWith<_$PosCatalogStateImpl> get copyWith =>
      __$$PosCatalogStateImplCopyWithImpl<_$PosCatalogStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PosCatalogState implements PosCatalogState {
  const factory _PosCatalogState({
    final List<ProductListItemModel> products,
    final List<CategoryModel> categories,
    final String? selectedCategoryId,
    final String productSearchQuery,
    final bool isLoadingProducts,
    final String? productsError,
    final Map<String, String> priceCache,
    final Map<String, String> stockCache,
    final Map<String, ProductModel> productDetailsCache,
  }) = _$PosCatalogStateImpl;

  @override
  List<ProductListItemModel> get products;
  @override
  List<CategoryModel> get categories;
  @override
  String? get selectedCategoryId;
  @override
  String get productSearchQuery;
  @override
  bool get isLoadingProducts;
  @override
  String? get productsError;
  @override
  Map<String, String> get priceCache;
  @override
  Map<String, String> get stockCache;
  @override
  Map<String, ProductModel> get productDetailsCache;

  /// Create a copy of PosCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosCatalogStateImplCopyWith<_$PosCatalogStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PosCartState {
  List<CartItemModel> get cartItems => throw _privateConstructorUsedError;
  List<TaxRateModel> get taxRates => throw _privateConstructorUsedError;
  TaxRateModel? get defaultTaxRate => throw _privateConstructorUsedError;
  CustomerModel? get selectedCustomer => throw _privateConstructorUsedError;
  String? get cartDiscountType => throw _privateConstructorUsedError;
  String? get cartDiscountValue => throw _privateConstructorUsedError;
  String? get cartNote => throw _privateConstructorUsedError;
  List<HeldOrderModel> get heldOrders => throw _privateConstructorUsedError;
  bool get isHoldingSale => throw _privateConstructorUsedError;
  bool get isSubmittingSale => throw _privateConstructorUsedError;
  bool get isFiringTab => throw _privateConstructorUsedError;
  bool get isRequestingBill => throw _privateConstructorUsedError;
  String? get selectedDiscountSchemeId => throw _privateConstructorUsedError;
  List<DiscountSchemeModel> get discountSchemes =>
      throw _privateConstructorUsedError;
  SalePricePreviewModel? get pricePreview => throw _privateConstructorUsedError;
  bool get isLoadingPricePreview => throw _privateConstructorUsedError;
  String? get pricePreviewError => throw _privateConstructorUsedError;

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosCartStateCopyWith<PosCartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosCartStateCopyWith<$Res> {
  factory $PosCartStateCopyWith(
    PosCartState value,
    $Res Function(PosCartState) then,
  ) = _$PosCartStateCopyWithImpl<$Res, PosCartState>;
  @useResult
  $Res call({
    List<CartItemModel> cartItems,
    List<TaxRateModel> taxRates,
    TaxRateModel? defaultTaxRate,
    CustomerModel? selectedCustomer,
    String? cartDiscountType,
    String? cartDiscountValue,
    String? cartNote,
    List<HeldOrderModel> heldOrders,
    bool isHoldingSale,
    bool isSubmittingSale,
    bool isFiringTab,
    bool isRequestingBill,
    String? selectedDiscountSchemeId,
    List<DiscountSchemeModel> discountSchemes,
    SalePricePreviewModel? pricePreview,
    bool isLoadingPricePreview,
    String? pricePreviewError,
  });

  $TaxRateModelCopyWith<$Res>? get defaultTaxRate;
  $CustomerModelCopyWith<$Res>? get selectedCustomer;
  $SalePricePreviewModelCopyWith<$Res>? get pricePreview;
}

/// @nodoc
class _$PosCartStateCopyWithImpl<$Res, $Val extends PosCartState>
    implements $PosCartStateCopyWith<$Res> {
  _$PosCartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartItems = null,
    Object? taxRates = null,
    Object? defaultTaxRate = freezed,
    Object? selectedCustomer = freezed,
    Object? cartDiscountType = freezed,
    Object? cartDiscountValue = freezed,
    Object? cartNote = freezed,
    Object? heldOrders = null,
    Object? isHoldingSale = null,
    Object? isSubmittingSale = null,
    Object? isFiringTab = null,
    Object? isRequestingBill = null,
    Object? selectedDiscountSchemeId = freezed,
    Object? discountSchemes = null,
    Object? pricePreview = freezed,
    Object? isLoadingPricePreview = null,
    Object? pricePreviewError = freezed,
  }) {
    return _then(
      _value.copyWith(
            cartItems: null == cartItems
                ? _value.cartItems
                : cartItems // ignore: cast_nullable_to_non_nullable
                      as List<CartItemModel>,
            taxRates: null == taxRates
                ? _value.taxRates
                : taxRates // ignore: cast_nullable_to_non_nullable
                      as List<TaxRateModel>,
            defaultTaxRate: freezed == defaultTaxRate
                ? _value.defaultTaxRate
                : defaultTaxRate // ignore: cast_nullable_to_non_nullable
                      as TaxRateModel?,
            selectedCustomer: freezed == selectedCustomer
                ? _value.selectedCustomer
                : selectedCustomer // ignore: cast_nullable_to_non_nullable
                      as CustomerModel?,
            cartDiscountType: freezed == cartDiscountType
                ? _value.cartDiscountType
                : cartDiscountType // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartDiscountValue: freezed == cartDiscountValue
                ? _value.cartDiscountValue
                : cartDiscountValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartNote: freezed == cartNote
                ? _value.cartNote
                : cartNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            heldOrders: null == heldOrders
                ? _value.heldOrders
                : heldOrders // ignore: cast_nullable_to_non_nullable
                      as List<HeldOrderModel>,
            isHoldingSale: null == isHoldingSale
                ? _value.isHoldingSale
                : isHoldingSale // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmittingSale: null == isSubmittingSale
                ? _value.isSubmittingSale
                : isSubmittingSale // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFiringTab: null == isFiringTab
                ? _value.isFiringTab
                : isFiringTab // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRequestingBill: null == isRequestingBill
                ? _value.isRequestingBill
                : isRequestingBill // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedDiscountSchemeId: freezed == selectedDiscountSchemeId
                ? _value.selectedDiscountSchemeId
                : selectedDiscountSchemeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountSchemes: null == discountSchemes
                ? _value.discountSchemes
                : discountSchemes // ignore: cast_nullable_to_non_nullable
                      as List<DiscountSchemeModel>,
            pricePreview: freezed == pricePreview
                ? _value.pricePreview
                : pricePreview // ignore: cast_nullable_to_non_nullable
                      as SalePricePreviewModel?,
            isLoadingPricePreview: null == isLoadingPricePreview
                ? _value.isLoadingPricePreview
                : isLoadingPricePreview // ignore: cast_nullable_to_non_nullable
                      as bool,
            pricePreviewError: freezed == pricePreviewError
                ? _value.pricePreviewError
                : pricePreviewError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaxRateModelCopyWith<$Res>? get defaultTaxRate {
    if (_value.defaultTaxRate == null) {
      return null;
    }

    return $TaxRateModelCopyWith<$Res>(_value.defaultTaxRate!, (value) {
      return _then(_value.copyWith(defaultTaxRate: value) as $Val);
    });
  }

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get selectedCustomer {
    if (_value.selectedCustomer == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.selectedCustomer!, (value) {
      return _then(_value.copyWith(selectedCustomer: value) as $Val);
    });
  }

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalePricePreviewModelCopyWith<$Res>? get pricePreview {
    if (_value.pricePreview == null) {
      return null;
    }

    return $SalePricePreviewModelCopyWith<$Res>(_value.pricePreview!, (value) {
      return _then(_value.copyWith(pricePreview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PosCartStateImplCopyWith<$Res>
    implements $PosCartStateCopyWith<$Res> {
  factory _$$PosCartStateImplCopyWith(
    _$PosCartStateImpl value,
    $Res Function(_$PosCartStateImpl) then,
  ) = __$$PosCartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CartItemModel> cartItems,
    List<TaxRateModel> taxRates,
    TaxRateModel? defaultTaxRate,
    CustomerModel? selectedCustomer,
    String? cartDiscountType,
    String? cartDiscountValue,
    String? cartNote,
    List<HeldOrderModel> heldOrders,
    bool isHoldingSale,
    bool isSubmittingSale,
    bool isFiringTab,
    bool isRequestingBill,
    String? selectedDiscountSchemeId,
    List<DiscountSchemeModel> discountSchemes,
    SalePricePreviewModel? pricePreview,
    bool isLoadingPricePreview,
    String? pricePreviewError,
  });

  @override
  $TaxRateModelCopyWith<$Res>? get defaultTaxRate;
  @override
  $CustomerModelCopyWith<$Res>? get selectedCustomer;
  @override
  $SalePricePreviewModelCopyWith<$Res>? get pricePreview;
}

/// @nodoc
class __$$PosCartStateImplCopyWithImpl<$Res>
    extends _$PosCartStateCopyWithImpl<$Res, _$PosCartStateImpl>
    implements _$$PosCartStateImplCopyWith<$Res> {
  __$$PosCartStateImplCopyWithImpl(
    _$PosCartStateImpl _value,
    $Res Function(_$PosCartStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartItems = null,
    Object? taxRates = null,
    Object? defaultTaxRate = freezed,
    Object? selectedCustomer = freezed,
    Object? cartDiscountType = freezed,
    Object? cartDiscountValue = freezed,
    Object? cartNote = freezed,
    Object? heldOrders = null,
    Object? isHoldingSale = null,
    Object? isSubmittingSale = null,
    Object? isFiringTab = null,
    Object? isRequestingBill = null,
    Object? selectedDiscountSchemeId = freezed,
    Object? discountSchemes = null,
    Object? pricePreview = freezed,
    Object? isLoadingPricePreview = null,
    Object? pricePreviewError = freezed,
  }) {
    return _then(
      _$PosCartStateImpl(
        cartItems: null == cartItems
            ? _value._cartItems
            : cartItems // ignore: cast_nullable_to_non_nullable
                  as List<CartItemModel>,
        taxRates: null == taxRates
            ? _value._taxRates
            : taxRates // ignore: cast_nullable_to_non_nullable
                  as List<TaxRateModel>,
        defaultTaxRate: freezed == defaultTaxRate
            ? _value.defaultTaxRate
            : defaultTaxRate // ignore: cast_nullable_to_non_nullable
                  as TaxRateModel?,
        selectedCustomer: freezed == selectedCustomer
            ? _value.selectedCustomer
            : selectedCustomer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel?,
        cartDiscountType: freezed == cartDiscountType
            ? _value.cartDiscountType
            : cartDiscountType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartDiscountValue: freezed == cartDiscountValue
            ? _value.cartDiscountValue
            : cartDiscountValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartNote: freezed == cartNote
            ? _value.cartNote
            : cartNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        heldOrders: null == heldOrders
            ? _value._heldOrders
            : heldOrders // ignore: cast_nullable_to_non_nullable
                  as List<HeldOrderModel>,
        isHoldingSale: null == isHoldingSale
            ? _value.isHoldingSale
            : isHoldingSale // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmittingSale: null == isSubmittingSale
            ? _value.isSubmittingSale
            : isSubmittingSale // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFiringTab: null == isFiringTab
            ? _value.isFiringTab
            : isFiringTab // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRequestingBill: null == isRequestingBill
            ? _value.isRequestingBill
            : isRequestingBill // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedDiscountSchemeId: freezed == selectedDiscountSchemeId
            ? _value.selectedDiscountSchemeId
            : selectedDiscountSchemeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountSchemes: null == discountSchemes
            ? _value._discountSchemes
            : discountSchemes // ignore: cast_nullable_to_non_nullable
                  as List<DiscountSchemeModel>,
        pricePreview: freezed == pricePreview
            ? _value.pricePreview
            : pricePreview // ignore: cast_nullable_to_non_nullable
                  as SalePricePreviewModel?,
        isLoadingPricePreview: null == isLoadingPricePreview
            ? _value.isLoadingPricePreview
            : isLoadingPricePreview // ignore: cast_nullable_to_non_nullable
                  as bool,
        pricePreviewError: freezed == pricePreviewError
            ? _value.pricePreviewError
            : pricePreviewError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PosCartStateImpl extends _PosCartState {
  const _$PosCartStateImpl({
    final List<CartItemModel> cartItems = const [],
    final List<TaxRateModel> taxRates = const [],
    this.defaultTaxRate,
    this.selectedCustomer,
    this.cartDiscountType,
    this.cartDiscountValue,
    this.cartNote,
    final List<HeldOrderModel> heldOrders = const [],
    this.isHoldingSale = false,
    this.isSubmittingSale = false,
    this.isFiringTab = false,
    this.isRequestingBill = false,
    this.selectedDiscountSchemeId,
    final List<DiscountSchemeModel> discountSchemes = const [],
    this.pricePreview,
    this.isLoadingPricePreview = false,
    this.pricePreviewError,
  }) : _cartItems = cartItems,
       _taxRates = taxRates,
       _heldOrders = heldOrders,
       _discountSchemes = discountSchemes,
       super._();

  final List<CartItemModel> _cartItems;
  @override
  @JsonKey()
  List<CartItemModel> get cartItems {
    if (_cartItems is EqualUnmodifiableListView) return _cartItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartItems);
  }

  final List<TaxRateModel> _taxRates;
  @override
  @JsonKey()
  List<TaxRateModel> get taxRates {
    if (_taxRates is EqualUnmodifiableListView) return _taxRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taxRates);
  }

  @override
  final TaxRateModel? defaultTaxRate;
  @override
  final CustomerModel? selectedCustomer;
  @override
  final String? cartDiscountType;
  @override
  final String? cartDiscountValue;
  @override
  final String? cartNote;
  final List<HeldOrderModel> _heldOrders;
  @override
  @JsonKey()
  List<HeldOrderModel> get heldOrders {
    if (_heldOrders is EqualUnmodifiableListView) return _heldOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heldOrders);
  }

  @override
  @JsonKey()
  final bool isHoldingSale;
  @override
  @JsonKey()
  final bool isSubmittingSale;
  @override
  @JsonKey()
  final bool isFiringTab;
  @override
  @JsonKey()
  final bool isRequestingBill;
  @override
  final String? selectedDiscountSchemeId;
  final List<DiscountSchemeModel> _discountSchemes;
  @override
  @JsonKey()
  List<DiscountSchemeModel> get discountSchemes {
    if (_discountSchemes is EqualUnmodifiableListView) return _discountSchemes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_discountSchemes);
  }

  @override
  final SalePricePreviewModel? pricePreview;
  @override
  @JsonKey()
  final bool isLoadingPricePreview;
  @override
  final String? pricePreviewError;

  @override
  String toString() {
    return 'PosCartState(cartItems: $cartItems, taxRates: $taxRates, defaultTaxRate: $defaultTaxRate, selectedCustomer: $selectedCustomer, cartDiscountType: $cartDiscountType, cartDiscountValue: $cartDiscountValue, cartNote: $cartNote, heldOrders: $heldOrders, isHoldingSale: $isHoldingSale, isSubmittingSale: $isSubmittingSale, isFiringTab: $isFiringTab, isRequestingBill: $isRequestingBill, selectedDiscountSchemeId: $selectedDiscountSchemeId, discountSchemes: $discountSchemes, pricePreview: $pricePreview, isLoadingPricePreview: $isLoadingPricePreview, pricePreviewError: $pricePreviewError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosCartStateImpl &&
            const DeepCollectionEquality().equals(
              other._cartItems,
              _cartItems,
            ) &&
            const DeepCollectionEquality().equals(other._taxRates, _taxRates) &&
            (identical(other.defaultTaxRate, defaultTaxRate) ||
                other.defaultTaxRate == defaultTaxRate) &&
            (identical(other.selectedCustomer, selectedCustomer) ||
                other.selectedCustomer == selectedCustomer) &&
            (identical(other.cartDiscountType, cartDiscountType) ||
                other.cartDiscountType == cartDiscountType) &&
            (identical(other.cartDiscountValue, cartDiscountValue) ||
                other.cartDiscountValue == cartDiscountValue) &&
            (identical(other.cartNote, cartNote) ||
                other.cartNote == cartNote) &&
            const DeepCollectionEquality().equals(
              other._heldOrders,
              _heldOrders,
            ) &&
            (identical(other.isHoldingSale, isHoldingSale) ||
                other.isHoldingSale == isHoldingSale) &&
            (identical(other.isSubmittingSale, isSubmittingSale) ||
                other.isSubmittingSale == isSubmittingSale) &&
            (identical(other.isFiringTab, isFiringTab) ||
                other.isFiringTab == isFiringTab) &&
            (identical(other.isRequestingBill, isRequestingBill) ||
                other.isRequestingBill == isRequestingBill) &&
            (identical(
                  other.selectedDiscountSchemeId,
                  selectedDiscountSchemeId,
                ) ||
                other.selectedDiscountSchemeId == selectedDiscountSchemeId) &&
            const DeepCollectionEquality().equals(
              other._discountSchemes,
              _discountSchemes,
            ) &&
            (identical(other.pricePreview, pricePreview) ||
                other.pricePreview == pricePreview) &&
            (identical(other.isLoadingPricePreview, isLoadingPricePreview) ||
                other.isLoadingPricePreview == isLoadingPricePreview) &&
            (identical(other.pricePreviewError, pricePreviewError) ||
                other.pricePreviewError == pricePreviewError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_cartItems),
    const DeepCollectionEquality().hash(_taxRates),
    defaultTaxRate,
    selectedCustomer,
    cartDiscountType,
    cartDiscountValue,
    cartNote,
    const DeepCollectionEquality().hash(_heldOrders),
    isHoldingSale,
    isSubmittingSale,
    isFiringTab,
    isRequestingBill,
    selectedDiscountSchemeId,
    const DeepCollectionEquality().hash(_discountSchemes),
    pricePreview,
    isLoadingPricePreview,
    pricePreviewError,
  );

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosCartStateImplCopyWith<_$PosCartStateImpl> get copyWith =>
      __$$PosCartStateImplCopyWithImpl<_$PosCartStateImpl>(this, _$identity);
}

abstract class _PosCartState extends PosCartState {
  const factory _PosCartState({
    final List<CartItemModel> cartItems,
    final List<TaxRateModel> taxRates,
    final TaxRateModel? defaultTaxRate,
    final CustomerModel? selectedCustomer,
    final String? cartDiscountType,
    final String? cartDiscountValue,
    final String? cartNote,
    final List<HeldOrderModel> heldOrders,
    final bool isHoldingSale,
    final bool isSubmittingSale,
    final bool isFiringTab,
    final bool isRequestingBill,
    final String? selectedDiscountSchemeId,
    final List<DiscountSchemeModel> discountSchemes,
    final SalePricePreviewModel? pricePreview,
    final bool isLoadingPricePreview,
    final String? pricePreviewError,
  }) = _$PosCartStateImpl;
  const _PosCartState._() : super._();

  @override
  List<CartItemModel> get cartItems;
  @override
  List<TaxRateModel> get taxRates;
  @override
  TaxRateModel? get defaultTaxRate;
  @override
  CustomerModel? get selectedCustomer;
  @override
  String? get cartDiscountType;
  @override
  String? get cartDiscountValue;
  @override
  String? get cartNote;
  @override
  List<HeldOrderModel> get heldOrders;
  @override
  bool get isHoldingSale;
  @override
  bool get isSubmittingSale;
  @override
  bool get isFiringTab;
  @override
  bool get isRequestingBill;
  @override
  String? get selectedDiscountSchemeId;
  @override
  List<DiscountSchemeModel> get discountSchemes;
  @override
  SalePricePreviewModel? get pricePreview;
  @override
  bool get isLoadingPricePreview;
  @override
  String? get pricePreviewError;

  /// Create a copy of PosCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosCartStateImplCopyWith<_$PosCartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
