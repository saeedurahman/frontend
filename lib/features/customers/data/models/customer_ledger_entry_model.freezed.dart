// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_ledger_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerLedgerEntryModel _$CustomerLedgerEntryModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerLedgerEntryModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerLedgerEntryModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_type')
  LedgerEntryType get entryType => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String? get referenceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_at')
  String? get entryAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CustomerLedgerEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerLedgerEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerLedgerEntryModelCopyWith<CustomerLedgerEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerLedgerEntryModelCopyWith<$Res> {
  factory $CustomerLedgerEntryModelCopyWith(
    CustomerLedgerEntryModel value,
    $Res Function(CustomerLedgerEntryModel) then,
  ) = _$CustomerLedgerEntryModelCopyWithImpl<$Res, CustomerLedgerEntryModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'entry_type') LedgerEntryType entryType,
    String amount,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'entry_at') String? entryAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$CustomerLedgerEntryModelCopyWithImpl<
  $Res,
  $Val extends CustomerLedgerEntryModel
>
    implements $CustomerLedgerEntryModelCopyWith<$Res> {
  _$CustomerLedgerEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerLedgerEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? customerId = null,
    Object? entryType = null,
    Object? amount = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? entryAt = freezed,
    Object? notes = freezed,
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
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            entryType: null == entryType
                ? _value.entryType
                : entryType // ignore: cast_nullable_to_non_nullable
                      as LedgerEntryType,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceType: freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            entryAt: freezed == entryAt
                ? _value.entryAt
                : entryAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CustomerLedgerEntryModelImplCopyWith<$Res>
    implements $CustomerLedgerEntryModelCopyWith<$Res> {
  factory _$$CustomerLedgerEntryModelImplCopyWith(
    _$CustomerLedgerEntryModelImpl value,
    $Res Function(_$CustomerLedgerEntryModelImpl) then,
  ) = __$$CustomerLedgerEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'entry_type') LedgerEntryType entryType,
    String amount,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'entry_at') String? entryAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$CustomerLedgerEntryModelImplCopyWithImpl<$Res>
    extends
        _$CustomerLedgerEntryModelCopyWithImpl<
          $Res,
          _$CustomerLedgerEntryModelImpl
        >
    implements _$$CustomerLedgerEntryModelImplCopyWith<$Res> {
  __$$CustomerLedgerEntryModelImplCopyWithImpl(
    _$CustomerLedgerEntryModelImpl _value,
    $Res Function(_$CustomerLedgerEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerLedgerEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? customerId = null,
    Object? entryType = null,
    Object? amount = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? entryAt = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CustomerLedgerEntryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        entryType: null == entryType
            ? _value.entryType
            : entryType // ignore: cast_nullable_to_non_nullable
                  as LedgerEntryType,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceType: freezed == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entryAt: freezed == entryAt
            ? _value.entryAt
            : entryAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
class _$CustomerLedgerEntryModelImpl implements _CustomerLedgerEntryModel {
  const _$CustomerLedgerEntryModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'customer_id') required this.customerId,
    @JsonKey(name: 'entry_type') required this.entryType,
    required this.amount,
    @JsonKey(name: 'reference_type') this.referenceType,
    @JsonKey(name: 'reference_id') this.referenceId,
    @JsonKey(name: 'entry_at') this.entryAt,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$CustomerLedgerEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerLedgerEntryModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'entry_type')
  final LedgerEntryType entryType;
  @override
  final String amount;
  @override
  @JsonKey(name: 'reference_type')
  final String? referenceType;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'entry_at')
  final String? entryAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'CustomerLedgerEntryModel(id: $id, businessId: $businessId, customerId: $customerId, entryType: $entryType, amount: $amount, referenceType: $referenceType, referenceId: $referenceId, entryAt: $entryAt, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLedgerEntryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.entryAt, entryAt) || other.entryAt == entryAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    customerId,
    entryType,
    amount,
    referenceType,
    referenceId,
    entryAt,
    notes,
    createdAt,
  );

  /// Create a copy of CustomerLedgerEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerLedgerEntryModelImplCopyWith<_$CustomerLedgerEntryModelImpl>
  get copyWith =>
      __$$CustomerLedgerEntryModelImplCopyWithImpl<
        _$CustomerLedgerEntryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerLedgerEntryModelImplToJson(this);
  }
}

abstract class _CustomerLedgerEntryModel implements CustomerLedgerEntryModel {
  const factory _CustomerLedgerEntryModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'customer_id') required final String customerId,
    @JsonKey(name: 'entry_type') required final LedgerEntryType entryType,
    required final String amount,
    @JsonKey(name: 'reference_type') final String? referenceType,
    @JsonKey(name: 'reference_id') final String? referenceId,
    @JsonKey(name: 'entry_at') final String? entryAt,
    final String? notes,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$CustomerLedgerEntryModelImpl;

  factory _CustomerLedgerEntryModel.fromJson(Map<String, dynamic> json) =
      _$CustomerLedgerEntryModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'entry_type')
  LedgerEntryType get entryType;
  @override
  String get amount;
  @override
  @JsonKey(name: 'reference_type')
  String? get referenceType;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'entry_at')
  String? get entryAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of CustomerLedgerEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerLedgerEntryModelImplCopyWith<_$CustomerLedgerEntryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
