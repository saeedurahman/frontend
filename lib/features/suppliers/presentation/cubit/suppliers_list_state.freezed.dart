// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suppliers_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupplierListRow {

 SupplierModel get supplier; String? get balance; bool get balanceLoading;
/// Create a copy of SupplierListRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierListRowCopyWith<SupplierListRow> get copyWith => _$SupplierListRowCopyWithImpl<SupplierListRow>(this as SupplierListRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SupplierListRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierListRow&&(identical(other.supplier, _this.supplier) || other.supplier == _this.supplier)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.balanceLoading, _this.balanceLoading) || other.balanceLoading == _this.balanceLoading));
}


@override
int get hashCode {
  final _this = this as SupplierListRow;
  return Object.hash(runtimeType,_this.supplier,_this.balance,_this.balanceLoading);
}

@override
String toString() {
  final _this = this as SupplierListRow;
  return 'SupplierListRow(supplier: ${_this.supplier}, balance: ${_this.balance}, balanceLoading: ${_this.balanceLoading})';
}


}

/// @nodoc
abstract mixin class $SupplierListRowCopyWith<$Res>  {
  factory $SupplierListRowCopyWith(SupplierListRow value, $Res Function(SupplierListRow) _then) = _$SupplierListRowCopyWithImpl;
@useResult
$Res call({
 SupplierModel supplier, String? balance, bool balanceLoading
});


$SupplierModelCopyWith<$Res> get supplier;

}
/// @nodoc
class _$SupplierListRowCopyWithImpl<$Res>
    implements $SupplierListRowCopyWith<$Res> {
  _$SupplierListRowCopyWithImpl(this._self, this._then);

  final SupplierListRow _self;
  final $Res Function(SupplierListRow) _then;

/// Create a copy of SupplierListRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplier = null,Object? balance = freezed,Object? balanceLoading = null,}) {
  return _then(SupplierListRow(
supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as SupplierModel,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String?,balanceLoading: null == balanceLoading ? _self.balanceLoading : balanceLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SupplierListRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<$Res> get supplier {
  
  return $SupplierModelCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}


/// Adds pattern-matching-related methods to [SupplierListRow].
extension SupplierListRowPatterns on SupplierListRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierListRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierListRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierListRow value)  $default,){
final _that = this;
switch (_that) {
case _SupplierListRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierListRow value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierListRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SupplierModel supplier,  String? balance,  bool balanceLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierListRow() when $default != null:
return $default(_that.supplier,_that.balance,_that.balanceLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SupplierModel supplier,  String? balance,  bool balanceLoading)  $default,) {final _that = this;
switch (_that) {
case _SupplierListRow():
return $default(_that.supplier,_that.balance,_that.balanceLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SupplierModel supplier,  String? balance,  bool balanceLoading)?  $default,) {final _that = this;
switch (_that) {
case _SupplierListRow() when $default != null:
return $default(_that.supplier,_that.balance,_that.balanceLoading);case _:
  return null;

}
}

}

/// @nodoc


class _SupplierListRow implements SupplierListRow {
  const _SupplierListRow({required this.supplier, this.balance, this.balanceLoading = false});
  

@override final  SupplierModel supplier;
@override final  String? balance;
@override@JsonKey() final  bool balanceLoading;

/// Create a copy of SupplierListRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierListRowCopyWith<_SupplierListRow> get copyWith => __$SupplierListRowCopyWithImpl<_SupplierListRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierListRow&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.balanceLoading, balanceLoading) || other.balanceLoading == balanceLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,supplier,balance,balanceLoading);
}

@override
String toString() {
    return 'SupplierListRow(supplier: $supplier, balance: $balance, balanceLoading: $balanceLoading)';
}


}

/// @nodoc
abstract mixin class _$SupplierListRowCopyWith<$Res> implements $SupplierListRowCopyWith<$Res> {
  factory _$SupplierListRowCopyWith(_SupplierListRow value, $Res Function(_SupplierListRow) _then) = __$SupplierListRowCopyWithImpl;
@override @useResult
$Res call({
 SupplierModel supplier, String? balance, bool balanceLoading
});


@override $SupplierModelCopyWith<$Res> get supplier;

}
/// @nodoc
class __$SupplierListRowCopyWithImpl<$Res>
    implements _$SupplierListRowCopyWith<$Res> {
  __$SupplierListRowCopyWithImpl(this._self, this._then);

  final _SupplierListRow _self;
  final $Res Function(_SupplierListRow) _then;

/// Create a copy of SupplierListRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplier = null,Object? balance = freezed,Object? balanceLoading = null,}) {
  return _then(_SupplierListRow(
supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as SupplierModel,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String?,balanceLoading: null == balanceLoading ? _self.balanceLoading : balanceLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SupplierListRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<$Res> get supplier {
  
  return $SupplierModelCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}

/// @nodoc
mixin _$SuppliersListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SuppliersListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SuppliersListState()';
}


}

/// @nodoc
class $SuppliersListStateCopyWith<$Res>  {
$SuppliersListStateCopyWith(SuppliersListState _, $Res Function(SuppliersListState) __);
}


/// Adds pattern-matching-related methods to [SuppliersListState].
extension SuppliersListStatePatterns on SuppliersListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SuppliersListInitial value)?  initial,TResult Function( SuppliersListLoading value)?  loading,TResult Function( SuppliersListLoaded value)?  loaded,TResult Function( SuppliersListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SuppliersListInitial() when initial != null:
return initial(_that);case SuppliersListLoading() when loading != null:
return loading(_that);case SuppliersListLoaded() when loaded != null:
return loaded(_that);case SuppliersListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SuppliersListInitial value)  initial,required TResult Function( SuppliersListLoading value)  loading,required TResult Function( SuppliersListLoaded value)  loaded,required TResult Function( SuppliersListError value)  error,}){
final _that = this;
switch (_that) {
case SuppliersListInitial():
return initial(_that);case SuppliersListLoading():
return loading(_that);case SuppliersListLoaded():
return loaded(_that);case SuppliersListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SuppliersListInitial value)?  initial,TResult? Function( SuppliersListLoading value)?  loading,TResult? Function( SuppliersListLoaded value)?  loaded,TResult? Function( SuppliersListError value)?  error,}){
final _that = this;
switch (_that) {
case SuppliersListInitial() when initial != null:
return initial(_that);case SuppliersListLoading() when loading != null:
return loading(_that);case SuppliersListLoaded() when loaded != null:
return loaded(_that);case SuppliersListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SupplierListRow> allItems,  List<SupplierListRow> filteredItems,  String? searchQuery,  BalanceFilter balanceFilter,  BalanceSort balanceSort)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SuppliersListInitial() when initial != null:
return initial();case SuppliersListLoading() when loading != null:
return loading();case SuppliersListLoaded() when loaded != null:
return loaded(_that.allItems,_that.filteredItems,_that.searchQuery,_that.balanceFilter,_that.balanceSort);case SuppliersListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SupplierListRow> allItems,  List<SupplierListRow> filteredItems,  String? searchQuery,  BalanceFilter balanceFilter,  BalanceSort balanceSort)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SuppliersListInitial():
return initial();case SuppliersListLoading():
return loading();case SuppliersListLoaded():
return loaded(_that.allItems,_that.filteredItems,_that.searchQuery,_that.balanceFilter,_that.balanceSort);case SuppliersListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SupplierListRow> allItems,  List<SupplierListRow> filteredItems,  String? searchQuery,  BalanceFilter balanceFilter,  BalanceSort balanceSort)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SuppliersListInitial() when initial != null:
return initial();case SuppliersListLoading() when loading != null:
return loading();case SuppliersListLoaded() when loaded != null:
return loaded(_that.allItems,_that.filteredItems,_that.searchQuery,_that.balanceFilter,_that.balanceSort);case SuppliersListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SuppliersListInitial implements SuppliersListState {
  const SuppliersListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SuppliersListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SuppliersListState.initial()';
}


}




/// @nodoc


class SuppliersListLoading implements SuppliersListState {
  const SuppliersListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SuppliersListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SuppliersListState.loading()';
}


}




/// @nodoc


class SuppliersListLoaded implements SuppliersListState {
  const SuppliersListLoaded({required  List<SupplierListRow> allItems, required  List<SupplierListRow> filteredItems, this.searchQuery, this.balanceFilter = BalanceFilter.all, this.balanceSort = BalanceSort.none}): _allItems = allItems,_filteredItems = filteredItems;
  

 final  List<SupplierListRow> _allItems;
 List<SupplierListRow> get allItems {
  if (_allItems is EqualUnmodifiableListView) return _allItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allItems);
}

 final  List<SupplierListRow> _filteredItems;
 List<SupplierListRow> get filteredItems {
  if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredItems);
}

 final  String? searchQuery;
@JsonKey() final  BalanceFilter balanceFilter;
@JsonKey() final  BalanceSort balanceSort;

/// Create a copy of SuppliersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuppliersListLoadedCopyWith<SuppliersListLoaded> get copyWith => _$SuppliersListLoadedCopyWithImpl<SuppliersListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SuppliersListLoaded&&const DeepCollectionEquality().equals(other.allItems, _allItems)&&const DeepCollectionEquality().equals(other.filteredItems, _filteredItems)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.balanceFilter, balanceFilter) || other.balanceFilter == balanceFilter)&&(identical(other.balanceSort, balanceSort) || other.balanceSort == balanceSort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allItems),const DeepCollectionEquality().hash(_filteredItems),searchQuery,balanceFilter,balanceSort);
}

@override
String toString() {
    return 'SuppliersListState.loaded(allItems: $allItems, filteredItems: $filteredItems, searchQuery: $searchQuery, balanceFilter: $balanceFilter, balanceSort: $balanceSort)';
}


}

/// @nodoc
abstract mixin class $SuppliersListLoadedCopyWith<$Res> implements $SuppliersListStateCopyWith<$Res> {
  factory $SuppliersListLoadedCopyWith(SuppliersListLoaded value, $Res Function(SuppliersListLoaded) _then) = _$SuppliersListLoadedCopyWithImpl;
@useResult
$Res call({
 List<SupplierListRow> allItems, List<SupplierListRow> filteredItems, String? searchQuery, BalanceFilter balanceFilter, BalanceSort balanceSort
});




}
/// @nodoc
class _$SuppliersListLoadedCopyWithImpl<$Res>
    implements $SuppliersListLoadedCopyWith<$Res> {
  _$SuppliersListLoadedCopyWithImpl(this._self, this._then);

  final SuppliersListLoaded _self;
  final $Res Function(SuppliersListLoaded) _then;

/// Create a copy of SuppliersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allItems = null,Object? filteredItems = null,Object? searchQuery = freezed,Object? balanceFilter = null,Object? balanceSort = null,}) {
  return _then(SuppliersListLoaded(
allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<SupplierListRow>,filteredItems: null == filteredItems ? _self._filteredItems : filteredItems // ignore: cast_nullable_to_non_nullable
as List<SupplierListRow>,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,balanceFilter: null == balanceFilter ? _self.balanceFilter : balanceFilter // ignore: cast_nullable_to_non_nullable
as BalanceFilter,balanceSort: null == balanceSort ? _self.balanceSort : balanceSort // ignore: cast_nullable_to_non_nullable
as BalanceSort,
  ));
}


}

/// @nodoc


class SuppliersListError implements SuppliersListState {
  const SuppliersListError(this.message);
  

 final  String message;

/// Create a copy of SuppliersListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuppliersListErrorCopyWith<SuppliersListError> get copyWith => _$SuppliersListErrorCopyWithImpl<SuppliersListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SuppliersListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SuppliersListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SuppliersListErrorCopyWith<$Res> implements $SuppliersListStateCopyWith<$Res> {
  factory $SuppliersListErrorCopyWith(SuppliersListError value, $Res Function(SuppliersListError) _then) = _$SuppliersListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SuppliersListErrorCopyWithImpl<$Res>
    implements $SuppliersListErrorCopyWith<$Res> {
  _$SuppliersListErrorCopyWithImpl(this._self, this._then);

  final SuppliersListError _self;
  final $Res Function(SuppliersListError) _then;

/// Create a copy of SuppliersListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SuppliersListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
