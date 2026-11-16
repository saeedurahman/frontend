// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductsListState()';
}


}

/// @nodoc
class $ProductsListStateCopyWith<$Res>  {
$ProductsListStateCopyWith(ProductsListState _, $Res Function(ProductsListState) __);
}


/// Adds pattern-matching-related methods to [ProductsListState].
extension ProductsListStatePatterns on ProductsListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductsListInitial value)?  initial,TResult Function( ProductsListLoading value)?  loading,TResult Function( ProductsListLoaded value)?  loaded,TResult Function( ProductsListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductsListInitial() when initial != null:
return initial(_that);case ProductsListLoading() when loading != null:
return loading(_that);case ProductsListLoaded() when loaded != null:
return loaded(_that);case ProductsListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductsListInitial value)  initial,required TResult Function( ProductsListLoading value)  loading,required TResult Function( ProductsListLoaded value)  loaded,required TResult Function( ProductsListError value)  error,}){
final _that = this;
switch (_that) {
case ProductsListInitial():
return initial(_that);case ProductsListLoading():
return loading(_that);case ProductsListLoaded():
return loaded(_that);case ProductsListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductsListInitial value)?  initial,TResult? Function( ProductsListLoading value)?  loading,TResult? Function( ProductsListLoaded value)?  loaded,TResult? Function( ProductsListError value)?  error,}){
final _that = this;
switch (_that) {
case ProductsListInitial() when initial != null:
return initial(_that);case ProductsListLoading() when loading != null:
return loading(_that);case ProductsListLoaded() when loaded != null:
return loaded(_that);case ProductsListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ProductListItemModel> items,  int total,  int skip,  int limit,  String? currentSearch,  String? currentCategoryId,  String? currentBrandId,  bool? currentIsActive,  bool isLoadingMore)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductsListInitial() when initial != null:
return initial();case ProductsListLoading() when loading != null:
return loading();case ProductsListLoaded() when loaded != null:
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.currentSearch,_that.currentCategoryId,_that.currentBrandId,_that.currentIsActive,_that.isLoadingMore);case ProductsListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ProductListItemModel> items,  int total,  int skip,  int limit,  String? currentSearch,  String? currentCategoryId,  String? currentBrandId,  bool? currentIsActive,  bool isLoadingMore)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ProductsListInitial():
return initial();case ProductsListLoading():
return loading();case ProductsListLoaded():
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.currentSearch,_that.currentCategoryId,_that.currentBrandId,_that.currentIsActive,_that.isLoadingMore);case ProductsListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ProductListItemModel> items,  int total,  int skip,  int limit,  String? currentSearch,  String? currentCategoryId,  String? currentBrandId,  bool? currentIsActive,  bool isLoadingMore)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ProductsListInitial() when initial != null:
return initial();case ProductsListLoading() when loading != null:
return loading();case ProductsListLoaded() when loaded != null:
return loaded(_that.items,_that.total,_that.skip,_that.limit,_that.currentSearch,_that.currentCategoryId,_that.currentBrandId,_that.currentIsActive,_that.isLoadingMore);case ProductsListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ProductsListInitial implements ProductsListState {
  const ProductsListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductsListState.initial()';
}


}




/// @nodoc


class ProductsListLoading implements ProductsListState {
  const ProductsListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductsListState.loading()';
}


}




/// @nodoc


class ProductsListLoaded implements ProductsListState {
  const ProductsListLoaded({required  List<ProductListItemModel> items, required this.total, required this.skip, required this.limit, this.currentSearch, this.currentCategoryId, this.currentBrandId, this.currentIsActive, this.isLoadingMore = false}): _items = items;
  

 final  List<ProductListItemModel> _items;
 List<ProductListItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int total;
 final  int skip;
 final  int limit;
 final  String? currentSearch;
 final  String? currentCategoryId;
 final  String? currentBrandId;
 final  bool? currentIsActive;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of ProductsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsListLoadedCopyWith<ProductsListLoaded> get copyWith => _$ProductsListLoadedCopyWithImpl<ProductsListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsListLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.currentSearch, currentSearch) || other.currentSearch == currentSearch)&&(identical(other.currentCategoryId, currentCategoryId) || other.currentCategoryId == currentCategoryId)&&(identical(other.currentBrandId, currentBrandId) || other.currentBrandId == currentBrandId)&&(identical(other.currentIsActive, currentIsActive) || other.currentIsActive == currentIsActive)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,skip,limit,currentSearch,currentCategoryId,currentBrandId,currentIsActive,isLoadingMore);
}

@override
String toString() {
    return 'ProductsListState.loaded(items: $items, total: $total, skip: $skip, limit: $limit, currentSearch: $currentSearch, currentCategoryId: $currentCategoryId, currentBrandId: $currentBrandId, currentIsActive: $currentIsActive, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $ProductsListLoadedCopyWith<$Res> implements $ProductsListStateCopyWith<$Res> {
  factory $ProductsListLoadedCopyWith(ProductsListLoaded value, $Res Function(ProductsListLoaded) _then) = _$ProductsListLoadedCopyWithImpl;
@useResult
$Res call({
 List<ProductListItemModel> items, int total, int skip, int limit, String? currentSearch, String? currentCategoryId, String? currentBrandId, bool? currentIsActive, bool isLoadingMore
});




}
/// @nodoc
class _$ProductsListLoadedCopyWithImpl<$Res>
    implements $ProductsListLoadedCopyWith<$Res> {
  _$ProductsListLoadedCopyWithImpl(this._self, this._then);

  final ProductsListLoaded _self;
  final $Res Function(ProductsListLoaded) _then;

/// Create a copy of ProductsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? skip = null,Object? limit = null,Object? currentSearch = freezed,Object? currentCategoryId = freezed,Object? currentBrandId = freezed,Object? currentIsActive = freezed,Object? isLoadingMore = null,}) {
  return _then(ProductsListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,currentSearch: freezed == currentSearch ? _self.currentSearch : currentSearch // ignore: cast_nullable_to_non_nullable
as String?,currentCategoryId: freezed == currentCategoryId ? _self.currentCategoryId : currentCategoryId // ignore: cast_nullable_to_non_nullable
as String?,currentBrandId: freezed == currentBrandId ? _self.currentBrandId : currentBrandId // ignore: cast_nullable_to_non_nullable
as String?,currentIsActive: freezed == currentIsActive ? _self.currentIsActive : currentIsActive // ignore: cast_nullable_to_non_nullable
as bool?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ProductsListError implements ProductsListState {
  const ProductsListError(this.message);
  

 final  String message;

/// Create a copy of ProductsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsListErrorCopyWith<ProductsListError> get copyWith => _$ProductsListErrorCopyWithImpl<ProductsListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ProductsListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProductsListErrorCopyWith<$Res> implements $ProductsListStateCopyWith<$Res> {
  factory $ProductsListErrorCopyWith(ProductsListError value, $Res Function(ProductsListError) _then) = _$ProductsListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProductsListErrorCopyWithImpl<$Res>
    implements $ProductsListErrorCopyWith<$Res> {
  _$ProductsListErrorCopyWithImpl(this._self, this._then);

  final ProductsListError _self;
  final $Res Function(ProductsListError) _then;

/// Create a copy of ProductsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProductsListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
