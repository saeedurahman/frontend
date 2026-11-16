// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_notifications_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedNotificationsModel {

@JsonKey(fromJson: JsonNum.intOr) int get total;@JsonKey(name: 'unread_count', fromJson: JsonNum.intOr) int get unreadCount;@JsonKey(fromJson: JsonNum.intOr) int get skip;@JsonKey(fromJson: JsonNum.intOr) int get limit; List<NotificationModel> get items;
/// Create a copy of PaginatedNotificationsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedNotificationsModelCopyWith<PaginatedNotificationsModel> get copyWith => _$PaginatedNotificationsModelCopyWithImpl<PaginatedNotificationsModel>(this as PaginatedNotificationsModel, _$identity);

  /// Serializes this PaginatedNotificationsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaginatedNotificationsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedNotificationsModel&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaginatedNotificationsModel;
  return Object.hash(runtimeType,_this.total,_this.unreadCount,_this.skip,_this.limit,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PaginatedNotificationsModel;
  return 'PaginatedNotificationsModel(total: ${_this.total}, unreadCount: ${_this.unreadCount}, skip: ${_this.skip}, limit: ${_this.limit}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PaginatedNotificationsModelCopyWith<$Res>  {
  factory $PaginatedNotificationsModelCopyWith(PaginatedNotificationsModel value, $Res Function(PaginatedNotificationsModel) _then) = _$PaginatedNotificationsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(name: 'unread_count', fromJson: JsonNum.intOr) int unreadCount,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<NotificationModel> items
});




}
/// @nodoc
class _$PaginatedNotificationsModelCopyWithImpl<$Res>
    implements $PaginatedNotificationsModelCopyWith<$Res> {
  _$PaginatedNotificationsModelCopyWithImpl(this._self, this._then);

  final PaginatedNotificationsModel _self;
  final $Res Function(PaginatedNotificationsModel) _then;

/// Create a copy of PaginatedNotificationsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? unreadCount = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(PaginatedNotificationsModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedNotificationsModel].
extension PaginatedNotificationsModelPatterns on PaginatedNotificationsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedNotificationsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedNotificationsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedNotificationsModel value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedNotificationsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedNotificationsModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedNotificationsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(name: 'unread_count', fromJson: JsonNum.intOr)  int unreadCount, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<NotificationModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedNotificationsModel() when $default != null:
return $default(_that.total,_that.unreadCount,_that.skip,_that.limit,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(name: 'unread_count', fromJson: JsonNum.intOr)  int unreadCount, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<NotificationModel> items)  $default,) {final _that = this;
switch (_that) {
case _PaginatedNotificationsModel():
return $default(_that.total,_that.unreadCount,_that.skip,_that.limit,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(name: 'unread_count', fromJson: JsonNum.intOr)  int unreadCount, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<NotificationModel> items)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedNotificationsModel() when $default != null:
return $default(_that.total,_that.unreadCount,_that.skip,_that.limit,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedNotificationsModel implements PaginatedNotificationsModel {
  const _PaginatedNotificationsModel({@JsonKey(fromJson: JsonNum.intOr) required this.total, @JsonKey(name: 'unread_count', fromJson: JsonNum.intOr) required this.unreadCount, @JsonKey(fromJson: JsonNum.intOr) required this.skip, @JsonKey(fromJson: JsonNum.intOr) required this.limit,  List<NotificationModel> items = const []}): _items = items;
  factory _PaginatedNotificationsModel.fromJson(Map<String, dynamic> json) => _$PaginatedNotificationsModelFromJson(json);

@override@JsonKey(fromJson: JsonNum.intOr) final  int total;
@override@JsonKey(name: 'unread_count', fromJson: JsonNum.intOr) final  int unreadCount;
@override@JsonKey(fromJson: JsonNum.intOr) final  int skip;
@override@JsonKey(fromJson: JsonNum.intOr) final  int limit;
 final  List<NotificationModel> _items;
@override@JsonKey() List<NotificationModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PaginatedNotificationsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedNotificationsModelCopyWith<_PaginatedNotificationsModel> get copyWith => __$PaginatedNotificationsModelCopyWithImpl<_PaginatedNotificationsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedNotificationsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedNotificationsModel&&(identical(other.total, total) || other.total == total)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,unreadCount,skip,limit,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PaginatedNotificationsModel(total: $total, unreadCount: $unreadCount, skip: $skip, limit: $limit, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PaginatedNotificationsModelCopyWith<$Res> implements $PaginatedNotificationsModelCopyWith<$Res> {
  factory _$PaginatedNotificationsModelCopyWith(_PaginatedNotificationsModel value, $Res Function(_PaginatedNotificationsModel) _then) = __$PaginatedNotificationsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(name: 'unread_count', fromJson: JsonNum.intOr) int unreadCount,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<NotificationModel> items
});




}
/// @nodoc
class __$PaginatedNotificationsModelCopyWithImpl<$Res>
    implements _$PaginatedNotificationsModelCopyWith<$Res> {
  __$PaginatedNotificationsModelCopyWithImpl(this._self, this._then);

  final _PaginatedNotificationsModel _self;
  final $Res Function(_PaginatedNotificationsModel) _then;

/// Create a copy of PaginatedNotificationsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? unreadCount = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(_PaginatedNotificationsModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,
  ));
}


}

// dart format on
