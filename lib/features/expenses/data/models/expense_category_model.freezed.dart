// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseCategoryModel {

 String get id; String get name;@JsonKey(name: 'parent_id') String? get parentId;@JsonKey(name: 'is_active') bool get isActive; List<ExpenseCategoryModel> get children;
/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCategoryModelCopyWith<ExpenseCategoryModel> get copyWith => _$ExpenseCategoryModelCopyWithImpl<ExpenseCategoryModel>(this as ExpenseCategoryModel, _$identity);

  /// Serializes this ExpenseCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpenseCategoryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&const DeepCollectionEquality().equals(other.children, _this.children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpenseCategoryModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.parentId,_this.isActive,const DeepCollectionEquality().hash(_this.children));
}

@override
String toString() {
  final _this = this as ExpenseCategoryModel;
  return 'ExpenseCategoryModel(id: ${_this.id}, name: ${_this.name}, parentId: ${_this.parentId}, isActive: ${_this.isActive}, children: ${_this.children})';
}


}

/// @nodoc
abstract mixin class $ExpenseCategoryModelCopyWith<$Res>  {
  factory $ExpenseCategoryModelCopyWith(ExpenseCategoryModel value, $Res Function(ExpenseCategoryModel) _then) = _$ExpenseCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'is_active') bool isActive, List<ExpenseCategoryModel> children
});




}
/// @nodoc
class _$ExpenseCategoryModelCopyWithImpl<$Res>
    implements $ExpenseCategoryModelCopyWith<$Res> {
  _$ExpenseCategoryModelCopyWithImpl(this._self, this._then);

  final ExpenseCategoryModel _self;
  final $Res Function(ExpenseCategoryModel) _then;

/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? parentId = freezed,Object? isActive = null,Object? children = null,}) {
  return _then(ExpenseCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseCategoryModel].
extension ExpenseCategoryModelPatterns on ExpenseCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'is_active')  bool isActive,  List<ExpenseCategoryModel> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.parentId,_that.isActive,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'is_active')  bool isActive,  List<ExpenseCategoryModel> children)  $default,) {final _that = this;
switch (_that) {
case _ExpenseCategoryModel():
return $default(_that.id,_that.name,_that.parentId,_that.isActive,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'is_active')  bool isActive,  List<ExpenseCategoryModel> children)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.parentId,_that.isActive,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseCategoryModel implements ExpenseCategoryModel {
  const _ExpenseCategoryModel({required this.id, required this.name, @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'is_active') this.isActive = true,  List<ExpenseCategoryModel> children = const []}): _children = children;
  factory _ExpenseCategoryModel.fromJson(Map<String, dynamic> json) => _$ExpenseCategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  List<ExpenseCategoryModel> _children;
@override@JsonKey() List<ExpenseCategoryModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCategoryModelCopyWith<_ExpenseCategoryModel> get copyWith => __$ExpenseCategoryModelCopyWithImpl<_ExpenseCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,parentId,isActive,const DeepCollectionEquality().hash(_children));
}

@override
String toString() {
    return 'ExpenseCategoryModel(id: $id, name: $name, parentId: $parentId, isActive: $isActive, children: $children)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCategoryModelCopyWith<$Res> implements $ExpenseCategoryModelCopyWith<$Res> {
  factory _$ExpenseCategoryModelCopyWith(_ExpenseCategoryModel value, $Res Function(_ExpenseCategoryModel) _then) = __$ExpenseCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'is_active') bool isActive, List<ExpenseCategoryModel> children
});




}
/// @nodoc
class __$ExpenseCategoryModelCopyWithImpl<$Res>
    implements _$ExpenseCategoryModelCopyWith<$Res> {
  __$ExpenseCategoryModelCopyWithImpl(this._self, this._then);

  final _ExpenseCategoryModel _self;
  final $Res Function(_ExpenseCategoryModel) _then;

/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? parentId = freezed,Object? isActive = null,Object? children = null,}) {
  return _then(_ExpenseCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,
  ));
}


}

// dart format on
