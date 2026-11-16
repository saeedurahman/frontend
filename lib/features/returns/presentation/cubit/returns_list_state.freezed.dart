// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'returns_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReturnsListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnsListState()';
}


}

/// @nodoc
class $ReturnsListStateCopyWith<$Res>  {
$ReturnsListStateCopyWith(ReturnsListState _, $Res Function(ReturnsListState) __);
}


/// Adds pattern-matching-related methods to [ReturnsListState].
extension ReturnsListStatePatterns on ReturnsListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReturnsListInitial value)?  initial,TResult Function( ReturnsListLoading value)?  loading,TResult Function( ReturnsListLoaded value)?  loaded,TResult Function( ReturnsListAccessDenied value)?  accessDenied,TResult Function( ReturnsListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReturnsListInitial() when initial != null:
return initial(_that);case ReturnsListLoading() when loading != null:
return loading(_that);case ReturnsListLoaded() when loaded != null:
return loaded(_that);case ReturnsListAccessDenied() when accessDenied != null:
return accessDenied(_that);case ReturnsListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReturnsListInitial value)  initial,required TResult Function( ReturnsListLoading value)  loading,required TResult Function( ReturnsListLoaded value)  loaded,required TResult Function( ReturnsListAccessDenied value)  accessDenied,required TResult Function( ReturnsListError value)  error,}){
final _that = this;
switch (_that) {
case ReturnsListInitial():
return initial(_that);case ReturnsListLoading():
return loading(_that);case ReturnsListLoaded():
return loaded(_that);case ReturnsListAccessDenied():
return accessDenied(_that);case ReturnsListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReturnsListInitial value)?  initial,TResult? Function( ReturnsListLoading value)?  loading,TResult? Function( ReturnsListLoaded value)?  loaded,TResult? Function( ReturnsListAccessDenied value)?  accessDenied,TResult? Function( ReturnsListError value)?  error,}){
final _that = this;
switch (_that) {
case ReturnsListInitial() when initial != null:
return initial(_that);case ReturnsListLoading() when loading != null:
return loading(_that);case ReturnsListLoaded() when loaded != null:
return loaded(_that);case ReturnsListAccessDenied() when accessDenied != null:
return accessDenied(_that);case ReturnsListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SaleReturnResponseModel> items,  int skip,  int limit,  String? branchIdFilter,  bool isLoadingMore,  bool hasMore)?  loaded,TResult Function()?  accessDenied,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReturnsListInitial() when initial != null:
return initial();case ReturnsListLoading() when loading != null:
return loading();case ReturnsListLoaded() when loaded != null:
return loaded(_that.items,_that.skip,_that.limit,_that.branchIdFilter,_that.isLoadingMore,_that.hasMore);case ReturnsListAccessDenied() when accessDenied != null:
return accessDenied();case ReturnsListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SaleReturnResponseModel> items,  int skip,  int limit,  String? branchIdFilter,  bool isLoadingMore,  bool hasMore)  loaded,required TResult Function()  accessDenied,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ReturnsListInitial():
return initial();case ReturnsListLoading():
return loading();case ReturnsListLoaded():
return loaded(_that.items,_that.skip,_that.limit,_that.branchIdFilter,_that.isLoadingMore,_that.hasMore);case ReturnsListAccessDenied():
return accessDenied();case ReturnsListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SaleReturnResponseModel> items,  int skip,  int limit,  String? branchIdFilter,  bool isLoadingMore,  bool hasMore)?  loaded,TResult? Function()?  accessDenied,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ReturnsListInitial() when initial != null:
return initial();case ReturnsListLoading() when loading != null:
return loading();case ReturnsListLoaded() when loaded != null:
return loaded(_that.items,_that.skip,_that.limit,_that.branchIdFilter,_that.isLoadingMore,_that.hasMore);case ReturnsListAccessDenied() when accessDenied != null:
return accessDenied();case ReturnsListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ReturnsListInitial implements ReturnsListState {
  const ReturnsListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnsListState.initial()';
}


}




/// @nodoc


class ReturnsListLoading implements ReturnsListState {
  const ReturnsListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnsListState.loading()';
}


}




/// @nodoc


class ReturnsListLoaded implements ReturnsListState {
  const ReturnsListLoaded({required  List<SaleReturnResponseModel> items, required this.skip, required this.limit, this.branchIdFilter, this.isLoadingMore = false, this.hasMore = false}): _items = items;
  

 final  List<SaleReturnResponseModel> _items;
 List<SaleReturnResponseModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int skip;
 final  int limit;
 final  String? branchIdFilter;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool hasMore;

/// Create a copy of ReturnsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnsListLoadedCopyWith<ReturnsListLoaded> get copyWith => _$ReturnsListLoadedCopyWithImpl<ReturnsListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsListLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.branchIdFilter, branchIdFilter) || other.branchIdFilter == branchIdFilter)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),skip,limit,branchIdFilter,isLoadingMore,hasMore);
}

@override
String toString() {
    return 'ReturnsListState.loaded(items: $items, skip: $skip, limit: $limit, branchIdFilter: $branchIdFilter, isLoadingMore: $isLoadingMore, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ReturnsListLoadedCopyWith<$Res> implements $ReturnsListStateCopyWith<$Res> {
  factory $ReturnsListLoadedCopyWith(ReturnsListLoaded value, $Res Function(ReturnsListLoaded) _then) = _$ReturnsListLoadedCopyWithImpl;
@useResult
$Res call({
 List<SaleReturnResponseModel> items, int skip, int limit, String? branchIdFilter, bool isLoadingMore, bool hasMore
});




}
/// @nodoc
class _$ReturnsListLoadedCopyWithImpl<$Res>
    implements $ReturnsListLoadedCopyWith<$Res> {
  _$ReturnsListLoadedCopyWithImpl(this._self, this._then);

  final ReturnsListLoaded _self;
  final $Res Function(ReturnsListLoaded) _then;

/// Create a copy of ReturnsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? skip = null,Object? limit = null,Object? branchIdFilter = freezed,Object? isLoadingMore = null,Object? hasMore = null,}) {
  return _then(ReturnsListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleReturnResponseModel>,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,branchIdFilter: freezed == branchIdFilter ? _self.branchIdFilter : branchIdFilter // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ReturnsListAccessDenied implements ReturnsListState {
  const ReturnsListAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsListAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReturnsListState.accessDenied()';
}


}




/// @nodoc


class ReturnsListError implements ReturnsListState {
  const ReturnsListError(this.message);
  

 final  String message;

/// Create a copy of ReturnsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnsListErrorCopyWith<ReturnsListError> get copyWith => _$ReturnsListErrorCopyWithImpl<ReturnsListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ReturnsListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ReturnsListErrorCopyWith<$Res> implements $ReturnsListStateCopyWith<$Res> {
  factory $ReturnsListErrorCopyWith(ReturnsListError value, $Res Function(ReturnsListError) _then) = _$ReturnsListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ReturnsListErrorCopyWithImpl<$Res>
    implements $ReturnsListErrorCopyWith<$Res> {
  _$ReturnsListErrorCopyWithImpl(this._self, this._then);

  final ReturnsListError _self;
  final $Res Function(ReturnsListError) _then;

/// Create a copy of ReturnsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ReturnsListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
