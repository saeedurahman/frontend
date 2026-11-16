// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movements_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockMovementRow {

 StockMovementModel get movement; double get runningBalance;
/// Create a copy of StockMovementRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementRowCopyWith<StockMovementRow> get copyWith => _$StockMovementRowCopyWithImpl<StockMovementRow>(this as StockMovementRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockMovementRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementRow&&(identical(other.movement, _this.movement) || other.movement == _this.movement)&&(identical(other.runningBalance, _this.runningBalance) || other.runningBalance == _this.runningBalance));
}


@override
int get hashCode {
  final _this = this as StockMovementRow;
  return Object.hash(runtimeType,_this.movement,_this.runningBalance);
}

@override
String toString() {
  final _this = this as StockMovementRow;
  return 'StockMovementRow(movement: ${_this.movement}, runningBalance: ${_this.runningBalance})';
}


}

/// @nodoc
abstract mixin class $StockMovementRowCopyWith<$Res>  {
  factory $StockMovementRowCopyWith(StockMovementRow value, $Res Function(StockMovementRow) _then) = _$StockMovementRowCopyWithImpl;
@useResult
$Res call({
 StockMovementModel movement, double runningBalance
});


$StockMovementModelCopyWith<$Res> get movement;

}
/// @nodoc
class _$StockMovementRowCopyWithImpl<$Res>
    implements $StockMovementRowCopyWith<$Res> {
  _$StockMovementRowCopyWithImpl(this._self, this._then);

  final StockMovementRow _self;
  final $Res Function(StockMovementRow) _then;

/// Create a copy of StockMovementRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movement = null,Object? runningBalance = null,}) {
  return _then(StockMovementRow(
movement: null == movement ? _self.movement : movement // ignore: cast_nullable_to_non_nullable
as StockMovementModel,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of StockMovementRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<$Res> get movement {
  
  return $StockMovementModelCopyWith<$Res>(_self.movement, (value) {
    return _then(_self.copyWith(movement: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockMovementRow].
extension StockMovementRowPatterns on StockMovementRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovementRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovementRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovementRow value)  $default,){
final _that = this;
switch (_that) {
case _StockMovementRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovementRow value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovementRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockMovementModel movement,  double runningBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovementRow() when $default != null:
return $default(_that.movement,_that.runningBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockMovementModel movement,  double runningBalance)  $default,) {final _that = this;
switch (_that) {
case _StockMovementRow():
return $default(_that.movement,_that.runningBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockMovementModel movement,  double runningBalance)?  $default,) {final _that = this;
switch (_that) {
case _StockMovementRow() when $default != null:
return $default(_that.movement,_that.runningBalance);case _:
  return null;

}
}

}

/// @nodoc


class _StockMovementRow implements StockMovementRow {
  const _StockMovementRow({required this.movement, required this.runningBalance});
  

@override final  StockMovementModel movement;
@override final  double runningBalance;

/// Create a copy of StockMovementRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementRowCopyWith<_StockMovementRow> get copyWith => __$StockMovementRowCopyWithImpl<_StockMovementRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovementRow&&(identical(other.movement, movement) || other.movement == movement)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movement,runningBalance);
}

@override
String toString() {
    return 'StockMovementRow(movement: $movement, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class _$StockMovementRowCopyWith<$Res> implements $StockMovementRowCopyWith<$Res> {
  factory _$StockMovementRowCopyWith(_StockMovementRow value, $Res Function(_StockMovementRow) _then) = __$StockMovementRowCopyWithImpl;
@override @useResult
$Res call({
 StockMovementModel movement, double runningBalance
});


@override $StockMovementModelCopyWith<$Res> get movement;

}
/// @nodoc
class __$StockMovementRowCopyWithImpl<$Res>
    implements _$StockMovementRowCopyWith<$Res> {
  __$StockMovementRowCopyWithImpl(this._self, this._then);

  final _StockMovementRow _self;
  final $Res Function(_StockMovementRow) _then;

/// Create a copy of StockMovementRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movement = null,Object? runningBalance = null,}) {
  return _then(_StockMovementRow(
movement: null == movement ? _self.movement : movement // ignore: cast_nullable_to_non_nullable
as StockMovementModel,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of StockMovementRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<$Res> get movement {
  
  return $StockMovementModelCopyWith<$Res>(_self.movement, (value) {
    return _then(_self.copyWith(movement: value));
  });
}
}

/// @nodoc
mixin _$StockMovementsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StockMovementsState()';
}


}

/// @nodoc
class $StockMovementsStateCopyWith<$Res>  {
$StockMovementsStateCopyWith(StockMovementsState _, $Res Function(StockMovementsState) __);
}


/// Adds pattern-matching-related methods to [StockMovementsState].
extension StockMovementsStatePatterns on StockMovementsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StockMovementsInitial value)?  initial,TResult Function( StockMovementsLoading value)?  loading,TResult Function( StockMovementsLoaded value)?  loaded,TResult Function( StockMovementsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StockMovementsInitial() when initial != null:
return initial(_that);case StockMovementsLoading() when loading != null:
return loading(_that);case StockMovementsLoaded() when loaded != null:
return loaded(_that);case StockMovementsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StockMovementsInitial value)  initial,required TResult Function( StockMovementsLoading value)  loading,required TResult Function( StockMovementsLoaded value)  loaded,required TResult Function( StockMovementsError value)  error,}){
final _that = this;
switch (_that) {
case StockMovementsInitial():
return initial(_that);case StockMovementsLoading():
return loading(_that);case StockMovementsLoaded():
return loaded(_that);case StockMovementsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StockMovementsInitial value)?  initial,TResult? Function( StockMovementsLoading value)?  loading,TResult? Function( StockMovementsLoaded value)?  loaded,TResult? Function( StockMovementsError value)?  error,}){
final _that = this;
switch (_that) {
case StockMovementsInitial() when initial != null:
return initial(_that);case StockMovementsLoading() when loading != null:
return loading(_that);case StockMovementsLoaded() when loaded != null:
return loaded(_that);case StockMovementsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<StockMovementRow> rows,  int total,  int skip,  int limit,  String? productId,  String? branchId,  bool isLoadingMore)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StockMovementsInitial() when initial != null:
return initial();case StockMovementsLoading() when loading != null:
return loading();case StockMovementsLoaded() when loaded != null:
return loaded(_that.rows,_that.total,_that.skip,_that.limit,_that.productId,_that.branchId,_that.isLoadingMore);case StockMovementsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<StockMovementRow> rows,  int total,  int skip,  int limit,  String? productId,  String? branchId,  bool isLoadingMore)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case StockMovementsInitial():
return initial();case StockMovementsLoading():
return loading();case StockMovementsLoaded():
return loaded(_that.rows,_that.total,_that.skip,_that.limit,_that.productId,_that.branchId,_that.isLoadingMore);case StockMovementsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<StockMovementRow> rows,  int total,  int skip,  int limit,  String? productId,  String? branchId,  bool isLoadingMore)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case StockMovementsInitial() when initial != null:
return initial();case StockMovementsLoading() when loading != null:
return loading();case StockMovementsLoaded() when loaded != null:
return loaded(_that.rows,_that.total,_that.skip,_that.limit,_that.productId,_that.branchId,_that.isLoadingMore);case StockMovementsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class StockMovementsInitial implements StockMovementsState {
  const StockMovementsInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StockMovementsState.initial()';
}


}




/// @nodoc


class StockMovementsLoading implements StockMovementsState {
  const StockMovementsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StockMovementsState.loading()';
}


}




/// @nodoc


class StockMovementsLoaded implements StockMovementsState {
  const StockMovementsLoaded({required  List<StockMovementRow> rows, required this.total, required this.skip, required this.limit, this.productId, this.branchId, this.isLoadingMore = false}): _rows = rows;
  

 final  List<StockMovementRow> _rows;
 List<StockMovementRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

 final  int total;
 final  int skip;
 final  int limit;
 final  String? productId;
 final  String? branchId;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of StockMovementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementsLoadedCopyWith<StockMovementsLoaded> get copyWith => _$StockMovementsLoadedCopyWithImpl<StockMovementsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementsLoaded&&const DeepCollectionEquality().equals(other.rows, _rows)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),total,skip,limit,productId,branchId,isLoadingMore);
}

@override
String toString() {
    return 'StockMovementsState.loaded(rows: $rows, total: $total, skip: $skip, limit: $limit, productId: $productId, branchId: $branchId, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $StockMovementsLoadedCopyWith<$Res> implements $StockMovementsStateCopyWith<$Res> {
  factory $StockMovementsLoadedCopyWith(StockMovementsLoaded value, $Res Function(StockMovementsLoaded) _then) = _$StockMovementsLoadedCopyWithImpl;
@useResult
$Res call({
 List<StockMovementRow> rows, int total, int skip, int limit, String? productId, String? branchId, bool isLoadingMore
});




}
/// @nodoc
class _$StockMovementsLoadedCopyWithImpl<$Res>
    implements $StockMovementsLoadedCopyWith<$Res> {
  _$StockMovementsLoadedCopyWithImpl(this._self, this._then);

  final StockMovementsLoaded _self;
  final $Res Function(StockMovementsLoaded) _then;

/// Create a copy of StockMovementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? total = null,Object? skip = null,Object? limit = null,Object? productId = freezed,Object? branchId = freezed,Object? isLoadingMore = null,}) {
  return _then(StockMovementsLoaded(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<StockMovementRow>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class StockMovementsError implements StockMovementsState {
  const StockMovementsError(this.message);
  

 final  String message;

/// Create a copy of StockMovementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementsErrorCopyWith<StockMovementsError> get copyWith => _$StockMovementsErrorCopyWithImpl<StockMovementsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'StockMovementsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $StockMovementsErrorCopyWith<$Res> implements $StockMovementsStateCopyWith<$Res> {
  factory $StockMovementsErrorCopyWith(StockMovementsError value, $Res Function(StockMovementsError) _then) = _$StockMovementsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StockMovementsErrorCopyWithImpl<$Res>
    implements $StockMovementsErrorCopyWith<$Res> {
  _$StockMovementsErrorCopyWithImpl(this._self, this._then);

  final StockMovementsError _self;
  final $Res Function(StockMovementsError) _then;

/// Create a copy of StockMovementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StockMovementsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
