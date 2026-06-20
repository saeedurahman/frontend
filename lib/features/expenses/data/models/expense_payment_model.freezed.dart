// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpensePaymentModel _$ExpensePaymentModelFromJson(Map<String, dynamic> json) {
  return _ExpensePaymentModel.fromJson(json);
}

/// @nodoc
mixin _$ExpensePaymentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_id')
  String get expenseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_no')
  String? get referenceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  String? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExpensePaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpensePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpensePaymentModelCopyWith<ExpensePaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpensePaymentModelCopyWith<$Res> {
  factory $ExpensePaymentModelCopyWith(
    ExpensePaymentModel value,
    $Res Function(ExpensePaymentModel) then,
  ) = _$ExpensePaymentModelCopyWithImpl<$Res, ExpensePaymentModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'expense_id') String expenseId,
    @JsonKey(name: 'payment_method') String paymentMethod,
    String amount,
    String status,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$ExpensePaymentModelCopyWithImpl<$Res, $Val extends ExpensePaymentModel>
    implements $ExpensePaymentModelCopyWith<$Res> {
  _$ExpensePaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpensePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? status = null,
    Object? referenceNo = freezed,
    Object? paidAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            expenseId: null == expenseId
                ? _value.expenseId
                : expenseId // ignore: cast_nullable_to_non_nullable
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
            referenceNo: freezed == referenceNo
                ? _value.referenceNo
                : referenceNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ExpensePaymentModelImplCopyWith<$Res>
    implements $ExpensePaymentModelCopyWith<$Res> {
  factory _$$ExpensePaymentModelImplCopyWith(
    _$ExpensePaymentModelImpl value,
    $Res Function(_$ExpensePaymentModelImpl) then,
  ) = __$$ExpensePaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'expense_id') String expenseId,
    @JsonKey(name: 'payment_method') String paymentMethod,
    String amount,
    String status,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$ExpensePaymentModelImplCopyWithImpl<$Res>
    extends _$ExpensePaymentModelCopyWithImpl<$Res, _$ExpensePaymentModelImpl>
    implements _$$ExpensePaymentModelImplCopyWith<$Res> {
  __$$ExpensePaymentModelImplCopyWithImpl(
    _$ExpensePaymentModelImpl _value,
    $Res Function(_$ExpensePaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpensePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? status = null,
    Object? referenceNo = freezed,
    Object? paidAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExpensePaymentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseId: null == expenseId
            ? _value.expenseId
            : expenseId // ignore: cast_nullable_to_non_nullable
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
        referenceNo: freezed == referenceNo
            ? _value.referenceNo
            : referenceNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
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
class _$ExpensePaymentModelImpl implements _ExpensePaymentModel {
  const _$ExpensePaymentModelImpl({
    required this.id,
    @JsonKey(name: 'expense_id') required this.expenseId,
    @JsonKey(name: 'payment_method') required this.paymentMethod,
    required this.amount,
    this.status = 'completed',
    @JsonKey(name: 'reference_no') this.referenceNo,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$ExpensePaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpensePaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'expense_id')
  final String expenseId;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  final String amount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'reference_no')
  final String? referenceNo;
  @override
  @JsonKey(name: 'paid_at')
  final String? paidAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'ExpensePaymentModel(id: $id, expenseId: $expenseId, paymentMethod: $paymentMethod, amount: $amount, status: $status, referenceNo: $referenceNo, paidAt: $paidAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpensePaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    expenseId,
    paymentMethod,
    amount,
    status,
    referenceNo,
    paidAt,
    createdAt,
  );

  /// Create a copy of ExpensePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpensePaymentModelImplCopyWith<_$ExpensePaymentModelImpl> get copyWith =>
      __$$ExpensePaymentModelImplCopyWithImpl<_$ExpensePaymentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpensePaymentModelImplToJson(this);
  }
}

abstract class _ExpensePaymentModel implements ExpensePaymentModel {
  const factory _ExpensePaymentModel({
    required final String id,
    @JsonKey(name: 'expense_id') required final String expenseId,
    @JsonKey(name: 'payment_method') required final String paymentMethod,
    required final String amount,
    final String status,
    @JsonKey(name: 'reference_no') final String? referenceNo,
    @JsonKey(name: 'paid_at') final String? paidAt,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$ExpensePaymentModelImpl;

  factory _ExpensePaymentModel.fromJson(Map<String, dynamic> json) =
      _$ExpensePaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'expense_id')
  String get expenseId;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  String get amount;
  @override
  String get status;
  @override
  @JsonKey(name: 'reference_no')
  String? get referenceNo;
  @override
  @JsonKey(name: 'paid_at')
  String? get paidAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of ExpensePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpensePaymentModelImplCopyWith<_$ExpensePaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
