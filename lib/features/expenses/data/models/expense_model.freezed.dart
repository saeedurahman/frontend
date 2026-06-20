// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_category_id')
  String get expenseCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  String? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_number')
  String get expenseNumber => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_date')
  String get expenseDate => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  String get taxAmount => throw _privateConstructorUsedError;
  List<ExpensePaymentModel> get payments => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
    ExpenseModel value,
    $Res Function(ExpenseModel) then,
  ) = _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'expense_category_id') String expenseCategoryId,
    @JsonKey(name: 'supplier_id') String? supplierId,
    @JsonKey(name: 'expense_number') String expenseNumber,
    String? description,
    @JsonKey(name: 'expense_date') String expenseDate,
    String amount,
    @JsonKey(name: 'tax_amount') String taxAmount,
    List<ExpensePaymentModel> payments,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? expenseCategoryId = null,
    Object? supplierId = freezed,
    Object? expenseNumber = null,
    Object? description = freezed,
    Object? expenseDate = null,
    Object? amount = null,
    Object? taxAmount = null,
    Object? payments = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            expenseCategoryId: null == expenseCategoryId
                ? _value.expenseCategoryId
                : expenseCategoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            supplierId: freezed == supplierId
                ? _value.supplierId
                : supplierId // ignore: cast_nullable_to_non_nullable
                      as String?,
            expenseNumber: null == expenseNumber
                ? _value.expenseNumber
                : expenseNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            expenseDate: null == expenseDate
                ? _value.expenseDate
                : expenseDate // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<ExpensePaymentModel>,
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
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
    _$ExpenseModelImpl value,
    $Res Function(_$ExpenseModelImpl) then,
  ) = __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'expense_category_id') String expenseCategoryId,
    @JsonKey(name: 'supplier_id') String? supplierId,
    @JsonKey(name: 'expense_number') String expenseNumber,
    String? description,
    @JsonKey(name: 'expense_date') String expenseDate,
    String amount,
    @JsonKey(name: 'tax_amount') String taxAmount,
    List<ExpensePaymentModel> payments,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
    _$ExpenseModelImpl _value,
    $Res Function(_$ExpenseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? expenseCategoryId = null,
    Object? supplierId = freezed,
    Object? expenseNumber = null,
    Object? description = freezed,
    Object? expenseDate = null,
    Object? amount = null,
    Object? taxAmount = null,
    Object? payments = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExpenseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseCategoryId: null == expenseCategoryId
            ? _value.expenseCategoryId
            : expenseCategoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        supplierId: freezed == supplierId
            ? _value.supplierId
            : supplierId // ignore: cast_nullable_to_non_nullable
                  as String?,
        expenseNumber: null == expenseNumber
            ? _value.expenseNumber
            : expenseNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        expenseDate: null == expenseDate
            ? _value.expenseDate
            : expenseDate // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<ExpensePaymentModel>,
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
class _$ExpenseModelImpl implements _ExpenseModel {
  const _$ExpenseModelImpl({
    required this.id,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'expense_category_id') required this.expenseCategoryId,
    @JsonKey(name: 'supplier_id') this.supplierId,
    @JsonKey(name: 'expense_number') required this.expenseNumber,
    this.description,
    @JsonKey(name: 'expense_date') required this.expenseDate,
    required this.amount,
    @JsonKey(name: 'tax_amount') this.taxAmount = '0',
    final List<ExpensePaymentModel> payments = const [],
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _payments = payments;

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'expense_category_id')
  final String expenseCategoryId;
  @override
  @JsonKey(name: 'supplier_id')
  final String? supplierId;
  @override
  @JsonKey(name: 'expense_number')
  final String expenseNumber;
  @override
  final String? description;
  @override
  @JsonKey(name: 'expense_date')
  final String expenseDate;
  @override
  final String amount;
  @override
  @JsonKey(name: 'tax_amount')
  final String taxAmount;
  final List<ExpensePaymentModel> _payments;
  @override
  @JsonKey()
  List<ExpensePaymentModel> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, branchId: $branchId, expenseCategoryId: $expenseCategoryId, supplierId: $supplierId, expenseNumber: $expenseNumber, description: $description, expenseDate: $expenseDate, amount: $amount, taxAmount: $taxAmount, payments: $payments, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.expenseCategoryId, expenseCategoryId) ||
                other.expenseCategoryId == expenseCategoryId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.expenseNumber, expenseNumber) ||
                other.expenseNumber == expenseNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    branchId,
    expenseCategoryId,
    supplierId,
    expenseNumber,
    description,
    expenseDate,
    amount,
    taxAmount,
    const DeepCollectionEquality().hash(_payments),
    createdAt,
  );

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(this);
  }
}

abstract class _ExpenseModel implements ExpenseModel {
  const factory _ExpenseModel({
    required final String id,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'expense_category_id')
    required final String expenseCategoryId,
    @JsonKey(name: 'supplier_id') final String? supplierId,
    @JsonKey(name: 'expense_number') required final String expenseNumber,
    final String? description,
    @JsonKey(name: 'expense_date') required final String expenseDate,
    required final String amount,
    @JsonKey(name: 'tax_amount') final String taxAmount,
    final List<ExpensePaymentModel> payments,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$ExpenseModelImpl;

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'expense_category_id')
  String get expenseCategoryId;
  @override
  @JsonKey(name: 'supplier_id')
  String? get supplierId;
  @override
  @JsonKey(name: 'expense_number')
  String get expenseNumber;
  @override
  String? get description;
  @override
  @JsonKey(name: 'expense_date')
  String get expenseDate;
  @override
  String get amount;
  @override
  @JsonKey(name: 'tax_amount')
  String get taxAmount;
  @override
  List<ExpensePaymentModel> get payments;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
