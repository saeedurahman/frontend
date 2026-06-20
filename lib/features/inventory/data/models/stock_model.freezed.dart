// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StockBalanceModel _$StockBalanceModelFromJson(Map<String, dynamic> json) {
  return _StockBalanceModel.fromJson(json);
}

/// @nodoc
mixin _$StockBalanceModel {
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_qty')
  String get currentQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_movement_at')
  String? get lastMovementAt => throw _privateConstructorUsedError;

  /// Serializes this StockBalanceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockBalanceModelCopyWith<StockBalanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockBalanceModelCopyWith<$Res> {
  factory $StockBalanceModelCopyWith(
    StockBalanceModel value,
    $Res Function(StockBalanceModel) then,
  ) = _$StockBalanceModelCopyWithImpl<$Res, StockBalanceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'current_qty') String currentQty,
    @JsonKey(name: 'last_movement_at') String? lastMovementAt,
  });
}

/// @nodoc
class _$StockBalanceModelCopyWithImpl<$Res, $Val extends StockBalanceModel>
    implements $StockBalanceModelCopyWith<$Res> {
  _$StockBalanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? variationId = freezed,
    Object? branchId = null,
    Object? currentQty = null,
    Object? lastMovementAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            currentQty: null == currentQty
                ? _value.currentQty
                : currentQty // ignore: cast_nullable_to_non_nullable
                      as String,
            lastMovementAt: freezed == lastMovementAt
                ? _value.lastMovementAt
                : lastMovementAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockBalanceModelImplCopyWith<$Res>
    implements $StockBalanceModelCopyWith<$Res> {
  factory _$$StockBalanceModelImplCopyWith(
    _$StockBalanceModelImpl value,
    $Res Function(_$StockBalanceModelImpl) then,
  ) = __$$StockBalanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'current_qty') String currentQty,
    @JsonKey(name: 'last_movement_at') String? lastMovementAt,
  });
}

/// @nodoc
class __$$StockBalanceModelImplCopyWithImpl<$Res>
    extends _$StockBalanceModelCopyWithImpl<$Res, _$StockBalanceModelImpl>
    implements _$$StockBalanceModelImplCopyWith<$Res> {
  __$$StockBalanceModelImplCopyWithImpl(
    _$StockBalanceModelImpl _value,
    $Res Function(_$StockBalanceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? variationId = freezed,
    Object? branchId = null,
    Object? currentQty = null,
    Object? lastMovementAt = freezed,
  }) {
    return _then(
      _$StockBalanceModelImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentQty: null == currentQty
            ? _value.currentQty
            : currentQty // ignore: cast_nullable_to_non_nullable
                  as String,
        lastMovementAt: freezed == lastMovementAt
            ? _value.lastMovementAt
            : lastMovementAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockBalanceModelImpl implements _StockBalanceModel {
  const _$StockBalanceModelImpl({
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'current_qty') required this.currentQty,
    @JsonKey(name: 'last_movement_at') this.lastMovementAt,
  });

  factory _$StockBalanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockBalanceModelImplFromJson(json);

  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'current_qty')
  final String currentQty;
  @override
  @JsonKey(name: 'last_movement_at')
  final String? lastMovementAt;

  @override
  String toString() {
    return 'StockBalanceModel(productId: $productId, variationId: $variationId, branchId: $branchId, currentQty: $currentQty, lastMovementAt: $lastMovementAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockBalanceModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.currentQty, currentQty) ||
                other.currentQty == currentQty) &&
            (identical(other.lastMovementAt, lastMovementAt) ||
                other.lastMovementAt == lastMovementAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    variationId,
    branchId,
    currentQty,
    lastMovementAt,
  );

  /// Create a copy of StockBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockBalanceModelImplCopyWith<_$StockBalanceModelImpl> get copyWith =>
      __$$StockBalanceModelImplCopyWithImpl<_$StockBalanceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockBalanceModelImplToJson(this);
  }
}

abstract class _StockBalanceModel implements StockBalanceModel {
  const factory _StockBalanceModel({
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'current_qty') required final String currentQty,
    @JsonKey(name: 'last_movement_at') final String? lastMovementAt,
  }) = _$StockBalanceModelImpl;

  factory _StockBalanceModel.fromJson(Map<String, dynamic> json) =
      _$StockBalanceModelImpl.fromJson;

  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'current_qty')
  String get currentQty;
  @override
  @JsonKey(name: 'last_movement_at')
  String? get lastMovementAt;

  /// Create a copy of StockBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockBalanceModelImplCopyWith<_$StockBalanceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockMovementModel _$StockMovementModelFromJson(Map<String, dynamic> json) {
  return _StockMovementModel.fromJson(json);
}

/// @nodoc
mixin _$StockMovementModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'movement_type')
  String get movementType => throw _privateConstructorUsedError;
  String get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String get referenceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_number')
  String? get batchNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  String? get expiryDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'movement_at')
  String get movementAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this StockMovementModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockMovementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMovementModelCopyWith<StockMovementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMovementModelCopyWith<$Res> {
  factory $StockMovementModelCopyWith(
    StockMovementModel value,
    $Res Function(StockMovementModel) then,
  ) = _$StockMovementModelCopyWithImpl<$Res, StockMovementModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'movement_type') String movementType,
    String qty,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    @JsonKey(name: 'reference_type') String referenceType,
    @JsonKey(name: 'reference_id') String referenceId,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    String? notes,
    @JsonKey(name: 'movement_at') String movementAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$StockMovementModelCopyWithImpl<$Res, $Val extends StockMovementModel>
    implements $StockMovementModelCopyWith<$Res> {
  _$StockMovementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMovementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? movementType = null,
    Object? qty = null,
    Object? costPerUnit = null,
    Object? referenceType = null,
    Object? referenceId = null,
    Object? batchNumber = freezed,
    Object? expiryDate = freezed,
    Object? notes = freezed,
    Object? movementAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            movementType: null == movementType
                ? _value.movementType
                : movementType // ignore: cast_nullable_to_non_nullable
                      as String,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerUnit: null == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceType: null == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceId: null == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String,
            batchNumber: freezed == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            movementAt: null == movementAt
                ? _value.movementAt
                : movementAt // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockMovementModelImplCopyWith<$Res>
    implements $StockMovementModelCopyWith<$Res> {
  factory _$$StockMovementModelImplCopyWith(
    _$StockMovementModelImpl value,
    $Res Function(_$StockMovementModelImpl) then,
  ) = __$$StockMovementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'movement_type') String movementType,
    String qty,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    @JsonKey(name: 'reference_type') String referenceType,
    @JsonKey(name: 'reference_id') String referenceId,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    String? notes,
    @JsonKey(name: 'movement_at') String movementAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$StockMovementModelImplCopyWithImpl<$Res>
    extends _$StockMovementModelCopyWithImpl<$Res, _$StockMovementModelImpl>
    implements _$$StockMovementModelImplCopyWith<$Res> {
  __$$StockMovementModelImplCopyWithImpl(
    _$StockMovementModelImpl _value,
    $Res Function(_$StockMovementModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? movementType = null,
    Object? qty = null,
    Object? costPerUnit = null,
    Object? referenceType = null,
    Object? referenceId = null,
    Object? batchNumber = freezed,
    Object? expiryDate = freezed,
    Object? notes = freezed,
    Object? movementAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$StockMovementModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        movementType: null == movementType
            ? _value.movementType
            : movementType // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerUnit: null == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceType: null == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceId: null == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String,
        batchNumber: freezed == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        movementAt: null == movementAt
            ? _value.movementAt
            : movementAt // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMovementModelImpl implements _StockMovementModel {
  const _$StockMovementModelImpl({
    required this.id,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'movement_type') required this.movementType,
    required this.qty,
    @JsonKey(name: 'cost_per_unit') required this.costPerUnit,
    @JsonKey(name: 'reference_type') required this.referenceType,
    @JsonKey(name: 'reference_id') required this.referenceId,
    @JsonKey(name: 'batch_number') this.batchNumber,
    @JsonKey(name: 'expiry_date') this.expiryDate,
    this.notes,
    @JsonKey(name: 'movement_at') required this.movementAt,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$StockMovementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMovementModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'movement_type')
  final String movementType;
  @override
  final String qty;
  @override
  @JsonKey(name: 'cost_per_unit')
  final String costPerUnit;
  @override
  @JsonKey(name: 'reference_type')
  final String referenceType;
  @override
  @JsonKey(name: 'reference_id')
  final String referenceId;
  @override
  @JsonKey(name: 'batch_number')
  final String? batchNumber;
  @override
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'movement_at')
  final String movementAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'StockMovementModel(id: $id, branchId: $branchId, productId: $productId, variationId: $variationId, movementType: $movementType, qty: $qty, costPerUnit: $costPerUnit, referenceType: $referenceType, referenceId: $referenceId, batchNumber: $batchNumber, expiryDate: $expiryDate, notes: $notes, movementAt: $movementAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.movementType, movementType) ||
                other.movementType == movementType) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.movementAt, movementAt) ||
                other.movementAt == movementAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    branchId,
    productId,
    variationId,
    movementType,
    qty,
    costPerUnit,
    referenceType,
    referenceId,
    batchNumber,
    expiryDate,
    notes,
    movementAt,
    createdAt,
  );

  /// Create a copy of StockMovementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementModelImplCopyWith<_$StockMovementModelImpl> get copyWith =>
      __$$StockMovementModelImplCopyWithImpl<_$StockMovementModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMovementModelImplToJson(this);
  }
}

abstract class _StockMovementModel implements StockMovementModel {
  const factory _StockMovementModel({
    required final String id,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'movement_type') required final String movementType,
    required final String qty,
    @JsonKey(name: 'cost_per_unit') required final String costPerUnit,
    @JsonKey(name: 'reference_type') required final String referenceType,
    @JsonKey(name: 'reference_id') required final String referenceId,
    @JsonKey(name: 'batch_number') final String? batchNumber,
    @JsonKey(name: 'expiry_date') final String? expiryDate,
    final String? notes,
    @JsonKey(name: 'movement_at') required final String movementAt,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$StockMovementModelImpl;

  factory _StockMovementModel.fromJson(Map<String, dynamic> json) =
      _$StockMovementModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'movement_type')
  String get movementType;
  @override
  String get qty;
  @override
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit;
  @override
  @JsonKey(name: 'reference_type')
  String get referenceType;
  @override
  @JsonKey(name: 'reference_id')
  String get referenceId;
  @override
  @JsonKey(name: 'batch_number')
  String? get batchNumber;
  @override
  @JsonKey(name: 'expiry_date')
  String? get expiryDate;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'movement_at')
  String get movementAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of StockMovementModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMovementModelImplCopyWith<_$StockMovementModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginatedStockMovementsModel _$PaginatedStockMovementsModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedStockMovementsModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedStockMovementsModel {
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<StockMovementModel> get items => throw _privateConstructorUsedError;

  /// Serializes this PaginatedStockMovementsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedStockMovementsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedStockMovementsModelCopyWith<PaginatedStockMovementsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedStockMovementsModelCopyWith<$Res> {
  factory $PaginatedStockMovementsModelCopyWith(
    PaginatedStockMovementsModel value,
    $Res Function(PaginatedStockMovementsModel) then,
  ) =
      _$PaginatedStockMovementsModelCopyWithImpl<
        $Res,
        PaginatedStockMovementsModel
      >;
  @useResult
  $Res call({int total, int skip, int limit, List<StockMovementModel> items});
}

/// @nodoc
class _$PaginatedStockMovementsModelCopyWithImpl<
  $Res,
  $Val extends PaginatedStockMovementsModel
>
    implements $PaginatedStockMovementsModelCopyWith<$Res> {
  _$PaginatedStockMovementsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedStockMovementsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
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
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<StockMovementModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedStockMovementsModelImplCopyWith<$Res>
    implements $PaginatedStockMovementsModelCopyWith<$Res> {
  factory _$$PaginatedStockMovementsModelImplCopyWith(
    _$PaginatedStockMovementsModelImpl value,
    $Res Function(_$PaginatedStockMovementsModelImpl) then,
  ) = __$$PaginatedStockMovementsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int skip, int limit, List<StockMovementModel> items});
}

/// @nodoc
class __$$PaginatedStockMovementsModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedStockMovementsModelCopyWithImpl<
          $Res,
          _$PaginatedStockMovementsModelImpl
        >
    implements _$$PaginatedStockMovementsModelImplCopyWith<$Res> {
  __$$PaginatedStockMovementsModelImplCopyWithImpl(
    _$PaginatedStockMovementsModelImpl _value,
    $Res Function(_$PaginatedStockMovementsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedStockMovementsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? items = null,
  }) {
    return _then(
      _$PaginatedStockMovementsModelImpl(
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
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<StockMovementModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedStockMovementsModelImpl
    implements _PaginatedStockMovementsModel {
  const _$PaginatedStockMovementsModelImpl({
    required this.total,
    required this.skip,
    required this.limit,
    required final List<StockMovementModel> items,
  }) : _items = items;

  factory _$PaginatedStockMovementsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PaginatedStockMovementsModelImplFromJson(json);

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  final List<StockMovementModel> _items;
  @override
  List<StockMovementModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginatedStockMovementsModel(total: $total, skip: $skip, limit: $limit, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedStockMovementsModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    skip,
    limit,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of PaginatedStockMovementsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedStockMovementsModelImplCopyWith<
    _$PaginatedStockMovementsModelImpl
  >
  get copyWith =>
      __$$PaginatedStockMovementsModelImplCopyWithImpl<
        _$PaginatedStockMovementsModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedStockMovementsModelImplToJson(this);
  }
}

abstract class _PaginatedStockMovementsModel
    implements PaginatedStockMovementsModel {
  const factory _PaginatedStockMovementsModel({
    required final int total,
    required final int skip,
    required final int limit,
    required final List<StockMovementModel> items,
  }) = _$PaginatedStockMovementsModelImpl;

  factory _PaginatedStockMovementsModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedStockMovementsModelImpl.fromJson;

  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;
  @override
  List<StockMovementModel> get items;

  /// Create a copy of PaginatedStockMovementsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedStockMovementsModelImplCopyWith<
    _$PaginatedStockMovementsModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

StockAdjustmentLineModel _$StockAdjustmentLineModelFromJson(
  Map<String, dynamic> json,
) {
  return _StockAdjustmentLineModel.fromJson(json);
}

/// @nodoc
mixin _$StockAdjustmentLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_delta')
  String get qtyDelta => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this StockAdjustmentLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockAdjustmentLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockAdjustmentLineModelCopyWith<StockAdjustmentLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAdjustmentLineModelCopyWith<$Res> {
  factory $StockAdjustmentLineModelCopyWith(
    StockAdjustmentLineModel value,
    $Res Function(StockAdjustmentLineModel) then,
  ) = _$StockAdjustmentLineModelCopyWithImpl<$Res, StockAdjustmentLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_delta') String qtyDelta,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    String? notes,
  });
}

/// @nodoc
class _$StockAdjustmentLineModelCopyWithImpl<
  $Res,
  $Val extends StockAdjustmentLineModel
>
    implements $StockAdjustmentLineModelCopyWith<$Res> {
  _$StockAdjustmentLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockAdjustmentLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qtyDelta = null,
    Object? costPerUnit = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qtyDelta: null == qtyDelta
                ? _value.qtyDelta
                : qtyDelta // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerUnit: null == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockAdjustmentLineModelImplCopyWith<$Res>
    implements $StockAdjustmentLineModelCopyWith<$Res> {
  factory _$$StockAdjustmentLineModelImplCopyWith(
    _$StockAdjustmentLineModelImpl value,
    $Res Function(_$StockAdjustmentLineModelImpl) then,
  ) = __$$StockAdjustmentLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_delta') String qtyDelta,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    String? notes,
  });
}

/// @nodoc
class __$$StockAdjustmentLineModelImplCopyWithImpl<$Res>
    extends
        _$StockAdjustmentLineModelCopyWithImpl<
          $Res,
          _$StockAdjustmentLineModelImpl
        >
    implements _$$StockAdjustmentLineModelImplCopyWith<$Res> {
  __$$StockAdjustmentLineModelImplCopyWithImpl(
    _$StockAdjustmentLineModelImpl _value,
    $Res Function(_$StockAdjustmentLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockAdjustmentLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qtyDelta = null,
    Object? costPerUnit = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$StockAdjustmentLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qtyDelta: null == qtyDelta
            ? _value.qtyDelta
            : qtyDelta // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerUnit: null == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAdjustmentLineModelImpl implements _StockAdjustmentLineModel {
  const _$StockAdjustmentLineModelImpl({
    required this.id,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'qty_delta') required this.qtyDelta,
    @JsonKey(name: 'cost_per_unit') required this.costPerUnit,
    this.notes,
  });

  factory _$StockAdjustmentLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAdjustmentLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'qty_delta')
  final String qtyDelta;
  @override
  @JsonKey(name: 'cost_per_unit')
  final String costPerUnit;
  @override
  final String? notes;

  @override
  String toString() {
    return 'StockAdjustmentLineModel(id: $id, productId: $productId, variationId: $variationId, qtyDelta: $qtyDelta, costPerUnit: $costPerUnit, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAdjustmentLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qtyDelta, qtyDelta) ||
                other.qtyDelta == qtyDelta) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    variationId,
    qtyDelta,
    costPerUnit,
    notes,
  );

  /// Create a copy of StockAdjustmentLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAdjustmentLineModelImplCopyWith<_$StockAdjustmentLineModelImpl>
  get copyWith =>
      __$$StockAdjustmentLineModelImplCopyWithImpl<
        _$StockAdjustmentLineModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAdjustmentLineModelImplToJson(this);
  }
}

abstract class _StockAdjustmentLineModel implements StockAdjustmentLineModel {
  const factory _StockAdjustmentLineModel({
    required final String id,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'qty_delta') required final String qtyDelta,
    @JsonKey(name: 'cost_per_unit') required final String costPerUnit,
    final String? notes,
  }) = _$StockAdjustmentLineModelImpl;

  factory _StockAdjustmentLineModel.fromJson(Map<String, dynamic> json) =
      _$StockAdjustmentLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'qty_delta')
  String get qtyDelta;
  @override
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit;
  @override
  String? get notes;

  /// Create a copy of StockAdjustmentLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockAdjustmentLineModelImplCopyWith<_$StockAdjustmentLineModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

StockAdjustmentModel _$StockAdjustmentModelFromJson(Map<String, dynamic> json) {
  return _StockAdjustmentModel.fromJson(json);
}

/// @nodoc
mixin _$StockAdjustmentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'adjustment_number')
  String get adjustmentNumber => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'adjusted_at')
  String get adjustedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<StockAdjustmentLineModel> get lines =>
      throw _privateConstructorUsedError;

  /// Serializes this StockAdjustmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockAdjustmentModelCopyWith<StockAdjustmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAdjustmentModelCopyWith<$Res> {
  factory $StockAdjustmentModelCopyWith(
    StockAdjustmentModel value,
    $Res Function(StockAdjustmentModel) then,
  ) = _$StockAdjustmentModelCopyWithImpl<$Res, StockAdjustmentModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'adjustment_number') String adjustmentNumber,
    String reason,
    @JsonKey(name: 'adjusted_at') String adjustedAt,
    String? notes,
    List<StockAdjustmentLineModel> lines,
  });
}

/// @nodoc
class _$StockAdjustmentModelCopyWithImpl<
  $Res,
  $Val extends StockAdjustmentModel
>
    implements $StockAdjustmentModelCopyWith<$Res> {
  _$StockAdjustmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? adjustmentNumber = null,
    Object? reason = null,
    Object? adjustedAt = null,
    Object? notes = freezed,
    Object? lines = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            adjustmentNumber: null == adjustmentNumber
                ? _value.adjustmentNumber
                : adjustmentNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            adjustedAt: null == adjustedAt
                ? _value.adjustedAt
                : adjustedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<StockAdjustmentLineModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockAdjustmentModelImplCopyWith<$Res>
    implements $StockAdjustmentModelCopyWith<$Res> {
  factory _$$StockAdjustmentModelImplCopyWith(
    _$StockAdjustmentModelImpl value,
    $Res Function(_$StockAdjustmentModelImpl) then,
  ) = __$$StockAdjustmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'adjustment_number') String adjustmentNumber,
    String reason,
    @JsonKey(name: 'adjusted_at') String adjustedAt,
    String? notes,
    List<StockAdjustmentLineModel> lines,
  });
}

/// @nodoc
class __$$StockAdjustmentModelImplCopyWithImpl<$Res>
    extends _$StockAdjustmentModelCopyWithImpl<$Res, _$StockAdjustmentModelImpl>
    implements _$$StockAdjustmentModelImplCopyWith<$Res> {
  __$$StockAdjustmentModelImplCopyWithImpl(
    _$StockAdjustmentModelImpl _value,
    $Res Function(_$StockAdjustmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? adjustmentNumber = null,
    Object? reason = null,
    Object? adjustedAt = null,
    Object? notes = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$StockAdjustmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        adjustmentNumber: null == adjustmentNumber
            ? _value.adjustmentNumber
            : adjustmentNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        adjustedAt: null == adjustedAt
            ? _value.adjustedAt
            : adjustedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<StockAdjustmentLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAdjustmentModelImpl implements _StockAdjustmentModel {
  const _$StockAdjustmentModelImpl({
    required this.id,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'adjustment_number') required this.adjustmentNumber,
    required this.reason,
    @JsonKey(name: 'adjusted_at') required this.adjustedAt,
    this.notes,
    final List<StockAdjustmentLineModel> lines = const [],
  }) : _lines = lines;

  factory _$StockAdjustmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAdjustmentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'adjustment_number')
  final String adjustmentNumber;
  @override
  final String reason;
  @override
  @JsonKey(name: 'adjusted_at')
  final String adjustedAt;
  @override
  final String? notes;
  final List<StockAdjustmentLineModel> _lines;
  @override
  @JsonKey()
  List<StockAdjustmentLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'StockAdjustmentModel(id: $id, branchId: $branchId, adjustmentNumber: $adjustmentNumber, reason: $reason, adjustedAt: $adjustedAt, notes: $notes, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAdjustmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.adjustmentNumber, adjustmentNumber) ||
                other.adjustmentNumber == adjustmentNumber) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.adjustedAt, adjustedAt) ||
                other.adjustedAt == adjustedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    branchId,
    adjustmentNumber,
    reason,
    adjustedAt,
    notes,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of StockAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAdjustmentModelImplCopyWith<_$StockAdjustmentModelImpl>
  get copyWith =>
      __$$StockAdjustmentModelImplCopyWithImpl<_$StockAdjustmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAdjustmentModelImplToJson(this);
  }
}

abstract class _StockAdjustmentModel implements StockAdjustmentModel {
  const factory _StockAdjustmentModel({
    required final String id,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'adjustment_number') required final String adjustmentNumber,
    required final String reason,
    @JsonKey(name: 'adjusted_at') required final String adjustedAt,
    final String? notes,
    final List<StockAdjustmentLineModel> lines,
  }) = _$StockAdjustmentModelImpl;

  factory _StockAdjustmentModel.fromJson(Map<String, dynamic> json) =
      _$StockAdjustmentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'adjustment_number')
  String get adjustmentNumber;
  @override
  String get reason;
  @override
  @JsonKey(name: 'adjusted_at')
  String get adjustedAt;
  @override
  String? get notes;
  @override
  List<StockAdjustmentLineModel> get lines;

  /// Create a copy of StockAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockAdjustmentModelImplCopyWith<_$StockAdjustmentModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
