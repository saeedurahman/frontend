// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VariationModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'product_id') String get productId; String get name; String? get sku;@JsonKey(name: 'unit_id') String? get unitId;@JsonKey(name: 'is_default') bool get isDefault;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'weight_grams') String? get weightGrams;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; List<BarcodeModel> get barcodes; UnitModel? get unit;
/// Create a copy of VariationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VariationModelCopyWith<VariationModel> get copyWith => _$VariationModelCopyWithImpl<VariationModel>(this as VariationModel, _$identity);

  /// Serializes this VariationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VariationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VariationModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.weightGrams, _this.weightGrams) || other.weightGrams == _this.weightGrams)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.barcodes, _this.barcodes)&&(identical(other.unit, _this.unit) || other.unit == _this.unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VariationModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.productId,_this.name,_this.sku,_this.unitId,_this.isDefault,_this.isActive,_this.weightGrams,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.barcodes),_this.unit);
}

@override
String toString() {
  final _this = this as VariationModel;
  return 'VariationModel(id: ${_this.id}, businessId: ${_this.businessId}, productId: ${_this.productId}, name: ${_this.name}, sku: ${_this.sku}, unitId: ${_this.unitId}, isDefault: ${_this.isDefault}, isActive: ${_this.isActive}, weightGrams: ${_this.weightGrams}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, barcodes: ${_this.barcodes}, unit: ${_this.unit})';
}


}

/// @nodoc
abstract mixin class $VariationModelCopyWith<$Res>  {
  factory $VariationModelCopyWith(VariationModel value, $Res Function(VariationModel) _then) = _$VariationModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'product_id') String productId, String name, String? sku,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'weight_grams') String? weightGrams,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, List<BarcodeModel> barcodes, UnitModel? unit
});


$UnitModelCopyWith<$Res>? get unit;

}
/// @nodoc
class _$VariationModelCopyWithImpl<$Res>
    implements $VariationModelCopyWith<$Res> {
  _$VariationModelCopyWithImpl(this._self, this._then);

  final VariationModel _self;
  final $Res Function(VariationModel) _then;

/// Create a copy of VariationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? productId = null,Object? name = null,Object? sku = freezed,Object? unitId = freezed,Object? isDefault = null,Object? isActive = null,Object? weightGrams = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? barcodes = null,Object? unit = freezed,}) {
  return _then(VariationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,barcodes: null == barcodes ? _self.barcodes : barcodes // ignore: cast_nullable_to_non_nullable
as List<BarcodeModel>,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as UnitModel?,
  ));
}
/// Create a copy of VariationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitModelCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitModelCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [VariationModel].
extension VariationModelPatterns on VariationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VariationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VariationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VariationModel value)  $default,){
final _that = this;
switch (_that) {
case _VariationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VariationModel value)?  $default,){
final _that = this;
switch (_that) {
case _VariationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'product_id')  String productId,  String name,  String? sku, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'weight_grams')  String? weightGrams, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  List<BarcodeModel> barcodes,  UnitModel? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VariationModel() when $default != null:
return $default(_that.id,_that.businessId,_that.productId,_that.name,_that.sku,_that.unitId,_that.isDefault,_that.isActive,_that.weightGrams,_that.createdAt,_that.updatedAt,_that.barcodes,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'product_id')  String productId,  String name,  String? sku, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'weight_grams')  String? weightGrams, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  List<BarcodeModel> barcodes,  UnitModel? unit)  $default,) {final _that = this;
switch (_that) {
case _VariationModel():
return $default(_that.id,_that.businessId,_that.productId,_that.name,_that.sku,_that.unitId,_that.isDefault,_that.isActive,_that.weightGrams,_that.createdAt,_that.updatedAt,_that.barcodes,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'product_id')  String productId,  String name,  String? sku, @JsonKey(name: 'unit_id')  String? unitId, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'weight_grams')  String? weightGrams, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  List<BarcodeModel> barcodes,  UnitModel? unit)?  $default,) {final _that = this;
switch (_that) {
case _VariationModel() when $default != null:
return $default(_that.id,_that.businessId,_that.productId,_that.name,_that.sku,_that.unitId,_that.isDefault,_that.isActive,_that.weightGrams,_that.createdAt,_that.updatedAt,_that.barcodes,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VariationModel implements VariationModel {
  const _VariationModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'product_id') required this.productId, required this.name, this.sku, @JsonKey(name: 'unit_id') this.unitId, @JsonKey(name: 'is_default') this.isDefault = false, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'weight_grams') this.weightGrams, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt,  List<BarcodeModel> barcodes = const [], this.unit}): _barcodes = barcodes;
  factory _VariationModel.fromJson(Map<String, dynamic> json) => _$VariationModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'product_id') final  String productId;
@override final  String name;
@override final  String? sku;
@override@JsonKey(name: 'unit_id') final  String? unitId;
@override@JsonKey(name: 'is_default') final  bool isDefault;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'weight_grams') final  String? weightGrams;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
 final  List<BarcodeModel> _barcodes;
@override@JsonKey() List<BarcodeModel> get barcodes {
  if (_barcodes is EqualUnmodifiableListView) return _barcodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barcodes);
}

@override final  UnitModel? unit;

/// Create a copy of VariationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VariationModelCopyWith<_VariationModel> get copyWith => __$VariationModelCopyWithImpl<_VariationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VariationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VariationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.barcodes, _barcodes)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,productId,name,sku,unitId,isDefault,isActive,weightGrams,createdAt,updatedAt,const DeepCollectionEquality().hash(_barcodes),unit);
}

@override
String toString() {
    return 'VariationModel(id: $id, businessId: $businessId, productId: $productId, name: $name, sku: $sku, unitId: $unitId, isDefault: $isDefault, isActive: $isActive, weightGrams: $weightGrams, createdAt: $createdAt, updatedAt: $updatedAt, barcodes: $barcodes, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$VariationModelCopyWith<$Res> implements $VariationModelCopyWith<$Res> {
  factory _$VariationModelCopyWith(_VariationModel value, $Res Function(_VariationModel) _then) = __$VariationModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'product_id') String productId, String name, String? sku,@JsonKey(name: 'unit_id') String? unitId,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'weight_grams') String? weightGrams,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, List<BarcodeModel> barcodes, UnitModel? unit
});


@override $UnitModelCopyWith<$Res>? get unit;

}
/// @nodoc
class __$VariationModelCopyWithImpl<$Res>
    implements _$VariationModelCopyWith<$Res> {
  __$VariationModelCopyWithImpl(this._self, this._then);

  final _VariationModel _self;
  final $Res Function(_VariationModel) _then;

/// Create a copy of VariationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? productId = null,Object? name = null,Object? sku = freezed,Object? unitId = freezed,Object? isDefault = null,Object? isActive = null,Object? weightGrams = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? barcodes = null,Object? unit = freezed,}) {
  return _then(_VariationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,barcodes: null == barcodes ? _self._barcodes : barcodes // ignore: cast_nullable_to_non_nullable
as List<BarcodeModel>,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as UnitModel?,
  ));
}

/// Create a copy of VariationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitModelCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitModelCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on
