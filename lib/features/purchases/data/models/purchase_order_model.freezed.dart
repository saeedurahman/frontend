// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PurchaseLineModel _$PurchaseLineModelFromJson(Map<String, dynamic> json) {
  return _PurchaseLineModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_order_id')
  String get purchaseOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_qty')
  String get orderedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_qty')
  String get receivedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_remaining')
  String get qtyRemaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate')
  String get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_number')
  String? get batchNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  String? get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_name')
  String? get variationName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;

  /// Serializes this PurchaseLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseLineModelCopyWith<PurchaseLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseLineModelCopyWith<$Res> {
  factory $PurchaseLineModelCopyWith(
    PurchaseLineModel value,
    $Res Function(PurchaseLineModel) then,
  ) = _$PurchaseLineModelCopyWithImpl<$Res, PurchaseLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'purchase_order_id') String purchaseOrderId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'ordered_qty') String orderedQty,
    @JsonKey(name: 'received_qty') String receivedQty,
    @JsonKey(name: 'qty_remaining') String qtyRemaining,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    @JsonKey(name: 'tax_rate') String taxRate,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variation_name') String? variationName,
    String? sku,
  });
}

/// @nodoc
class _$PurchaseLineModelCopyWithImpl<$Res, $Val extends PurchaseLineModel>
    implements $PurchaseLineModelCopyWith<$Res> {
  _$PurchaseLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? purchaseOrderId = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? orderedQty = null,
    Object? receivedQty = null,
    Object? qtyRemaining = null,
    Object? costPerUnit = null,
    Object? taxRate = null,
    Object? batchNumber = freezed,
    Object? expiryDate = freezed,
    Object? productName = freezed,
    Object? variationName = freezed,
    Object? sku = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as String,
            purchaseOrderId: null == purchaseOrderId
                ? _value.purchaseOrderId
                : purchaseOrderId // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderedQty: null == orderedQty
                ? _value.orderedQty
                : orderedQty // ignore: cast_nullable_to_non_nullable
                      as String,
            receivedQty: null == receivedQty
                ? _value.receivedQty
                : receivedQty // ignore: cast_nullable_to_non_nullable
                      as String,
            qtyRemaining: null == qtyRemaining
                ? _value.qtyRemaining
                : qtyRemaining // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerUnit: null == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            taxRate: null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                      as String,
            batchNumber: freezed == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            variationName: freezed == variationName
                ? _value.variationName
                : variationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sku: freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseLineModelImplCopyWith<$Res>
    implements $PurchaseLineModelCopyWith<$Res> {
  factory _$$PurchaseLineModelImplCopyWith(
    _$PurchaseLineModelImpl value,
    $Res Function(_$PurchaseLineModelImpl) then,
  ) = __$$PurchaseLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'purchase_order_id') String purchaseOrderId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'ordered_qty') String orderedQty,
    @JsonKey(name: 'received_qty') String receivedQty,
    @JsonKey(name: 'qty_remaining') String qtyRemaining,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    @JsonKey(name: 'tax_rate') String taxRate,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variation_name') String? variationName,
    String? sku,
  });
}

/// @nodoc
class __$$PurchaseLineModelImplCopyWithImpl<$Res>
    extends _$PurchaseLineModelCopyWithImpl<$Res, _$PurchaseLineModelImpl>
    implements _$$PurchaseLineModelImplCopyWith<$Res> {
  __$$PurchaseLineModelImplCopyWithImpl(
    _$PurchaseLineModelImpl _value,
    $Res Function(_$PurchaseLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? purchaseOrderId = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? orderedQty = null,
    Object? receivedQty = null,
    Object? qtyRemaining = null,
    Object? costPerUnit = null,
    Object? taxRate = null,
    Object? batchNumber = freezed,
    Object? expiryDate = freezed,
    Object? productName = freezed,
    Object? variationName = freezed,
    Object? sku = freezed,
  }) {
    return _then(
      _$PurchaseLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        purchaseOrderId: null == purchaseOrderId
            ? _value.purchaseOrderId
            : purchaseOrderId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderedQty: null == orderedQty
            ? _value.orderedQty
            : orderedQty // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedQty: null == receivedQty
            ? _value.receivedQty
            : receivedQty // ignore: cast_nullable_to_non_nullable
                  as String,
        qtyRemaining: null == qtyRemaining
            ? _value.qtyRemaining
            : qtyRemaining // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerUnit: null == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        taxRate: null == taxRate
            ? _value.taxRate
            : taxRate // ignore: cast_nullable_to_non_nullable
                  as String,
        batchNumber: freezed == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        variationName: freezed == variationName
            ? _value.variationName
            : variationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sku: freezed == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseLineModelImpl extends _PurchaseLineModel {
  const _$PurchaseLineModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'purchase_order_id') required this.purchaseOrderId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'ordered_qty') required this.orderedQty,
    @JsonKey(name: 'received_qty') required this.receivedQty,
    @JsonKey(name: 'qty_remaining') required this.qtyRemaining,
    @JsonKey(name: 'cost_per_unit') required this.costPerUnit,
    @JsonKey(name: 'tax_rate') this.taxRate = '0',
    @JsonKey(name: 'batch_number') this.batchNumber,
    @JsonKey(name: 'expiry_date') this.expiryDate,
    @JsonKey(name: 'product_name') this.productName,
    @JsonKey(name: 'variation_name') this.variationName,
    this.sku,
  }) : super._();

  factory _$PurchaseLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'purchase_order_id')
  final String purchaseOrderId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'ordered_qty')
  final String orderedQty;
  @override
  @JsonKey(name: 'received_qty')
  final String receivedQty;
  @override
  @JsonKey(name: 'qty_remaining')
  final String qtyRemaining;
  @override
  @JsonKey(name: 'cost_per_unit')
  final String costPerUnit;
  @override
  @JsonKey(name: 'tax_rate')
  final String taxRate;
  @override
  @JsonKey(name: 'batch_number')
  final String? batchNumber;
  @override
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  @override
  @JsonKey(name: 'product_name')
  final String? productName;
  @override
  @JsonKey(name: 'variation_name')
  final String? variationName;
  @override
  final String? sku;

  @override
  String toString() {
    return 'PurchaseLineModel(id: $id, businessId: $businessId, purchaseOrderId: $purchaseOrderId, productId: $productId, variationId: $variationId, orderedQty: $orderedQty, receivedQty: $receivedQty, qtyRemaining: $qtyRemaining, costPerUnit: $costPerUnit, taxRate: $taxRate, batchNumber: $batchNumber, expiryDate: $expiryDate, productName: $productName, variationName: $variationName, sku: $sku)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.purchaseOrderId, purchaseOrderId) ||
                other.purchaseOrderId == purchaseOrderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.orderedQty, orderedQty) ||
                other.orderedQty == orderedQty) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty) &&
            (identical(other.qtyRemaining, qtyRemaining) ||
                other.qtyRemaining == qtyRemaining) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationName, variationName) ||
                other.variationName == variationName) &&
            (identical(other.sku, sku) || other.sku == sku));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    purchaseOrderId,
    productId,
    variationId,
    orderedQty,
    receivedQty,
    qtyRemaining,
    costPerUnit,
    taxRate,
    batchNumber,
    expiryDate,
    productName,
    variationName,
    sku,
  );

  /// Create a copy of PurchaseLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseLineModelImplCopyWith<_$PurchaseLineModelImpl> get copyWith =>
      __$$PurchaseLineModelImplCopyWithImpl<_$PurchaseLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseLineModelImplToJson(this);
  }
}

abstract class _PurchaseLineModel extends PurchaseLineModel {
  const factory _PurchaseLineModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'purchase_order_id') required final String purchaseOrderId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'ordered_qty') required final String orderedQty,
    @JsonKey(name: 'received_qty') required final String receivedQty,
    @JsonKey(name: 'qty_remaining') required final String qtyRemaining,
    @JsonKey(name: 'cost_per_unit') required final String costPerUnit,
    @JsonKey(name: 'tax_rate') final String taxRate,
    @JsonKey(name: 'batch_number') final String? batchNumber,
    @JsonKey(name: 'expiry_date') final String? expiryDate,
    @JsonKey(name: 'product_name') final String? productName,
    @JsonKey(name: 'variation_name') final String? variationName,
    final String? sku,
  }) = _$PurchaseLineModelImpl;
  const _PurchaseLineModel._() : super._();

  factory _PurchaseLineModel.fromJson(Map<String, dynamic> json) =
      _$PurchaseLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'purchase_order_id')
  String get purchaseOrderId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'ordered_qty')
  String get orderedQty;
  @override
  @JsonKey(name: 'received_qty')
  String get receivedQty;
  @override
  @JsonKey(name: 'qty_remaining')
  String get qtyRemaining;
  @override
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit;
  @override
  @JsonKey(name: 'tax_rate')
  String get taxRate;
  @override
  @JsonKey(name: 'batch_number')
  String? get batchNumber;
  @override
  @JsonKey(name: 'expiry_date')
  String? get expiryDate;
  @override
  @JsonKey(name: 'product_name')
  String? get productName;
  @override
  @JsonKey(name: 'variation_name')
  String? get variationName;
  @override
  String? get sku;

  /// Create a copy of PurchaseLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseLineModelImplCopyWith<_$PurchaseLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseOrderModel _$PurchaseOrderModelFromJson(Map<String, dynamic> json) {
  return _PurchaseOrderModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  String get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_at')
  String? get orderedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_at')
  String? get expectedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  SupplierModel? get supplier => throw _privateConstructorUsedError;
  List<PurchaseLineModel> get lines => throw _privateConstructorUsedError;

  /// Serializes this PurchaseOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseOrderModelCopyWith<PurchaseOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderModelCopyWith<$Res> {
  factory $PurchaseOrderModelCopyWith(
    PurchaseOrderModel value,
    $Res Function(PurchaseOrderModel) then,
  ) = _$PurchaseOrderModelCopyWithImpl<$Res, PurchaseOrderModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'supplier_id') String supplierId,
    @JsonKey(name: 'po_number') String poNumber,
    String status,
    @JsonKey(name: 'ordered_at') String? orderedAt,
    @JsonKey(name: 'expected_at') String? expectedAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    SupplierModel? supplier,
    List<PurchaseLineModel> lines,
  });

  $SupplierModelCopyWith<$Res>? get supplier;
}

/// @nodoc
class _$PurchaseOrderModelCopyWithImpl<$Res, $Val extends PurchaseOrderModel>
    implements $PurchaseOrderModelCopyWith<$Res> {
  _$PurchaseOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? supplierId = null,
    Object? poNumber = null,
    Object? status = null,
    Object? orderedAt = freezed,
    Object? expectedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? supplier = freezed,
    Object? lines = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            supplierId: null == supplierId
                ? _value.supplierId
                : supplierId // ignore: cast_nullable_to_non_nullable
                      as String,
            poNumber: null == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            orderedAt: freezed == orderedAt
                ? _value.orderedAt
                : orderedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            expectedAt: freezed == expectedAt
                ? _value.expectedAt
                : expectedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            supplier: freezed == supplier
                ? _value.supplier
                : supplier // ignore: cast_nullable_to_non_nullable
                      as SupplierModel?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<PurchaseLineModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of PurchaseOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupplierModelCopyWith<$Res>? get supplier {
    if (_value.supplier == null) {
      return null;
    }

    return $SupplierModelCopyWith<$Res>(_value.supplier!, (value) {
      return _then(_value.copyWith(supplier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchaseOrderModelImplCopyWith<$Res>
    implements $PurchaseOrderModelCopyWith<$Res> {
  factory _$$PurchaseOrderModelImplCopyWith(
    _$PurchaseOrderModelImpl value,
    $Res Function(_$PurchaseOrderModelImpl) then,
  ) = __$$PurchaseOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'supplier_id') String supplierId,
    @JsonKey(name: 'po_number') String poNumber,
    String status,
    @JsonKey(name: 'ordered_at') String? orderedAt,
    @JsonKey(name: 'expected_at') String? expectedAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    SupplierModel? supplier,
    List<PurchaseLineModel> lines,
  });

  @override
  $SupplierModelCopyWith<$Res>? get supplier;
}

/// @nodoc
class __$$PurchaseOrderModelImplCopyWithImpl<$Res>
    extends _$PurchaseOrderModelCopyWithImpl<$Res, _$PurchaseOrderModelImpl>
    implements _$$PurchaseOrderModelImplCopyWith<$Res> {
  __$$PurchaseOrderModelImplCopyWithImpl(
    _$PurchaseOrderModelImpl _value,
    $Res Function(_$PurchaseOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? supplierId = null,
    Object? poNumber = null,
    Object? status = null,
    Object? orderedAt = freezed,
    Object? expectedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? supplier = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$PurchaseOrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        supplierId: null == supplierId
            ? _value.supplierId
            : supplierId // ignore: cast_nullable_to_non_nullable
                  as String,
        poNumber: null == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        orderedAt: freezed == orderedAt
            ? _value.orderedAt
            : orderedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        expectedAt: freezed == expectedAt
            ? _value.expectedAt
            : expectedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        supplier: freezed == supplier
            ? _value.supplier
            : supplier // ignore: cast_nullable_to_non_nullable
                  as SupplierModel?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<PurchaseLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderModelImpl extends _PurchaseOrderModel {
  const _$PurchaseOrderModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'supplier_id') required this.supplierId,
    @JsonKey(name: 'po_number') required this.poNumber,
    required this.status,
    @JsonKey(name: 'ordered_at') this.orderedAt,
    @JsonKey(name: 'expected_at') this.expectedAt,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    this.supplier,
    final List<PurchaseLineModel> lines = const [],
  }) : _lines = lines,
       super._();

  factory _$PurchaseOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'supplier_id')
  final String supplierId;
  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'ordered_at')
  final String? orderedAt;
  @override
  @JsonKey(name: 'expected_at')
  final String? expectedAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  final SupplierModel? supplier;
  final List<PurchaseLineModel> _lines;
  @override
  @JsonKey()
  List<PurchaseLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'PurchaseOrderModel(id: $id, businessId: $businessId, branchId: $branchId, supplierId: $supplierId, poNumber: $poNumber, status: $status, orderedAt: $orderedAt, expectedAt: $expectedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, supplier: $supplier, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.orderedAt, orderedAt) ||
                other.orderedAt == orderedAt) &&
            (identical(other.expectedAt, expectedAt) ||
                other.expectedAt == expectedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    supplierId,
    poNumber,
    status,
    orderedAt,
    expectedAt,
    notes,
    createdAt,
    updatedAt,
    supplier,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of PurchaseOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderModelImplCopyWith<_$PurchaseOrderModelImpl> get copyWith =>
      __$$PurchaseOrderModelImplCopyWithImpl<_$PurchaseOrderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderModelImplToJson(this);
  }
}

abstract class _PurchaseOrderModel extends PurchaseOrderModel {
  const factory _PurchaseOrderModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'supplier_id') required final String supplierId,
    @JsonKey(name: 'po_number') required final String poNumber,
    required final String status,
    @JsonKey(name: 'ordered_at') final String? orderedAt,
    @JsonKey(name: 'expected_at') final String? expectedAt,
    final String? notes,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final SupplierModel? supplier,
    final List<PurchaseLineModel> lines,
  }) = _$PurchaseOrderModelImpl;
  const _PurchaseOrderModel._() : super._();

  factory _PurchaseOrderModel.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'supplier_id')
  String get supplierId;
  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'ordered_at')
  String? get orderedAt;
  @override
  @JsonKey(name: 'expected_at')
  String? get expectedAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  SupplierModel? get supplier;
  @override
  List<PurchaseLineModel> get lines;

  /// Create a copy of PurchaseOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseOrderModelImplCopyWith<_$PurchaseOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseReceiptLineModel _$PurchaseReceiptLineModelFromJson(
  Map<String, dynamic> json,
) {
  return _PurchaseReceiptLineModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseReceiptLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_receipt_id')
  String get purchaseReceiptId => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_line_id')
  String? get purchaseLineId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_received')
  String get qtyReceived => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_number')
  String? get batchNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  String? get expiryDate => throw _privateConstructorUsedError;

  /// Serializes this PurchaseReceiptLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseReceiptLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseReceiptLineModelCopyWith<PurchaseReceiptLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseReceiptLineModelCopyWith<$Res> {
  factory $PurchaseReceiptLineModelCopyWith(
    PurchaseReceiptLineModel value,
    $Res Function(PurchaseReceiptLineModel) then,
  ) = _$PurchaseReceiptLineModelCopyWithImpl<$Res, PurchaseReceiptLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'purchase_receipt_id') String purchaseReceiptId,
    @JsonKey(name: 'purchase_line_id') String? purchaseLineId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_received') String qtyReceived,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
  });
}

/// @nodoc
class _$PurchaseReceiptLineModelCopyWithImpl<
  $Res,
  $Val extends PurchaseReceiptLineModel
>
    implements $PurchaseReceiptLineModelCopyWith<$Res> {
  _$PurchaseReceiptLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseReceiptLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? purchaseReceiptId = null,
    Object? purchaseLineId = freezed,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qtyReceived = null,
    Object? costPerUnit = null,
    Object? batchNumber = freezed,
    Object? expiryDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            purchaseReceiptId: null == purchaseReceiptId
                ? _value.purchaseReceiptId
                : purchaseReceiptId // ignore: cast_nullable_to_non_nullable
                      as String,
            purchaseLineId: freezed == purchaseLineId
                ? _value.purchaseLineId
                : purchaseLineId // ignore: cast_nullable_to_non_nullable
                      as String?,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qtyReceived: null == qtyReceived
                ? _value.qtyReceived
                : qtyReceived // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerUnit: null == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            batchNumber: freezed == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseReceiptLineModelImplCopyWith<$Res>
    implements $PurchaseReceiptLineModelCopyWith<$Res> {
  factory _$$PurchaseReceiptLineModelImplCopyWith(
    _$PurchaseReceiptLineModelImpl value,
    $Res Function(_$PurchaseReceiptLineModelImpl) then,
  ) = __$$PurchaseReceiptLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'purchase_receipt_id') String purchaseReceiptId,
    @JsonKey(name: 'purchase_line_id') String? purchaseLineId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_received') String qtyReceived,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
  });
}

/// @nodoc
class __$$PurchaseReceiptLineModelImplCopyWithImpl<$Res>
    extends
        _$PurchaseReceiptLineModelCopyWithImpl<
          $Res,
          _$PurchaseReceiptLineModelImpl
        >
    implements _$$PurchaseReceiptLineModelImplCopyWith<$Res> {
  __$$PurchaseReceiptLineModelImplCopyWithImpl(
    _$PurchaseReceiptLineModelImpl _value,
    $Res Function(_$PurchaseReceiptLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseReceiptLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? purchaseReceiptId = null,
    Object? purchaseLineId = freezed,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qtyReceived = null,
    Object? costPerUnit = null,
    Object? batchNumber = freezed,
    Object? expiryDate = freezed,
  }) {
    return _then(
      _$PurchaseReceiptLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        purchaseReceiptId: null == purchaseReceiptId
            ? _value.purchaseReceiptId
            : purchaseReceiptId // ignore: cast_nullable_to_non_nullable
                  as String,
        purchaseLineId: freezed == purchaseLineId
            ? _value.purchaseLineId
            : purchaseLineId // ignore: cast_nullable_to_non_nullable
                  as String?,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qtyReceived: null == qtyReceived
            ? _value.qtyReceived
            : qtyReceived // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerUnit: null == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        batchNumber: freezed == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseReceiptLineModelImpl implements _PurchaseReceiptLineModel {
  const _$PurchaseReceiptLineModelImpl({
    required this.id,
    @JsonKey(name: 'purchase_receipt_id') required this.purchaseReceiptId,
    @JsonKey(name: 'purchase_line_id') this.purchaseLineId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'qty_received') required this.qtyReceived,
    @JsonKey(name: 'cost_per_unit') required this.costPerUnit,
    @JsonKey(name: 'batch_number') this.batchNumber,
    @JsonKey(name: 'expiry_date') this.expiryDate,
  });

  factory _$PurchaseReceiptLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseReceiptLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'purchase_receipt_id')
  final String purchaseReceiptId;
  @override
  @JsonKey(name: 'purchase_line_id')
  final String? purchaseLineId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'qty_received')
  final String qtyReceived;
  @override
  @JsonKey(name: 'cost_per_unit')
  final String costPerUnit;
  @override
  @JsonKey(name: 'batch_number')
  final String? batchNumber;
  @override
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;

  @override
  String toString() {
    return 'PurchaseReceiptLineModel(id: $id, purchaseReceiptId: $purchaseReceiptId, purchaseLineId: $purchaseLineId, productId: $productId, variationId: $variationId, qtyReceived: $qtyReceived, costPerUnit: $costPerUnit, batchNumber: $batchNumber, expiryDate: $expiryDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseReceiptLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.purchaseReceiptId, purchaseReceiptId) ||
                other.purchaseReceiptId == purchaseReceiptId) &&
            (identical(other.purchaseLineId, purchaseLineId) ||
                other.purchaseLineId == purchaseLineId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qtyReceived, qtyReceived) ||
                other.qtyReceived == qtyReceived) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    purchaseReceiptId,
    purchaseLineId,
    productId,
    variationId,
    qtyReceived,
    costPerUnit,
    batchNumber,
    expiryDate,
  );

  /// Create a copy of PurchaseReceiptLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseReceiptLineModelImplCopyWith<_$PurchaseReceiptLineModelImpl>
  get copyWith =>
      __$$PurchaseReceiptLineModelImplCopyWithImpl<
        _$PurchaseReceiptLineModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseReceiptLineModelImplToJson(this);
  }
}

abstract class _PurchaseReceiptLineModel implements PurchaseReceiptLineModel {
  const factory _PurchaseReceiptLineModel({
    required final String id,
    @JsonKey(name: 'purchase_receipt_id')
    required final String purchaseReceiptId,
    @JsonKey(name: 'purchase_line_id') final String? purchaseLineId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'qty_received') required final String qtyReceived,
    @JsonKey(name: 'cost_per_unit') required final String costPerUnit,
    @JsonKey(name: 'batch_number') final String? batchNumber,
    @JsonKey(name: 'expiry_date') final String? expiryDate,
  }) = _$PurchaseReceiptLineModelImpl;

  factory _PurchaseReceiptLineModel.fromJson(Map<String, dynamic> json) =
      _$PurchaseReceiptLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'purchase_receipt_id')
  String get purchaseReceiptId;
  @override
  @JsonKey(name: 'purchase_line_id')
  String? get purchaseLineId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'qty_received')
  String get qtyReceived;
  @override
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit;
  @override
  @JsonKey(name: 'batch_number')
  String? get batchNumber;
  @override
  @JsonKey(name: 'expiry_date')
  String? get expiryDate;

  /// Create a copy of PurchaseReceiptLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseReceiptLineModelImplCopyWith<_$PurchaseReceiptLineModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PurchaseReceiptModel _$PurchaseReceiptModelFromJson(Map<String, dynamic> json) {
  return _PurchaseReceiptModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseReceiptModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  String get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_order_id')
  String? get purchaseOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_number')
  String get receiptNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_at')
  String get receivedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_invoice_no')
  String? get supplierInvoiceNo => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<PurchaseReceiptLineModel> get lines =>
      throw _privateConstructorUsedError;

  /// Serializes this PurchaseReceiptModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseReceiptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseReceiptModelCopyWith<PurchaseReceiptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseReceiptModelCopyWith<$Res> {
  factory $PurchaseReceiptModelCopyWith(
    PurchaseReceiptModel value,
    $Res Function(PurchaseReceiptModel) then,
  ) = _$PurchaseReceiptModelCopyWithImpl<$Res, PurchaseReceiptModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'supplier_id') String supplierId,
    @JsonKey(name: 'purchase_order_id') String? purchaseOrderId,
    @JsonKey(name: 'receipt_number') String receiptNumber,
    @JsonKey(name: 'received_at') String receivedAt,
    @JsonKey(name: 'supplier_invoice_no') String? supplierInvoiceNo,
    String? notes,
    List<PurchaseReceiptLineModel> lines,
  });
}

/// @nodoc
class _$PurchaseReceiptModelCopyWithImpl<
  $Res,
  $Val extends PurchaseReceiptModel
>
    implements $PurchaseReceiptModelCopyWith<$Res> {
  _$PurchaseReceiptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseReceiptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? supplierId = null,
    Object? purchaseOrderId = freezed,
    Object? receiptNumber = null,
    Object? receivedAt = null,
    Object? supplierInvoiceNo = freezed,
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
            supplierId: null == supplierId
                ? _value.supplierId
                : supplierId // ignore: cast_nullable_to_non_nullable
                      as String,
            purchaseOrderId: freezed == purchaseOrderId
                ? _value.purchaseOrderId
                : purchaseOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiptNumber: null == receiptNumber
                ? _value.receiptNumber
                : receiptNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            receivedAt: null == receivedAt
                ? _value.receivedAt
                : receivedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            supplierInvoiceNo: freezed == supplierInvoiceNo
                ? _value.supplierInvoiceNo
                : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<PurchaseReceiptLineModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseReceiptModelImplCopyWith<$Res>
    implements $PurchaseReceiptModelCopyWith<$Res> {
  factory _$$PurchaseReceiptModelImplCopyWith(
    _$PurchaseReceiptModelImpl value,
    $Res Function(_$PurchaseReceiptModelImpl) then,
  ) = __$$PurchaseReceiptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'supplier_id') String supplierId,
    @JsonKey(name: 'purchase_order_id') String? purchaseOrderId,
    @JsonKey(name: 'receipt_number') String receiptNumber,
    @JsonKey(name: 'received_at') String receivedAt,
    @JsonKey(name: 'supplier_invoice_no') String? supplierInvoiceNo,
    String? notes,
    List<PurchaseReceiptLineModel> lines,
  });
}

/// @nodoc
class __$$PurchaseReceiptModelImplCopyWithImpl<$Res>
    extends _$PurchaseReceiptModelCopyWithImpl<$Res, _$PurchaseReceiptModelImpl>
    implements _$$PurchaseReceiptModelImplCopyWith<$Res> {
  __$$PurchaseReceiptModelImplCopyWithImpl(
    _$PurchaseReceiptModelImpl _value,
    $Res Function(_$PurchaseReceiptModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseReceiptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? supplierId = null,
    Object? purchaseOrderId = freezed,
    Object? receiptNumber = null,
    Object? receivedAt = null,
    Object? supplierInvoiceNo = freezed,
    Object? notes = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$PurchaseReceiptModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        supplierId: null == supplierId
            ? _value.supplierId
            : supplierId // ignore: cast_nullable_to_non_nullable
                  as String,
        purchaseOrderId: freezed == purchaseOrderId
            ? _value.purchaseOrderId
            : purchaseOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiptNumber: null == receiptNumber
            ? _value.receiptNumber
            : receiptNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: null == receivedAt
            ? _value.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        supplierInvoiceNo: freezed == supplierInvoiceNo
            ? _value.supplierInvoiceNo
            : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<PurchaseReceiptLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseReceiptModelImpl implements _PurchaseReceiptModel {
  const _$PurchaseReceiptModelImpl({
    required this.id,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'supplier_id') required this.supplierId,
    @JsonKey(name: 'purchase_order_id') this.purchaseOrderId,
    @JsonKey(name: 'receipt_number') required this.receiptNumber,
    @JsonKey(name: 'received_at') required this.receivedAt,
    @JsonKey(name: 'supplier_invoice_no') this.supplierInvoiceNo,
    this.notes,
    final List<PurchaseReceiptLineModel> lines = const [],
  }) : _lines = lines;

  factory _$PurchaseReceiptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseReceiptModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'supplier_id')
  final String supplierId;
  @override
  @JsonKey(name: 'purchase_order_id')
  final String? purchaseOrderId;
  @override
  @JsonKey(name: 'receipt_number')
  final String receiptNumber;
  @override
  @JsonKey(name: 'received_at')
  final String receivedAt;
  @override
  @JsonKey(name: 'supplier_invoice_no')
  final String? supplierInvoiceNo;
  @override
  final String? notes;
  final List<PurchaseReceiptLineModel> _lines;
  @override
  @JsonKey()
  List<PurchaseReceiptLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'PurchaseReceiptModel(id: $id, branchId: $branchId, supplierId: $supplierId, purchaseOrderId: $purchaseOrderId, receiptNumber: $receiptNumber, receivedAt: $receivedAt, supplierInvoiceNo: $supplierInvoiceNo, notes: $notes, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseReceiptModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.purchaseOrderId, purchaseOrderId) ||
                other.purchaseOrderId == purchaseOrderId) &&
            (identical(other.receiptNumber, receiptNumber) ||
                other.receiptNumber == receiptNumber) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.supplierInvoiceNo, supplierInvoiceNo) ||
                other.supplierInvoiceNo == supplierInvoiceNo) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    branchId,
    supplierId,
    purchaseOrderId,
    receiptNumber,
    receivedAt,
    supplierInvoiceNo,
    notes,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of PurchaseReceiptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseReceiptModelImplCopyWith<_$PurchaseReceiptModelImpl>
  get copyWith =>
      __$$PurchaseReceiptModelImplCopyWithImpl<_$PurchaseReceiptModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseReceiptModelImplToJson(this);
  }
}

abstract class _PurchaseReceiptModel implements PurchaseReceiptModel {
  const factory _PurchaseReceiptModel({
    required final String id,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'supplier_id') required final String supplierId,
    @JsonKey(name: 'purchase_order_id') final String? purchaseOrderId,
    @JsonKey(name: 'receipt_number') required final String receiptNumber,
    @JsonKey(name: 'received_at') required final String receivedAt,
    @JsonKey(name: 'supplier_invoice_no') final String? supplierInvoiceNo,
    final String? notes,
    final List<PurchaseReceiptLineModel> lines,
  }) = _$PurchaseReceiptModelImpl;

  factory _PurchaseReceiptModel.fromJson(Map<String, dynamic> json) =
      _$PurchaseReceiptModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'supplier_id')
  String get supplierId;
  @override
  @JsonKey(name: 'purchase_order_id')
  String? get purchaseOrderId;
  @override
  @JsonKey(name: 'receipt_number')
  String get receiptNumber;
  @override
  @JsonKey(name: 'received_at')
  String get receivedAt;
  @override
  @JsonKey(name: 'supplier_invoice_no')
  String? get supplierInvoiceNo;
  @override
  String? get notes;
  @override
  List<PurchaseReceiptLineModel> get lines;

  /// Create a copy of PurchaseReceiptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseReceiptModelImplCopyWith<_$PurchaseReceiptModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
