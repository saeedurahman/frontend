// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customers_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerListRow {

 CustomerModel get customer; String? get balance; bool get balanceLoading;
/// Create a copy of CustomerListRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerListRowCopyWith<CustomerListRow> get copyWith => _$CustomerListRowCopyWithImpl<CustomerListRow>(this as CustomerListRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerListRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerListRow&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.balanceLoading, _this.balanceLoading) || other.balanceLoading == _this.balanceLoading));
}


@override
int get hashCode {
  final _this = this as CustomerListRow;
  return Object.hash(runtimeType,_this.customer,_this.balance,_this.balanceLoading);
}

@override
String toString() {
  final _this = this as CustomerListRow;
  return 'CustomerListRow(customer: ${_this.customer}, balance: ${_this.balance}, balanceLoading: ${_this.balanceLoading})';
}


}

/// @nodoc
abstract mixin class $CustomerListRowCopyWith<$Res>  {
  factory $CustomerListRowCopyWith(CustomerListRow value, $Res Function(CustomerListRow) _then) = _$CustomerListRowCopyWithImpl;
@useResult
$Res call({
 CustomerModel customer, String? balance, bool balanceLoading
});


$CustomerModelCopyWith<$Res> get customer;

}
/// @nodoc
class _$CustomerListRowCopyWithImpl<$Res>
    implements $CustomerListRowCopyWith<$Res> {
  _$CustomerListRowCopyWithImpl(this._self, this._then);

  final CustomerListRow _self;
  final $Res Function(CustomerListRow) _then;

/// Create a copy of CustomerListRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customer = null,Object? balance = freezed,Object? balanceLoading = null,}) {
  return _then(CustomerListRow(
customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerModel,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String?,balanceLoading: null == balanceLoading ? _self.balanceLoading : balanceLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CustomerListRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res> get customer {
  
  return $CustomerModelCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerListRow].
extension CustomerListRowPatterns on CustomerListRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerListRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerListRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerListRow value)  $default,){
final _that = this;
switch (_that) {
case _CustomerListRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerListRow value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerListRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CustomerModel customer,  String? balance,  bool balanceLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerListRow() when $default != null:
return $default(_that.customer,_that.balance,_that.balanceLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CustomerModel customer,  String? balance,  bool balanceLoading)  $default,) {final _that = this;
switch (_that) {
case _CustomerListRow():
return $default(_that.customer,_that.balance,_that.balanceLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CustomerModel customer,  String? balance,  bool balanceLoading)?  $default,) {final _that = this;
switch (_that) {
case _CustomerListRow() when $default != null:
return $default(_that.customer,_that.balance,_that.balanceLoading);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerListRow implements CustomerListRow {
  const _CustomerListRow({required this.customer, this.balance, this.balanceLoading = false});
  

@override final  CustomerModel customer;
@override final  String? balance;
@override@JsonKey() final  bool balanceLoading;

/// Create a copy of CustomerListRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerListRowCopyWith<_CustomerListRow> get copyWith => __$CustomerListRowCopyWithImpl<_CustomerListRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerListRow&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.balanceLoading, balanceLoading) || other.balanceLoading == balanceLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,customer,balance,balanceLoading);
}

@override
String toString() {
    return 'CustomerListRow(customer: $customer, balance: $balance, balanceLoading: $balanceLoading)';
}


}

/// @nodoc
abstract mixin class _$CustomerListRowCopyWith<$Res> implements $CustomerListRowCopyWith<$Res> {
  factory _$CustomerListRowCopyWith(_CustomerListRow value, $Res Function(_CustomerListRow) _then) = __$CustomerListRowCopyWithImpl;
@override @useResult
$Res call({
 CustomerModel customer, String? balance, bool balanceLoading
});


@override $CustomerModelCopyWith<$Res> get customer;

}
/// @nodoc
class __$CustomerListRowCopyWithImpl<$Res>
    implements _$CustomerListRowCopyWith<$Res> {
  __$CustomerListRowCopyWithImpl(this._self, this._then);

  final _CustomerListRow _self;
  final $Res Function(_CustomerListRow) _then;

/// Create a copy of CustomerListRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customer = null,Object? balance = freezed,Object? balanceLoading = null,}) {
  return _then(_CustomerListRow(
customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerModel,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String?,balanceLoading: null == balanceLoading ? _self.balanceLoading : balanceLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CustomerListRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res> get customer {
  
  return $CustomerModelCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

/// @nodoc
mixin _$CustomersListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomersListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomersListState()';
}


}

/// @nodoc
class $CustomersListStateCopyWith<$Res>  {
$CustomersListStateCopyWith(CustomersListState _, $Res Function(CustomersListState) __);
}


/// Adds pattern-matching-related methods to [CustomersListState].
extension CustomersListStatePatterns on CustomersListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CustomersListInitial value)?  initial,TResult Function( CustomersListLoading value)?  loading,TResult Function( CustomersListLoaded value)?  loaded,TResult Function( CustomersListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CustomersListInitial() when initial != null:
return initial(_that);case CustomersListLoading() when loading != null:
return loading(_that);case CustomersListLoaded() when loaded != null:
return loaded(_that);case CustomersListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CustomersListInitial value)  initial,required TResult Function( CustomersListLoading value)  loading,required TResult Function( CustomersListLoaded value)  loaded,required TResult Function( CustomersListError value)  error,}){
final _that = this;
switch (_that) {
case CustomersListInitial():
return initial(_that);case CustomersListLoading():
return loading(_that);case CustomersListLoaded():
return loaded(_that);case CustomersListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CustomersListInitial value)?  initial,TResult? Function( CustomersListLoading value)?  loading,TResult? Function( CustomersListLoaded value)?  loaded,TResult? Function( CustomersListError value)?  error,}){
final _that = this;
switch (_that) {
case CustomersListInitial() when initial != null:
return initial(_that);case CustomersListLoading() when loading != null:
return loading(_that);case CustomersListLoaded() when loaded != null:
return loaded(_that);case CustomersListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CustomerListRow> allItems,  List<CustomerListRow> filteredItems,  String? searchQuery,  CustomerActiveFilter activeFilter,  BalanceFilter balanceFilter,  BalanceSort balanceSort)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CustomersListInitial() when initial != null:
return initial();case CustomersListLoading() when loading != null:
return loading();case CustomersListLoaded() when loaded != null:
return loaded(_that.allItems,_that.filteredItems,_that.searchQuery,_that.activeFilter,_that.balanceFilter,_that.balanceSort);case CustomersListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CustomerListRow> allItems,  List<CustomerListRow> filteredItems,  String? searchQuery,  CustomerActiveFilter activeFilter,  BalanceFilter balanceFilter,  BalanceSort balanceSort)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CustomersListInitial():
return initial();case CustomersListLoading():
return loading();case CustomersListLoaded():
return loaded(_that.allItems,_that.filteredItems,_that.searchQuery,_that.activeFilter,_that.balanceFilter,_that.balanceSort);case CustomersListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CustomerListRow> allItems,  List<CustomerListRow> filteredItems,  String? searchQuery,  CustomerActiveFilter activeFilter,  BalanceFilter balanceFilter,  BalanceSort balanceSort)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CustomersListInitial() when initial != null:
return initial();case CustomersListLoading() when loading != null:
return loading();case CustomersListLoaded() when loaded != null:
return loaded(_that.allItems,_that.filteredItems,_that.searchQuery,_that.activeFilter,_that.balanceFilter,_that.balanceSort);case CustomersListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CustomersListInitial implements CustomersListState {
  const CustomersListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomersListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomersListState.initial()';
}


}




/// @nodoc


class CustomersListLoading implements CustomersListState {
  const CustomersListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomersListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomersListState.loading()';
}


}




/// @nodoc


class CustomersListLoaded implements CustomersListState {
  const CustomersListLoaded({required  List<CustomerListRow> allItems, required  List<CustomerListRow> filteredItems, this.searchQuery, this.activeFilter = CustomerActiveFilter.all, this.balanceFilter = BalanceFilter.all, this.balanceSort = BalanceSort.none}): _allItems = allItems,_filteredItems = filteredItems;
  

 final  List<CustomerListRow> _allItems;
 List<CustomerListRow> get allItems {
  if (_allItems is EqualUnmodifiableListView) return _allItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allItems);
}

 final  List<CustomerListRow> _filteredItems;
 List<CustomerListRow> get filteredItems {
  if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredItems);
}

 final  String? searchQuery;
@JsonKey() final  CustomerActiveFilter activeFilter;
@JsonKey() final  BalanceFilter balanceFilter;
@JsonKey() final  BalanceSort balanceSort;

/// Create a copy of CustomersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomersListLoadedCopyWith<CustomersListLoaded> get copyWith => _$CustomersListLoadedCopyWithImpl<CustomersListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomersListLoaded&&const DeepCollectionEquality().equals(other.allItems, _allItems)&&const DeepCollectionEquality().equals(other.filteredItems, _filteredItems)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.activeFilter, activeFilter) || other.activeFilter == activeFilter)&&(identical(other.balanceFilter, balanceFilter) || other.balanceFilter == balanceFilter)&&(identical(other.balanceSort, balanceSort) || other.balanceSort == balanceSort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allItems),const DeepCollectionEquality().hash(_filteredItems),searchQuery,activeFilter,balanceFilter,balanceSort);
}

@override
String toString() {
    return 'CustomersListState.loaded(allItems: $allItems, filteredItems: $filteredItems, searchQuery: $searchQuery, activeFilter: $activeFilter, balanceFilter: $balanceFilter, balanceSort: $balanceSort)';
}


}

/// @nodoc
abstract mixin class $CustomersListLoadedCopyWith<$Res> implements $CustomersListStateCopyWith<$Res> {
  factory $CustomersListLoadedCopyWith(CustomersListLoaded value, $Res Function(CustomersListLoaded) _then) = _$CustomersListLoadedCopyWithImpl;
@useResult
$Res call({
 List<CustomerListRow> allItems, List<CustomerListRow> filteredItems, String? searchQuery, CustomerActiveFilter activeFilter, BalanceFilter balanceFilter, BalanceSort balanceSort
});




}
/// @nodoc
class _$CustomersListLoadedCopyWithImpl<$Res>
    implements $CustomersListLoadedCopyWith<$Res> {
  _$CustomersListLoadedCopyWithImpl(this._self, this._then);

  final CustomersListLoaded _self;
  final $Res Function(CustomersListLoaded) _then;

/// Create a copy of CustomersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allItems = null,Object? filteredItems = null,Object? searchQuery = freezed,Object? activeFilter = null,Object? balanceFilter = null,Object? balanceSort = null,}) {
  return _then(CustomersListLoaded(
allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<CustomerListRow>,filteredItems: null == filteredItems ? _self._filteredItems : filteredItems // ignore: cast_nullable_to_non_nullable
as List<CustomerListRow>,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,activeFilter: null == activeFilter ? _self.activeFilter : activeFilter // ignore: cast_nullable_to_non_nullable
as CustomerActiveFilter,balanceFilter: null == balanceFilter ? _self.balanceFilter : balanceFilter // ignore: cast_nullable_to_non_nullable
as BalanceFilter,balanceSort: null == balanceSort ? _self.balanceSort : balanceSort // ignore: cast_nullable_to_non_nullable
as BalanceSort,
  ));
}


}

/// @nodoc


class CustomersListError implements CustomersListState {
  const CustomersListError(this.message);
  

 final  String message;

/// Create a copy of CustomersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomersListErrorCopyWith<CustomersListError> get copyWith => _$CustomersListErrorCopyWithImpl<CustomersListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomersListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CustomersListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CustomersListErrorCopyWith<$Res> implements $CustomersListStateCopyWith<$Res> {
  factory $CustomersListErrorCopyWith(CustomersListError value, $Res Function(CustomersListError) _then) = _$CustomersListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CustomersListErrorCopyWithImpl<$Res>
    implements $CustomersListErrorCopyWith<$Res> {
  _$CustomersListErrorCopyWithImpl(this._self, this._then);

  final CustomersListError _self;
  final $Res Function(CustomersListError) _then;

/// Create a copy of CustomersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CustomersListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
