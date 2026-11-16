// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KotOrderLineModel {

 String get id;@JsonKey(name: 'kot_order_id') String get kotOrderId;@JsonKey(name: 'sale_line_id') String? get saleLineId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'variation_id') String? get variationId; String get qty;@JsonKey(name: 'modifiers_json') List<dynamic> get modifiersJson;@JsonKey(name: 'kitchen_notes') String? get kitchenNotes; String get status;
/// Create a copy of KotOrderLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KotOrderLineModelCopyWith<KotOrderLineModel> get copyWith => _$KotOrderLineModelCopyWithImpl<KotOrderLineModel>(this as KotOrderLineModel, _$identity);

  /// Serializes this KotOrderLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KotOrderLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KotOrderLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kotOrderId, _this.kotOrderId) || other.kotOrderId == _this.kotOrderId)&&(identical(other.saleLineId, _this.saleLineId) || other.saleLineId == _this.saleLineId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&const DeepCollectionEquality().equals(other.modifiersJson, _this.modifiersJson)&&(identical(other.kitchenNotes, _this.kitchenNotes) || other.kitchenNotes == _this.kitchenNotes)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KotOrderLineModel;
  return Object.hash(runtimeType,_this.id,_this.kotOrderId,_this.saleLineId,_this.productId,_this.productName,_this.variationId,_this.qty,const DeepCollectionEquality().hash(_this.modifiersJson),_this.kitchenNotes,_this.status);
}

@override
String toString() {
  final _this = this as KotOrderLineModel;
  return 'KotOrderLineModel(id: ${_this.id}, kotOrderId: ${_this.kotOrderId}, saleLineId: ${_this.saleLineId}, productId: ${_this.productId}, productName: ${_this.productName}, variationId: ${_this.variationId}, qty: ${_this.qty}, modifiersJson: ${_this.modifiersJson}, kitchenNotes: ${_this.kitchenNotes}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $KotOrderLineModelCopyWith<$Res>  {
  factory $KotOrderLineModelCopyWith(KotOrderLineModel value, $Res Function(KotOrderLineModel) _then) = _$KotOrderLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'kot_order_id') String kotOrderId,@JsonKey(name: 'sale_line_id') String? saleLineId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'modifiers_json') List<dynamic> modifiersJson,@JsonKey(name: 'kitchen_notes') String? kitchenNotes, String status
});




}
/// @nodoc
class _$KotOrderLineModelCopyWithImpl<$Res>
    implements $KotOrderLineModelCopyWith<$Res> {
  _$KotOrderLineModelCopyWithImpl(this._self, this._then);

  final KotOrderLineModel _self;
  final $Res Function(KotOrderLineModel) _then;

/// Create a copy of KotOrderLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kotOrderId = null,Object? saleLineId = freezed,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? qty = null,Object? modifiersJson = null,Object? kitchenNotes = freezed,Object? status = null,}) {
  return _then(KotOrderLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kotOrderId: null == kotOrderId ? _self.kotOrderId : kotOrderId // ignore: cast_nullable_to_non_nullable
as String,saleLineId: freezed == saleLineId ? _self.saleLineId : saleLineId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,modifiersJson: null == modifiersJson ? _self.modifiersJson : modifiersJson // ignore: cast_nullable_to_non_nullable
as List<dynamic>,kitchenNotes: freezed == kitchenNotes ? _self.kitchenNotes : kitchenNotes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KotOrderLineModel].
extension KotOrderLineModelPatterns on KotOrderLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KotOrderLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KotOrderLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KotOrderLineModel value)  $default,){
final _that = this;
switch (_that) {
case _KotOrderLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KotOrderLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _KotOrderLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'kot_order_id')  String kotOrderId, @JsonKey(name: 'sale_line_id')  String? saleLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'modifiers_json')  List<dynamic> modifiersJson, @JsonKey(name: 'kitchen_notes')  String? kitchenNotes,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KotOrderLineModel() when $default != null:
return $default(_that.id,_that.kotOrderId,_that.saleLineId,_that.productId,_that.productName,_that.variationId,_that.qty,_that.modifiersJson,_that.kitchenNotes,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'kot_order_id')  String kotOrderId, @JsonKey(name: 'sale_line_id')  String? saleLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'modifiers_json')  List<dynamic> modifiersJson, @JsonKey(name: 'kitchen_notes')  String? kitchenNotes,  String status)  $default,) {final _that = this;
switch (_that) {
case _KotOrderLineModel():
return $default(_that.id,_that.kotOrderId,_that.saleLineId,_that.productId,_that.productName,_that.variationId,_that.qty,_that.modifiersJson,_that.kitchenNotes,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'kot_order_id')  String kotOrderId, @JsonKey(name: 'sale_line_id')  String? saleLineId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId,  String qty, @JsonKey(name: 'modifiers_json')  List<dynamic> modifiersJson, @JsonKey(name: 'kitchen_notes')  String? kitchenNotes,  String status)?  $default,) {final _that = this;
switch (_that) {
case _KotOrderLineModel() when $default != null:
return $default(_that.id,_that.kotOrderId,_that.saleLineId,_that.productId,_that.productName,_that.variationId,_that.qty,_that.modifiersJson,_that.kitchenNotes,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KotOrderLineModel implements KotOrderLineModel {
  const _KotOrderLineModel({required this.id, @JsonKey(name: 'kot_order_id') required this.kotOrderId, @JsonKey(name: 'sale_line_id') this.saleLineId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'variation_id') this.variationId, required this.qty, @JsonKey(name: 'modifiers_json')  List<dynamic> modifiersJson = const [], @JsonKey(name: 'kitchen_notes') this.kitchenNotes, required this.status}): _modifiersJson = modifiersJson;
  factory _KotOrderLineModel.fromJson(Map<String, dynamic> json) => _$KotOrderLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'kot_order_id') final  String kotOrderId;
@override@JsonKey(name: 'sale_line_id') final  String? saleLineId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override final  String qty;
 final  List<dynamic> _modifiersJson;
@override@JsonKey(name: 'modifiers_json') List<dynamic> get modifiersJson {
  if (_modifiersJson is EqualUnmodifiableListView) return _modifiersJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiersJson);
}

@override@JsonKey(name: 'kitchen_notes') final  String? kitchenNotes;
@override final  String status;

/// Create a copy of KotOrderLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KotOrderLineModelCopyWith<_KotOrderLineModel> get copyWith => __$KotOrderLineModelCopyWithImpl<_KotOrderLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KotOrderLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KotOrderLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kotOrderId, kotOrderId) || other.kotOrderId == kotOrderId)&&(identical(other.saleLineId, saleLineId) || other.saleLineId == saleLineId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qty, qty) || other.qty == qty)&&const DeepCollectionEquality().equals(other.modifiersJson, _modifiersJson)&&(identical(other.kitchenNotes, kitchenNotes) || other.kitchenNotes == kitchenNotes)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kotOrderId,saleLineId,productId,productName,variationId,qty,const DeepCollectionEquality().hash(_modifiersJson),kitchenNotes,status);
}

@override
String toString() {
    return 'KotOrderLineModel(id: $id, kotOrderId: $kotOrderId, saleLineId: $saleLineId, productId: $productId, productName: $productName, variationId: $variationId, qty: $qty, modifiersJson: $modifiersJson, kitchenNotes: $kitchenNotes, status: $status)';
}


}

/// @nodoc
abstract mixin class _$KotOrderLineModelCopyWith<$Res> implements $KotOrderLineModelCopyWith<$Res> {
  factory _$KotOrderLineModelCopyWith(_KotOrderLineModel value, $Res Function(_KotOrderLineModel) _then) = __$KotOrderLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'kot_order_id') String kotOrderId,@JsonKey(name: 'sale_line_id') String? saleLineId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId, String qty,@JsonKey(name: 'modifiers_json') List<dynamic> modifiersJson,@JsonKey(name: 'kitchen_notes') String? kitchenNotes, String status
});




}
/// @nodoc
class __$KotOrderLineModelCopyWithImpl<$Res>
    implements _$KotOrderLineModelCopyWith<$Res> {
  __$KotOrderLineModelCopyWithImpl(this._self, this._then);

  final _KotOrderLineModel _self;
  final $Res Function(_KotOrderLineModel) _then;

/// Create a copy of KotOrderLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kotOrderId = null,Object? saleLineId = freezed,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? qty = null,Object? modifiersJson = null,Object? kitchenNotes = freezed,Object? status = null,}) {
  return _then(_KotOrderLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kotOrderId: null == kotOrderId ? _self.kotOrderId : kotOrderId // ignore: cast_nullable_to_non_nullable
as String,saleLineId: freezed == saleLineId ? _self.saleLineId : saleLineId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as String,modifiersJson: null == modifiersJson ? _self._modifiersJson : modifiersJson // ignore: cast_nullable_to_non_nullable
as List<dynamic>,kitchenNotes: freezed == kitchenNotes ? _self.kitchenNotes : kitchenNotes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KotOrderModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'sale_id') String? get saleId;@JsonKey(name: 'table_id') String? get tableId;@JsonKey(name: 'table_number') String? get tableNumber;@JsonKey(name: 'kot_number') String get kotNumber; String get status;@JsonKey(name: 'fired_at') String get firedAt;@JsonKey(name: 'ready_at') String? get readyAt;@JsonKey(name: 'served_at') String? get servedAt; String? get notes; List<KotOrderLineModel> get lines;
/// Create a copy of KotOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KotOrderModelCopyWith<KotOrderModel> get copyWith => _$KotOrderModelCopyWithImpl<KotOrderModel>(this as KotOrderModel, _$identity);

  /// Serializes this KotOrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KotOrderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KotOrderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.saleId, _this.saleId) || other.saleId == _this.saleId)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.tableNumber, _this.tableNumber) || other.tableNumber == _this.tableNumber)&&(identical(other.kotNumber, _this.kotNumber) || other.kotNumber == _this.kotNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.firedAt, _this.firedAt) || other.firedAt == _this.firedAt)&&(identical(other.readyAt, _this.readyAt) || other.readyAt == _this.readyAt)&&(identical(other.servedAt, _this.servedAt) || other.servedAt == _this.servedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KotOrderModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.saleId,_this.tableId,_this.tableNumber,_this.kotNumber,_this.status,_this.firedAt,_this.readyAt,_this.servedAt,_this.notes,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as KotOrderModel;
  return 'KotOrderModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, saleId: ${_this.saleId}, tableId: ${_this.tableId}, tableNumber: ${_this.tableNumber}, kotNumber: ${_this.kotNumber}, status: ${_this.status}, firedAt: ${_this.firedAt}, readyAt: ${_this.readyAt}, servedAt: ${_this.servedAt}, notes: ${_this.notes}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $KotOrderModelCopyWith<$Res>  {
  factory $KotOrderModelCopyWith(KotOrderModel value, $Res Function(KotOrderModel) _then) = _$KotOrderModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'table_id') String? tableId,@JsonKey(name: 'table_number') String? tableNumber,@JsonKey(name: 'kot_number') String kotNumber, String status,@JsonKey(name: 'fired_at') String firedAt,@JsonKey(name: 'ready_at') String? readyAt,@JsonKey(name: 'served_at') String? servedAt, String? notes, List<KotOrderLineModel> lines
});




}
/// @nodoc
class _$KotOrderModelCopyWithImpl<$Res>
    implements $KotOrderModelCopyWith<$Res> {
  _$KotOrderModelCopyWithImpl(this._self, this._then);

  final KotOrderModel _self;
  final $Res Function(KotOrderModel) _then;

/// Create a copy of KotOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? saleId = freezed,Object? tableId = freezed,Object? tableNumber = freezed,Object? kotNumber = null,Object? status = null,Object? firedAt = null,Object? readyAt = freezed,Object? servedAt = freezed,Object? notes = freezed,Object? lines = null,}) {
  return _then(KotOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableNumber: freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,kotNumber: null == kotNumber ? _self.kotNumber : kotNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,firedAt: null == firedAt ? _self.firedAt : firedAt // ignore: cast_nullable_to_non_nullable
as String,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as String?,servedAt: freezed == servedAt ? _self.servedAt : servedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<KotOrderLineModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [KotOrderModel].
extension KotOrderModelPatterns on KotOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KotOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KotOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KotOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _KotOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KotOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _KotOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'table_id')  String? tableId, @JsonKey(name: 'table_number')  String? tableNumber, @JsonKey(name: 'kot_number')  String kotNumber,  String status, @JsonKey(name: 'fired_at')  String firedAt, @JsonKey(name: 'ready_at')  String? readyAt, @JsonKey(name: 'served_at')  String? servedAt,  String? notes,  List<KotOrderLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KotOrderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.saleId,_that.tableId,_that.tableNumber,_that.kotNumber,_that.status,_that.firedAt,_that.readyAt,_that.servedAt,_that.notes,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'table_id')  String? tableId, @JsonKey(name: 'table_number')  String? tableNumber, @JsonKey(name: 'kot_number')  String kotNumber,  String status, @JsonKey(name: 'fired_at')  String firedAt, @JsonKey(name: 'ready_at')  String? readyAt, @JsonKey(name: 'served_at')  String? servedAt,  String? notes,  List<KotOrderLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _KotOrderModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.saleId,_that.tableId,_that.tableNumber,_that.kotNumber,_that.status,_that.firedAt,_that.readyAt,_that.servedAt,_that.notes,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'table_id')  String? tableId, @JsonKey(name: 'table_number')  String? tableNumber, @JsonKey(name: 'kot_number')  String kotNumber,  String status, @JsonKey(name: 'fired_at')  String firedAt, @JsonKey(name: 'ready_at')  String? readyAt, @JsonKey(name: 'served_at')  String? servedAt,  String? notes,  List<KotOrderLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _KotOrderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.saleId,_that.tableId,_that.tableNumber,_that.kotNumber,_that.status,_that.firedAt,_that.readyAt,_that.servedAt,_that.notes,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KotOrderModel implements KotOrderModel {
  const _KotOrderModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'sale_id') this.saleId, @JsonKey(name: 'table_id') this.tableId, @JsonKey(name: 'table_number') this.tableNumber, @JsonKey(name: 'kot_number') required this.kotNumber, required this.status, @JsonKey(name: 'fired_at') required this.firedAt, @JsonKey(name: 'ready_at') this.readyAt, @JsonKey(name: 'served_at') this.servedAt, this.notes,  List<KotOrderLineModel> lines = const []}): _lines = lines;
  factory _KotOrderModel.fromJson(Map<String, dynamic> json) => _$KotOrderModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'sale_id') final  String? saleId;
@override@JsonKey(name: 'table_id') final  String? tableId;
@override@JsonKey(name: 'table_number') final  String? tableNumber;
@override@JsonKey(name: 'kot_number') final  String kotNumber;
@override final  String status;
@override@JsonKey(name: 'fired_at') final  String firedAt;
@override@JsonKey(name: 'ready_at') final  String? readyAt;
@override@JsonKey(name: 'served_at') final  String? servedAt;
@override final  String? notes;
 final  List<KotOrderLineModel> _lines;
@override@JsonKey() List<KotOrderLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of KotOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KotOrderModelCopyWith<_KotOrderModel> get copyWith => __$KotOrderModelCopyWithImpl<_KotOrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KotOrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KotOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.kotNumber, kotNumber) || other.kotNumber == kotNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.firedAt, firedAt) || other.firedAt == firedAt)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.servedAt, servedAt) || other.servedAt == servedAt)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,saleId,tableId,tableNumber,kotNumber,status,firedAt,readyAt,servedAt,notes,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'KotOrderModel(id: $id, businessId: $businessId, branchId: $branchId, saleId: $saleId, tableId: $tableId, tableNumber: $tableNumber, kotNumber: $kotNumber, status: $status, firedAt: $firedAt, readyAt: $readyAt, servedAt: $servedAt, notes: $notes, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$KotOrderModelCopyWith<$Res> implements $KotOrderModelCopyWith<$Res> {
  factory _$KotOrderModelCopyWith(_KotOrderModel value, $Res Function(_KotOrderModel) _then) = __$KotOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'table_id') String? tableId,@JsonKey(name: 'table_number') String? tableNumber,@JsonKey(name: 'kot_number') String kotNumber, String status,@JsonKey(name: 'fired_at') String firedAt,@JsonKey(name: 'ready_at') String? readyAt,@JsonKey(name: 'served_at') String? servedAt, String? notes, List<KotOrderLineModel> lines
});




}
/// @nodoc
class __$KotOrderModelCopyWithImpl<$Res>
    implements _$KotOrderModelCopyWith<$Res> {
  __$KotOrderModelCopyWithImpl(this._self, this._then);

  final _KotOrderModel _self;
  final $Res Function(_KotOrderModel) _then;

/// Create a copy of KotOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? saleId = freezed,Object? tableId = freezed,Object? tableNumber = freezed,Object? kotNumber = null,Object? status = null,Object? firedAt = null,Object? readyAt = freezed,Object? servedAt = freezed,Object? notes = freezed,Object? lines = null,}) {
  return _then(_KotOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableNumber: freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,kotNumber: null == kotNumber ? _self.kotNumber : kotNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,firedAt: null == firedAt ? _self.firedAt : firedAt // ignore: cast_nullable_to_non_nullable
as String,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as String?,servedAt: freezed == servedAt ? _self.servedAt : servedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<KotOrderLineModel>,
  ));
}


}


/// @nodoc
mixin _$FireTabResponseModel {

 String get id;@JsonKey(name: 'kot_number') String get kotNumber;@JsonKey(name: 'sale_id') String? get saleId;@JsonKey(name: 'table_id') String? get tableId; String get status;
/// Create a copy of FireTabResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FireTabResponseModelCopyWith<FireTabResponseModel> get copyWith => _$FireTabResponseModelCopyWithImpl<FireTabResponseModel>(this as FireTabResponseModel, _$identity);

  /// Serializes this FireTabResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FireTabResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FireTabResponseModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kotNumber, _this.kotNumber) || other.kotNumber == _this.kotNumber)&&(identical(other.saleId, _this.saleId) || other.saleId == _this.saleId)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FireTabResponseModel;
  return Object.hash(runtimeType,_this.id,_this.kotNumber,_this.saleId,_this.tableId,_this.status);
}

@override
String toString() {
  final _this = this as FireTabResponseModel;
  return 'FireTabResponseModel(id: ${_this.id}, kotNumber: ${_this.kotNumber}, saleId: ${_this.saleId}, tableId: ${_this.tableId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $FireTabResponseModelCopyWith<$Res>  {
  factory $FireTabResponseModelCopyWith(FireTabResponseModel value, $Res Function(FireTabResponseModel) _then) = _$FireTabResponseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'kot_number') String kotNumber,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'table_id') String? tableId, String status
});




}
/// @nodoc
class _$FireTabResponseModelCopyWithImpl<$Res>
    implements $FireTabResponseModelCopyWith<$Res> {
  _$FireTabResponseModelCopyWithImpl(this._self, this._then);

  final FireTabResponseModel _self;
  final $Res Function(FireTabResponseModel) _then;

/// Create a copy of FireTabResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kotNumber = null,Object? saleId = freezed,Object? tableId = freezed,Object? status = null,}) {
  return _then(FireTabResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kotNumber: null == kotNumber ? _self.kotNumber : kotNumber // ignore: cast_nullable_to_non_nullable
as String,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FireTabResponseModel].
extension FireTabResponseModelPatterns on FireTabResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FireTabResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FireTabResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FireTabResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _FireTabResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FireTabResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _FireTabResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'kot_number')  String kotNumber, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'table_id')  String? tableId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FireTabResponseModel() when $default != null:
return $default(_that.id,_that.kotNumber,_that.saleId,_that.tableId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'kot_number')  String kotNumber, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'table_id')  String? tableId,  String status)  $default,) {final _that = this;
switch (_that) {
case _FireTabResponseModel():
return $default(_that.id,_that.kotNumber,_that.saleId,_that.tableId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'kot_number')  String kotNumber, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'table_id')  String? tableId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _FireTabResponseModel() when $default != null:
return $default(_that.id,_that.kotNumber,_that.saleId,_that.tableId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FireTabResponseModel implements FireTabResponseModel {
  const _FireTabResponseModel({required this.id, @JsonKey(name: 'kot_number') required this.kotNumber, @JsonKey(name: 'sale_id') this.saleId, @JsonKey(name: 'table_id') this.tableId, required this.status});
  factory _FireTabResponseModel.fromJson(Map<String, dynamic> json) => _$FireTabResponseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'kot_number') final  String kotNumber;
@override@JsonKey(name: 'sale_id') final  String? saleId;
@override@JsonKey(name: 'table_id') final  String? tableId;
@override final  String status;

/// Create a copy of FireTabResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FireTabResponseModelCopyWith<_FireTabResponseModel> get copyWith => __$FireTabResponseModelCopyWithImpl<_FireTabResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FireTabResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FireTabResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kotNumber, kotNumber) || other.kotNumber == kotNumber)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kotNumber,saleId,tableId,status);
}

@override
String toString() {
    return 'FireTabResponseModel(id: $id, kotNumber: $kotNumber, saleId: $saleId, tableId: $tableId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FireTabResponseModelCopyWith<$Res> implements $FireTabResponseModelCopyWith<$Res> {
  factory _$FireTabResponseModelCopyWith(_FireTabResponseModel value, $Res Function(_FireTabResponseModel) _then) = __$FireTabResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'kot_number') String kotNumber,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'table_id') String? tableId, String status
});




}
/// @nodoc
class __$FireTabResponseModelCopyWithImpl<$Res>
    implements _$FireTabResponseModelCopyWith<$Res> {
  __$FireTabResponseModelCopyWithImpl(this._self, this._then);

  final _FireTabResponseModel _self;
  final $Res Function(_FireTabResponseModel) _then;

/// Create a copy of FireTabResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kotNumber = null,Object? saleId = freezed,Object? tableId = freezed,Object? status = null,}) {
  return _then(_FireTabResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kotNumber: null == kotNumber ? _self.kotNumber : kotNumber // ignore: cast_nullable_to_non_nullable
as String,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
