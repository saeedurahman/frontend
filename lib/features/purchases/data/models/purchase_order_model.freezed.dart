// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseLineModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'purchase_order_id') String get purchaseOrderId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'ordered_qty') String get orderedQty;@JsonKey(name: 'received_qty') String get receivedQty;@JsonKey(name: 'qty_remaining') String get qtyRemaining;@JsonKey(name: 'cost_per_unit') String get costPerUnit;@JsonKey(name: 'tax_rate') String get taxRate;@JsonKey(name: 'batch_number') String? get batchNumber;@JsonKey(name: 'expiry_date') String? get expiryDate;@JsonKey(name: 'product_name') String? get productName;@JsonKey(name: 'variation_name') String? get variationName; String? get sku;
/// Create a copy of PurchaseLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseLineModelCopyWith<PurchaseLineModel> get copyWith => _$PurchaseLineModelCopyWithImpl<PurchaseLineModel>(this as PurchaseLineModel, _$identity);

  /// Serializes this PurchaseLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PurchaseLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.purchaseOrderId, _this.purchaseOrderId) || other.purchaseOrderId == _this.purchaseOrderId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.orderedQty, _this.orderedQty) || other.orderedQty == _this.orderedQty)&&(identical(other.receivedQty, _this.receivedQty) || other.receivedQty == _this.receivedQty)&&(identical(other.qtyRemaining, _this.qtyRemaining) || other.qtyRemaining == _this.qtyRemaining)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.batchNumber, _this.batchNumber) || other.batchNumber == _this.batchNumber)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationName, _this.variationName) || other.variationName == _this.variationName)&&(identical(other.sku, _this.sku) || other.sku == _this.sku));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PurchaseLineModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.purchaseOrderId,_this.productId,_this.variationId,_this.orderedQty,_this.receivedQty,_this.qtyRemaining,_this.costPerUnit,_this.taxRate,_this.batchNumber,_this.expiryDate,_this.productName,_this.variationName,_this.sku);
}

@override
String toString() {
  final _this = this as PurchaseLineModel;
  return 'PurchaseLineModel(id: ${_this.id}, businessId: ${_this.businessId}, purchaseOrderId: ${_this.purchaseOrderId}, productId: ${_this.productId}, variationId: ${_this.variationId}, orderedQty: ${_this.orderedQty}, receivedQty: ${_this.receivedQty}, qtyRemaining: ${_this.qtyRemaining}, costPerUnit: ${_this.costPerUnit}, taxRate: ${_this.taxRate}, batchNumber: ${_this.batchNumber}, expiryDate: ${_this.expiryDate}, productName: ${_this.productName}, variationName: ${_this.variationName}, sku: ${_this.sku})';
}


}

/// @nodoc
abstract mixin class $PurchaseLineModelCopyWith<$Res>  {
  factory $PurchaseLineModelCopyWith(PurchaseLineModel value, $Res Function(PurchaseLineModel) _then) = _$PurchaseLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'purchase_order_id') String purchaseOrderId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'ordered_qty') String orderedQty,@JsonKey(name: 'received_qty') String receivedQty,@JsonKey(name: 'qty_remaining') String qtyRemaining,@JsonKey(name: 'cost_per_unit') String costPerUnit,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(name: 'expiry_date') String? expiryDate,@JsonKey(name: 'product_name') String? productName,@JsonKey(name: 'variation_name') String? variationName, String? sku
});




}
/// @nodoc
class _$PurchaseLineModelCopyWithImpl<$Res>
    implements $PurchaseLineModelCopyWith<$Res> {
  _$PurchaseLineModelCopyWithImpl(this._self, this._then);

  final PurchaseLineModel _self;
  final $Res Function(PurchaseLineModel) _then;

/// Create a copy of PurchaseLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? purchaseOrderId = null,Object? productId = null,Object? variationId = freezed,Object? orderedQty = null,Object? receivedQty = null,Object? qtyRemaining = null,Object? costPerUnit = null,Object? taxRate = null,Object? batchNumber = freezed,Object? expiryDate = freezed,Object? productName = freezed,Object? variationName = freezed,Object? sku = freezed,}) {
  return _then(PurchaseLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,purchaseOrderId: null == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,orderedQty: null == orderedQty ? _self.orderedQty : orderedQty // ignore: cast_nullable_to_non_nullable
as String,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as String,qtyRemaining: null == qtyRemaining ? _self.qtyRemaining : qtyRemaining // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseLineModel].
extension PurchaseLineModelPatterns on PurchaseLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseLineModel value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'purchase_order_id')  String purchaseOrderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'ordered_qty')  String orderedQty, @JsonKey(name: 'received_qty')  String receivedQty, @JsonKey(name: 'qty_remaining')  String qtyRemaining, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate, @JsonKey(name: 'product_name')  String? productName, @JsonKey(name: 'variation_name')  String? variationName,  String? sku)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseLineModel() when $default != null:
return $default(_that.id,_that.businessId,_that.purchaseOrderId,_that.productId,_that.variationId,_that.orderedQty,_that.receivedQty,_that.qtyRemaining,_that.costPerUnit,_that.taxRate,_that.batchNumber,_that.expiryDate,_that.productName,_that.variationName,_that.sku);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'purchase_order_id')  String purchaseOrderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'ordered_qty')  String orderedQty, @JsonKey(name: 'received_qty')  String receivedQty, @JsonKey(name: 'qty_remaining')  String qtyRemaining, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate, @JsonKey(name: 'product_name')  String? productName, @JsonKey(name: 'variation_name')  String? variationName,  String? sku)  $default,) {final _that = this;
switch (_that) {
case _PurchaseLineModel():
return $default(_that.id,_that.businessId,_that.purchaseOrderId,_that.productId,_that.variationId,_that.orderedQty,_that.receivedQty,_that.qtyRemaining,_that.costPerUnit,_that.taxRate,_that.batchNumber,_that.expiryDate,_that.productName,_that.variationName,_that.sku);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'purchase_order_id')  String purchaseOrderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'ordered_qty')  String orderedQty, @JsonKey(name: 'received_qty')  String receivedQty, @JsonKey(name: 'qty_remaining')  String qtyRemaining, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'tax_rate')  String taxRate, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate, @JsonKey(name: 'product_name')  String? productName, @JsonKey(name: 'variation_name')  String? variationName,  String? sku)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseLineModel() when $default != null:
return $default(_that.id,_that.businessId,_that.purchaseOrderId,_that.productId,_that.variationId,_that.orderedQty,_that.receivedQty,_that.qtyRemaining,_that.costPerUnit,_that.taxRate,_that.batchNumber,_that.expiryDate,_that.productName,_that.variationName,_that.sku);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseLineModel extends PurchaseLineModel {
  const _PurchaseLineModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'purchase_order_id') required this.purchaseOrderId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'ordered_qty') required this.orderedQty, @JsonKey(name: 'received_qty') required this.receivedQty, @JsonKey(name: 'qty_remaining') required this.qtyRemaining, @JsonKey(name: 'cost_per_unit') required this.costPerUnit, @JsonKey(name: 'tax_rate') this.taxRate = '0', @JsonKey(name: 'batch_number') this.batchNumber, @JsonKey(name: 'expiry_date') this.expiryDate, @JsonKey(name: 'product_name') this.productName, @JsonKey(name: 'variation_name') this.variationName, this.sku}): super._();
  factory _PurchaseLineModel.fromJson(Map<String, dynamic> json) => _$PurchaseLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'purchase_order_id') final  String purchaseOrderId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'ordered_qty') final  String orderedQty;
@override@JsonKey(name: 'received_qty') final  String receivedQty;
@override@JsonKey(name: 'qty_remaining') final  String qtyRemaining;
@override@JsonKey(name: 'cost_per_unit') final  String costPerUnit;
@override@JsonKey(name: 'tax_rate') final  String taxRate;
@override@JsonKey(name: 'batch_number') final  String? batchNumber;
@override@JsonKey(name: 'expiry_date') final  String? expiryDate;
@override@JsonKey(name: 'product_name') final  String? productName;
@override@JsonKey(name: 'variation_name') final  String? variationName;
@override final  String? sku;

/// Create a copy of PurchaseLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseLineModelCopyWith<_PurchaseLineModel> get copyWith => __$PurchaseLineModelCopyWithImpl<_PurchaseLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.purchaseOrderId, purchaseOrderId) || other.purchaseOrderId == purchaseOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.orderedQty, orderedQty) || other.orderedQty == orderedQty)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty)&&(identical(other.qtyRemaining, qtyRemaining) || other.qtyRemaining == qtyRemaining)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationName, variationName) || other.variationName == variationName)&&(identical(other.sku, sku) || other.sku == sku));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,purchaseOrderId,productId,variationId,orderedQty,receivedQty,qtyRemaining,costPerUnit,taxRate,batchNumber,expiryDate,productName,variationName,sku);
}

@override
String toString() {
    return 'PurchaseLineModel(id: $id, businessId: $businessId, purchaseOrderId: $purchaseOrderId, productId: $productId, variationId: $variationId, orderedQty: $orderedQty, receivedQty: $receivedQty, qtyRemaining: $qtyRemaining, costPerUnit: $costPerUnit, taxRate: $taxRate, batchNumber: $batchNumber, expiryDate: $expiryDate, productName: $productName, variationName: $variationName, sku: $sku)';
}


}

/// @nodoc
abstract mixin class _$PurchaseLineModelCopyWith<$Res> implements $PurchaseLineModelCopyWith<$Res> {
  factory _$PurchaseLineModelCopyWith(_PurchaseLineModel value, $Res Function(_PurchaseLineModel) _then) = __$PurchaseLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'purchase_order_id') String purchaseOrderId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'ordered_qty') String orderedQty,@JsonKey(name: 'received_qty') String receivedQty,@JsonKey(name: 'qty_remaining') String qtyRemaining,@JsonKey(name: 'cost_per_unit') String costPerUnit,@JsonKey(name: 'tax_rate') String taxRate,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(name: 'expiry_date') String? expiryDate,@JsonKey(name: 'product_name') String? productName,@JsonKey(name: 'variation_name') String? variationName, String? sku
});




}
/// @nodoc
class __$PurchaseLineModelCopyWithImpl<$Res>
    implements _$PurchaseLineModelCopyWith<$Res> {
  __$PurchaseLineModelCopyWithImpl(this._self, this._then);

  final _PurchaseLineModel _self;
  final $Res Function(_PurchaseLineModel) _then;

/// Create a copy of PurchaseLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? purchaseOrderId = null,Object? productId = null,Object? variationId = freezed,Object? orderedQty = null,Object? receivedQty = null,Object? qtyRemaining = null,Object? costPerUnit = null,Object? taxRate = null,Object? batchNumber = freezed,Object? expiryDate = freezed,Object? productName = freezed,Object? variationName = freezed,Object? sku = freezed,}) {
  return _then(_PurchaseLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,purchaseOrderId: null == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,orderedQty: null == orderedQty ? _self.orderedQty : orderedQty // ignore: cast_nullable_to_non_nullable
as String,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as String,qtyRemaining: null == qtyRemaining ? _self.qtyRemaining : qtyRemaining // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PurchaseOrderModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'supplier_id') String get supplierId;@JsonKey(name: 'po_number') String get poNumber; String get status;@JsonKey(name: 'ordered_at') String? get orderedAt;@JsonKey(name: 'expected_at') String? get expectedAt; String? get notes;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; SupplierModel? get supplier; List<PurchaseLineModel> get lines;
/// Create a copy of PurchaseOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderModelCopyWith<PurchaseOrderModel> get copyWith => _$PurchaseOrderModelCopyWithImpl<PurchaseOrderModel>(this as PurchaseOrderModel, _$identity);

  /// Serializes this PurchaseOrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PurchaseOrderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.poNumber, _this.poNumber) || other.poNumber == _this.poNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.orderedAt, _this.orderedAt) || other.orderedAt == _this.orderedAt)&&(identical(other.expectedAt, _this.expectedAt) || other.expectedAt == _this.expectedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.supplier, _this.supplier) || other.supplier == _this.supplier)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PurchaseOrderModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.supplierId,_this.poNumber,_this.status,_this.orderedAt,_this.expectedAt,_this.notes,_this.createdAt,_this.updatedAt,_this.supplier,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as PurchaseOrderModel;
  return 'PurchaseOrderModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, supplierId: ${_this.supplierId}, poNumber: ${_this.poNumber}, status: ${_this.status}, orderedAt: ${_this.orderedAt}, expectedAt: ${_this.expectedAt}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, supplier: ${_this.supplier}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderModelCopyWith<$Res>  {
  factory $PurchaseOrderModelCopyWith(PurchaseOrderModel value, $Res Function(PurchaseOrderModel) _then) = _$PurchaseOrderModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'po_number') String poNumber, String status,@JsonKey(name: 'ordered_at') String? orderedAt,@JsonKey(name: 'expected_at') String? expectedAt, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, SupplierModel? supplier, List<PurchaseLineModel> lines
});


$SupplierModelCopyWith<$Res>? get supplier;

}
/// @nodoc
class _$PurchaseOrderModelCopyWithImpl<$Res>
    implements $PurchaseOrderModelCopyWith<$Res> {
  _$PurchaseOrderModelCopyWithImpl(this._self, this._then);

  final PurchaseOrderModel _self;
  final $Res Function(PurchaseOrderModel) _then;

/// Create a copy of PurchaseOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? supplierId = null,Object? poNumber = null,Object? status = null,Object? orderedAt = freezed,Object? expectedAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? supplier = freezed,Object? lines = null,}) {
  return _then(PurchaseOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,poNumber: null == poNumber ? _self.poNumber : poNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderedAt: freezed == orderedAt ? _self.orderedAt : orderedAt // ignore: cast_nullable_to_non_nullable
as String?,expectedAt: freezed == expectedAt ? _self.expectedAt : expectedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,supplier: freezed == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as SupplierModel?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<PurchaseLineModel>,
  ));
}
/// Create a copy of PurchaseOrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<$Res>? get supplier {
    if (_self.supplier == null) {
    return null;
  }

  return $SupplierModelCopyWith<$Res>(_self.supplier!, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}


/// Adds pattern-matching-related methods to [PurchaseOrderModel].
extension PurchaseOrderModelPatterns on PurchaseOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'po_number')  String poNumber,  String status, @JsonKey(name: 'ordered_at')  String? orderedAt, @JsonKey(name: 'expected_at')  String? expectedAt,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  SupplierModel? supplier,  List<PurchaseLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.supplierId,_that.poNumber,_that.status,_that.orderedAt,_that.expectedAt,_that.notes,_that.createdAt,_that.updatedAt,_that.supplier,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'po_number')  String poNumber,  String status, @JsonKey(name: 'ordered_at')  String? orderedAt, @JsonKey(name: 'expected_at')  String? expectedAt,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  SupplierModel? supplier,  List<PurchaseLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.supplierId,_that.poNumber,_that.status,_that.orderedAt,_that.expectedAt,_that.notes,_that.createdAt,_that.updatedAt,_that.supplier,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'po_number')  String poNumber,  String status, @JsonKey(name: 'ordered_at')  String? orderedAt, @JsonKey(name: 'expected_at')  String? expectedAt,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  SupplierModel? supplier,  List<PurchaseLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.supplierId,_that.poNumber,_that.status,_that.orderedAt,_that.expectedAt,_that.notes,_that.createdAt,_that.updatedAt,_that.supplier,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrderModel extends PurchaseOrderModel {
  const _PurchaseOrderModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'supplier_id') required this.supplierId, @JsonKey(name: 'po_number') required this.poNumber, required this.status, @JsonKey(name: 'ordered_at') this.orderedAt, @JsonKey(name: 'expected_at') this.expectedAt, this.notes, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.supplier,  List<PurchaseLineModel> lines = const []}): _lines = lines,super._();
  factory _PurchaseOrderModel.fromJson(Map<String, dynamic> json) => _$PurchaseOrderModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override@JsonKey(name: 'po_number') final  String poNumber;
@override final  String status;
@override@JsonKey(name: 'ordered_at') final  String? orderedAt;
@override@JsonKey(name: 'expected_at') final  String? expectedAt;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  SupplierModel? supplier;
 final  List<PurchaseLineModel> _lines;
@override@JsonKey() List<PurchaseLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of PurchaseOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderModelCopyWith<_PurchaseOrderModel> get copyWith => __$PurchaseOrderModelCopyWithImpl<_PurchaseOrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.poNumber, poNumber) || other.poNumber == poNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderedAt, orderedAt) || other.orderedAt == orderedAt)&&(identical(other.expectedAt, expectedAt) || other.expectedAt == expectedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,supplierId,poNumber,status,orderedAt,expectedAt,notes,createdAt,updatedAt,supplier,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'PurchaseOrderModel(id: $id, businessId: $businessId, branchId: $branchId, supplierId: $supplierId, poNumber: $poNumber, status: $status, orderedAt: $orderedAt, expectedAt: $expectedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, supplier: $supplier, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderModelCopyWith<$Res> implements $PurchaseOrderModelCopyWith<$Res> {
  factory _$PurchaseOrderModelCopyWith(_PurchaseOrderModel value, $Res Function(_PurchaseOrderModel) _then) = __$PurchaseOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'po_number') String poNumber, String status,@JsonKey(name: 'ordered_at') String? orderedAt,@JsonKey(name: 'expected_at') String? expectedAt, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, SupplierModel? supplier, List<PurchaseLineModel> lines
});


@override $SupplierModelCopyWith<$Res>? get supplier;

}
/// @nodoc
class __$PurchaseOrderModelCopyWithImpl<$Res>
    implements _$PurchaseOrderModelCopyWith<$Res> {
  __$PurchaseOrderModelCopyWithImpl(this._self, this._then);

  final _PurchaseOrderModel _self;
  final $Res Function(_PurchaseOrderModel) _then;

/// Create a copy of PurchaseOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? supplierId = null,Object? poNumber = null,Object? status = null,Object? orderedAt = freezed,Object? expectedAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? supplier = freezed,Object? lines = null,}) {
  return _then(_PurchaseOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,poNumber: null == poNumber ? _self.poNumber : poNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderedAt: freezed == orderedAt ? _self.orderedAt : orderedAt // ignore: cast_nullable_to_non_nullable
as String?,expectedAt: freezed == expectedAt ? _self.expectedAt : expectedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,supplier: freezed == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as SupplierModel?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<PurchaseLineModel>,
  ));
}

/// Create a copy of PurchaseOrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<$Res>? get supplier {
    if (_self.supplier == null) {
    return null;
  }

  return $SupplierModelCopyWith<$Res>(_self.supplier!, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}


/// @nodoc
mixin _$PurchaseReceiptLineModel {

 String get id;@JsonKey(name: 'purchase_receipt_id') String get purchaseReceiptId;@JsonKey(name: 'purchase_line_id') String? get purchaseLineId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'qty_received') String get qtyReceived;@JsonKey(name: 'cost_per_unit') String get costPerUnit;@JsonKey(name: 'batch_number') String? get batchNumber;@JsonKey(name: 'expiry_date') String? get expiryDate;
/// Create a copy of PurchaseReceiptLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseReceiptLineModelCopyWith<PurchaseReceiptLineModel> get copyWith => _$PurchaseReceiptLineModelCopyWithImpl<PurchaseReceiptLineModel>(this as PurchaseReceiptLineModel, _$identity);

  /// Serializes this PurchaseReceiptLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PurchaseReceiptLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseReceiptLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.purchaseReceiptId, _this.purchaseReceiptId) || other.purchaseReceiptId == _this.purchaseReceiptId)&&(identical(other.purchaseLineId, _this.purchaseLineId) || other.purchaseLineId == _this.purchaseLineId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qtyReceived, _this.qtyReceived) || other.qtyReceived == _this.qtyReceived)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.batchNumber, _this.batchNumber) || other.batchNumber == _this.batchNumber)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PurchaseReceiptLineModel;
  return Object.hash(runtimeType,_this.id,_this.purchaseReceiptId,_this.purchaseLineId,_this.productId,_this.variationId,_this.qtyReceived,_this.costPerUnit,_this.batchNumber,_this.expiryDate);
}

@override
String toString() {
  final _this = this as PurchaseReceiptLineModel;
  return 'PurchaseReceiptLineModel(id: ${_this.id}, purchaseReceiptId: ${_this.purchaseReceiptId}, purchaseLineId: ${_this.purchaseLineId}, productId: ${_this.productId}, variationId: ${_this.variationId}, qtyReceived: ${_this.qtyReceived}, costPerUnit: ${_this.costPerUnit}, batchNumber: ${_this.batchNumber}, expiryDate: ${_this.expiryDate})';
}


}

/// @nodoc
abstract mixin class $PurchaseReceiptLineModelCopyWith<$Res>  {
  factory $PurchaseReceiptLineModelCopyWith(PurchaseReceiptLineModel value, $Res Function(PurchaseReceiptLineModel) _then) = _$PurchaseReceiptLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'purchase_receipt_id') String purchaseReceiptId,@JsonKey(name: 'purchase_line_id') String? purchaseLineId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'qty_received') String qtyReceived,@JsonKey(name: 'cost_per_unit') String costPerUnit,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(name: 'expiry_date') String? expiryDate
});




}
/// @nodoc
class _$PurchaseReceiptLineModelCopyWithImpl<$Res>
    implements $PurchaseReceiptLineModelCopyWith<$Res> {
  _$PurchaseReceiptLineModelCopyWithImpl(this._self, this._then);

  final PurchaseReceiptLineModel _self;
  final $Res Function(PurchaseReceiptLineModel) _then;

/// Create a copy of PurchaseReceiptLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? purchaseReceiptId = null,Object? purchaseLineId = freezed,Object? productId = null,Object? variationId = freezed,Object? qtyReceived = null,Object? costPerUnit = null,Object? batchNumber = freezed,Object? expiryDate = freezed,}) {
  return _then(PurchaseReceiptLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purchaseReceiptId: null == purchaseReceiptId ? _self.purchaseReceiptId : purchaseReceiptId // ignore: cast_nullable_to_non_nullable
as String,purchaseLineId: freezed == purchaseLineId ? _self.purchaseLineId : purchaseLineId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qtyReceived: null == qtyReceived ? _self.qtyReceived : qtyReceived // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseReceiptLineModel].
extension PurchaseReceiptLineModelPatterns on PurchaseReceiptLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseReceiptLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseReceiptLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseReceiptLineModel value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseReceiptLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseReceiptLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseReceiptLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'purchase_receipt_id')  String purchaseReceiptId, @JsonKey(name: 'purchase_line_id')  String? purchaseLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_received')  String qtyReceived, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseReceiptLineModel() when $default != null:
return $default(_that.id,_that.purchaseReceiptId,_that.purchaseLineId,_that.productId,_that.variationId,_that.qtyReceived,_that.costPerUnit,_that.batchNumber,_that.expiryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'purchase_receipt_id')  String purchaseReceiptId, @JsonKey(name: 'purchase_line_id')  String? purchaseLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_received')  String qtyReceived, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate)  $default,) {final _that = this;
switch (_that) {
case _PurchaseReceiptLineModel():
return $default(_that.id,_that.purchaseReceiptId,_that.purchaseLineId,_that.productId,_that.variationId,_that.qtyReceived,_that.costPerUnit,_that.batchNumber,_that.expiryDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'purchase_receipt_id')  String purchaseReceiptId, @JsonKey(name: 'purchase_line_id')  String? purchaseLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_received')  String qtyReceived, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseReceiptLineModel() when $default != null:
return $default(_that.id,_that.purchaseReceiptId,_that.purchaseLineId,_that.productId,_that.variationId,_that.qtyReceived,_that.costPerUnit,_that.batchNumber,_that.expiryDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseReceiptLineModel implements PurchaseReceiptLineModel {
  const _PurchaseReceiptLineModel({required this.id, @JsonKey(name: 'purchase_receipt_id') required this.purchaseReceiptId, @JsonKey(name: 'purchase_line_id') this.purchaseLineId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'qty_received') required this.qtyReceived, @JsonKey(name: 'cost_per_unit') required this.costPerUnit, @JsonKey(name: 'batch_number') this.batchNumber, @JsonKey(name: 'expiry_date') this.expiryDate});
  factory _PurchaseReceiptLineModel.fromJson(Map<String, dynamic> json) => _$PurchaseReceiptLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'purchase_receipt_id') final  String purchaseReceiptId;
@override@JsonKey(name: 'purchase_line_id') final  String? purchaseLineId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'qty_received') final  String qtyReceived;
@override@JsonKey(name: 'cost_per_unit') final  String costPerUnit;
@override@JsonKey(name: 'batch_number') final  String? batchNumber;
@override@JsonKey(name: 'expiry_date') final  String? expiryDate;

/// Create a copy of PurchaseReceiptLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseReceiptLineModelCopyWith<_PurchaseReceiptLineModel> get copyWith => __$PurchaseReceiptLineModelCopyWithImpl<_PurchaseReceiptLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseReceiptLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseReceiptLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseReceiptId, purchaseReceiptId) || other.purchaseReceiptId == purchaseReceiptId)&&(identical(other.purchaseLineId, purchaseLineId) || other.purchaseLineId == purchaseLineId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qtyReceived, qtyReceived) || other.qtyReceived == qtyReceived)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,purchaseReceiptId,purchaseLineId,productId,variationId,qtyReceived,costPerUnit,batchNumber,expiryDate);
}

@override
String toString() {
    return 'PurchaseReceiptLineModel(id: $id, purchaseReceiptId: $purchaseReceiptId, purchaseLineId: $purchaseLineId, productId: $productId, variationId: $variationId, qtyReceived: $qtyReceived, costPerUnit: $costPerUnit, batchNumber: $batchNumber, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class _$PurchaseReceiptLineModelCopyWith<$Res> implements $PurchaseReceiptLineModelCopyWith<$Res> {
  factory _$PurchaseReceiptLineModelCopyWith(_PurchaseReceiptLineModel value, $Res Function(_PurchaseReceiptLineModel) _then) = __$PurchaseReceiptLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'purchase_receipt_id') String purchaseReceiptId,@JsonKey(name: 'purchase_line_id') String? purchaseLineId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'qty_received') String qtyReceived,@JsonKey(name: 'cost_per_unit') String costPerUnit,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(name: 'expiry_date') String? expiryDate
});




}
/// @nodoc
class __$PurchaseReceiptLineModelCopyWithImpl<$Res>
    implements _$PurchaseReceiptLineModelCopyWith<$Res> {
  __$PurchaseReceiptLineModelCopyWithImpl(this._self, this._then);

  final _PurchaseReceiptLineModel _self;
  final $Res Function(_PurchaseReceiptLineModel) _then;

/// Create a copy of PurchaseReceiptLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? purchaseReceiptId = null,Object? purchaseLineId = freezed,Object? productId = null,Object? variationId = freezed,Object? qtyReceived = null,Object? costPerUnit = null,Object? batchNumber = freezed,Object? expiryDate = freezed,}) {
  return _then(_PurchaseReceiptLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purchaseReceiptId: null == purchaseReceiptId ? _self.purchaseReceiptId : purchaseReceiptId // ignore: cast_nullable_to_non_nullable
as String,purchaseLineId: freezed == purchaseLineId ? _self.purchaseLineId : purchaseLineId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qtyReceived: null == qtyReceived ? _self.qtyReceived : qtyReceived // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PurchaseReceiptModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'supplier_id') String get supplierId;@JsonKey(name: 'purchase_order_id') String? get purchaseOrderId;@JsonKey(name: 'receipt_number') String get receiptNumber;@JsonKey(name: 'received_at') String get receivedAt;@JsonKey(name: 'supplier_invoice_no') String? get supplierInvoiceNo; String? get notes; List<PurchaseReceiptLineModel> get lines;/// Full receipt total (posted to the supplier account).
@JsonKey(name: 'total_amount') String? get totalAmount;/// The payment made together with the receipt; null when all on credit.
 Map<String, dynamic>? get payment;
/// Create a copy of PurchaseReceiptModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseReceiptModelCopyWith<PurchaseReceiptModel> get copyWith => _$PurchaseReceiptModelCopyWithImpl<PurchaseReceiptModel>(this as PurchaseReceiptModel, _$identity);

  /// Serializes this PurchaseReceiptModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PurchaseReceiptModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseReceiptModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.purchaseOrderId, _this.purchaseOrderId) || other.purchaseOrderId == _this.purchaseOrderId)&&(identical(other.receiptNumber, _this.receiptNumber) || other.receiptNumber == _this.receiptNumber)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt)&&(identical(other.supplierInvoiceNo, _this.supplierInvoiceNo) || other.supplierInvoiceNo == _this.supplierInvoiceNo)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&const DeepCollectionEquality().equals(other.payment, _this.payment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PurchaseReceiptModel;
  return Object.hash(runtimeType,_this.id,_this.branchId,_this.supplierId,_this.purchaseOrderId,_this.receiptNumber,_this.receivedAt,_this.supplierInvoiceNo,_this.notes,const DeepCollectionEquality().hash(_this.lines),_this.totalAmount,const DeepCollectionEquality().hash(_this.payment));
}

@override
String toString() {
  final _this = this as PurchaseReceiptModel;
  return 'PurchaseReceiptModel(id: ${_this.id}, branchId: ${_this.branchId}, supplierId: ${_this.supplierId}, purchaseOrderId: ${_this.purchaseOrderId}, receiptNumber: ${_this.receiptNumber}, receivedAt: ${_this.receivedAt}, supplierInvoiceNo: ${_this.supplierInvoiceNo}, notes: ${_this.notes}, lines: ${_this.lines}, totalAmount: ${_this.totalAmount}, payment: ${_this.payment})';
}


}

/// @nodoc
abstract mixin class $PurchaseReceiptModelCopyWith<$Res>  {
  factory $PurchaseReceiptModelCopyWith(PurchaseReceiptModel value, $Res Function(PurchaseReceiptModel) _then) = _$PurchaseReceiptModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'purchase_order_id') String? purchaseOrderId,@JsonKey(name: 'receipt_number') String receiptNumber,@JsonKey(name: 'received_at') String receivedAt,@JsonKey(name: 'supplier_invoice_no') String? supplierInvoiceNo, String? notes, List<PurchaseReceiptLineModel> lines,@JsonKey(name: 'total_amount') String? totalAmount, Map<String, dynamic>? payment
});




}
/// @nodoc
class _$PurchaseReceiptModelCopyWithImpl<$Res>
    implements $PurchaseReceiptModelCopyWith<$Res> {
  _$PurchaseReceiptModelCopyWithImpl(this._self, this._then);

  final PurchaseReceiptModel _self;
  final $Res Function(PurchaseReceiptModel) _then;

/// Create a copy of PurchaseReceiptModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? supplierId = null,Object? purchaseOrderId = freezed,Object? receiptNumber = null,Object? receivedAt = null,Object? supplierInvoiceNo = freezed,Object? notes = freezed,Object? lines = null,Object? totalAmount = freezed,Object? payment = freezed,}) {
  return _then(PurchaseReceiptModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,purchaseOrderId: freezed == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as String?,receiptNumber: null == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as String,supplierInvoiceNo: freezed == supplierInvoiceNo ? _self.supplierInvoiceNo : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<PurchaseReceiptLineModel>,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseReceiptModel].
extension PurchaseReceiptModelPatterns on PurchaseReceiptModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseReceiptModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseReceiptModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseReceiptModel value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseReceiptModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseReceiptModel value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseReceiptModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'purchase_order_id')  String? purchaseOrderId, @JsonKey(name: 'receipt_number')  String receiptNumber, @JsonKey(name: 'received_at')  String receivedAt, @JsonKey(name: 'supplier_invoice_no')  String? supplierInvoiceNo,  String? notes,  List<PurchaseReceiptLineModel> lines, @JsonKey(name: 'total_amount')  String? totalAmount,  Map<String, dynamic>? payment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseReceiptModel() when $default != null:
return $default(_that.id,_that.branchId,_that.supplierId,_that.purchaseOrderId,_that.receiptNumber,_that.receivedAt,_that.supplierInvoiceNo,_that.notes,_that.lines,_that.totalAmount,_that.payment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'purchase_order_id')  String? purchaseOrderId, @JsonKey(name: 'receipt_number')  String receiptNumber, @JsonKey(name: 'received_at')  String receivedAt, @JsonKey(name: 'supplier_invoice_no')  String? supplierInvoiceNo,  String? notes,  List<PurchaseReceiptLineModel> lines, @JsonKey(name: 'total_amount')  String? totalAmount,  Map<String, dynamic>? payment)  $default,) {final _that = this;
switch (_that) {
case _PurchaseReceiptModel():
return $default(_that.id,_that.branchId,_that.supplierId,_that.purchaseOrderId,_that.receiptNumber,_that.receivedAt,_that.supplierInvoiceNo,_that.notes,_that.lines,_that.totalAmount,_that.payment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'purchase_order_id')  String? purchaseOrderId, @JsonKey(name: 'receipt_number')  String receiptNumber, @JsonKey(name: 'received_at')  String receivedAt, @JsonKey(name: 'supplier_invoice_no')  String? supplierInvoiceNo,  String? notes,  List<PurchaseReceiptLineModel> lines, @JsonKey(name: 'total_amount')  String? totalAmount,  Map<String, dynamic>? payment)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseReceiptModel() when $default != null:
return $default(_that.id,_that.branchId,_that.supplierId,_that.purchaseOrderId,_that.receiptNumber,_that.receivedAt,_that.supplierInvoiceNo,_that.notes,_that.lines,_that.totalAmount,_that.payment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseReceiptModel implements PurchaseReceiptModel {
  const _PurchaseReceiptModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'supplier_id') required this.supplierId, @JsonKey(name: 'purchase_order_id') this.purchaseOrderId, @JsonKey(name: 'receipt_number') required this.receiptNumber, @JsonKey(name: 'received_at') required this.receivedAt, @JsonKey(name: 'supplier_invoice_no') this.supplierInvoiceNo, this.notes,  List<PurchaseReceiptLineModel> lines = const [], @JsonKey(name: 'total_amount') this.totalAmount,  Map<String, dynamic>? payment}): _lines = lines,_payment = payment;
  factory _PurchaseReceiptModel.fromJson(Map<String, dynamic> json) => _$PurchaseReceiptModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override@JsonKey(name: 'purchase_order_id') final  String? purchaseOrderId;
@override@JsonKey(name: 'receipt_number') final  String receiptNumber;
@override@JsonKey(name: 'received_at') final  String receivedAt;
@override@JsonKey(name: 'supplier_invoice_no') final  String? supplierInvoiceNo;
@override final  String? notes;
 final  List<PurchaseReceiptLineModel> _lines;
@override@JsonKey() List<PurchaseReceiptLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// Full receipt total (posted to the supplier account).
@override@JsonKey(name: 'total_amount') final  String? totalAmount;
/// The payment made together with the receipt; null when all on credit.
 final  Map<String, dynamic>? _payment;
/// The payment made together with the receipt; null when all on credit.
@override Map<String, dynamic>? get payment {
  final value = _payment;
  if (value == null) return null;
  if (_payment is EqualUnmodifiableMapView) return _payment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PurchaseReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseReceiptModelCopyWith<_PurchaseReceiptModel> get copyWith => __$PurchaseReceiptModelCopyWithImpl<_PurchaseReceiptModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseReceiptModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.purchaseOrderId, purchaseOrderId) || other.purchaseOrderId == purchaseOrderId)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.supplierInvoiceNo, supplierInvoiceNo) || other.supplierInvoiceNo == supplierInvoiceNo)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.payment, _payment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,branchId,supplierId,purchaseOrderId,receiptNumber,receivedAt,supplierInvoiceNo,notes,const DeepCollectionEquality().hash(_lines),totalAmount,const DeepCollectionEquality().hash(_payment));
}

@override
String toString() {
    return 'PurchaseReceiptModel(id: $id, branchId: $branchId, supplierId: $supplierId, purchaseOrderId: $purchaseOrderId, receiptNumber: $receiptNumber, receivedAt: $receivedAt, supplierInvoiceNo: $supplierInvoiceNo, notes: $notes, lines: $lines, totalAmount: $totalAmount, payment: $payment)';
}


}

/// @nodoc
abstract mixin class _$PurchaseReceiptModelCopyWith<$Res> implements $PurchaseReceiptModelCopyWith<$Res> {
  factory _$PurchaseReceiptModelCopyWith(_PurchaseReceiptModel value, $Res Function(_PurchaseReceiptModel) _then) = __$PurchaseReceiptModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'purchase_order_id') String? purchaseOrderId,@JsonKey(name: 'receipt_number') String receiptNumber,@JsonKey(name: 'received_at') String receivedAt,@JsonKey(name: 'supplier_invoice_no') String? supplierInvoiceNo, String? notes, List<PurchaseReceiptLineModel> lines,@JsonKey(name: 'total_amount') String? totalAmount, Map<String, dynamic>? payment
});




}
/// @nodoc
class __$PurchaseReceiptModelCopyWithImpl<$Res>
    implements _$PurchaseReceiptModelCopyWith<$Res> {
  __$PurchaseReceiptModelCopyWithImpl(this._self, this._then);

  final _PurchaseReceiptModel _self;
  final $Res Function(_PurchaseReceiptModel) _then;

/// Create a copy of PurchaseReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? supplierId = null,Object? purchaseOrderId = freezed,Object? receiptNumber = null,Object? receivedAt = null,Object? supplierInvoiceNo = freezed,Object? notes = freezed,Object? lines = null,Object? totalAmount = freezed,Object? payment = freezed,}) {
  return _then(_PurchaseReceiptModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,purchaseOrderId: freezed == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as String?,receiptNumber: null == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as String,supplierInvoiceNo: freezed == supplierInvoiceNo ? _self.supplierInvoiceNo : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<PurchaseReceiptLineModel>,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,payment: freezed == payment ? _self._payment : payment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
