// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_payment_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpensePaymentResponseModel _$ExpensePaymentResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _ExpensePaymentResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpensePaymentResponseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_id')
  String get expenseId => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_no')
  String? get referenceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  String? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_paid')
  String get totalPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_balance')
  String get remainingBalance => throw _privateConstructorUsedError;

  /// Serializes this ExpensePaymentResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpensePaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpensePaymentResponseModelCopyWith<ExpensePaymentResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpensePaymentResponseModelCopyWith<$Res> {
  factory $ExpensePaymentResponseModelCopyWith(
    ExpensePaymentResponseModel value,
    $Res Function(ExpensePaymentResponseModel) then,
  ) =
      _$ExpensePaymentResponseModelCopyWithImpl<
        $Res,
        ExpensePaymentResponseModel
      >;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'expense_id') String expenseId,
    String amount,
    @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'total_paid') String totalPaid,
    @JsonKey(name: 'remaining_balance') String remainingBalance,
  });
}

/// @nodoc
class _$ExpensePaymentResponseModelCopyWithImpl<
  $Res,
  $Val extends ExpensePaymentResponseModel
>
    implements $ExpensePaymentResponseModelCopyWith<$Res> {
  _$ExpensePaymentResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpensePaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? referenceNo = freezed,
    Object? paidAt = freezed,
    Object? totalPaid = null,
    Object? remainingBalance = null,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceNo: freezed == referenceNo
                ? _value.referenceNo
                : referenceNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalPaid: null == totalPaid
                ? _value.totalPaid
                : totalPaid // ignore: cast_nullable_to_non_nullable
                      as String,
            remainingBalance: null == remainingBalance
                ? _value.remainingBalance
                : remainingBalance // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpensePaymentResponseModelImplCopyWith<$Res>
    implements $ExpensePaymentResponseModelCopyWith<$Res> {
  factory _$$ExpensePaymentResponseModelImplCopyWith(
    _$ExpensePaymentResponseModelImpl value,
    $Res Function(_$ExpensePaymentResponseModelImpl) then,
  ) = __$$ExpensePaymentResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'expense_id') String expenseId,
    String amount,
    @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'total_paid') String totalPaid,
    @JsonKey(name: 'remaining_balance') String remainingBalance,
  });
}

/// @nodoc
class __$$ExpensePaymentResponseModelImplCopyWithImpl<$Res>
    extends
        _$ExpensePaymentResponseModelCopyWithImpl<
          $Res,
          _$ExpensePaymentResponseModelImpl
        >
    implements _$$ExpensePaymentResponseModelImplCopyWith<$Res> {
  __$$ExpensePaymentResponseModelImplCopyWithImpl(
    _$ExpensePaymentResponseModelImpl _value,
    $Res Function(_$ExpensePaymentResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpensePaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? referenceNo = freezed,
    Object? paidAt = freezed,
    Object? totalPaid = null,
    Object? remainingBalance = null,
  }) {
    return _then(
      _$ExpensePaymentResponseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseId: null == expenseId
            ? _value.expenseId
            : expenseId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceNo: freezed == referenceNo
            ? _value.referenceNo
            : referenceNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalPaid: null == totalPaid
            ? _value.totalPaid
            : totalPaid // ignore: cast_nullable_to_non_nullable
                  as String,
        remainingBalance: null == remainingBalance
            ? _value.remainingBalance
            : remainingBalance // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpensePaymentResponseModelImpl
    implements _ExpensePaymentResponseModel {
  const _$ExpensePaymentResponseModelImpl({
    required this.id,
    @JsonKey(name: 'expense_id') required this.expenseId,
    required this.amount,
    @JsonKey(name: 'payment_method') required this.paymentMethod,
    @JsonKey(name: 'reference_no') this.referenceNo,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'total_paid') required this.totalPaid,
    @JsonKey(name: 'remaining_balance') required this.remainingBalance,
  });

  factory _$ExpensePaymentResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ExpensePaymentResponseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'expense_id')
  final String expenseId;
  @override
  final String amount;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @JsonKey(name: 'reference_no')
  final String? referenceNo;
  @override
  @JsonKey(name: 'paid_at')
  final String? paidAt;
  @override
  @JsonKey(name: 'total_paid')
  final String totalPaid;
  @override
  @JsonKey(name: 'remaining_balance')
  final String remainingBalance;

  @override
  String toString() {
    return 'ExpensePaymentResponseModel(id: $id, expenseId: $expenseId, amount: $amount, paymentMethod: $paymentMethod, referenceNo: $referenceNo, paidAt: $paidAt, totalPaid: $totalPaid, remainingBalance: $remainingBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpensePaymentResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.remainingBalance, remainingBalance) ||
                other.remainingBalance == remainingBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    expenseId,
    amount,
    paymentMethod,
    referenceNo,
    paidAt,
    totalPaid,
    remainingBalance,
  );

  /// Create a copy of ExpensePaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpensePaymentResponseModelImplCopyWith<_$ExpensePaymentResponseModelImpl>
  get copyWith =>
      __$$ExpensePaymentResponseModelImplCopyWithImpl<
        _$ExpensePaymentResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpensePaymentResponseModelImplToJson(this);
  }
}

abstract class _ExpensePaymentResponseModel
    implements ExpensePaymentResponseModel {
  const factory _ExpensePaymentResponseModel({
    required final String id,
    @JsonKey(name: 'expense_id') required final String expenseId,
    required final String amount,
    @JsonKey(name: 'payment_method') required final String paymentMethod,
    @JsonKey(name: 'reference_no') final String? referenceNo,
    @JsonKey(name: 'paid_at') final String? paidAt,
    @JsonKey(name: 'total_paid') required final String totalPaid,
    @JsonKey(name: 'remaining_balance') required final String remainingBalance,
  }) = _$ExpensePaymentResponseModelImpl;

  factory _ExpensePaymentResponseModel.fromJson(Map<String, dynamic> json) =
      _$ExpensePaymentResponseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'expense_id')
  String get expenseId;
  @override
  String get amount;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  @JsonKey(name: 'reference_no')
  String? get referenceNo;
  @override
  @JsonKey(name: 'paid_at')
  String? get paidAt;
  @override
  @JsonKey(name: 'total_paid')
  String get totalPaid;
  @override
  @JsonKey(name: 'remaining_balance')
  String get remainingBalance;

  /// Create a copy of ExpensePaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpensePaymentResponseModelImplCopyWith<_$ExpensePaymentResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
