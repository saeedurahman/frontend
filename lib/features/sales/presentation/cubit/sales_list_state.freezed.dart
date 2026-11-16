// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SalesListState()';
}


}

/// @nodoc
class $SalesListStateCopyWith<$Res>  {
$SalesListStateCopyWith(SalesListState _, $Res Function(SalesListState) __);
}


/// Adds pattern-matching-related methods to [SalesListState].
extension SalesListStatePatterns on SalesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SalesListInitial value)?  initial,TResult Function( SalesListLoading value)?  loading,TResult Function( SalesListLoaded value)?  loaded,TResult Function( SalesListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SalesListInitial() when initial != null:
return initial(_that);case SalesListLoading() when loading != null:
return loading(_that);case SalesListLoaded() when loaded != null:
return loaded(_that);case SalesListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SalesListInitial value)  initial,required TResult Function( SalesListLoading value)  loading,required TResult Function( SalesListLoaded value)  loaded,required TResult Function( SalesListError value)  error,}){
final _that = this;
switch (_that) {
case SalesListInitial():
return initial(_that);case SalesListLoading():
return loading(_that);case SalesListLoaded():
return loaded(_that);case SalesListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SalesListInitial value)?  initial,TResult? Function( SalesListLoading value)?  loading,TResult? Function( SalesListLoaded value)?  loaded,TResult? Function( SalesListError value)?  error,}){
final _that = this;
switch (_that) {
case SalesListInitial() when initial != null:
return initial(_that);case SalesListLoading() when loading != null:
return loading(_that);case SalesListLoaded() when loaded != null:
return loaded(_that);case SalesListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SaleListItemModel> items,  int total,  int skip,  int limit,  String? statusFilter,  String? branchIdFilter,  String? searchQuery,  DateTime? dateFrom,  DateTime? dateTo,  bool isLoadingMore,  bool hasActiveFilters)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SalesListInitial() when initial != null:
return initial();case SalesListLoading() when loading != null:
return loading();case SalesListLoaded() when loaded != null:
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.statusFilter,_that.branchIdFilter,_that.searchQuery,_that.dateFrom,_that.dateTo,_that.isLoadingMore,_that.hasActiveFilters);case SalesListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SaleListItemModel> items,  int total,  int skip,  int limit,  String? statusFilter,  String? branchIdFilter,  String? searchQuery,  DateTime? dateFrom,  DateTime? dateTo,  bool isLoadingMore,  bool hasActiveFilters)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SalesListInitial():
return initial();case SalesListLoading():
return loading();case SalesListLoaded():
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.statusFilter,_that.branchIdFilter,_that.searchQuery,_that.dateFrom,_that.dateTo,_that.isLoadingMore,_that.hasActiveFilters);case SalesListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SaleListItemModel> items,  int total,  int skip,  int limit,  String? statusFilter,  String? branchIdFilter,  String? searchQuery,  DateTime? dateFrom,  DateTime? dateTo,  bool isLoadingMore,  bool hasActiveFilters)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SalesListInitial() when initial != null:
return initial();case SalesListLoading() when loading != null:
return loading();case SalesListLoaded() when loaded != null:
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.statusFilter,_that.branchIdFilter,_that.searchQuery,_that.dateFrom,_that.dateTo,_that.isLoadingMore,_that.hasActiveFilters);case SalesListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SalesListInitial implements SalesListState {
  const SalesListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SalesListState.initial()';
}


}




/// @nodoc


class SalesListLoading implements SalesListState {
  const SalesListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SalesListState.loading()';
}


}




/// @nodoc


class SalesListLoaded implements SalesListState {
  const SalesListLoaded({required  List<SaleListItemModel> items, required this.total, required this.skip, required this.limit, this.statusFilter, this.branchIdFilter, this.searchQuery, this.dateFrom, this.dateTo, this.isLoadingMore = false, this.hasActiveFilters = false}): _items = items;
  

 final  List<SaleListItemModel> _items;
 List<SaleListItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int total;
 final  int skip;
 final  int limit;
 final  String? statusFilter;
 final  String? branchIdFilter;
 final  String? searchQuery;
 final  DateTime? dateFrom;
 final  DateTime? dateTo;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool hasActiveFilters;

/// Create a copy of SalesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesListLoadedCopyWith<SalesListLoaded> get copyWith => _$SalesListLoadedCopyWithImpl<SalesListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesListLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.branchIdFilter, branchIdFilter) || other.branchIdFilter == branchIdFilter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasActiveFilters, hasActiveFilters) || other.hasActiveFilters == hasActiveFilters));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,skip,limit,statusFilter,branchIdFilter,searchQuery,dateFrom,dateTo,isLoadingMore,hasActiveFilters);
}

@override
String toString() {
    return 'SalesListState.loaded(items: $items, total: $total, skip: $skip, limit: $limit, statusFilter: $statusFilter, branchIdFilter: $branchIdFilter, searchQuery: $searchQuery, dateFrom: $dateFrom, dateTo: $dateTo, isLoadingMore: $isLoadingMore, hasActiveFilters: $hasActiveFilters)';
}


}

/// @nodoc
abstract mixin class $SalesListLoadedCopyWith<$Res> implements $SalesListStateCopyWith<$Res> {
  factory $SalesListLoadedCopyWith(SalesListLoaded value, $Res Function(SalesListLoaded) _then) = _$SalesListLoadedCopyWithImpl;
@useResult
$Res call({
 List<SaleListItemModel> items, int total, int skip, int limit, String? statusFilter, String? branchIdFilter, String? searchQuery, DateTime? dateFrom, DateTime? dateTo, bool isLoadingMore, bool hasActiveFilters
});




}
/// @nodoc
class _$SalesListLoadedCopyWithImpl<$Res>
    implements $SalesListLoadedCopyWith<$Res> {
  _$SalesListLoadedCopyWithImpl(this._self, this._then);

  final SalesListLoaded _self;
  final $Res Function(SalesListLoaded) _then;

/// Create a copy of SalesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? skip = null,Object? limit = null,Object? statusFilter = freezed,Object? branchIdFilter = freezed,Object? searchQuery = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? isLoadingMore = null,Object? hasActiveFilters = null,}) {
  return _then(SalesListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleListItemModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,branchIdFilter: freezed == branchIdFilter ? _self.branchIdFilter : branchIdFilter // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasActiveFilters: null == hasActiveFilters ? _self.hasActiveFilters : hasActiveFilters // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SalesListError implements SalesListState {
  const SalesListError(this.message);
  

 final  String message;

/// Create a copy of SalesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesListErrorCopyWith<SalesListError> get copyWith => _$SalesListErrorCopyWithImpl<SalesListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SalesListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SalesListErrorCopyWith<$Res> implements $SalesListStateCopyWith<$Res> {
  factory $SalesListErrorCopyWith(SalesListError value, $Res Function(SalesListError) _then) = _$SalesListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SalesListErrorCopyWithImpl<$Res>
    implements $SalesListErrorCopyWith<$Res> {
  _$SalesListErrorCopyWithImpl(this._self, this._then);

  final SalesListError _self;
  final $Res Function(SalesListError) _then;

/// Create a copy of SalesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SalesListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
