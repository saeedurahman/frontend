// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_payment_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerPaymentResponseModel _$CustomerPaymentResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerPaymentResponseModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerPaymentResponseModel {
  @JsonKey(name: 'ledger_entry_id')
  String get ledgerEntryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_balance')
  String get newBalance => throw _privateConstructorUsedError;

  /// Serializes this CustomerPaymentResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerPaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerPaymentResponseModelCopyWith<CustomerPaymentResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerPaymentResponseModelCopyWith<$Res> {
  factory $CustomerPaymentResponseModelCopyWith(
    CustomerPaymentResponseModel value,
    $Res Function(CustomerPaymentResponseModel) then,
  ) =
      _$CustomerPaymentResponseModelCopyWithImpl<
        $Res,
        CustomerPaymentResponseModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ledger_entry_id') String ledgerEntryId,
    @JsonKey(name: 'customer_id') String customerId,
    String amount,
    @JsonKey(name: 'new_balance') String newBalance,
  });
}

/// @nodoc
class _$CustomerPaymentResponseModelCopyWithImpl<
  $Res,
  $Val extends CustomerPaymentResponseModel
>
    implements $CustomerPaymentResponseModelCopyWith<$Res> {
  _$CustomerPaymentResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerPaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ledgerEntryId = null,
    Object? customerId = null,
    Object? amount = null,
    Object? newBalance = null,
  }) {
    return _then(
      _value.copyWith(
            ledgerEntryId: null == ledgerEntryId
                ? _value.ledgerEntryId
                : ledgerEntryId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            newBalance: null == newBalance
                ? _value.newBalance
                : newBalance // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerPaymentResponseModelImplCopyWith<$Res>
    implements $CustomerPaymentResponseModelCopyWith<$Res> {
  factory _$$CustomerPaymentResponseModelImplCopyWith(
    _$CustomerPaymentResponseModelImpl value,
    $Res Function(_$CustomerPaymentResponseModelImpl) then,
  ) = __$$CustomerPaymentResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ledger_entry_id') String ledgerEntryId,
    @JsonKey(name: 'customer_id') String customerId,
    String amount,
    @JsonKey(name: 'new_balance') String newBalance,
  });
}

/// @nodoc
class __$$CustomerPaymentResponseModelImplCopyWithImpl<$Res>
    extends
        _$CustomerPaymentResponseModelCopyWithImpl<
          $Res,
          _$CustomerPaymentResponseModelImpl
        >
    implements _$$CustomerPaymentResponseModelImplCopyWith<$Res> {
  __$$CustomerPaymentResponseModelImplCopyWithImpl(
    _$CustomerPaymentResponseModelImpl _value,
    $Res Function(_$CustomerPaymentResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerPaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ledgerEntryId = null,
    Object? customerId = null,
    Object? amount = null,
    Object? newBalance = null,
  }) {
    return _then(
      _$CustomerPaymentResponseModelImpl(
        ledgerEntryId: null == ledgerEntryId
            ? _value.ledgerEntryId
            : ledgerEntryId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        newBalance: null == newBalance
            ? _value.newBalance
            : newBalance // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerPaymentResponseModelImpl
    implements _CustomerPaymentResponseModel {
  const _$CustomerPaymentResponseModelImpl({
    @JsonKey(name: 'ledger_entry_id') required this.ledgerEntryId,
    @JsonKey(name: 'customer_id') required this.customerId,
    required this.amount,
    @JsonKey(name: 'new_balance') required this.newBalance,
  });

  factory _$CustomerPaymentResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerPaymentResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'ledger_entry_id')
  final String ledgerEntryId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  final String amount;
  @override
  @JsonKey(name: 'new_balance')
  final String newBalance;

  @override
  String toString() {
    return 'CustomerPaymentResponseModel(ledgerEntryId: $ledgerEntryId, customerId: $customerId, amount: $amount, newBalance: $newBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerPaymentResponseModelImpl &&
            (identical(other.ledgerEntryId, ledgerEntryId) ||
                other.ledgerEntryId == ledgerEntryId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.newBalance, newBalance) ||
                other.newBalance == newBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, ledgerEntryId, customerId, amount, newBalance);

  /// Create a copy of CustomerPaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerPaymentResponseModelImplCopyWith<
    _$CustomerPaymentResponseModelImpl
  >
  get copyWith =>
      __$$CustomerPaymentResponseModelImplCopyWithImpl<
        _$CustomerPaymentResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerPaymentResponseModelImplToJson(this);
  }
}

abstract class _CustomerPaymentResponseModel
    implements CustomerPaymentResponseModel {
  const factory _CustomerPaymentResponseModel({
    @JsonKey(name: 'ledger_entry_id') required final String ledgerEntryId,
    @JsonKey(name: 'customer_id') required final String customerId,
    required final String amount,
    @JsonKey(name: 'new_balance') required final String newBalance,
  }) = _$CustomerPaymentResponseModelImpl;

  factory _CustomerPaymentResponseModel.fromJson(Map<String, dynamic> json) =
      _$CustomerPaymentResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'ledger_entry_id')
  String get ledgerEntryId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  String get amount;
  @override
  @JsonKey(name: 'new_balance')
  String get newBalance;

  /// Create a copy of CustomerPaymentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerPaymentResponseModelImplCopyWith<
    _$CustomerPaymentResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
