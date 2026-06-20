// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ExpenseFormState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get expenseId => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get taxAmount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get expenseDate => throw _privateConstructorUsedError;
  bool get recordPaymentNow => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get paymentAmount => throw _privateConstructorUsedError;
  String? get referenceNo => throw _privateConstructorUsedError;
  List<ExpenseCategoryModel> get categories =>
      throw _privateConstructorUsedError;
  List<SupplierModel> get suppliers => throw _privateConstructorUsedError;
  String? get activePaymentShiftId => throw _privateConstructorUsedError;
  bool get isCheckingPaymentShift => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseFormStateCopyWith<ExpenseFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseFormStateCopyWith<$Res> {
  factory $ExpenseFormStateCopyWith(
    ExpenseFormState value,
    $Res Function(ExpenseFormState) then,
  ) = _$ExpenseFormStateCopyWithImpl<$Res, ExpenseFormState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isSaving,
    String? expenseId,
    String? branchId,
    String? categoryId,
    String? supplierId,
    String amount,
    String taxAmount,
    String description,
    DateTime? expenseDate,
    bool recordPaymentNow,
    String paymentMethod,
    String paymentAmount,
    String? referenceNo,
    List<ExpenseCategoryModel> categories,
    List<SupplierModel> suppliers,
    String? activePaymentShiftId,
    bool isCheckingPaymentShift,
    Map<String, String> errors,
  });
}

/// @nodoc
class _$ExpenseFormStateCopyWithImpl<$Res, $Val extends ExpenseFormState>
    implements $ExpenseFormStateCopyWith<$Res> {
  _$ExpenseFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSaving = null,
    Object? expenseId = freezed,
    Object? branchId = freezed,
    Object? categoryId = freezed,
    Object? supplierId = freezed,
    Object? amount = null,
    Object? taxAmount = null,
    Object? description = null,
    Object? expenseDate = freezed,
    Object? recordPaymentNow = null,
    Object? paymentMethod = null,
    Object? paymentAmount = null,
    Object? referenceNo = freezed,
    Object? categories = null,
    Object? suppliers = null,
    Object? activePaymentShiftId = freezed,
    Object? isCheckingPaymentShift = null,
    Object? errors = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            expenseId: freezed == expenseId
                ? _value.expenseId
                : expenseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            supplierId: freezed == supplierId
                ? _value.supplierId
                : supplierId // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            expenseDate: freezed == expenseDate
                ? _value.expenseDate
                : expenseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            recordPaymentNow: null == recordPaymentNow
                ? _value.recordPaymentNow
                : recordPaymentNow // ignore: cast_nullable_to_non_nullable
                      as bool,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentAmount: null == paymentAmount
                ? _value.paymentAmount
                : paymentAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceNo: freezed == referenceNo
                ? _value.referenceNo
                : referenceNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<ExpenseCategoryModel>,
            suppliers: null == suppliers
                ? _value.suppliers
                : suppliers // ignore: cast_nullable_to_non_nullable
                      as List<SupplierModel>,
            activePaymentShiftId: freezed == activePaymentShiftId
                ? _value.activePaymentShiftId
                : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCheckingPaymentShift: null == isCheckingPaymentShift
                ? _value.isCheckingPaymentShift
                : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseFormStateImplCopyWith<$Res>
    implements $ExpenseFormStateCopyWith<$Res> {
  factory _$$ExpenseFormStateImplCopyWith(
    _$ExpenseFormStateImpl value,
    $Res Function(_$ExpenseFormStateImpl) then,
  ) = __$$ExpenseFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isSaving,
    String? expenseId,
    String? branchId,
    String? categoryId,
    String? supplierId,
    String amount,
    String taxAmount,
    String description,
    DateTime? expenseDate,
    bool recordPaymentNow,
    String paymentMethod,
    String paymentAmount,
    String? referenceNo,
    List<ExpenseCategoryModel> categories,
    List<SupplierModel> suppliers,
    String? activePaymentShiftId,
    bool isCheckingPaymentShift,
    Map<String, String> errors,
  });
}

/// @nodoc
class __$$ExpenseFormStateImplCopyWithImpl<$Res>
    extends _$ExpenseFormStateCopyWithImpl<$Res, _$ExpenseFormStateImpl>
    implements _$$ExpenseFormStateImplCopyWith<$Res> {
  __$$ExpenseFormStateImplCopyWithImpl(
    _$ExpenseFormStateImpl _value,
    $Res Function(_$ExpenseFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSaving = null,
    Object? expenseId = freezed,
    Object? branchId = freezed,
    Object? categoryId = freezed,
    Object? supplierId = freezed,
    Object? amount = null,
    Object? taxAmount = null,
    Object? description = null,
    Object? expenseDate = freezed,
    Object? recordPaymentNow = null,
    Object? paymentMethod = null,
    Object? paymentAmount = null,
    Object? referenceNo = freezed,
    Object? categories = null,
    Object? suppliers = null,
    Object? activePaymentShiftId = freezed,
    Object? isCheckingPaymentShift = null,
    Object? errors = null,
  }) {
    return _then(
      _$ExpenseFormStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        expenseId: freezed == expenseId
            ? _value.expenseId
            : expenseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        supplierId: freezed == supplierId
            ? _value.supplierId
            : supplierId // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseDate: freezed == expenseDate
            ? _value.expenseDate
            : expenseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        recordPaymentNow: null == recordPaymentNow
            ? _value.recordPaymentNow
            : recordPaymentNow // ignore: cast_nullable_to_non_nullable
                  as bool,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentAmount: null == paymentAmount
            ? _value.paymentAmount
            : paymentAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceNo: freezed == referenceNo
            ? _value.referenceNo
            : referenceNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<ExpenseCategoryModel>,
        suppliers: null == suppliers
            ? _value._suppliers
            : suppliers // ignore: cast_nullable_to_non_nullable
                  as List<SupplierModel>,
        activePaymentShiftId: freezed == activePaymentShiftId
            ? _value.activePaymentShiftId
            : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCheckingPaymentShift: null == isCheckingPaymentShift
            ? _value.isCheckingPaymentShift
            : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$ExpenseFormStateImpl implements _ExpenseFormState {
  const _$ExpenseFormStateImpl({
    this.isLoading = false,
    this.isSaving = false,
    this.expenseId,
    this.branchId,
    this.categoryId,
    this.supplierId,
    this.amount = '',
    this.taxAmount = '0',
    this.description = '',
    this.expenseDate,
    this.recordPaymentNow = false,
    this.paymentMethod = 'cash',
    this.paymentAmount = '',
    this.referenceNo,
    final List<ExpenseCategoryModel> categories = const [],
    final List<SupplierModel> suppliers = const [],
    this.activePaymentShiftId,
    this.isCheckingPaymentShift = false,
    final Map<String, String> errors = const {},
  }) : _categories = categories,
       _suppliers = suppliers,
       _errors = errors;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? expenseId;
  @override
  final String? branchId;
  @override
  final String? categoryId;
  @override
  final String? supplierId;
  @override
  @JsonKey()
  final String amount;
  @override
  @JsonKey()
  final String taxAmount;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? expenseDate;
  @override
  @JsonKey()
  final bool recordPaymentNow;
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  @JsonKey()
  final String paymentAmount;
  @override
  final String? referenceNo;
  final List<ExpenseCategoryModel> _categories;
  @override
  @JsonKey()
  List<ExpenseCategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<SupplierModel> _suppliers;
  @override
  @JsonKey()
  List<SupplierModel> get suppliers {
    if (_suppliers is EqualUnmodifiableListView) return _suppliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suppliers);
  }

  @override
  final String? activePaymentShiftId;
  @override
  @JsonKey()
  final bool isCheckingPaymentShift;
  final Map<String, String> _errors;
  @override
  @JsonKey()
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  String toString() {
    return 'ExpenseFormState(isLoading: $isLoading, isSaving: $isSaving, expenseId: $expenseId, branchId: $branchId, categoryId: $categoryId, supplierId: $supplierId, amount: $amount, taxAmount: $taxAmount, description: $description, expenseDate: $expenseDate, recordPaymentNow: $recordPaymentNow, paymentMethod: $paymentMethod, paymentAmount: $paymentAmount, referenceNo: $referenceNo, categories: $categories, suppliers: $suppliers, activePaymentShiftId: $activePaymentShiftId, isCheckingPaymentShift: $isCheckingPaymentShift, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseFormStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.recordPaymentNow, recordPaymentNow) ||
                other.recordPaymentNow == recordPaymentNow) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentAmount, paymentAmount) ||
                other.paymentAmount == paymentAmount) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._suppliers,
              _suppliers,
            ) &&
            (identical(other.activePaymentShiftId, activePaymentShiftId) ||
                other.activePaymentShiftId == activePaymentShiftId) &&
            (identical(other.isCheckingPaymentShift, isCheckingPaymentShift) ||
                other.isCheckingPaymentShift == isCheckingPaymentShift) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    isLoading,
    isSaving,
    expenseId,
    branchId,
    categoryId,
    supplierId,
    amount,
    taxAmount,
    description,
    expenseDate,
    recordPaymentNow,
    paymentMethod,
    paymentAmount,
    referenceNo,
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_suppliers),
    activePaymentShiftId,
    isCheckingPaymentShift,
    const DeepCollectionEquality().hash(_errors),
  ]);

  /// Create a copy of ExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseFormStateImplCopyWith<_$ExpenseFormStateImpl> get copyWith =>
      __$$ExpenseFormStateImplCopyWithImpl<_$ExpenseFormStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ExpenseFormState implements ExpenseFormState {
  const factory _ExpenseFormState({
    final bool isLoading,
    final bool isSaving,
    final String? expenseId,
    final String? branchId,
    final String? categoryId,
    final String? supplierId,
    final String amount,
    final String taxAmount,
    final String description,
    final DateTime? expenseDate,
    final bool recordPaymentNow,
    final String paymentMethod,
    final String paymentAmount,
    final String? referenceNo,
    final List<ExpenseCategoryModel> categories,
    final List<SupplierModel> suppliers,
    final String? activePaymentShiftId,
    final bool isCheckingPaymentShift,
    final Map<String, String> errors,
  }) = _$ExpenseFormStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  String? get expenseId;
  @override
  String? get branchId;
  @override
  String? get categoryId;
  @override
  String? get supplierId;
  @override
  String get amount;
  @override
  String get taxAmount;
  @override
  String get description;
  @override
  DateTime? get expenseDate;
  @override
  bool get recordPaymentNow;
  @override
  String get paymentMethod;
  @override
  String get paymentAmount;
  @override
  String? get referenceNo;
  @override
  List<ExpenseCategoryModel> get categories;
  @override
  List<SupplierModel> get suppliers;
  @override
  String? get activePaymentShiftId;
  @override
  bool get isCheckingPaymentShift;
  @override
  Map<String, String> get errors;

  /// Create a copy of ExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseFormStateImplCopyWith<_$ExpenseFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
