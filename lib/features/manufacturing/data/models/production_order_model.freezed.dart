// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductionOrderBomSummaryModel {

 String get id; String get name;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'output_qty') String get outputQty;@JsonKey(fromJson: JsonNum.intOr) int get version;
/// Create a copy of ProductionOrderBomSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionOrderBomSummaryModelCopyWith<ProductionOrderBomSummaryModel> get copyWith => _$ProductionOrderBomSummaryModelCopyWithImpl<ProductionOrderBomSummaryModel>(this as ProductionOrderBomSummaryModel, _$identity);

  /// Serializes this ProductionOrderBomSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductionOrderBomSummaryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrderBomSummaryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.outputQty, _this.outputQty) || other.outputQty == _this.outputQty)&&(identical(other.version, _this.version) || other.version == _this.version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductionOrderBomSummaryModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.productId,_this.productName,_this.variationId,_this.outputQty,_this.version);
}

@override
String toString() {
  final _this = this as ProductionOrderBomSummaryModel;
  return 'ProductionOrderBomSummaryModel(id: ${_this.id}, name: ${_this.name}, productId: ${_this.productId}, productName: ${_this.productName}, variationId: ${_this.variationId}, outputQty: ${_this.outputQty}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $ProductionOrderBomSummaryModelCopyWith<$Res>  {
  factory $ProductionOrderBomSummaryModelCopyWith(ProductionOrderBomSummaryModel value, $Res Function(ProductionOrderBomSummaryModel) _then) = _$ProductionOrderBomSummaryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'output_qty') String outputQty,@JsonKey(fromJson: JsonNum.intOr) int version
});




}
/// @nodoc
class _$ProductionOrderBomSummaryModelCopyWithImpl<$Res>
    implements $ProductionOrderBomSummaryModelCopyWith<$Res> {
  _$ProductionOrderBomSummaryModelCopyWithImpl(this._self, this._then);

  final ProductionOrderBomSummaryModel _self;
  final $Res Function(ProductionOrderBomSummaryModel) _then;

/// Create a copy of ProductionOrderBomSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? outputQty = null,Object? version = null,}) {
  return _then(ProductionOrderBomSummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionOrderBomSummaryModel].
extension ProductionOrderBomSummaryModelPatterns on ProductionOrderBomSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionOrderBomSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionOrderBomSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionOrderBomSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderBomSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionOrderBomSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderBomSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(fromJson: JsonNum.intOr)  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionOrderBomSummaryModel() when $default != null:
return $default(_that.id,_that.name,_that.productId,_that.productName,_that.variationId,_that.outputQty,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(fromJson: JsonNum.intOr)  int version)  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderBomSummaryModel():
return $default(_that.id,_that.name,_that.productId,_that.productName,_that.variationId,_that.outputQty,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(fromJson: JsonNum.intOr)  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderBomSummaryModel() when $default != null:
return $default(_that.id,_that.name,_that.productId,_that.productName,_that.variationId,_that.outputQty,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionOrderBomSummaryModel implements ProductionOrderBomSummaryModel {
  const _ProductionOrderBomSummaryModel({required this.id, required this.name, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'output_qty') required this.outputQty, @JsonKey(fromJson: JsonNum.intOr) this.version = 1});
  factory _ProductionOrderBomSummaryModel.fromJson(Map<String, dynamic> json) => _$ProductionOrderBomSummaryModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'output_qty') final  String outputQty;
@override@JsonKey(fromJson: JsonNum.intOr) final  int version;

/// Create a copy of ProductionOrderBomSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionOrderBomSummaryModelCopyWith<_ProductionOrderBomSummaryModel> get copyWith => __$ProductionOrderBomSummaryModelCopyWithImpl<_ProductionOrderBomSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionOrderBomSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionOrderBomSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.outputQty, outputQty) || other.outputQty == outputQty)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,productId,productName,variationId,outputQty,version);
}

@override
String toString() {
    return 'ProductionOrderBomSummaryModel(id: $id, name: $name, productId: $productId, productName: $productName, variationId: $variationId, outputQty: $outputQty, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProductionOrderBomSummaryModelCopyWith<$Res> implements $ProductionOrderBomSummaryModelCopyWith<$Res> {
  factory _$ProductionOrderBomSummaryModelCopyWith(_ProductionOrderBomSummaryModel value, $Res Function(_ProductionOrderBomSummaryModel) _then) = __$ProductionOrderBomSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'output_qty') String outputQty,@JsonKey(fromJson: JsonNum.intOr) int version
});




}
/// @nodoc
class __$ProductionOrderBomSummaryModelCopyWithImpl<$Res>
    implements _$ProductionOrderBomSummaryModelCopyWith<$Res> {
  __$ProductionOrderBomSummaryModelCopyWithImpl(this._self, this._then);

  final _ProductionOrderBomSummaryModel _self;
  final $Res Function(_ProductionOrderBomSummaryModel) _then;

/// Create a copy of ProductionOrderBomSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? outputQty = null,Object? version = null,}) {
  return _then(_ProductionOrderBomSummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProductionLineModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'variation_id') String? get variationId;@JsonKey(name: 'qty_consumed') String get qtyConsumed;@JsonKey(name: 'cost_per_unit') String get costPerUnit;
/// Create a copy of ProductionLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionLineModelCopyWith<ProductionLineModel> get copyWith => _$ProductionLineModelCopyWithImpl<ProductionLineModel>(this as ProductionLineModel, _$identity);

  /// Serializes this ProductionLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductionLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.qtyConsumed, _this.qtyConsumed) || other.qtyConsumed == _this.qtyConsumed)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductionLineModel;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.productName,_this.variationId,_this.qtyConsumed,_this.costPerUnit);
}

@override
String toString() {
  final _this = this as ProductionLineModel;
  return 'ProductionLineModel(id: ${_this.id}, productId: ${_this.productId}, productName: ${_this.productName}, variationId: ${_this.variationId}, qtyConsumed: ${_this.qtyConsumed}, costPerUnit: ${_this.costPerUnit})';
}


}

/// @nodoc
abstract mixin class $ProductionLineModelCopyWith<$Res>  {
  factory $ProductionLineModelCopyWith(ProductionLineModel value, $Res Function(ProductionLineModel) _then) = _$ProductionLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'qty_consumed') String qtyConsumed,@JsonKey(name: 'cost_per_unit') String costPerUnit
});




}
/// @nodoc
class _$ProductionLineModelCopyWithImpl<$Res>
    implements $ProductionLineModelCopyWith<$Res> {
  _$ProductionLineModelCopyWithImpl(this._self, this._then);

  final ProductionLineModel _self;
  final $Res Function(ProductionLineModel) _then;

/// Create a copy of ProductionLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? qtyConsumed = null,Object? costPerUnit = null,}) {
  return _then(ProductionLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qtyConsumed: null == qtyConsumed ? _self.qtyConsumed : qtyConsumed // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionLineModel].
extension ProductionLineModelPatterns on ProductionLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionLineModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductionLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_consumed')  String qtyConsumed, @JsonKey(name: 'cost_per_unit')  String costPerUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionLineModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.variationId,_that.qtyConsumed,_that.costPerUnit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_consumed')  String qtyConsumed, @JsonKey(name: 'cost_per_unit')  String costPerUnit)  $default,) {final _that = this;
switch (_that) {
case _ProductionLineModel():
return $default(_that.id,_that.productId,_that.productName,_that.variationId,_that.qtyConsumed,_that.costPerUnit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId, @JsonKey(name: 'qty_consumed')  String qtyConsumed, @JsonKey(name: 'cost_per_unit')  String costPerUnit)?  $default,) {final _that = this;
switch (_that) {
case _ProductionLineModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.variationId,_that.qtyConsumed,_that.costPerUnit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionLineModel implements ProductionLineModel {
  const _ProductionLineModel({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'variation_id') this.variationId, @JsonKey(name: 'qty_consumed') required this.qtyConsumed, @JsonKey(name: 'cost_per_unit') required this.costPerUnit});
  factory _ProductionLineModel.fromJson(Map<String, dynamic> json) => _$ProductionLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override@JsonKey(name: 'qty_consumed') final  String qtyConsumed;
@override@JsonKey(name: 'cost_per_unit') final  String costPerUnit;

/// Create a copy of ProductionLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionLineModelCopyWith<_ProductionLineModel> get copyWith => __$ProductionLineModelCopyWithImpl<_ProductionLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.qtyConsumed, qtyConsumed) || other.qtyConsumed == qtyConsumed)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,productName,variationId,qtyConsumed,costPerUnit);
}

@override
String toString() {
    return 'ProductionLineModel(id: $id, productId: $productId, productName: $productName, variationId: $variationId, qtyConsumed: $qtyConsumed, costPerUnit: $costPerUnit)';
}


}

/// @nodoc
abstract mixin class _$ProductionLineModelCopyWith<$Res> implements $ProductionLineModelCopyWith<$Res> {
  factory _$ProductionLineModelCopyWith(_ProductionLineModel value, $Res Function(_ProductionLineModel) _then) = __$ProductionLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId,@JsonKey(name: 'qty_consumed') String qtyConsumed,@JsonKey(name: 'cost_per_unit') String costPerUnit
});




}
/// @nodoc
class __$ProductionLineModelCopyWithImpl<$Res>
    implements _$ProductionLineModelCopyWith<$Res> {
  __$ProductionLineModelCopyWithImpl(this._self, this._then);

  final _ProductionLineModel _self;
  final $Res Function(_ProductionLineModel) _then;

/// Create a copy of ProductionLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? qtyConsumed = null,Object? costPerUnit = null,}) {
  return _then(_ProductionLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,qtyConsumed: null == qtyConsumed ? _self.qtyConsumed : qtyConsumed // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProductionOrderModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String get branchId;@JsonKey(name: 'bom_header_id') String get bomHeaderId;@JsonKey(name: 'production_number') String get productionNumber; String get status;@JsonKey(name: 'qty_to_produce') String get qtyToProduce;@JsonKey(name: 'qty_produced') String get qtyProduced;@JsonKey(name: 'started_at') String? get startedAt;@JsonKey(name: 'completed_at') String? get completedAt; String? get notes; ProductionOrderBomSummaryModel get bom;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt; List<ProductionLineModel> get lines;
/// Create a copy of ProductionOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionOrderModelCopyWith<ProductionOrderModel> get copyWith => _$ProductionOrderModelCopyWithImpl<ProductionOrderModel>(this as ProductionOrderModel, _$identity);

  /// Serializes this ProductionOrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductionOrderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.bomHeaderId, _this.bomHeaderId) || other.bomHeaderId == _this.bomHeaderId)&&(identical(other.productionNumber, _this.productionNumber) || other.productionNumber == _this.productionNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.qtyToProduce, _this.qtyToProduce) || other.qtyToProduce == _this.qtyToProduce)&&(identical(other.qtyProduced, _this.qtyProduced) || other.qtyProduced == _this.qtyProduced)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.bom, _this.bom) || other.bom == _this.bom)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductionOrderModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.bomHeaderId,_this.productionNumber,_this.status,_this.qtyToProduce,_this.qtyProduced,_this.startedAt,_this.completedAt,_this.notes,_this.bom,_this.createdAt,_this.updatedAt,_this.deletedAt,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as ProductionOrderModel;
  return 'ProductionOrderModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, bomHeaderId: ${_this.bomHeaderId}, productionNumber: ${_this.productionNumber}, status: ${_this.status}, qtyToProduce: ${_this.qtyToProduce}, qtyProduced: ${_this.qtyProduced}, startedAt: ${_this.startedAt}, completedAt: ${_this.completedAt}, notes: ${_this.notes}, bom: ${_this.bom}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $ProductionOrderModelCopyWith<$Res>  {
  factory $ProductionOrderModelCopyWith(ProductionOrderModel value, $Res Function(ProductionOrderModel) _then) = _$ProductionOrderModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'bom_header_id') String bomHeaderId,@JsonKey(name: 'production_number') String productionNumber, String status,@JsonKey(name: 'qty_to_produce') String qtyToProduce,@JsonKey(name: 'qty_produced') String qtyProduced,@JsonKey(name: 'started_at') String? startedAt,@JsonKey(name: 'completed_at') String? completedAt, String? notes, ProductionOrderBomSummaryModel bom,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt, List<ProductionLineModel> lines
});


$ProductionOrderBomSummaryModelCopyWith<$Res> get bom;

}
/// @nodoc
class _$ProductionOrderModelCopyWithImpl<$Res>
    implements $ProductionOrderModelCopyWith<$Res> {
  _$ProductionOrderModelCopyWithImpl(this._self, this._then);

  final ProductionOrderModel _self;
  final $Res Function(ProductionOrderModel) _then;

/// Create a copy of ProductionOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? bomHeaderId = null,Object? productionNumber = null,Object? status = null,Object? qtyToProduce = null,Object? qtyProduced = null,Object? startedAt = freezed,Object? completedAt = freezed,Object? notes = freezed,Object? bom = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? lines = null,}) {
  return _then(ProductionOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,bomHeaderId: null == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String,productionNumber: null == productionNumber ? _self.productionNumber : productionNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,qtyToProduce: null == qtyToProduce ? _self.qtyToProduce : qtyToProduce // ignore: cast_nullable_to_non_nullable
as String,qtyProduced: null == qtyProduced ? _self.qtyProduced : qtyProduced // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bom: null == bom ? _self.bom : bom // ignore: cast_nullable_to_non_nullable
as ProductionOrderBomSummaryModel,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ProductionLineModel>,
  ));
}
/// Create a copy of ProductionOrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductionOrderBomSummaryModelCopyWith<$Res> get bom {
  
  return $ProductionOrderBomSummaryModelCopyWith<$Res>(_self.bom, (value) {
    return _then(_self.copyWith(bom: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductionOrderModel].
extension ProductionOrderModelPatterns on ProductionOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'production_number')  String productionNumber,  String status, @JsonKey(name: 'qty_to_produce')  String qtyToProduce, @JsonKey(name: 'qty_produced')  String qtyProduced, @JsonKey(name: 'started_at')  String? startedAt, @JsonKey(name: 'completed_at')  String? completedAt,  String? notes,  ProductionOrderBomSummaryModel bom, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<ProductionLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionOrderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.bomHeaderId,_that.productionNumber,_that.status,_that.qtyToProduce,_that.qtyProduced,_that.startedAt,_that.completedAt,_that.notes,_that.bom,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'production_number')  String productionNumber,  String status, @JsonKey(name: 'qty_to_produce')  String qtyToProduce, @JsonKey(name: 'qty_produced')  String qtyProduced, @JsonKey(name: 'started_at')  String? startedAt, @JsonKey(name: 'completed_at')  String? completedAt,  String? notes,  ProductionOrderBomSummaryModel bom, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<ProductionLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.bomHeaderId,_that.productionNumber,_that.status,_that.qtyToProduce,_that.qtyProduced,_that.startedAt,_that.completedAt,_that.notes,_that.bom,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String branchId, @JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'production_number')  String productionNumber,  String status, @JsonKey(name: 'qty_to_produce')  String qtyToProduce, @JsonKey(name: 'qty_produced')  String qtyProduced, @JsonKey(name: 'started_at')  String? startedAt, @JsonKey(name: 'completed_at')  String? completedAt,  String? notes,  ProductionOrderBomSummaryModel bom, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<ProductionLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.bomHeaderId,_that.productionNumber,_that.status,_that.qtyToProduce,_that.qtyProduced,_that.startedAt,_that.completedAt,_that.notes,_that.bom,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionOrderModel implements ProductionOrderModel {
  const _ProductionOrderModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') required this.branchId, @JsonKey(name: 'bom_header_id') required this.bomHeaderId, @JsonKey(name: 'production_number') required this.productionNumber, required this.status, @JsonKey(name: 'qty_to_produce') required this.qtyToProduce, @JsonKey(name: 'qty_produced') this.qtyProduced = '0', @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'completed_at') this.completedAt, this.notes, required this.bom, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt,  List<ProductionLineModel> lines = const []}): _lines = lines;
  factory _ProductionOrderModel.fromJson(Map<String, dynamic> json) => _$ProductionOrderModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String branchId;
@override@JsonKey(name: 'bom_header_id') final  String bomHeaderId;
@override@JsonKey(name: 'production_number') final  String productionNumber;
@override final  String status;
@override@JsonKey(name: 'qty_to_produce') final  String qtyToProduce;
@override@JsonKey(name: 'qty_produced') final  String qtyProduced;
@override@JsonKey(name: 'started_at') final  String? startedAt;
@override@JsonKey(name: 'completed_at') final  String? completedAt;
@override final  String? notes;
@override final  ProductionOrderBomSummaryModel bom;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;
 final  List<ProductionLineModel> _lines;
@override@JsonKey() List<ProductionLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of ProductionOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionOrderModelCopyWith<_ProductionOrderModel> get copyWith => __$ProductionOrderModelCopyWithImpl<_ProductionOrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionOrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.bomHeaderId, bomHeaderId) || other.bomHeaderId == bomHeaderId)&&(identical(other.productionNumber, productionNumber) || other.productionNumber == productionNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.qtyToProduce, qtyToProduce) || other.qtyToProduce == qtyToProduce)&&(identical(other.qtyProduced, qtyProduced) || other.qtyProduced == qtyProduced)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bom, bom) || other.bom == bom)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,bomHeaderId,productionNumber,status,qtyToProduce,qtyProduced,startedAt,completedAt,notes,bom,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'ProductionOrderModel(id: $id, businessId: $businessId, branchId: $branchId, bomHeaderId: $bomHeaderId, productionNumber: $productionNumber, status: $status, qtyToProduce: $qtyToProduce, qtyProduced: $qtyProduced, startedAt: $startedAt, completedAt: $completedAt, notes: $notes, bom: $bom, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$ProductionOrderModelCopyWith<$Res> implements $ProductionOrderModelCopyWith<$Res> {
  factory _$ProductionOrderModelCopyWith(_ProductionOrderModel value, $Res Function(_ProductionOrderModel) _then) = __$ProductionOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String branchId,@JsonKey(name: 'bom_header_id') String bomHeaderId,@JsonKey(name: 'production_number') String productionNumber, String status,@JsonKey(name: 'qty_to_produce') String qtyToProduce,@JsonKey(name: 'qty_produced') String qtyProduced,@JsonKey(name: 'started_at') String? startedAt,@JsonKey(name: 'completed_at') String? completedAt, String? notes, ProductionOrderBomSummaryModel bom,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt, List<ProductionLineModel> lines
});


@override $ProductionOrderBomSummaryModelCopyWith<$Res> get bom;

}
/// @nodoc
class __$ProductionOrderModelCopyWithImpl<$Res>
    implements _$ProductionOrderModelCopyWith<$Res> {
  __$ProductionOrderModelCopyWithImpl(this._self, this._then);

  final _ProductionOrderModel _self;
  final $Res Function(_ProductionOrderModel) _then;

/// Create a copy of ProductionOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = null,Object? bomHeaderId = null,Object? productionNumber = null,Object? status = null,Object? qtyToProduce = null,Object? qtyProduced = null,Object? startedAt = freezed,Object? completedAt = freezed,Object? notes = freezed,Object? bom = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? lines = null,}) {
  return _then(_ProductionOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,bomHeaderId: null == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String,productionNumber: null == productionNumber ? _self.productionNumber : productionNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,qtyToProduce: null == qtyToProduce ? _self.qtyToProduce : qtyToProduce // ignore: cast_nullable_to_non_nullable
as String,qtyProduced: null == qtyProduced ? _self.qtyProduced : qtyProduced // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bom: null == bom ? _self.bom : bom // ignore: cast_nullable_to_non_nullable
as ProductionOrderBomSummaryModel,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ProductionLineModel>,
  ));
}

/// Create a copy of ProductionOrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductionOrderBomSummaryModelCopyWith<$Res> get bom {
  
  return $ProductionOrderBomSummaryModelCopyWith<$Res>(_self.bom, (value) {
    return _then(_self.copyWith(bom: value));
  });
}
}

// dart format on
