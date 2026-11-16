// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_sales_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedSalesModel {

@JsonKey(fromJson: JsonNum.intOr) int get total;@JsonKey(fromJson: JsonNum.intOr) int get skip;@JsonKey(fromJson: JsonNum.intOr) int get limit; List<SaleListItemModel> get items;
/// Create a copy of PaginatedSalesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedSalesModelCopyWith<PaginatedSalesModel> get copyWith => _$PaginatedSalesModelCopyWithImpl<PaginatedSalesModel>(this as PaginatedSalesModel, _$identity);

  /// Serializes this PaginatedSalesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaginatedSalesModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedSalesModel&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaginatedSalesModel;
  return Object.hash(runtimeType,_this.total,_this.skip,_this.limit,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PaginatedSalesModel;
  return 'PaginatedSalesModel(total: ${_this.total}, skip: ${_this.skip}, limit: ${_this.limit}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PaginatedSalesModelCopyWith<$Res>  {
  factory $PaginatedSalesModelCopyWith(PaginatedSalesModel value, $Res Function(PaginatedSalesModel) _then) = _$PaginatedSalesModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<SaleListItemModel> items
});




}
/// @nodoc
class _$PaginatedSalesModelCopyWithImpl<$Res>
    implements $PaginatedSalesModelCopyWith<$Res> {
  _$PaginatedSalesModelCopyWithImpl(this._self, this._then);

  final PaginatedSalesModel _self;
  final $Res Function(PaginatedSalesModel) _then;

/// Create a copy of PaginatedSalesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(PaginatedSalesModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleListItemModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedSalesModel].
extension PaginatedSalesModelPatterns on PaginatedSalesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedSalesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedSalesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedSalesModel value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedSalesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedSalesModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedSalesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<SaleListItemModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedSalesModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<SaleListItemModel> items)  $default,) {final _that = this;
switch (_that) {
case _PaginatedSalesModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<SaleListItemModel> items)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedSalesModel() when $default != null:
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedSalesModel implements PaginatedSalesModel {
  const _PaginatedSalesModel({@JsonKey(fromJson: JsonNum.intOr) required this.total, @JsonKey(fromJson: JsonNum.intOr) required this.skip, @JsonKey(fromJson: JsonNum.intOr) required this.limit,  List<SaleListItemModel> items = const []}): _items = items;
  factory _PaginatedSalesModel.fromJson(Map<String, dynamic> json) => _$PaginatedSalesModelFromJson(json);

@override@JsonKey(fromJson: JsonNum.intOr) final  int total;
@override@JsonKey(fromJson: JsonNum.intOr) final  int skip;
@override@JsonKey(fromJson: JsonNum.intOr) final  int limit;
 final  List<SaleListItemModel> _items;
@override@JsonKey() List<SaleListItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PaginatedSalesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedSalesModelCopyWith<_PaginatedSalesModel> get copyWith => __$PaginatedSalesModelCopyWithImpl<_PaginatedSalesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedSalesModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedSalesModel&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,skip,limit,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PaginatedSalesModel(total: $total, skip: $skip, limit: $limit, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PaginatedSalesModelCopyWith<$Res> implements $PaginatedSalesModelCopyWith<$Res> {
  factory _$PaginatedSalesModelCopyWith(_PaginatedSalesModel value, $Res Function(_PaginatedSalesModel) _then) = __$PaginatedSalesModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<SaleListItemModel> items
});




}
/// @nodoc
class __$PaginatedSalesModelCopyWithImpl<$Res>
    implements _$PaginatedSalesModelCopyWith<$Res> {
  __$PaginatedSalesModelCopyWithImpl(this._self, this._then);

  final _PaginatedSalesModel _self;
  final $Res Function(_PaginatedSalesModel) _then;

/// Create a copy of PaginatedSalesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(_PaginatedSalesModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleListItemModel>,
  ));
}


}

// dart format on
