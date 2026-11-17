// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchaseLineFormItem {

 String? get productId; String? get productName; String? get variationId; String? get variationName; String get orderedQty; String get costPerUnit; String get taxRate; List<VariationModel> get variations;
/// Create a copy of PurchaseLineFormItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseLineFormItemCopyWith<PurchaseLineFormItem> get copyWith => _$PurchaseLineFormItemCopyWithImpl<PurchaseLineFormItem>(this as PurchaseLineFormItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchaseLineFormItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseLineFormItem&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.variationId, _this.variationId) || other.variationId == _this.variationId)&&(identical(other.variationName, _this.variationName) || other.variationName == _this.variationName)&&(identical(other.orderedQty, _this.orderedQty) || other.orderedQty == _this.orderedQty)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&const DeepCollectionEquality().equals(other.variations, _this.variations));
}


@override
int get hashCode {
  final _this = this as PurchaseLineFormItem;
  return Object.hash(runtimeType,_this.productId,_this.productName,_this.variationId,_this.variationName,_this.orderedQty,_this.costPerUnit,_this.taxRate,const DeepCollectionEquality().hash(_this.variations));
}

@override
String toString() {
  final _this = this as PurchaseLineFormItem;
  return 'PurchaseLineFormItem(productId: ${_this.productId}, productName: ${_this.productName}, variationId: ${_this.variationId}, variationName: ${_this.variationName}, orderedQty: ${_this.orderedQty}, costPerUnit: ${_this.costPerUnit}, taxRate: ${_this.taxRate}, variations: ${_this.variations})';
}


}

/// @nodoc
abstract mixin class $PurchaseLineFormItemCopyWith<$Res>  {
  factory $PurchaseLineFormItemCopyWith(PurchaseLineFormItem value, $Res Function(PurchaseLineFormItem) _then) = _$PurchaseLineFormItemCopyWithImpl;
@useResult
$Res call({
 String? productId, String? productName, String? variationId, String? variationName, String orderedQty, String costPerUnit, String taxRate, List<VariationModel> variations
});




}
/// @nodoc
class _$PurchaseLineFormItemCopyWithImpl<$Res>
    implements $PurchaseLineFormItemCopyWith<$Res> {
  _$PurchaseLineFormItemCopyWithImpl(this._self, this._then);

  final PurchaseLineFormItem _self;
  final $Res Function(PurchaseLineFormItem) _then;

/// Create a copy of PurchaseLineFormItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = freezed,Object? productName = freezed,Object? variationId = freezed,Object? variationName = freezed,Object? orderedQty = null,Object? costPerUnit = null,Object? taxRate = null,Object? variations = null,}) {
  return _then(PurchaseLineFormItem(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,orderedQty: null == orderedQty ? _self.orderedQty : orderedQty // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,variations: null == variations ? _self.variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseLineFormItem].
extension PurchaseLineFormItemPatterns on PurchaseLineFormItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseLineFormItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseLineFormItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseLineFormItem value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseLineFormItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseLineFormItem value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseLineFormItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? productId,  String? productName,  String? variationId,  String? variationName,  String orderedQty,  String costPerUnit,  String taxRate,  List<VariationModel> variations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseLineFormItem() when $default != null:
return $default(_that.productId,_that.productName,_that.variationId,_that.variationName,_that.orderedQty,_that.costPerUnit,_that.taxRate,_that.variations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? productId,  String? productName,  String? variationId,  String? variationName,  String orderedQty,  String costPerUnit,  String taxRate,  List<VariationModel> variations)  $default,) {final _that = this;
switch (_that) {
case _PurchaseLineFormItem():
return $default(_that.productId,_that.productName,_that.variationId,_that.variationName,_that.orderedQty,_that.costPerUnit,_that.taxRate,_that.variations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? productId,  String? productName,  String? variationId,  String? variationName,  String orderedQty,  String costPerUnit,  String taxRate,  List<VariationModel> variations)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseLineFormItem() when $default != null:
return $default(_that.productId,_that.productName,_that.variationId,_that.variationName,_that.orderedQty,_that.costPerUnit,_that.taxRate,_that.variations);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseLineFormItem extends PurchaseLineFormItem {
  const _PurchaseLineFormItem({this.productId, this.productName, this.variationId, this.variationName, this.orderedQty = '', this.costPerUnit = '', this.taxRate = '0',  List<VariationModel> variations = const []}): _variations = variations,super._();
  

@override final  String? productId;
@override final  String? productName;
@override final  String? variationId;
@override final  String? variationName;
@override@JsonKey() final  String orderedQty;
@override@JsonKey() final  String costPerUnit;
@override@JsonKey() final  String taxRate;
 final  List<VariationModel> _variations;
@override@JsonKey() List<VariationModel> get variations {
  if (_variations is EqualUnmodifiableListView) return _variations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variations);
}


/// Create a copy of PurchaseLineFormItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseLineFormItemCopyWith<_PurchaseLineFormItem> get copyWith => __$PurchaseLineFormItemCopyWithImpl<_PurchaseLineFormItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseLineFormItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variationId, variationId) || other.variationId == variationId)&&(identical(other.variationName, variationName) || other.variationName == variationName)&&(identical(other.orderedQty, orderedQty) || other.orderedQty == orderedQty)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&const DeepCollectionEquality().equals(other.variations, _variations));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,productName,variationId,variationName,orderedQty,costPerUnit,taxRate,const DeepCollectionEquality().hash(_variations));
}

@override
String toString() {
    return 'PurchaseLineFormItem(productId: $productId, productName: $productName, variationId: $variationId, variationName: $variationName, orderedQty: $orderedQty, costPerUnit: $costPerUnit, taxRate: $taxRate, variations: $variations)';
}


}

/// @nodoc
abstract mixin class _$PurchaseLineFormItemCopyWith<$Res> implements $PurchaseLineFormItemCopyWith<$Res> {
  factory _$PurchaseLineFormItemCopyWith(_PurchaseLineFormItem value, $Res Function(_PurchaseLineFormItem) _then) = __$PurchaseLineFormItemCopyWithImpl;
@override @useResult
$Res call({
 String? productId, String? productName, String? variationId, String? variationName, String orderedQty, String costPerUnit, String taxRate, List<VariationModel> variations
});




}
/// @nodoc
class __$PurchaseLineFormItemCopyWithImpl<$Res>
    implements _$PurchaseLineFormItemCopyWith<$Res> {
  __$PurchaseLineFormItemCopyWithImpl(this._self, this._then);

  final _PurchaseLineFormItem _self;
  final $Res Function(_PurchaseLineFormItem) _then;

/// Create a copy of PurchaseLineFormItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = freezed,Object? productName = freezed,Object? variationId = freezed,Object? variationName = freezed,Object? orderedQty = null,Object? costPerUnit = null,Object? taxRate = null,Object? variations = null,}) {
  return _then(_PurchaseLineFormItem(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,variationId: freezed == variationId ? _self.variationId : variationId // ignore: cast_nullable_to_non_nullable
as String?,variationName: freezed == variationName ? _self.variationName : variationName // ignore: cast_nullable_to_non_nullable
as String?,orderedQty: null == orderedQty ? _self.orderedQty : orderedQty // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,variations: null == variations ? _self._variations : variations // ignore: cast_nullable_to_non_nullable
as List<VariationModel>,
  ));
}


}

/// @nodoc
mixin _$PurchaseOrderFormState {

 String? get branchId; String? get supplierId; DateTime? get expectedAt; String get notes; List<PurchaseLineFormItem> get lines; List<SupplierModel> get suppliers; List<ProductListItemModel> get products; bool get isLoading; bool get isSubmitting; Map<String, String> get errors;/// Set once the order exists on the server (a retry must not create it again).
 String? get createdOrderId;
/// Create a copy of PurchaseOrderFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderFormStateCopyWith<PurchaseOrderFormState> get copyWith => _$PurchaseOrderFormStateCopyWithImpl<PurchaseOrderFormState>(this as PurchaseOrderFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchaseOrderFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderFormState&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.expectedAt, _this.expectedAt) || other.expectedAt == _this.expectedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.suppliers, _this.suppliers)&&const DeepCollectionEquality().equals(other.products, _this.products)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&(identical(other.createdOrderId, _this.createdOrderId) || other.createdOrderId == _this.createdOrderId));
}


@override
int get hashCode {
  final _this = this as PurchaseOrderFormState;
  return Object.hash(runtimeType,_this.branchId,_this.supplierId,_this.expectedAt,_this.notes,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.suppliers),const DeepCollectionEquality().hash(_this.products),_this.isLoading,_this.isSubmitting,const DeepCollectionEquality().hash(_this.errors),_this.createdOrderId);
}

@override
String toString() {
  final _this = this as PurchaseOrderFormState;
  return 'PurchaseOrderFormState(branchId: ${_this.branchId}, supplierId: ${_this.supplierId}, expectedAt: ${_this.expectedAt}, notes: ${_this.notes}, lines: ${_this.lines}, suppliers: ${_this.suppliers}, products: ${_this.products}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, errors: ${_this.errors}, createdOrderId: ${_this.createdOrderId})';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderFormStateCopyWith<$Res>  {
  factory $PurchaseOrderFormStateCopyWith(PurchaseOrderFormState value, $Res Function(PurchaseOrderFormState) _then) = _$PurchaseOrderFormStateCopyWithImpl;
@useResult
$Res call({
 String? branchId, String? supplierId, DateTime? expectedAt, String notes, List<PurchaseLineFormItem> lines, List<SupplierModel> suppliers, List<ProductListItemModel> products, bool isLoading, bool isSubmitting, Map<String, String> errors, String? createdOrderId
});




}
/// @nodoc
class _$PurchaseOrderFormStateCopyWithImpl<$Res>
    implements $PurchaseOrderFormStateCopyWith<$Res> {
  _$PurchaseOrderFormStateCopyWithImpl(this._self, this._then);

  final PurchaseOrderFormState _self;
  final $Res Function(PurchaseOrderFormState) _then;

/// Create a copy of PurchaseOrderFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = freezed,Object? supplierId = freezed,Object? expectedAt = freezed,Object? notes = null,Object? lines = null,Object? suppliers = null,Object? products = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,Object? createdOrderId = freezed,}) {
  return _then(PurchaseOrderFormState(
branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,expectedAt: freezed == expectedAt ? _self.expectedAt : expectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<PurchaseLineFormItem>,suppliers: null == suppliers ? _self.suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,createdOrderId: freezed == createdOrderId ? _self.createdOrderId : createdOrderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrderFormState].
extension PurchaseOrderFormStatePatterns on PurchaseOrderFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderFormState value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderFormState value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? branchId,  String? supplierId,  DateTime? expectedAt,  String notes,  List<PurchaseLineFormItem> lines,  List<SupplierModel> suppliers,  List<ProductListItemModel> products,  bool isLoading,  bool isSubmitting,  Map<String, String> errors,  String? createdOrderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderFormState() when $default != null:
return $default(_that.branchId,_that.supplierId,_that.expectedAt,_that.notes,_that.lines,_that.suppliers,_that.products,_that.isLoading,_that.isSubmitting,_that.errors,_that.createdOrderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? branchId,  String? supplierId,  DateTime? expectedAt,  String notes,  List<PurchaseLineFormItem> lines,  List<SupplierModel> suppliers,  List<ProductListItemModel> products,  bool isLoading,  bool isSubmitting,  Map<String, String> errors,  String? createdOrderId)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderFormState():
return $default(_that.branchId,_that.supplierId,_that.expectedAt,_that.notes,_that.lines,_that.suppliers,_that.products,_that.isLoading,_that.isSubmitting,_that.errors,_that.createdOrderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? branchId,  String? supplierId,  DateTime? expectedAt,  String notes,  List<PurchaseLineFormItem> lines,  List<SupplierModel> suppliers,  List<ProductListItemModel> products,  bool isLoading,  bool isSubmitting,  Map<String, String> errors,  String? createdOrderId)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderFormState() when $default != null:
return $default(_that.branchId,_that.supplierId,_that.expectedAt,_that.notes,_that.lines,_that.suppliers,_that.products,_that.isLoading,_that.isSubmitting,_that.errors,_that.createdOrderId);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseOrderFormState extends PurchaseOrderFormState {
  const _PurchaseOrderFormState({this.branchId, this.supplierId, this.expectedAt, this.notes = '',  List<PurchaseLineFormItem> lines = const [],  List<SupplierModel> suppliers = const [],  List<ProductListItemModel> products = const [], this.isLoading = false, this.isSubmitting = false,  Map<String, String> errors = const {}, this.createdOrderId}): _lines = lines,_suppliers = suppliers,_products = products,_errors = errors,super._();
  

@override final  String? branchId;
@override final  String? supplierId;
@override final  DateTime? expectedAt;
@override@JsonKey() final  String notes;
 final  List<PurchaseLineFormItem> _lines;
@override@JsonKey() List<PurchaseLineFormItem> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<SupplierModel> _suppliers;
@override@JsonKey() List<SupplierModel> get suppliers {
  if (_suppliers is EqualUnmodifiableListView) return _suppliers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suppliers);
}

 final  List<ProductListItemModel> _products;
@override@JsonKey() List<ProductListItemModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// Set once the order exists on the server (a retry must not create it again).
@override final  String? createdOrderId;

/// Create a copy of PurchaseOrderFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderFormStateCopyWith<_PurchaseOrderFormState> get copyWith => __$PurchaseOrderFormStateCopyWithImpl<_PurchaseOrderFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderFormState&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.expectedAt, expectedAt) || other.expectedAt == expectedAt)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.suppliers, _suppliers)&&const DeepCollectionEquality().equals(other.products, _products)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _errors)&&(identical(other.createdOrderId, createdOrderId) || other.createdOrderId == createdOrderId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,branchId,supplierId,expectedAt,notes,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_suppliers),const DeepCollectionEquality().hash(_products),isLoading,isSubmitting,const DeepCollectionEquality().hash(_errors),createdOrderId);
}

@override
String toString() {
    return 'PurchaseOrderFormState(branchId: $branchId, supplierId: $supplierId, expectedAt: $expectedAt, notes: $notes, lines: $lines, suppliers: $suppliers, products: $products, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors, createdOrderId: $createdOrderId)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderFormStateCopyWith<$Res> implements $PurchaseOrderFormStateCopyWith<$Res> {
  factory _$PurchaseOrderFormStateCopyWith(_PurchaseOrderFormState value, $Res Function(_PurchaseOrderFormState) _then) = __$PurchaseOrderFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? branchId, String? supplierId, DateTime? expectedAt, String notes, List<PurchaseLineFormItem> lines, List<SupplierModel> suppliers, List<ProductListItemModel> products, bool isLoading, bool isSubmitting, Map<String, String> errors, String? createdOrderId
});




}
/// @nodoc
class __$PurchaseOrderFormStateCopyWithImpl<$Res>
    implements _$PurchaseOrderFormStateCopyWith<$Res> {
  __$PurchaseOrderFormStateCopyWithImpl(this._self, this._then);

  final _PurchaseOrderFormState _self;
  final $Res Function(_PurchaseOrderFormState) _then;

/// Create a copy of PurchaseOrderFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = freezed,Object? supplierId = freezed,Object? expectedAt = freezed,Object? notes = null,Object? lines = null,Object? suppliers = null,Object? products = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,Object? createdOrderId = freezed,}) {
  return _then(_PurchaseOrderFormState(
branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,expectedAt: freezed == expectedAt ? _self.expectedAt : expectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<PurchaseLineFormItem>,suppliers: null == suppliers ? _self._suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductListItemModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,createdOrderId: freezed == createdOrderId ? _self.createdOrderId : createdOrderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
