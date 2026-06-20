// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseListItemModel _$ExpenseListItemModelFromJson(Map<String, dynamic> json) {
  return _ExpenseListItemModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseListItemModel {
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
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseListItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseListItemModelCopyWith<ExpenseListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseListItemModelCopyWith<$Res> {
  factory $ExpenseListItemModelCopyWith(
    ExpenseListItemModel value,
    $Res Function(ExpenseListItemModel) then,
  ) = _$ExpenseListItemModelCopyWithImpl<$Res, ExpenseListItemModel>;
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
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$ExpenseListItemModelCopyWithImpl<
  $Res,
  $Val extends ExpenseListItemModel
>
    implements $ExpenseListItemModelCopyWith<$Res> {
  _$ExpenseListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseListItemModel
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
abstract class _$$ExpenseListItemModelImplCopyWith<$Res>
    implements $ExpenseListItemModelCopyWith<$Res> {
  factory _$$ExpenseListItemModelImplCopyWith(
    _$ExpenseListItemModelImpl value,
    $Res Function(_$ExpenseListItemModelImpl) then,
  ) = __$$ExpenseListItemModelImplCopyWithImpl<$Res>;
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
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$ExpenseListItemModelImplCopyWithImpl<$Res>
    extends _$ExpenseListItemModelCopyWithImpl<$Res, _$ExpenseListItemModelImpl>
    implements _$$ExpenseListItemModelImplCopyWith<$Res> {
  __$$ExpenseListItemModelImplCopyWithImpl(
    _$ExpenseListItemModelImpl _value,
    $Res Function(_$ExpenseListItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseListItemModel
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
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExpenseListItemModelImpl(
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
class _$ExpenseListItemModelImpl implements _ExpenseListItemModel {
  const _$ExpenseListItemModelImpl({
    required this.id,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'expense_category_id') required this.expenseCategoryId,
    @JsonKey(name: 'supplier_id') this.supplierId,
    @JsonKey(name: 'expense_number') required this.expenseNumber,
    this.description,
    @JsonKey(name: 'expense_date') required this.expenseDate,
    required this.amount,
    @JsonKey(name: 'tax_amount') this.taxAmount = '0',
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$ExpenseListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseListItemModelImplFromJson(json);

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
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'ExpenseListItemModel(id: $id, branchId: $branchId, expenseCategoryId: $expenseCategoryId, supplierId: $supplierId, expenseNumber: $expenseNumber, description: $description, expenseDate: $expenseDate, amount: $amount, taxAmount: $taxAmount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseListItemModelImpl &&
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
    createdAt,
  );

  /// Create a copy of ExpenseListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseListItemModelImplCopyWith<_$ExpenseListItemModelImpl>
  get copyWith =>
      __$$ExpenseListItemModelImplCopyWithImpl<_$ExpenseListItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseListItemModelImplToJson(this);
  }
}

abstract class _ExpenseListItemModel implements ExpenseListItemModel {
  const factory _ExpenseListItemModel({
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
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$ExpenseListItemModelImpl;

  factory _ExpenseListItemModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseListItemModelImpl.fromJson;

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
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of ExpenseListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseListItemModelImplCopyWith<_$ExpenseListItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
