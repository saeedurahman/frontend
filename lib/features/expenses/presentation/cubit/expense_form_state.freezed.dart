// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseFormState {

 bool get isLoading; bool get isSaving; String? get expenseId; String? get branchId; String? get categoryId; String? get supplierId; String get amount; String get taxAmount; String get description; DateTime? get expenseDate; bool get recordPaymentNow; String get paymentMethod; String get paymentAmount; String? get referenceNo; List<ExpenseCategoryModel> get categories; List<SupplierModel> get suppliers; String? get activePaymentShiftId; bool get isCheckingPaymentShift; Map<String, String> get errors;
/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseFormStateCopyWith<ExpenseFormState> get copyWith => _$ExpenseFormStateCopyWithImpl<ExpenseFormState>(this as ExpenseFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExpenseFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseFormState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.expenseId, _this.expenseId) || other.expenseId == _this.expenseId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.expenseDate, _this.expenseDate) || other.expenseDate == _this.expenseDate)&&(identical(other.recordPaymentNow, _this.recordPaymentNow) || other.recordPaymentNow == _this.recordPaymentNow)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.paymentAmount, _this.paymentAmount) || other.paymentAmount == _this.paymentAmount)&&(identical(other.referenceNo, _this.referenceNo) || other.referenceNo == _this.referenceNo)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.suppliers, _this.suppliers)&&(identical(other.activePaymentShiftId, _this.activePaymentShiftId) || other.activePaymentShiftId == _this.activePaymentShiftId)&&(identical(other.isCheckingPaymentShift, _this.isCheckingPaymentShift) || other.isCheckingPaymentShift == _this.isCheckingPaymentShift)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as ExpenseFormState;
  return Object.hashAll([runtimeType,_this.isLoading,_this.isSaving,_this.expenseId,_this.branchId,_this.categoryId,_this.supplierId,_this.amount,_this.taxAmount,_this.description,_this.expenseDate,_this.recordPaymentNow,_this.paymentMethod,_this.paymentAmount,_this.referenceNo,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.suppliers),_this.activePaymentShiftId,_this.isCheckingPaymentShift,const DeepCollectionEquality().hash(_this.errors)]);
}

@override
String toString() {
  final _this = this as ExpenseFormState;
  return 'ExpenseFormState(isLoading: ${_this.isLoading}, isSaving: ${_this.isSaving}, expenseId: ${_this.expenseId}, branchId: ${_this.branchId}, categoryId: ${_this.categoryId}, supplierId: ${_this.supplierId}, amount: ${_this.amount}, taxAmount: ${_this.taxAmount}, description: ${_this.description}, expenseDate: ${_this.expenseDate}, recordPaymentNow: ${_this.recordPaymentNow}, paymentMethod: ${_this.paymentMethod}, paymentAmount: ${_this.paymentAmount}, referenceNo: ${_this.referenceNo}, categories: ${_this.categories}, suppliers: ${_this.suppliers}, activePaymentShiftId: ${_this.activePaymentShiftId}, isCheckingPaymentShift: ${_this.isCheckingPaymentShift}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ExpenseFormStateCopyWith<$Res>  {
  factory $ExpenseFormStateCopyWith(ExpenseFormState value, $Res Function(ExpenseFormState) _then) = _$ExpenseFormStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSaving, String? expenseId, String? branchId, String? categoryId, String? supplierId, String amount, String taxAmount, String description, DateTime? expenseDate, bool recordPaymentNow, String paymentMethod, String paymentAmount, String? referenceNo, List<ExpenseCategoryModel> categories, List<SupplierModel> suppliers, String? activePaymentShiftId, bool isCheckingPaymentShift, Map<String, String> errors
});




}
/// @nodoc
class _$ExpenseFormStateCopyWithImpl<$Res>
    implements $ExpenseFormStateCopyWith<$Res> {
  _$ExpenseFormStateCopyWithImpl(this._self, this._then);

  final ExpenseFormState _self;
  final $Res Function(ExpenseFormState) _then;

/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSaving = null,Object? expenseId = freezed,Object? branchId = freezed,Object? categoryId = freezed,Object? supplierId = freezed,Object? amount = null,Object? taxAmount = null,Object? description = null,Object? expenseDate = freezed,Object? recordPaymentNow = null,Object? paymentMethod = null,Object? paymentAmount = null,Object? referenceNo = freezed,Object? categories = null,Object? suppliers = null,Object? activePaymentShiftId = freezed,Object? isCheckingPaymentShift = null,Object? errors = null,}) {
  return _then(ExpenseFormState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,expenseDate: freezed == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,recordPaymentNow: null == recordPaymentNow ? _self.recordPaymentNow : recordPaymentNow // ignore: cast_nullable_to_non_nullable
as bool,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentAmount: null == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,suppliers: null == suppliers ? _self.suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,activePaymentShiftId: freezed == activePaymentShiftId ? _self.activePaymentShiftId : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
as String?,isCheckingPaymentShift: null == isCheckingPaymentShift ? _self.isCheckingPaymentShift : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseFormState].
extension ExpenseFormStatePatterns on ExpenseFormState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseFormState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseFormState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  String? expenseId,  String? branchId,  String? categoryId,  String? supplierId,  String amount,  String taxAmount,  String description,  DateTime? expenseDate,  bool recordPaymentNow,  String paymentMethod,  String paymentAmount,  String? referenceNo,  List<ExpenseCategoryModel> categories,  List<SupplierModel> suppliers,  String? activePaymentShiftId,  bool isCheckingPaymentShift,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.expenseId,_that.branchId,_that.categoryId,_that.supplierId,_that.amount,_that.taxAmount,_that.description,_that.expenseDate,_that.recordPaymentNow,_that.paymentMethod,_that.paymentAmount,_that.referenceNo,_that.categories,_that.suppliers,_that.activePaymentShiftId,_that.isCheckingPaymentShift,_that.errors);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  String? expenseId,  String? branchId,  String? categoryId,  String? supplierId,  String amount,  String taxAmount,  String description,  DateTime? expenseDate,  bool recordPaymentNow,  String paymentMethod,  String paymentAmount,  String? referenceNo,  List<ExpenseCategoryModel> categories,  List<SupplierModel> suppliers,  String? activePaymentShiftId,  bool isCheckingPaymentShift,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _ExpenseFormState():
return $default(_that.isLoading,_that.isSaving,_that.expenseId,_that.branchId,_that.categoryId,_that.supplierId,_that.amount,_that.taxAmount,_that.description,_that.expenseDate,_that.recordPaymentNow,_that.paymentMethod,_that.paymentAmount,_that.referenceNo,_that.categories,_that.suppliers,_that.activePaymentShiftId,_that.isCheckingPaymentShift,_that.errors);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSaving,  String? expenseId,  String? branchId,  String? categoryId,  String? supplierId,  String amount,  String taxAmount,  String description,  DateTime? expenseDate,  bool recordPaymentNow,  String paymentMethod,  String paymentAmount,  String? referenceNo,  List<ExpenseCategoryModel> categories,  List<SupplierModel> suppliers,  String? activePaymentShiftId,  bool isCheckingPaymentShift,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.expenseId,_that.branchId,_that.categoryId,_that.supplierId,_that.amount,_that.taxAmount,_that.description,_that.expenseDate,_that.recordPaymentNow,_that.paymentMethod,_that.paymentAmount,_that.referenceNo,_that.categories,_that.suppliers,_that.activePaymentShiftId,_that.isCheckingPaymentShift,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseFormState implements ExpenseFormState {
  const _ExpenseFormState({this.isLoading = false, this.isSaving = false, this.expenseId, this.branchId, this.categoryId, this.supplierId, this.amount = '', this.taxAmount = '0', this.description = '', this.expenseDate, this.recordPaymentNow = false, this.paymentMethod = 'cash', this.paymentAmount = '', this.referenceNo,  List<ExpenseCategoryModel> categories = const [],  List<SupplierModel> suppliers = const [], this.activePaymentShiftId, this.isCheckingPaymentShift = false,  Map<String, String> errors = const {}}): _categories = categories,_suppliers = suppliers,_errors = errors;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSaving;
@override final  String? expenseId;
@override final  String? branchId;
@override final  String? categoryId;
@override final  String? supplierId;
@override@JsonKey() final  String amount;
@override@JsonKey() final  String taxAmount;
@override@JsonKey() final  String description;
@override final  DateTime? expenseDate;
@override@JsonKey() final  bool recordPaymentNow;
@override@JsonKey() final  String paymentMethod;
@override@JsonKey() final  String paymentAmount;
@override final  String? referenceNo;
 final  List<ExpenseCategoryModel> _categories;
@override@JsonKey() List<ExpenseCategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<SupplierModel> _suppliers;
@override@JsonKey() List<SupplierModel> get suppliers {
  if (_suppliers is EqualUnmodifiableListView) return _suppliers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suppliers);
}

@override final  String? activePaymentShiftId;
@override@JsonKey() final  bool isCheckingPaymentShift;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseFormStateCopyWith<_ExpenseFormState> get copyWith => __$ExpenseFormStateCopyWithImpl<_ExpenseFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseFormState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.expenseDate, expenseDate) || other.expenseDate == expenseDate)&&(identical(other.recordPaymentNow, recordPaymentNow) || other.recordPaymentNow == recordPaymentNow)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.suppliers, _suppliers)&&(identical(other.activePaymentShiftId, activePaymentShiftId) || other.activePaymentShiftId == activePaymentShiftId)&&(identical(other.isCheckingPaymentShift, isCheckingPaymentShift) || other.isCheckingPaymentShift == isCheckingPaymentShift)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,isLoading,isSaving,expenseId,branchId,categoryId,supplierId,amount,taxAmount,description,expenseDate,recordPaymentNow,paymentMethod,paymentAmount,referenceNo,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_suppliers),activePaymentShiftId,isCheckingPaymentShift,const DeepCollectionEquality().hash(_errors)]);
}

@override
String toString() {
    return 'ExpenseFormState(isLoading: $isLoading, isSaving: $isSaving, expenseId: $expenseId, branchId: $branchId, categoryId: $categoryId, supplierId: $supplierId, amount: $amount, taxAmount: $taxAmount, description: $description, expenseDate: $expenseDate, recordPaymentNow: $recordPaymentNow, paymentMethod: $paymentMethod, paymentAmount: $paymentAmount, referenceNo: $referenceNo, categories: $categories, suppliers: $suppliers, activePaymentShiftId: $activePaymentShiftId, isCheckingPaymentShift: $isCheckingPaymentShift, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ExpenseFormStateCopyWith<$Res> implements $ExpenseFormStateCopyWith<$Res> {
  factory _$ExpenseFormStateCopyWith(_ExpenseFormState value, $Res Function(_ExpenseFormState) _then) = __$ExpenseFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSaving, String? expenseId, String? branchId, String? categoryId, String? supplierId, String amount, String taxAmount, String description, DateTime? expenseDate, bool recordPaymentNow, String paymentMethod, String paymentAmount, String? referenceNo, List<ExpenseCategoryModel> categories, List<SupplierModel> suppliers, String? activePaymentShiftId, bool isCheckingPaymentShift, Map<String, String> errors
});




}
/// @nodoc
class __$ExpenseFormStateCopyWithImpl<$Res>
    implements _$ExpenseFormStateCopyWith<$Res> {
  __$ExpenseFormStateCopyWithImpl(this._self, this._then);

  final _ExpenseFormState _self;
  final $Res Function(_ExpenseFormState) _then;

/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSaving = null,Object? expenseId = freezed,Object? branchId = freezed,Object? categoryId = freezed,Object? supplierId = freezed,Object? amount = null,Object? taxAmount = null,Object? description = null,Object? expenseDate = freezed,Object? recordPaymentNow = null,Object? paymentMethod = null,Object? paymentAmount = null,Object? referenceNo = freezed,Object? categories = null,Object? suppliers = null,Object? activePaymentShiftId = freezed,Object? isCheckingPaymentShift = null,Object? errors = null,}) {
  return _then(_ExpenseFormState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,expenseDate: freezed == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,recordPaymentNow: null == recordPaymentNow ? _self.recordPaymentNow : recordPaymentNow // ignore: cast_nullable_to_non_nullable
as bool,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentAmount: null == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as String,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,suppliers: null == suppliers ? _self._suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,activePaymentShiftId: freezed == activePaymentShiftId ? _self.activePaymentShiftId : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
as String?,isCheckingPaymentShift: null == isCheckingPaymentShift ? _self.isCheckingPaymentShift : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
