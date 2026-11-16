// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BomLineModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'bom_header_id') String get bomHeaderId;@JsonKey(name: 'ingredient_product_id') String get ingredientProductId;@JsonKey(name: 'ingredient_product_name') String get ingredientProductName;@JsonKey(name: 'ingredient_variation_id') String? get ingredientVariationId;@JsonKey(name: 'qty_required') String get qtyRequired;@JsonKey(name: 'unit_id') String? get unitId;@JsonKey(name: 'wastage_pct') String get wastagePct;@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int get sortOrder;
/// Create a copy of BomLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomLineModelCopyWith<BomLineModel> get copyWith => _$BomLineModelCopyWithImpl<BomLineModel>(this as BomLineModel, _$identity);

  /// Serializes this BomLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BomLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BomLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.bomHeaderId, _this.bomHeaderId) || other.bomHeaderId == _this.bomHeaderId)&&(identical(other.ingredientProductId, _this.ingredientProductId) || other.ingredientProductId == _this.ingredientProductId)&&(identical(other.ingredientProductName, _this.ingredientProductName) || other.ingredientProductName == _this.ingredientProductName)&&(identical(other.ingredientVariationId, _this.ingredientVariationId) || other.ingredientVariationId == _this.ingredientVariationId)&&(identical(other.qtyRequired, _this.qtyRequired) || other.qtyRequired == _this.qtyRequired)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.wastagePct, _this.wastagePct) || other.wastagePct == _this.wastagePct)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BomLineModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.bomHeaderId,_this.ingredientProductId,_this.ingredientProductName,_this.ingredientVariationId,_this.qtyRequired,_this.unitId,_this.wastagePct,_this.sortOrder);
}

@override
String toString() {
  final _this = this as BomLineModel;
  return 'BomLineModel(id: ${_this.id}, businessId: ${_this.businessId}, bomHeaderId: ${_this.bomHeaderId}, ingredientProductId: ${_this.ingredientProductId}, ingredientProductName: ${_this.ingredientProductName}, ingredientVariationId: ${_this.ingredientVariationId}, qtyRequired: ${_this.qtyRequired}, unitId: ${_this.unitId}, wastagePct: ${_this.wastagePct}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $BomLineModelCopyWith<$Res>  {
  factory $BomLineModelCopyWith(BomLineModel value, $Res Function(BomLineModel) _then) = _$BomLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'bom_header_id') String bomHeaderId,@JsonKey(name: 'ingredient_product_id') String ingredientProductId,@JsonKey(name: 'ingredient_product_name') String ingredientProductName,@JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,@JsonKey(name: 'qty_required') String qtyRequired,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(name: 'wastage_pct') String wastagePct,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder
});




}
/// @nodoc
class _$BomLineModelCopyWithImpl<$Res>
    implements $BomLineModelCopyWith<$Res> {
  _$BomLineModelCopyWithImpl(this._self, this._then);

  final BomLineModel _self;
  final $Res Function(BomLineModel) _then;

/// Create a copy of BomLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? bomHeaderId = null,Object? ingredientProductId = null,Object? ingredientProductName = null,Object? ingredientVariationId = freezed,Object? qtyRequired = null,Object? unitId = freezed,Object? wastagePct = null,Object? sortOrder = null,}) {
  return _then(BomLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,bomHeaderId: null == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String,ingredientProductId: null == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String,ingredientProductName: null == ingredientProductName ? _self.ingredientProductName : ingredientProductName // ignore: cast_nullable_to_non_nullable
as String,ingredientVariationId: freezed == ingredientVariationId ? _self.ingredientVariationId : ingredientVariationId // ignore: cast_nullable_to_non_nullable
as String?,qtyRequired: null == qtyRequired ? _self.qtyRequired : qtyRequired // ignore: cast_nullable_to_non_nullable
as String,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,wastagePct: null == wastagePct ? _self.wastagePct : wastagePct // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BomLineModel].
extension BomLineModelPatterns on BomLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BomLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BomLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BomLineModel value)  $default,){
final _that = this;
switch (_that) {
case _BomLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BomLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _BomLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'ingredient_product_id')  String ingredientProductId, @JsonKey(name: 'ingredient_product_name')  String ingredientProductName, @JsonKey(name: 'ingredient_variation_id')  String? ingredientVariationId, @JsonKey(name: 'qty_required')  String qtyRequired, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'wastage_pct')  String wastagePct, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BomLineModel() when $default != null:
return $default(_that.id,_that.businessId,_that.bomHeaderId,_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.qtyRequired,_that.unitId,_that.wastagePct,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'ingredient_product_id')  String ingredientProductId, @JsonKey(name: 'ingredient_product_name')  String ingredientProductName, @JsonKey(name: 'ingredient_variation_id')  String? ingredientVariationId, @JsonKey(name: 'qty_required')  String qtyRequired, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'wastage_pct')  String wastagePct, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _BomLineModel():
return $default(_that.id,_that.businessId,_that.bomHeaderId,_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.qtyRequired,_that.unitId,_that.wastagePct,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'ingredient_product_id')  String ingredientProductId, @JsonKey(name: 'ingredient_product_name')  String ingredientProductName, @JsonKey(name: 'ingredient_variation_id')  String? ingredientVariationId, @JsonKey(name: 'qty_required')  String qtyRequired, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'wastage_pct')  String wastagePct, @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr)  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _BomLineModel() when $default != null:
return $default(_that.id,_that.businessId,_that.bomHeaderId,_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.qtyRequired,_that.unitId,_that.wastagePct,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BomLineModel implements BomLineModel {
  const _BomLineModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'bom_header_id') required this.bomHeaderId, @JsonKey(name: 'ingredient_product_id') required this.ingredientProductId, @JsonKey(name: 'ingredient_product_name') required this.ingredientProductName, @JsonKey(name: 'ingredient_variation_id') this.ingredientVariationId, @JsonKey(name: 'qty_required') required this.qtyRequired, @JsonKey(name: 'unit_id') this.unitId, @JsonKey(name: 'wastage_pct') this.wastagePct = '0', @JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) this.sortOrder = 0});
  factory _BomLineModel.fromJson(Map<String, dynamic> json) => _$BomLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'bom_header_id') final  String bomHeaderId;
@override@JsonKey(name: 'ingredient_product_id') final  String ingredientProductId;
@override@JsonKey(name: 'ingredient_product_name') final  String ingredientProductName;
@override@JsonKey(name: 'ingredient_variation_id') final  String? ingredientVariationId;
@override@JsonKey(name: 'qty_required') final  String qtyRequired;
@override@JsonKey(name: 'unit_id') final  String? unitId;
@override@JsonKey(name: 'wastage_pct') final  String wastagePct;
@override@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) final  int sortOrder;

/// Create a copy of BomLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BomLineModelCopyWith<_BomLineModel> get copyWith => __$BomLineModelCopyWithImpl<_BomLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BomLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BomLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.bomHeaderId, bomHeaderId) || other.bomHeaderId == bomHeaderId)&&(identical(other.ingredientProductId, ingredientProductId) || other.ingredientProductId == ingredientProductId)&&(identical(other.ingredientProductName, ingredientProductName) || other.ingredientProductName == ingredientProductName)&&(identical(other.ingredientVariationId, ingredientVariationId) || other.ingredientVariationId == ingredientVariationId)&&(identical(other.qtyRequired, qtyRequired) || other.qtyRequired == qtyRequired)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.wastagePct, wastagePct) || other.wastagePct == wastagePct)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,bomHeaderId,ingredientProductId,ingredientProductName,ingredientVariationId,qtyRequired,unitId,wastagePct,sortOrder);
}

@override
String toString() {
    return 'BomLineModel(id: $id, businessId: $businessId, bomHeaderId: $bomHeaderId, ingredientProductId: $ingredientProductId, ingredientProductName: $ingredientProductName, ingredientVariationId: $ingredientVariationId, qtyRequired: $qtyRequired, unitId: $unitId, wastagePct: $wastagePct, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$BomLineModelCopyWith<$Res> implements $BomLineModelCopyWith<$Res> {
  factory _$BomLineModelCopyWith(_BomLineModel value, $Res Function(_BomLineModel) _then) = __$BomLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'bom_header_id') String bomHeaderId,@JsonKey(name: 'ingredient_product_id') String ingredientProductId,@JsonKey(name: 'ingredient_product_name') String ingredientProductName,@JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,@JsonKey(name: 'qty_required') String qtyRequired,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(name: 'wastage_pct') String wastagePct,@JsonKey(name: 'sort_order', fromJson: JsonNum.intOr) int sortOrder
});




}
/// @nodoc
class __$BomLineModelCopyWithImpl<$Res>
    implements _$BomLineModelCopyWith<$Res> {
  __$BomLineModelCopyWithImpl(this._self, this._then);

  final _BomLineModel _self;
  final $Res Function(_BomLineModel) _then;

/// Create a copy of BomLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? bomHeaderId = null,Object? ingredientProductId = null,Object? ingredientProductName = null,Object? ingredientVariationId = freezed,Object? qtyRequired = null,Object? unitId = freezed,Object? wastagePct = null,Object? sortOrder = null,}) {
  return _then(_BomLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,bomHeaderId: null == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String,ingredientProductId: null == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String,ingredientProductName: null == ingredientProductName ? _self.ingredientProductName : ingredientProductName // ignore: cast_nullable_to_non_nullable
as String,ingredientVariationId: freezed == ingredientVariationId ? _self.ingredientVariationId : ingredientVariationId // ignore: cast_nullable_to_non_nullable
as String?,qtyRequired: null == qtyRequired ? _self.qtyRequired : qtyRequired // ignore: cast_nullable_to_non_nullable
as String,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,wastagePct: null == wastagePct ? _self.wastagePct : wastagePct // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
