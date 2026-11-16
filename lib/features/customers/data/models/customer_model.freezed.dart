// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name; String? get email; String? get phone;@JsonKey(name: 'tax_id') String? get taxId;@JsonKey(name: 'address_line1') String? get addressLine1; String? get city;@JsonKey(name: 'credit_limit') String get creditLimit;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;@JsonKey(name: 'price_list_id') String? get priceListId;@JsonKey(includeFromJson: false, includeToJson: false) String? get balance;
/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<CustomerModel> get copyWith => _$CustomerModelCopyWithImpl<CustomerModel>(this as CustomerModel, _$identity);

  /// Serializes this CustomerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.taxId, _this.taxId) || other.taxId == _this.taxId)&&(identical(other.addressLine1, _this.addressLine1) || other.addressLine1 == _this.addressLine1)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.creditLimit, _this.creditLimit) || other.creditLimit == _this.creditLimit)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.priceListId, _this.priceListId) || other.priceListId == _this.priceListId)&&(identical(other.balance, _this.balance) || other.balance == _this.balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.email,_this.phone,_this.taxId,_this.addressLine1,_this.city,_this.creditLimit,_this.isActive,_this.createdAt,_this.updatedAt,_this.priceListId,_this.balance);
}

@override
String toString() {
  final _this = this as CustomerModel;
  return 'CustomerModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, taxId: ${_this.taxId}, addressLine1: ${_this.addressLine1}, city: ${_this.city}, creditLimit: ${_this.creditLimit}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, priceListId: ${_this.priceListId}, balance: ${_this.balance})';
}


}

/// @nodoc
abstract mixin class $CustomerModelCopyWith<$Res>  {
  factory $CustomerModelCopyWith(CustomerModel value, $Res Function(CustomerModel) _then) = _$CustomerModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String? email, String? phone,@JsonKey(name: 'tax_id') String? taxId,@JsonKey(name: 'address_line1') String? addressLine1, String? city,@JsonKey(name: 'credit_limit') String creditLimit,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'price_list_id') String? priceListId,@JsonKey(includeFromJson: false, includeToJson: false) String? balance
});




}
/// @nodoc
class _$CustomerModelCopyWithImpl<$Res>
    implements $CustomerModelCopyWith<$Res> {
  _$CustomerModelCopyWithImpl(this._self, this._then);

  final CustomerModel _self;
  final $Res Function(CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? taxId = freezed,Object? addressLine1 = freezed,Object? city = freezed,Object? creditLimit = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? priceListId = freezed,Object? balance = freezed,}) {
  return _then(CustomerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,creditLimit: null == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,priceListId: freezed == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerModel].
extension CustomerModelPatterns on CustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1,  String? city, @JsonKey(name: 'credit_limit')  String creditLimit, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'price_list_id')  String? priceListId, @JsonKey(includeFromJson: false, includeToJson: false)  String? balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.creditLimit,_that.isActive,_that.createdAt,_that.updatedAt,_that.priceListId,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1,  String? city, @JsonKey(name: 'credit_limit')  String creditLimit, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'price_list_id')  String? priceListId, @JsonKey(includeFromJson: false, includeToJson: false)  String? balance)  $default,) {final _that = this;
switch (_that) {
case _CustomerModel():
return $default(_that.id,_that.businessId,_that.name,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.creditLimit,_that.isActive,_that.createdAt,_that.updatedAt,_that.priceListId,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1,  String? city, @JsonKey(name: 'credit_limit')  String creditLimit, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'price_list_id')  String? priceListId, @JsonKey(includeFromJson: false, includeToJson: false)  String? balance)?  $default,) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.creditLimit,_that.isActive,_that.createdAt,_that.updatedAt,_that.priceListId,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerModel implements CustomerModel {
  const _CustomerModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, this.email, this.phone, @JsonKey(name: 'tax_id') this.taxId, @JsonKey(name: 'address_line1') this.addressLine1, this.city, @JsonKey(name: 'credit_limit') this.creditLimit = '0', @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'price_list_id') this.priceListId, @JsonKey(includeFromJson: false, includeToJson: false) this.balance});
  factory _CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'tax_id') final  String? taxId;
@override@JsonKey(name: 'address_line1') final  String? addressLine1;
@override final  String? city;
@override@JsonKey(name: 'credit_limit') final  String creditLimit;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override@JsonKey(name: 'price_list_id') final  String? priceListId;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? balance;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerModelCopyWith<_CustomerModel> get copyWith => __$CustomerModelCopyWithImpl<_CustomerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.taxId, taxId) || other.taxId == taxId)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.priceListId, priceListId) || other.priceListId == priceListId)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,email,phone,taxId,addressLine1,city,creditLimit,isActive,createdAt,updatedAt,priceListId,balance);
}

@override
String toString() {
    return 'CustomerModel(id: $id, businessId: $businessId, name: $name, email: $email, phone: $phone, taxId: $taxId, addressLine1: $addressLine1, city: $city, creditLimit: $creditLimit, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, priceListId: $priceListId, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$CustomerModelCopyWith<$Res> implements $CustomerModelCopyWith<$Res> {
  factory _$CustomerModelCopyWith(_CustomerModel value, $Res Function(_CustomerModel) _then) = __$CustomerModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name, String? email, String? phone,@JsonKey(name: 'tax_id') String? taxId,@JsonKey(name: 'address_line1') String? addressLine1, String? city,@JsonKey(name: 'credit_limit') String creditLimit,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'price_list_id') String? priceListId,@JsonKey(includeFromJson: false, includeToJson: false) String? balance
});




}
/// @nodoc
class __$CustomerModelCopyWithImpl<$Res>
    implements _$CustomerModelCopyWith<$Res> {
  __$CustomerModelCopyWithImpl(this._self, this._then);

  final _CustomerModel _self;
  final $Res Function(_CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? taxId = freezed,Object? addressLine1 = freezed,Object? city = freezed,Object? creditLimit = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? priceListId = freezed,Object? balance = freezed,}) {
  return _then(_CustomerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,creditLimit: null == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,priceListId: freezed == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
