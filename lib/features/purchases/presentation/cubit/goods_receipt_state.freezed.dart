// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_receipt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoodsReceiptLineItem {

 PurchaseLineModel get line; String get qtyReceived; String get costPerUnit; String get batchNumber; DateTime? get expiryDate;/// The product tracks expiry: batch number and expiry date are required.
 bool get trackExpiry;
/// Create a copy of GoodsReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoodsReceiptLineItemCopyWith<GoodsReceiptLineItem> get copyWith => _$GoodsReceiptLineItemCopyWithImpl<GoodsReceiptLineItem>(this as GoodsReceiptLineItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoodsReceiptLineItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoodsReceiptLineItem&&(identical(other.line, _this.line) || other.line == _this.line)&&(identical(other.qtyReceived, _this.qtyReceived) || other.qtyReceived == _this.qtyReceived)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.batchNumber, _this.batchNumber) || other.batchNumber == _this.batchNumber)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.trackExpiry, _this.trackExpiry) || other.trackExpiry == _this.trackExpiry));
}


@override
int get hashCode {
  final _this = this as GoodsReceiptLineItem;
  return Object.hash(runtimeType,_this.line,_this.qtyReceived,_this.costPerUnit,_this.batchNumber,_this.expiryDate,_this.trackExpiry);
}

@override
String toString() {
  final _this = this as GoodsReceiptLineItem;
  return 'GoodsReceiptLineItem(line: ${_this.line}, qtyReceived: ${_this.qtyReceived}, costPerUnit: ${_this.costPerUnit}, batchNumber: ${_this.batchNumber}, expiryDate: ${_this.expiryDate}, trackExpiry: ${_this.trackExpiry})';
}


}

/// @nodoc
abstract mixin class $GoodsReceiptLineItemCopyWith<$Res>  {
  factory $GoodsReceiptLineItemCopyWith(GoodsReceiptLineItem value, $Res Function(GoodsReceiptLineItem) _then) = _$GoodsReceiptLineItemCopyWithImpl;
@useResult
$Res call({
 PurchaseLineModel line, String qtyReceived, String costPerUnit, String batchNumber, DateTime? expiryDate, bool trackExpiry
});


$PurchaseLineModelCopyWith<$Res> get line;

}
/// @nodoc
class _$GoodsReceiptLineItemCopyWithImpl<$Res>
    implements $GoodsReceiptLineItemCopyWith<$Res> {
  _$GoodsReceiptLineItemCopyWithImpl(this._self, this._then);

  final GoodsReceiptLineItem _self;
  final $Res Function(GoodsReceiptLineItem) _then;

/// Create a copy of GoodsReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? line = null,Object? qtyReceived = null,Object? costPerUnit = null,Object? batchNumber = null,Object? expiryDate = freezed,Object? trackExpiry = null,}) {
  return _then(GoodsReceiptLineItem(
line: null == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as PurchaseLineModel,qtyReceived: null == qtyReceived ? _self.qtyReceived : qtyReceived // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,batchNumber: null == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,trackExpiry: null == trackExpiry ? _self.trackExpiry : trackExpiry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GoodsReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseLineModelCopyWith<$Res> get line {
  
  return $PurchaseLineModelCopyWith<$Res>(_self.line, (value) {
    return _then(_self.copyWith(line: value));
  });
}
}


/// Adds pattern-matching-related methods to [GoodsReceiptLineItem].
extension GoodsReceiptLineItemPatterns on GoodsReceiptLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoodsReceiptLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoodsReceiptLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoodsReceiptLineItem value)  $default,){
final _that = this;
switch (_that) {
case _GoodsReceiptLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoodsReceiptLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _GoodsReceiptLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PurchaseLineModel line,  String qtyReceived,  String costPerUnit,  String batchNumber,  DateTime? expiryDate,  bool trackExpiry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoodsReceiptLineItem() when $default != null:
return $default(_that.line,_that.qtyReceived,_that.costPerUnit,_that.batchNumber,_that.expiryDate,_that.trackExpiry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PurchaseLineModel line,  String qtyReceived,  String costPerUnit,  String batchNumber,  DateTime? expiryDate,  bool trackExpiry)  $default,) {final _that = this;
switch (_that) {
case _GoodsReceiptLineItem():
return $default(_that.line,_that.qtyReceived,_that.costPerUnit,_that.batchNumber,_that.expiryDate,_that.trackExpiry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PurchaseLineModel line,  String qtyReceived,  String costPerUnit,  String batchNumber,  DateTime? expiryDate,  bool trackExpiry)?  $default,) {final _that = this;
switch (_that) {
case _GoodsReceiptLineItem() when $default != null:
return $default(_that.line,_that.qtyReceived,_that.costPerUnit,_that.batchNumber,_that.expiryDate,_that.trackExpiry);case _:
  return null;

}
}

}

/// @nodoc


class _GoodsReceiptLineItem extends GoodsReceiptLineItem {
  const _GoodsReceiptLineItem({required this.line, this.qtyReceived = '', this.costPerUnit = '', this.batchNumber = '', this.expiryDate, this.trackExpiry = false}): super._();
  

@override final  PurchaseLineModel line;
@override@JsonKey() final  String qtyReceived;
@override@JsonKey() final  String costPerUnit;
@override@JsonKey() final  String batchNumber;
@override final  DateTime? expiryDate;
/// The product tracks expiry: batch number and expiry date are required.
@override@JsonKey() final  bool trackExpiry;

/// Create a copy of GoodsReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoodsReceiptLineItemCopyWith<_GoodsReceiptLineItem> get copyWith => __$GoodsReceiptLineItemCopyWithImpl<_GoodsReceiptLineItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoodsReceiptLineItem&&(identical(other.line, line) || other.line == line)&&(identical(other.qtyReceived, qtyReceived) || other.qtyReceived == qtyReceived)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.trackExpiry, trackExpiry) || other.trackExpiry == trackExpiry));
}


@override
int get hashCode {
    return Object.hash(runtimeType,line,qtyReceived,costPerUnit,batchNumber,expiryDate,trackExpiry);
}

@override
String toString() {
    return 'GoodsReceiptLineItem(line: $line, qtyReceived: $qtyReceived, costPerUnit: $costPerUnit, batchNumber: $batchNumber, expiryDate: $expiryDate, trackExpiry: $trackExpiry)';
}


}

/// @nodoc
abstract mixin class _$GoodsReceiptLineItemCopyWith<$Res> implements $GoodsReceiptLineItemCopyWith<$Res> {
  factory _$GoodsReceiptLineItemCopyWith(_GoodsReceiptLineItem value, $Res Function(_GoodsReceiptLineItem) _then) = __$GoodsReceiptLineItemCopyWithImpl;
@override @useResult
$Res call({
 PurchaseLineModel line, String qtyReceived, String costPerUnit, String batchNumber, DateTime? expiryDate, bool trackExpiry
});


@override $PurchaseLineModelCopyWith<$Res> get line;

}
/// @nodoc
class __$GoodsReceiptLineItemCopyWithImpl<$Res>
    implements _$GoodsReceiptLineItemCopyWith<$Res> {
  __$GoodsReceiptLineItemCopyWithImpl(this._self, this._then);

  final _GoodsReceiptLineItem _self;
  final $Res Function(_GoodsReceiptLineItem) _then;

/// Create a copy of GoodsReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? line = null,Object? qtyReceived = null,Object? costPerUnit = null,Object? batchNumber = null,Object? expiryDate = freezed,Object? trackExpiry = null,}) {
  return _then(_GoodsReceiptLineItem(
line: null == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as PurchaseLineModel,qtyReceived: null == qtyReceived ? _self.qtyReceived : qtyReceived // ignore: cast_nullable_to_non_nullable
as String,costPerUnit: null == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as String,batchNumber: null == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,trackExpiry: null == trackExpiry ? _self.trackExpiry : trackExpiry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GoodsReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseLineModelCopyWith<$Res> get line {
  
  return $PurchaseLineModelCopyWith<$Res>(_self.line, (value) {
    return _then(_self.copyWith(line: value));
  });
}
}

/// @nodoc
mixin _$GoodsReceiptState {

 String? get branchId; PurchaseOrderModel? get order; List<GoodsReceiptLineItem> get lines; DateTime? get receivedAt; String get supplierInvoiceNo; String get notes; bool get isLoading; bool get isSubmitting; Map<String, String> get errors;
/// Create a copy of GoodsReceiptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoodsReceiptStateCopyWith<GoodsReceiptState> get copyWith => _$GoodsReceiptStateCopyWithImpl<GoodsReceiptState>(this as GoodsReceiptState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoodsReceiptState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoodsReceiptState&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.order, _this.order) || other.order == _this.order)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt)&&(identical(other.supplierInvoiceNo, _this.supplierInvoiceNo) || other.supplierInvoiceNo == _this.supplierInvoiceNo)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as GoodsReceiptState;
  return Object.hash(runtimeType,_this.branchId,_this.order,const DeepCollectionEquality().hash(_this.lines),_this.receivedAt,_this.supplierInvoiceNo,_this.notes,_this.isLoading,_this.isSubmitting,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as GoodsReceiptState;
  return 'GoodsReceiptState(branchId: ${_this.branchId}, order: ${_this.order}, lines: ${_this.lines}, receivedAt: ${_this.receivedAt}, supplierInvoiceNo: ${_this.supplierInvoiceNo}, notes: ${_this.notes}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $GoodsReceiptStateCopyWith<$Res>  {
  factory $GoodsReceiptStateCopyWith(GoodsReceiptState value, $Res Function(GoodsReceiptState) _then) = _$GoodsReceiptStateCopyWithImpl;
@useResult
$Res call({
 String? branchId, PurchaseOrderModel? order, List<GoodsReceiptLineItem> lines, DateTime? receivedAt, String supplierInvoiceNo, String notes, bool isLoading, bool isSubmitting, Map<String, String> errors
});


$PurchaseOrderModelCopyWith<$Res>? get order;

}
/// @nodoc
class _$GoodsReceiptStateCopyWithImpl<$Res>
    implements $GoodsReceiptStateCopyWith<$Res> {
  _$GoodsReceiptStateCopyWithImpl(this._self, this._then);

  final GoodsReceiptState _self;
  final $Res Function(GoodsReceiptState) _then;

/// Create a copy of GoodsReceiptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = freezed,Object? order = freezed,Object? lines = null,Object? receivedAt = freezed,Object? supplierInvoiceNo = null,Object? notes = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,}) {
  return _then(GoodsReceiptState(
branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PurchaseOrderModel?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<GoodsReceiptLineItem>,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,supplierInvoiceNo: null == supplierInvoiceNo ? _self.supplierInvoiceNo : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of GoodsReceiptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOrderModelCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $PurchaseOrderModelCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [GoodsReceiptState].
extension GoodsReceiptStatePatterns on GoodsReceiptState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoodsReceiptState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoodsReceiptState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoodsReceiptState value)  $default,){
final _that = this;
switch (_that) {
case _GoodsReceiptState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoodsReceiptState value)?  $default,){
final _that = this;
switch (_that) {
case _GoodsReceiptState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? branchId,  PurchaseOrderModel? order,  List<GoodsReceiptLineItem> lines,  DateTime? receivedAt,  String supplierInvoiceNo,  String notes,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoodsReceiptState() when $default != null:
return $default(_that.branchId,_that.order,_that.lines,_that.receivedAt,_that.supplierInvoiceNo,_that.notes,_that.isLoading,_that.isSubmitting,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? branchId,  PurchaseOrderModel? order,  List<GoodsReceiptLineItem> lines,  DateTime? receivedAt,  String supplierInvoiceNo,  String notes,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _GoodsReceiptState():
return $default(_that.branchId,_that.order,_that.lines,_that.receivedAt,_that.supplierInvoiceNo,_that.notes,_that.isLoading,_that.isSubmitting,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? branchId,  PurchaseOrderModel? order,  List<GoodsReceiptLineItem> lines,  DateTime? receivedAt,  String supplierInvoiceNo,  String notes,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _GoodsReceiptState() when $default != null:
return $default(_that.branchId,_that.order,_that.lines,_that.receivedAt,_that.supplierInvoiceNo,_that.notes,_that.isLoading,_that.isSubmitting,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _GoodsReceiptState implements GoodsReceiptState {
  const _GoodsReceiptState({this.branchId, this.order,  List<GoodsReceiptLineItem> lines = const [], this.receivedAt, this.supplierInvoiceNo = '', this.notes = '', this.isLoading = false, this.isSubmitting = false,  Map<String, String> errors = const {}}): _lines = lines,_errors = errors;
  

@override final  String? branchId;
@override final  PurchaseOrderModel? order;
 final  List<GoodsReceiptLineItem> _lines;
@override@JsonKey() List<GoodsReceiptLineItem> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  DateTime? receivedAt;
@override@JsonKey() final  String supplierInvoiceNo;
@override@JsonKey() final  String notes;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of GoodsReceiptState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoodsReceiptStateCopyWith<_GoodsReceiptState> get copyWith => __$GoodsReceiptStateCopyWithImpl<_GoodsReceiptState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoodsReceiptState&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.supplierInvoiceNo, supplierInvoiceNo) || other.supplierInvoiceNo == supplierInvoiceNo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,branchId,order,const DeepCollectionEquality().hash(_lines),receivedAt,supplierInvoiceNo,notes,isLoading,isSubmitting,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'GoodsReceiptState(branchId: $branchId, order: $order, lines: $lines, receivedAt: $receivedAt, supplierInvoiceNo: $supplierInvoiceNo, notes: $notes, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$GoodsReceiptStateCopyWith<$Res> implements $GoodsReceiptStateCopyWith<$Res> {
  factory _$GoodsReceiptStateCopyWith(_GoodsReceiptState value, $Res Function(_GoodsReceiptState) _then) = __$GoodsReceiptStateCopyWithImpl;
@override @useResult
$Res call({
 String? branchId, PurchaseOrderModel? order, List<GoodsReceiptLineItem> lines, DateTime? receivedAt, String supplierInvoiceNo, String notes, bool isLoading, bool isSubmitting, Map<String, String> errors
});


@override $PurchaseOrderModelCopyWith<$Res>? get order;

}
/// @nodoc
class __$GoodsReceiptStateCopyWithImpl<$Res>
    implements _$GoodsReceiptStateCopyWith<$Res> {
  __$GoodsReceiptStateCopyWithImpl(this._self, this._then);

  final _GoodsReceiptState _self;
  final $Res Function(_GoodsReceiptState) _then;

/// Create a copy of GoodsReceiptState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = freezed,Object? order = freezed,Object? lines = null,Object? receivedAt = freezed,Object? supplierInvoiceNo = null,Object? notes = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,}) {
  return _then(_GoodsReceiptState(
branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PurchaseOrderModel?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<GoodsReceiptLineItem>,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,supplierInvoiceNo: null == supplierInvoiceNo ? _self.supplierInvoiceNo : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of GoodsReceiptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOrderModelCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $PurchaseOrderModelCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
