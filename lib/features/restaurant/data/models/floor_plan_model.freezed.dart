// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floor_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FloorPlanModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId; String get name;@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> get layoutJson;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of FloorPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorPlanModelCopyWith<FloorPlanModel> get copyWith => _$FloorPlanModelCopyWithImpl<FloorPlanModel>(this as FloorPlanModel, _$identity);

  /// Serializes this FloorPlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FloorPlanModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorPlanModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&const DeepCollectionEquality().equals(other.layoutJson, _this.layoutJson)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FloorPlanModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.name,_this.sortOrder,_this.isActive,const DeepCollectionEquality().hash(_this.layoutJson),_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FloorPlanModel;
  return 'FloorPlanModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, name: ${_this.name}, sortOrder: ${_this.sortOrder}, isActive: ${_this.isActive}, layoutJson: ${_this.layoutJson}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FloorPlanModelCopyWith<$Res>  {
  factory $FloorPlanModelCopyWith(FloorPlanModel value, $Res Function(FloorPlanModel) _then) = _$FloorPlanModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId, String name,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> layoutJson,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$FloorPlanModelCopyWithImpl<$Res>
    implements $FloorPlanModelCopyWith<$Res> {
  _$FloorPlanModelCopyWithImpl(this._self, this._then);

  final FloorPlanModel _self;
  final $Res Function(FloorPlanModel) _then;

/// Create a copy of FloorPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? name = null,Object? sortOrder = null,Object? isActive = null,Object? layoutJson = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(FloorPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,layoutJson: null == layoutJson ? _self.layoutJson : layoutJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FloorPlanModel].
extension FloorPlanModelPatterns on FloorPlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorPlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorPlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorPlanModel value)  $default,){
final _that = this;
switch (_that) {
case _FloorPlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorPlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _FloorPlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorPlanModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.name,_that.sortOrder,_that.isActive,_that.layoutJson,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FloorPlanModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.name,_that.sortOrder,_that.isActive,_that.layoutJson,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FloorPlanModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.name,_that.sortOrder,_that.isActive,_that.layoutJson,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FloorPlanModel implements FloorPlanModel {
  const _FloorPlanModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, required this.name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson = const {}, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _layoutJson = layoutJson;
  factory _FloorPlanModel.fromJson(Map<String, dynamic> json) => _$FloorPlanModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override final  String name;
@override@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  Map<String, dynamic> _layoutJson;
@override@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> get layoutJson {
  if (_layoutJson is EqualUnmodifiableMapView) return _layoutJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_layoutJson);
}

@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of FloorPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorPlanModelCopyWith<_FloorPlanModel> get copyWith => __$FloorPlanModelCopyWithImpl<_FloorPlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FloorPlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.layoutJson, _layoutJson)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,name,sortOrder,isActive,const DeepCollectionEquality().hash(_layoutJson),createdAt,updatedAt);
}

@override
String toString() {
    return 'FloorPlanModel(id: $id, businessId: $businessId, branchId: $branchId, name: $name, sortOrder: $sortOrder, isActive: $isActive, layoutJson: $layoutJson, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FloorPlanModelCopyWith<$Res> implements $FloorPlanModelCopyWith<$Res> {
  factory _$FloorPlanModelCopyWith(_FloorPlanModel value, $Res Function(_FloorPlanModel) _then) = __$FloorPlanModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId, String name,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> layoutJson,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$FloorPlanModelCopyWithImpl<$Res>
    implements _$FloorPlanModelCopyWith<$Res> {
  __$FloorPlanModelCopyWithImpl(this._self, this._then);

  final _FloorPlanModel _self;
  final $Res Function(_FloorPlanModel) _then;

/// Create a copy of FloorPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? name = null,Object? sortOrder = null,Object? isActive = null,Object? layoutJson = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_FloorPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,layoutJson: null == layoutJson ? _self._layoutJson : layoutJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FloorPlanWithTablesModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId; String get name;@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> get layoutJson;@JsonKey(fromJson: _diningTableListFromJson) List<DiningTableModel> get tables;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of FloorPlanWithTablesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorPlanWithTablesModelCopyWith<FloorPlanWithTablesModel> get copyWith => _$FloorPlanWithTablesModelCopyWithImpl<FloorPlanWithTablesModel>(this as FloorPlanWithTablesModel, _$identity);

  /// Serializes this FloorPlanWithTablesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FloorPlanWithTablesModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorPlanWithTablesModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&const DeepCollectionEquality().equals(other.layoutJson, _this.layoutJson)&&const DeepCollectionEquality().equals(other.tables, _this.tables)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FloorPlanWithTablesModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.name,_this.sortOrder,_this.isActive,const DeepCollectionEquality().hash(_this.layoutJson),const DeepCollectionEquality().hash(_this.tables),_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FloorPlanWithTablesModel;
  return 'FloorPlanWithTablesModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, name: ${_this.name}, sortOrder: ${_this.sortOrder}, isActive: ${_this.isActive}, layoutJson: ${_this.layoutJson}, tables: ${_this.tables}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FloorPlanWithTablesModelCopyWith<$Res>  {
  factory $FloorPlanWithTablesModelCopyWith(FloorPlanWithTablesModel value, $Res Function(FloorPlanWithTablesModel) _then) = _$FloorPlanWithTablesModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId, String name,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> layoutJson,@JsonKey(fromJson: _diningTableListFromJson) List<DiningTableModel> tables,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$FloorPlanWithTablesModelCopyWithImpl<$Res>
    implements $FloorPlanWithTablesModelCopyWith<$Res> {
  _$FloorPlanWithTablesModelCopyWithImpl(this._self, this._then);

  final FloorPlanWithTablesModel _self;
  final $Res Function(FloorPlanWithTablesModel) _then;

/// Create a copy of FloorPlanWithTablesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? name = null,Object? sortOrder = null,Object? isActive = null,Object? layoutJson = null,Object? tables = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(FloorPlanWithTablesModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,layoutJson: null == layoutJson ? _self.layoutJson : layoutJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as List<DiningTableModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FloorPlanWithTablesModel].
extension FloorPlanWithTablesModelPatterns on FloorPlanWithTablesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorPlanWithTablesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorPlanWithTablesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorPlanWithTablesModel value)  $default,){
final _that = this;
switch (_that) {
case _FloorPlanWithTablesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorPlanWithTablesModel value)?  $default,){
final _that = this;
switch (_that) {
case _FloorPlanWithTablesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson, @JsonKey(fromJson: _diningTableListFromJson)  List<DiningTableModel> tables, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorPlanWithTablesModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.name,_that.sortOrder,_that.isActive,_that.layoutJson,_that.tables,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson, @JsonKey(fromJson: _diningTableListFromJson)  List<DiningTableModel> tables, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FloorPlanWithTablesModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.name,_that.sortOrder,_that.isActive,_that.layoutJson,_that.tables,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId,  String name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson, @JsonKey(fromJson: _diningTableListFromJson)  List<DiningTableModel> tables, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FloorPlanWithTablesModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.name,_that.sortOrder,_that.isActive,_that.layoutJson,_that.tables,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FloorPlanWithTablesModel implements FloorPlanWithTablesModel {
  const _FloorPlanWithTablesModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, required this.name, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)  Map<String, dynamic> layoutJson = const {}, @JsonKey(fromJson: _diningTableListFromJson)  List<DiningTableModel> tables = const [], @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _layoutJson = layoutJson,_tables = tables;
  factory _FloorPlanWithTablesModel.fromJson(Map<String, dynamic> json) => _$FloorPlanWithTablesModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override final  String name;
@override@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  Map<String, dynamic> _layoutJson;
@override@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> get layoutJson {
  if (_layoutJson is EqualUnmodifiableMapView) return _layoutJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_layoutJson);
}

 final  List<DiningTableModel> _tables;
@override@JsonKey(fromJson: _diningTableListFromJson) List<DiningTableModel> get tables {
  if (_tables is EqualUnmodifiableListView) return _tables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tables);
}

@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of FloorPlanWithTablesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorPlanWithTablesModelCopyWith<_FloorPlanWithTablesModel> get copyWith => __$FloorPlanWithTablesModelCopyWithImpl<_FloorPlanWithTablesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FloorPlanWithTablesModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorPlanWithTablesModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.layoutJson, _layoutJson)&&const DeepCollectionEquality().equals(other.tables, _tables)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,name,sortOrder,isActive,const DeepCollectionEquality().hash(_layoutJson),const DeepCollectionEquality().hash(_tables),createdAt,updatedAt);
}

@override
String toString() {
    return 'FloorPlanWithTablesModel(id: $id, businessId: $businessId, branchId: $branchId, name: $name, sortOrder: $sortOrder, isActive: $isActive, layoutJson: $layoutJson, tables: $tables, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FloorPlanWithTablesModelCopyWith<$Res> implements $FloorPlanWithTablesModelCopyWith<$Res> {
  factory _$FloorPlanWithTablesModelCopyWith(_FloorPlanWithTablesModel value, $Res Function(_FloorPlanWithTablesModel) _then) = __$FloorPlanWithTablesModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId, String name,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson) Map<String, dynamic> layoutJson,@JsonKey(fromJson: _diningTableListFromJson) List<DiningTableModel> tables,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$FloorPlanWithTablesModelCopyWithImpl<$Res>
    implements _$FloorPlanWithTablesModelCopyWith<$Res> {
  __$FloorPlanWithTablesModelCopyWithImpl(this._self, this._then);

  final _FloorPlanWithTablesModel _self;
  final $Res Function(_FloorPlanWithTablesModel) _then;

/// Create a copy of FloorPlanWithTablesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? name = null,Object? sortOrder = null,Object? isActive = null,Object? layoutJson = null,Object? tables = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_FloorPlanWithTablesModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,layoutJson: null == layoutJson ? _self._layoutJson : layoutJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,tables: null == tables ? _self._tables : tables // ignore: cast_nullable_to_non_nullable
as List<DiningTableModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FloorLayoutModel {

@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson) List<FloorPlanWithTablesModel> get floorPlans;@JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson) List<DiningTableModel> get unassignedTables;
/// Create a copy of FloorLayoutModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorLayoutModelCopyWith<FloorLayoutModel> get copyWith => _$FloorLayoutModelCopyWithImpl<FloorLayoutModel>(this as FloorLayoutModel, _$identity);

  /// Serializes this FloorLayoutModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FloorLayoutModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorLayoutModel&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&const DeepCollectionEquality().equals(other.floorPlans, _this.floorPlans)&&const DeepCollectionEquality().equals(other.unassignedTables, _this.unassignedTables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FloorLayoutModel;
  return Object.hash(runtimeType,_this.branchId,const DeepCollectionEquality().hash(_this.floorPlans),const DeepCollectionEquality().hash(_this.unassignedTables));
}

@override
String toString() {
  final _this = this as FloorLayoutModel;
  return 'FloorLayoutModel(branchId: ${_this.branchId}, floorPlans: ${_this.floorPlans}, unassignedTables: ${_this.unassignedTables})';
}


}

/// @nodoc
abstract mixin class $FloorLayoutModelCopyWith<$Res>  {
  factory $FloorLayoutModelCopyWith(FloorLayoutModel value, $Res Function(FloorLayoutModel) _then) = _$FloorLayoutModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson) List<FloorPlanWithTablesModel> floorPlans,@JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson) List<DiningTableModel> unassignedTables
});




}
/// @nodoc
class _$FloorLayoutModelCopyWithImpl<$Res>
    implements $FloorLayoutModelCopyWith<$Res> {
  _$FloorLayoutModelCopyWithImpl(this._self, this._then);

  final FloorLayoutModel _self;
  final $Res Function(FloorLayoutModel) _then;

/// Create a copy of FloorLayoutModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = null,Object? floorPlans = null,Object? unassignedTables = null,}) {
  return _then(FloorLayoutModel(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,floorPlans: null == floorPlans ? _self.floorPlans : floorPlans // ignore: cast_nullable_to_non_nullable
as List<FloorPlanWithTablesModel>,unassignedTables: null == unassignedTables ? _self.unassignedTables : unassignedTables // ignore: cast_nullable_to_non_nullable
as List<DiningTableModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [FloorLayoutModel].
extension FloorLayoutModelPatterns on FloorLayoutModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorLayoutModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorLayoutModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorLayoutModel value)  $default,){
final _that = this;
switch (_that) {
case _FloorLayoutModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorLayoutModel value)?  $default,){
final _that = this;
switch (_that) {
case _FloorLayoutModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)  List<FloorPlanWithTablesModel> floorPlans, @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)  List<DiningTableModel> unassignedTables)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorLayoutModel() when $default != null:
return $default(_that.branchId,_that.floorPlans,_that.unassignedTables);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)  List<FloorPlanWithTablesModel> floorPlans, @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)  List<DiningTableModel> unassignedTables)  $default,) {final _that = this;
switch (_that) {
case _FloorLayoutModel():
return $default(_that.branchId,_that.floorPlans,_that.unassignedTables);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)  List<FloorPlanWithTablesModel> floorPlans, @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)  List<DiningTableModel> unassignedTables)?  $default,) {final _that = this;
switch (_that) {
case _FloorLayoutModel() when $default != null:
return $default(_that.branchId,_that.floorPlans,_that.unassignedTables);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FloorLayoutModel implements FloorLayoutModel {
  const _FloorLayoutModel({@JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)  List<FloorPlanWithTablesModel> floorPlans = const [], @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)  List<DiningTableModel> unassignedTables = const []}): _floorPlans = floorPlans,_unassignedTables = unassignedTables;
  factory _FloorLayoutModel.fromJson(Map<String, dynamic> json) => _$FloorLayoutModelFromJson(json);

@override@JsonKey(name: 'branch_id') final  String branchId;
 final  List<FloorPlanWithTablesModel> _floorPlans;
@override@JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson) List<FloorPlanWithTablesModel> get floorPlans {
  if (_floorPlans is EqualUnmodifiableListView) return _floorPlans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_floorPlans);
}

 final  List<DiningTableModel> _unassignedTables;
@override@JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson) List<DiningTableModel> get unassignedTables {
  if (_unassignedTables is EqualUnmodifiableListView) return _unassignedTables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unassignedTables);
}


/// Create a copy of FloorLayoutModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorLayoutModelCopyWith<_FloorLayoutModel> get copyWith => __$FloorLayoutModelCopyWithImpl<_FloorLayoutModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FloorLayoutModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorLayoutModel&&(identical(other.branchId, branchId) || other.branchId == branchId)&&const DeepCollectionEquality().equals(other.floorPlans, _floorPlans)&&const DeepCollectionEquality().equals(other.unassignedTables, _unassignedTables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,branchId,const DeepCollectionEquality().hash(_floorPlans),const DeepCollectionEquality().hash(_unassignedTables));
}

@override
String toString() {
    return 'FloorLayoutModel(branchId: $branchId, floorPlans: $floorPlans, unassignedTables: $unassignedTables)';
}


}

/// @nodoc
abstract mixin class _$FloorLayoutModelCopyWith<$Res> implements $FloorLayoutModelCopyWith<$Res> {
  factory _$FloorLayoutModelCopyWith(_FloorLayoutModel value, $Res Function(_FloorLayoutModel) _then) = __$FloorLayoutModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson) List<FloorPlanWithTablesModel> floorPlans,@JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson) List<DiningTableModel> unassignedTables
});




}
/// @nodoc
class __$FloorLayoutModelCopyWithImpl<$Res>
    implements _$FloorLayoutModelCopyWith<$Res> {
  __$FloorLayoutModelCopyWithImpl(this._self, this._then);

  final _FloorLayoutModel _self;
  final $Res Function(_FloorLayoutModel) _then;

/// Create a copy of FloorLayoutModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? floorPlans = null,Object? unassignedTables = null,}) {
  return _then(_FloorLayoutModel(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,floorPlans: null == floorPlans ? _self._floorPlans : floorPlans // ignore: cast_nullable_to_non_nullable
as List<FloorPlanWithTablesModel>,unassignedTables: null == unassignedTables ? _self._unassignedTables : unassignedTables // ignore: cast_nullable_to_non_nullable
as List<DiningTableModel>,
  ));
}


}


/// @nodoc
mixin _$DiningTableModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'floor_plan_id') String? get floorPlanId;@JsonKey(name: 'table_number') String get tableNumber;@JsonKey(fromJson: JsonNum.intOr) int get capacity; String get status;@JsonKey(name: 'pos_x') String? get posX;@JsonKey(name: 'pos_y') String? get posY;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'active_sale_id') String? get activeSaleId;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of DiningTableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiningTableModelCopyWith<DiningTableModel> get copyWith => _$DiningTableModelCopyWithImpl<DiningTableModel>(this as DiningTableModel, _$identity);

  /// Serializes this DiningTableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiningTableModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiningTableModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.floorPlanId, _this.floorPlanId) || other.floorPlanId == _this.floorPlanId)&&(identical(other.tableNumber, _this.tableNumber) || other.tableNumber == _this.tableNumber)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.posX, _this.posX) || other.posX == _this.posX)&&(identical(other.posY, _this.posY) || other.posY == _this.posY)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.activeSaleId, _this.activeSaleId) || other.activeSaleId == _this.activeSaleId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiningTableModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.floorPlanId,_this.tableNumber,_this.capacity,_this.status,_this.posX,_this.posY,_this.isActive,_this.activeSaleId,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as DiningTableModel;
  return 'DiningTableModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, floorPlanId: ${_this.floorPlanId}, tableNumber: ${_this.tableNumber}, capacity: ${_this.capacity}, status: ${_this.status}, posX: ${_this.posX}, posY: ${_this.posY}, isActive: ${_this.isActive}, activeSaleId: ${_this.activeSaleId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $DiningTableModelCopyWith<$Res>  {
  factory $DiningTableModelCopyWith(DiningTableModel value, $Res Function(DiningTableModel) _then) = _$DiningTableModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'floor_plan_id') String? floorPlanId,@JsonKey(name: 'table_number') String tableNumber,@JsonKey(fromJson: JsonNum.intOr) int capacity, String status,@JsonKey(name: 'pos_x') String? posX,@JsonKey(name: 'pos_y') String? posY,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'active_sale_id') String? activeSaleId,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$DiningTableModelCopyWithImpl<$Res>
    implements $DiningTableModelCopyWith<$Res> {
  _$DiningTableModelCopyWithImpl(this._self, this._then);

  final DiningTableModel _self;
  final $Res Function(DiningTableModel) _then;

/// Create a copy of DiningTableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? floorPlanId = freezed,Object? tableNumber = null,Object? capacity = null,Object? status = null,Object? posX = freezed,Object? posY = freezed,Object? isActive = null,Object? activeSaleId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(DiningTableModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,floorPlanId: freezed == floorPlanId ? _self.floorPlanId : floorPlanId // ignore: cast_nullable_to_non_nullable
as String?,tableNumber: null == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,posX: freezed == posX ? _self.posX : posX // ignore: cast_nullable_to_non_nullable
as String?,posY: freezed == posY ? _self.posY : posY // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activeSaleId: freezed == activeSaleId ? _self.activeSaleId : activeSaleId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiningTableModel].
extension DiningTableModelPatterns on DiningTableModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiningTableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiningTableModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiningTableModel value)  $default,){
final _that = this;
switch (_that) {
case _DiningTableModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiningTableModel value)?  $default,){
final _that = this;
switch (_that) {
case _DiningTableModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'floor_plan_id')  String? floorPlanId, @JsonKey(name: 'table_number')  String tableNumber, @JsonKey(fromJson: JsonNum.intOr)  int capacity,  String status, @JsonKey(name: 'pos_x')  String? posX, @JsonKey(name: 'pos_y')  String? posY, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'active_sale_id')  String? activeSaleId, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiningTableModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.floorPlanId,_that.tableNumber,_that.capacity,_that.status,_that.posX,_that.posY,_that.isActive,_that.activeSaleId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'floor_plan_id')  String? floorPlanId, @JsonKey(name: 'table_number')  String tableNumber, @JsonKey(fromJson: JsonNum.intOr)  int capacity,  String status, @JsonKey(name: 'pos_x')  String? posX, @JsonKey(name: 'pos_y')  String? posY, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'active_sale_id')  String? activeSaleId, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DiningTableModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.floorPlanId,_that.tableNumber,_that.capacity,_that.status,_that.posX,_that.posY,_that.isActive,_that.activeSaleId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'floor_plan_id')  String? floorPlanId, @JsonKey(name: 'table_number')  String tableNumber, @JsonKey(fromJson: JsonNum.intOr)  int capacity,  String status, @JsonKey(name: 'pos_x')  String? posX, @JsonKey(name: 'pos_y')  String? posY, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'active_sale_id')  String? activeSaleId, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DiningTableModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.floorPlanId,_that.tableNumber,_that.capacity,_that.status,_that.posX,_that.posY,_that.isActive,_that.activeSaleId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiningTableModel implements DiningTableModel {
  const _DiningTableModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'floor_plan_id') this.floorPlanId, @JsonKey(name: 'table_number') required this.tableNumber, @JsonKey(fromJson: JsonNum.intOr) this.capacity = 4, required this.status, @JsonKey(name: 'pos_x') this.posX, @JsonKey(name: 'pos_y') this.posY, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'active_sale_id') this.activeSaleId, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _DiningTableModel.fromJson(Map<String, dynamic> json) => _$DiningTableModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'floor_plan_id') final  String? floorPlanId;
@override@JsonKey(name: 'table_number') final  String tableNumber;
@override@JsonKey(fromJson: JsonNum.intOr) final  int capacity;
@override final  String status;
@override@JsonKey(name: 'pos_x') final  String? posX;
@override@JsonKey(name: 'pos_y') final  String? posY;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'active_sale_id') final  String? activeSaleId;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of DiningTableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiningTableModelCopyWith<_DiningTableModel> get copyWith => __$DiningTableModelCopyWithImpl<_DiningTableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiningTableModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiningTableModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.floorPlanId, floorPlanId) || other.floorPlanId == floorPlanId)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.status, status) || other.status == status)&&(identical(other.posX, posX) || other.posX == posX)&&(identical(other.posY, posY) || other.posY == posY)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activeSaleId, activeSaleId) || other.activeSaleId == activeSaleId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,floorPlanId,tableNumber,capacity,status,posX,posY,isActive,activeSaleId,createdAt,updatedAt);
}

@override
String toString() {
    return 'DiningTableModel(id: $id, businessId: $businessId, branchId: $branchId, floorPlanId: $floorPlanId, tableNumber: $tableNumber, capacity: $capacity, status: $status, posX: $posX, posY: $posY, isActive: $isActive, activeSaleId: $activeSaleId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DiningTableModelCopyWith<$Res> implements $DiningTableModelCopyWith<$Res> {
  factory _$DiningTableModelCopyWith(_DiningTableModel value, $Res Function(_DiningTableModel) _then) = __$DiningTableModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'floor_plan_id') String? floorPlanId,@JsonKey(name: 'table_number') String tableNumber,@JsonKey(fromJson: JsonNum.intOr) int capacity, String status,@JsonKey(name: 'pos_x') String? posX,@JsonKey(name: 'pos_y') String? posY,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'active_sale_id') String? activeSaleId,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$DiningTableModelCopyWithImpl<$Res>
    implements _$DiningTableModelCopyWith<$Res> {
  __$DiningTableModelCopyWithImpl(this._self, this._then);

  final _DiningTableModel _self;
  final $Res Function(_DiningTableModel) _then;

/// Create a copy of DiningTableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? floorPlanId = freezed,Object? tableNumber = null,Object? capacity = null,Object? status = null,Object? posX = freezed,Object? posY = freezed,Object? isActive = null,Object? activeSaleId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DiningTableModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,floorPlanId: freezed == floorPlanId ? _self.floorPlanId : floorPlanId // ignore: cast_nullable_to_non_nullable
as String?,tableNumber: null == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,posX: freezed == posX ? _self.posX : posX // ignore: cast_nullable_to_non_nullable
as String?,posY: freezed == posY ? _self.posY : posY // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activeSaleId: freezed == activeSaleId ? _self.activeSaleId : activeSaleId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
