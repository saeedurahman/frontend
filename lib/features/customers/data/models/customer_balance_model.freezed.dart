// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_balance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerBalanceModel _$CustomerBalanceModelFromJson(Map<String, dynamic> json) {
  return _CustomerBalanceModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerBalanceModel {
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;

  /// Serializes this CustomerBalanceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerBalanceModelCopyWith<CustomerBalanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerBalanceModelCopyWith<$Res> {
  factory $CustomerBalanceModelCopyWith(
    CustomerBalanceModel value,
    $Res Function(CustomerBalanceModel) then,
  ) = _$CustomerBalanceModelCopyWithImpl<$Res, CustomerBalanceModel>;
  @useResult
  $Res call({@JsonKey(name: 'customer_id') String customerId, String balance});
}

/// @nodoc
class _$CustomerBalanceModelCopyWithImpl<
  $Res,
  $Val extends CustomerBalanceModel
>
    implements $CustomerBalanceModelCopyWith<$Res> {
  _$CustomerBalanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerId = null, Object? balance = null}) {
    return _then(
      _value.copyWith(
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerBalanceModelImplCopyWith<$Res>
    implements $CustomerBalanceModelCopyWith<$Res> {
  factory _$$CustomerBalanceModelImplCopyWith(
    _$CustomerBalanceModelImpl value,
    $Res Function(_$CustomerBalanceModelImpl) then,
  ) = __$$CustomerBalanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'customer_id') String customerId, String balance});
}

/// @nodoc
class __$$CustomerBalanceModelImplCopyWithImpl<$Res>
    extends _$CustomerBalanceModelCopyWithImpl<$Res, _$CustomerBalanceModelImpl>
    implements _$$CustomerBalanceModelImplCopyWith<$Res> {
  __$$CustomerBalanceModelImplCopyWithImpl(
    _$CustomerBalanceModelImpl _value,
    $Res Function(_$CustomerBalanceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerId = null, Object? balance = null}) {
    return _then(
      _$CustomerBalanceModelImpl(
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerBalanceModelImpl implements _CustomerBalanceModel {
  const _$CustomerBalanceModelImpl({
    @JsonKey(name: 'customer_id') required this.customerId,
    required this.balance,
  });

  factory _$CustomerBalanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerBalanceModelImplFromJson(json);

  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  final String balance;

  @override
  String toString() {
    return 'CustomerBalanceModel(customerId: $customerId, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerBalanceModelImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, customerId, balance);

  /// Create a copy of CustomerBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerBalanceModelImplCopyWith<_$CustomerBalanceModelImpl>
  get copyWith =>
      __$$CustomerBalanceModelImplCopyWithImpl<_$CustomerBalanceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerBalanceModelImplToJson(this);
  }
}

abstract class _CustomerBalanceModel implements CustomerBalanceModel {
  const factory _CustomerBalanceModel({
    @JsonKey(name: 'customer_id') required final String customerId,
    required final String balance,
  }) = _$CustomerBalanceModelImpl;

  factory _CustomerBalanceModel.fromJson(Map<String, dynamic> json) =
      _$CustomerBalanceModelImpl.fromJson;

  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  String get balance;

  /// Create a copy of CustomerBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerBalanceModelImplCopyWith<_$CustomerBalanceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
