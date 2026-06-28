// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SaleListItemModel _$SaleListItemModelFromJson(Map<String, dynamic> json) {
  return _SaleListItemModel.fromJson(json);
}

/// @nodoc
mixin _$SaleListItemModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_number')
  String get saleNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_type')
  String get saleType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'sold_at')
  String get soldAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  String? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_paid')
  String? get totalPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance_due')
  String? get balanceDue => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'cashier_name')
  String? get cashierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_count')
  int? get itemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_names')
  List<String> get productNames => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_methods')
  List<String> get paymentMethods => throw _privateConstructorUsedError;

  /// Serializes this SaleListItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleListItemModelCopyWith<SaleListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleListItemModelCopyWith<$Res> {
  factory $SaleListItemModelCopyWith(
    SaleListItemModel value,
    $Res Function(SaleListItemModel) then,
  ) = _$SaleListItemModelCopyWithImpl<$Res, SaleListItemModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'sale_number') String saleNumber,
    @JsonKey(name: 'sale_type') String saleType,
    String status,
    @JsonKey(name: 'sold_at') String soldAt,
    @JsonKey(name: 'total_amount') String? totalAmount,
    @JsonKey(name: 'total_paid') String? totalPaid,
    @JsonKey(name: 'balance_due') String? balanceDue,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'cashier_name') String? cashierName,
    @JsonKey(name: 'item_count') int? itemCount,
    @JsonKey(name: 'product_names') List<String> productNames,
    @JsonKey(name: 'payment_methods') List<String> paymentMethods,
  });
}

/// @nodoc
class _$SaleListItemModelCopyWithImpl<$Res, $Val extends SaleListItemModel>
    implements $SaleListItemModelCopyWith<$Res> {
  _$SaleListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? customerId = freezed,
    Object? saleNumber = null,
    Object? saleType = null,
    Object? status = null,
    Object? soldAt = null,
    Object? totalAmount = freezed,
    Object? totalPaid = freezed,
    Object? balanceDue = freezed,
    Object? customerName = freezed,
    Object? cashierName = freezed,
    Object? itemCount = freezed,
    Object? productNames = null,
    Object? paymentMethods = null,
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
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            saleNumber: null == saleNumber
                ? _value.saleNumber
                : saleNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            saleType: null == saleType
                ? _value.saleType
                : saleType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            soldAt: null == soldAt
                ? _value.soldAt
                : soldAt // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: freezed == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalPaid: freezed == totalPaid
                ? _value.totalPaid
                : totalPaid // ignore: cast_nullable_to_non_nullable
                      as String?,
            balanceDue: freezed == balanceDue
                ? _value.balanceDue
                : balanceDue // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            cashierName: freezed == cashierName
                ? _value.cashierName
                : cashierName // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemCount: freezed == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            productNames: null == productNames
                ? _value.productNames
                : productNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            paymentMethods: null == paymentMethods
                ? _value.paymentMethods
                : paymentMethods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleListItemModelImplCopyWith<$Res>
    implements $SaleListItemModelCopyWith<$Res> {
  factory _$$SaleListItemModelImplCopyWith(
    _$SaleListItemModelImpl value,
    $Res Function(_$SaleListItemModelImpl) then,
  ) = __$$SaleListItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'sale_number') String saleNumber,
    @JsonKey(name: 'sale_type') String saleType,
    String status,
    @JsonKey(name: 'sold_at') String soldAt,
    @JsonKey(name: 'total_amount') String? totalAmount,
    @JsonKey(name: 'total_paid') String? totalPaid,
    @JsonKey(name: 'balance_due') String? balanceDue,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'cashier_name') String? cashierName,
    @JsonKey(name: 'item_count') int? itemCount,
    @JsonKey(name: 'product_names') List<String> productNames,
    @JsonKey(name: 'payment_methods') List<String> paymentMethods,
  });
}

/// @nodoc
class __$$SaleListItemModelImplCopyWithImpl<$Res>
    extends _$SaleListItemModelCopyWithImpl<$Res, _$SaleListItemModelImpl>
    implements _$$SaleListItemModelImplCopyWith<$Res> {
  __$$SaleListItemModelImplCopyWithImpl(
    _$SaleListItemModelImpl _value,
    $Res Function(_$SaleListItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? customerId = freezed,
    Object? saleNumber = null,
    Object? saleType = null,
    Object? status = null,
    Object? soldAt = null,
    Object? totalAmount = freezed,
    Object? totalPaid = freezed,
    Object? balanceDue = freezed,
    Object? customerName = freezed,
    Object? cashierName = freezed,
    Object? itemCount = freezed,
    Object? productNames = null,
    Object? paymentMethods = null,
  }) {
    return _then(
      _$SaleListItemModelImpl(
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
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        saleNumber: null == saleNumber
            ? _value.saleNumber
            : saleNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        saleType: null == saleType
            ? _value.saleType
            : saleType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        soldAt: null == soldAt
            ? _value.soldAt
            : soldAt // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: freezed == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalPaid: freezed == totalPaid
            ? _value.totalPaid
            : totalPaid // ignore: cast_nullable_to_non_nullable
                  as String?,
        balanceDue: freezed == balanceDue
            ? _value.balanceDue
            : balanceDue // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        cashierName: freezed == cashierName
            ? _value.cashierName
            : cashierName // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemCount: freezed == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        productNames: null == productNames
            ? _value._productNames
            : productNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        paymentMethods: null == paymentMethods
            ? _value._paymentMethods
            : paymentMethods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleListItemModelImpl implements _SaleListItemModel {
  const _$SaleListItemModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'customer_id') this.customerId,
    @JsonKey(name: 'sale_number') required this.saleNumber,
    @JsonKey(name: 'sale_type') required this.saleType,
    required this.status,
    @JsonKey(name: 'sold_at') required this.soldAt,
    @JsonKey(name: 'total_amount') this.totalAmount,
    @JsonKey(name: 'total_paid') this.totalPaid,
    @JsonKey(name: 'balance_due') this.balanceDue,
    @JsonKey(name: 'customer_name') this.customerName,
    @JsonKey(name: 'cashier_name') this.cashierName,
    @JsonKey(name: 'item_count') this.itemCount,
    @JsonKey(name: 'product_names') final List<String> productNames = const [],
    @JsonKey(name: 'payment_methods')
    final List<String> paymentMethods = const [],
  }) : _productNames = productNames,
       _paymentMethods = paymentMethods;

  factory _$SaleListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleListItemModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'customer_id')
  final String? customerId;
  @override
  @JsonKey(name: 'sale_number')
  final String saleNumber;
  @override
  @JsonKey(name: 'sale_type')
  final String saleType;
  @override
  final String status;
  @override
  @JsonKey(name: 'sold_at')
  final String soldAt;
  @override
  @JsonKey(name: 'total_amount')
  final String? totalAmount;
  @override
  @JsonKey(name: 'total_paid')
  final String? totalPaid;
  @override
  @JsonKey(name: 'balance_due')
  final String? balanceDue;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'cashier_name')
  final String? cashierName;
  @override
  @JsonKey(name: 'item_count')
  final int? itemCount;
  final List<String> _productNames;
  @override
  @JsonKey(name: 'product_names')
  List<String> get productNames {
    if (_productNames is EqualUnmodifiableListView) return _productNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productNames);
  }

  final List<String> _paymentMethods;
  @override
  @JsonKey(name: 'payment_methods')
  List<String> get paymentMethods {
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentMethods);
  }

  @override
  String toString() {
    return 'SaleListItemModel(id: $id, businessId: $businessId, branchId: $branchId, customerId: $customerId, saleNumber: $saleNumber, saleType: $saleType, status: $status, soldAt: $soldAt, totalAmount: $totalAmount, totalPaid: $totalPaid, balanceDue: $balanceDue, customerName: $customerName, cashierName: $cashierName, itemCount: $itemCount, productNames: $productNames, paymentMethods: $paymentMethods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleListItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.saleNumber, saleNumber) ||
                other.saleNumber == saleNumber) &&
            (identical(other.saleType, saleType) ||
                other.saleType == saleType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.soldAt, soldAt) || other.soldAt == soldAt) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.balanceDue, balanceDue) ||
                other.balanceDue == balanceDue) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.cashierName, cashierName) ||
                other.cashierName == cashierName) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            const DeepCollectionEquality().equals(
              other._productNames,
              _productNames,
            ) &&
            const DeepCollectionEquality().equals(
              other._paymentMethods,
              _paymentMethods,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    customerId,
    saleNumber,
    saleType,
    status,
    soldAt,
    totalAmount,
    totalPaid,
    balanceDue,
    customerName,
    cashierName,
    itemCount,
    const DeepCollectionEquality().hash(_productNames),
    const DeepCollectionEquality().hash(_paymentMethods),
  );

  /// Create a copy of SaleListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleListItemModelImplCopyWith<_$SaleListItemModelImpl> get copyWith =>
      __$$SaleListItemModelImplCopyWithImpl<_$SaleListItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleListItemModelImplToJson(this);
  }
}

abstract class _SaleListItemModel implements SaleListItemModel {
  const factory _SaleListItemModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'customer_id') final String? customerId,
    @JsonKey(name: 'sale_number') required final String saleNumber,
    @JsonKey(name: 'sale_type') required final String saleType,
    required final String status,
    @JsonKey(name: 'sold_at') required final String soldAt,
    @JsonKey(name: 'total_amount') final String? totalAmount,
    @JsonKey(name: 'total_paid') final String? totalPaid,
    @JsonKey(name: 'balance_due') final String? balanceDue,
    @JsonKey(name: 'customer_name') final String? customerName,
    @JsonKey(name: 'cashier_name') final String? cashierName,
    @JsonKey(name: 'item_count') final int? itemCount,
    @JsonKey(name: 'product_names') final List<String> productNames,
    @JsonKey(name: 'payment_methods') final List<String> paymentMethods,
  }) = _$SaleListItemModelImpl;

  factory _SaleListItemModel.fromJson(Map<String, dynamic> json) =
      _$SaleListItemModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'customer_id')
  String? get customerId;
  @override
  @JsonKey(name: 'sale_number')
  String get saleNumber;
  @override
  @JsonKey(name: 'sale_type')
  String get saleType;
  @override
  String get status;
  @override
  @JsonKey(name: 'sold_at')
  String get soldAt;
  @override
  @JsonKey(name: 'total_amount')
  String? get totalAmount;
  @override
  @JsonKey(name: 'total_paid')
  String? get totalPaid;
  @override
  @JsonKey(name: 'balance_due')
  String? get balanceDue;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  @JsonKey(name: 'cashier_name')
  String? get cashierName;
  @override
  @JsonKey(name: 'item_count')
  int? get itemCount;
  @override
  @JsonKey(name: 'product_names')
  List<String> get productNames;
  @override
  @JsonKey(name: 'payment_methods')
  List<String> get paymentMethods;

  /// Create a copy of SaleListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleListItemModelImplCopyWith<_$SaleListItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
