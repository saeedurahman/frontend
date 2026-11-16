// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_orders_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductionOrdersListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrdersListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductionOrdersListState()';
}


}

/// @nodoc
class $ProductionOrdersListStateCopyWith<$Res>  {
$ProductionOrdersListStateCopyWith(ProductionOrdersListState _, $Res Function(ProductionOrdersListState) __);
}


/// Adds pattern-matching-related methods to [ProductionOrdersListState].
extension ProductionOrdersListStatePatterns on ProductionOrdersListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductionOrdersListInitial value)?  initial,TResult Function( ProductionOrdersListLoading value)?  loading,TResult Function( ProductionOrdersListLoaded value)?  loaded,TResult Function( ProductionOrdersListError value)?  error,TResult Function( ProductionOrdersListAccessDenied value)?  accessDenied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductionOrdersListInitial() when initial != null:
return initial(_that);case ProductionOrdersListLoading() when loading != null:
return loading(_that);case ProductionOrdersListLoaded() when loaded != null:
return loaded(_that);case ProductionOrdersListError() when error != null:
return error(_that);case ProductionOrdersListAccessDenied() when accessDenied != null:
return accessDenied(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductionOrdersListInitial value)  initial,required TResult Function( ProductionOrdersListLoading value)  loading,required TResult Function( ProductionOrdersListLoaded value)  loaded,required TResult Function( ProductionOrdersListError value)  error,required TResult Function( ProductionOrdersListAccessDenied value)  accessDenied,}){
final _that = this;
switch (_that) {
case ProductionOrdersListInitial():
return initial(_that);case ProductionOrdersListLoading():
return loading(_that);case ProductionOrdersListLoaded():
return loaded(_that);case ProductionOrdersListError():
return error(_that);case ProductionOrdersListAccessDenied():
return accessDenied(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductionOrdersListInitial value)?  initial,TResult? Function( ProductionOrdersListLoading value)?  loading,TResult? Function( ProductionOrdersListLoaded value)?  loaded,TResult? Function( ProductionOrdersListError value)?  error,TResult? Function( ProductionOrdersListAccessDenied value)?  accessDenied,}){
final _that = this;
switch (_that) {
case ProductionOrdersListInitial() when initial != null:
return initial(_that);case ProductionOrdersListLoading() when loading != null:
return loading(_that);case ProductionOrdersListLoaded() when loaded != null:
return loaded(_that);case ProductionOrdersListError() when error != null:
return error(_that);case ProductionOrdersListAccessDenied() when accessDenied != null:
return accessDenied(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ProductionOrderModel> allOrders,  List<ProductionOrderModel> filteredOrders,  String? statusFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool canCreate,  Map<String, String> branchNames)?  loaded,TResult Function( String message)?  error,TResult Function()?  accessDenied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductionOrdersListInitial() when initial != null:
return initial();case ProductionOrdersListLoading() when loading != null:
return loading();case ProductionOrdersListLoaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.statusFilter,_that.dateFrom,_that.dateTo,_that.canCreate,_that.branchNames);case ProductionOrdersListError() when error != null:
return error(_that.message);case ProductionOrdersListAccessDenied() when accessDenied != null:
return accessDenied();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ProductionOrderModel> allOrders,  List<ProductionOrderModel> filteredOrders,  String? statusFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool canCreate,  Map<String, String> branchNames)  loaded,required TResult Function( String message)  error,required TResult Function()  accessDenied,}) {final _that = this;
switch (_that) {
case ProductionOrdersListInitial():
return initial();case ProductionOrdersListLoading():
return loading();case ProductionOrdersListLoaded():
return loaded(_that.allOrders,_that.filteredOrders,_that.statusFilter,_that.dateFrom,_that.dateTo,_that.canCreate,_that.branchNames);case ProductionOrdersListError():
return error(_that.message);case ProductionOrdersListAccessDenied():
return accessDenied();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ProductionOrderModel> allOrders,  List<ProductionOrderModel> filteredOrders,  String? statusFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool canCreate,  Map<String, String> branchNames)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  accessDenied,}) {final _that = this;
switch (_that) {
case ProductionOrdersListInitial() when initial != null:
return initial();case ProductionOrdersListLoading() when loading != null:
return loading();case ProductionOrdersListLoaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.statusFilter,_that.dateFrom,_that.dateTo,_that.canCreate,_that.branchNames);case ProductionOrdersListError() when error != null:
return error(_that.message);case ProductionOrdersListAccessDenied() when accessDenied != null:
return accessDenied();case _:
  return null;

}
}

}

/// @nodoc


class ProductionOrdersListInitial implements ProductionOrdersListState {
  const ProductionOrdersListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrdersListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductionOrdersListState.initial()';
}


}




/// @nodoc


class ProductionOrdersListLoading implements ProductionOrdersListState {
  const ProductionOrdersListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrdersListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductionOrdersListState.loading()';
}


}




/// @nodoc


class ProductionOrdersListLoaded implements ProductionOrdersListState {
  const ProductionOrdersListLoaded({required  List<ProductionOrderModel> allOrders, required  List<ProductionOrderModel> filteredOrders, this.statusFilter, this.dateFrom, this.dateTo, this.canCreate = false,  Map<String, String> branchNames = const {}}): _allOrders = allOrders,_filteredOrders = filteredOrders,_branchNames = branchNames;
  

 final  List<ProductionOrderModel> _allOrders;
 List<ProductionOrderModel> get allOrders {
  if (_allOrders is EqualUnmodifiableListView) return _allOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allOrders);
}

 final  List<ProductionOrderModel> _filteredOrders;
 List<ProductionOrderModel> get filteredOrders {
  if (_filteredOrders is EqualUnmodifiableListView) return _filteredOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredOrders);
}

 final  String? statusFilter;
 final  DateTime? dateFrom;
 final  DateTime? dateTo;
@JsonKey() final  bool canCreate;
 final  Map<String, String> _branchNames;
@JsonKey() Map<String, String> get branchNames {
  if (_branchNames is EqualUnmodifiableMapView) return _branchNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_branchNames);
}


/// Create a copy of ProductionOrdersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionOrdersListLoadedCopyWith<ProductionOrdersListLoaded> get copyWith => _$ProductionOrdersListLoadedCopyWithImpl<ProductionOrdersListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrdersListLoaded&&const DeepCollectionEquality().equals(other.allOrders, _allOrders)&&const DeepCollectionEquality().equals(other.filteredOrders, _filteredOrders)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&const DeepCollectionEquality().equals(other.branchNames, _branchNames));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allOrders),const DeepCollectionEquality().hash(_filteredOrders),statusFilter,dateFrom,dateTo,canCreate,const DeepCollectionEquality().hash(_branchNames));
}

@override
String toString() {
    return 'ProductionOrdersListState.loaded(allOrders: $allOrders, filteredOrders: $filteredOrders, statusFilter: $statusFilter, dateFrom: $dateFrom, dateTo: $dateTo, canCreate: $canCreate, branchNames: $branchNames)';
}


}

/// @nodoc
abstract mixin class $ProductionOrdersListLoadedCopyWith<$Res> implements $ProductionOrdersListStateCopyWith<$Res> {
  factory $ProductionOrdersListLoadedCopyWith(ProductionOrdersListLoaded value, $Res Function(ProductionOrdersListLoaded) _then) = _$ProductionOrdersListLoadedCopyWithImpl;
@useResult
$Res call({
 List<ProductionOrderModel> allOrders, List<ProductionOrderModel> filteredOrders, String? statusFilter, DateTime? dateFrom, DateTime? dateTo, bool canCreate, Map<String, String> branchNames
});




}
/// @nodoc
class _$ProductionOrdersListLoadedCopyWithImpl<$Res>
    implements $ProductionOrdersListLoadedCopyWith<$Res> {
  _$ProductionOrdersListLoadedCopyWithImpl(this._self, this._then);

  final ProductionOrdersListLoaded _self;
  final $Res Function(ProductionOrdersListLoaded) _then;

/// Create a copy of ProductionOrdersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allOrders = null,Object? filteredOrders = null,Object? statusFilter = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? canCreate = null,Object? branchNames = null,}) {
  return _then(ProductionOrdersListLoaded(
allOrders: null == allOrders ? _self._allOrders : allOrders // ignore: cast_nullable_to_non_nullable
as List<ProductionOrderModel>,filteredOrders: null == filteredOrders ? _self._filteredOrders : filteredOrders // ignore: cast_nullable_to_non_nullable
as List<ProductionOrderModel>,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,branchNames: null == branchNames ? _self._branchNames : branchNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc


class ProductionOrdersListError implements ProductionOrdersListState {
  const ProductionOrdersListError(this.message);
  

 final  String message;

/// Create a copy of ProductionOrdersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionOrdersListErrorCopyWith<ProductionOrdersListError> get copyWith => _$ProductionOrdersListErrorCopyWithImpl<ProductionOrdersListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrdersListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ProductionOrdersListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProductionOrdersListErrorCopyWith<$Res> implements $ProductionOrdersListStateCopyWith<$Res> {
  factory $ProductionOrdersListErrorCopyWith(ProductionOrdersListError value, $Res Function(ProductionOrdersListError) _then) = _$ProductionOrdersListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProductionOrdersListErrorCopyWithImpl<$Res>
    implements $ProductionOrdersListErrorCopyWith<$Res> {
  _$ProductionOrdersListErrorCopyWithImpl(this._self, this._then);

  final ProductionOrdersListError _self;
  final $Res Function(ProductionOrdersListError) _then;

/// Create a copy of ProductionOrdersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProductionOrdersListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProductionOrdersListAccessDenied implements ProductionOrdersListState {
  const ProductionOrdersListAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrdersListAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProductionOrdersListState.accessDenied()';
}


}




// dart format on
