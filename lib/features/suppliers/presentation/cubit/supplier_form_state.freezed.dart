// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupplierFormState {

 String get mode; String? get supplierId; String get name; String get contactPerson; String get email; String get phone; String get taxId; String get addressLine1; String get city; String get paymentTermsDays; bool get isLoading; bool get isSubmitting; Map<String, String> get errors;
/// Create a copy of SupplierFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierFormStateCopyWith<SupplierFormState> get copyWith => _$SupplierFormStateCopyWithImpl<SupplierFormState>(this as SupplierFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SupplierFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.contactPerson, _this.contactPerson) || other.contactPerson == _this.contactPerson)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.taxId, _this.taxId) || other.taxId == _this.taxId)&&(identical(other.addressLine1, _this.addressLine1) || other.addressLine1 == _this.addressLine1)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.paymentTermsDays, _this.paymentTermsDays) || other.paymentTermsDays == _this.paymentTermsDays)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as SupplierFormState;
  return Object.hash(runtimeType,_this.mode,_this.supplierId,_this.name,_this.contactPerson,_this.email,_this.phone,_this.taxId,_this.addressLine1,_this.city,_this.paymentTermsDays,_this.isLoading,_this.isSubmitting,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as SupplierFormState;
  return 'SupplierFormState(mode: ${_this.mode}, supplierId: ${_this.supplierId}, name: ${_this.name}, contactPerson: ${_this.contactPerson}, email: ${_this.email}, phone: ${_this.phone}, taxId: ${_this.taxId}, addressLine1: ${_this.addressLine1}, city: ${_this.city}, paymentTermsDays: ${_this.paymentTermsDays}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $SupplierFormStateCopyWith<$Res>  {
  factory $SupplierFormStateCopyWith(SupplierFormState value, $Res Function(SupplierFormState) _then) = _$SupplierFormStateCopyWithImpl;
@useResult
$Res call({
 String mode, String? supplierId, String name, String contactPerson, String email, String phone, String taxId, String addressLine1, String city, String paymentTermsDays, bool isLoading, bool isSubmitting, Map<String, String> errors
});




}
/// @nodoc
class _$SupplierFormStateCopyWithImpl<$Res>
    implements $SupplierFormStateCopyWith<$Res> {
  _$SupplierFormStateCopyWithImpl(this._self, this._then);

  final SupplierFormState _self;
  final $Res Function(SupplierFormState) _then;

/// Create a copy of SupplierFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? supplierId = freezed,Object? name = null,Object? contactPerson = null,Object? email = null,Object? phone = null,Object? taxId = null,Object? addressLine1 = null,Object? city = null,Object? paymentTermsDays = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,}) {
  return _then(SupplierFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: null == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,taxId: null == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String,addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplierFormState].
extension SupplierFormStatePatterns on SupplierFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierFormState value)  $default,){
final _that = this;
switch (_that) {
case _SupplierFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierFormState value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  String? supplierId,  String name,  String contactPerson,  String email,  String phone,  String taxId,  String addressLine1,  String city,  String paymentTermsDays,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierFormState() when $default != null:
return $default(_that.mode,_that.supplierId,_that.name,_that.contactPerson,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.paymentTermsDays,_that.isLoading,_that.isSubmitting,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  String? supplierId,  String name,  String contactPerson,  String email,  String phone,  String taxId,  String addressLine1,  String city,  String paymentTermsDays,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _SupplierFormState():
return $default(_that.mode,_that.supplierId,_that.name,_that.contactPerson,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.paymentTermsDays,_that.isLoading,_that.isSubmitting,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  String? supplierId,  String name,  String contactPerson,  String email,  String phone,  String taxId,  String addressLine1,  String city,  String paymentTermsDays,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _SupplierFormState() when $default != null:
return $default(_that.mode,_that.supplierId,_that.name,_that.contactPerson,_that.email,_that.phone,_that.taxId,_that.addressLine1,_that.city,_that.paymentTermsDays,_that.isLoading,_that.isSubmitting,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _SupplierFormState implements SupplierFormState {
  const _SupplierFormState({this.mode = 'create', this.supplierId, this.name = '', this.contactPerson = '', this.email = '', this.phone = '', this.taxId = '', this.addressLine1 = '', this.city = '', this.paymentTermsDays = '30', this.isLoading = false, this.isSubmitting = false,  Map<String, String> errors = const {}}): _errors = errors;
  

@override@JsonKey() final  String mode;
@override final  String? supplierId;
@override@JsonKey() final  String name;
@override@JsonKey() final  String contactPerson;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String taxId;
@override@JsonKey() final  String addressLine1;
@override@JsonKey() final  String city;
@override@JsonKey() final  String paymentTermsDays;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of SupplierFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierFormStateCopyWith<_SupplierFormState> get copyWith => __$SupplierFormStateCopyWithImpl<_SupplierFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.taxId, taxId) || other.taxId == taxId)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.city, city) || other.city == city)&&(identical(other.paymentTermsDays, paymentTermsDays) || other.paymentTermsDays == paymentTermsDays)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,supplierId,name,contactPerson,email,phone,taxId,addressLine1,city,paymentTermsDays,isLoading,isSubmitting,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'SupplierFormState(mode: $mode, supplierId: $supplierId, name: $name, contactPerson: $contactPerson, email: $email, phone: $phone, taxId: $taxId, addressLine1: $addressLine1, city: $city, paymentTermsDays: $paymentTermsDays, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$SupplierFormStateCopyWith<$Res> implements $SupplierFormStateCopyWith<$Res> {
  factory _$SupplierFormStateCopyWith(_SupplierFormState value, $Res Function(_SupplierFormState) _then) = __$SupplierFormStateCopyWithImpl;
@override @useResult
$Res call({
 String mode, String? supplierId, String name, String contactPerson, String email, String phone, String taxId, String addressLine1, String city, String paymentTermsDays, bool isLoading, bool isSubmitting, Map<String, String> errors
});




}
/// @nodoc
class __$SupplierFormStateCopyWithImpl<$Res>
    implements _$SupplierFormStateCopyWith<$Res> {
  __$SupplierFormStateCopyWithImpl(this._self, this._then);

  final _SupplierFormState _self;
  final $Res Function(_SupplierFormState) _then;

/// Create a copy of SupplierFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? supplierId = freezed,Object? name = null,Object? contactPerson = null,Object? email = null,Object? phone = null,Object? taxId = null,Object? addressLine1 = null,Object? city = null,Object? paymentTermsDays = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,}) {
  return _then(_SupplierFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: null == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,taxId: null == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String,addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
