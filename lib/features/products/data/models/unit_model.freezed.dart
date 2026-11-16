// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnitModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name; String get symbol;@JsonKey(name: 'is_base_unit') bool get isBaseUnit;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of UnitModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitModelCopyWith<UnitModel> get copyWith => _$UnitModelCopyWithImpl<UnitModel>(this as UnitModel, _$identity);

  /// Serializes this UnitModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UnitModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.isBaseUnit, _this.isBaseUnit) || other.isBaseUnit == _this.isBaseUnit)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UnitModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.symbol,_this.isBaseUnit,_this.isActive);
}

@override
String toString() {
  final _this = this as UnitModel;
  return 'UnitModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, symbol: ${_this.symbol}, isBaseUnit: ${_this.isBaseUnit}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $UnitModelCopyWith<$Res>  {
  factory $UnitModelCopyWith(UnitModel value, $Res Function(UnitModel) _then) = _$UnitModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String symbol,@JsonKey(name: 'is_base_unit') bool isBaseUnit,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$UnitModelCopyWithImpl<$Res>
    implements $UnitModelCopyWith<$Res> {
  _$UnitModelCopyWithImpl(this._self, this._then);

  final UnitModel _self;
  final $Res Function(UnitModel) _then;

/// Create a copy of UnitModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? symbol = null,Object? isBaseUnit = null,Object? isActive = null,}) {
  return _then(UnitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitModel].
extension UnitModelPatterns on UnitModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitModel value)  $default,){
final _that = this;
switch (_that) {
case _UnitModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitModel value)?  $default,){
final _that = this;
switch (_that) {
case _UnitModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String symbol, @JsonKey(name: 'is_base_unit')  bool isBaseUnit, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.symbol,_that.isBaseUnit,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String symbol, @JsonKey(name: 'is_base_unit')  bool isBaseUnit, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _UnitModel():
return $default(_that.id,_that.businessId,_that.name,_that.symbol,_that.isBaseUnit,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String symbol, @JsonKey(name: 'is_base_unit')  bool isBaseUnit, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _UnitModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.symbol,_that.isBaseUnit,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitModel implements UnitModel {
  const _UnitModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, required this.symbol, @JsonKey(name: 'is_base_unit') this.isBaseUnit = false, @JsonKey(name: 'is_active') this.isActive = true});
  factory _UnitModel.fromJson(Map<String, dynamic> json) => _$UnitModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override final  String symbol;
@override@JsonKey(name: 'is_base_unit') final  bool isBaseUnit;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of UnitModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitModelCopyWith<_UnitModel> get copyWith => __$UnitModelCopyWithImpl<_UnitModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.isBaseUnit, isBaseUnit) || other.isBaseUnit == isBaseUnit)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,symbol,isBaseUnit,isActive);
}

@override
String toString() {
    return 'UnitModel(id: $id, businessId: $businessId, name: $name, symbol: $symbol, isBaseUnit: $isBaseUnit, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UnitModelCopyWith<$Res> implements $UnitModelCopyWith<$Res> {
  factory _$UnitModelCopyWith(_UnitModel value, $Res Function(_UnitModel) _then) = __$UnitModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String symbol,@JsonKey(name: 'is_base_unit') bool isBaseUnit,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$UnitModelCopyWithImpl<$Res>
    implements _$UnitModelCopyWith<$Res> {
  __$UnitModelCopyWithImpl(this._self, this._then);

  final _UnitModel _self;
  final $Res Function(_UnitModel) _then;

/// Create a copy of UnitModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? symbol = null,Object? isBaseUnit = null,Object? isActive = null,}) {
  return _then(_UnitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UnitConversionModel {

 String get id;@JsonKey(name: 'from_unit_id') String get fromUnitId;@JsonKey(name: 'to_unit_id') String get toUnitId;@JsonKey(name: 'conversion_factor') String get conversionFactor;
/// Create a copy of UnitConversionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitConversionModelCopyWith<UnitConversionModel> get copyWith => _$UnitConversionModelCopyWithImpl<UnitConversionModel>(this as UnitConversionModel, _$identity);

  /// Serializes this UnitConversionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UnitConversionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitConversionModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fromUnitId, _this.fromUnitId) || other.fromUnitId == _this.fromUnitId)&&(identical(other.toUnitId, _this.toUnitId) || other.toUnitId == _this.toUnitId)&&(identical(other.conversionFactor, _this.conversionFactor) || other.conversionFactor == _this.conversionFactor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UnitConversionModel;
  return Object.hash(runtimeType,_this.id,_this.fromUnitId,_this.toUnitId,_this.conversionFactor);
}

@override
String toString() {
  final _this = this as UnitConversionModel;
  return 'UnitConversionModel(id: ${_this.id}, fromUnitId: ${_this.fromUnitId}, toUnitId: ${_this.toUnitId}, conversionFactor: ${_this.conversionFactor})';
}


}

/// @nodoc
abstract mixin class $UnitConversionModelCopyWith<$Res>  {
  factory $UnitConversionModelCopyWith(UnitConversionModel value, $Res Function(UnitConversionModel) _then) = _$UnitConversionModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'from_unit_id') String fromUnitId,@JsonKey(name: 'to_unit_id') String toUnitId,@JsonKey(name: 'conversion_factor') String conversionFactor
});




}
/// @nodoc
class _$UnitConversionModelCopyWithImpl<$Res>
    implements $UnitConversionModelCopyWith<$Res> {
  _$UnitConversionModelCopyWithImpl(this._self, this._then);

  final UnitConversionModel _self;
  final $Res Function(UnitConversionModel) _then;

/// Create a copy of UnitConversionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUnitId = null,Object? toUnitId = null,Object? conversionFactor = null,}) {
  return _then(UnitConversionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUnitId: null == fromUnitId ? _self.fromUnitId : fromUnitId // ignore: cast_nullable_to_non_nullable
as String,toUnitId: null == toUnitId ? _self.toUnitId : toUnitId // ignore: cast_nullable_to_non_nullable
as String,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitConversionModel].
extension UnitConversionModelPatterns on UnitConversionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitConversionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitConversionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitConversionModel value)  $default,){
final _that = this;
switch (_that) {
case _UnitConversionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitConversionModel value)?  $default,){
final _that = this;
switch (_that) {
case _UnitConversionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'from_unit_id')  String fromUnitId, @JsonKey(name: 'to_unit_id')  String toUnitId, @JsonKey(name: 'conversion_factor')  String conversionFactor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitConversionModel() when $default != null:
return $default(_that.id,_that.fromUnitId,_that.toUnitId,_that.conversionFactor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'from_unit_id')  String fromUnitId, @JsonKey(name: 'to_unit_id')  String toUnitId, @JsonKey(name: 'conversion_factor')  String conversionFactor)  $default,) {final _that = this;
switch (_that) {
case _UnitConversionModel():
return $default(_that.id,_that.fromUnitId,_that.toUnitId,_that.conversionFactor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'from_unit_id')  String fromUnitId, @JsonKey(name: 'to_unit_id')  String toUnitId, @JsonKey(name: 'conversion_factor')  String conversionFactor)?  $default,) {final _that = this;
switch (_that) {
case _UnitConversionModel() when $default != null:
return $default(_that.id,_that.fromUnitId,_that.toUnitId,_that.conversionFactor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitConversionModel implements UnitConversionModel {
  const _UnitConversionModel({required this.id, @JsonKey(name: 'from_unit_id') required this.fromUnitId, @JsonKey(name: 'to_unit_id') required this.toUnitId, @JsonKey(name: 'conversion_factor') required this.conversionFactor});
  factory _UnitConversionModel.fromJson(Map<String, dynamic> json) => _$UnitConversionModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'from_unit_id') final  String fromUnitId;
@override@JsonKey(name: 'to_unit_id') final  String toUnitId;
@override@JsonKey(name: 'conversion_factor') final  String conversionFactor;

/// Create a copy of UnitConversionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitConversionModelCopyWith<_UnitConversionModel> get copyWith => __$UnitConversionModelCopyWithImpl<_UnitConversionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitConversionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitConversionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUnitId, fromUnitId) || other.fromUnitId == fromUnitId)&&(identical(other.toUnitId, toUnitId) || other.toUnitId == toUnitId)&&(identical(other.conversionFactor, conversionFactor) || other.conversionFactor == conversionFactor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fromUnitId,toUnitId,conversionFactor);
}

@override
String toString() {
    return 'UnitConversionModel(id: $id, fromUnitId: $fromUnitId, toUnitId: $toUnitId, conversionFactor: $conversionFactor)';
}


}

/// @nodoc
abstract mixin class _$UnitConversionModelCopyWith<$Res> implements $UnitConversionModelCopyWith<$Res> {
  factory _$UnitConversionModelCopyWith(_UnitConversionModel value, $Res Function(_UnitConversionModel) _then) = __$UnitConversionModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'from_unit_id') String fromUnitId,@JsonKey(name: 'to_unit_id') String toUnitId,@JsonKey(name: 'conversion_factor') String conversionFactor
});




}
/// @nodoc
class __$UnitConversionModelCopyWithImpl<$Res>
    implements _$UnitConversionModelCopyWith<$Res> {
  __$UnitConversionModelCopyWithImpl(this._self, this._then);

  final _UnitConversionModel _self;
  final $Res Function(_UnitConversionModel) _then;

/// Create a copy of UnitConversionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUnitId = null,Object? toUnitId = null,Object? conversionFactor = null,}) {
  return _then(_UnitConversionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUnitId: null == fromUnitId ? _self.fromUnitId : fromUnitId // ignore: cast_nullable_to_non_nullable
as String,toUnitId: null == toUnitId ? _self.toUnitId : toUnitId // ignore: cast_nullable_to_non_nullable
as String,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
