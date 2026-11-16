// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'expense_category_id') String get expenseCategoryId;@JsonKey(name: 'supplier_id') String? get supplierId;@JsonKey(name: 'expense_number') String get expenseNumber; String? get description;@JsonKey(name: 'expense_date') String get expenseDate; String get amount;@JsonKey(name: 'tax_amount') String get taxAmount; List<ExpensePaymentModel> get payments;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseModelCopyWith<ExpenseModel> get copyWith => _$ExpenseModelCopyWithImpl<ExpenseModel>(this as ExpenseModel, _$identity);

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpenseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.expenseCategoryId, _this.expenseCategoryId) || other.expenseCategoryId == _this.expenseCategoryId)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.expenseNumber, _this.expenseNumber) || other.expenseNumber == _this.expenseNumber)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.expenseDate, _this.expenseDate) || other.expenseDate == _this.expenseDate)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpenseModel;
  return Object.hash(runtimeType,_this.id,_this.branchId,_this.expenseCategoryId,_this.supplierId,_this.expenseNumber,_this.description,_this.expenseDate,_this.amount,_this.taxAmount,const DeepCollectionEquality().hash(_this.payments),_this.createdAt);
}

@override
String toString() {
  final _this = this as ExpenseModel;
  return 'ExpenseModel(id: ${_this.id}, branchId: ${_this.branchId}, expenseCategoryId: ${_this.expenseCategoryId}, supplierId: ${_this.supplierId}, expenseNumber: ${_this.expenseNumber}, description: ${_this.description}, expenseDate: ${_this.expenseDate}, amount: ${_this.amount}, taxAmount: ${_this.taxAmount}, payments: ${_this.payments}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ExpenseModelCopyWith<$Res>  {
  factory $ExpenseModelCopyWith(ExpenseModel value, $Res Function(ExpenseModel) _then) = _$ExpenseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'expense_category_id') String expenseCategoryId,@JsonKey(name: 'supplier_id') String? supplierId,@JsonKey(name: 'expense_number') String expenseNumber, String? description,@JsonKey(name: 'expense_date') String expenseDate, String amount,@JsonKey(name: 'tax_amount') String taxAmount, List<ExpensePaymentModel> payments,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._self, this._then);

  final ExpenseModel _self;
  final $Res Function(ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? expenseCategoryId = null,Object? supplierId = freezed,Object? expenseNumber = null,Object? description = freezed,Object? expenseDate = null,Object? amount = null,Object? taxAmount = null,Object? payments = null,Object? createdAt = freezed,}) {
  return _then(ExpenseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,expenseCategoryId: null == expenseCategoryId ? _self.expenseCategoryId : expenseCategoryId // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,expenseNumber: null == expenseNumber ? _self.expenseNumber : expenseNumber // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<ExpensePaymentModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseModel].
extension ExpenseModelPatterns on ExpenseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'expense_category_id')  String expenseCategoryId, @JsonKey(name: 'supplier_id')  String? supplierId, @JsonKey(name: 'expense_number')  String expenseNumber,  String? description, @JsonKey(name: 'expense_date')  String expenseDate,  String amount, @JsonKey(name: 'tax_amount')  String taxAmount,  List<ExpensePaymentModel> payments, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.id,_that.branchId,_that.expenseCategoryId,_that.supplierId,_that.expenseNumber,_that.description,_that.expenseDate,_that.amount,_that.taxAmount,_that.payments,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'expense_category_id')  String expenseCategoryId, @JsonKey(name: 'supplier_id')  String? supplierId, @JsonKey(name: 'expense_number')  String expenseNumber,  String? description, @JsonKey(name: 'expense_date')  String expenseDate,  String amount, @JsonKey(name: 'tax_amount')  String taxAmount,  List<ExpensePaymentModel> payments, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel():
return $default(_that.id,_that.branchId,_that.expenseCategoryId,_that.supplierId,_that.expenseNumber,_that.description,_that.expenseDate,_that.amount,_that.taxAmount,_that.payments,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'expense_category_id')  String expenseCategoryId, @JsonKey(name: 'supplier_id')  String? supplierId, @JsonKey(name: 'expense_number')  String expenseNumber,  String? description, @JsonKey(name: 'expense_date')  String expenseDate,  String amount, @JsonKey(name: 'tax_amount')  String taxAmount,  List<ExpensePaymentModel> payments, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.id,_that.branchId,_that.expenseCategoryId,_that.supplierId,_that.expenseNumber,_that.description,_that.expenseDate,_that.amount,_that.taxAmount,_that.payments,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseModel implements ExpenseModel {
  const _ExpenseModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'expense_category_id') required this.expenseCategoryId, @JsonKey(name: 'supplier_id') this.supplierId, @JsonKey(name: 'expense_number') required this.expenseNumber, this.description, @JsonKey(name: 'expense_date') required this.expenseDate, required this.amount, @JsonKey(name: 'tax_amount') this.taxAmount = '0',  List<ExpensePaymentModel> payments = const [], @JsonKey(name: 'created_at') this.createdAt}): _payments = payments;
  factory _ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'expense_category_id') final  String expenseCategoryId;
@override@JsonKey(name: 'supplier_id') final  String? supplierId;
@override@JsonKey(name: 'expense_number') final  String expenseNumber;
@override final  String? description;
@override@JsonKey(name: 'expense_date') final  String expenseDate;
@override final  String amount;
@override@JsonKey(name: 'tax_amount') final  String taxAmount;
 final  List<ExpensePaymentModel> _payments;
@override@JsonKey() List<ExpensePaymentModel> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseModelCopyWith<_ExpenseModel> get copyWith => __$ExpenseModelCopyWithImpl<_ExpenseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.expenseCategoryId, expenseCategoryId) || other.expenseCategoryId == expenseCategoryId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.expenseNumber, expenseNumber) || other.expenseNumber == expenseNumber)&&(identical(other.description, description) || other.description == description)&&(identical(other.expenseDate, expenseDate) || other.expenseDate == expenseDate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&const DeepCollectionEquality().equals(other.payments, _payments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,branchId,expenseCategoryId,supplierId,expenseNumber,description,expenseDate,amount,taxAmount,const DeepCollectionEquality().hash(_payments),createdAt);
}

@override
String toString() {
    return 'ExpenseModel(id: $id, branchId: $branchId, expenseCategoryId: $expenseCategoryId, supplierId: $supplierId, expenseNumber: $expenseNumber, description: $description, expenseDate: $expenseDate, amount: $amount, taxAmount: $taxAmount, payments: $payments, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseModelCopyWith<$Res> implements $ExpenseModelCopyWith<$Res> {
  factory _$ExpenseModelCopyWith(_ExpenseModel value, $Res Function(_ExpenseModel) _then) = __$ExpenseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'expense_category_id') String expenseCategoryId,@JsonKey(name: 'supplier_id') String? supplierId,@JsonKey(name: 'expense_number') String expenseNumber, String? description,@JsonKey(name: 'expense_date') String expenseDate, String amount,@JsonKey(name: 'tax_amount') String taxAmount, List<ExpensePaymentModel> payments,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$ExpenseModelCopyWithImpl<$Res>
    implements _$ExpenseModelCopyWith<$Res> {
  __$ExpenseModelCopyWithImpl(this._self, this._then);

  final _ExpenseModel _self;
  final $Res Function(_ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? expenseCategoryId = null,Object? supplierId = freezed,Object? expenseNumber = null,Object? description = freezed,Object? expenseDate = null,Object? amount = null,Object? taxAmount = null,Object? payments = null,Object? createdAt = freezed,}) {
  return _then(_ExpenseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,expenseCategoryId: null == expenseCategoryId ? _self.expenseCategoryId : expenseCategoryId // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,expenseNumber: null == expenseNumber ? _self.expenseNumber : expenseNumber // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<ExpensePaymentModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
