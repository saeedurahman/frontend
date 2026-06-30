// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SaleDetailState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SaleDetailInitial value) initial,
    required TResult Function(SaleDetailLoading value) loading,
    required TResult Function(SaleDetailLoaded value) loaded,
    required TResult Function(SaleDetailError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SaleDetailInitial value)? initial,
    TResult? Function(SaleDetailLoading value)? loading,
    TResult? Function(SaleDetailLoaded value)? loaded,
    TResult? Function(SaleDetailError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SaleDetailInitial value)? initial,
    TResult Function(SaleDetailLoading value)? loading,
    TResult Function(SaleDetailLoaded value)? loaded,
    TResult Function(SaleDetailError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleDetailStateCopyWith<$Res> {
  factory $SaleDetailStateCopyWith(
    SaleDetailState value,
    $Res Function(SaleDetailState) then,
  ) = _$SaleDetailStateCopyWithImpl<$Res, SaleDetailState>;
}

/// @nodoc
class _$SaleDetailStateCopyWithImpl<$Res, $Val extends SaleDetailState>
    implements $SaleDetailStateCopyWith<$Res> {
  _$SaleDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SaleDetailInitialImplCopyWith<$Res> {
  factory _$$SaleDetailInitialImplCopyWith(
    _$SaleDetailInitialImpl value,
    $Res Function(_$SaleDetailInitialImpl) then,
  ) = __$$SaleDetailInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SaleDetailInitialImplCopyWithImpl<$Res>
    extends _$SaleDetailStateCopyWithImpl<$Res, _$SaleDetailInitialImpl>
    implements _$$SaleDetailInitialImplCopyWith<$Res> {
  __$$SaleDetailInitialImplCopyWithImpl(
    _$SaleDetailInitialImpl _value,
    $Res Function(_$SaleDetailInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SaleDetailInitialImpl implements SaleDetailInitial {
  const _$SaleDetailInitialImpl();

  @override
  String toString() {
    return 'SaleDetailState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SaleDetailInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
    required TResult Function(SaleDetailInitial value) initial,
    required TResult Function(SaleDetailLoading value) loading,
    required TResult Function(SaleDetailLoaded value) loaded,
    required TResult Function(SaleDetailError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SaleDetailInitial value)? initial,
    TResult? Function(SaleDetailLoading value)? loading,
    TResult? Function(SaleDetailLoaded value)? loaded,
    TResult? Function(SaleDetailError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SaleDetailInitial value)? initial,
    TResult Function(SaleDetailLoading value)? loading,
    TResult Function(SaleDetailLoaded value)? loaded,
    TResult Function(SaleDetailError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SaleDetailInitial implements SaleDetailState {
  const factory SaleDetailInitial() = _$SaleDetailInitialImpl;
}

/// @nodoc
abstract class _$$SaleDetailLoadingImplCopyWith<$Res> {
  factory _$$SaleDetailLoadingImplCopyWith(
    _$SaleDetailLoadingImpl value,
    $Res Function(_$SaleDetailLoadingImpl) then,
  ) = __$$SaleDetailLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SaleDetailLoadingImplCopyWithImpl<$Res>
    extends _$SaleDetailStateCopyWithImpl<$Res, _$SaleDetailLoadingImpl>
    implements _$$SaleDetailLoadingImplCopyWith<$Res> {
  __$$SaleDetailLoadingImplCopyWithImpl(
    _$SaleDetailLoadingImpl _value,
    $Res Function(_$SaleDetailLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SaleDetailLoadingImpl implements SaleDetailLoading {
  const _$SaleDetailLoadingImpl();

  @override
  String toString() {
    return 'SaleDetailState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SaleDetailLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
    required TResult Function(SaleDetailInitial value) initial,
    required TResult Function(SaleDetailLoading value) loading,
    required TResult Function(SaleDetailLoaded value) loaded,
    required TResult Function(SaleDetailError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SaleDetailInitial value)? initial,
    TResult? Function(SaleDetailLoading value)? loading,
    TResult? Function(SaleDetailLoaded value)? loaded,
    TResult? Function(SaleDetailError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SaleDetailInitial value)? initial,
    TResult Function(SaleDetailLoading value)? loading,
    TResult Function(SaleDetailLoaded value)? loaded,
    TResult Function(SaleDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SaleDetailLoading implements SaleDetailState {
  const factory SaleDetailLoading() = _$SaleDetailLoadingImpl;
}

/// @nodoc
abstract class _$$SaleDetailLoadedImplCopyWith<$Res> {
  factory _$$SaleDetailLoadedImplCopyWith(
    _$SaleDetailLoadedImpl value,
    $Res Function(_$SaleDetailLoadedImpl) then,
  ) = __$$SaleDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    SaleResponseModel sale,
    CustomerModel? customer,
    bool isCancelling,
    bool isVoiding,
    bool? registerShiftOpen,
    bool canCancelSales,
    bool canCreateReturn,
  });

  $SaleResponseModelCopyWith<$Res> get sale;
  $CustomerModelCopyWith<$Res>? get customer;
}

/// @nodoc
class __$$SaleDetailLoadedImplCopyWithImpl<$Res>
    extends _$SaleDetailStateCopyWithImpl<$Res, _$SaleDetailLoadedImpl>
    implements _$$SaleDetailLoadedImplCopyWith<$Res> {
  __$$SaleDetailLoadedImplCopyWithImpl(
    _$SaleDetailLoadedImpl _value,
    $Res Function(_$SaleDetailLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sale = null,
    Object? customer = freezed,
    Object? isCancelling = null,
    Object? isVoiding = null,
    Object? registerShiftOpen = freezed,
    Object? canCancelSales = null,
    Object? canCreateReturn = null,
  }) {
    return _then(
      _$SaleDetailLoadedImpl(
        sale: null == sale
            ? _value.sale
            : sale // ignore: cast_nullable_to_non_nullable
                  as SaleResponseModel,
        customer: freezed == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel?,
        isCancelling: null == isCancelling
            ? _value.isCancelling
            : isCancelling // ignore: cast_nullable_to_non_nullable
                  as bool,
        isVoiding: null == isVoiding
            ? _value.isVoiding
            : isVoiding // ignore: cast_nullable_to_non_nullable
                  as bool,
        registerShiftOpen: freezed == registerShiftOpen
            ? _value.registerShiftOpen
            : registerShiftOpen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canCancelSales: null == canCancelSales
            ? _value.canCancelSales
            : canCancelSales // ignore: cast_nullable_to_non_nullable
                  as bool,
        canCreateReturn: null == canCreateReturn
            ? _value.canCreateReturn
            : canCreateReturn // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleResponseModelCopyWith<$Res> get sale {
    return $SaleResponseModelCopyWith<$Res>(_value.sale, (value) {
      return _then(_value.copyWith(sale: value));
    });
  }

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value));
    });
  }
}

/// @nodoc

class _$SaleDetailLoadedImpl implements SaleDetailLoaded {
  const _$SaleDetailLoadedImpl({
    required this.sale,
    this.customer,
    this.isCancelling = false,
    this.isVoiding = false,
    this.registerShiftOpen,
    this.canCancelSales = false,
    this.canCreateReturn = false,
  });

  @override
  final SaleResponseModel sale;
  @override
  final CustomerModel? customer;
  @override
  @JsonKey()
  final bool isCancelling;
  @override
  @JsonKey()
  final bool isVoiding;
  @override
  final bool? registerShiftOpen;
  @override
  @JsonKey()
  final bool canCancelSales;
  @override
  @JsonKey()
  final bool canCreateReturn;

  @override
  String toString() {
    return 'SaleDetailState.loaded(sale: $sale, customer: $customer, isCancelling: $isCancelling, isVoiding: $isVoiding, registerShiftOpen: $registerShiftOpen, canCancelSales: $canCancelSales, canCreateReturn: $canCreateReturn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleDetailLoadedImpl &&
            (identical(other.sale, sale) || other.sale == sale) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.isCancelling, isCancelling) ||
                other.isCancelling == isCancelling) &&
            (identical(other.isVoiding, isVoiding) ||
                other.isVoiding == isVoiding) &&
            (identical(other.registerShiftOpen, registerShiftOpen) ||
                other.registerShiftOpen == registerShiftOpen) &&
            (identical(other.canCancelSales, canCancelSales) ||
                other.canCancelSales == canCancelSales) &&
            (identical(other.canCreateReturn, canCreateReturn) ||
                other.canCreateReturn == canCreateReturn));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    sale,
    customer,
    isCancelling,
    isVoiding,
    registerShiftOpen,
    canCancelSales,
    canCreateReturn,
  );

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleDetailLoadedImplCopyWith<_$SaleDetailLoadedImpl> get copyWith =>
      __$$SaleDetailLoadedImplCopyWithImpl<_$SaleDetailLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
      sale,
      customer,
      isCancelling,
      isVoiding,
      registerShiftOpen,
      canCancelSales,
      canCreateReturn,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      sale,
      customer,
      isCancelling,
      isVoiding,
      registerShiftOpen,
      canCancelSales,
      canCreateReturn,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        sale,
        customer,
        isCancelling,
        isVoiding,
        registerShiftOpen,
        canCancelSales,
        canCreateReturn,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SaleDetailInitial value) initial,
    required TResult Function(SaleDetailLoading value) loading,
    required TResult Function(SaleDetailLoaded value) loaded,
    required TResult Function(SaleDetailError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SaleDetailInitial value)? initial,
    TResult? Function(SaleDetailLoading value)? loading,
    TResult? Function(SaleDetailLoaded value)? loaded,
    TResult? Function(SaleDetailError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SaleDetailInitial value)? initial,
    TResult Function(SaleDetailLoading value)? loading,
    TResult Function(SaleDetailLoaded value)? loaded,
    TResult Function(SaleDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SaleDetailLoaded implements SaleDetailState {
  const factory SaleDetailLoaded({
    required final SaleResponseModel sale,
    final CustomerModel? customer,
    final bool isCancelling,
    final bool isVoiding,
    final bool? registerShiftOpen,
    final bool canCancelSales,
    final bool canCreateReturn,
  }) = _$SaleDetailLoadedImpl;

  SaleResponseModel get sale;
  CustomerModel? get customer;
  bool get isCancelling;
  bool get isVoiding;
  bool? get registerShiftOpen;
  bool get canCancelSales;
  bool get canCreateReturn;

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleDetailLoadedImplCopyWith<_$SaleDetailLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaleDetailErrorImplCopyWith<$Res> {
  factory _$$SaleDetailErrorImplCopyWith(
    _$SaleDetailErrorImpl value,
    $Res Function(_$SaleDetailErrorImpl) then,
  ) = __$$SaleDetailErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SaleDetailErrorImplCopyWithImpl<$Res>
    extends _$SaleDetailStateCopyWithImpl<$Res, _$SaleDetailErrorImpl>
    implements _$$SaleDetailErrorImplCopyWith<$Res> {
  __$$SaleDetailErrorImplCopyWithImpl(
    _$SaleDetailErrorImpl _value,
    $Res Function(_$SaleDetailErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SaleDetailErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SaleDetailErrorImpl implements SaleDetailError {
  const _$SaleDetailErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SaleDetailState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleDetailErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleDetailErrorImplCopyWith<_$SaleDetailErrorImpl> get copyWith =>
      __$$SaleDetailErrorImplCopyWithImpl<_$SaleDetailErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
      SaleResponseModel sale,
      CustomerModel? customer,
      bool isCancelling,
      bool isVoiding,
      bool? registerShiftOpen,
      bool canCancelSales,
      bool canCreateReturn,
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
    required TResult Function(SaleDetailInitial value) initial,
    required TResult Function(SaleDetailLoading value) loading,
    required TResult Function(SaleDetailLoaded value) loaded,
    required TResult Function(SaleDetailError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SaleDetailInitial value)? initial,
    TResult? Function(SaleDetailLoading value)? loading,
    TResult? Function(SaleDetailLoaded value)? loaded,
    TResult? Function(SaleDetailError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SaleDetailInitial value)? initial,
    TResult Function(SaleDetailLoading value)? loading,
    TResult Function(SaleDetailLoaded value)? loaded,
    TResult Function(SaleDetailError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SaleDetailError implements SaleDetailState {
  const factory SaleDetailError(final String message) = _$SaleDetailErrorImpl;

  String get message;

  /// Create a copy of SaleDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleDetailErrorImplCopyWith<_$SaleDetailErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
