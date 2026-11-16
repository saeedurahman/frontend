// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessConfigModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'enable_restaurant') bool get enableRestaurant;@JsonKey(name: 'enable_manufacturing') bool get enableManufacturing;@JsonKey(name: 'enable_accounting') bool get enableAccounting;@JsonKey(name: 'enable_weight_billing') bool get enableWeightBilling;@JsonKey(name: 'enable_kot') bool get enableKot;@JsonKey(name: 'fifo_costing_enabled') bool get fifoCostingEnabled;@JsonKey(name: 'allow_negative_stock') bool get allowNegativeStock;@JsonKey(name: 'config_json') Map<String, dynamic> get configJson;
/// Create a copy of BusinessConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessConfigModelCopyWith<BusinessConfigModel> get copyWith => _$BusinessConfigModelCopyWithImpl<BusinessConfigModel>(this as BusinessConfigModel, _$identity);

  /// Serializes this BusinessConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BusinessConfigModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessConfigModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.enableRestaurant, _this.enableRestaurant) || other.enableRestaurant == _this.enableRestaurant)&&(identical(other.enableManufacturing, _this.enableManufacturing) || other.enableManufacturing == _this.enableManufacturing)&&(identical(other.enableAccounting, _this.enableAccounting) || other.enableAccounting == _this.enableAccounting)&&(identical(other.enableWeightBilling, _this.enableWeightBilling) || other.enableWeightBilling == _this.enableWeightBilling)&&(identical(other.enableKot, _this.enableKot) || other.enableKot == _this.enableKot)&&(identical(other.fifoCostingEnabled, _this.fifoCostingEnabled) || other.fifoCostingEnabled == _this.fifoCostingEnabled)&&(identical(other.allowNegativeStock, _this.allowNegativeStock) || other.allowNegativeStock == _this.allowNegativeStock)&&const DeepCollectionEquality().equals(other.configJson, _this.configJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BusinessConfigModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.enableRestaurant,_this.enableManufacturing,_this.enableAccounting,_this.enableWeightBilling,_this.enableKot,_this.fifoCostingEnabled,_this.allowNegativeStock,const DeepCollectionEquality().hash(_this.configJson));
}

@override
String toString() {
  final _this = this as BusinessConfigModel;
  return 'BusinessConfigModel(id: ${_this.id}, businessId: ${_this.businessId}, enableRestaurant: ${_this.enableRestaurant}, enableManufacturing: ${_this.enableManufacturing}, enableAccounting: ${_this.enableAccounting}, enableWeightBilling: ${_this.enableWeightBilling}, enableKot: ${_this.enableKot}, fifoCostingEnabled: ${_this.fifoCostingEnabled}, allowNegativeStock: ${_this.allowNegativeStock}, configJson: ${_this.configJson})';
}


}

/// @nodoc
abstract mixin class $BusinessConfigModelCopyWith<$Res>  {
  factory $BusinessConfigModelCopyWith(BusinessConfigModel value, $Res Function(BusinessConfigModel) _then) = _$BusinessConfigModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'enable_restaurant') bool enableRestaurant,@JsonKey(name: 'enable_manufacturing') bool enableManufacturing,@JsonKey(name: 'enable_accounting') bool enableAccounting,@JsonKey(name: 'enable_weight_billing') bool enableWeightBilling,@JsonKey(name: 'enable_kot') bool enableKot,@JsonKey(name: 'fifo_costing_enabled') bool fifoCostingEnabled,@JsonKey(name: 'allow_negative_stock') bool allowNegativeStock,@JsonKey(name: 'config_json') Map<String, dynamic> configJson
});




}
/// @nodoc
class _$BusinessConfigModelCopyWithImpl<$Res>
    implements $BusinessConfigModelCopyWith<$Res> {
  _$BusinessConfigModelCopyWithImpl(this._self, this._then);

  final BusinessConfigModel _self;
  final $Res Function(BusinessConfigModel) _then;

/// Create a copy of BusinessConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? enableRestaurant = null,Object? enableManufacturing = null,Object? enableAccounting = null,Object? enableWeightBilling = null,Object? enableKot = null,Object? fifoCostingEnabled = null,Object? allowNegativeStock = null,Object? configJson = null,}) {
  return _then(BusinessConfigModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,enableRestaurant: null == enableRestaurant ? _self.enableRestaurant : enableRestaurant // ignore: cast_nullable_to_non_nullable
as bool,enableManufacturing: null == enableManufacturing ? _self.enableManufacturing : enableManufacturing // ignore: cast_nullable_to_non_nullable
as bool,enableAccounting: null == enableAccounting ? _self.enableAccounting : enableAccounting // ignore: cast_nullable_to_non_nullable
as bool,enableWeightBilling: null == enableWeightBilling ? _self.enableWeightBilling : enableWeightBilling // ignore: cast_nullable_to_non_nullable
as bool,enableKot: null == enableKot ? _self.enableKot : enableKot // ignore: cast_nullable_to_non_nullable
as bool,fifoCostingEnabled: null == fifoCostingEnabled ? _self.fifoCostingEnabled : fifoCostingEnabled // ignore: cast_nullable_to_non_nullable
as bool,allowNegativeStock: null == allowNegativeStock ? _self.allowNegativeStock : allowNegativeStock // ignore: cast_nullable_to_non_nullable
as bool,configJson: null == configJson ? _self.configJson : configJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessConfigModel].
extension BusinessConfigModelPatterns on BusinessConfigModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessConfigModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _BusinessConfigModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessConfigModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'enable_restaurant')  bool enableRestaurant, @JsonKey(name: 'enable_manufacturing')  bool enableManufacturing, @JsonKey(name: 'enable_accounting')  bool enableAccounting, @JsonKey(name: 'enable_weight_billing')  bool enableWeightBilling, @JsonKey(name: 'enable_kot')  bool enableKot, @JsonKey(name: 'fifo_costing_enabled')  bool fifoCostingEnabled, @JsonKey(name: 'allow_negative_stock')  bool allowNegativeStock, @JsonKey(name: 'config_json')  Map<String, dynamic> configJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessConfigModel() when $default != null:
return $default(_that.id,_that.businessId,_that.enableRestaurant,_that.enableManufacturing,_that.enableAccounting,_that.enableWeightBilling,_that.enableKot,_that.fifoCostingEnabled,_that.allowNegativeStock,_that.configJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'enable_restaurant')  bool enableRestaurant, @JsonKey(name: 'enable_manufacturing')  bool enableManufacturing, @JsonKey(name: 'enable_accounting')  bool enableAccounting, @JsonKey(name: 'enable_weight_billing')  bool enableWeightBilling, @JsonKey(name: 'enable_kot')  bool enableKot, @JsonKey(name: 'fifo_costing_enabled')  bool fifoCostingEnabled, @JsonKey(name: 'allow_negative_stock')  bool allowNegativeStock, @JsonKey(name: 'config_json')  Map<String, dynamic> configJson)  $default,) {final _that = this;
switch (_that) {
case _BusinessConfigModel():
return $default(_that.id,_that.businessId,_that.enableRestaurant,_that.enableManufacturing,_that.enableAccounting,_that.enableWeightBilling,_that.enableKot,_that.fifoCostingEnabled,_that.allowNegativeStock,_that.configJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'enable_restaurant')  bool enableRestaurant, @JsonKey(name: 'enable_manufacturing')  bool enableManufacturing, @JsonKey(name: 'enable_accounting')  bool enableAccounting, @JsonKey(name: 'enable_weight_billing')  bool enableWeightBilling, @JsonKey(name: 'enable_kot')  bool enableKot, @JsonKey(name: 'fifo_costing_enabled')  bool fifoCostingEnabled, @JsonKey(name: 'allow_negative_stock')  bool allowNegativeStock, @JsonKey(name: 'config_json')  Map<String, dynamic> configJson)?  $default,) {final _that = this;
switch (_that) {
case _BusinessConfigModel() when $default != null:
return $default(_that.id,_that.businessId,_that.enableRestaurant,_that.enableManufacturing,_that.enableAccounting,_that.enableWeightBilling,_that.enableKot,_that.fifoCostingEnabled,_that.allowNegativeStock,_that.configJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessConfigModel implements BusinessConfigModel {
  const _BusinessConfigModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'enable_restaurant') this.enableRestaurant = false, @JsonKey(name: 'enable_manufacturing') this.enableManufacturing = false, @JsonKey(name: 'enable_accounting') this.enableAccounting = false, @JsonKey(name: 'enable_weight_billing') this.enableWeightBilling = false, @JsonKey(name: 'enable_kot') this.enableKot = false, @JsonKey(name: 'fifo_costing_enabled') this.fifoCostingEnabled = true, @JsonKey(name: 'allow_negative_stock') this.allowNegativeStock = false, @JsonKey(name: 'config_json')  Map<String, dynamic> configJson = const {}}): _configJson = configJson;
  factory _BusinessConfigModel.fromJson(Map<String, dynamic> json) => _$BusinessConfigModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'enable_restaurant') final  bool enableRestaurant;
@override@JsonKey(name: 'enable_manufacturing') final  bool enableManufacturing;
@override@JsonKey(name: 'enable_accounting') final  bool enableAccounting;
@override@JsonKey(name: 'enable_weight_billing') final  bool enableWeightBilling;
@override@JsonKey(name: 'enable_kot') final  bool enableKot;
@override@JsonKey(name: 'fifo_costing_enabled') final  bool fifoCostingEnabled;
@override@JsonKey(name: 'allow_negative_stock') final  bool allowNegativeStock;
 final  Map<String, dynamic> _configJson;
@override@JsonKey(name: 'config_json') Map<String, dynamic> get configJson {
  if (_configJson is EqualUnmodifiableMapView) return _configJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_configJson);
}


/// Create a copy of BusinessConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessConfigModelCopyWith<_BusinessConfigModel> get copyWith => __$BusinessConfigModelCopyWithImpl<_BusinessConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessConfigModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.enableRestaurant, enableRestaurant) || other.enableRestaurant == enableRestaurant)&&(identical(other.enableManufacturing, enableManufacturing) || other.enableManufacturing == enableManufacturing)&&(identical(other.enableAccounting, enableAccounting) || other.enableAccounting == enableAccounting)&&(identical(other.enableWeightBilling, enableWeightBilling) || other.enableWeightBilling == enableWeightBilling)&&(identical(other.enableKot, enableKot) || other.enableKot == enableKot)&&(identical(other.fifoCostingEnabled, fifoCostingEnabled) || other.fifoCostingEnabled == fifoCostingEnabled)&&(identical(other.allowNegativeStock, allowNegativeStock) || other.allowNegativeStock == allowNegativeStock)&&const DeepCollectionEquality().equals(other.configJson, _configJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,enableRestaurant,enableManufacturing,enableAccounting,enableWeightBilling,enableKot,fifoCostingEnabled,allowNegativeStock,const DeepCollectionEquality().hash(_configJson));
}

@override
String toString() {
    return 'BusinessConfigModel(id: $id, businessId: $businessId, enableRestaurant: $enableRestaurant, enableManufacturing: $enableManufacturing, enableAccounting: $enableAccounting, enableWeightBilling: $enableWeightBilling, enableKot: $enableKot, fifoCostingEnabled: $fifoCostingEnabled, allowNegativeStock: $allowNegativeStock, configJson: $configJson)';
}


}

/// @nodoc
abstract mixin class _$BusinessConfigModelCopyWith<$Res> implements $BusinessConfigModelCopyWith<$Res> {
  factory _$BusinessConfigModelCopyWith(_BusinessConfigModel value, $Res Function(_BusinessConfigModel) _then) = __$BusinessConfigModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'enable_restaurant') bool enableRestaurant,@JsonKey(name: 'enable_manufacturing') bool enableManufacturing,@JsonKey(name: 'enable_accounting') bool enableAccounting,@JsonKey(name: 'enable_weight_billing') bool enableWeightBilling,@JsonKey(name: 'enable_kot') bool enableKot,@JsonKey(name: 'fifo_costing_enabled') bool fifoCostingEnabled,@JsonKey(name: 'allow_negative_stock') bool allowNegativeStock,@JsonKey(name: 'config_json') Map<String, dynamic> configJson
});




}
/// @nodoc
class __$BusinessConfigModelCopyWithImpl<$Res>
    implements _$BusinessConfigModelCopyWith<$Res> {
  __$BusinessConfigModelCopyWithImpl(this._self, this._then);

  final _BusinessConfigModel _self;
  final $Res Function(_BusinessConfigModel) _then;

/// Create a copy of BusinessConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? enableRestaurant = null,Object? enableManufacturing = null,Object? enableAccounting = null,Object? enableWeightBilling = null,Object? enableKot = null,Object? fifoCostingEnabled = null,Object? allowNegativeStock = null,Object? configJson = null,}) {
  return _then(_BusinessConfigModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,enableRestaurant: null == enableRestaurant ? _self.enableRestaurant : enableRestaurant // ignore: cast_nullable_to_non_nullable
as bool,enableManufacturing: null == enableManufacturing ? _self.enableManufacturing : enableManufacturing // ignore: cast_nullable_to_non_nullable
as bool,enableAccounting: null == enableAccounting ? _self.enableAccounting : enableAccounting // ignore: cast_nullable_to_non_nullable
as bool,enableWeightBilling: null == enableWeightBilling ? _self.enableWeightBilling : enableWeightBilling // ignore: cast_nullable_to_non_nullable
as bool,enableKot: null == enableKot ? _self.enableKot : enableKot // ignore: cast_nullable_to_non_nullable
as bool,fifoCostingEnabled: null == fifoCostingEnabled ? _self.fifoCostingEnabled : fifoCostingEnabled // ignore: cast_nullable_to_non_nullable
as bool,allowNegativeStock: null == allowNegativeStock ? _self.allowNegativeStock : allowNegativeStock // ignore: cast_nullable_to_non_nullable
as bool,configJson: null == configJson ? _self._configJson : configJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
