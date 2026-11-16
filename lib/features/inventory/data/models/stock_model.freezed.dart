// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockBalanceModel {

@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'current_qty') String get currentQty;@JsonKey(name: 'last_movement_at') String? get lastMovementAt;
/// Create a copy of StockBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockBalanceModelCopyWith<StockBalanceModel> get copyWith => _$StockBalanceModelCopyWithImpl<StockBalanceModel>(this as StockBalanceModel, _$identity);

  /// Serializes this StockBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockBalanceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockBalanceModel&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.currentQty, _this.currentQty) || other.currentQty == _this.currentQty)&&(identical(other.lastMovementAt, _this.lastMovementAt) || other.lastMovementAt == _this.lastMovementAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockBalanceModel;
  return Object.hash(runtimeType,_this.productId,_this.variationId,_this.branchId,_this.currentQty,_this.lastMovementAt);
}

@override
String toString() {
  final _this = this as StockBalanceModel;
  return 'StockBalanceModel(productId: ${_this.productId}, variationId: ${_this.variationId}, branchId: ${_this.branchId}, currentQty: ${_this.currentQty}, lastMovementAt: ${_this.lastMovementAt})';
}


}

/// @nodoc
abstract mixin class $StockBalanceModelCopyWith<$Res>  {
  factory $StockBalanceModelCopyWith(StockBalanceModel value, $Res Function(StockBalanceModel) _then) = _$StockBalanceModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'current_qty') String currentQty,@JsonKey(name: 'last_movement_at') String? lastMovementAt
});




}
/// @nodoc
class _$StockBalanceModelCopyWithImpl<$Res>
    implements $StockBalanceModelCopyWith<$Res> {
  _$StockBalanceModelCopyWithImpl(this._self, this._then);

  final StockBalanceModel _self;
  final $Res Function(StockBalanceModel) _then;

/// Create a copy of StockBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? variationId = freezed,Object? branchId = null,Object? currentQty = null,Object? lastMovementAt = freezed,}) {
  return _then(StockBalanceModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,currentQty: null == currentQty ? _self.currentQty : currentQty // ignore: cast_nullable_to_non_nullable
as String,lastMovementAt: freezed == lastMovementAt ? _self.lastMovementAt : lastMovementAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockBalanceModel].
extension StockBalanceModelPatterns on StockBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _StockBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'current_qty')  String currentQty, @JsonKey(name: 'last_movement_at')  String? lastMovementAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockBalanceModel() when $default != null:
return $default(_that.productId,_that.variationId,_that.branchId,_that.currentQty,_that.lastMovementAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'current_qty')  String currentQty, @JsonKey(name: 'last_movement_at')  String? lastMovementAt)  $default,) {final _that = this;
switch (_that) {
case _StockBalanceModel():
return $default(_that.productId,_that.variationId,_that.branchId,_that.currentQty,_that.lastMovementAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'current_qty')  String currentQty, @JsonKey(name: 'last_movement_at')  String? lastMovementAt)?  $default,) {final _that = this;
switch (_that) {
case _StockBalanceModel() when $default != null:
return $default(_that.productId,_that.variationId,_that.branchId,_that.currentQty,_that.lastMovementAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockBalanceModel implements StockBalanceModel {
  const _StockBalanceModel({@JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'current_qty') required this.currentQty, @JsonKey(name: 'last_movement_at') this.lastMovementAt});
  factory _StockBalanceModel.fromJson(Map<String, dynamic> json) => _$StockBalanceModelFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'current_qty') final  String currentQty;
@override@JsonKey(name: 'last_movement_at') final  String? lastMovementAt;

/// Create a copy of StockBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockBalanceModelCopyWith<_StockBalanceModel> get copyWith => __$StockBalanceModelCopyWithImpl<_StockBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockBalanceModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.currentQty, currentQty) || other.currentQty == currentQty)&&(identical(other.lastMovementAt, lastMovementAt) || other.lastMovementAt == lastMovementAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,variationId,branchId,currentQty,lastMovementAt);
}

@override
String toString() {
    return 'StockBalanceModel(productId: $productId, variationId: $variationId, branchId: $branchId, currentQty: $currentQty, lastMovementAt: $lastMovementAt)';
}


}

/// @nodoc
abstract mixin class _$StockBalanceModelCopyWith<$Res> implements $StockBalanceModelCopyWith<$Res> {
  factory _$StockBalanceModelCopyWith(_StockBalanceModel value, $Res Function(_StockBalanceModel) _then) = __$StockBalanceModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'current_qty') String currentQty,@JsonKey(name: 'last_movement_at') String? lastMovementAt
});




}
/// @nodoc
class __$StockBalanceModelCopyWithImpl<$Res>
    implements _$StockBalanceModelCopyWith<$Res> {
  __$StockBalanceModelCopyWithImpl(this._self, this._then);

  final _StockBalanceModel _self;
  final $Res Function(_StockBalanceModel) _then;

/// Create a copy of StockBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? variationId = freezed,Object? branchId = null,Object? currentQty = null,Object? lastMovementAt = freezed,}) {
  return _then(_StockBalanceModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,currentQty: null == currentQty ? _self.currentQty : currentQty // ignore: cast_nullable_to_non_nullable
as String,lastMovementAt: freezed == lastMovementAt ? _self.lastMovementAt : lastMovementAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StockMovementModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'movement_type') String get movementType; String get qty;@JsonKey(name: 'cost_per_unit') String get costPerUnit;@JsonKey(name: 'reference_type') String get referenceType;@JsonKey(name: 'reference_id') String get referenceId;@JsonKey(name: 'batch_number') String? get batchNumber;@JsonKey(name: 'expiry_date') String? get expiryDate; String? get notes;@JsonKey(name: 'movement_at') String get movementAt;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementModelCopyWith<StockMovementModel> get copyWith => _$StockMovementModelCopyWithImpl<StockMovementModel>(this as StockMovementModel, _$identity);

  /// Serializes this StockMovementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockMovementModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.movementType, _this.movementType) || other.movementType == _this.movementType)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.referenceId, _this.referenceId) || other.referenceId == _this.referenceId)&&(identical(other.batchNumber, _this.batchNumber) || other.batchNumber == _this.batchNumber)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.movementAt, _this.movementAt) || other.movementAt == _this.movementAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockMovementModel;
  return Object.hash(runtimeType,_this.id,_this.branchId,_this.productId,_this.variationId,_this.movementType,_this.qty,_this.costPerUnit,_this.referenceType,_this.referenceId,_this.batchNumber,_this.expiryDate,_this.notes,_this.movementAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as StockMovementModel;
  return 'StockMovementModel(id: ${_this.id}, branchId: ${_this.branchId}, productId: ${_this.productId}, variationId: ${_this.variationId}, movementType: ${_this.movementType}, qty: ${_this.qty}, costPerUnit: ${_this.costPerUnit}, referenceType: ${_this.referenceType}, referenceId: ${_this.referenceId}, batchNumber: ${_this.batchNumber}, expiryDate: ${_this.expiryDate}, notes: ${_this.notes}, movementAt: ${_this.movementAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $StockMovementModelCopyWith<$Res>  {
  factory $StockMovementModelCopyWith(StockMovementModel value, $Res Function(StockMovementModel) _then) = _$StockMovementModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'movement_type') String movementType, String qty,@JsonKey(name: 'cost_per_unit') String costPerUnit,@JsonKey(name: 'reference_type') String referenceType,@JsonKey(name: 'reference_id') String referenceId,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(name: 'expiry_date') String? expiryDate, String? notes,@JsonKey(name: 'movement_at') String movementAt,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$StockMovementModelCopyWithImpl<$Res>
    implements $StockMovementModelCopyWith<$Res> {
  _$StockMovementModelCopyWithImpl(this._self, this._then);

  final StockMovementModel _self;
  final $Res Function(StockMovementModel) _then;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? productId = null,Object? variationId = freezed,Object? movementType = null,Object? qty = null,Object? costPerUnit = null,Object? referenceType = null,Object? referenceId = null,Object? batchNumber = freezed,Object? expiryDate = freezed,Object? notes = freezed,Object? movementAt = null,Object? createdAt = freezed,}) {
  return _then(StockMovementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,movementType: null == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,movementAt: null == movementAt ? _self.movementAt : movementAt // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovementModel].
extension StockMovementModelPatterns on StockMovementModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovementModel value)  $default,){
final _that = this;
switch (_that) {
case _StockMovementModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovementModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'movement_type')  String movementType,  String qty, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'reference_type')  String referenceType, @JsonKey(name: 'reference_id')  String referenceId, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate,  String? notes, @JsonKey(name: 'movement_at')  String movementAt, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
return $default(_that.id,_that.branchId,_that.productId,_that.variationId,_that.movementType,_that.qty,_that.costPerUnit,_that.referenceType,_that.referenceId,_that.batchNumber,_that.expiryDate,_that.notes,_that.movementAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'movement_type')  String movementType,  String qty, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'reference_type')  String referenceType, @JsonKey(name: 'reference_id')  String referenceId, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate,  String? notes, @JsonKey(name: 'movement_at')  String movementAt, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockMovementModel():
return $default(_that.id,_that.branchId,_that.productId,_that.variationId,_that.movementType,_that.qty,_that.costPerUnit,_that.referenceType,_that.referenceId,_that.batchNumber,_that.expiryDate,_that.notes,_that.movementAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'movement_type')  String movementType,  String qty, @JsonKey(name: 'cost_per_unit')  String costPerUnit, @JsonKey(name: 'reference_type')  String referenceType, @JsonKey(name: 'reference_id')  String referenceId, @JsonKey(name: 'batch_number')  String? batchNumber, @JsonKey(name: 'expiry_date')  String? expiryDate,  String? notes, @JsonKey(name: 'movement_at')  String movementAt, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockMovementModel() when $default != null:
return $default(_that.id,_that.branchId,_that.productId,_that.variationId,_that.movementType,_that.qty,_that.costPerUnit,_that.referenceType,_that.referenceId,_that.batchNumber,_that.expiryDate,_that.notes,_that.movementAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMovementModel implements StockMovementModel {
  const _StockMovementModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'movement_type') required this.movementType, required this.qty, @JsonKey(name: 'cost_per_unit') required this.costPerUnit, @JsonKey(name: 'reference_type') required this.referenceType, @JsonKey(name: 'reference_id') required this.referenceId, @JsonKey(name: 'batch_number') this.batchNumber, @JsonKey(name: 'expiry_date') this.expiryDate, this.notes, @JsonKey(name: 'movement_at') required this.movementAt, @JsonKey(name: 'created_at') this.createdAt});
  factory _StockMovementModel.fromJson(Map<String, dynamic> json) => _$StockMovementModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'movement_type') final  String movementType;
@override final  String qty;
@override@JsonKey(name: 'cost_per_unit') final  String costPerUnit;
@override@JsonKey(name: 'reference_type') final  String referenceType;
@override@JsonKey(name: 'reference_id') final  String referenceId;
@override@JsonKey(name: 'batch_number') final  String? batchNumber;
@override@JsonKey(name: 'expiry_date') final  String? expiryDate;
@override final  String? notes;
@override@JsonKey(name: 'movement_at') final  String movementAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementModelCopyWith<_StockMovementModel> get copyWith => __$StockMovementModelCopyWithImpl<_StockMovementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMovementModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.movementType, movementType) || other.movementType == movementType)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.movementAt, movementAt) || other.movementAt == movementAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,branchId,productId,variationId,movementType,qty,costPerUnit,referenceType,referenceId,batchNumber,expiryDate,notes,movementAt,createdAt);
}

@override
String toString() {
    return 'StockMovementModel(id: $id, branchId: $branchId, productId: $productId, variationId: $variationId, movementType: $movementType, qty: $qty, costPerUnit: $costPerUnit, referenceType: $referenceType, referenceId: $referenceId, batchNumber: $batchNumber, expiryDate: $expiryDate, notes: $notes, movementAt: $movementAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockMovementModelCopyWith<$Res> implements $StockMovementModelCopyWith<$Res> {
  factory _$StockMovementModelCopyWith(_StockMovementModel value, $Res Function(_StockMovementModel) _then) = __$StockMovementModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'movement_type') String movementType, String qty,@JsonKey(name: 'cost_per_unit') String costPerUnit,@JsonKey(name: 'reference_type') String referenceType,@JsonKey(name: 'reference_id') String referenceId,@JsonKey(name: 'batch_number') String? batchNumber,@JsonKey(name: 'expiry_date') String? expiryDate, String? notes,@JsonKey(name: 'movement_at') String movementAt,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$StockMovementModelCopyWithImpl<$Res>
    implements _$StockMovementModelCopyWith<$Res> {
  __$StockMovementModelCopyWithImpl(this._self, this._then);

  final _StockMovementModel _self;
  final $Res Function(_StockMovementModel) _then;

/// Create a copy of StockMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? productId = null,Object? variationId = freezed,Object? movementType = null,Object? qty = null,Object? costPerUnit = null,Object? referenceType = null,Object? referenceId = null,Object? batchNumber = freezed,Object? expiryDate = freezed,Object? notes = freezed,Object? movementAt = null,Object? createdAt = freezed,}) {
  return _then(_StockMovementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,movementType: null == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,referenceId: null == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,movementAt: null == movementAt ? _self.movementAt : movementAt // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PaginatedStockMovementsModel {

@JsonKey(fromJson: JsonNum.intOr) int get total;@JsonKey(fromJson: JsonNum.intOr) int get skip;@JsonKey(fromJson: JsonNum.intOr) int get limit; List<StockMovementModel> get items;
/// Create a copy of PaginatedStockMovementsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedStockMovementsModelCopyWith<PaginatedStockMovementsModel> get copyWith => _$PaginatedStockMovementsModelCopyWithImpl<PaginatedStockMovementsModel>(this as PaginatedStockMovementsModel, _$identity);

  /// Serializes this PaginatedStockMovementsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaginatedStockMovementsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedStockMovementsModel&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaginatedStockMovementsModel;
  return Object.hash(runtimeType,_this.total,_this.skip,_this.limit,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PaginatedStockMovementsModel;
  return 'PaginatedStockMovementsModel(total: ${_this.total}, skip: ${_this.skip}, limit: ${_this.limit}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PaginatedStockMovementsModelCopyWith<$Res>  {
  factory $PaginatedStockMovementsModelCopyWith(PaginatedStockMovementsModel value, $Res Function(PaginatedStockMovementsModel) _then) = _$PaginatedStockMovementsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<StockMovementModel> items
});




}
/// @nodoc
class _$PaginatedStockMovementsModelCopyWithImpl<$Res>
    implements $PaginatedStockMovementsModelCopyWith<$Res> {
  _$PaginatedStockMovementsModelCopyWithImpl(this._self, this._then);

  final PaginatedStockMovementsModel _self;
  final $Res Function(PaginatedStockMovementsModel) _then;

/// Create a copy of PaginatedStockMovementsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(PaginatedStockMovementsModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StockMovementModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedStockMovementsModel].
extension PaginatedStockMovementsModelPatterns on PaginatedStockMovementsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedStockMovementsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedStockMovementsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedStockMovementsModel value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedStockMovementsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedStockMovementsModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedStockMovementsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<StockMovementModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedStockMovementsModel() when $default != null:
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<StockMovementModel> items)  $default,) {final _that = this;
switch (_that) {
case _PaginatedStockMovementsModel():
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: JsonNum.intOr)  int total, @JsonKey(fromJson: JsonNum.intOr)  int skip, @JsonKey(fromJson: JsonNum.intOr)  int limit,  List<StockMovementModel> items)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedStockMovementsModel() when $default != null:
return $default(_that.total,_that.skip,_that.limit,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedStockMovementsModel implements PaginatedStockMovementsModel {
  const _PaginatedStockMovementsModel({@JsonKey(fromJson: JsonNum.intOr) required this.total, @JsonKey(fromJson: JsonNum.intOr) required this.skip, @JsonKey(fromJson: JsonNum.intOr) required this.limit, required  List<StockMovementModel> items}): _items = items;
  factory _PaginatedStockMovementsModel.fromJson(Map<String, dynamic> json) => _$PaginatedStockMovementsModelFromJson(json);

@override@JsonKey(fromJson: JsonNum.intOr) final  int total;
@override@JsonKey(fromJson: JsonNum.intOr) final  int skip;
@override@JsonKey(fromJson: JsonNum.intOr) final  int limit;
 final  List<StockMovementModel> _items;
@override List<StockMovementModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PaginatedStockMovementsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedStockMovementsModelCopyWith<_PaginatedStockMovementsModel> get copyWith => __$PaginatedStockMovementsModelCopyWithImpl<_PaginatedStockMovementsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedStockMovementsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedStockMovementsModel&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,skip,limit,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PaginatedStockMovementsModel(total: $total, skip: $skip, limit: $limit, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PaginatedStockMovementsModelCopyWith<$Res> implements $PaginatedStockMovementsModelCopyWith<$Res> {
  factory _$PaginatedStockMovementsModelCopyWith(_PaginatedStockMovementsModel value, $Res Function(_PaginatedStockMovementsModel) _then) = __$PaginatedStockMovementsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: JsonNum.intOr) int total,@JsonKey(fromJson: JsonNum.intOr) int skip,@JsonKey(fromJson: JsonNum.intOr) int limit, List<StockMovementModel> items
});




}
/// @nodoc
class __$PaginatedStockMovementsModelCopyWithImpl<$Res>
    implements _$PaginatedStockMovementsModelCopyWith<$Res> {
  __$PaginatedStockMovementsModelCopyWithImpl(this._self, this._then);

  final _PaginatedStockMovementsModel _self;
  final $Res Function(_PaginatedStockMovementsModel) _then;

/// Create a copy of PaginatedStockMovementsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? skip = null,Object? limit = null,Object? items = null,}) {
  return _then(_PaginatedStockMovementsModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StockMovementModel>,
  ));
}


}


/// @nodoc
mixin _$StockAdjustmentLineModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'qty_delta') String get qtyDelta;@JsonKey(name: 'cost_per_unit') String get costPerUnit; String? get notes;
/// Create a copy of StockAdjustmentLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustmentLineModelCopyWith<StockAdjustmentLineModel> get copyWith => _$StockAdjustmentLineModelCopyWithImpl<StockAdjustmentLineModel>(this as StockAdjustmentLineModel, _$identity);

  /// Serializes this StockAdjustmentLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockAdjustmentLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustmentLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qtyDelta, _this.qtyDelta) || other.qtyDelta == _this.qtyDelta)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockAdjustmentLineModel;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.variationId,_this.qtyDelta,_this.costPerUnit,_this.notes);
}

@override
String toString() {
  final _this = this as StockAdjustmentLineModel;
  return 'StockAdjustmentLineModel(id: ${_this.id}, productId: ${_this.productId}, variationId: ${_this.variationId}, qtyDelta: ${_this.qtyDelta}, costPerUnit: ${_this.costPerUnit}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $StockAdjustmentLineModelCopyWith<$Res>  {
  factory $StockAdjustmentLineModelCopyWith(StockAdjustmentLineModel value, $Res Function(StockAdjustmentLineModel) _then) = _$StockAdjustmentLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'qty_delta') String qtyDelta,@JsonKey(name: 'cost_per_unit') String costPerUnit, String? notes
});




}
/// @nodoc
class _$StockAdjustmentLineModelCopyWithImpl<$Res>
    implements $StockAdjustmentLineModelCopyWith<$Res> {
  _$StockAdjustmentLineModelCopyWithImpl(this._self, this._then);

  final StockAdjustmentLineModel _self;
  final $Res Function(StockAdjustmentLineModel) _then;

/// Create a copy of StockAdjustmentLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? variationId = freezed,Object? qtyDelta = null,Object? costPerUnit = null,Object? notes = freezed,}) {
  return _then(StockAdjustmentLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qtyDelta: null == qtyDelta ? _self.qtyDelta : qtyDelta // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustmentLineModel].
extension StockAdjustmentLineModelPatterns on StockAdjustmentLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockAdjustmentLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockAdjustmentLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockAdjustmentLineModel value)  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockAdjustmentLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_delta')  String qtyDelta, @JsonKey(name: 'cost_per_unit')  String costPerUnit,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockAdjustmentLineModel() when $default != null:
return $default(_that.id,_that.productId,_that.variationId,_that.qtyDelta,_that.costPerUnit,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_delta')  String qtyDelta, @JsonKey(name: 'cost_per_unit')  String costPerUnit,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentLineModel():
return $default(_that.id,_that.productId,_that.variationId,_that.qtyDelta,_that.costPerUnit,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_delta')  String qtyDelta, @JsonKey(name: 'cost_per_unit')  String costPerUnit,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentLineModel() when $default != null:
return $default(_that.id,_that.productId,_that.variationId,_that.qtyDelta,_that.costPerUnit,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockAdjustmentLineModel implements StockAdjustmentLineModel {
  const _StockAdjustmentLineModel({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'qty_delta') required this.qtyDelta, @JsonKey(name: 'cost_per_unit') required this.costPerUnit, this.notes});
  factory _StockAdjustmentLineModel.fromJson(Map<String, dynamic> json) => _$StockAdjustmentLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'qty_delta') final  String qtyDelta;
@override@JsonKey(name: 'cost_per_unit') final  String costPerUnit;
@override final  String? notes;

/// Create a copy of StockAdjustmentLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockAdjustmentLineModelCopyWith<_StockAdjustmentLineModel> get copyWith => __$StockAdjustmentLineModelCopyWithImpl<_StockAdjustmentLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockAdjustmentLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockAdjustmentLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qtyDelta, qtyDelta) || other.qtyDelta == qtyDelta)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,variationId,qtyDelta,costPerUnit,notes);
}

@override
String toString() {
    return 'StockAdjustmentLineModel(id: $id, productId: $productId, variationId: $variationId, qtyDelta: $qtyDelta, costPerUnit: $costPerUnit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$StockAdjustmentLineModelCopyWith<$Res> implements $StockAdjustmentLineModelCopyWith<$Res> {
  factory _$StockAdjustmentLineModelCopyWith(_StockAdjustmentLineModel value, $Res Function(_StockAdjustmentLineModel) _then) = __$StockAdjustmentLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'qty_delta') String qtyDelta,@JsonKey(name: 'cost_per_unit') String costPerUnit, String? notes
});




}
/// @nodoc
class __$StockAdjustmentLineModelCopyWithImpl<$Res>
    implements _$StockAdjustmentLineModelCopyWith<$Res> {
  __$StockAdjustmentLineModelCopyWithImpl(this._self, this._then);

  final _StockAdjustmentLineModel _self;
  final $Res Function(_StockAdjustmentLineModel) _then;

/// Create a copy of StockAdjustmentLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? variationId = freezed,Object? qtyDelta = null,Object? costPerUnit = null,Object? notes = freezed,}) {
  return _then(_StockAdjustmentLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qtyDelta: null == qtyDelta ? _self.qtyDelta : qtyDelta // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StockAdjustmentModel {

 String get id;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'adjustment_number') String get adjustmentNumber; String get reason;@JsonKey(name: 'adjusted_at') String get adjustedAt; String? get notes; List<StockAdjustmentLineModel> get lines;
/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustmentModelCopyWith<StockAdjustmentModel> get copyWith => _$StockAdjustmentModelCopyWithImpl<StockAdjustmentModel>(this as StockAdjustmentModel, _$identity);

  /// Serializes this StockAdjustmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockAdjustmentModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustmentModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.adjustmentNumber, _this.adjustmentNumber) || other.adjustmentNumber == _this.adjustmentNumber)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.adjustedAt, _this.adjustedAt) || other.adjustedAt == _this.adjustedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockAdjustmentModel;
  return Object.hash(runtimeType,_this.id,_this.branchId,_this.adjustmentNumber,_this.reason,_this.adjustedAt,_this.notes,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as StockAdjustmentModel;
  return 'StockAdjustmentModel(id: ${_this.id}, branchId: ${_this.branchId}, adjustmentNumber: ${_this.adjustmentNumber}, reason: ${_this.reason}, adjustedAt: ${_this.adjustedAt}, notes: ${_this.notes}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $StockAdjustmentModelCopyWith<$Res>  {
  factory $StockAdjustmentModelCopyWith(StockAdjustmentModel value, $Res Function(StockAdjustmentModel) _then) = _$StockAdjustmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'adjustment_number') String adjustmentNumber, String reason,@JsonKey(name: 'adjusted_at') String adjustedAt, String? notes, List<StockAdjustmentLineModel> lines
});




}
/// @nodoc
class _$StockAdjustmentModelCopyWithImpl<$Res>
    implements $StockAdjustmentModelCopyWith<$Res> {
  _$StockAdjustmentModelCopyWithImpl(this._self, this._then);

  final StockAdjustmentModel _self;
  final $Res Function(StockAdjustmentModel) _then;

/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? adjustmentNumber = null,Object? reason = null,Object? adjustedAt = null,Object? notes = freezed,Object? lines = null,}) {
  return _then(StockAdjustmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,adjustmentNumber: null == adjustmentNumber ? _self.adjustmentNumber : adjustmentNumber // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,adjustedAt: null == adjustedAt ? _self.adjustedAt : adjustedAt // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<StockAdjustmentLineModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustmentModel].
extension StockAdjustmentModelPatterns on StockAdjustmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockAdjustmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockAdjustmentModel value)  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockAdjustmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'adjustment_number')  String adjustmentNumber,  String reason, @JsonKey(name: 'adjusted_at')  String adjustedAt,  String? notes,  List<StockAdjustmentLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
return $default(_that.id,_that.branchId,_that.adjustmentNumber,_that.reason,_that.adjustedAt,_that.notes,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'adjustment_number')  String adjustmentNumber,  String reason, @JsonKey(name: 'adjusted_at')  String adjustedAt,  String? notes,  List<StockAdjustmentLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentModel():
return $default(_that.id,_that.branchId,_that.adjustmentNumber,_that.reason,_that.adjustedAt,_that.notes,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'adjustment_number')  String adjustmentNumber,  String reason, @JsonKey(name: 'adjusted_at')  String adjustedAt,  String? notes,  List<StockAdjustmentLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _StockAdjustmentModel() when $default != null:
return $default(_that.id,_that.branchId,_that.adjustmentNumber,_that.reason,_that.adjustedAt,_that.notes,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockAdjustmentModel implements StockAdjustmentModel {
  const _StockAdjustmentModel({required this.id, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'adjustment_number') required this.adjustmentNumber, required this.reason, @JsonKey(name: 'adjusted_at') required this.adjustedAt, this.notes,  List<StockAdjustmentLineModel> lines = const []}): _lines = lines;
  factory _StockAdjustmentModel.fromJson(Map<String, dynamic> json) => _$StockAdjustmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'adjustment_number') final  String adjustmentNumber;
@override final  String reason;
@override@JsonKey(name: 'adjusted_at') final  String adjustedAt;
@override final  String? notes;
 final  List<StockAdjustmentLineModel> _lines;
@override@JsonKey() List<StockAdjustmentLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockAdjustmentModelCopyWith<_StockAdjustmentModel> get copyWith => __$StockAdjustmentModelCopyWithImpl<_StockAdjustmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockAdjustmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockAdjustmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.adjustmentNumber, adjustmentNumber) || other.adjustmentNumber == adjustmentNumber)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.adjustedAt, adjustedAt) || other.adjustedAt == adjustedAt)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,branchId,adjustmentNumber,reason,adjustedAt,notes,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'StockAdjustmentModel(id: $id, branchId: $branchId, adjustmentNumber: $adjustmentNumber, reason: $reason, adjustedAt: $adjustedAt, notes: $notes, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$StockAdjustmentModelCopyWith<$Res> implements $StockAdjustmentModelCopyWith<$Res> {
  factory _$StockAdjustmentModelCopyWith(_StockAdjustmentModel value, $Res Function(_StockAdjustmentModel) _then) = __$StockAdjustmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'adjustment_number') String adjustmentNumber, String reason,@JsonKey(name: 'adjusted_at') String adjustedAt, String? notes, List<StockAdjustmentLineModel> lines
});




}
/// @nodoc
class __$StockAdjustmentModelCopyWithImpl<$Res>
    implements _$StockAdjustmentModelCopyWith<$Res> {
  __$StockAdjustmentModelCopyWithImpl(this._self, this._then);

  final _StockAdjustmentModel _self;
  final $Res Function(_StockAdjustmentModel) _then;

/// Create a copy of StockAdjustmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? adjustmentNumber = null,Object? reason = null,Object? adjustedAt = null,Object? notes = freezed,Object? lines = null,}) {
  return _then(_StockAdjustmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,adjustmentNumber: null == adjustmentNumber ? _self.adjustmentNumber : adjustmentNumber // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,adjustedAt: null == adjustedAt ? _self.adjustedAt : adjustedAt // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<StockAdjustmentLineModel>,
  ));
}


}

// dart format on
