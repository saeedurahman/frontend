// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessTypeModel {

 String get id; String get code; String get name; String? get description;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of BusinessTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessTypeModelCopyWith<BusinessTypeModel> get copyWith => _$BusinessTypeModelCopyWithImpl<BusinessTypeModel>(this as BusinessTypeModel, _$identity);

  /// Serializes this BusinessTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BusinessTypeModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessTypeModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BusinessTypeModel;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.description,_this.isActive);
}

@override
String toString() {
  final _this = this as BusinessTypeModel;
  return 'BusinessTypeModel(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, description: ${_this.description}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $BusinessTypeModelCopyWith<$Res>  {
  factory $BusinessTypeModelCopyWith(BusinessTypeModel value, $Res Function(BusinessTypeModel) _then) = _$BusinessTypeModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String? description,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$BusinessTypeModelCopyWithImpl<$Res>
    implements $BusinessTypeModelCopyWith<$Res> {
  _$BusinessTypeModelCopyWithImpl(this._self, this._then);

  final BusinessTypeModel _self;
  final $Res Function(BusinessTypeModel) _then;

/// Create a copy of BusinessTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? isActive = null,}) {
  return _then(BusinessTypeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessTypeModel].
extension BusinessTypeModelPatterns on BusinessTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _BusinessTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String? description, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessTypeModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String? description, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _BusinessTypeModel():
return $default(_that.id,_that.code,_that.name,_that.description,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  String? description, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _BusinessTypeModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessTypeModel implements BusinessTypeModel {
  const _BusinessTypeModel({required this.id, required this.code, required this.name, this.description, @JsonKey(name: 'is_active') this.isActive = true});
  factory _BusinessTypeModel.fromJson(Map<String, dynamic> json) => _$BusinessTypeModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of BusinessTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessTypeModelCopyWith<_BusinessTypeModel> get copyWith => __$BusinessTypeModelCopyWithImpl<_BusinessTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,description,isActive);
}

@override
String toString() {
    return 'BusinessTypeModel(id: $id, code: $code, name: $name, description: $description, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$BusinessTypeModelCopyWith<$Res> implements $BusinessTypeModelCopyWith<$Res> {
  factory _$BusinessTypeModelCopyWith(_BusinessTypeModel value, $Res Function(_BusinessTypeModel) _then) = __$BusinessTypeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String? description,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$BusinessTypeModelCopyWithImpl<$Res>
    implements _$BusinessTypeModelCopyWith<$Res> {
  __$BusinessTypeModelCopyWithImpl(this._self, this._then);

  final _BusinessTypeModel _self;
  final $Res Function(_BusinessTypeModel) _then;

/// Create a copy of BusinessTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? isActive = null,}) {
  return _then(_BusinessTypeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BusinessProfileModel {

 String get id; String get name;@JsonKey(name: 'legal_name') String? get legalName; String? get email; String? get phone;@JsonKey(name: 'tax_id') String? get taxId;@JsonKey(name: 'address_line1') String? get addressLine1;@JsonKey(name: 'logo_url') String? get logoUrl; String? get city;@JsonKey(name: 'country_code') String get countryCode;@JsonKey(name: 'currency_code') String get currencyCode;@JsonKey(name: 'subscription_plan') String? get subscriptionPlan;@JsonKey(name: 'subscription_status') String? get subscriptionStatus;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'business_type') BusinessTypeModel? get businessType; BusinessConfigModel? get config; List<BranchModel> get branches;
/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProfileModelCopyWith<BusinessProfileModel> get copyWith => _$BusinessProfileModelCopyWithImpl<BusinessProfileModel>(this as BusinessProfileModel, _$identity);

  /// Serializes this BusinessProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BusinessProfileModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProfileModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.legalName, _this.legalName) || other.legalName == _this.legalName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.taxId, _this.taxId) || other.taxId == _this.taxId)&&(identical(other.addressLine1, _this.addressLine1) || other.addressLine1 == _this.addressLine1)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.subscriptionPlan, _this.subscriptionPlan) || other.subscriptionPlan == _this.subscriptionPlan)&&(identical(other.subscriptionStatus, _this.subscriptionStatus) || other.subscriptionStatus == _this.subscriptionStatus)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.businessType, _this.businessType) || other.businessType == _this.businessType)&&(identical(other.config, _this.config) || other.config == _this.config)&&const DeepCollectionEquality().equals(other.branches, _this.branches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BusinessProfileModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.legalName,_this.email,_this.phone,_this.taxId,_this.addressLine1,_this.logoUrl,_this.city,_this.countryCode,_this.currencyCode,_this.subscriptionPlan,_this.subscriptionStatus,_this.isActive,_this.businessType,_this.config,const DeepCollectionEquality().hash(_this.branches));
}

@override
String toString() {
  final _this = this as BusinessProfileModel;
  return 'BusinessProfileModel(id: ${_this.id}, name: ${_this.name}, legalName: ${_this.legalName}, email: ${_this.email}, phone: ${_this.phone}, taxId: ${_this.taxId}, addressLine1: ${_this.addressLine1}, logoUrl: ${_this.logoUrl}, city: ${_this.city}, countryCode: ${_this.countryCode}, currencyCode: ${_this.currencyCode}, subscriptionPlan: ${_this.subscriptionPlan}, subscriptionStatus: ${_this.subscriptionStatus}, isActive: ${_this.isActive}, businessType: ${_this.businessType}, config: ${_this.config}, branches: ${_this.branches})';
}


}

/// @nodoc
abstract mixin class $BusinessProfileModelCopyWith<$Res>  {
  factory $BusinessProfileModelCopyWith(BusinessProfileModel value, $Res Function(BusinessProfileModel) _then) = _$BusinessProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'legal_name') String? legalName, String? email, String? phone,@JsonKey(name: 'tax_id') String? taxId,@JsonKey(name: 'address_line1') String? addressLine1,@JsonKey(name: 'logo_url') String? logoUrl, String? city,@JsonKey(name: 'country_code') String countryCode,@JsonKey(name: 'currency_code') String currencyCode,@JsonKey(name: 'subscription_plan') String? subscriptionPlan,@JsonKey(name: 'subscription_status') String? subscriptionStatus,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'business_type') BusinessTypeModel? businessType, BusinessConfigModel? config, List<BranchModel> branches
});


$BusinessTypeModelCopyWith<$Res>? get businessType;$BusinessConfigModelCopyWith<$Res>? get config;

}
/// @nodoc
class _$BusinessProfileModelCopyWithImpl<$Res>
    implements $BusinessProfileModelCopyWith<$Res> {
  _$BusinessProfileModelCopyWithImpl(this._self, this._then);

  final BusinessProfileModel _self;
  final $Res Function(BusinessProfileModel) _then;

/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? legalName = freezed,Object? email = freezed,Object? phone = freezed,Object? taxId = freezed,Object? addressLine1 = freezed,Object? logoUrl = freezed,Object? city = freezed,Object? countryCode = null,Object? currencyCode = null,Object? subscriptionPlan = freezed,Object? subscriptionStatus = freezed,Object? isActive = null,Object? businessType = freezed,Object? config = freezed,Object? branches = null,}) {
  return _then(BusinessProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,subscriptionPlan: freezed == subscriptionPlan ? _self.subscriptionPlan : subscriptionPlan // ignore: cast_nullable_to_non_nullable
as String?,subscriptionStatus: freezed == subscriptionStatus ? _self.subscriptionStatus : subscriptionStatus // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as BusinessTypeModel?,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as BusinessConfigModel?,branches: null == branches ? _self.branches : branches // ignore: cast_nullable_to_non_nullable
as List<BranchModel>,
  ));
}
/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessTypeModelCopyWith<$Res>? get businessType {
    if (_self.businessType == null) {
    return null;
  }

  return $BusinessTypeModelCopyWith<$Res>(_self.businessType!, (value) {
    return _then(_self.copyWith(businessType: value));
  });
}/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessConfigModelCopyWith<$Res>? get config {
    if (_self.config == null) {
    return null;
  }

  return $BusinessConfigModelCopyWith<$Res>(_self.config!, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [BusinessProfileModel].
extension BusinessProfileModelPatterns on BusinessProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'legal_name')  String? legalName,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1, @JsonKey(name: 'logo_url')  String? logoUrl,  String? city, @JsonKey(name: 'country_code')  String countryCode, @JsonKey(name: 'currency_code')  String currencyCode, @JsonKey(name: 'subscription_plan')  String? subscriptionPlan, @JsonKey(name: 'subscription_status')  String? subscriptionStatus, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'business_type')  BusinessTypeModel? businessType,  BusinessConfigModel? config,  List<BranchModel> branches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProfileModel() when $default != null:
return $default(_that.id,_that.name,_that.legalName,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.logoUrl,_that.city,_that.countryCode,_that.currencyCode,_that.subscriptionPlan,_that.subscriptionStatus,_that.isActive,_that.businessType,_that.config,_that.branches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'legal_name')  String? legalName,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1, @JsonKey(name: 'logo_url')  String? logoUrl,  String? city, @JsonKey(name: 'country_code')  String countryCode, @JsonKey(name: 'currency_code')  String currencyCode, @JsonKey(name: 'subscription_plan')  String? subscriptionPlan, @JsonKey(name: 'subscription_status')  String? subscriptionStatus, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'business_type')  BusinessTypeModel? businessType,  BusinessConfigModel? config,  List<BranchModel> branches)  $default,) {final _that = this;
switch (_that) {
case _BusinessProfileModel():
return $default(_that.id,_that.name,_that.legalName,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.logoUrl,_that.city,_that.countryCode,_that.currencyCode,_that.subscriptionPlan,_that.subscriptionStatus,_that.isActive,_that.businessType,_that.config,_that.branches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'legal_name')  String? legalName,  String? email,  String? phone, @JsonKey(name: 'tax_id')  String? taxId, @JsonKey(name: 'address_line1')  String? addressLine1, @JsonKey(name: 'logo_url')  String? logoUrl,  String? city, @JsonKey(name: 'country_code')  String countryCode, @JsonKey(name: 'currency_code')  String currencyCode, @JsonKey(name: 'subscription_plan')  String? subscriptionPlan, @JsonKey(name: 'subscription_status')  String? subscriptionStatus, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'business_type')  BusinessTypeModel? businessType,  BusinessConfigModel? config,  List<BranchModel> branches)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProfileModel() when $default != null:
return $default(_that.id,_that.name,_that.legalName,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.logoUrl,_that.city,_that.countryCode,_that.currencyCode,_that.subscriptionPlan,_that.subscriptionStatus,_that.isActive,_that.businessType,_that.config,_that.branches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessProfileModel implements BusinessProfileModel {
  const _BusinessProfileModel({required this.id, required this.name, @JsonKey(name: 'legal_name') this.legalName, this.email, this.phone, @JsonKey(name: 'tax_id') this.taxId, @JsonKey(name: 'address_line1') this.addressLine1, @JsonKey(name: 'logo_url') this.logoUrl, this.city, @JsonKey(name: 'country_code') this.countryCode = 'PK', @JsonKey(name: 'currency_code') this.currencyCode = 'PKR', @JsonKey(name: 'subscription_plan') this.subscriptionPlan, @JsonKey(name: 'subscription_status') this.subscriptionStatus, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'business_type') this.businessType, this.config,  List<BranchModel> branches = const []}): _branches = branches;
  factory _BusinessProfileModel.fromJson(Map<String, dynamic> json) => _$BusinessProfileModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'legal_name') final  String? legalName;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'tax_id') final  String? taxId;
@override@JsonKey(name: 'address_line1') final  String? addressLine1;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override final  String? city;
@override@JsonKey(name: 'country_code') final  String countryCode;
@override@JsonKey(name: 'currency_code') final  String currencyCode;
@override@JsonKey(name: 'subscription_plan') final  String? subscriptionPlan;
@override@JsonKey(name: 'subscription_status') final  String? subscriptionStatus;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'business_type') final  BusinessTypeModel? businessType;
@override final  BusinessConfigModel? config;
 final  List<BranchModel> _branches;
@override@JsonKey() List<BranchModel> get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}


/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProfileModelCopyWith<_BusinessProfileModel> get copyWith => __$BusinessProfileModelCopyWithImpl<_BusinessProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.taxId, taxId) || other.taxId == taxId)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.subscriptionPlan, subscriptionPlan) || other.subscriptionPlan == subscriptionPlan)&&(identical(other.subscriptionStatus, subscriptionStatus) || other.subscriptionStatus == subscriptionStatus)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other.branches, _branches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,legalName,email,phone,taxId,addressLine1,logoUrl,city,countryCode,currencyCode,subscriptionPlan,subscriptionStatus,isActive,businessType,config,const DeepCollectionEquality().hash(_branches));
}

@override
String toString() {
    return 'BusinessProfileModel(id: $id, name: $name, legalName: $legalName, email: $email, phone: $phone, taxId: $taxId, addressLine1: $addressLine1, logoUrl: $logoUrl, city: $city, countryCode: $countryCode, currencyCode: $currencyCode, subscriptionPlan: $subscriptionPlan, subscriptionStatus: $subscriptionStatus, isActive: $isActive, businessType: $businessType, config: $config, branches: $branches)';
}


}

/// @nodoc
abstract mixin class _$BusinessProfileModelCopyWith<$Res> implements $BusinessProfileModelCopyWith<$Res> {
  factory _$BusinessProfileModelCopyWith(_BusinessProfileModel value, $Res Function(_BusinessProfileModel) _then) = __$BusinessProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'legal_name') String? legalName, String? email, String? phone,@JsonKey(name: 'tax_id') String? taxId,@JsonKey(name: 'address_line1') String? addressLine1,@JsonKey(name: 'logo_url') String? logoUrl, String? city,@JsonKey(name: 'country_code') String countryCode,@JsonKey(name: 'currency_code') String currencyCode,@JsonKey(name: 'subscription_plan') String? subscriptionPlan,@JsonKey(name: 'subscription_status') String? subscriptionStatus,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'business_type') BusinessTypeModel? businessType, BusinessConfigModel? config, List<BranchModel> branches
});


@override $BusinessTypeModelCopyWith<$Res>? get businessType;@override $BusinessConfigModelCopyWith<$Res>? get config;

}
/// @nodoc
class __$BusinessProfileModelCopyWithImpl<$Res>
    implements _$BusinessProfileModelCopyWith<$Res> {
  __$BusinessProfileModelCopyWithImpl(this._self, this._then);

  final _BusinessProfileModel _self;
  final $Res Function(_BusinessProfileModel) _then;

/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? legalName = freezed,Object? email = freezed,Object? phone = freezed,Object? taxId = freezed,Object? addressLine1 = freezed,Object? logoUrl = freezed,Object? city = freezed,Object? countryCode = null,Object? currencyCode = null,Object? subscriptionPlan = freezed,Object? subscriptionStatus = freezed,Object? isActive = null,Object? businessType = freezed,Object? config = freezed,Object? branches = null,}) {
  return _then(_BusinessProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,subscriptionPlan: freezed == subscriptionPlan ? _self.subscriptionPlan : subscriptionPlan // ignore: cast_nullable_to_non_nullable
as String?,subscriptionStatus: freezed == subscriptionStatus ? _self.subscriptionStatus : subscriptionStatus // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as BusinessTypeModel?,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as BusinessConfigModel?,branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as List<BranchModel>,
  ));
}

/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessTypeModelCopyWith<$Res>? get businessType {
    if (_self.businessType == null) {
    return null;
  }

  return $BusinessTypeModelCopyWith<$Res>(_self.businessType!, (value) {
    return _then(_self.copyWith(businessType: value));
  });
}/// Create a copy of BusinessProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessConfigModelCopyWith<$Res>? get config {
    if (_self.config == null) {
    return null;
  }

  return $BusinessConfigModelCopyWith<$Res>(_self.config!, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
