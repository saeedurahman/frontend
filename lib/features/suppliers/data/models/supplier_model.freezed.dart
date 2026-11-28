// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupplierModel {

 String get id;@JsonKey(name: 'business_id') String get businessId; String get name;@JsonKey(name: 'contact_person') String? get contactPerson; String? get email; String? get phone;@JsonKey(name: 'tax_id') String? get taxId;@JsonKey(name: 'address_line1') String? get addressLine1; String? get city;@JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr) int get paymentTermsDays;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<SupplierModel> get copyWith => _$SupplierModelCopyWithImpl<SupplierModel>(this as SupplierModel, _$identity);

  /// Serializes this SupplierModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SupplierModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.contactPerson, _this.contactPerson) || other.contactPerson == _this.contactPerson)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.taxId, _this.taxId) || other.taxId == _this.taxId)&&(identical(other.addressLine1, _this.addressLine1) || other.addressLine1 == _this.addressLine1)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.paymentTermsDays, _this.paymentTermsDays) || other.paymentTermsDays == _this.paymentTermsDays)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SupplierModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.name,_this.contactPerson,_this.email,_this.phone,_this.taxId,_this.addressLine1,_this.city,_this.paymentTermsDays,_this.isActive,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as SupplierModel;
  return 'SupplierModel(id: ${_this.id}, businessId: ${_this.businessId}, name: ${_this.name}, contactPerson: ${_this.contactPerson}, email: ${_this.email}, phone: ${_this.phone}, taxId: ${_this.taxId}, addressLine1: ${_this.addressLine1}, city: ${_this.city}, paymentTermsDays: ${_this.paymentTermsDays}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $SupplierModelCopyWith<$Res>  {
  factory $SupplierModelCopyWith(SupplierModel value, $Res Function(SupplierModel) _then) = _$SupplierModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'contact_person') String? contactPerson, String? email, String? phone,@JsonKey(name: 'tax_id') String? taxId,@JsonKey(name: 'address_line1') String? addressLine1, String? city,@JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr) int paymentTermsDays,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$SupplierModelCopyWithImpl<$Res>
    implements $SupplierModelCopyWith<$Res> {
  _$SupplierModelCopyWithImpl(this._self, this._then);

  final SupplierModel _self;
  final $Res Function(SupplierModel) _then;

/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? contactPerson = freezed,Object? email = freezed,Object? phone = freezed,Object? taxId = freezed,Object? addressLine1 = freezed,Object? city = freezed,Object? paymentTermsDays = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(SupplierModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplierModel].
extension SupplierModelPatterns on SupplierModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierModel value)  $default,){
final _that = this;
switch (_that) {
case _SupplierModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierModel value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'contact_person')  String? contactPerson,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1,  String? city, @JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr)  int paymentTermsDays, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.contactPerson,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.paymentTermsDays,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'contact_person')  String? contactPerson,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1,  String? city, @JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr)  int paymentTermsDays, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SupplierModel():
return $default(_that.id,_that.businessId,_that.name,_that.contactPerson,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.paymentTermsDays,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId,  String name, @JsonKey(name: 'contact_person')  String? contactPerson,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1,  String? city, @JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr)  int paymentTermsDays, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
return $default(_that.id,_that.businessId,_that.name,_that.contactPerson,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.paymentTermsDays,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupplierModel implements SupplierModel {
  const _SupplierModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, required this.name, @JsonKey(name: 'contact_person') this.contactPerson, this.email, this.phone, @JsonKey(name: 'tax_id') this.taxId, @JsonKey(name: 'address_line1') this.addressLine1, this.city, @JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr) this.paymentTermsDays = 30, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _SupplierModel.fromJson(Map<String, dynamic> json) => _$SupplierModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override final  String name;
@override@JsonKey(name: 'contact_person') final  String? contactPerson;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'tax_id') final  String? taxId;
@override@JsonKey(name: 'address_line1') final  String? addressLine1;
@override final  String? city;
@override@JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr) final  int paymentTermsDays;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierModelCopyWith<_SupplierModel> get copyWith => __$SupplierModelCopyWithImpl<_SupplierModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.taxId, taxId) || other.taxId == taxId)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.paymentTermsDays, paymentTermsDays) || other.paymentTermsDays == paymentTermsDays)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,name,contactPerson,email,phone,taxId,addressLine1,city,paymentTermsDays,isActive,createdAt,updatedAt);
}

@override
String toString() {
    return 'SupplierModel(id: $id, businessId: $businessId, name: $name, contactPerson: $contactPerson, email: $email, phone: $phone, taxId: $taxId, addressLine1: $addressLine1, city: $city, paymentTermsDays: $paymentTermsDays, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SupplierModelCopyWith<$Res> implements $SupplierModelCopyWith<$Res> {
  factory _$SupplierModelCopyWith(_SupplierModel value, $Res Function(_SupplierModel) _then) = __$SupplierModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId, String name,@JsonKey(name: 'contact_person') String? contactPerson, String? email, String? phone,@JsonKey(name: 'tax_id') String? taxId,@JsonKey(name: 'address_line1') String? addressLine1, String? city,@JsonKey(name: 'payment_terms_days', fromJson: JsonNum.intOr) int paymentTermsDays,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$SupplierModelCopyWithImpl<$Res>
    implements _$SupplierModelCopyWith<$Res> {
  __$SupplierModelCopyWithImpl(this._self, this._then);

  final _SupplierModel _self;
  final $Res Function(_SupplierModel) _then;

/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? name = null,Object? contactPerson = freezed,Object? email = freezed,Object? phone = freezed,Object? taxId = freezed,Object? addressLine1 = freezed,Object? city = freezed,Object? paymentTermsDays = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SupplierModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SupplierBalanceModel {

@JsonKey(name: 'supplier_id') String get supplierId; String get balance;@JsonKey(name: 'balance_owed') String? get balanceOwed;@JsonKey(name: 'is_advance') bool get isAdvance;/// Set when this is the device's figure: when its copy was last updated.
@JsonKey(includeFromJson: false, includeToJson: false) DateTime? get asOf;
/// Create a copy of SupplierBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierBalanceModelCopyWith<SupplierBalanceModel> get copyWith => _$SupplierBalanceModelCopyWithImpl<SupplierBalanceModel>(this as SupplierBalanceModel, _$identity);

  /// Serializes this SupplierBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SupplierBalanceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierBalanceModel&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.balanceOwed, _this.balanceOwed) || other.balanceOwed == _this.balanceOwed)&&(identical(other.isAdvance, _this.isAdvance) || other.isAdvance == _this.isAdvance)&&(identical(other.asOf, _this.asOf) || other.asOf == _this.asOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SupplierBalanceModel;
  return Object.hash(runtimeType,_this.supplierId,_this.balance,_this.balanceOwed,_this.isAdvance,_this.asOf);
}

@override
String toString() {
  final _this = this as SupplierBalanceModel;
  return 'SupplierBalanceModel(supplierId: ${_this.supplierId}, balance: ${_this.balance}, balanceOwed: ${_this.balanceOwed}, isAdvance: ${_this.isAdvance}, asOf: ${_this.asOf})';
}


}

/// @nodoc
abstract mixin class $SupplierBalanceModelCopyWith<$Res>  {
  factory $SupplierBalanceModelCopyWith(SupplierBalanceModel value, $Res Function(SupplierBalanceModel) _then) = _$SupplierBalanceModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId, String balance,@JsonKey(name: 'balance_owed') String? balanceOwed,@JsonKey(name: 'is_advance') bool isAdvance,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? asOf
});




}
/// @nodoc
class _$SupplierBalanceModelCopyWithImpl<$Res>
    implements $SupplierBalanceModelCopyWith<$Res> {
  _$SupplierBalanceModelCopyWithImpl(this._self, this._then);

  final SupplierBalanceModel _self;
  final $Res Function(SupplierBalanceModel) _then;

/// Create a copy of SupplierBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplierId = null,Object? balance = null,Object? balanceOwed = freezed,Object? isAdvance = null,Object? asOf = freezed,}) {
  return _then(SupplierBalanceModel(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,balanceOwed: freezed == balanceOwed ? _self.balanceOwed : balanceOwed // ignore: cast_nullable_to_non_nullable
as String?,isAdvance: null == isAdvance ? _self.isAdvance : isAdvance // ignore: cast_nullable_to_non_nullable
as bool,asOf: freezed == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplierBalanceModel].
extension SupplierBalanceModelPatterns on SupplierBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _SupplierBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId,  String balance, @JsonKey(name: 'balance_owed')  String? balanceOwed, @JsonKey(name: 'is_advance')  bool isAdvance, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? asOf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierBalanceModel() when $default != null:
return $default(_that.supplierId,_that.balance,_that.balanceOwed,_that.isAdvance,_that.asOf);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId,  String balance, @JsonKey(name: 'balance_owed')  String? balanceOwed, @JsonKey(name: 'is_advance')  bool isAdvance, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? asOf)  $default,) {final _that = this;
switch (_that) {
case _SupplierBalanceModel():
return $default(_that.supplierId,_that.balance,_that.balanceOwed,_that.isAdvance,_that.asOf);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'supplier_id')  String supplierId,  String balance, @JsonKey(name: 'balance_owed')  String? balanceOwed, @JsonKey(name: 'is_advance')  bool isAdvance, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? asOf)?  $default,) {final _that = this;
switch (_that) {
case _SupplierBalanceModel() when $default != null:
return $default(_that.supplierId,_that.balance,_that.balanceOwed,_that.isAdvance,_that.asOf);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupplierBalanceModel implements SupplierBalanceModel {
  const _SupplierBalanceModel({@JsonKey(name: 'supplier_id') required this.supplierId, required this.balance, @JsonKey(name: 'balance_owed') this.balanceOwed, @JsonKey(name: 'is_advance') this.isAdvance = false, @JsonKey(includeFromJson: false, includeToJson: false) this.asOf});
  factory _SupplierBalanceModel.fromJson(Map<String, dynamic> json) => _$SupplierBalanceModelFromJson(json);

@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override final  String balance;
@override@JsonKey(name: 'balance_owed') final  String? balanceOwed;
@override@JsonKey(name: 'is_advance') final  bool isAdvance;
/// Set when this is the device's figure: when its copy was last updated.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  DateTime? asOf;

/// Create a copy of SupplierBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierBalanceModelCopyWith<_SupplierBalanceModel> get copyWith => __$SupplierBalanceModelCopyWithImpl<_SupplierBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierBalanceModel&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.balanceOwed, balanceOwed) || other.balanceOwed == balanceOwed)&&(identical(other.isAdvance, isAdvance) || other.isAdvance == isAdvance)&&(identical(other.asOf, asOf) || other.asOf == asOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,supplierId,balance,balanceOwed,isAdvance,asOf);
}

@override
String toString() {
    return 'SupplierBalanceModel(supplierId: $supplierId, balance: $balance, balanceOwed: $balanceOwed, isAdvance: $isAdvance, asOf: $asOf)';
}


}

/// @nodoc
abstract mixin class _$SupplierBalanceModelCopyWith<$Res> implements $SupplierBalanceModelCopyWith<$Res> {
  factory _$SupplierBalanceModelCopyWith(_SupplierBalanceModel value, $Res Function(_SupplierBalanceModel) _then) = __$SupplierBalanceModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId, String balance,@JsonKey(name: 'balance_owed') String? balanceOwed,@JsonKey(name: 'is_advance') bool isAdvance,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? asOf
});




}
/// @nodoc
class __$SupplierBalanceModelCopyWithImpl<$Res>
    implements _$SupplierBalanceModelCopyWith<$Res> {
  __$SupplierBalanceModelCopyWithImpl(this._self, this._then);

  final _SupplierBalanceModel _self;
  final $Res Function(_SupplierBalanceModel) _then;

/// Create a copy of SupplierBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplierId = null,Object? balance = null,Object? balanceOwed = freezed,Object? isAdvance = null,Object? asOf = freezed,}) {
  return _then(_SupplierBalanceModel(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,balanceOwed: freezed == balanceOwed ? _self.balanceOwed : balanceOwed // ignore: cast_nullable_to_non_nullable
as String?,isAdvance: null == isAdvance ? _self.isAdvance : isAdvance // ignore: cast_nullable_to_non_nullable
as bool,asOf: freezed == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
