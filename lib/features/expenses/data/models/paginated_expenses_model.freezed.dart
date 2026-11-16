// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_expenses_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedExpensesModel {

@JsonKey(fromJson: JsonNum.intOr) int get total;@JsonKey(fromJson: JsonNum.intOr) int get skip;@JsonKey(fromJson: JsonNum.intOr) int get limit; List<ExpenseListItemModel> get items;
/// Create a copy of PaginatedExpensesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedExpensesModelCopyWith<PaginatedExpensesModel> get copyWith => _$PaginatedExpensesModelCopyWithImpl<PaginatedExpensesModel>(this as PaginatedExpensesModel, _$identity);

  /// Serializes this PaginatedExpensesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaginatedExpensesModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedExpensesModel&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaginatedExpensesModel;
  return Object.hash(runtimeType,_this.total,_this.skip,_this.limit,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PaginatedExpensesModel;
  return 'PaginatedExpensesModel(total: ${_this.total}, skip: ${_this.skip}, limit: ${_this.limit}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PaginatedExpensesModelCopyWith<$Res>  {
  factory $PaginatedExpensesModelCopyWith(PaginatedExpensesModel value, $Res Function(PaginatedExpensesModel) _then) = _$PaginatedExpensesModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<ExpenseListItemModel> items
});




}
/// @nodoc
class _$PaginatedExpensesModelCopyWithImpl<$Res>
    implements $PaginatedExpensesModelCopyWith<$Res> {
  _$PaginatedExpensesModelCopyWithImpl(this._self, this._then);

  final PaginatedExpensesModel _self;
  final $Res Function(PaginatedExpensesModel) _then;

/// Create a copy of PaginatedExpensesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(PaginatedExpensesModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ExpenseListItemModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedExpensesModel].
extension PaginatedExpensesModelPatterns on PaginatedExpensesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedExpensesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedExpensesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedExpensesModel value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedExpensesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedExpensesModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedExpensesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<ExpenseListItemModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedExpensesModel() when $default != null:
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<ExpenseListItemModel> items)  $default,) {final _that = this;
switch (_that) {
case _PaginatedExpensesModel():
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<ExpenseListItemModel> items)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedExpensesModel() when $default != null:
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedExpensesModel implements PaginatedExpensesModel {
  const _PaginatedExpensesModel({@JsonKey(fromJson: JsonNum.intOr) required this.total, @JsonKey(fromJson: JsonNum.intOr) required this.skip, @JsonKey(fromJson: JsonNum.intOr) required this.limit,  List<ExpenseListItemModel> items = const []}): _items = items;
  factory _PaginatedExpensesModel.fromJson(Map<String, dynamic> json) => _$PaginatedExpensesModelFromJson(json);

@override@JsonKey(fromJson: JsonNum.intOr) final  int total;
@override@JsonKey(fromJson: JsonNum.intOr) final  int skip;
@override@JsonKey(fromJson: JsonNum.intOr) final  int limit;
 final  List<ExpenseListItemModel> _items;
@override@JsonKey() List<ExpenseListItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PaginatedExpensesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedExpensesModelCopyWith<_PaginatedExpensesModel> get copyWith => __$PaginatedExpensesModelCopyWithImpl<_PaginatedExpensesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedExpensesModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedExpensesModel&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,skip,limit,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PaginatedExpensesModel(total: $total, skip: $skip, limit: $limit, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PaginatedExpensesModelCopyWith<$Res> implements $PaginatedExpensesModelCopyWith<$Res> {
  factory _$PaginatedExpensesModelCopyWith(_PaginatedExpensesModel value, $Res Function(_PaginatedExpensesModel) _then) = __$PaginatedExpensesModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<ExpenseListItemModel> items
});




}
/// @nodoc
class __$PaginatedExpensesModelCopyWithImpl<$Res>
    implements _$PaginatedExpensesModelCopyWith<$Res> {
  __$PaginatedExpensesModelCopyWithImpl(this._self, this._then);

  final _PaginatedExpensesModel _self;
  final $Res Function(_PaginatedExpensesModel) _then;

/// Create a copy of PaginatedExpensesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(_PaginatedExpensesModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExpenseListItemModel>,
  ));
}


}

// dart format on
