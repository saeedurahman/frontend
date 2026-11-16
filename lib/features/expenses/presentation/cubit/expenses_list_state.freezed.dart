// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpensesListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpensesListState()';
}


}

/// @nodoc
class $ExpensesListStateCopyWith<$Res>  {
$ExpensesListStateCopyWith(ExpensesListState _, $Res Function(ExpensesListState) __);
}


/// Adds pattern-matching-related methods to [ExpensesListState].
extension ExpensesListStatePatterns on ExpensesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExpensesListInitial value)?  initial,TResult Function( ExpensesListLoading value)?  loading,TResult Function( ExpensesListLoaded value)?  loaded,TResult Function( ExpensesListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExpensesListInitial() when initial != null:
return initial(_that);case ExpensesListLoading() when loading != null:
return loading(_that);case ExpensesListLoaded() when loaded != null:
return loaded(_that);case ExpensesListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExpensesListInitial value)  initial,required TResult Function( ExpensesListLoading value)  loading,required TResult Function( ExpensesListLoaded value)  loaded,required TResult Function( ExpensesListError value)  error,}){
final _that = this;
switch (_that) {
case ExpensesListInitial():
return initial(_that);case ExpensesListLoading():
return loading(_that);case ExpensesListLoaded():
return loaded(_that);case ExpensesListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExpensesListInitial value)?  initial,TResult? Function( ExpensesListLoading value)?  loading,TResult? Function( ExpensesListLoaded value)?  loaded,TResult? Function( ExpensesListError value)?  error,}){
final _that = this;
switch (_that) {
case ExpensesListInitial() when initial != null:
return initial(_that);case ExpensesListLoading() when loading != null:
return loading(_that);case ExpensesListLoaded() when loaded != null:
return loaded(_that);case ExpensesListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ExpenseListItemModel> items,  int total,  int skip,  int limit,  List<ExpenseCategoryModel> categories,  List<SupplierModel> suppliers,  String? categoryIdFilter,  String? supplierIdFilter,  String? branchIdFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool isLoadingMore,  bool hasActiveFilters)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExpensesListInitial() when initial != null:
return initial();case ExpensesListLoading() when loading != null:
return loading();case ExpensesListLoaded() when loaded != null:
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.categories,_that.suppliers,_that.categoryIdFilter,_that.supplierIdFilter,_that.branchIdFilter,_that.dateFrom,_that.dateTo,_that.isLoadingMore,_that.hasActiveFilters);case ExpensesListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ExpenseListItemModel> items,  int total,  int skip,  int limit,  List<ExpenseCategoryModel> categories,  List<SupplierModel> suppliers,  String? categoryIdFilter,  String? supplierIdFilter,  String? branchIdFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool isLoadingMore,  bool hasActiveFilters)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ExpensesListInitial():
return initial();case ExpensesListLoading():
return loading();case ExpensesListLoaded():
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.categories,_that.suppliers,_that.categoryIdFilter,_that.supplierIdFilter,_that.branchIdFilter,_that.dateFrom,_that.dateTo,_that.isLoadingMore,_that.hasActiveFilters);case ExpensesListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ExpenseListItemModel> items,  int total,  int skip,  int limit,  List<ExpenseCategoryModel> categories,  List<SupplierModel> suppliers,  String? categoryIdFilter,  String? supplierIdFilter,  String? branchIdFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool isLoadingMore,  bool hasActiveFilters)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ExpensesListInitial() when initial != null:
return initial();case ExpensesListLoading() when loading != null:
return loading();case ExpensesListLoaded() when loaded != null:
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.categories,_that.suppliers,_that.categoryIdFilter,_that.supplierIdFilter,_that.branchIdFilter,_that.dateFrom,_that.dateTo,_that.isLoadingMore,_that.hasActiveFilters);case ExpensesListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ExpensesListInitial implements ExpensesListState {
  const ExpensesListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpensesListState.initial()';
}


}




/// @nodoc


class ExpensesListLoading implements ExpensesListState {
  const ExpensesListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpensesListState.loading()';
}


}




/// @nodoc


class ExpensesListLoaded implements ExpensesListState {
  const ExpensesListLoaded({required  List<ExpenseListItemModel> items, required this.total, required this.skip, required this.limit, required  List<ExpenseCategoryModel> categories, required  List<SupplierModel> suppliers, this.categoryIdFilter, this.supplierIdFilter, this.branchIdFilter, this.dateFrom, this.dateTo, this.isLoadingMore = false, this.hasActiveFilters = false}): _items = items,_categories = categories,_suppliers = suppliers;
  

 final  List<ExpenseListItemModel> _items;
 List<ExpenseListItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int total;
 final  int skip;
 final  int limit;
 final  List<ExpenseCategoryModel> _categories;
 List<ExpenseCategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<SupplierModel> _suppliers;
 List<SupplierModel> get suppliers {
  if (_suppliers is EqualUnmodifiableListView) return _suppliers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suppliers);
}

 final  String? categoryIdFilter;
 final  String? supplierIdFilter;
 final  String? branchIdFilter;
 final  DateTime? dateFrom;
 final  DateTime? dateTo;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool hasActiveFilters;

/// Create a copy of ExpensesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensesListLoadedCopyWith<ExpensesListLoaded> get copyWith => _$ExpensesListLoadedCopyWithImpl<ExpensesListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesListLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.suppliers, _suppliers)&&(identical(other.categoryIdFilter, categoryIdFilter) || other.categoryIdFilter == categoryIdFilter)&&(identical(other.supplierIdFilter, supplierIdFilter) || other.supplierIdFilter == supplierIdFilter)&&(identical(other.branchIdFilter, branchIdFilter) || other.branchIdFilter == branchIdFilter)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasActiveFilters, hasActiveFilters) || other.hasActiveFilters == hasActiveFilters));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,skip,limit,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_suppliers),categoryIdFilter,supplierIdFilter,branchIdFilter,dateFrom,dateTo,isLoadingMore,hasActiveFilters);
}

@override
String toString() {
    return 'ExpensesListState.loaded(items: $items, total: $total, skip: $skip, limit: $limit, categories: $categories, suppliers: $suppliers, categoryIdFilter: $categoryIdFilter, supplierIdFilter: $supplierIdFilter, branchIdFilter: $branchIdFilter, dateFrom: $dateFrom, dateTo: $dateTo, isLoadingMore: $isLoadingMore, hasActiveFilters: $hasActiveFilters)';
}


}

/// @nodoc
abstract mixin class $ExpensesListLoadedCopyWith<$Res> implements $ExpensesListStateCopyWith<$Res> {
  factory $ExpensesListLoadedCopyWith(ExpensesListLoaded value, $Res Function(ExpensesListLoaded) _then) = _$ExpensesListLoadedCopyWithImpl;
@useResult
$Res call({
 List<ExpenseListItemModel> items, int total, int skip, int limit, List<ExpenseCategoryModel> categories, List<SupplierModel> suppliers, String? categoryIdFilter, String? supplierIdFilter, String? branchIdFilter, DateTime? dateFrom, DateTime? dateTo, bool isLoadingMore, bool hasActiveFilters
});




}
/// @nodoc
class _$ExpensesListLoadedCopyWithImpl<$Res>
    implements $ExpensesListLoadedCopyWith<$Res> {
  _$ExpensesListLoadedCopyWithImpl(this._self, this._then);

  final ExpensesListLoaded _self;
  final $Res Function(ExpensesListLoaded) _then;

/// Create a copy of ExpensesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? skip = null,Object? limit = null,Object? categories = null,Object? suppliers = null,Object? categoryIdFilter = freezed,Object? supplierIdFilter = freezed,Object? branchIdFilter = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? isLoadingMore = null,Object? hasActiveFilters = null,}) {
  return _then(ExpensesListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExpenseListItemModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,suppliers: null == suppliers ? _self._suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,categoryIdFilter: freezed == categoryIdFilter ? _self.categoryIdFilter : categoryIdFilter // ignore: cast_nullable_to_non_nullable
as String?,supplierIdFilter: freezed == supplierIdFilter ? _self.supplierIdFilter : supplierIdFilter // ignore: cast_nullable_to_non_nullable
as String?,branchIdFilter: freezed == branchIdFilter ? _self.branchIdFilter : branchIdFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasActiveFilters: null == hasActiveFilters ? _self.hasActiveFilters : hasActiveFilters // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ExpensesListError implements ExpensesListState {
  const ExpensesListError(this.message);
  

 final  String message;

/// Create a copy of ExpensesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensesListErrorCopyWith<ExpensesListError> get copyWith => _$ExpensesListErrorCopyWithImpl<ExpensesListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ExpensesListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ExpensesListErrorCopyWith<$Res> implements $ExpensesListStateCopyWith<$Res> {
  factory $ExpensesListErrorCopyWith(ExpensesListError value, $Res Function(ExpensesListError) _then) = _$ExpensesListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ExpensesListErrorCopyWithImpl<$Res>
    implements $ExpensesListErrorCopyWith<$Res> {
  _$ExpensesListErrorCopyWithImpl(this._self, this._then);

  final ExpensesListError _self;
  final $Res Function(ExpensesListError) _then;

/// Create a copy of ExpensesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ExpensesListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
