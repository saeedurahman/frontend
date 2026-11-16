// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_header_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BomHeaderModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'variation_id') String? get variationId; String get name;@JsonKey(name: 'output_qty') String get outputQty;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(fromJson: JsonNum.intOr) int get version;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt; List<BomLineModel> get lines;
/// Create a copy of BomHeaderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomHeaderModelCopyWith<BomHeaderModel> get copyWith => _$BomHeaderModelCopyWithImpl<BomHeaderModel>(this as BomHeaderModel, _$identity);

  /// Serializes this BomHeaderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BomHeaderModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BomHeaderModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.outputQty, _this.outputQty) || other.outputQty == _this.outputQty)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BomHeaderModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.productId,_this.productName,_this.variationId,_this.name,_this.outputQty,_this.isActive,_this.version,_this.createdAt,_this.updatedAt,_this.deletedAt,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as BomHeaderModel;
  return 'BomHeaderModel(id: ${_this.id}, businessId: ${_this.businessId}, productId: ${_this.productId}, productName: ${_this.productName}, variationId: ${_this.variationId}, name: ${_this.name}, outputQty: ${_this.outputQty}, isActive: ${_this.isActive}, version: ${_this.version}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $BomHeaderModelCopyWith<$Res>  {
  factory $BomHeaderModelCopyWith(BomHeaderModel value, $Res Function(BomHeaderModel) _then) = _$BomHeaderModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId, String name,@JsonKey(name: 'output_qty') String outputQty,@JsonKey(name: 'is_active') bool isActive,@JsonKey(fromJson: JsonNum.intOr) int version,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt, List<BomLineModel> lines
});




}
/// @nodoc
class _$BomHeaderModelCopyWithImpl<$Res>
    implements $BomHeaderModelCopyWith<$Res> {
  _$BomHeaderModelCopyWithImpl(this._self, this._then);

  final BomHeaderModel _self;
  final $Res Function(BomHeaderModel) _then;

/// Create a copy of BomHeaderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? name = null,Object? outputQty = null,Object? isActive = null,Object? version = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? lines = null,}) {
  return _then(BomHeaderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<BomLineModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BomHeaderModel].
extension BomHeaderModelPatterns on BomHeaderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BomHeaderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BomHeaderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BomHeaderModel value)  $default,){
final _that = this;
switch (_that) {
case _BomHeaderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BomHeaderModel value)?  $default,){
final _that = this;
switch (_that) {
case _BomHeaderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId,  String name, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(fromJson: JsonNum.intOr)  int version, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<BomLineModel> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BomHeaderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.productId,_that.productName,_that.variationId,_that.name,_that.outputQty,_that.isActive,_that.version,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId,  String name, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(fromJson: JsonNum.intOr)  int version, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<BomLineModel> lines)  $default,) {final _that = this;
switch (_that) {
case _BomHeaderModel():
return $default(_that.id,_that.businessId,_that.productId,_that.productName,_that.variationId,_that.name,_that.outputQty,_that.isActive,_that.version,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'variation_id')  String? variationId,  String name, @JsonKey(name: 'output_qty')  String outputQty, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(fromJson: JsonNum.intOr)  int version, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt,  List<BomLineModel> lines)?  $default,) {final _that = this;
switch (_that) {
case _BomHeaderModel() when $default != null:
return $default(_that.id,_that.businessId,_that.productId,_that.productName,_that.variationId,_that.name,_that.outputQty,_that.isActive,_that.version,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BomHeaderModel implements BomHeaderModel {
  const _BomHeaderModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'variation_id') this.variationId, required this.name, @JsonKey(name: 'output_qty') required this.outputQty, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(fromJson: JsonNum.intOr) this.version = 1, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt,  List<BomLineModel> lines = const []}): _lines = lines;
  factory _BomHeaderModel.fromJson(Map<String, dynamic> json) => _$BomHeaderModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'variation_id') final  String? variationId;
@override final  String name;
@override@JsonKey(name: 'output_qty') final  String outputQty;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(fromJson: JsonNum.intOr) final  int version;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;
 final  List<BomLineModel> _lines;
@override@JsonKey() List<BomLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of BomHeaderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BomHeaderModelCopyWith<_BomHeaderModel> get copyWith => __$BomHeaderModelCopyWithImpl<_BomHeaderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BomHeaderModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BomHeaderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.outputQty, outputQty) || other.outputQty == outputQty)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,productId,productName,variationId,name,outputQty,isActive,version,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'BomHeaderModel(id: $id, businessId: $businessId, productId: $productId, productName: $productName, variationId: $variationId, name: $name, outputQty: $outputQty, isActive: $isActive, version: $version, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$BomHeaderModelCopyWith<$Res> implements $BomHeaderModelCopyWith<$Res> {
  factory _$BomHeaderModelCopyWith(_BomHeaderModel value, $Res Function(_BomHeaderModel) _then) = __$BomHeaderModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'variation_id') String? variationId, String name,@JsonKey(name: 'output_qty') String outputQty,@JsonKey(name: 'is_active') bool isActive,@JsonKey(fromJson: JsonNum.intOr) int version,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt, List<BomLineModel> lines
});




}
/// @nodoc
class __$BomHeaderModelCopyWithImpl<$Res>
    implements _$BomHeaderModelCopyWith<$Res> {
  __$BomHeaderModelCopyWithImpl(this._self, this._then);

  final _BomHeaderModel _self;
  final $Res Function(_BomHeaderModel) _then;

/// Create a copy of BomHeaderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? productId = null,Object? productName = null,Object? variationId = freezed,Object? name = null,Object? outputQty = null,Object? isActive = null,Object? version = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? lines = null,}) {
  return _then(_BomHeaderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,outputQty: null == outputQty ? _self.outputQty : outputQty // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<BomLineModel>,
  ));
}


}

// dart format on
