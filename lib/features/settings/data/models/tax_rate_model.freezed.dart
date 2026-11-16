// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_rate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaxRateModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name; String get rate;@JsonKey(name: 'is_compound') bool get isCompound;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of TaxRateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaxRateModelCopyWith<TaxRateModel> get copyWith => _$TaxRateModelCopyWithImpl<TaxRateModel>(this as TaxRateModel, _$identity);

  /// Serializes this TaxRateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaxRateModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxRateModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.isCompound, _this.isCompound) || other.isCompound == _this.isCompound)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaxRateModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.rate,_this.isCompound,_this.isActive);
}

@override
String toString() {
  final _this = this as TaxRateModel;
  return 'TaxRateModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, rate: ${_this.rate}, isCompound: ${_this.isCompound}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $TaxRateModelCopyWith<$Res>  {
  factory $TaxRateModelCopyWith(TaxRateModel value, $Res Function(TaxRateModel) _then) = _$TaxRateModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String rate,@JsonKey(name: 'is_compound') bool isCompound,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$TaxRateModelCopyWithImpl<$Res>
    implements $TaxRateModelCopyWith<$Res> {
  _$TaxRateModelCopyWithImpl(this._self, this._then);

  final TaxRateModel _self;
  final $Res Function(TaxRateModel) _then;

/// Create a copy of TaxRateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? rate = null,Object? isCompound = null,Object? isActive = null,}) {
  return _then(TaxRateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as String,isCompound: null == isCompound ? _self.isCompound : isCompound // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaxRateModel].
extension TaxRateModelPatterns on TaxRateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaxRateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaxRateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaxRateModel value)  $default,){
final _that = this;
switch (_that) {
case _TaxRateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaxRateModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaxRateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String rate, @JsonKey(name: 'is_compound')  bool isCompound, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaxRateModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.rate,_that.isCompound,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String rate, @JsonKey(name: 'is_compound')  bool isCompound, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _TaxRateModel():
return $default(_that.id,_that.businessId,_that.name,_that.rate,_that.isCompound,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String rate, @JsonKey(name: 'is_compound')  bool isCompound, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _TaxRateModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.rate,_that.isCompound,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaxRateModel implements TaxRateModel {
  const _TaxRateModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, required this.rate, @JsonKey(name: 'is_compound') this.isCompound = false, @JsonKey(name: 'is_active') this.isActive = true});
  factory _TaxRateModel.fromJson(Map<String, dynamic> json) => _$TaxRateModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override final  String rate;
@override@JsonKey(name: 'is_compound') final  bool isCompound;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of TaxRateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaxRateModelCopyWith<_TaxRateModel> get copyWith => __$TaxRateModelCopyWithImpl<_TaxRateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaxRateModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaxRateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isCompound, isCompound) || other.isCompound == isCompound)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,rate,isCompound,isActive);
}

@override
String toString() {
    return 'TaxRateModel(id: $id, businessId: $businessId, name: $name, rate: $rate, isCompound: $isCompound, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TaxRateModelCopyWith<$Res> implements $TaxRateModelCopyWith<$Res> {
  factory _$TaxRateModelCopyWith(_TaxRateModel value, $Res Function(_TaxRateModel) _then) = __$TaxRateModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String rate,@JsonKey(name: 'is_compound') bool isCompound,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$TaxRateModelCopyWithImpl<$Res>
    implements _$TaxRateModelCopyWith<$Res> {
  __$TaxRateModelCopyWithImpl(this._self, this._then);

  final _TaxRateModel _self;
  final $Res Function(_TaxRateModel) _then;

/// Create a copy of TaxRateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? rate = null,Object? isCompound = null,Object? isActive = null,}) {
  return _then(_TaxRateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as String,isCompound: null == isCompound ? _self.isCompound : isCompound // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
