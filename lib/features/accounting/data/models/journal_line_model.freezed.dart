// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JournalLineModel _$JournalLineModelFromJson(Map<String, dynamic> json) {
  return _JournalLineModel.fromJson(json);
}

/// @nodoc
mixin _$JournalLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_code')
  String get accountCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'debit_amount')
  String get debitAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_amount')
  String get creditAmount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_order')
  int get lineOrder => throw _privateConstructorUsedError;

  /// Serializes this JournalLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalLineModelCopyWith<JournalLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalLineModelCopyWith<$Res> {
  factory $JournalLineModelCopyWith(
    JournalLineModel value,
    $Res Function(JournalLineModel) then,
  ) = _$JournalLineModelCopyWithImpl<$Res, JournalLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'account_code') String accountCode,
    @JsonKey(name: 'account_name') String accountName,
    @JsonKey(name: 'debit_amount') String debitAmount,
    @JsonKey(name: 'credit_amount') String creditAmount,
    String? description,
    @JsonKey(name: 'line_order') int lineOrder,
  });
}

/// @nodoc
class _$JournalLineModelCopyWithImpl<$Res, $Val extends JournalLineModel>
    implements $JournalLineModelCopyWith<$Res> {
  _$JournalLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? accountCode = null,
    Object? accountName = null,
    Object? debitAmount = null,
    Object? creditAmount = null,
    Object? description = freezed,
    Object? lineOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            accountCode: null == accountCode
                ? _value.accountCode
                : accountCode // ignore: cast_nullable_to_non_nullable
                      as String,
            accountName: null == accountName
                ? _value.accountName
                : accountName // ignore: cast_nullable_to_non_nullable
                      as String,
            debitAmount: null == debitAmount
                ? _value.debitAmount
                : debitAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            creditAmount: null == creditAmount
                ? _value.creditAmount
                : creditAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            lineOrder: null == lineOrder
                ? _value.lineOrder
                : lineOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JournalLineModelImplCopyWith<$Res>
    implements $JournalLineModelCopyWith<$Res> {
  factory _$$JournalLineModelImplCopyWith(
    _$JournalLineModelImpl value,
    $Res Function(_$JournalLineModelImpl) then,
  ) = __$$JournalLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'account_code') String accountCode,
    @JsonKey(name: 'account_name') String accountName,
    @JsonKey(name: 'debit_amount') String debitAmount,
    @JsonKey(name: 'credit_amount') String creditAmount,
    String? description,
    @JsonKey(name: 'line_order') int lineOrder,
  });
}

/// @nodoc
class __$$JournalLineModelImplCopyWithImpl<$Res>
    extends _$JournalLineModelCopyWithImpl<$Res, _$JournalLineModelImpl>
    implements _$$JournalLineModelImplCopyWith<$Res> {
  __$$JournalLineModelImplCopyWithImpl(
    _$JournalLineModelImpl _value,
    $Res Function(_$JournalLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JournalLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? accountCode = null,
    Object? accountName = null,
    Object? debitAmount = null,
    Object? creditAmount = null,
    Object? description = freezed,
    Object? lineOrder = null,
  }) {
    return _then(
      _$JournalLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        accountCode: null == accountCode
            ? _value.accountCode
            : accountCode // ignore: cast_nullable_to_non_nullable
                  as String,
        accountName: null == accountName
            ? _value.accountName
            : accountName // ignore: cast_nullable_to_non_nullable
                  as String,
        debitAmount: null == debitAmount
            ? _value.debitAmount
            : debitAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        creditAmount: null == creditAmount
            ? _value.creditAmount
            : creditAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        lineOrder: null == lineOrder
            ? _value.lineOrder
            : lineOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalLineModelImpl implements _JournalLineModel {
  const _$JournalLineModelImpl({
    required this.id,
    @JsonKey(name: 'account_id') required this.accountId,
    @JsonKey(name: 'account_code') required this.accountCode,
    @JsonKey(name: 'account_name') required this.accountName,
    @JsonKey(name: 'debit_amount') required this.debitAmount,
    @JsonKey(name: 'credit_amount') required this.creditAmount,
    this.description,
    @JsonKey(name: 'line_order') this.lineOrder = 0,
  });

  factory _$JournalLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'account_code')
  final String accountCode;
  @override
  @JsonKey(name: 'account_name')
  final String accountName;
  @override
  @JsonKey(name: 'debit_amount')
  final String debitAmount;
  @override
  @JsonKey(name: 'credit_amount')
  final String creditAmount;
  @override
  final String? description;
  @override
  @JsonKey(name: 'line_order')
  final int lineOrder;

  @override
  String toString() {
    return 'JournalLineModel(id: $id, accountId: $accountId, accountCode: $accountCode, accountName: $accountName, debitAmount: $debitAmount, creditAmount: $creditAmount, description: $description, lineOrder: $lineOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.debitAmount, debitAmount) ||
                other.debitAmount == debitAmount) &&
            (identical(other.creditAmount, creditAmount) ||
                other.creditAmount == creditAmount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lineOrder, lineOrder) ||
                other.lineOrder == lineOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    accountId,
    accountCode,
    accountName,
    debitAmount,
    creditAmount,
    description,
    lineOrder,
  );

  /// Create a copy of JournalLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalLineModelImplCopyWith<_$JournalLineModelImpl> get copyWith =>
      __$$JournalLineModelImplCopyWithImpl<_$JournalLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalLineModelImplToJson(this);
  }
}

abstract class _JournalLineModel implements JournalLineModel {
  const factory _JournalLineModel({
    required final String id,
    @JsonKey(name: 'account_id') required final String accountId,
    @JsonKey(name: 'account_code') required final String accountCode,
    @JsonKey(name: 'account_name') required final String accountName,
    @JsonKey(name: 'debit_amount') required final String debitAmount,
    @JsonKey(name: 'credit_amount') required final String creditAmount,
    final String? description,
    @JsonKey(name: 'line_order') final int lineOrder,
  }) = _$JournalLineModelImpl;

  factory _JournalLineModel.fromJson(Map<String, dynamic> json) =
      _$JournalLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'account_code')
  String get accountCode;
  @override
  @JsonKey(name: 'account_name')
  String get accountName;
  @override
  @JsonKey(name: 'debit_amount')
  String get debitAmount;
  @override
  @JsonKey(name: 'credit_amount')
  String get creditAmount;
  @override
  String? get description;
  @override
  @JsonKey(name: 'line_order')
  int get lineOrder;

  /// Create a copy of JournalLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalLineModelImplCopyWith<_$JournalLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
