// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SaleReturnResponseModel _$SaleReturnResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _SaleReturnResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SaleReturnResponseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_id')
  String? get saleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_number')
  String get returnNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'returned_at')
  String? get returnedAt => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  List<SaleReturnLineModel> get lines => throw _privateConstructorUsedError;
  List<SaleReturnPaymentModel> get payments =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SaleReturnResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleReturnResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleReturnResponseModelCopyWith<SaleReturnResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleReturnResponseModelCopyWith<$Res> {
  factory $SaleReturnResponseModelCopyWith(
    SaleReturnResponseModel value,
    $Res Function(SaleReturnResponseModel) then,
  ) = _$SaleReturnResponseModelCopyWithImpl<$Res, SaleReturnResponseModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'return_number') String returnNumber,
    @JsonKey(name: 'returned_at') String? returnedAt,
    String? reason,
    List<SaleReturnLineModel> lines,
    List<SaleReturnPaymentModel> payments,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$SaleReturnResponseModelCopyWithImpl<
  $Res,
  $Val extends SaleReturnResponseModel
>
    implements $SaleReturnResponseModelCopyWith<$Res> {
  _$SaleReturnResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleReturnResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? saleId = freezed,
    Object? customerId = freezed,
    Object? returnNumber = null,
    Object? returnedAt = freezed,
    Object? reason = freezed,
    Object? lines = null,
    Object? payments = null,
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
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            saleId: freezed == saleId
                ? _value.saleId
                : saleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            returnNumber: null == returnNumber
                ? _value.returnNumber
                : returnNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            returnedAt: freezed == returnedAt
                ? _value.returnedAt
                : returnedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<SaleReturnLineModel>,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<SaleReturnPaymentModel>,
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
abstract class _$$SaleReturnResponseModelImplCopyWith<$Res>
    implements $SaleReturnResponseModelCopyWith<$Res> {
  factory _$$SaleReturnResponseModelImplCopyWith(
    _$SaleReturnResponseModelImpl value,
    $Res Function(_$SaleReturnResponseModelImpl) then,
  ) = __$$SaleReturnResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'return_number') String returnNumber,
    @JsonKey(name: 'returned_at') String? returnedAt,
    String? reason,
    List<SaleReturnLineModel> lines,
    List<SaleReturnPaymentModel> payments,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$SaleReturnResponseModelImplCopyWithImpl<$Res>
    extends
        _$SaleReturnResponseModelCopyWithImpl<
          $Res,
          _$SaleReturnResponseModelImpl
        >
    implements _$$SaleReturnResponseModelImplCopyWith<$Res> {
  __$$SaleReturnResponseModelImplCopyWithImpl(
    _$SaleReturnResponseModelImpl _value,
    $Res Function(_$SaleReturnResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleReturnResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? saleId = freezed,
    Object? customerId = freezed,
    Object? returnNumber = null,
    Object? returnedAt = freezed,
    Object? reason = freezed,
    Object? lines = null,
    Object? payments = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SaleReturnResponseModelImpl(
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
        saleId: freezed == saleId
            ? _value.saleId
            : saleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        returnNumber: null == returnNumber
            ? _value.returnNumber
            : returnNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        returnedAt: freezed == returnedAt
            ? _value.returnedAt
            : returnedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<SaleReturnLineModel>,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<SaleReturnPaymentModel>,
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
class _$SaleReturnResponseModelImpl implements _SaleReturnResponseModel {
  const _$SaleReturnResponseModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'sale_id') this.saleId,
    @JsonKey(name: 'customer_id') this.customerId,
    @JsonKey(name: 'return_number') required this.returnNumber,
    @JsonKey(name: 'returned_at') this.returnedAt,
    this.reason,
    final List<SaleReturnLineModel> lines = const [],
    final List<SaleReturnPaymentModel> payments = const [],
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _lines = lines,
       _payments = payments;

  factory _$SaleReturnResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleReturnResponseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'sale_id')
  final String? saleId;
  @override
  @JsonKey(name: 'customer_id')
  final String? customerId;
  @override
  @JsonKey(name: 'return_number')
  final String returnNumber;
  @override
  @JsonKey(name: 'returned_at')
  final String? returnedAt;
  @override
  final String? reason;
  final List<SaleReturnLineModel> _lines;
  @override
  @JsonKey()
  List<SaleReturnLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  final List<SaleReturnPaymentModel> _payments;
  @override
  @JsonKey()
  List<SaleReturnPaymentModel> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'SaleReturnResponseModel(id: $id, businessId: $businessId, branchId: $branchId, saleId: $saleId, customerId: $customerId, returnNumber: $returnNumber, returnedAt: $returnedAt, reason: $reason, lines: $lines, payments: $payments, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleReturnResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.returnNumber, returnNumber) ||
                other.returnNumber == returnNumber) &&
            (identical(other.returnedAt, returnedAt) ||
                other.returnedAt == returnedAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    saleId,
    customerId,
    returnNumber,
    returnedAt,
    reason,
    const DeepCollectionEquality().hash(_lines),
    const DeepCollectionEquality().hash(_payments),
    createdAt,
  );

  /// Create a copy of SaleReturnResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleReturnResponseModelImplCopyWith<_$SaleReturnResponseModelImpl>
  get copyWith =>
      __$$SaleReturnResponseModelImplCopyWithImpl<
        _$SaleReturnResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleReturnResponseModelImplToJson(this);
  }
}

abstract class _SaleReturnResponseModel implements SaleReturnResponseModel {
  const factory _SaleReturnResponseModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'sale_id') final String? saleId,
    @JsonKey(name: 'customer_id') final String? customerId,
    @JsonKey(name: 'return_number') required final String returnNumber,
    @JsonKey(name: 'returned_at') final String? returnedAt,
    final String? reason,
    final List<SaleReturnLineModel> lines,
    final List<SaleReturnPaymentModel> payments,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$SaleReturnResponseModelImpl;

  factory _SaleReturnResponseModel.fromJson(Map<String, dynamic> json) =
      _$SaleReturnResponseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'sale_id')
  String? get saleId;
  @override
  @JsonKey(name: 'customer_id')
  String? get customerId;
  @override
  @JsonKey(name: 'return_number')
  String get returnNumber;
  @override
  @JsonKey(name: 'returned_at')
  String? get returnedAt;
  @override
  String? get reason;
  @override
  List<SaleReturnLineModel> get lines;
  @override
  List<SaleReturnPaymentModel> get payments;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of SaleReturnResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleReturnResponseModelImplCopyWith<_$SaleReturnResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
