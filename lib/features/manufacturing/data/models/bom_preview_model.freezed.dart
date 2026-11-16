// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_preview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BomPreviewLineModel {

@JsonKey(name: 'ingredient_product_id') String get ingredientProductId;@JsonKey(name: 'ingredient_product_name') String get ingredientProductName;@JsonKey(name: 'ingredient_variation_id') String? get ingredientVariationId;@JsonKey(name: 'qty_per_output_unit') String get qtyPerOutputUnit;@JsonKey(name: 'total_qty_required') String get totalQtyRequired;@JsonKey(name: 'wastage_pct') String get wastagePct;
/// Create a copy of BomPreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomPreviewLineModelCopyWith<BomPreviewLineModel> get copyWith => _$BomPreviewLineModelCopyWithImpl<BomPreviewLineModel>(this as BomPreviewLineModel, _$identity);

  /// Serializes this BomPreviewLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BomPreviewLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BomPreviewLineModel&&(identical(other.ingredientProductId, _this.ingredientProductId) || other.ingredientProductId == _this.ingredientProductId)&&(identical(other.ingredientProductName, _this.ingredientProductName) || other.ingredientProductName == _this.ingredientProductName)&&(identical(other.ingredientVariationId, _this.ingredientVariationId) || other.ingredientVariationId == _this.ingredientVariationId)&&(identical(other.qtyPerOutputUnit, _this.qtyPerOutputUnit) || other.qtyPerOutputUnit == _this.qtyPerOutputUnit)&&(identical(other.totalQtyRequired, _this.totalQtyRequired) || other.totalQtyRequired == _this.totalQtyRequired)&&(identical(other.wastagePct, _this.wastagePct) || other.wastagePct == _this.wastagePct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BomPreviewLineModel;
  return Object.hash(runtimeType,_this.ingredientProductId,_this.ingredientProductName,_this.ingredientVariationId,_this.qtyPerOutputUnit,_this.totalQtyRequired,_this.wastagePct);
}

@override
String toString() {
  final _this = this as BomPreviewLineModel;
  return 'BomPreviewLineModel(ingredientProductId: ${_this.ingredientProductId}, ingredientProductName: ${_this.ingredientProductName}, ingredientVariationId: ${_this.ingredientVariationId}, qtyPerOutputUnit: ${_this.qtyPerOutputUnit}, totalQtyRequired: ${_this.totalQtyRequired}, wastagePct: ${_this.wastagePct})';
}


}

/// @nodoc
abstract mixin class $BomPreviewLineModelCopyWith<$Res>  {
  factory $BomPreviewLineModelCopyWith(BomPreviewLineModel value, $Res Function(BomPreviewLineModel) _then) = _$BomPreviewLineModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ingredient_product_id') String ingredientProductId,@JsonKey(name: 'ingredient_product_name') String ingredientProductName,@JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,@JsonKey(name: 'qty_per_output_unit') String qtyPerOutputUnit,@JsonKey(name: 'total_qty_required') String totalQtyRequired,@JsonKey(name: 'wastage_pct') String wastagePct
});




}
/// @nodoc
class _$BomPreviewLineModelCopyWithImpl<$Res>
    implements $BomPreviewLineModelCopyWith<$Res> {
  _$BomPreviewLineModelCopyWithImpl(this._self, this._then);

  final BomPreviewLineModel _self;
  final $Res Function(BomPreviewLineModel) _then;

/// Create a copy of BomPreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingredientProductId = null,Object? ingredientProductName = null,Object? ingredientVariationId = freezed,Object? qtyPerOutputUnit = null,Object? totalQtyRequired = null,Object? wastagePct = null,}) {
  return _then(BomPreviewLineModel(
ingredientProductId: null == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String,ingredientProductName: null == ingredientProductName ? _self.ingredientProductName : ingredientProductName // ignore: cast_nullable_to_non_nullable
as String,ingredientVariationId: freezed == ingredientVariationId ? _self.ingredientVariationId : ingredientVariationId // ignore: cast_nullable_to_non_nullable
as String?,qtyPerOutputUnit: null == qtyPerOutputUnit ? _self.qtyPerOutputUnit : qtyPerOutputUnit // ignore: cast_nullable_to_non_nullable
as String,totalQtyRequired: null == totalQtyRequired ? _self.totalQtyRequired : totalQtyRequired // ignore: cast_nullable_to_non_nullable
as String,wastagePct: null == wastagePct ? _self.wastagePct : wastagePct // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BomPreviewLineModel].
extension BomPreviewLineModelPatterns on BomPreviewLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BomPreviewLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BomPreviewLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BomPreviewLineModel value)  $default,){
final _that = this;
switch (_that) {
case _BomPreviewLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BomPreviewLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _BomPreviewLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ingredient_product_id')  String ingredientProductId, @JsonKey(name: 'ingredient_product_name')  String ingredientProductName, @JsonKey(name: 'ingredient_variation_id')  String? ingredientVariationId, @JsonKey(name: 'qty_per_output_unit')  String qtyPerOutputUnit, @JsonKey(name: 'total_qty_required')  String totalQtyRequired, @JsonKey(name: 'wastage_pct')  String wastagePct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BomPreviewLineModel() when $default != null:
return $default(_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.qtyPerOutputUnit,_that.totalQtyRequired,_that.wastagePct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ingredient_product_id')  String ingredientProductId, @JsonKey(name: 'ingredient_product_name')  String ingredientProductName, @JsonKey(name: 'ingredient_variation_id')  String? ingredientVariationId, @JsonKey(name: 'qty_per_output_unit')  String qtyPerOutputUnit, @JsonKey(name: 'total_qty_required')  String totalQtyRequired, @JsonKey(name: 'wastage_pct')  String wastagePct)  $default,) {final _that = this;
switch (_that) {
case _BomPreviewLineModel():
return $default(_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.qtyPerOutputUnit,_that.totalQtyRequired,_that.wastagePct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ingredient_product_id')  String ingredientProductId, @JsonKey(name: 'ingredient_product_name')  String ingredientProductName, @JsonKey(name: 'ingredient_variation_id')  String? ingredientVariationId, @JsonKey(name: 'qty_per_output_unit')  String qtyPerOutputUnit, @JsonKey(name: 'total_qty_required')  String totalQtyRequired, @JsonKey(name: 'wastage_pct')  String wastagePct)?  $default,) {final _that = this;
switch (_that) {
case _BomPreviewLineModel() when $default != null:
return $default(_that.ingredientProductId,_that.ingredientProductName,_that.ingredientVariationId,_that.qtyPerOutputUnit,_that.totalQtyRequired,_that.wastagePct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BomPreviewLineModel implements BomPreviewLineModel {
  const _BomPreviewLineModel({@JsonKey(name: 'ingredient_product_id') required this.ingredientProductId, @JsonKey(name: 'ingredient_product_name') required this.ingredientProductName, @JsonKey(name: 'ingredient_variation_id') this.ingredientVariationId, @JsonKey(name: 'qty_per_output_unit') required this.qtyPerOutputUnit, @JsonKey(name: 'total_qty_required') required this.totalQtyRequired, @JsonKey(name: 'wastage_pct') this.wastagePct = '0'});
  factory _BomPreviewLineModel.fromJson(Map<String, dynamic> json) => _$BomPreviewLineModelFromJson(json);

@override@JsonKey(name: 'ingredient_product_id') final  String ingredientProductId;
@override@JsonKey(name: 'ingredient_product_name') final  String ingredientProductName;
@override@JsonKey(name: 'ingredient_variation_id') final  String? ingredientVariationId;
@override@JsonKey(name: 'qty_per_output_unit') final  String qtyPerOutputUnit;
@override@JsonKey(name: 'total_qty_required') final  String totalQtyRequired;
@override@JsonKey(name: 'wastage_pct') final  String wastagePct;

/// Create a copy of BomPreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BomPreviewLineModelCopyWith<_BomPreviewLineModel> get copyWith => __$BomPreviewLineModelCopyWithImpl<_BomPreviewLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BomPreviewLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BomPreviewLineModel&&(identical(other.ingredientProductId, ingredientProductId) || other.ingredientProductId == ingredientProductId)&&(identical(other.ingredientProductName, ingredientProductName) || other.ingredientProductName == ingredientProductName)&&(identical(other.ingredientVariationId, ingredientVariationId) || other.ingredientVariationId == ingredientVariationId)&&(identical(other.qtyPerOutputUnit, qtyPerOutputUnit) || other.qtyPerOutputUnit == qtyPerOutputUnit)&&(identical(other.totalQtyRequired, totalQtyRequired) || other.totalQtyRequired == totalQtyRequired)&&(identical(other.wastagePct, wastagePct) || other.wastagePct == wastagePct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ingredientProductId,ingredientProductName,ingredientVariationId,qtyPerOutputUnit,totalQtyRequired,wastagePct);
}

@override
String toString() {
    return 'BomPreviewLineModel(ingredientProductId: $ingredientProductId, ingredientProductName: $ingredientProductName, ingredientVariationId: $ingredientVariationId, qtyPerOutputUnit: $qtyPerOutputUnit, totalQtyRequired: $totalQtyRequired, wastagePct: $wastagePct)';
}


}

/// @nodoc
abstract mixin class _$BomPreviewLineModelCopyWith<$Res> implements $BomPreviewLineModelCopyWith<$Res> {
  factory _$BomPreviewLineModelCopyWith(_BomPreviewLineModel value, $Res Function(_BomPreviewLineModel) _then) = __$BomPreviewLineModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ingredient_product_id') String ingredientProductId,@JsonKey(name: 'ingredient_product_name') String ingredientProductName,@JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,@JsonKey(name: 'qty_per_output_unit') String qtyPerOutputUnit,@JsonKey(name: 'total_qty_required') String totalQtyRequired,@JsonKey(name: 'wastage_pct') String wastagePct
});




}
/// @nodoc
class __$BomPreviewLineModelCopyWithImpl<$Res>
    implements _$BomPreviewLineModelCopyWith<$Res> {
  __$BomPreviewLineModelCopyWithImpl(this._self, this._then);

  final _BomPreviewLineModel _self;
  final $Res Function(_BomPreviewLineModel) _then;

/// Create a copy of BomPreviewLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingredientProductId = null,Object? ingredientProductName = null,Object? ingredientVariationId = freezed,Object? qtyPerOutputUnit = null,Object? totalQtyRequired = null,Object? wastagePct = null,}) {
  return _then(_BomPreviewLineModel(
ingredientProductId: null == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String,ingredientProductName: null == ingredientProductName ? _self.ingredientProductName : ingredientProductName // ignore: cast_nullable_to_non_nullable
as String,ingredientVariationId: freezed == ingredientVariationId ? _self.ingredientVariationId : ingredientVariationId // ignore: cast_nullable_to_non_nullable
as String?,qtyPerOutputUnit: null == qtyPerOutputUnit ? _self.qtyPerOutputUnit : qtyPerOutputUnit // ignore: cast_nullable_to_non_nullable
as String,totalQtyRequired: null == totalQtyRequired ? _self.totalQtyRequired : totalQtyRequired // ignore: cast_nullable_to_non_nullable
as String,wastagePct: null == wastagePct ? _self.wastagePct : wastagePct // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BomPreviewModel {

@JsonKey(name: 'bom_header_id') String get bomHeaderId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'output_qty') String get outputQty;@JsonKey(name: 'qty_to_produce') String get qtyToProduce; List<BomPreviewLineModel> get lines;
/// Create a copy of BomPreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomPreviewModelCopyWith<BomPreviewModel> get copyWith => _$BomPreviewModelCopyWithImpl<BomPreviewModel>(this as BomPreviewModel, _$identity);

  /// Serializes this BomPreviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BomPreviewModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BomPreviewModel&&(identical(other.bomHeaderId, _this.bomHeaderId) || other.bomHeaderId == _this.bomHeaderId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.outputQty, _this.outputQty) || other.outputQty == _this.outputQty)&&(identical(other.qtyToProduce, _this.qtyToProduce) || other.qtyToProduce == _this.qtyToProduce)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BomPreviewModel;
  return Object.hash(runtimeType,_this.bomHeaderId,_this.productId,_this.outputQty,_this.qtyToProduce,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as BomPreviewModel;
  return 'BomPreviewModel(bomHeaderId: ${_this.bomHeaderId}, productId: ${_this.productId}, outputQty: ${_this.outputQty}, qtyToProduce: ${_this.qtyToProduce}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $BomPreviewModelCopyWith<$Res>  {
  factory $BomPreviewModelCopyWith(BomPreviewModel value, $Res Function(BomPreviewModel) _then) = _$BomPreviewModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bom_header_id') String bomHeaderId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'output_qty') String outputQty,@JsonKey(name: 'qty_to_produce') String qtyToProduce, List<BomPreviewLineModel> lines
});




}
/// @nodoc
class _$BomPreviewModelCopyWithImpl<$Res>
    implements $BomPreviewModelCopyWith<$Res> {
  _$BomPreviewModelCopyWithImpl(this._self, this._then);

  final BomPreviewModel _self;
  final $Res Function(BomPreviewModel) _then;

/// Create a copy of BomPreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bomHeaderId = null,Object? productId = null,Object? outputQty = null,Object? qtyToProduce = null,Object? lines = null,}) {
  return _then(BomPreviewModel(
bomHeaderId: null == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,qtyToProduce: null == qtyToProduce ? _self.qtyToProduce : qtyToProduce // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<BomPreviewLineModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BomPreviewModel].
extension BomPreviewModelPatterns on BomPreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BomPreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BomPreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BomPreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _BomPreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BomPreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _BomPreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(name: 'qty_to_produce')  String qtyToProduce,  List<BomPreviewLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BomPreviewModel() when $default != null:
return $default(_that.bomHeaderId,_that.productId,_that.outputQty,_that.qtyToProduce,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(name: 'qty_to_produce')  String qtyToProduce,  List<BomPreviewLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _BomPreviewModel():
return $default(_that.bomHeaderId,_that.productId,_that.outputQty,_that.qtyToProduce,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bom_header_id')  String bomHeaderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(name: 'qty_to_produce')  String qtyToProduce,  List<BomPreviewLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _BomPreviewModel() when $default != null:
return $default(_that.bomHeaderId,_that.productId,_that.outputQty,_that.qtyToProduce,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BomPreviewModel implements BomPreviewModel {
  const _BomPreviewModel({@JsonKey(name: 'bom_header_id') required this.bomHeaderId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'output_qty') required this.outputQty, @JsonKey(name: 'qty_to_produce') required this.qtyToProduce,  List<BomPreviewLineModel> lines = const []}): _lines = lines;
  factory _BomPreviewModel.fromJson(Map<String, dynamic> json) => _$BomPreviewModelFromJson(json);

@override@JsonKey(name: 'bom_header_id') final  String bomHeaderId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'output_qty') final  String outputQty;
@override@JsonKey(name: 'qty_to_produce') final  String qtyToProduce;
 final  List<BomPreviewLineModel> _lines;
@override@JsonKey() List<BomPreviewLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of BomPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BomPreviewModelCopyWith<_BomPreviewModel> get copyWith => __$BomPreviewModelCopyWithImpl<_BomPreviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BomPreviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BomPreviewModel&&(identical(other.bomHeaderId, bomHeaderId) || other.bomHeaderId == bomHeaderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.outputQty, outputQty) || other.outputQty == outputQty)&&(identical(other.qtyToProduce, qtyToProduce) || other.qtyToProduce == qtyToProduce)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,bomHeaderId,productId,outputQty,qtyToProduce,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'BomPreviewModel(bomHeaderId: $bomHeaderId, productId: $productId, outputQty: $outputQty, qtyToProduce: $qtyToProduce, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$BomPreviewModelCopyWith<$Res> implements $BomPreviewModelCopyWith<$Res> {
  factory _$BomPreviewModelCopyWith(_BomPreviewModel value, $Res Function(_BomPreviewModel) _then) = __$BomPreviewModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bom_header_id') String bomHeaderId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'output_qty') String outputQty,@JsonKey(name: 'qty_to_produce') String qtyToProduce, List<BomPreviewLineModel> lines
});




}
/// @nodoc
class __$BomPreviewModelCopyWithImpl<$Res>
    implements _$BomPreviewModelCopyWith<$Res> {
  __$BomPreviewModelCopyWithImpl(this._self, this._then);

  final _BomPreviewModel _self;
  final $Res Function(_BomPreviewModel) _then;

/// Create a copy of BomPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bomHeaderId = null,Object? productId = null,Object? outputQty = null,Object? qtyToProduce = null,Object? lines = null,}) {
  return _then(_BomPreviewModel(
bomHeaderId: null == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,qtyToProduce: null == qtyToProduce ? _self.qtyToProduce : qtyToProduce // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<BomPreviewLineModel>,
  ));
}


}

// dart format on
