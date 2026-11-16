// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'held_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HeldOrderModel {

 String get id; String get label; DateTime get createdAt; List<CartItemModel> get cartItems; String? get customerId; String? get customerName; String? get cartDiscountType; Decimal? get cartDiscountValue; int get itemCount; Decimal get totalAmount;
/// Create a copy of HeldOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeldOrderModelCopyWith<HeldOrderModel> get copyWith => _$HeldOrderModelCopyWithImpl<HeldOrderModel>(this as HeldOrderModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HeldOrderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeldOrderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.cartItems, _this.cartItems)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.cartDiscountType, _this.cartDiscountType) || other.cartDiscountType == _this.cartDiscountType)&&(identical(other.cartDiscountValue, _this.cartDiscountValue) || other.cartDiscountValue == _this.cartDiscountValue)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount));
}


@override
int get hashCode {
  final _this = this as HeldOrderModel;
  return Object.hash(runtimeType,_this.id,_this.label,_this.createdAt,const DeepCollectionEquality().hash(_this.cartItems),_this.customerId,_this.customerName,_this.cartDiscountType,_this.cartDiscountValue,_this.itemCount,_this.totalAmount);
}

@override
String toString() {
  final _this = this as HeldOrderModel;
  return 'HeldOrderModel(id: ${_this.id}, label: ${_this.label}, createdAt: ${_this.createdAt}, cartItems: ${_this.cartItems}, customerId: ${_this.customerId}, customerName: ${_this.customerName}, cartDiscountType: ${_this.cartDiscountType}, cartDiscountValue: ${_this.cartDiscountValue}, itemCount: ${_this.itemCount}, totalAmount: ${_this.totalAmount})';
}


}

/// @nodoc
abstract mixin class $HeldOrderModelCopyWith<$Res>  {
  factory $HeldOrderModelCopyWith(HeldOrderModel value, $Res Function(HeldOrderModel) _then) = _$HeldOrderModelCopyWithImpl;
@useResult
$Res call({
 String id, String label, DateTime createdAt, List<CartItemModel> cartItems, String? customerId, String? customerName, String? cartDiscountType, Decimal? cartDiscountValue, int itemCount, Decimal totalAmount
});




}
/// @nodoc
class _$HeldOrderModelCopyWithImpl<$Res>
    implements $HeldOrderModelCopyWith<$Res> {
  _$HeldOrderModelCopyWithImpl(this._self, this._then);

  final HeldOrderModel _self;
  final $Res Function(HeldOrderModel) _then;

/// Create a copy of HeldOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? createdAt = null,Object? cartItems = null,Object? customerId = freezed,Object? customerName = freezed,Object? cartDiscountType = freezed,Object? cartDiscountValue = freezed,Object? itemCount = null,Object? totalAmount = null,}) {
  return _then(HeldOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,cartDiscountType: freezed == cartDiscountType ? _self.cartDiscountType : cartDiscountType // ignore: cast_nullable_to_non_nullable
as String?,cartDiscountValue: freezed == cartDiscountValue ? _self.cartDiscountValue : cartDiscountValue // ignore: cast_nullable_to_non_nullable
as Decimal?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [HeldOrderModel].
extension HeldOrderModelPatterns on HeldOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeldOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeldOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeldOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _HeldOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeldOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _HeldOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  DateTime createdAt,  List<CartItemModel> cartItems,  String? customerId,  String? customerName,  String? cartDiscountType,  Decimal? cartDiscountValue,  int itemCount,  Decimal totalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeldOrderModel() when $default != null:
return $default(_that.id,_that.label,_that.createdAt,_that.cartItems,_that.customerId,_that.customerName,_that.cartDiscountType,_that.cartDiscountValue,_that.itemCount,_that.totalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  DateTime createdAt,  List<CartItemModel> cartItems,  String? customerId,  String? customerName,  String? cartDiscountType,  Decimal? cartDiscountValue,  int itemCount,  Decimal totalAmount)  $default,) {final _that = this;
switch (_that) {
case _HeldOrderModel():
return $default(_that.id,_that.label,_that.createdAt,_that.cartItems,_that.customerId,_that.customerName,_that.cartDiscountType,_that.cartDiscountValue,_that.itemCount,_that.totalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  DateTime createdAt,  List<CartItemModel> cartItems,  String? customerId,  String? customerName,  String? cartDiscountType,  Decimal? cartDiscountValue,  int itemCount,  Decimal totalAmount)?  $default,) {final _that = this;
switch (_that) {
case _HeldOrderModel() when $default != null:
return $default(_that.id,_that.label,_that.createdAt,_that.cartItems,_that.customerId,_that.customerName,_that.cartDiscountType,_that.cartDiscountValue,_that.itemCount,_that.totalAmount);case _:
  return null;

}
}

}

/// @nodoc


class _HeldOrderModel implements HeldOrderModel {
  const _HeldOrderModel({required this.id, required this.label, required this.createdAt, required  List<CartItemModel> cartItems, this.customerId, this.customerName, this.cartDiscountType, this.cartDiscountValue, required this.itemCount, required this.totalAmount}): _cartItems = cartItems;
  

@override final  String id;
@override final  String label;
@override final  DateTime createdAt;
 final  List<CartItemModel> _cartItems;
@override List<CartItemModel> get cartItems {
  if (_cartItems is EqualUnmodifiableListView) return _cartItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartItems);
}

@override final  String? customerId;
@override final  String? customerName;
@override final  String? cartDiscountType;
@override final  Decimal? cartDiscountValue;
@override final  int itemCount;
@override final  Decimal totalAmount;

/// Create a copy of HeldOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeldOrderModelCopyWith<_HeldOrderModel> get copyWith => __$HeldOrderModelCopyWithImpl<_HeldOrderModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeldOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.cartItems, _cartItems)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.cartDiscountType, cartDiscountType) || other.cartDiscountType == cartDiscountType)&&(identical(other.cartDiscountValue, cartDiscountValue) || other.cartDiscountValue == cartDiscountValue)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,label,createdAt,const DeepCollectionEquality().hash(_cartItems),customerId,customerName,cartDiscountType,cartDiscountValue,itemCount,totalAmount);
}

@override
String toString() {
    return 'HeldOrderModel(id: $id, label: $label, createdAt: $createdAt, cartItems: $cartItems, customerId: $customerId, customerName: $customerName, cartDiscountType: $cartDiscountType, cartDiscountValue: $cartDiscountValue, itemCount: $itemCount, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class _$HeldOrderModelCopyWith<$Res> implements $HeldOrderModelCopyWith<$Res> {
  factory _$HeldOrderModelCopyWith(_HeldOrderModel value, $Res Function(_HeldOrderModel) _then) = __$HeldOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, DateTime createdAt, List<CartItemModel> cartItems, String? customerId, String? customerName, String? cartDiscountType, Decimal? cartDiscountValue, int itemCount, Decimal totalAmount
});




}
/// @nodoc
class __$HeldOrderModelCopyWithImpl<$Res>
    implements _$HeldOrderModelCopyWith<$Res> {
  __$HeldOrderModelCopyWithImpl(this._self, this._then);

  final _HeldOrderModel _self;
  final $Res Function(_HeldOrderModel) _then;

/// Create a copy of HeldOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? createdAt = null,Object? cartItems = null,Object? customerId = freezed,Object? customerName = freezed,Object? cartDiscountType = freezed,Object? cartDiscountValue = freezed,Object? itemCount = null,Object? totalAmount = null,}) {
  return _then(_HeldOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,cartDiscountType: freezed == cartDiscountType ? _self.cartDiscountType : cartDiscountType // ignore: cast_nullable_to_non_nullable
as String?,cartDiscountValue: freezed == cartDiscountValue ? _self.cartDiscountValue : cartDiscountValue // ignore: cast_nullable_to_non_nullable
as Decimal?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
