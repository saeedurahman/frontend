// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceListModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name;@JsonKey(name: 'list_type') String get listType;@JsonKey(name: 'is_default') bool get isDefault;@JsonKey(name: 'valid_from') String? get validFrom;@JsonKey(name: 'valid_to') String? get validTo;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'item_count') int get itemCount;@JsonKey(name: 'customer_count') int get customerCount;
/// Create a copy of PriceListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceListModelCopyWith<PriceListModel> get copyWith => _$PriceListModelCopyWithImpl<PriceListModel>(this as PriceListModel, _$identity);

  /// Serializes this PriceListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceListModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceListModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.listType, _this.listType) || other.listType == _this.listType)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.validFrom, _this.validFrom) || other.validFrom == _this.validFrom)&&(identical(other.validTo, _this.validTo) || other.validTo == _this.validTo)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&(identical(other.customerCount, _this.customerCount) || other.customerCount == _this.customerCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceListModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.listType,_this.isDefault,_this.validFrom,_this.validTo,_this.isActive,_this.itemCount,_this.customerCount);
}

@override
String toString() {
  final _this = this as PriceListModel;
  return 'PriceListModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, listType: ${_this.listType}, isDefault: ${_this.isDefault}, validFrom: ${_this.validFrom}, validTo: ${_this.validTo}, isActive: ${_this.isActive}, itemCount: ${_this.itemCount}, customerCount: ${_this.customerCount})';
}


}

/// @nodoc
abstract mixin class $PriceListModelCopyWith<$Res>  {
  factory $PriceListModelCopyWith(PriceListModel value, $Res Function(PriceListModel) _then) = _$PriceListModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'list_type') String listType,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'valid_from') String? validFrom,@JsonKey(name: 'valid_to') String? validTo,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'customer_count') int customerCount
});




}
/// @nodoc
class _$PriceListModelCopyWithImpl<$Res>
    implements $PriceListModelCopyWith<$Res> {
  _$PriceListModelCopyWithImpl(this._self, this._then);

  final PriceListModel _self;
  final $Res Function(PriceListModel) _then;

/// Create a copy of PriceListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? listType = null,Object? isDefault = null,Object? validFrom = freezed,Object? validTo = freezed,Object? isActive = null,Object? itemCount = null,Object? customerCount = null,}) {
  return _then(PriceListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,listType: null == listType ? _self.listType : listType // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceListModel].
extension PriceListModelPatterns on PriceListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceListModel value)  $default,){
final _that = this;
switch (_that) {
case _PriceListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceListModel value)?  $default,){
final _that = this;
switch (_that) {
case _PriceListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'list_type')  String listType, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'valid_from')  String? validFrom, @JsonKey(name: 'valid_to')  String? validTo, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'customer_count')  int customerCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceListModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.listType,_that.isDefault,_that.validFrom,_that.validTo,_that.isActive,_that.itemCount,_that.customerCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'list_type')  String listType, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'valid_from')  String? validFrom, @JsonKey(name: 'valid_to')  String? validTo, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'customer_count')  int customerCount)  $default,) {final _that = this;
switch (_that) {
case _PriceListModel():
return $default(_that.id,_that.businessId,_that.name,_that.listType,_that.isDefault,_that.validFrom,_that.validTo,_that.isActive,_that.itemCount,_that.customerCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'list_type')  String listType, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'valid_from')  String? validFrom, @JsonKey(name: 'valid_to')  String? validTo, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'customer_count')  int customerCount)?  $default,) {final _that = this;
switch (_that) {
case _PriceListModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.listType,_that.isDefault,_that.validFrom,_that.validTo,_that.isActive,_that.itemCount,_that.customerCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceListModel implements PriceListModel {
  const _PriceListModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, @JsonKey(name: 'list_type') required this.listType, @JsonKey(name: 'is_default') this.isDefault = false, @JsonKey(name: 'valid_from') this.validFrom, @JsonKey(name: 'valid_to') this.validTo, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'item_count') this.itemCount = 0, @JsonKey(name: 'customer_count') this.customerCount = 0});
  factory _PriceListModel.fromJson(Map<String, dynamic> json) => _$PriceListModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override@JsonKey(name: 'list_type') final  String listType;
@override@JsonKey(name: 'is_default') final  bool isDefault;
@override@JsonKey(name: 'valid_from') final  String? validFrom;
@override@JsonKey(name: 'valid_to') final  String? validTo;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'item_count') final  int itemCount;
@override@JsonKey(name: 'customer_count') final  int customerCount;

/// Create a copy of PriceListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceListModelCopyWith<_PriceListModel> get copyWith => __$PriceListModelCopyWithImpl<_PriceListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceListModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.listType, listType) || other.listType == listType)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,listType,isDefault,validFrom,validTo,isActive,itemCount,customerCount);
}

@override
String toString() {
    return 'PriceListModel(id: $id, businessId: $businessId, name: $name, listType: $listType, isDefault: $isDefault, validFrom: $validFrom, validTo: $validTo, isActive: $isActive, itemCount: $itemCount, customerCount: $customerCount)';
}


}

/// @nodoc
abstract mixin class _$PriceListModelCopyWith<$Res> implements $PriceListModelCopyWith<$Res> {
  factory _$PriceListModelCopyWith(_PriceListModel value, $Res Function(_PriceListModel) _then) = __$PriceListModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'list_type') String listType,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'valid_from') String? validFrom,@JsonKey(name: 'valid_to') String? validTo,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'customer_count') int customerCount
});




}
/// @nodoc
class __$PriceListModelCopyWithImpl<$Res>
    implements _$PriceListModelCopyWith<$Res> {
  __$PriceListModelCopyWithImpl(this._self, this._then);

  final _PriceListModel _self;
  final $Res Function(_PriceListModel) _then;

/// Create a copy of PriceListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? listType = null,Object? isDefault = null,Object? validFrom = freezed,Object? validTo = freezed,Object? isActive = null,Object? itemCount = null,Object? customerCount = null,}) {
  return _then(_PriceListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,listType: null == listType ? _self.listType : listType // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PriceListItemModel {

 String get id;@JsonKey(name: 'price_list_id') String get priceListId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'min_qty') String? get minQty;
/// Create a copy of PriceListItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceListItemModelCopyWith<PriceListItemModel> get copyWith => _$PriceListItemModelCopyWithImpl<PriceListItemModel>(this as PriceListItemModel, _$identity);

  /// Serializes this PriceListItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceListItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceListItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.priceListId, _this.priceListId) || other.priceListId == _this.priceListId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.minQty, _this.minQty) || other.minQty == _this.minQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceListItemModel;
  return Object.hash(runtimeType,_this.id,_this.priceListId,_this.productId,_this.variationId,_this.unitPrice,_this.minQty);
}

@override
String toString() {
  final _this = this as PriceListItemModel;
  return 'PriceListItemModel(id: ${_this.id}, priceListId: ${_this.priceListId}, productId: ${_this.productId}, variationId: ${_this.variationId}, unitPrice: ${_this.unitPrice}, minQty: ${_this.minQty})';
}


}

/// @nodoc
abstract mixin class $PriceListItemModelCopyWith<$Res>  {
  factory $PriceListItemModelCopyWith(PriceListItemModel value, $Res Function(PriceListItemModel) _then) = _$PriceListItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'price_list_id') String priceListId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'min_qty') String? minQty
});




}
/// @nodoc
class _$PriceListItemModelCopyWithImpl<$Res>
    implements $PriceListItemModelCopyWith<$Res> {
  _$PriceListItemModelCopyWithImpl(this._self, this._then);

  final PriceListItemModel _self;
  final $Res Function(PriceListItemModel) _then;

/// Create a copy of PriceListItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? priceListId = null,Object? productId = null,Object? variationId = freezed,Object? unitPrice = null,Object? minQty = freezed,}) {
  return _then(PriceListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,priceListId: null == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,minQty: freezed == minQty ? _self.minQty : minQty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceListItemModel].
extension PriceListItemModelPatterns on PriceListItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceListItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceListItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceListItemModel value)  $default,){
final _that = this;
switch (_that) {
case _PriceListItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceListItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _PriceListItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'price_list_id')  String priceListId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'min_qty')  String? minQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceListItemModel() when $default != null:
return $default(_that.id,_that.priceListId,_that.productId,_that.variationId,_that.unitPrice,_that.minQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'price_list_id')  String priceListId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'min_qty')  String? minQty)  $default,) {final _that = this;
switch (_that) {
case _PriceListItemModel():
return $default(_that.id,_that.priceListId,_that.productId,_that.variationId,_that.unitPrice,_that.minQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'price_list_id')  String priceListId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'min_qty')  String? minQty)?  $default,) {final _that = this;
switch (_that) {
case _PriceListItemModel() when $default != null:
return $default(_that.id,_that.priceListId,_that.productId,_that.variationId,_that.unitPrice,_that.minQty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceListItemModel implements PriceListItemModel {
  const _PriceListItemModel({required this.id, @JsonKey(name: 'price_list_id') required this.priceListId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'min_qty') this.minQty});
  factory _PriceListItemModel.fromJson(Map<String, dynamic> json) => _$PriceListItemModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'price_list_id') final  String priceListId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'min_qty') final  String? minQty;

/// Create a copy of PriceListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceListItemModelCopyWith<_PriceListItemModel> get copyWith => __$PriceListItemModelCopyWithImpl<_PriceListItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceListItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.priceListId, priceListId) || other.priceListId == priceListId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.minQty, minQty) || other.minQty == minQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,priceListId,productId,variationId,unitPrice,minQty);
}

@override
String toString() {
    return 'PriceListItemModel(id: $id, priceListId: $priceListId, productId: $productId, variationId: $variationId, unitPrice: $unitPrice, minQty: $minQty)';
}


}

/// @nodoc
abstract mixin class _$PriceListItemModelCopyWith<$Res> implements $PriceListItemModelCopyWith<$Res> {
  factory _$PriceListItemModelCopyWith(_PriceListItemModel value, $Res Function(_PriceListItemModel) _then) = __$PriceListItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'price_list_id') String priceListId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'min_qty') String? minQty
});




}
/// @nodoc
class __$PriceListItemModelCopyWithImpl<$Res>
    implements _$PriceListItemModelCopyWith<$Res> {
  __$PriceListItemModelCopyWithImpl(this._self, this._then);

  final _PriceListItemModel _self;
  final $Res Function(_PriceListItemModel) _then;

/// Create a copy of PriceListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? priceListId = null,Object? productId = null,Object? variationId = freezed,Object? unitPrice = null,Object? minQty = freezed,}) {
  return _then(_PriceListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,priceListId: null == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,minQty: freezed == minQty ? _self.minQty : minQty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductPriceModel {

 String? get id;@JsonKey(name: 'unit_price') String? get unitPrice;@JsonKey(name: 'min_qty') String? get minQty;@JsonKey(name: 'price_list_id') String? get priceListId;@JsonKey(name: 'variation_id') String? get variationId;
/// Create a copy of ProductPriceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductPriceModelCopyWith<ProductPriceModel> get copyWith => _$ProductPriceModelCopyWithImpl<ProductPriceModel>(this as ProductPriceModel, _$identity);

  /// Serializes this ProductPriceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductPriceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductPriceModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.minQty, _this.minQty) || other.minQty == _this.minQty)&&(identical(other.priceListId, _this.priceListId) || other.priceListId == _this.priceListId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductPriceModel;
  return Object.hash(runtimeType,_this.id,_this.unitPrice,_this.minQty,_this.priceListId,_this.variationId);
}

@override
String toString() {
  final _this = this as ProductPriceModel;
  return 'ProductPriceModel(id: ${_this.id}, unitPrice: ${_this.unitPrice}, minQty: ${_this.minQty}, priceListId: ${_this.priceListId}, variationId: ${_this.variationId})';
}


}

/// @nodoc
abstract mixin class $ProductPriceModelCopyWith<$Res>  {
  factory $ProductPriceModelCopyWith(ProductPriceModel value, $Res Function(ProductPriceModel) _then) = _$ProductPriceModelCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'unit_price') String? unitPrice,@JsonKey(name: 'min_qty') String? minQty,@JsonKey(name: 'price_list_id') String? priceListId,@JsonKey(name: 'variation_id') String? variationId
});




}
/// @nodoc
class _$ProductPriceModelCopyWithImpl<$Res>
    implements $ProductPriceModelCopyWith<$Res> {
  _$ProductPriceModelCopyWithImpl(this._self, this._then);

  final ProductPriceModel _self;
  final $Res Function(ProductPriceModel) _then;

/// Create a copy of ProductPriceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? unitPrice = freezed,Object? minQty = freezed,Object? priceListId = freezed,Object? variationId = freezed,}) {
  return _then(ProductPriceModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String?,minQty: freezed == minQty ? _self.minQty : minQty // ignore: cast_nullable_to_non_nullable
as String?,priceListId: freezed == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String?,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductPriceModel].
extension ProductPriceModelPatterns on ProductPriceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductPriceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductPriceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductPriceModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductPriceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductPriceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductPriceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'unit_price')  String? unitPrice, @JsonKey(name: 'min_qty')  String? minQty, @JsonKey(name: 'price_list_id')  String? priceListId, @JsonKey(name: 'variation_id')  String? variationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductPriceModel() when $default != null:
return $default(_that.id,_that.unitPrice,_that.minQty,_that.priceListId,_that.variationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'unit_price')  String? unitPrice, @JsonKey(name: 'min_qty')  String? minQty, @JsonKey(name: 'price_list_id')  String? priceListId, @JsonKey(name: 'variation_id')  String? variationId)  $default,) {final _that = this;
switch (_that) {
case _ProductPriceModel():
return $default(_that.id,_that.unitPrice,_that.minQty,_that.priceListId,_that.variationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'unit_price')  String? unitPrice, @JsonKey(name: 'min_qty')  String? minQty, @JsonKey(name: 'price_list_id')  String? priceListId, @JsonKey(name: 'variation_id')  String? variationId)?  $default,) {final _that = this;
switch (_that) {
case _ProductPriceModel() when $default != null:
return $default(_that.id,_that.unitPrice,_that.minQty,_that.priceListId,_that.variationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductPriceModel implements ProductPriceModel {
  const _ProductPriceModel({this.id, @JsonKey(name: 'unit_price') this.unitPrice, @JsonKey(name: 'min_qty') this.minQty, @JsonKey(name: 'price_list_id') this.priceListId, @JsonKey(name: 'variation_id') this.variationId});
  factory _ProductPriceModel.fromJson(Map<String, dynamic> json) => _$ProductPriceModelFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'unit_price') final  String? unitPrice;
@override@JsonKey(name: 'min_qty') final  String? minQty;
@override@JsonKey(name: 'price_list_id') final  String? priceListId;
@override@JsonKey(name: 'variation_id') final  String? variationId;

/// Create a copy of ProductPriceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductPriceModelCopyWith<_ProductPriceModel> get copyWith => __$ProductPriceModelCopyWithImpl<_ProductPriceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductPriceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductPriceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.minQty, minQty) || other.minQty == minQty)&&(identical(other.priceListId, priceListId) || other.priceListId == priceListId)&&(identical(other.variationId, variationId) || other.variationId == variationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,unitPrice,minQty,priceListId,variationId);
}

@override
String toString() {
    return 'ProductPriceModel(id: $id, unitPrice: $unitPrice, minQty: $minQty, priceListId: $priceListId, variationId: $variationId)';
}


}

/// @nodoc
abstract mixin class _$ProductPriceModelCopyWith<$Res> implements $ProductPriceModelCopyWith<$Res> {
  factory _$ProductPriceModelCopyWith(_ProductPriceModel value, $Res Function(_ProductPriceModel) _then) = __$ProductPriceModelCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'unit_price') String? unitPrice,@JsonKey(name: 'min_qty') String? minQty,@JsonKey(name: 'price_list_id') String? priceListId,@JsonKey(name: 'variation_id') String? variationId
});




}
/// @nodoc
class __$ProductPriceModelCopyWithImpl<$Res>
    implements _$ProductPriceModelCopyWith<$Res> {
  __$ProductPriceModelCopyWithImpl(this._self, this._then);

  final _ProductPriceModel _self;
  final $Res Function(_ProductPriceModel) _then;

/// Create a copy of ProductPriceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? unitPrice = freezed,Object? minQty = freezed,Object? priceListId = freezed,Object? variationId = freezed,}) {
  return _then(_ProductPriceModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String?,minQty: freezed == minQty ? _self.minQty : minQty // ignore: cast_nullable_to_non_nullable
as String?,priceListId: freezed == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String?,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
