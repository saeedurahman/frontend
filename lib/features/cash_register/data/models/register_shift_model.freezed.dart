// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_shift_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegisterShiftModel _$RegisterShiftModelFromJson(Map<String, dynamic> json) {
  return _RegisterShiftModel.fromJson(json);
}

/// @nodoc
mixin _$RegisterShiftModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_register_id')
  String get cashRegisterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String? get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'opened_by')
  String? get openedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'closed_by')
  String? get closedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'opened_by_name')
  String? get openedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'closed_by_name')
  String? get closedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_float')
  String get openingFloat => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_cash')
  String? get expectedCash => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_cash')
  String? get actualCash => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_difference')
  String? get cashDifference => throw _privateConstructorUsedError;
  @JsonKey(name: 'opened_at')
  String? get openedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'closed_at')
  String? get closedAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  CashRegisterModel? get register => throw _privateConstructorUsedError;

  /// Serializes this RegisterShiftModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterShiftModelCopyWith<RegisterShiftModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterShiftModelCopyWith<$Res> {
  factory $RegisterShiftModelCopyWith(
    RegisterShiftModel value,
    $Res Function(RegisterShiftModel) then,
  ) = _$RegisterShiftModelCopyWithImpl<$Res, RegisterShiftModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'cash_register_id') String cashRegisterId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'opened_by') String? openedBy,
    @JsonKey(name: 'closed_by') String? closedBy,
    @JsonKey(name: 'opened_by_name') String? openedByName,
    @JsonKey(name: 'closed_by_name') String? closedByName,
    @JsonKey(name: 'opening_float') String openingFloat,
    @JsonKey(name: 'expected_cash') String? expectedCash,
    @JsonKey(name: 'actual_cash') String? actualCash,
    @JsonKey(name: 'cash_difference') String? cashDifference,
    @JsonKey(name: 'opened_at') String? openedAt,
    @JsonKey(name: 'closed_at') String? closedAt,
    String status,
    String? notes,
    CashRegisterModel? register,
  });

  $CashRegisterModelCopyWith<$Res>? get register;
}

/// @nodoc
class _$RegisterShiftModelCopyWithImpl<$Res, $Val extends RegisterShiftModel>
    implements $RegisterShiftModelCopyWith<$Res> {
  _$RegisterShiftModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cashRegisterId = null,
    Object? branchId = freezed,
    Object? openedBy = freezed,
    Object? closedBy = freezed,
    Object? openedByName = freezed,
    Object? closedByName = freezed,
    Object? openingFloat = null,
    Object? expectedCash = freezed,
    Object? actualCash = freezed,
    Object? cashDifference = freezed,
    Object? openedAt = freezed,
    Object? closedAt = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? register = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cashRegisterId: null == cashRegisterId
                ? _value.cashRegisterId
                : cashRegisterId // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            openedBy: freezed == openedBy
                ? _value.openedBy
                : openedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            closedBy: freezed == closedBy
                ? _value.closedBy
                : closedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            openedByName: freezed == openedByName
                ? _value.openedByName
                : openedByName // ignore: cast_nullable_to_non_nullable
                      as String?,
            closedByName: freezed == closedByName
                ? _value.closedByName
                : closedByName // ignore: cast_nullable_to_non_nullable
                      as String?,
            openingFloat: null == openingFloat
                ? _value.openingFloat
                : openingFloat // ignore: cast_nullable_to_non_nullable
                      as String,
            expectedCash: freezed == expectedCash
                ? _value.expectedCash
                : expectedCash // ignore: cast_nullable_to_non_nullable
                      as String?,
            actualCash: freezed == actualCash
                ? _value.actualCash
                : actualCash // ignore: cast_nullable_to_non_nullable
                      as String?,
            cashDifference: freezed == cashDifference
                ? _value.cashDifference
                : cashDifference // ignore: cast_nullable_to_non_nullable
                      as String?,
            openedAt: freezed == openedAt
                ? _value.openedAt
                : openedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            closedAt: freezed == closedAt
                ? _value.closedAt
                : closedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            register: freezed == register
                ? _value.register
                : register // ignore: cast_nullable_to_non_nullable
                      as CashRegisterModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of RegisterShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashRegisterModelCopyWith<$Res>? get register {
    if (_value.register == null) {
      return null;
    }

    return $CashRegisterModelCopyWith<$Res>(_value.register!, (value) {
      return _then(_value.copyWith(register: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegisterShiftModelImplCopyWith<$Res>
    implements $RegisterShiftModelCopyWith<$Res> {
  factory _$$RegisterShiftModelImplCopyWith(
    _$RegisterShiftModelImpl value,
    $Res Function(_$RegisterShiftModelImpl) then,
  ) = __$$RegisterShiftModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'cash_register_id') String cashRegisterId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'opened_by') String? openedBy,
    @JsonKey(name: 'closed_by') String? closedBy,
    @JsonKey(name: 'opened_by_name') String? openedByName,
    @JsonKey(name: 'closed_by_name') String? closedByName,
    @JsonKey(name: 'opening_float') String openingFloat,
    @JsonKey(name: 'expected_cash') String? expectedCash,
    @JsonKey(name: 'actual_cash') String? actualCash,
    @JsonKey(name: 'cash_difference') String? cashDifference,
    @JsonKey(name: 'opened_at') String? openedAt,
    @JsonKey(name: 'closed_at') String? closedAt,
    String status,
    String? notes,
    CashRegisterModel? register,
  });

  @override
  $CashRegisterModelCopyWith<$Res>? get register;
}

/// @nodoc
class __$$RegisterShiftModelImplCopyWithImpl<$Res>
    extends _$RegisterShiftModelCopyWithImpl<$Res, _$RegisterShiftModelImpl>
    implements _$$RegisterShiftModelImplCopyWith<$Res> {
  __$$RegisterShiftModelImplCopyWithImpl(
    _$RegisterShiftModelImpl _value,
    $Res Function(_$RegisterShiftModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cashRegisterId = null,
    Object? branchId = freezed,
    Object? openedBy = freezed,
    Object? closedBy = freezed,
    Object? openedByName = freezed,
    Object? closedByName = freezed,
    Object? openingFloat = null,
    Object? expectedCash = freezed,
    Object? actualCash = freezed,
    Object? cashDifference = freezed,
    Object? openedAt = freezed,
    Object? closedAt = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? register = freezed,
  }) {
    return _then(
      _$RegisterShiftModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cashRegisterId: null == cashRegisterId
            ? _value.cashRegisterId
            : cashRegisterId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        openedBy: freezed == openedBy
            ? _value.openedBy
            : openedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        closedBy: freezed == closedBy
            ? _value.closedBy
            : closedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        openedByName: freezed == openedByName
            ? _value.openedByName
            : openedByName // ignore: cast_nullable_to_non_nullable
                  as String?,
        closedByName: freezed == closedByName
            ? _value.closedByName
            : closedByName // ignore: cast_nullable_to_non_nullable
                  as String?,
        openingFloat: null == openingFloat
            ? _value.openingFloat
            : openingFloat // ignore: cast_nullable_to_non_nullable
                  as String,
        expectedCash: freezed == expectedCash
            ? _value.expectedCash
            : expectedCash // ignore: cast_nullable_to_non_nullable
                  as String?,
        actualCash: freezed == actualCash
            ? _value.actualCash
            : actualCash // ignore: cast_nullable_to_non_nullable
                  as String?,
        cashDifference: freezed == cashDifference
            ? _value.cashDifference
            : cashDifference // ignore: cast_nullable_to_non_nullable
                  as String?,
        openedAt: freezed == openedAt
            ? _value.openedAt
            : openedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        closedAt: freezed == closedAt
            ? _value.closedAt
            : closedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        register: freezed == register
            ? _value.register
            : register // ignore: cast_nullable_to_non_nullable
                  as CashRegisterModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterShiftModelImpl implements _RegisterShiftModel {
  const _$RegisterShiftModelImpl({
    required this.id,
    @JsonKey(name: 'cash_register_id') required this.cashRegisterId,
    @JsonKey(name: 'branch_id') this.branchId,
    @JsonKey(name: 'opened_by') this.openedBy,
    @JsonKey(name: 'closed_by') this.closedBy,
    @JsonKey(name: 'opened_by_name') this.openedByName,
    @JsonKey(name: 'closed_by_name') this.closedByName,
    @JsonKey(name: 'opening_float') this.openingFloat = '0',
    @JsonKey(name: 'expected_cash') this.expectedCash,
    @JsonKey(name: 'actual_cash') this.actualCash,
    @JsonKey(name: 'cash_difference') this.cashDifference,
    @JsonKey(name: 'opened_at') this.openedAt,
    @JsonKey(name: 'closed_at') this.closedAt,
    this.status = 'open',
    this.notes,
    this.register,
  });

  factory _$RegisterShiftModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterShiftModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'cash_register_id')
  final String cashRegisterId;
  @override
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @override
  @JsonKey(name: 'opened_by')
  final String? openedBy;
  @override
  @JsonKey(name: 'closed_by')
  final String? closedBy;
  @override
  @JsonKey(name: 'opened_by_name')
  final String? openedByName;
  @override
  @JsonKey(name: 'closed_by_name')
  final String? closedByName;
  @override
  @JsonKey(name: 'opening_float')
  final String openingFloat;
  @override
  @JsonKey(name: 'expected_cash')
  final String? expectedCash;
  @override
  @JsonKey(name: 'actual_cash')
  final String? actualCash;
  @override
  @JsonKey(name: 'cash_difference')
  final String? cashDifference;
  @override
  @JsonKey(name: 'opened_at')
  final String? openedAt;
  @override
  @JsonKey(name: 'closed_at')
  final String? closedAt;
  @override
  @JsonKey()
  final String status;
  @override
  final String? notes;
  @override
  final CashRegisterModel? register;

  @override
  String toString() {
    return 'RegisterShiftModel(id: $id, cashRegisterId: $cashRegisterId, branchId: $branchId, openedBy: $openedBy, closedBy: $closedBy, openedByName: $openedByName, closedByName: $closedByName, openingFloat: $openingFloat, expectedCash: $expectedCash, actualCash: $actualCash, cashDifference: $cashDifference, openedAt: $openedAt, closedAt: $closedAt, status: $status, notes: $notes, register: $register)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterShiftModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cashRegisterId, cashRegisterId) ||
                other.cashRegisterId == cashRegisterId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.openedBy, openedBy) ||
                other.openedBy == openedBy) &&
            (identical(other.closedBy, closedBy) ||
                other.closedBy == closedBy) &&
            (identical(other.openedByName, openedByName) ||
                other.openedByName == openedByName) &&
            (identical(other.closedByName, closedByName) ||
                other.closedByName == closedByName) &&
            (identical(other.openingFloat, openingFloat) ||
                other.openingFloat == openingFloat) &&
            (identical(other.expectedCash, expectedCash) ||
                other.expectedCash == expectedCash) &&
            (identical(other.actualCash, actualCash) ||
                other.actualCash == actualCash) &&
            (identical(other.cashDifference, cashDifference) ||
                other.cashDifference == cashDifference) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.register, register) ||
                other.register == register));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cashRegisterId,
    branchId,
    openedBy,
    closedBy,
    openedByName,
    closedByName,
    openingFloat,
    expectedCash,
    actualCash,
    cashDifference,
    openedAt,
    closedAt,
    status,
    notes,
    register,
  );

  /// Create a copy of RegisterShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterShiftModelImplCopyWith<_$RegisterShiftModelImpl> get copyWith =>
      __$$RegisterShiftModelImplCopyWithImpl<_$RegisterShiftModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterShiftModelImplToJson(this);
  }
}

abstract class _RegisterShiftModel implements RegisterShiftModel {
  const factory _RegisterShiftModel({
    required final String id,
    @JsonKey(name: 'cash_register_id') required final String cashRegisterId,
    @JsonKey(name: 'branch_id') final String? branchId,
    @JsonKey(name: 'opened_by') final String? openedBy,
    @JsonKey(name: 'closed_by') final String? closedBy,
    @JsonKey(name: 'opened_by_name') final String? openedByName,
    @JsonKey(name: 'closed_by_name') final String? closedByName,
    @JsonKey(name: 'opening_float') final String openingFloat,
    @JsonKey(name: 'expected_cash') final String? expectedCash,
    @JsonKey(name: 'actual_cash') final String? actualCash,
    @JsonKey(name: 'cash_difference') final String? cashDifference,
    @JsonKey(name: 'opened_at') final String? openedAt,
    @JsonKey(name: 'closed_at') final String? closedAt,
    final String status,
    final String? notes,
    final CashRegisterModel? register,
  }) = _$RegisterShiftModelImpl;

  factory _RegisterShiftModel.fromJson(Map<String, dynamic> json) =
      _$RegisterShiftModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'cash_register_id')
  String get cashRegisterId;
  @override
  @JsonKey(name: 'branch_id')
  String? get branchId;
  @override
  @JsonKey(name: 'opened_by')
  String? get openedBy;
  @override
  @JsonKey(name: 'closed_by')
  String? get closedBy;
  @override
  @JsonKey(name: 'opened_by_name')
  String? get openedByName;
  @override
  @JsonKey(name: 'closed_by_name')
  String? get closedByName;
  @override
  @JsonKey(name: 'opening_float')
  String get openingFloat;
  @override
  @JsonKey(name: 'expected_cash')
  String? get expectedCash;
  @override
  @JsonKey(name: 'actual_cash')
  String? get actualCash;
  @override
  @JsonKey(name: 'cash_difference')
  String? get cashDifference;
  @override
  @JsonKey(name: 'opened_at')
  String? get openedAt;
  @override
  @JsonKey(name: 'closed_at')
  String? get closedAt;
  @override
  String get status;
  @override
  String? get notes;
  @override
  CashRegisterModel? get register;

  /// Create a copy of RegisterShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterShiftModelImplCopyWith<_$RegisterShiftModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
