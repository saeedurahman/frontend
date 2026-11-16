// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpenseDetailState()';
}


}

/// @nodoc
class $ExpenseDetailStateCopyWith<$Res>  {
$ExpenseDetailStateCopyWith(ExpenseDetailState _, $Res Function(ExpenseDetailState) __);
}


/// Adds pattern-matching-related methods to [ExpenseDetailState].
extension ExpenseDetailStatePatterns on ExpenseDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExpenseDetailInitial value)?  initial,TResult Function( ExpenseDetailLoading value)?  loading,TResult Function( ExpenseDetailLoaded value)?  loaded,TResult Function( ExpenseDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExpenseDetailInitial() when initial != null:
return initial(_that);case ExpenseDetailLoading() when loading != null:
return loading(_that);case ExpenseDetailLoaded() when loaded != null:
return loaded(_that);case ExpenseDetailError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExpenseDetailInitial value)  initial,required TResult Function( ExpenseDetailLoading value)  loading,required TResult Function( ExpenseDetailLoaded value)  loaded,required TResult Function( ExpenseDetailError value)  error,}){
final _that = this;
switch (_that) {
case ExpenseDetailInitial():
return initial(_that);case ExpenseDetailLoading():
return loading(_that);case ExpenseDetailLoaded():
return loaded(_that);case ExpenseDetailError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExpenseDetailInitial value)?  initial,TResult? Function( ExpenseDetailLoading value)?  loading,TResult? Function( ExpenseDetailLoaded value)?  loaded,TResult? Function( ExpenseDetailError value)?  error,}){
final _that = this;
switch (_that) {
case ExpenseDetailInitial() when initial != null:
return initial(_that);case ExpenseDetailLoading() when loading != null:
return loading(_that);case ExpenseDetailLoaded() when loaded != null:
return loaded(_that);case ExpenseDetailError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ExpenseModel expense,  List<ExpenseCategoryModel> categories,  SupplierModel? supplier,  String? activePaymentShiftId,  bool isCheckingPaymentShift,  bool isDeleting,  bool isRecordingPayment,  String? paymentError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExpenseDetailInitial() when initial != null:
return initial();case ExpenseDetailLoading() when loading != null:
return loading();case ExpenseDetailLoaded() when loaded != null:
return loaded(_that.expense,_that.categories,_that.supplier,_that.activePaymentShiftId,_that.isCheckingPaymentShift,_that.isDeleting,_that.isRecordingPayment,_that.paymentError);case ExpenseDetailError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ExpenseModel expense,  List<ExpenseCategoryModel> categories,  SupplierModel? supplier,  String? activePaymentShiftId,  bool isCheckingPaymentShift,  bool isDeleting,  bool isRecordingPayment,  String? paymentError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ExpenseDetailInitial():
return initial();case ExpenseDetailLoading():
return loading();case ExpenseDetailLoaded():
return loaded(_that.expense,_that.categories,_that.supplier,_that.activePaymentShiftId,_that.isCheckingPaymentShift,_that.isDeleting,_that.isRecordingPayment,_that.paymentError);case ExpenseDetailError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ExpenseModel expense,  List<ExpenseCategoryModel> categories,  SupplierModel? supplier,  String? activePaymentShiftId,  bool isCheckingPaymentShift,  bool isDeleting,  bool isRecordingPayment,  String? paymentError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ExpenseDetailInitial() when initial != null:
return initial();case ExpenseDetailLoading() when loading != null:
return loading();case ExpenseDetailLoaded() when loaded != null:
return loaded(_that.expense,_that.categories,_that.supplier,_that.activePaymentShiftId,_that.isCheckingPaymentShift,_that.isDeleting,_that.isRecordingPayment,_that.paymentError);case ExpenseDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ExpenseDetailInitial implements ExpenseDetailState {
  const ExpenseDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpenseDetailState.initial()';
}


}




/// @nodoc


class ExpenseDetailLoading implements ExpenseDetailState {
  const ExpenseDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpenseDetailState.loading()';
}


}




/// @nodoc


class ExpenseDetailLoaded implements ExpenseDetailState {
  const ExpenseDetailLoaded({required this.expense, required  List<ExpenseCategoryModel> categories, this.supplier, this.activePaymentShiftId, this.isCheckingPaymentShift = false, this.isDeleting = false, this.isRecordingPayment = false, this.paymentError}): _categories = categories;
  

 final  ExpenseModel expense;
 final  List<ExpenseCategoryModel> _categories;
 List<ExpenseCategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  SupplierModel? supplier;
 final  String? activePaymentShiftId;
@JsonKey() final  bool isCheckingPaymentShift;
@JsonKey() final  bool isDeleting;
@JsonKey() final  bool isRecordingPayment;
 final  String? paymentError;

/// Create a copy of ExpenseDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseDetailLoadedCopyWith<ExpenseDetailLoaded> get copyWith => _$ExpenseDetailLoadedCopyWithImpl<ExpenseDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDetailLoaded&&(identical(other.expense, expense) || other.expense == expense)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.activePaymentShiftId, activePaymentShiftId) || other.activePaymentShiftId == activePaymentShiftId)&&(identical(other.isCheckingPaymentShift, isCheckingPaymentShift) || other.isCheckingPaymentShift == isCheckingPaymentShift)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isRecordingPayment, isRecordingPayment) || other.isRecordingPayment == isRecordingPayment)&&(identical(other.paymentError, paymentError) || other.paymentError == paymentError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,expense,const DeepCollectionEquality().hash(_categories),supplier,activePaymentShiftId,isCheckingPaymentShift,isDeleting,isRecordingPayment,paymentError);
}

@override
String toString() {
    return 'ExpenseDetailState.loaded(expense: $expense, categories: $categories, supplier: $supplier, activePaymentShiftId: $activePaymentShiftId, isCheckingPaymentShift: $isCheckingPaymentShift, isDeleting: $isDeleting, isRecordingPayment: $isRecordingPayment, paymentError: $paymentError)';
}


}

/// @nodoc
abstract mixin class $ExpenseDetailLoadedCopyWith<$Res> implements $ExpenseDetailStateCopyWith<$Res> {
  factory $ExpenseDetailLoadedCopyWith(ExpenseDetailLoaded value, $Res Function(ExpenseDetailLoaded) _then) = _$ExpenseDetailLoadedCopyWithImpl;
@useResult
$Res call({
 ExpenseModel expense, List<ExpenseCategoryModel> categories, SupplierModel? supplier, String? activePaymentShiftId, bool isCheckingPaymentShift, bool isDeleting, bool isRecordingPayment, String? paymentError
});


$ExpenseModelCopyWith<$Res> get expense;$SupplierModelCopyWith<$Res>? get supplier;

}
/// @nodoc
class _$ExpenseDetailLoadedCopyWithImpl<$Res>
    implements $ExpenseDetailLoadedCopyWith<$Res> {
  _$ExpenseDetailLoadedCopyWithImpl(this._self, this._then);

  final ExpenseDetailLoaded _self;
  final $Res Function(ExpenseDetailLoaded) _then;

/// Create a copy of ExpenseDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? expense = null,Object? categories = null,Object? supplier = freezed,Object? activePaymentShiftId = freezed,Object? isCheckingPaymentShift = null,Object? isDeleting = null,Object? isRecordingPayment = null,Object? paymentError = freezed,}) {
  return _then(ExpenseDetailLoaded(
expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as ExpenseModel,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,supplier: freezed == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as SupplierModel?,activePaymentShiftId: freezed == activePaymentShiftId ? _self.activePaymentShiftId : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
as String?,isCheckingPaymentShift: null == isCheckingPaymentShift ? _self.isCheckingPaymentShift : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isRecordingPayment: null == isRecordingPayment ? _self.isRecordingPayment : isRecordingPayment // ignore: cast_nullable_to_non_nullable
as bool,paymentError: freezed == paymentError ? _self.paymentError : paymentError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ExpenseDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpenseModelCopyWith<$Res> get expense {
  
  return $ExpenseModelCopyWith<$Res>(_self.expense, (value) {
    return _then(_self.copyWith(expense: value));
  });
}/// Create a copy of ExpenseDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<$Res>? get supplier {
    if (_self.supplier == null) {
    return null;
  }

  return $SupplierModelCopyWith<$Res>(_self.supplier!, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}

/// @nodoc


class ExpenseDetailError implements ExpenseDetailState {
  const ExpenseDetailError(this.message);
  

 final  String message;

/// Create a copy of ExpenseDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseDetailErrorCopyWith<ExpenseDetailError> get copyWith => _$ExpenseDetailErrorCopyWithImpl<ExpenseDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ExpenseDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ExpenseDetailErrorCopyWith<$Res> implements $ExpenseDetailStateCopyWith<$Res> {
  factory $ExpenseDetailErrorCopyWith(ExpenseDetailError value, $Res Function(ExpenseDetailError) _then) = _$ExpenseDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ExpenseDetailErrorCopyWithImpl<$Res>
    implements $ExpenseDetailErrorCopyWith<$Res> {
  _$ExpenseDetailErrorCopyWithImpl(this._self, this._then);

  final ExpenseDetailError _self;
  final $Res Function(ExpenseDetailError) _then;

/// Create a copy of ExpenseDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ExpenseDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
