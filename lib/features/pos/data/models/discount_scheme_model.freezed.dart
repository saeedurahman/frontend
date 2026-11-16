// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount_scheme_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiscountSchemeModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name;@JsonKey(name: 'discount_type') String get discountType;@JsonKey(name: 'discount_value') String get discountValue;@JsonKey(name: 'min_purchase_amount') String? get minPurchaseAmount;@JsonKey(name: 'valid_from') String? get validFrom;@JsonKey(name: 'valid_to') String? get validTo;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of DiscountSchemeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountSchemeModelCopyWith<DiscountSchemeModel> get copyWith => _$DiscountSchemeModelCopyWithImpl<DiscountSchemeModel>(this as DiscountSchemeModel, _$identity);

  /// Serializes this DiscountSchemeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiscountSchemeModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountSchemeModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.discountType, _this.discountType) || other.discountType == _this.discountType)&&(identical(other.discountValue, _this.discountValue) || other.discountValue == _this.discountValue)&&(identical(other.minPurchaseAmount, _this.minPurchaseAmount) || other.minPurchaseAmount == _this.minPurchaseAmount)&&(identical(other.validFrom, _this.validFrom) || other.validFrom == _this.validFrom)&&(identical(other.validTo, _this.validTo) || other.validTo == _this.validTo)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiscountSchemeModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.discountType,_this.discountValue,_this.minPurchaseAmount,_this.validFrom,_this.validTo,_this.isActive);
}

@override
String toString() {
  final _this = this as DiscountSchemeModel;
  return 'DiscountSchemeModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, discountType: ${_this.discountType}, discountValue: ${_this.discountValue}, minPurchaseAmount: ${_this.minPurchaseAmount}, validFrom: ${_this.validFrom}, validTo: ${_this.validTo}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $DiscountSchemeModelCopyWith<$Res>  {
  factory $DiscountSchemeModelCopyWith(DiscountSchemeModel value, $Res Function(DiscountSchemeModel) _then) = _$DiscountSchemeModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'discount_type') String discountType,@JsonKey(name: 'discount_value') String discountValue,@JsonKey(name: 'min_purchase_amount') String? minPurchaseAmount,@JsonKey(name: 'valid_from') String? validFrom,@JsonKey(name: 'valid_to') String? validTo,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$DiscountSchemeModelCopyWithImpl<$Res>
    implements $DiscountSchemeModelCopyWith<$Res> {
  _$DiscountSchemeModelCopyWithImpl(this._self, this._then);

  final DiscountSchemeModel _self;
  final $Res Function(DiscountSchemeModel) _then;

/// Create a copy of DiscountSchemeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? discountType = null,Object? discountValue = null,Object? minPurchaseAmount = freezed,Object? validFrom = freezed,Object? validTo = freezed,Object? isActive = null,}) {
  return _then(DiscountSchemeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String,minPurchaseAmount: freezed == minPurchaseAmount ? _self.minPurchaseAmount : minPurchaseAmount // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscountSchemeModel].
extension DiscountSchemeModelPatterns on DiscountSchemeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscountSchemeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscountSchemeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscountSchemeModel value)  $default,){
final _that = this;
switch (_that) {
case _DiscountSchemeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscountSchemeModel value)?  $default,){
final _that = this;
switch (_that) {
case _DiscountSchemeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'discount_type')  String discountType, @JsonKey(name: 'discount_value')  String discountValue, @JsonKey(name: 'min_purchase_amount')  String? minPurchaseAmount, @JsonKey(name: 'valid_from')  String? validFrom, @JsonKey(name: 'valid_to')  String? validTo, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscountSchemeModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.discountType,_that.discountValue,_that.minPurchaseAmount,_that.validFrom,_that.validTo,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'discount_type')  String discountType, @JsonKey(name: 'discount_value')  String discountValue, @JsonKey(name: 'min_purchase_amount')  String? minPurchaseAmount, @JsonKey(name: 'valid_from')  String? validFrom, @JsonKey(name: 'valid_to')  String? validTo, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _DiscountSchemeModel():
return $default(_that.id,_that.businessId,_that.name,_that.discountType,_that.discountValue,_that.minPurchaseAmount,_that.validFrom,_that.validTo,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'discount_type')  String discountType, @JsonKey(name: 'discount_value')  String discountValue, @JsonKey(name: 'min_purchase_amount')  String? minPurchaseAmount, @JsonKey(name: 'valid_from')  String? validFrom, @JsonKey(name: 'valid_to')  String? validTo, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _DiscountSchemeModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.discountType,_that.discountValue,_that.minPurchaseAmount,_that.validFrom,_that.validTo,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscountSchemeModel implements DiscountSchemeModel {
  const _DiscountSchemeModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, @JsonKey(name: 'discount_type') required this.discountType, @JsonKey(name: 'discount_value') required this.discountValue, @JsonKey(name: 'min_purchase_amount') this.minPurchaseAmount, @JsonKey(name: 'valid_from') this.validFrom, @JsonKey(name: 'valid_to') this.validTo, @JsonKey(name: 'is_active') this.isActive = true});
  factory _DiscountSchemeModel.fromJson(Map<String, dynamic> json) => _$DiscountSchemeModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override@JsonKey(name: 'discount_type') final  String discountType;
@override@JsonKey(name: 'discount_value') final  String discountValue;
@override@JsonKey(name: 'min_purchase_amount') final  String? minPurchaseAmount;
@override@JsonKey(name: 'valid_from') final  String? validFrom;
@override@JsonKey(name: 'valid_to') final  String? validTo;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of DiscountSchemeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountSchemeModelCopyWith<_DiscountSchemeModel> get copyWith => __$DiscountSchemeModelCopyWithImpl<_DiscountSchemeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscountSchemeModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscountSchemeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minPurchaseAmount, minPurchaseAmount) || other.minPurchaseAmount == minPurchaseAmount)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,discountType,discountValue,minPurchaseAmount,validFrom,validTo,isActive);
}

@override
String toString() {
    return 'DiscountSchemeModel(id: $id, businessId: $businessId, name: $name, discountType: $discountType, discountValue: $discountValue, minPurchaseAmount: $minPurchaseAmount, validFrom: $validFrom, validTo: $validTo, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$DiscountSchemeModelCopyWith<$Res> implements $DiscountSchemeModelCopyWith<$Res> {
  factory _$DiscountSchemeModelCopyWith(_DiscountSchemeModel value, $Res Function(_DiscountSchemeModel) _then) = __$DiscountSchemeModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'discount_type') String discountType,@JsonKey(name: 'discount_value') String discountValue,@JsonKey(name: 'min_purchase_amount') String? minPurchaseAmount,@JsonKey(name: 'valid_from') String? validFrom,@JsonKey(name: 'valid_to') String? validTo,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$DiscountSchemeModelCopyWithImpl<$Res>
    implements _$DiscountSchemeModelCopyWith<$Res> {
  __$DiscountSchemeModelCopyWithImpl(this._self, this._then);

  final _DiscountSchemeModel _self;
  final $Res Function(_DiscountSchemeModel) _then;

/// Create a copy of DiscountSchemeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? discountType = null,Object? discountValue = null,Object? minPurchaseAmount = freezed,Object? validFrom = freezed,Object? validTo = freezed,Object? isActive = null,}) {
  return _then(_DiscountSchemeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String,minPurchaseAmount: freezed == minPurchaseAmount ? _self.minPurchaseAmount : minPurchaseAmount // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
