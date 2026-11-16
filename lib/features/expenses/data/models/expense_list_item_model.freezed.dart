// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseListItemModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'expense_category_id') String get expenseCategoryId;@JsonKey(name: 'supplier_id') String? get supplierId;@JsonKey(name: 'expense_number') String get expenseNumber; String? get description;@JsonKey(name: 'expense_date') String get expenseDate; String get amount;@JsonKey(name: 'tax_amount') String get taxAmount;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of ExpenseListItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseListItemModelCopyWith<ExpenseListItemModel> get copyWith => _$ExpenseListItemModelCopyWithImpl<ExpenseListItemModel>(this as ExpenseListItemModel, _$identity);

  /// Serializes this ExpenseListItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpenseListItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseListItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.expenseCategoryId, _this.expenseCategoryId) || other.expenseCategoryId == _this.expenseCategoryId)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.expenseNumber, _this.expenseNumber) || other.expenseNumber == _this.expenseNumber)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.expenseDate, _this.expenseDate) || other.expenseDate == _this.expenseDate)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.taxAmount, _this.taxAmount) || other.taxAmount == _this.taxAmount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpenseListItemModel;
  return Object.hash(runtimeType,_this.id,_this.branchId,_this.expenseCategoryId,_this.supplierId,_this.expenseNumber,_this.description,_this.expenseDate,_this.amount,_this.taxAmount,_this.createdAt);
}

@override
String toString() {
  final _this = this as ExpenseListItemModel;
  return 'ExpenseListItemModel(id: ${_this.id}, branchId: ${_this.branchId}, expenseCategoryId: ${_this.expenseCategoryId}, supplierId: ${_this.supplierId}, expenseNumber: ${_this.expenseNumber}, description: ${_this.description}, expenseDate: ${_this.expenseDate}, amount: ${_this.amount}, taxAmount: ${_this.taxAmount}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ExpenseListItemModelCopyWith<$Res>  {
  factory $ExpenseListItemModelCopyWith(ExpenseListItemModel value, $Res Function(ExpenseListItemModel) _then) = _$ExpenseListItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'expense_category_id') String expenseCategoryId,@JsonKey(name: 'supplier_id') String? supplierId,@JsonKey(name: 'expense_number') String expenseNumber, String? description,@JsonKey(name: 'expense_date') String expenseDate, String amount,@JsonKey(name: 'tax_amount') String taxAmount,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$ExpenseListItemModelCopyWithImpl<$Res>
    implements $ExpenseListItemModelCopyWith<$Res> {
  _$ExpenseListItemModelCopyWithImpl(this._self, this._then);

  final ExpenseListItemModel _self;
  final $Res Function(ExpenseListItemModel) _then;

/// Create a copy of ExpenseListItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? expenseCategoryId = null,Object? supplierId = freezed,Object? expenseNumber = null,Object? description = freezed,Object? expenseDate = null,Object? amount = null,Object? taxAmount = null,Object? createdAt = freezed,}) {
  return _then(ExpenseListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,expenseCategoryId: null == expenseCategoryId ? _self.expenseCategoryId : expenseCategoryId // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,expenseNumber: null == expenseNumber ? _self.expenseNumber : expenseNumber // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseListItemModel].
extension ExpenseListItemModelPatterns on ExpenseListItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseListItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseListItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseListItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseListItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseListItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseListItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'expense_category_id')  String expenseCategoryId, @JsonKey(name: 'supplier_id')  String? supplierId, @JsonKey(name: 'expense_number')  String expenseNumber,  String? description, @JsonKey(name: 'expense_date')  String expenseDate,  String amount, @JsonKey(name: 'tax_amount')  String taxAmount, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseListItemModel() when $default != null:
return $default(_that.id,_that.branchId,_that.expenseCategoryId,_that.supplierId,_that.expenseNumber,_that.description,_that.expenseDate,_that.amount,_that.taxAmount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'expense_category_id')  String expenseCategoryId, @JsonKey(name: 'supplier_id')  String? supplierId, @JsonKey(name: 'expense_number')  String expenseNumber,  String? description, @JsonKey(name: 'expense_date')  String expenseDate,  String amount, @JsonKey(name: 'tax_amount')  String taxAmount, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExpenseListItemModel():
return $default(_that.id,_that.branchId,_that.expenseCategoryId,_that.supplierId,_that.expenseNumber,_that.description,_that.expenseDate,_that.amount,_that.taxAmount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'expense_category_id')  String expenseCategoryId, @JsonKey(name: 'supplier_id')  String? supplierId, @JsonKey(name: 'expense_number')  String expenseNumber,  String? description, @JsonKey(name: 'expense_date')  String expenseDate,  String amount, @JsonKey(name: 'tax_amount')  String taxAmount, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseListItemModel() when $default != null:
return $default(_that.id,_that.branchId,_that.expenseCategoryId,_that.supplierId,_that.expenseNumber,_that.description,_that.expenseDate,_that.amount,_that.taxAmount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseListItemModel implements ExpenseListItemModel {
  const _ExpenseListItemModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'expense_category_id') required this.expenseCategoryId, @JsonKey(name: 'supplier_id') this.supplierId, @JsonKey(name: 'expense_number') required this.expenseNumber, this.description, @JsonKey(name: 'expense_date') required this.expenseDate, required this.amount, @JsonKey(name: 'tax_amount') this.taxAmount = '0', @JsonKey(name: 'created_at') this.createdAt});
  factory _ExpenseListItemModel.fromJson(Map<String, dynamic> json) => _$ExpenseListItemModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'expense_category_id') final  String expenseCategoryId;
@override@JsonKey(name: 'supplier_id') final  String? supplierId;
@override@JsonKey(name: 'expense_number') final  String expenseNumber;
@override final  String? description;
@override@JsonKey(name: 'expense_date') final  String expenseDate;
@override final  String amount;
@override@JsonKey(name: 'tax_amount') final  String taxAmount;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of ExpenseListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseListItemModelCopyWith<_ExpenseListItemModel> get copyWith => __$ExpenseListItemModelCopyWithImpl<_ExpenseListItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseListItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.expenseCategoryId, expenseCategoryId) || other.expenseCategoryId == expenseCategoryId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.expenseNumber, expenseNumber) || other.expenseNumber == expenseNumber)&&(identical(other.description, description) || other.description == description)&&(identical(other.expenseDate, expenseDate) || other.expenseDate == expenseDate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,branchId,expenseCategoryId,supplierId,expenseNumber,description,expenseDate,amount,taxAmount,createdAt);
}

@override
String toString() {
    return 'ExpenseListItemModel(id: $id, branchId: $branchId, expenseCategoryId: $expenseCategoryId, supplierId: $supplierId, expenseNumber: $expenseNumber, description: $description, expenseDate: $expenseDate, amount: $amount, taxAmount: $taxAmount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseListItemModelCopyWith<$Res> implements $ExpenseListItemModelCopyWith<$Res> {
  factory _$ExpenseListItemModelCopyWith(_ExpenseListItemModel value, $Res Function(_ExpenseListItemModel) _then) = __$ExpenseListItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'expense_category_id') String expenseCategoryId,@JsonKey(name: 'supplier_id') String? supplierId,@JsonKey(name: 'expense_number') String expenseNumber, String? description,@JsonKey(name: 'expense_date') String expenseDate, String amount,@JsonKey(name: 'tax_amount') String taxAmount,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$ExpenseListItemModelCopyWithImpl<$Res>
    implements _$ExpenseListItemModelCopyWith<$Res> {
  __$ExpenseListItemModelCopyWithImpl(this._self, this._then);

  final _ExpenseListItemModel _self;
  final $Res Function(_ExpenseListItemModel) _then;

/// Create a copy of ExpenseListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? expenseCategoryId = null,Object? supplierId = freezed,Object? expenseNumber = null,Object? description = freezed,Object? expenseDate = null,Object? amount = null,Object? taxAmount = null,Object? createdAt = freezed,}) {
  return _then(_ExpenseListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,expenseCategoryId: null == expenseCategoryId ? _self.expenseCategoryId : expenseCategoryId // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,expenseNumber: null == expenseNumber ? _self.expenseNumber : expenseNumber // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
