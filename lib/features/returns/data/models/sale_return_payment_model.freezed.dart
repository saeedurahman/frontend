// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SaleReturnPaymentModel _$SaleReturnPaymentModelFromJson(
  Map<String, dynamic> json,
) {
  return _SaleReturnPaymentModel.fromJson(json);
}

/// @nodoc
mixin _$SaleReturnPaymentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_return_id')
  String get saleReturnId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'refunded_at')
  String? get refundedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SaleReturnPaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleReturnPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleReturnPaymentModelCopyWith<SaleReturnPaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleReturnPaymentModelCopyWith<$Res> {
  factory $SaleReturnPaymentModelCopyWith(
    SaleReturnPaymentModel value,
    $Res Function(SaleReturnPaymentModel) then,
  ) = _$SaleReturnPaymentModelCopyWithImpl<$Res, SaleReturnPaymentModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'sale_return_id') String saleReturnId,
    @JsonKey(name: 'payment_method') String paymentMethod,
    String amount,
    String status,
    @JsonKey(name: 'refunded_at') String? refundedAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$SaleReturnPaymentModelCopyWithImpl<
  $Res,
  $Val extends SaleReturnPaymentModel
>
    implements $SaleReturnPaymentModelCopyWith<$Res> {
  _$SaleReturnPaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleReturnPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? saleReturnId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? status = null,
    Object? refundedAt = freezed,
    Object? createdAt = freezed,
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
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            refundedAt: freezed == refundedAt
                ? _value.refundedAt
                : refundedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$SaleReturnPaymentModelImplCopyWith<$Res>
    implements $SaleReturnPaymentModelCopyWith<$Res> {
  factory _$$SaleReturnPaymentModelImplCopyWith(
    _$SaleReturnPaymentModelImpl value,
    $Res Function(_$SaleReturnPaymentModelImpl) then,
  ) = __$$SaleReturnPaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'sale_return_id') String saleReturnId,
    @JsonKey(name: 'payment_method') String paymentMethod,
    String amount,
    String status,
    @JsonKey(name: 'refunded_at') String? refundedAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$SaleReturnPaymentModelImplCopyWithImpl<$Res>
    extends
        _$SaleReturnPaymentModelCopyWithImpl<$Res, _$SaleReturnPaymentModelImpl>
    implements _$$SaleReturnPaymentModelImplCopyWith<$Res> {
  __$$SaleReturnPaymentModelImplCopyWithImpl(
    _$SaleReturnPaymentModelImpl _value,
    $Res Function(_$SaleReturnPaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleReturnPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? saleReturnId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? status = null,
    Object? refundedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SaleReturnPaymentModelImpl(
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
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        refundedAt: freezed == refundedAt
            ? _value.refundedAt
            : refundedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$SaleReturnPaymentModelImpl implements _SaleReturnPaymentModel {
  const _$SaleReturnPaymentModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'sale_return_id') required this.saleReturnId,
    @JsonKey(name: 'payment_method') required this.paymentMethod,
    required this.amount,
    required this.status,
    @JsonKey(name: 'refunded_at') this.refundedAt,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$SaleReturnPaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleReturnPaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'sale_return_id')
  final String saleReturnId;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  final String amount;
  @override
  final String status;
  @override
  @JsonKey(name: 'refunded_at')
  final String? refundedAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'SaleReturnPaymentModel(id: $id, businessId: $businessId, saleReturnId: $saleReturnId, paymentMethod: $paymentMethod, amount: $amount, status: $status, refundedAt: $refundedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleReturnPaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.saleReturnId, saleReturnId) ||
                other.saleReturnId == saleReturnId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    saleReturnId,
    paymentMethod,
    amount,
    status,
    refundedAt,
    createdAt,
  );

  /// Create a copy of SaleReturnPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleReturnPaymentModelImplCopyWith<_$SaleReturnPaymentModelImpl>
  get copyWith =>
      __$$SaleReturnPaymentModelImplCopyWithImpl<_$SaleReturnPaymentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleReturnPaymentModelImplToJson(this);
  }
}

abstract class _SaleReturnPaymentModel implements SaleReturnPaymentModel {
  const factory _SaleReturnPaymentModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'sale_return_id') required final String saleReturnId,
    @JsonKey(name: 'payment_method') required final String paymentMethod,
    required final String amount,
    required final String status,
    @JsonKey(name: 'refunded_at') final String? refundedAt,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$SaleReturnPaymentModelImpl;

  factory _SaleReturnPaymentModel.fromJson(Map<String, dynamic> json) =
      _$SaleReturnPaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'sale_return_id')
  String get saleReturnId;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  String get amount;
  @override
  String get status;
  @override
  @JsonKey(name: 'refunded_at')
  String? get refundedAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of SaleReturnPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleReturnPaymentModelImplCopyWith<_$SaleReturnPaymentModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
