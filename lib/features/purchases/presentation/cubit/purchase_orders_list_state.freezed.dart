// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_orders_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchaseOrdersListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrdersListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PurchaseOrdersListState()';
}


}

/// @nodoc
class $PurchaseOrdersListStateCopyWith<$Res>  {
$PurchaseOrdersListStateCopyWith(PurchaseOrdersListState _, $Res Function(PurchaseOrdersListState) __);
}


/// Adds pattern-matching-related methods to [PurchaseOrdersListState].
extension PurchaseOrdersListStatePatterns on PurchaseOrdersListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PurchaseOrdersListInitial value)?  initial,TResult Function( PurchaseOrdersListLoading value)?  loading,TResult Function( PurchaseOrdersListLoaded value)?  loaded,TResult Function( PurchaseOrdersListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PurchaseOrdersListInitial() when initial != null:
return initial(_that);case PurchaseOrdersListLoading() when loading != null:
return loading(_that);case PurchaseOrdersListLoaded() when loaded != null:
return loaded(_that);case PurchaseOrdersListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PurchaseOrdersListInitial value)  initial,required TResult Function( PurchaseOrdersListLoading value)  loading,required TResult Function( PurchaseOrdersListLoaded value)  loaded,required TResult Function( PurchaseOrdersListError value)  error,}){
final _that = this;
switch (_that) {
case PurchaseOrdersListInitial():
return initial(_that);case PurchaseOrdersListLoading():
return loading(_that);case PurchaseOrdersListLoaded():
return loaded(_that);case PurchaseOrdersListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PurchaseOrdersListInitial value)?  initial,TResult? Function( PurchaseOrdersListLoading value)?  loading,TResult? Function( PurchaseOrdersListLoaded value)?  loaded,TResult? Function( PurchaseOrdersListError value)?  error,}){
final _that = this;
switch (_that) {
case PurchaseOrdersListInitial() when initial != null:
return initial(_that);case PurchaseOrdersListLoading() when loading != null:
return loading(_that);case PurchaseOrdersListLoaded() when loaded != null:
return loaded(_that);case PurchaseOrdersListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PurchaseOrderModel> allOrders,  List<PurchaseOrderModel> filteredOrders,  List<SupplierModel> suppliers,  String? statusFilter,  String? supplierFilter)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PurchaseOrdersListInitial() when initial != null:
return initial();case PurchaseOrdersListLoading() when loading != null:
return loading();case PurchaseOrdersListLoaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.suppliers,_that.statusFilter,_that.supplierFilter);case PurchaseOrdersListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PurchaseOrderModel> allOrders,  List<PurchaseOrderModel> filteredOrders,  List<SupplierModel> suppliers,  String? statusFilter,  String? supplierFilter)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PurchaseOrdersListInitial():
return initial();case PurchaseOrdersListLoading():
return loading();case PurchaseOrdersListLoaded():
return loaded(_that.allOrders,_that.filteredOrders,_that.suppliers,_that.statusFilter,_that.supplierFilter);case PurchaseOrdersListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PurchaseOrderModel> allOrders,  List<PurchaseOrderModel> filteredOrders,  List<SupplierModel> suppliers,  String? statusFilter,  String? supplierFilter)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PurchaseOrdersListInitial() when initial != null:
return initial();case PurchaseOrdersListLoading() when loading != null:
return loading();case PurchaseOrdersListLoaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.suppliers,_that.statusFilter,_that.supplierFilter);case PurchaseOrdersListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PurchaseOrdersListInitial implements PurchaseOrdersListState {
  const PurchaseOrdersListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrdersListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PurchaseOrdersListState.initial()';
}


}




/// @nodoc


class PurchaseOrdersListLoading implements PurchaseOrdersListState {
  const PurchaseOrdersListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrdersListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PurchaseOrdersListState.loading()';
}


}




/// @nodoc


class PurchaseOrdersListLoaded implements PurchaseOrdersListState {
  const PurchaseOrdersListLoaded({required  List<PurchaseOrderModel> allOrders, required  List<PurchaseOrderModel> filteredOrders, required  List<SupplierModel> suppliers, this.statusFilter, this.supplierFilter}): _allOrders = allOrders,_filteredOrders = filteredOrders,_suppliers = suppliers;
  

 final  List<PurchaseOrderModel> _allOrders;
 List<PurchaseOrderModel> get allOrders {
  if (_allOrders is EqualUnmodifiableListView) return _allOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allOrders);
}

 final  List<PurchaseOrderModel> _filteredOrders;
 List<PurchaseOrderModel> get filteredOrders {
  if (_filteredOrders is EqualUnmodifiableListView) return _filteredOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredOrders);
}

 final  List<SupplierModel> _suppliers;
 List<SupplierModel> get suppliers {
  if (_suppliers is EqualUnmodifiableListView) return _suppliers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suppliers);
}

 final  String? statusFilter;
 final  String? supplierFilter;

/// Create a copy of PurchaseOrdersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrdersListLoadedCopyWith<PurchaseOrdersListLoaded> get copyWith => _$PurchaseOrdersListLoadedCopyWithImpl<PurchaseOrdersListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrdersListLoaded&&const DeepCollectionEquality().equals(other.allOrders, _allOrders)&&const DeepCollectionEquality().equals(other.filteredOrders, _filteredOrders)&&const DeepCollectionEquality().equals(other.suppliers, _suppliers)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.supplierFilter, supplierFilter) || other.supplierFilter == supplierFilter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allOrders),const DeepCollectionEquality().hash(_filteredOrders),const DeepCollectionEquality().hash(_suppliers),statusFilter,supplierFilter);
}

@override
String toString() {
    return 'PurchaseOrdersListState.loaded(allOrders: $allOrders, filteredOrders: $filteredOrders, suppliers: $suppliers, statusFilter: $statusFilter, supplierFilter: $supplierFilter)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrdersListLoadedCopyWith<$Res> implements $PurchaseOrdersListStateCopyWith<$Res> {
  factory $PurchaseOrdersListLoadedCopyWith(PurchaseOrdersListLoaded value, $Res Function(PurchaseOrdersListLoaded) _then) = _$PurchaseOrdersListLoadedCopyWithImpl;
@useResult
$Res call({
 List<PurchaseOrderModel> allOrders, List<PurchaseOrderModel> filteredOrders, List<SupplierModel> suppliers, String? statusFilter, String? supplierFilter
});




}
/// @nodoc
class _$PurchaseOrdersListLoadedCopyWithImpl<$Res>
    implements $PurchaseOrdersListLoadedCopyWith<$Res> {
  _$PurchaseOrdersListLoadedCopyWithImpl(this._self, this._then);

  final PurchaseOrdersListLoaded _self;
  final $Res Function(PurchaseOrdersListLoaded) _then;

/// Create a copy of PurchaseOrdersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allOrders = null,Object? filteredOrders = null,Object? suppliers = null,Object? statusFilter = freezed,Object? supplierFilter = freezed,}) {
  return _then(PurchaseOrdersListLoaded(
allOrders: null == allOrders ? _self._allOrders : allOrders // ignore: cast_nullable_to_non_nullable
as List<PurchaseOrderModel>,filteredOrders: null == filteredOrders ? _self._filteredOrders : filteredOrders // ignore: cast_nullable_to_non_nullable
as List<PurchaseOrderModel>,suppliers: null == suppliers ? _self._suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,supplierFilter: freezed == supplierFilter ? _self.supplierFilter : supplierFilter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PurchaseOrdersListError implements PurchaseOrdersListState {
  const PurchaseOrdersListError(this.message);
  

 final  String message;

/// Create a copy of PurchaseOrdersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrdersListErrorCopyWith<PurchaseOrdersListError> get copyWith => _$PurchaseOrdersListErrorCopyWithImpl<PurchaseOrdersListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrdersListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'PurchaseOrdersListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrdersListErrorCopyWith<$Res> implements $PurchaseOrdersListStateCopyWith<$Res> {
  factory $PurchaseOrdersListErrorCopyWith(PurchaseOrdersListError value, $Res Function(PurchaseOrdersListError) _then) = _$PurchaseOrdersListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PurchaseOrdersListErrorCopyWithImpl<$Res>
    implements $PurchaseOrdersListErrorCopyWith<$Res> {
  _$PurchaseOrdersListErrorCopyWithImpl(this._self, this._then);

  final PurchaseOrdersListError _self;
  final $Res Function(PurchaseOrdersListError) _then;

/// Create a copy of PurchaseOrdersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PurchaseOrdersListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
