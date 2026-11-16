// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifier_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModifierModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'modifier_group_id') String get modifierGroupId; String get name;@JsonKey(name: 'price_delta') String get priceDelta;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int get sortOrder;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of ModifierModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModifierModelCopyWith<ModifierModel> get copyWith => _$ModifierModelCopyWithImpl<ModifierModel>(this as ModifierModel, _$identity);

  /// Serializes this ModifierModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ModifierModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifierModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.modifierGroupId, _this.modifierGroupId) || other.modifierGroupId == _this.modifierGroupId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceDelta, _this.priceDelta) || other.priceDelta == _this.priceDelta)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ModifierModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.modifierGroupId,_this.name,_this.priceDelta,_this.isActive,_this.sortOrder,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as ModifierModel;
  return 'ModifierModel(id: ${_this.id}, businessId: ${_this.businessId}, modifierGroupId: ${_this.modifierGroupId}, name: ${_this.name}, priceDelta: ${_this.priceDelta}, isActive: ${_this.isActive}, sortOrder: ${_this.sortOrder}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ModifierModelCopyWith<$Res>  {
  factory $ModifierModelCopyWith(ModifierModel value, $Res Function(ModifierModel) _then) = _$ModifierModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'modifier_group_id') String modifierGroupId, String name,@JsonKey(name: 'price_delta') String priceDelta,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$ModifierModelCopyWithImpl<$Res>
    implements $ModifierModelCopyWith<$Res> {
  _$ModifierModelCopyWithImpl(this._self, this._then);

  final ModifierModel _self;
  final $Res Function(ModifierModel) _then;

/// Create a copy of ModifierModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? modifierGroupId = null,Object? name = null,Object? priceDelta = null,Object? isActive = null,Object? sortOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(ModifierModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModifierModel].
extension ModifierModelPatterns on ModifierModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModifierModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModifierModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModifierModel value)  $default,){
final _that = this;
switch (_that) {
case _ModifierModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModifierModel value)?  $default,){
final _that = this;
switch (_that) {
case _ModifierModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'modifier_group_id')  String modifierGroupId,  String name, @JsonKey(name: 'price_delta')  String priceDelta, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModifierModel() when $default != null:
return $default(_that.id,_that.businessId,_that.modifierGroupId,_that.name,_that.priceDelta,_that.isActive,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'modifier_group_id')  String modifierGroupId,  String name, @JsonKey(name: 'price_delta')  String priceDelta, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ModifierModel():
return $default(_that.id,_that.businessId,_that.modifierGroupId,_that.name,_that.priceDelta,_that.isActive,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'modifier_group_id')  String modifierGroupId,  String name, @JsonKey(name: 'price_delta')  String priceDelta, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ModifierModel() when $default != null:
return $default(_that.id,_that.businessId,_that.modifierGroupId,_that.name,_that.priceDelta,_that.isActive,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModifierModel implements ModifierModel {
  const _ModifierModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'modifier_group_id') required this.modifierGroupId, required this.name, @JsonKey(name: 'price_delta') this.priceDelta = '0', @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) this.sortOrder = 0, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ModifierModel.fromJson(Map<String, dynamic> json) => _$ModifierModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'modifier_group_id') final  String modifierGroupId;
@override final  String name;
@override@JsonKey(name: 'price_delta') final  String priceDelta;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) final  int sortOrder;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of ModifierModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModifierModelCopyWith<_ModifierModel> get copyWith => __$ModifierModelCopyWithImpl<_ModifierModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModifierModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModifierModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.modifierGroupId, modifierGroupId) || other.modifierGroupId == modifierGroupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceDelta, priceDelta) || other.priceDelta == priceDelta)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,modifierGroupId,name,priceDelta,isActive,sortOrder,createdAt,updatedAt);
}

@override
String toString() {
    return 'ModifierModel(id: $id, businessId: $businessId, modifierGroupId: $modifierGroupId, name: $name, priceDelta: $priceDelta, isActive: $isActive, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ModifierModelCopyWith<$Res> implements $ModifierModelCopyWith<$Res> {
  factory _$ModifierModelCopyWith(_ModifierModel value, $Res Function(_ModifierModel) _then) = __$ModifierModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'modifier_group_id') String modifierGroupId, String name,@JsonKey(name: 'price_delta') String priceDelta,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$ModifierModelCopyWithImpl<$Res>
    implements _$ModifierModelCopyWith<$Res> {
  __$ModifierModelCopyWithImpl(this._self, this._then);

  final _ModifierModel _self;
  final $Res Function(_ModifierModel) _then;

/// Create a copy of ModifierModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? modifierGroupId = null,Object? name = null,Object? priceDelta = null,Object? isActive = null,Object? sortOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ModifierModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,modifierGroupId: null == modifierGroupId ? _self.modifierGroupId : modifierGroupId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ModifierGroupModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name;@JsonKey(name: 'selection_type') String get selectionType;@JsonKey(name: 'min_selections', fromJson: JsonNum.intOr) int get minSelections;@JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull) int? get maxSelections;@JsonKey(name: 'is_required') bool get isRequired;@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(fromJson: _modifierListFromJson) List<ModifierModel> get modifiers;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of ModifierGroupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModifierGroupModelCopyWith<ModifierGroupModel> get copyWith => _$ModifierGroupModelCopyWithImpl<ModifierGroupModel>(this as ModifierGroupModel, _$identity);

  /// Serializes this ModifierGroupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ModifierGroupModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifierGroupModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.selectionType, _this.selectionType) || other.selectionType == _this.selectionType)&&(identical(other.minSelections, _this.minSelections) || other.minSelections == _this.minSelections)&&(identical(other.maxSelections, _this.maxSelections) || other.maxSelections == _this.maxSelections)&&(identical(other.isRequired, _this.isRequired) || other.isRequired == _this.isRequired)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&const DeepCollectionEquality().equals(other.modifiers, _this.modifiers)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ModifierGroupModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.selectionType,_this.minSelections,_this.maxSelections,_this.isRequired,_this.sortOrder,_this.isActive,const DeepCollectionEquality().hash(_this.modifiers),_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as ModifierGroupModel;
  return 'ModifierGroupModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, selectionType: ${_this.selectionType}, minSelections: ${_this.minSelections}, maxSelections: ${_this.maxSelections}, isRequired: ${_this.isRequired}, sortOrder: ${_this.sortOrder}, isActive: ${_this.isActive}, modifiers: ${_this.modifiers}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ModifierGroupModelCopyWith<$Res>  {
  factory $ModifierGroupModelCopyWith(ModifierGroupModel value, $Res Function(ModifierGroupModel) _then) = _$ModifierGroupModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'selection_type') String selectionType,@JsonKey(name: 'min_selections', fromJson: JsonNum.intOr) int minSelections,@JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull) int? maxSelections,@JsonKey(name: 'is_required') bool isRequired,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(fromJson: _modifierListFromJson) List<ModifierModel> modifiers,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$ModifierGroupModelCopyWithImpl<$Res>
    implements $ModifierGroupModelCopyWith<$Res> {
  _$ModifierGroupModelCopyWithImpl(this._self, this._then);

  final ModifierGroupModel _self;
  final $Res Function(ModifierGroupModel) _then;

/// Create a copy of ModifierGroupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? selectionType = null,Object? minSelections = null,Object? maxSelections = freezed,Object? isRequired = null,Object? sortOrder = null,Object? isActive = null,Object? modifiers = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(ModifierGroupModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,selectionType: null == selectionType ? _self.selectionType : selectionType // ignore: cast_nullable_to_non_nullable
as String,minSelections: null == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<ModifierModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModifierGroupModel].
extension ModifierGroupModelPatterns on ModifierGroupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModifierGroupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModifierGroupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModifierGroupModel value)  $default,){
final _that = this;
switch (_that) {
case _ModifierGroupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModifierGroupModel value)?  $default,){
final _that = this;
switch (_that) {
case _ModifierGroupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'selection_type')  String selectionType, @JsonKey(name: 'min_selections', fromJson: JsonNum.intOr)  int minSelections, @JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull)  int? maxSelections, @JsonKey(name: 'is_required')  bool isRequired, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(fromJson: _modifierListFromJson)  List<ModifierModel> modifiers, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModifierGroupModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.selectionType,_that.minSelections,_that.maxSelections,_that.isRequired,_that.sortOrder,_that.isActive,_that.modifiers,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'selection_type')  String selectionType, @JsonKey(name: 'min_selections', fromJson: JsonNum.intOr)  int minSelections, @JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull)  int? maxSelections, @JsonKey(name: 'is_required')  bool isRequired, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(fromJson: _modifierListFromJson)  List<ModifierModel> modifiers, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ModifierGroupModel():
return $default(_that.id,_that.businessId,_that.name,_that.selectionType,_that.minSelections,_that.maxSelections,_that.isRequired,_that.sortOrder,_that.isActive,_that.modifiers,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'selection_type')  String selectionType, @JsonKey(name: 'min_selections', fromJson: JsonNum.intOr)  int minSelections, @JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull)  int? maxSelections, @JsonKey(name: 'is_required')  bool isRequired, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(fromJson: _modifierListFromJson)  List<ModifierModel> modifiers, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ModifierGroupModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.selectionType,_that.minSelections,_that.maxSelections,_that.isRequired,_that.sortOrder,_that.isActive,_that.modifiers,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModifierGroupModel implements ModifierGroupModel {
  const _ModifierGroupModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, @JsonKey(name: 'selection_type') required this.selectionType, @JsonKey(name: 'min_selections', fromJson: JsonNum.intOr) this.minSelections = 0, @JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull) this.maxSelections, @JsonKey(name: 'is_required') this.isRequired = false, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(fromJson: _modifierListFromJson)  List<ModifierModel> modifiers = const [], @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _modifiers = modifiers;
  factory _ModifierGroupModel.fromJson(Map<String, dynamic> json) => _$ModifierGroupModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override@JsonKey(name: 'selection_type') final  String selectionType;
@override@JsonKey(name: 'min_selections', fromJson: JsonNum.intOr) final  int minSelections;
@override@JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull) final  int? maxSelections;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  List<ModifierModel> _modifiers;
@override@JsonKey(fromJson: _modifierListFromJson) List<ModifierModel> get modifiers {
  if (_modifiers is EqualUnmodifiableListView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiers);
}

@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of ModifierGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModifierGroupModelCopyWith<_ModifierGroupModel> get copyWith => __$ModifierGroupModelCopyWithImpl<_ModifierGroupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModifierGroupModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModifierGroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.selectionType, selectionType) || other.selectionType == selectionType)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.modifiers, _modifiers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,selectionType,minSelections,maxSelections,isRequired,sortOrder,isActive,const DeepCollectionEquality().hash(_modifiers),createdAt,updatedAt);
}

@override
String toString() {
    return 'ModifierGroupModel(id: $id, businessId: $businessId, name: $name, selectionType: $selectionType, minSelections: $minSelections, maxSelections: $maxSelections, isRequired: $isRequired, sortOrder: $sortOrder, isActive: $isActive, modifiers: $modifiers, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ModifierGroupModelCopyWith<$Res> implements $ModifierGroupModelCopyWith<$Res> {
  factory _$ModifierGroupModelCopyWith(_ModifierGroupModel value, $Res Function(_ModifierGroupModel) _then) = __$ModifierGroupModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'selection_type') String selectionType,@JsonKey(name: 'min_selections', fromJson: JsonNum.intOr) int minSelections,@JsonKey(name: 'max_selections', fromJson: JsonNum.intOrNull) int? maxSelections,@JsonKey(name: 'is_required') bool isRequired,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(fromJson: _modifierListFromJson) List<ModifierModel> modifiers,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$ModifierGroupModelCopyWithImpl<$Res>
    implements _$ModifierGroupModelCopyWith<$Res> {
  __$ModifierGroupModelCopyWithImpl(this._self, this._then);

  final _ModifierGroupModel _self;
  final $Res Function(_ModifierGroupModel) _then;

/// Create a copy of ModifierGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? selectionType = null,Object? minSelections = null,Object? maxSelections = freezed,Object? isRequired = null,Object? sortOrder = null,Object? isActive = null,Object? modifiers = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ModifierGroupModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,selectionType: null == selectionType ? _self.selectionType : selectionType // ignore: cast_nullable_to_non_nullable
as String,minSelections: null == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<ModifierModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
