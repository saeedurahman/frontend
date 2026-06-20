// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SaleReturnLineModel _$SaleReturnLineModelFromJson(Map<String, dynamic> json) {
  return _SaleReturnLineModel.fromJson(json);
}

/// @nodoc
mixin _$SaleReturnLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_return_id')
  String get saleReturnId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_line_id')
  String? get saleLineId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  String get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  String get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  String get taxAmount => throw _privateConstructorUsedError;

  /// Serializes this SaleReturnLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleReturnLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleReturnLineModelCopyWith<SaleReturnLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleReturnLineModelCopyWith<$Res> {
  factory $SaleReturnLineModelCopyWith(
    SaleReturnLineModel value,
    $Res Function(SaleReturnLineModel) then,
  ) = _$SaleReturnLineModelCopyWithImpl<$Res, SaleReturnLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'sale_return_id') String saleReturnId,
    @JsonKey(name: 'sale_line_id') String? saleLineId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'tax_amount') String taxAmount,
  });
}

/// @nodoc
class _$SaleReturnLineModelCopyWithImpl<$Res, $Val extends SaleReturnLineModel>
    implements $SaleReturnLineModelCopyWith<$Res> {
  _$SaleReturnLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleReturnLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? saleReturnId = null,
    Object? saleLineId = freezed,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? unitPrice = null,
    Object? taxAmount = null,
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
            saleReturnId: null == saleReturnId
                ? _value.saleReturnId
                : saleReturnId // ignore: cast_nullable_to_non_nullable
                      as String,
            saleLineId: freezed == saleLineId
                ? _value.saleLineId
                : saleLineId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleReturnLineModelImplCopyWith<$Res>
    implements $SaleReturnLineModelCopyWith<$Res> {
  factory _$$SaleReturnLineModelImplCopyWith(
    _$SaleReturnLineModelImpl value,
    $Res Function(_$SaleReturnLineModelImpl) then,
  ) = __$$SaleReturnLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'sale_return_id') String saleReturnId,
    @JsonKey(name: 'sale_line_id') String? saleLineId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'tax_amount') String taxAmount,
  });
}

/// @nodoc
class __$$SaleReturnLineModelImplCopyWithImpl<$Res>
    extends _$SaleReturnLineModelCopyWithImpl<$Res, _$SaleReturnLineModelImpl>
    implements _$$SaleReturnLineModelImplCopyWith<$Res> {
  __$$SaleReturnLineModelImplCopyWithImpl(
    _$SaleReturnLineModelImpl _value,
    $Res Function(_$SaleReturnLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleReturnLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? saleReturnId = null,
    Object? saleLineId = freezed,
    Object? productId = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? unitPrice = null,
    Object? taxAmount = null,
  }) {
    return _then(
      _$SaleReturnLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        saleReturnId: null == saleReturnId
            ? _value.saleReturnId
            : saleReturnId // ignore: cast_nullable_to_non_nullable
                  as String,
        saleLineId: freezed == saleLineId
            ? _value.saleLineId
            : saleLineId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleReturnLineModelImpl implements _SaleReturnLineModel {
  const _$SaleReturnLineModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'sale_return_id') required this.saleReturnId,
    @JsonKey(name: 'sale_line_id') this.saleLineId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    required this.qty,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    @JsonKey(name: 'tax_amount') this.taxAmount = '0',
  });

  factory _$SaleReturnLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleReturnLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'sale_return_id')
  final String saleReturnId;
  @override
  @JsonKey(name: 'sale_line_id')
  final String? saleLineId;
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
  @JsonKey(name: 'tax_amount')
  final String taxAmount;

  @override
  String toString() {
    return 'SaleReturnLineModel(id: $id, businessId: $businessId, saleReturnId: $saleReturnId, saleLineId: $saleLineId, productId: $productId, variationId: $variationId, qty: $qty, unitPrice: $unitPrice, taxAmount: $taxAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleReturnLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.saleReturnId, saleReturnId) ||
                other.saleReturnId == saleReturnId) &&
            (identical(other.saleLineId, saleLineId) ||
                other.saleLineId == saleLineId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    saleReturnId,
    saleLineId,
    productId,
    variationId,
    qty,
    unitPrice,
    taxAmount,
  );

  /// Create a copy of SaleReturnLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleReturnLineModelImplCopyWith<_$SaleReturnLineModelImpl> get copyWith =>
      __$$SaleReturnLineModelImplCopyWithImpl<_$SaleReturnLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleReturnLineModelImplToJson(this);
  }
}

abstract class _SaleReturnLineModel implements SaleReturnLineModel {
  const factory _SaleReturnLineModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'sale_return_id') required final String saleReturnId,
    @JsonKey(name: 'sale_line_id') final String? saleLineId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    required final String qty,
    @JsonKey(name: 'unit_price') required final String unitPrice,
    @JsonKey(name: 'tax_amount') final String taxAmount,
  }) = _$SaleReturnLineModelImpl;

  factory _SaleReturnLineModel.fromJson(Map<String, dynamic> json) =
      _$SaleReturnLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'sale_return_id')
  String get saleReturnId;
  @override
  @JsonKey(name: 'sale_line_id')
  String? get saleLineId;
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
  @JsonKey(name: 'tax_amount')
  String get taxAmount;

  /// Create a copy of SaleReturnLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleReturnLineModelImplCopyWith<_$SaleReturnLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
