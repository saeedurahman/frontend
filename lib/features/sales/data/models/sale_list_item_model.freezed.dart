// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleListItemModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'customer_id') String? get customerId;@JsonKey(name: 'sale_number') String get saleNumber;@JsonKey(name: 'sale_type') String get saleType; String get status;@JsonKey(name: 'sold_at') String get soldAt;@JsonKey(name: 'total_amount') String? get totalAmount;@JsonKey(name: 'total_paid') String? get totalPaid;@JsonKey(name: 'balance_due') String? get balanceDue;@JsonKey(name: 'customer_name') String? get customerName;@JsonKey(name: 'cashier_name') String? get cashierName;@JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull) int? get itemCount;@JsonKey(name: 'product_names') List<String> get productNames;@JsonKey(name: 'payment_methods') List<String> get paymentMethods;
/// Create a copy of SaleListItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleListItemModelCopyWith<SaleListItemModel> get copyWith => _$SaleListItemModelCopyWithImpl<SaleListItemModel>(this as SaleListItemModel, _$identity);

  /// Serializes this SaleListItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaleListItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleListItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.saleNumber, _this.saleNumber) || other.saleNumber == _this.saleNumber)&&(identical(other.saleType, _this.saleType) || other.saleType == _this.saleType)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.soldAt, _this.soldAt) || other.soldAt == _this.soldAt)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.totalPaid, _this.totalPaid) || other.totalPaid == _this.totalPaid)&&(identical(other.balanceDue, _this.balanceDue) || other.balanceDue == _this.balanceDue)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.cashierName, _this.cashierName) || other.cashierName == _this.cashierName)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&const DeepCollectionEquality().equals(other.productNames, _this.productNames)&&const DeepCollectionEquality().equals(other.paymentMethods, _this.paymentMethods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaleListItemModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.customerId,_this.saleNumber,_this.saleType,_this.status,_this.soldAt,_this.totalAmount,_this.totalPaid,_this.balanceDue,_this.customerName,_this.cashierName,_this.itemCount,const DeepCollectionEquality().hash(_this.productNames),const DeepCollectionEquality().hash(_this.paymentMethods));
}

@override
String toString() {
  final _this = this as SaleListItemModel;
  return 'SaleListItemModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, customerId: ${_this.customerId}, saleNumber: ${_this.saleNumber}, saleType: ${_this.saleType}, status: ${_this.status}, soldAt: ${_this.soldAt}, totalAmount: ${_this.totalAmount}, totalPaid: ${_this.totalPaid}, balanceDue: ${_this.balanceDue}, customerName: ${_this.customerName}, cashierName: ${_this.cashierName}, itemCount: ${_this.itemCount}, productNames: ${_this.productNames}, paymentMethods: ${_this.paymentMethods})';
}


}

/// @nodoc
abstract mixin class $SaleListItemModelCopyWith<$Res>  {
  factory $SaleListItemModelCopyWith(SaleListItemModel value, $Res Function(SaleListItemModel) _then) = _$SaleListItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'sale_number') String saleNumber,@JsonKey(name: 'sale_type') String saleType, String status,@JsonKey(name: 'sold_at') String soldAt,@JsonKey(name: 'total_amount') String? totalAmount,@JsonKey(name: 'total_paid') String? totalPaid,@JsonKey(name: 'balance_due') String? balanceDue,@JsonKey(name: 'customer_name') String? customerName,@JsonKey(name: 'cashier_name') String? cashierName,@JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull) int? itemCount,@JsonKey(name: 'product_names') List<String> productNames,@JsonKey(name: 'payment_methods') List<String> paymentMethods
});




}
/// @nodoc
class _$SaleListItemModelCopyWithImpl<$Res>
    implements $SaleListItemModelCopyWith<$Res> {
  _$SaleListItemModelCopyWithImpl(this._self, this._then);

  final SaleListItemModel _self;
  final $Res Function(SaleListItemModel) _then;

/// Create a copy of SaleListItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? customerId = freezed,Object? saleNumber = null,Object? saleType = null,Object? status = null,Object? soldAt = null,Object? totalAmount = freezed,Object? totalPaid = freezed,Object? balanceDue = freezed,Object? customerName = freezed,Object? cashierName = freezed,Object? itemCount = freezed,Object? productNames = null,Object? paymentMethods = null,}) {
  return _then(SaleListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,saleNumber: null == saleNumber ? _self.saleNumber : saleNumber // ignore: cast_nullable_to_non_nullable
as String,saleType: null == saleType ? _self.saleType : saleType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,soldAt: null == soldAt ? _self.soldAt : soldAt // ignore: cast_nullable_to_non_nullable
as String,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,totalPaid: freezed == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String?,balanceDue: freezed == balanceDue ? _self.balanceDue : balanceDue // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,cashierName: freezed == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String?,itemCount: freezed == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int?,productNames: null == productNames ? _self.productNames : productNames // ignore: cast_nullable_to_non_nullable
as List<String>,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleListItemModel].
extension SaleListItemModelPatterns on SaleListItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleListItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleListItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleListItemModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleListItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleListItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleListItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'sale_number')  String saleNumber, @JsonKey(name: 'sale_type')  String saleType,  String status, @JsonKey(name: 'sold_at')  String soldAt, @JsonKey(name: 'total_amount')  String? totalAmount, @JsonKey(name: 'total_paid')  String? totalPaid, @JsonKey(name: 'balance_due')  String? balanceDue, @JsonKey(name: 'customer_name')  String? customerName, @JsonKey(name: 'cashier_name')  String? cashierName, @JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull)  int? itemCount, @JsonKey(name: 'product_names')  List<String> productNames, @JsonKey(name: 'payment_methods')  List<String> paymentMethods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleListItemModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.customerId,_that.saleNumber,_that.saleType,_that.status,_that.soldAt,_that.totalAmount,_that.totalPaid,_that.balanceDue,_that.customerName,_that.cashierName,_that.itemCount,_that.productNames,_that.paymentMethods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'sale_number')  String saleNumber, @JsonKey(name: 'sale_type')  String saleType,  String status, @JsonKey(name: 'sold_at')  String soldAt, @JsonKey(name: 'total_amount')  String? totalAmount, @JsonKey(name: 'total_paid')  String? totalPaid, @JsonKey(name: 'balance_due')  String? balanceDue, @JsonKey(name: 'customer_name')  String? customerName, @JsonKey(name: 'cashier_name')  String? cashierName, @JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull)  int? itemCount, @JsonKey(name: 'product_names')  List<String> productNames, @JsonKey(name: 'payment_methods')  List<String> paymentMethods)  $default,) {final _that = this;
switch (_that) {
case _SaleListItemModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.customerId,_that.saleNumber,_that.saleType,_that.status,_that.soldAt,_that.totalAmount,_that.totalPaid,_that.balanceDue,_that.customerName,_that.cashierName,_that.itemCount,_that.productNames,_that.paymentMethods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'sale_number')  String saleNumber, @JsonKey(name: 'sale_type')  String saleType,  String status, @JsonKey(name: 'sold_at')  String soldAt, @JsonKey(name: 'total_amount')  String? totalAmount, @JsonKey(name: 'total_paid')  String? totalPaid, @JsonKey(name: 'balance_due')  String? balanceDue, @JsonKey(name: 'customer_name')  String? customerName, @JsonKey(name: 'cashier_name')  String? cashierName, @JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull)  int? itemCount, @JsonKey(name: 'product_names')  List<String> productNames, @JsonKey(name: 'payment_methods')  List<String> paymentMethods)?  $default,) {final _that = this;
switch (_that) {
case _SaleListItemModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.customerId,_that.saleNumber,_that.saleType,_that.status,_that.soldAt,_that.totalAmount,_that.totalPaid,_that.balanceDue,_that.customerName,_that.cashierName,_that.itemCount,_that.productNames,_that.paymentMethods);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleListItemModel implements SaleListItemModel {
  const _SaleListItemModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'customer_id') this.customerId, @JsonKey(name: 'sale_number') required this.saleNumber, @JsonKey(name: 'sale_type') required this.saleType, required this.status, @JsonKey(name: 'sold_at') required this.soldAt, @JsonKey(name: 'total_amount') this.totalAmount, @JsonKey(name: 'total_paid') this.totalPaid, @JsonKey(name: 'balance_due') this.balanceDue, @JsonKey(name: 'customer_name') this.customerName, @JsonKey(name: 'cashier_name') this.cashierName, @JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull) this.itemCount, @JsonKey(name: 'product_names')  List<String> productNames = const [], @JsonKey(name: 'payment_methods')  List<String> paymentMethods = const []}): _productNames = productNames,_paymentMethods = paymentMethods;
  factory _SaleListItemModel.fromJson(Map<String, dynamic> json) => _$SaleListItemModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'customer_id') final  String? customerId;
@override@JsonKey(name: 'sale_number') final  String saleNumber;
@override@JsonKey(name: 'sale_type') final  String saleType;
@override final  String status;
@override@JsonKey(name: 'sold_at') final  String soldAt;
@override@JsonKey(name: 'total_amount') final  String? totalAmount;
@override@JsonKey(name: 'total_paid') final  String? totalPaid;
@override@JsonKey(name: 'balance_due') final  String? balanceDue;
@override@JsonKey(name: 'customer_name') final  String? customerName;
@override@JsonKey(name: 'cashier_name') final  String? cashierName;
@override@JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull) final  int? itemCount;
 final  List<String> _productNames;
@override@JsonKey(name: 'product_names') List<String> get productNames {
  if (_productNames is EqualUnmodifiableListView) return _productNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_productNames);
}

 final  List<String> _paymentMethods;
@override@JsonKey(name: 'payment_methods') List<String> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}


/// Create a copy of SaleListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleListItemModelCopyWith<_SaleListItemModel> get copyWith => __$SaleListItemModelCopyWithImpl<_SaleListItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleListItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.saleNumber, saleNumber) || other.saleNumber == saleNumber)&&(identical(other.saleType, saleType) || other.saleType == saleType)&&(identical(other.status, status) || other.status == status)&&(identical(other.soldAt, soldAt) || other.soldAt == soldAt)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.balanceDue, balanceDue) || other.balanceDue == balanceDue)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&const DeepCollectionEquality().equals(other.productNames, _productNames)&&const DeepCollectionEquality().equals(other.paymentMethods, _paymentMethods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,customerId,saleNumber,saleType,status,soldAt,totalAmount,totalPaid,balanceDue,customerName,cashierName,itemCount,const DeepCollectionEquality().hash(_productNames),const DeepCollectionEquality().hash(_paymentMethods));
}

@override
String toString() {
    return 'SaleListItemModel(id: $id, businessId: $businessId, branchId: $branchId, customerId: $customerId, saleNumber: $saleNumber, saleType: $saleType, status: $status, soldAt: $soldAt, totalAmount: $totalAmount, totalPaid: $totalPaid, balanceDue: $balanceDue, customerName: $customerName, cashierName: $cashierName, itemCount: $itemCount, productNames: $productNames, paymentMethods: $paymentMethods)';
}


}

/// @nodoc
abstract mixin class _$SaleListItemModelCopyWith<$Res> implements $SaleListItemModelCopyWith<$Res> {
  factory _$SaleListItemModelCopyWith(_SaleListItemModel value, $Res Function(_SaleListItemModel) _then) = __$SaleListItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'sale_number') String saleNumber,@JsonKey(name: 'sale_type') String saleType, String status,@JsonKey(name: 'sold_at') String soldAt,@JsonKey(name: 'total_amount') String? totalAmount,@JsonKey(name: 'total_paid') String? totalPaid,@JsonKey(name: 'balance_due') String? balanceDue,@JsonKey(name: 'customer_name') String? customerName,@JsonKey(name: 'cashier_name') String? cashierName,@JsonKey(name: 'item_count', fromJson: JsonNum.intOrNull) int? itemCount,@JsonKey(name: 'product_names') List<String> productNames,@JsonKey(name: 'payment_methods') List<String> paymentMethods
});




}
/// @nodoc
class __$SaleListItemModelCopyWithImpl<$Res>
    implements _$SaleListItemModelCopyWith<$Res> {
  __$SaleListItemModelCopyWithImpl(this._self, this._then);

  final _SaleListItemModel _self;
  final $Res Function(_SaleListItemModel) _then;

/// Create a copy of SaleListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? customerId = freezed,Object? saleNumber = null,Object? saleType = null,Object? status = null,Object? soldAt = null,Object? totalAmount = freezed,Object? totalPaid = freezed,Object? balanceDue = freezed,Object? customerName = freezed,Object? cashierName = freezed,Object? itemCount = freezed,Object? productNames = null,Object? paymentMethods = null,}) {
  return _then(_SaleListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,saleNumber: null == saleNumber ? _self.saleNumber : saleNumber // ignore: cast_nullable_to_non_nullable
as String,saleType: null == saleType ? _self.saleType : saleType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,soldAt: null == soldAt ? _self.soldAt : soldAt // ignore: cast_nullable_to_non_nullable
as String,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,totalPaid: freezed == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String?,balanceDue: freezed == balanceDue ? _self.balanceDue : balanceDue // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,cashierName: freezed == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String?,itemCount: freezed == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int?,productNames: null == productNames ? _self._productNames : productNames // ignore: cast_nullable_to_non_nullable
as List<String>,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
