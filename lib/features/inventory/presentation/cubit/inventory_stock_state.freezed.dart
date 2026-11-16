// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_stock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockDisplayRow {

 ProductListItemModel get product; StockBalanceModel get balance; String? get variationName; String? get unitName; String? get minStockLevel;
/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockDisplayRowCopyWith<StockDisplayRow> get copyWith => _$StockDisplayRowCopyWithImpl<StockDisplayRow>(this as StockDisplayRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockDisplayRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockDisplayRow&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.variationName, _this.variationName) || other.variationName == _this.variationName)&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.minStockLevel, _this.minStockLevel) || other.minStockLevel == _this.minStockLevel));
}


@override
int get hashCode {
  final _this = this as StockDisplayRow;
  return Object.hash(runtimeType,_this.product,_this.balance,_this.variationName,_this.unitName,_this.minStockLevel);
}

@override
String toString() {
  final _this = this as StockDisplayRow;
  return 'StockDisplayRow(product: ${_this.product}, balance: ${_this.balance}, variationName: ${_this.variationName}, unitName: ${_this.unitName}, minStockLevel: ${_this.minStockLevel})';
}


}

/// @nodoc
abstract mixin class $StockDisplayRowCopyWith<$Res>  {
  factory $StockDisplayRowCopyWith(StockDisplayRow value, $Res Function(StockDisplayRow) _then) = _$StockDisplayRowCopyWithImpl;
@useResult
$Res call({
 ProductListItemModel product, StockBalanceModel balance, String? variationName, String? unitName, String? minStockLevel
});


$ProductListItemModelCopyWith<$Res> get product;$StockBalanceModelCopyWith<$Res> get balance;

}
/// @nodoc
class _$StockDisplayRowCopyWithImpl<$Res>
    implements $StockDisplayRowCopyWith<$Res> {
  _$StockDisplayRowCopyWithImpl(this._self, this._then);

  final StockDisplayRow _self;
  final $Res Function(StockDisplayRow) _then;

/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? balance = null,Object? variationName = freezed,Object? unitName = freezed,Object? minStockLevel = freezed,}) {
  return _then(StockDisplayRow(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductListItemModel,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as StockBalanceModel,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,unitName: freezed == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductListItemModelCopyWith<$Res> get product {
  
  return $ProductListItemModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockBalanceModelCopyWith<$Res> get balance {
  
  return $StockBalanceModelCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockDisplayRow].
extension StockDisplayRowPatterns on StockDisplayRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockDisplayRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockDisplayRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockDisplayRow value)  $default,){
final _that = this;
switch (_that) {
case _StockDisplayRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockDisplayRow value)?  $default,){
final _that = this;
switch (_that) {
case _StockDisplayRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductListItemModel product,  StockBalanceModel balance,  String? variationName,  String? unitName,  String? minStockLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockDisplayRow() when $default != null:
return $default(_that.product,_that.balance,_that.variationName,_that.unitName,_that.minStockLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductListItemModel product,  StockBalanceModel balance,  String? variationName,  String? unitName,  String? minStockLevel)  $default,) {final _that = this;
switch (_that) {
case _StockDisplayRow():
return $default(_that.product,_that.balance,_that.variationName,_that.unitName,_that.minStockLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductListItemModel product,  StockBalanceModel balance,  String? variationName,  String? unitName,  String? minStockLevel)?  $default,) {final _that = this;
switch (_that) {
case _StockDisplayRow() when $default != null:
return $default(_that.product,_that.balance,_that.variationName,_that.unitName,_that.minStockLevel);case _:
  return null;

}
}

}

/// @nodoc


class _StockDisplayRow extends StockDisplayRow {
  const _StockDisplayRow({required this.product, required this.balance, this.variationName, this.unitName, this.minStockLevel}): super._();
  

@override final  ProductListItemModel product;
@override final  StockBalanceModel balance;
@override final  String? variationName;
@override final  String? unitName;
@override final  String? minStockLevel;

/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockDisplayRowCopyWith<_StockDisplayRow> get copyWith => __$StockDisplayRowCopyWithImpl<_StockDisplayRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockDisplayRow&&(identical(other.product, product) || other.product == product)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.variationName, variationName) || other.variationName == variationName)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.minStockLevel, minStockLevel) || other.minStockLevel == minStockLevel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,product,balance,variationName,unitName,minStockLevel);
}

@override
String toString() {
    return 'StockDisplayRow(product: $product, balance: $balance, variationName: $variationName, unitName: $unitName, minStockLevel: $minStockLevel)';
}


}

/// @nodoc
abstract mixin class _$StockDisplayRowCopyWith<$Res> implements $StockDisplayRowCopyWith<$Res> {
  factory _$StockDisplayRowCopyWith(_StockDisplayRow value, $Res Function(_StockDisplayRow) _then) = __$StockDisplayRowCopyWithImpl;
@override @useResult
$Res call({
 ProductListItemModel product, StockBalanceModel balance, String? variationName, String? unitName, String? minStockLevel
});


@override $ProductListItemModelCopyWith<$Res> get product;@override $StockBalanceModelCopyWith<$Res> get balance;

}
/// @nodoc
class __$StockDisplayRowCopyWithImpl<$Res>
    implements _$StockDisplayRowCopyWith<$Res> {
  __$StockDisplayRowCopyWithImpl(this._self, this._then);

  final _StockDisplayRow _self;
  final $Res Function(_StockDisplayRow) _then;

/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? balance = null,Object? variationName = freezed,Object? unitName = freezed,Object? minStockLevel = freezed,}) {
  return _then(_StockDisplayRow(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductListItemModel,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as StockBalanceModel,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,unitName: freezed == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductListItemModelCopyWith<$Res> get product {
  
  return $ProductListItemModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of StockDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockBalanceModelCopyWith<$Res> get balance {
  
  return $StockBalanceModelCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}

/// @nodoc
mixin _$InventoryStockState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStockState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'InventoryStockState()';
}


}

/// @nodoc
class $InventoryStockStateCopyWith<$Res>  {
$InventoryStockStateCopyWith(InventoryStockState _, $Res Function(InventoryStockState) __);
}


/// Adds pattern-matching-related methods to [InventoryStockState].
extension InventoryStockStatePatterns on InventoryStockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InventoryStockInitial value)?  initial,TResult Function( InventoryStockLoading value)?  loading,TResult Function( InventoryStockLoaded value)?  loaded,TResult Function( InventoryStockError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InventoryStockInitial() when initial != null:
return initial(_that);case InventoryStockLoading() when loading != null:
return loading(_that);case InventoryStockLoaded() when loaded != null:
return loaded(_that);case InventoryStockError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InventoryStockInitial value)  initial,required TResult Function( InventoryStockLoading value)  loading,required TResult Function( InventoryStockLoaded value)  loaded,required TResult Function( InventoryStockError value)  error,}){
final _that = this;
switch (_that) {
case InventoryStockInitial():
return initial(_that);case InventoryStockLoading():
return loading(_that);case InventoryStockLoaded():
return loaded(_that);case InventoryStockError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InventoryStockInitial value)?  initial,TResult? Function( InventoryStockLoading value)?  loading,TResult? Function( InventoryStockLoaded value)?  loaded,TResult? Function( InventoryStockError value)?  error,}){
final _that = this;
switch (_that) {
case InventoryStockInitial() when initial != null:
return initial(_that);case InventoryStockLoading() when loading != null:
return loading(_that);case InventoryStockLoaded() when loaded != null:
return loaded(_that);case InventoryStockError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<StockDisplayRow> allRows,  List<StockDisplayRow> filteredRows,  String? branchId,  String? searchQuery,  String? categoryFilter,  bool lowStockOnly,  bool outOfStockOnly)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InventoryStockInitial() when initial != null:
return initial();case InventoryStockLoading() when loading != null:
return loading();case InventoryStockLoaded() when loaded != null:
return loaded(_that.allRows,_that.filteredRows,_that.branchId,_that.searchQuery,_that.categoryFilter,_that.lowStockOnly,_that.outOfStockOnly);case InventoryStockError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<StockDisplayRow> allRows,  List<StockDisplayRow> filteredRows,  String? branchId,  String? searchQuery,  String? categoryFilter,  bool lowStockOnly,  bool outOfStockOnly)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case InventoryStockInitial():
return initial();case InventoryStockLoading():
return loading();case InventoryStockLoaded():
return loaded(_that.allRows,_that.filteredRows,_that.branchId,_that.searchQuery,_that.categoryFilter,_that.lowStockOnly,_that.outOfStockOnly);case InventoryStockError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<StockDisplayRow> allRows,  List<StockDisplayRow> filteredRows,  String? branchId,  String? searchQuery,  String? categoryFilter,  bool lowStockOnly,  bool outOfStockOnly)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case InventoryStockInitial() when initial != null:
return initial();case InventoryStockLoading() when loading != null:
return loading();case InventoryStockLoaded() when loaded != null:
return loaded(_that.allRows,_that.filteredRows,_that.branchId,_that.searchQuery,_that.categoryFilter,_that.lowStockOnly,_that.outOfStockOnly);case InventoryStockError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class InventoryStockInitial implements InventoryStockState {
  const InventoryStockInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStockInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'InventoryStockState.initial()';
}


}




/// @nodoc


class InventoryStockLoading implements InventoryStockState {
  const InventoryStockLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStockLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'InventoryStockState.loading()';
}


}




/// @nodoc


class InventoryStockLoaded implements InventoryStockState {
  const InventoryStockLoaded({required  List<StockDisplayRow> allRows, required  List<StockDisplayRow> filteredRows, this.branchId, this.searchQuery, this.categoryFilter, this.lowStockOnly = false, this.outOfStockOnly = false}): _allRows = allRows,_filteredRows = filteredRows;
  

 final  List<StockDisplayRow> _allRows;
 List<StockDisplayRow> get allRows {
  if (_allRows is EqualUnmodifiableListView) return _allRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allRows);
}

 final  List<StockDisplayRow> _filteredRows;
 List<StockDisplayRow> get filteredRows {
  if (_filteredRows is EqualUnmodifiableListView) return _filteredRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredRows);
}

 final  String? branchId;
 final  String? searchQuery;
 final  String? categoryFilter;
@JsonKey() final  bool lowStockOnly;
@JsonKey() final  bool outOfStockOnly;

/// Create a copy of InventoryStockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStockLoadedCopyWith<InventoryStockLoaded> get copyWith => _$InventoryStockLoadedCopyWithImpl<InventoryStockLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStockLoaded&&const DeepCollectionEquality().equals(other.allRows, _allRows)&&const DeepCollectionEquality().equals(other.filteredRows, _filteredRows)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.categoryFilter, categoryFilter) || other.categoryFilter == categoryFilter)&&(identical(other.lowStockOnly, lowStockOnly) || other.lowStockOnly == lowStockOnly)&&(identical(other.outOfStockOnly, outOfStockOnly) || other.outOfStockOnly == outOfStockOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allRows),const DeepCollectionEquality().hash(_filteredRows),branchId,searchQuery,categoryFilter,lowStockOnly,outOfStockOnly);
}

@override
String toString() {
    return 'InventoryStockState.loaded(allRows: $allRows, filteredRows: $filteredRows, branchId: $branchId, searchQuery: $searchQuery, categoryFilter: $categoryFilter, lowStockOnly: $lowStockOnly, outOfStockOnly: $outOfStockOnly)';
}


}

/// @nodoc
abstract mixin class $InventoryStockLoadedCopyWith<$Res> implements $InventoryStockStateCopyWith<$Res> {
  factory $InventoryStockLoadedCopyWith(InventoryStockLoaded value, $Res Function(InventoryStockLoaded) _then) = _$InventoryStockLoadedCopyWithImpl;
@useResult
$Res call({
 List<StockDisplayRow> allRows, List<StockDisplayRow> filteredRows, String? branchId, String? searchQuery, String? categoryFilter, bool lowStockOnly, bool outOfStockOnly
});




}
/// @nodoc
class _$InventoryStockLoadedCopyWithImpl<$Res>
    implements $InventoryStockLoadedCopyWith<$Res> {
  _$InventoryStockLoadedCopyWithImpl(this._self, this._then);

  final InventoryStockLoaded _self;
  final $Res Function(InventoryStockLoaded) _then;

/// Create a copy of InventoryStockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allRows = null,Object? filteredRows = null,Object? branchId = freezed,Object? searchQuery = freezed,Object? categoryFilter = freezed,Object? lowStockOnly = null,Object? outOfStockOnly = null,}) {
  return _then(InventoryStockLoaded(
allRows: null == allRows ? _self._allRows : allRows // ignore: cast_nullable_to_non_nullable
as List<StockDisplayRow>,filteredRows: null == filteredRows ? _self._filteredRows : filteredRows // ignore: cast_nullable_to_non_nullable
as List<StockDisplayRow>,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,categoryFilter: freezed == categoryFilter ? _self.categoryFilter : categoryFilter // ignore: cast_nullable_to_non_nullable
as String?,lowStockOnly: null == lowStockOnly ? _self.lowStockOnly : lowStockOnly // ignore: cast_nullable_to_non_nullable
as bool,outOfStockOnly: null == outOfStockOnly ? _self.outOfStockOnly : outOfStockOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class InventoryStockError implements InventoryStockState {
  const InventoryStockError(this.message);
  

 final  String message;

/// Create a copy of InventoryStockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStockErrorCopyWith<InventoryStockError> get copyWith => _$InventoryStockErrorCopyWithImpl<InventoryStockError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStockError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'InventoryStockState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $InventoryStockErrorCopyWith<$Res> implements $InventoryStockStateCopyWith<$Res> {
  factory $InventoryStockErrorCopyWith(InventoryStockError value, $Res Function(InventoryStockError) _then) = _$InventoryStockErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$InventoryStockErrorCopyWithImpl<$Res>
    implements $InventoryStockErrorCopyWith<$Res> {
  _$InventoryStockErrorCopyWithImpl(this._self, this._then);

  final InventoryStockError _self;
  final $Res Function(InventoryStockError) _then;

/// Create a copy of InventoryStockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(InventoryStockError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
