// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleReturnResponseModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'sale_id') String? get saleId;@JsonKey(name: 'customer_id') String? get customerId;@JsonKey(name: 'return_number') String get returnNumber;@JsonKey(name: 'returned_at') String? get returnedAt; String? get reason; List<SaleReturnLineModel> get lines; List<SaleReturnPaymentModel> get payments;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of SaleReturnResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnResponseModelCopyWith<SaleReturnResponseModel> get copyWith => _$SaleReturnResponseModelCopyWithImpl<SaleReturnResponseModel>(this as SaleReturnResponseModel, _$identity);

  /// Serializes this SaleReturnResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleReturnResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnResponseModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.saleId, _this.saleId) || other.saleId == _this.saleId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.returnNumber, _this.returnNumber) || other.returnNumber == _this.returnNumber)&&(identical(other.returnedAt, _this.returnedAt) || other.returnedAt == _this.returnedAt)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleReturnResponseModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.saleId,_this.customerId,_this.returnNumber,_this.returnedAt,_this.reason,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.payments),_this.createdAt);
}

@override
String toString() {
  final _this = this as SaleReturnResponseModel;
  return 'SaleReturnResponseModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, saleId: ${_this.saleId}, customerId: ${_this.customerId}, returnNumber: ${_this.returnNumber}, returnedAt: ${_this.returnedAt}, reason: ${_this.reason}, lines: ${_this.lines}, payments: ${_this.payments}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SaleReturnResponseModelCopyWith<$Res>  {
  factory $SaleReturnResponseModelCopyWith(SaleReturnResponseModel value, $Res Function(SaleReturnResponseModel) _then) = _$SaleReturnResponseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'return_number') String returnNumber,@JsonKey(name: 'returned_at') String? returnedAt, String? reason, List<SaleReturnLineModel> lines, List<SaleReturnPaymentModel> payments,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$SaleReturnResponseModelCopyWithImpl<$Res>
    implements $SaleReturnResponseModelCopyWith<$Res> {
  _$SaleReturnResponseModelCopyWithImpl(this._self, this._then);

  final SaleReturnResponseModel _self;
  final $Res Function(SaleReturnResponseModel) _then;

/// Create a copy of SaleReturnResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? saleId = freezed,Object? customerId = freezed,Object? returnNumber = null,Object? returnedAt = freezed,Object? reason = freezed,Object? lines = null,Object? payments = null,Object? createdAt = freezed,}) {
  return _then(SaleReturnResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,returnNumber: null == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as String,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleReturnLineModel>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<SaleReturnPaymentModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnResponseModel].
extension SaleReturnResponseModelPatterns on SaleReturnResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'return_number')  String returnNumber, @JsonKey(name: 'returned_at')  String? returnedAt,  String? reason,  List<SaleReturnLineModel> lines,  List<SaleReturnPaymentModel> payments, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnResponseModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.saleId,_that.customerId,_that.returnNumber,_that.returnedAt,_that.reason,_that.lines,_that.payments,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'return_number')  String returnNumber, @JsonKey(name: 'returned_at')  String? returnedAt,  String? reason,  List<SaleReturnLineModel> lines,  List<SaleReturnPaymentModel> payments, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnResponseModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.saleId,_that.customerId,_that.returnNumber,_that.returnedAt,_that.reason,_that.lines,_that.payments,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'return_number')  String returnNumber, @JsonKey(name: 'returned_at')  String? returnedAt,  String? reason,  List<SaleReturnLineModel> lines,  List<SaleReturnPaymentModel> payments, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnResponseModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.saleId,_that.customerId,_that.returnNumber,_that.returnedAt,_that.reason,_that.lines,_that.payments,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnResponseModel implements SaleReturnResponseModel {
  const _SaleReturnResponseModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'sale_id') this.saleId, @JsonKey(name: 'customer_id') this.customerId, @JsonKey(name: 'return_number') required this.returnNumber, @JsonKey(name: 'returned_at') this.returnedAt, this.reason,  List<SaleReturnLineModel> lines = const [],  List<SaleReturnPaymentModel> payments = const [], @JsonKey(name: 'created_at') this.createdAt}): _lines = lines,_payments = payments;
  factory _SaleReturnResponseModel.fromJson(Map<String, dynamic> json) => _$SaleReturnResponseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'sale_id') final  String? saleId;
@override@JsonKey(name: 'customer_id') final  String? customerId;
@override@JsonKey(name: 'return_number') final  String returnNumber;
@override@JsonKey(name: 'returned_at') final  String? returnedAt;
@override final  String? reason;
 final  List<SaleReturnLineModel> _lines;
@override@JsonKey() List<SaleReturnLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<SaleReturnPaymentModel> _payments;
@override@JsonKey() List<SaleReturnPaymentModel> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of SaleReturnResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnResponseModelCopyWith<_SaleReturnResponseModel> get copyWith => __$SaleReturnResponseModelCopyWithImpl<_SaleReturnResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.payments, _payments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,saleId,customerId,returnNumber,returnedAt,reason,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_payments),createdAt);
}

@override
String toString() {
    return 'SaleReturnResponseModel(id: $id, businessId: $businessId, branchId: $branchId, saleId: $saleId, customerId: $customerId, returnNumber: $returnNumber, returnedAt: $returnedAt, reason: $reason, lines: $lines, payments: $payments, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnResponseModelCopyWith<$Res> implements $SaleReturnResponseModelCopyWith<$Res> {
  factory _$SaleReturnResponseModelCopyWith(_SaleReturnResponseModel value, $Res Function(_SaleReturnResponseModel) _then) = __$SaleReturnResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'return_number') String returnNumber,@JsonKey(name: 'returned_at') String? returnedAt, String? reason, List<SaleReturnLineModel> lines, List<SaleReturnPaymentModel> payments,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$SaleReturnResponseModelCopyWithImpl<$Res>
    implements _$SaleReturnResponseModelCopyWith<$Res> {
  __$SaleReturnResponseModelCopyWithImpl(this._self, this._then);

  final _SaleReturnResponseModel _self;
  final $Res Function(_SaleReturnResponseModel) _then;

/// Create a copy of SaleReturnResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? saleId = freezed,Object? customerId = freezed,Object? returnNumber = null,Object? returnedAt = freezed,Object? reason = freezed,Object? lines = null,Object? payments = null,Object? createdAt = freezed,}) {
  return _then(_SaleReturnResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,returnNumber: null == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as String,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleReturnLineModel>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<SaleReturnPaymentModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
