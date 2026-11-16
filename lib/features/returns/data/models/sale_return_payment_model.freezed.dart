// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleReturnPaymentModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'sale_return_id') String get saleReturnId;@JsonKey(name: 'payment_method') String get paymentMethod; String get amount; String get status;@JsonKey(name: 'refunded_at') String? get refundedAt;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of SaleReturnPaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnPaymentModelCopyWith<SaleReturnPaymentModel> get copyWith => _$SaleReturnPaymentModelCopyWithImpl<SaleReturnPaymentModel>(this as SaleReturnPaymentModel, _$identity);

  /// Serializes this SaleReturnPaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleReturnPaymentModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnPaymentModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.saleReturnId, _this.saleReturnId) || other.saleReturnId == _this.saleReturnId)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.refundedAt, _this.refundedAt) || other.refundedAt == _this.refundedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleReturnPaymentModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.saleReturnId,_this.paymentMethod,_this.amount,_this.status,_this.refundedAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as SaleReturnPaymentModel;
  return 'SaleReturnPaymentModel(id: ${_this.id}, businessId: ${_this.businessId}, saleReturnId: ${_this.saleReturnId}, paymentMethod: ${_this.paymentMethod}, amount: ${_this.amount}, status: ${_this.status}, refundedAt: ${_this.refundedAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SaleReturnPaymentModelCopyWith<$Res>  {
  factory $SaleReturnPaymentModelCopyWith(SaleReturnPaymentModel value, $Res Function(SaleReturnPaymentModel) _then) = _$SaleReturnPaymentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'sale_return_id') String saleReturnId,@JsonKey(name: 'payment_method') String paymentMethod, String amount, String status,@JsonKey(name: 'refunded_at') String? refundedAt,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$SaleReturnPaymentModelCopyWithImpl<$Res>
    implements $SaleReturnPaymentModelCopyWith<$Res> {
  _$SaleReturnPaymentModelCopyWithImpl(this._self, this._then);

  final SaleReturnPaymentModel _self;
  final $Res Function(SaleReturnPaymentModel) _then;

/// Create a copy of SaleReturnPaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? saleReturnId = null,Object? paymentMethod = null,Object? amount = null,Object? status = null,Object? refundedAt = freezed,Object? createdAt = freezed,}) {
  return _then(SaleReturnPaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,saleReturnId: null == saleReturnId ? _self.saleReturnId : saleReturnId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnPaymentModel].
extension SaleReturnPaymentModelPatterns on SaleReturnPaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnPaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnPaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnPaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnPaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnPaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnPaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount,  String status, @JsonKey(name: 'refunded_at')  String? refundedAt, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnPaymentModel() when $default != null:
return $default(_that.id,_that.businessId,_that.saleReturnId,_that.paymentMethod,_that.amount,_that.status,_that.refundedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount,  String status, @JsonKey(name: 'refunded_at')  String? refundedAt, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnPaymentModel():
return $default(_that.id,_that.businessId,_that.saleReturnId,_that.paymentMethod,_that.amount,_that.status,_that.refundedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'payment_method')  String paymentMethod,  String amount,  String status, @JsonKey(name: 'refunded_at')  String? refundedAt, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnPaymentModel() when $default != null:
return $default(_that.id,_that.businessId,_that.saleReturnId,_that.paymentMethod,_that.amount,_that.status,_that.refundedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnPaymentModel implements SaleReturnPaymentModel {
  const _SaleReturnPaymentModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'sale_return_id') required this.saleReturnId, @JsonKey(name: 'payment_method') required this.paymentMethod, required this.amount, required this.status, @JsonKey(name: 'refunded_at') this.refundedAt, @JsonKey(name: 'created_at') this.createdAt});
  factory _SaleReturnPaymentModel.fromJson(Map<String, dynamic> json) => _$SaleReturnPaymentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'sale_return_id') final  String saleReturnId;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override final  String amount;
@override final  String status;
@override@JsonKey(name: 'refunded_at') final  String? refundedAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of SaleReturnPaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnPaymentModelCopyWith<_SaleReturnPaymentModel> get copyWith => __$SaleReturnPaymentModelCopyWithImpl<_SaleReturnPaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnPaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnPaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.saleReturnId, saleReturnId) || other.saleReturnId == saleReturnId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,saleReturnId,paymentMethod,amount,status,refundedAt,createdAt);
}

@override
String toString() {
    return 'SaleReturnPaymentModel(id: $id, businessId: $businessId, saleReturnId: $saleReturnId, paymentMethod: $paymentMethod, amount: $amount, status: $status, refundedAt: $refundedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnPaymentModelCopyWith<$Res> implements $SaleReturnPaymentModelCopyWith<$Res> {
  factory _$SaleReturnPaymentModelCopyWith(_SaleReturnPaymentModel value, $Res Function(_SaleReturnPaymentModel) _then) = __$SaleReturnPaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'sale_return_id') String saleReturnId,@JsonKey(name: 'payment_method') String paymentMethod, String amount, String status,@JsonKey(name: 'refunded_at') String? refundedAt,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$SaleReturnPaymentModelCopyWithImpl<$Res>
    implements _$SaleReturnPaymentModelCopyWith<$Res> {
  __$SaleReturnPaymentModelCopyWithImpl(this._self, this._then);

  final _SaleReturnPaymentModel _self;
  final $Res Function(_SaleReturnPaymentModel) _then;

/// Create a copy of SaleReturnPaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? saleReturnId = null,Object? paymentMethod = null,Object? amount = null,Object? status = null,Object? refundedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_SaleReturnPaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,saleReturnId: null == saleReturnId ? _self.saleReturnId : saleReturnId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
