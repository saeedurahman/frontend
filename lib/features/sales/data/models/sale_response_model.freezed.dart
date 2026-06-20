// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SaleLineModel _$SaleLineModelFromJson(Map<String, dynamic> json) {
  return _SaleLineModel.fromJson(json);
}

/// @nodoc
mixin _$SaleLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  String get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  String get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_pct')
  String get discountPct => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  String get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate')
  String get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  String? get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_total')
  String? get lineTotal => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_order')
  int? get lineOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_name')
  String? get variationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'returned_qty')
  String get returnedQty => throw _privateConstructorUsedError;

  /// Serializes this SaleLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleLineModelCopyWith<SaleLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleLineModelCopyWith<$Res> {
  factory $SaleLineModelCopyWith(
    SaleLineModel value,
    $Res Function(SaleLineModel) then,
  ) = _$SaleLineModelCopyWithImpl<$Res, SaleLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'discount_pct') String discountPct,
    @JsonKey(name: 'discount_amount') String discountAmount,
    @JsonKey(name: 'tax_rate') String taxRate,
    @JsonKey(name: 'tax_amount') String? taxAmount,
    @JsonKey(name: 'line_total') String? lineTotal,
    String? notes,
    @JsonKey(name: 'line_order') int? lineOrder,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variation_name') String? variationName,
    @JsonKey(name: 'returned_qty') String returnedQty,
  });
}

/// @nodoc
class _$SaleLineModelCopyWithImpl<$Res, $Val extends SaleLineModel>
    implements $SaleLineModelCopyWith<$Res> {
  _$SaleLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? unitPrice = null,
    Object? discountPct = null,
    Object? discountAmount = null,
    Object? taxRate = null,
    Object? taxAmount = freezed,
    Object? lineTotal = freezed,
    Object? notes = freezed,
    Object? lineOrder = freezed,
    Object? productName = freezed,
    Object? variationName = freezed,
    Object? returnedQty = null,
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
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as String,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as String,
            discountPct: null == discountPct
                ? _value.discountPct
                : discountPct // ignore: cast_nullable_to_non_nullable
                      as String,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            taxRate: null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                      as String,
            taxAmount: freezed == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as String?,
            lineTotal: freezed == lineTotal
                ? _value.lineTotal
                : lineTotal // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            lineOrder: freezed == lineOrder
                ? _value.lineOrder
                : lineOrder // ignore: cast_nullable_to_non_nullable
                      as int?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            variationName: freezed == variationName
                ? _value.variationName
                : variationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            returnedQty: null == returnedQty
                ? _value.returnedQty
                : returnedQty // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleLineModelImplCopyWith<$Res>
    implements $SaleLineModelCopyWith<$Res> {
  factory _$$SaleLineModelImplCopyWith(
    _$SaleLineModelImpl value,
    $Res Function(_$SaleLineModelImpl) then,
  ) = __$$SaleLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'discount_pct') String discountPct,
    @JsonKey(name: 'discount_amount') String discountAmount,
    @JsonKey(name: 'tax_rate') String taxRate,
    @JsonKey(name: 'tax_amount') String? taxAmount,
    @JsonKey(name: 'line_total') String? lineTotal,
    String? notes,
    @JsonKey(name: 'line_order') int? lineOrder,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variation_name') String? variationName,
    @JsonKey(name: 'returned_qty') String returnedQty,
  });
}

/// @nodoc
class __$$SaleLineModelImplCopyWithImpl<$Res>
    extends _$SaleLineModelCopyWithImpl<$Res, _$SaleLineModelImpl>
    implements _$$SaleLineModelImplCopyWith<$Res> {
  __$$SaleLineModelImplCopyWithImpl(
    _$SaleLineModelImpl _value,
    $Res Function(_$SaleLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? unitPrice = null,
    Object? discountPct = null,
    Object? discountAmount = null,
    Object? taxRate = null,
    Object? taxAmount = freezed,
    Object? lineTotal = freezed,
    Object? notes = freezed,
    Object? lineOrder = freezed,
    Object? productName = freezed,
    Object? variationName = freezed,
    Object? returnedQty = null,
  }) {
    return _then(
      _$SaleLineModelImpl(
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
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as String,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as String,
        discountPct: null == discountPct
            ? _value.discountPct
            : discountPct // ignore: cast_nullable_to_non_nullable
                  as String,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        taxRate: null == taxRate
            ? _value.taxRate
            : taxRate // ignore: cast_nullable_to_non_nullable
                  as String,
        taxAmount: freezed == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as String?,
        lineTotal: freezed == lineTotal
            ? _value.lineTotal
            : lineTotal // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        lineOrder: freezed == lineOrder
            ? _value.lineOrder
            : lineOrder // ignore: cast_nullable_to_non_nullable
                  as int?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        variationName: freezed == variationName
            ? _value.variationName
            : variationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        returnedQty: null == returnedQty
            ? _value.returnedQty
            : returnedQty // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleLineModelImpl implements _SaleLineModel {
  const _$SaleLineModelImpl({
    required this.id,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    required this.qty,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    @JsonKey(name: 'discount_pct') this.discountPct = '0',
    @JsonKey(name: 'discount_amount') this.discountAmount = '0',
    @JsonKey(name: 'tax_rate') this.taxRate = '0',
    @JsonKey(name: 'tax_amount') this.taxAmount,
    @JsonKey(name: 'line_total') this.lineTotal,
    this.notes,
    @JsonKey(name: 'line_order') this.lineOrder,
    @JsonKey(name: 'product_name') this.productName,
    @JsonKey(name: 'variation_name') this.variationName,
    @JsonKey(name: 'returned_qty') this.returnedQty = '0',
  });

  factory _$SaleLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  final String qty;
  @override
  @JsonKey(name: 'unit_price')
  final String unitPrice;
  @override
  @JsonKey(name: 'discount_pct')
  final String discountPct;
  @override
  @JsonKey(name: 'discount_amount')
  final String discountAmount;
  @override
  @JsonKey(name: 'tax_rate')
  final String taxRate;
  @override
  @JsonKey(name: 'tax_amount')
  final String? taxAmount;
  @override
  @JsonKey(name: 'line_total')
  final String? lineTotal;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'line_order')
  final int? lineOrder;
  @override
  @JsonKey(name: 'product_name')
  final String? productName;
  @override
  @JsonKey(name: 'variation_name')
  final String? variationName;
  @override
  @JsonKey(name: 'returned_qty')
  final String returnedQty;

  @override
  String toString() {
    return 'SaleLineModel(id: $id, productId: $productId, variationId: $variationId, qty: $qty, unitPrice: $unitPrice, discountPct: $discountPct, discountAmount: $discountAmount, taxRate: $taxRate, taxAmount: $taxAmount, lineTotal: $lineTotal, notes: $notes, lineOrder: $lineOrder, productName: $productName, variationName: $variationName, returnedQty: $returnedQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discountPct, discountPct) ||
                other.discountPct == discountPct) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lineOrder, lineOrder) ||
                other.lineOrder == lineOrder) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationName, variationName) ||
                other.variationName == variationName) &&
            (identical(other.returnedQty, returnedQty) ||
                other.returnedQty == returnedQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    variationId,
    qty,
    unitPrice,
    discountPct,
    discountAmount,
    taxRate,
    taxAmount,
    lineTotal,
    notes,
    lineOrder,
    productName,
    variationName,
    returnedQty,
  );

  /// Create a copy of SaleLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleLineModelImplCopyWith<_$SaleLineModelImpl> get copyWith =>
      __$$SaleLineModelImplCopyWithImpl<_$SaleLineModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleLineModelImplToJson(this);
  }
}

abstract class _SaleLineModel implements SaleLineModel {
  const factory _SaleLineModel({
    required final String id,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    required final String qty,
    @JsonKey(name: 'unit_price') required final String unitPrice,
    @JsonKey(name: 'discount_pct') final String discountPct,
    @JsonKey(name: 'discount_amount') final String discountAmount,
    @JsonKey(name: 'tax_rate') final String taxRate,
    @JsonKey(name: 'tax_amount') final String? taxAmount,
    @JsonKey(name: 'line_total') final String? lineTotal,
    final String? notes,
    @JsonKey(name: 'line_order') final int? lineOrder,
    @JsonKey(name: 'product_name') final String? productName,
    @JsonKey(name: 'variation_name') final String? variationName,
    @JsonKey(name: 'returned_qty') final String returnedQty,
  }) = _$SaleLineModelImpl;

  factory _SaleLineModel.fromJson(Map<String, dynamic> json) =
      _$SaleLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  String get qty;
  @override
  @JsonKey(name: 'unit_price')
  String get unitPrice;
  @override
  @JsonKey(name: 'discount_pct')
  String get discountPct;
  @override
  @JsonKey(name: 'discount_amount')
  String get discountAmount;
  @override
  @JsonKey(name: 'tax_rate')
  String get taxRate;
  @override
  @JsonKey(name: 'tax_amount')
  String? get taxAmount;
  @override
  @JsonKey(name: 'line_total')
  String? get lineTotal;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'line_order')
  int? get lineOrder;
  @override
  @JsonKey(name: 'product_name')
  String? get productName;
  @override
  @JsonKey(name: 'variation_name')
  String? get variationName;
  @override
  @JsonKey(name: 'returned_qty')
  String get returnedQty;

  /// Create a copy of SaleLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleLineModelImplCopyWith<_$SaleLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalePaymentModel _$SalePaymentModelFromJson(Map<String, dynamic> json) {
  return _SalePaymentModel.fromJson(json);
}

/// @nodoc
mixin _$SalePaymentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_no')
  String? get referenceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  String? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this SalePaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalePaymentModelCopyWith<SalePaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalePaymentModelCopyWith<$Res> {
  factory $SalePaymentModelCopyWith(
    SalePaymentModel value,
    $Res Function(SalePaymentModel) then,
  ) = _$SalePaymentModelCopyWithImpl<$Res, SalePaymentModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'payment_method') String paymentMethod,
    String amount,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
  });
}

/// @nodoc
class _$SalePaymentModelCopyWithImpl<$Res, $Val extends SalePaymentModel>
    implements $SalePaymentModelCopyWith<$Res> {
  _$SalePaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? referenceNo = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceNo: freezed == referenceNo
                ? _value.referenceNo
                : referenceNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalePaymentModelImplCopyWith<$Res>
    implements $SalePaymentModelCopyWith<$Res> {
  factory _$$SalePaymentModelImplCopyWith(
    _$SalePaymentModelImpl value,
    $Res Function(_$SalePaymentModelImpl) then,
  ) = __$$SalePaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'payment_method') String paymentMethod,
    String amount,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
  });
}

/// @nodoc
class __$$SalePaymentModelImplCopyWithImpl<$Res>
    extends _$SalePaymentModelCopyWithImpl<$Res, _$SalePaymentModelImpl>
    implements _$$SalePaymentModelImplCopyWith<$Res> {
  __$$SalePaymentModelImplCopyWithImpl(
    _$SalePaymentModelImpl _value,
    $Res Function(_$SalePaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? referenceNo = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(
      _$SalePaymentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceNo: freezed == referenceNo
            ? _value.referenceNo
            : referenceNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalePaymentModelImpl implements _SalePaymentModel {
  const _$SalePaymentModelImpl({
    required this.id,
    @JsonKey(name: 'payment_method') required this.paymentMethod,
    required this.amount,
    @JsonKey(name: 'reference_no') this.referenceNo,
    @JsonKey(name: 'paid_at') this.paidAt,
  });

  factory _$SalePaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalePaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  final String amount;
  @override
  @JsonKey(name: 'reference_no')
  final String? referenceNo;
  @override
  @JsonKey(name: 'paid_at')
  final String? paidAt;

  @override
  String toString() {
    return 'SalePaymentModel(id: $id, paymentMethod: $paymentMethod, amount: $amount, referenceNo: $referenceNo, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalePaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, paymentMethod, amount, referenceNo, paidAt);

  /// Create a copy of SalePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalePaymentModelImplCopyWith<_$SalePaymentModelImpl> get copyWith =>
      __$$SalePaymentModelImplCopyWithImpl<_$SalePaymentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalePaymentModelImplToJson(this);
  }
}

abstract class _SalePaymentModel implements SalePaymentModel {
  const factory _SalePaymentModel({
    required final String id,
    @JsonKey(name: 'payment_method') required final String paymentMethod,
    required final String amount,
    @JsonKey(name: 'reference_no') final String? referenceNo,
    @JsonKey(name: 'paid_at') final String? paidAt,
  }) = _$SalePaymentModelImpl;

  factory _SalePaymentModel.fromJson(Map<String, dynamic> json) =
      _$SalePaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  String get amount;
  @override
  @JsonKey(name: 'reference_no')
  String? get referenceNo;
  @override
  @JsonKey(name: 'paid_at')
  String? get paidAt;

  /// Create a copy of SalePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalePaymentModelImplCopyWith<_$SalePaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleResponseModel _$SaleResponseModelFromJson(Map<String, dynamic> json) {
  return _SaleResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SaleResponseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_number')
  String? get saleNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_type')
  String get saleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_status', readValue: _readSaleStatus)
  String get saleStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'register_shift_id')
  String? get registerShiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal')
  String? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_discount')
  String? get totalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_tax')
  String? get totalTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  String get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_paid')
  String? get totalPaid => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'sold_at')
  String? get soldAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  CustomerModel? get customer => throw _privateConstructorUsedError;
  List<SaleLineModel> get lines => throw _privateConstructorUsedError;
  List<SalePaymentModel> get payments => throw _privateConstructorUsedError;
  @JsonKey(name: 'offline')
  bool get offline => throw _privateConstructorUsedError;

  /// Serializes this SaleResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleResponseModelCopyWith<SaleResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleResponseModelCopyWith<$Res> {
  factory $SaleResponseModelCopyWith(
    SaleResponseModel value,
    $Res Function(SaleResponseModel) then,
  ) = _$SaleResponseModelCopyWithImpl<$Res, SaleResponseModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sale_number') String? saleNumber,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'sale_type') String saleType,
    @JsonKey(name: 'sale_status', readValue: _readSaleStatus) String saleStatus,
    @JsonKey(name: 'register_shift_id') String? registerShiftId,
    @JsonKey(name: 'subtotal') String? subtotal,
    @JsonKey(name: 'total_discount') String? totalDiscount,
    @JsonKey(name: 'total_tax') String? totalTax,
    @JsonKey(name: 'total_amount') String totalAmount,
    @JsonKey(name: 'total_paid') String? totalPaid,
    String? notes,
    @JsonKey(name: 'sold_at') String? soldAt,
    @JsonKey(name: 'created_at') String? createdAt,
    CustomerModel? customer,
    List<SaleLineModel> lines,
    List<SalePaymentModel> payments,
    @JsonKey(name: 'offline') bool offline,
  });

  $CustomerModelCopyWith<$Res>? get customer;
}

/// @nodoc
class _$SaleResponseModelCopyWithImpl<$Res, $Val extends SaleResponseModel>
    implements $SaleResponseModelCopyWith<$Res> {
  _$SaleResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saleNumber = freezed,
    Object? branchId = null,
    Object? customerId = freezed,
    Object? saleType = null,
    Object? saleStatus = null,
    Object? registerShiftId = freezed,
    Object? subtotal = freezed,
    Object? totalDiscount = freezed,
    Object? totalTax = freezed,
    Object? totalAmount = null,
    Object? totalPaid = freezed,
    Object? notes = freezed,
    Object? soldAt = freezed,
    Object? createdAt = freezed,
    Object? customer = freezed,
    Object? lines = null,
    Object? payments = null,
    Object? offline = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            saleNumber: freezed == saleNumber
                ? _value.saleNumber
                : saleNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            saleType: null == saleType
                ? _value.saleType
                : saleType // ignore: cast_nullable_to_non_nullable
                      as String,
            saleStatus: null == saleStatus
                ? _value.saleStatus
                : saleStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            registerShiftId: freezed == registerShiftId
                ? _value.registerShiftId
                : registerShiftId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtotal: freezed == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalDiscount: freezed == totalDiscount
                ? _value.totalDiscount
                : totalDiscount // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalTax: freezed == totalTax
                ? _value.totalTax
                : totalTax // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPaid: freezed == totalPaid
                ? _value.totalPaid
                : totalPaid // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            soldAt: freezed == soldAt
                ? _value.soldAt
                : soldAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            customer: freezed == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as CustomerModel?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<SaleLineModel>,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<SalePaymentModel>,
            offline: null == offline
                ? _value.offline
                : offline // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SaleResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SaleResponseModelImplCopyWith<$Res>
    implements $SaleResponseModelCopyWith<$Res> {
  factory _$$SaleResponseModelImplCopyWith(
    _$SaleResponseModelImpl value,
    $Res Function(_$SaleResponseModelImpl) then,
  ) = __$$SaleResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sale_number') String? saleNumber,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'sale_type') String saleType,
    @JsonKey(name: 'sale_status', readValue: _readSaleStatus) String saleStatus,
    @JsonKey(name: 'register_shift_id') String? registerShiftId,
    @JsonKey(name: 'subtotal') String? subtotal,
    @JsonKey(name: 'total_discount') String? totalDiscount,
    @JsonKey(name: 'total_tax') String? totalTax,
    @JsonKey(name: 'total_amount') String totalAmount,
    @JsonKey(name: 'total_paid') String? totalPaid,
    String? notes,
    @JsonKey(name: 'sold_at') String? soldAt,
    @JsonKey(name: 'created_at') String? createdAt,
    CustomerModel? customer,
    List<SaleLineModel> lines,
    List<SalePaymentModel> payments,
    @JsonKey(name: 'offline') bool offline,
  });

  @override
  $CustomerModelCopyWith<$Res>? get customer;
}

/// @nodoc
class __$$SaleResponseModelImplCopyWithImpl<$Res>
    extends _$SaleResponseModelCopyWithImpl<$Res, _$SaleResponseModelImpl>
    implements _$$SaleResponseModelImplCopyWith<$Res> {
  __$$SaleResponseModelImplCopyWithImpl(
    _$SaleResponseModelImpl _value,
    $Res Function(_$SaleResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saleNumber = freezed,
    Object? branchId = null,
    Object? customerId = freezed,
    Object? saleType = null,
    Object? saleStatus = null,
    Object? registerShiftId = freezed,
    Object? subtotal = freezed,
    Object? totalDiscount = freezed,
    Object? totalTax = freezed,
    Object? totalAmount = null,
    Object? totalPaid = freezed,
    Object? notes = freezed,
    Object? soldAt = freezed,
    Object? createdAt = freezed,
    Object? customer = freezed,
    Object? lines = null,
    Object? payments = null,
    Object? offline = null,
  }) {
    return _then(
      _$SaleResponseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        saleNumber: freezed == saleNumber
            ? _value.saleNumber
            : saleNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        saleType: null == saleType
            ? _value.saleType
            : saleType // ignore: cast_nullable_to_non_nullable
                  as String,
        saleStatus: null == saleStatus
            ? _value.saleStatus
            : saleStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        registerShiftId: freezed == registerShiftId
            ? _value.registerShiftId
            : registerShiftId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtotal: freezed == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalDiscount: freezed == totalDiscount
            ? _value.totalDiscount
            : totalDiscount // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalTax: freezed == totalTax
            ? _value.totalTax
            : totalTax // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPaid: freezed == totalPaid
            ? _value.totalPaid
            : totalPaid // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        soldAt: freezed == soldAt
            ? _value.soldAt
            : soldAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        customer: freezed == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<SaleLineModel>,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<SalePaymentModel>,
        offline: null == offline
            ? _value.offline
            : offline // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleResponseModelImpl implements _SaleResponseModel {
  const _$SaleResponseModelImpl({
    required this.id,
    @JsonKey(name: 'sale_number') this.saleNumber,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'customer_id') this.customerId,
    @JsonKey(name: 'sale_type') required this.saleType,
    @JsonKey(name: 'sale_status', readValue: _readSaleStatus)
    required this.saleStatus,
    @JsonKey(name: 'register_shift_id') this.registerShiftId,
    @JsonKey(name: 'subtotal') this.subtotal,
    @JsonKey(name: 'total_discount') this.totalDiscount,
    @JsonKey(name: 'total_tax') this.totalTax,
    @JsonKey(name: 'total_amount') this.totalAmount = '0',
    @JsonKey(name: 'total_paid') this.totalPaid,
    this.notes,
    @JsonKey(name: 'sold_at') this.soldAt,
    @JsonKey(name: 'created_at') this.createdAt,
    this.customer,
    final List<SaleLineModel> lines = const [],
    final List<SalePaymentModel> payments = const [],
    @JsonKey(name: 'offline') this.offline = false,
  }) : _lines = lines,
       _payments = payments;

  factory _$SaleResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleResponseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'sale_number')
  final String? saleNumber;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'customer_id')
  final String? customerId;
  @override
  @JsonKey(name: 'sale_type')
  final String saleType;
  @override
  @JsonKey(name: 'sale_status', readValue: _readSaleStatus)
  final String saleStatus;
  @override
  @JsonKey(name: 'register_shift_id')
  final String? registerShiftId;
  @override
  @JsonKey(name: 'subtotal')
  final String? subtotal;
  @override
  @JsonKey(name: 'total_discount')
  final String? totalDiscount;
  @override
  @JsonKey(name: 'total_tax')
  final String? totalTax;
  @override
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  @override
  @JsonKey(name: 'total_paid')
  final String? totalPaid;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'sold_at')
  final String? soldAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  final CustomerModel? customer;
  final List<SaleLineModel> _lines;
  @override
  @JsonKey()
  List<SaleLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  final List<SalePaymentModel> _payments;
  @override
  @JsonKey()
  List<SalePaymentModel> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey(name: 'offline')
  final bool offline;

  @override
  String toString() {
    return 'SaleResponseModel(id: $id, saleNumber: $saleNumber, branchId: $branchId, customerId: $customerId, saleType: $saleType, saleStatus: $saleStatus, registerShiftId: $registerShiftId, subtotal: $subtotal, totalDiscount: $totalDiscount, totalTax: $totalTax, totalAmount: $totalAmount, totalPaid: $totalPaid, notes: $notes, soldAt: $soldAt, createdAt: $createdAt, customer: $customer, lines: $lines, payments: $payments, offline: $offline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saleNumber, saleNumber) ||
                other.saleNumber == saleNumber) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.saleType, saleType) ||
                other.saleType == saleType) &&
            (identical(other.saleStatus, saleStatus) ||
                other.saleStatus == saleStatus) &&
            (identical(other.registerShiftId, registerShiftId) ||
                other.registerShiftId == registerShiftId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.totalDiscount, totalDiscount) ||
                other.totalDiscount == totalDiscount) &&
            (identical(other.totalTax, totalTax) ||
                other.totalTax == totalTax) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.soldAt, soldAt) || other.soldAt == soldAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.offline, offline) || other.offline == offline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    saleNumber,
    branchId,
    customerId,
    saleType,
    saleStatus,
    registerShiftId,
    subtotal,
    totalDiscount,
    totalTax,
    totalAmount,
    totalPaid,
    notes,
    soldAt,
    createdAt,
    customer,
    const DeepCollectionEquality().hash(_lines),
    const DeepCollectionEquality().hash(_payments),
    offline,
  ]);

  /// Create a copy of SaleResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleResponseModelImplCopyWith<_$SaleResponseModelImpl> get copyWith =>
      __$$SaleResponseModelImplCopyWithImpl<_$SaleResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleResponseModelImplToJson(this);
  }
}

abstract class _SaleResponseModel implements SaleResponseModel {
  const factory _SaleResponseModel({
    required final String id,
    @JsonKey(name: 'sale_number') final String? saleNumber,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'customer_id') final String? customerId,
    @JsonKey(name: 'sale_type') required final String saleType,
    @JsonKey(name: 'sale_status', readValue: _readSaleStatus)
    required final String saleStatus,
    @JsonKey(name: 'register_shift_id') final String? registerShiftId,
    @JsonKey(name: 'subtotal') final String? subtotal,
    @JsonKey(name: 'total_discount') final String? totalDiscount,
    @JsonKey(name: 'total_tax') final String? totalTax,
    @JsonKey(name: 'total_amount') final String totalAmount,
    @JsonKey(name: 'total_paid') final String? totalPaid,
    final String? notes,
    @JsonKey(name: 'sold_at') final String? soldAt,
    @JsonKey(name: 'created_at') final String? createdAt,
    final CustomerModel? customer,
    final List<SaleLineModel> lines,
    final List<SalePaymentModel> payments,
    @JsonKey(name: 'offline') final bool offline,
  }) = _$SaleResponseModelImpl;

  factory _SaleResponseModel.fromJson(Map<String, dynamic> json) =
      _$SaleResponseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'sale_number')
  String? get saleNumber;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'customer_id')
  String? get customerId;
  @override
  @JsonKey(name: 'sale_type')
  String get saleType;
  @override
  @JsonKey(name: 'sale_status', readValue: _readSaleStatus)
  String get saleStatus;
  @override
  @JsonKey(name: 'register_shift_id')
  String? get registerShiftId;
  @override
  @JsonKey(name: 'subtotal')
  String? get subtotal;
  @override
  @JsonKey(name: 'total_discount')
  String? get totalDiscount;
  @override
  @JsonKey(name: 'total_tax')
  String? get totalTax;
  @override
  @JsonKey(name: 'total_amount')
  String get totalAmount;
  @override
  @JsonKey(name: 'total_paid')
  String? get totalPaid;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'sold_at')
  String? get soldAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  CustomerModel? get customer;
  @override
  List<SaleLineModel> get lines;
  @override
  List<SalePaymentModel> get payments;
  @override
  @JsonKey(name: 'offline')
  bool get offline;

  /// Create a copy of SaleResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleResponseModelImplCopyWith<_$SaleResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
