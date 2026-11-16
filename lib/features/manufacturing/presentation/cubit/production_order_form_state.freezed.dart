// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_order_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductionOrderFormState {

 String? get branchId; String? get bomHeaderId; String get qtyToProduce; String get notes; List<BomHeaderModel> get activeBoms; bool get isPreviewLoading; BomPreviewModel? get preview; List<IngredientAvailabilityRow> get availability; bool get hasShortfall; bool get allowNegativeStock; bool get isLoading; bool get isSubmitting; Map<String, String> get errors;
/// Create a copy of ProductionOrderFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionOrderFormStateCopyWith<ProductionOrderFormState> get copyWith => _$ProductionOrderFormStateCopyWithImpl<ProductionOrderFormState>(this as ProductionOrderFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductionOrderFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrderFormState&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.bomHeaderId, _this.bomHeaderId) || other.bomHeaderId == _this.bomHeaderId)&&(identical(other.qtyToProduce, _this.qtyToProduce) || other.qtyToProduce == _this.qtyToProduce)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.activeBoms, _this.activeBoms)&&(identical(other.isPreviewLoading, _this.isPreviewLoading) || other.isPreviewLoading == _this.isPreviewLoading)&&(identical(other.preview, _this.preview) || other.preview == _this.preview)&&const DeepCollectionEquality().equals(other.availability, _this.availability)&&(identical(other.hasShortfall, _this.hasShortfall) || other.hasShortfall == _this.hasShortfall)&&(identical(other.allowNegativeStock, _this.allowNegativeStock) || other.allowNegativeStock == _this.allowNegativeStock)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as ProductionOrderFormState;
  return Object.hash(runtimeType,_this.branchId,_this.bomHeaderId,_this.qtyToProduce,_this.notes,const DeepCollectionEquality().hash(_this.activeBoms),_this.isPreviewLoading,_this.preview,const DeepCollectionEquality().hash(_this.availability),_this.hasShortfall,_this.allowNegativeStock,_this.isLoading,_this.isSubmitting,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as ProductionOrderFormState;
  return 'ProductionOrderFormState(branchId: ${_this.branchId}, bomHeaderId: ${_this.bomHeaderId}, qtyToProduce: ${_this.qtyToProduce}, notes: ${_this.notes}, activeBoms: ${_this.activeBoms}, isPreviewLoading: ${_this.isPreviewLoading}, preview: ${_this.preview}, availability: ${_this.availability}, hasShortfall: ${_this.hasShortfall}, allowNegativeStock: ${_this.allowNegativeStock}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ProductionOrderFormStateCopyWith<$Res>  {
  factory $ProductionOrderFormStateCopyWith(ProductionOrderFormState value, $Res Function(ProductionOrderFormState) _then) = _$ProductionOrderFormStateCopyWithImpl;
@useResult
$Res call({
 String? branchId, String? bomHeaderId, String qtyToProduce, String notes, List<BomHeaderModel> activeBoms, bool isPreviewLoading, BomPreviewModel? preview, List<IngredientAvailabilityRow> availability, bool hasShortfall, bool allowNegativeStock, bool isLoading, bool isSubmitting, Map<String, String> errors
});


$BomPreviewModelCopyWith<$Res>? get preview;

}
/// @nodoc
class _$ProductionOrderFormStateCopyWithImpl<$Res>
    implements $ProductionOrderFormStateCopyWith<$Res> {
  _$ProductionOrderFormStateCopyWithImpl(this._self, this._then);

  final ProductionOrderFormState _self;
  final $Res Function(ProductionOrderFormState) _then;

/// Create a copy of ProductionOrderFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = freezed,Object? bomHeaderId = freezed,Object? qtyToProduce = null,Object? notes = null,Object? activeBoms = null,Object? isPreviewLoading = null,Object? preview = freezed,Object? availability = null,Object? hasShortfall = null,Object? allowNegativeStock = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,}) {
  return _then(ProductionOrderFormState(
branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,bomHeaderId: freezed == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String?,qtyToProduce: null == qtyToProduce ? _self.qtyToProduce : qtyToProduce // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,activeBoms: null == activeBoms ? _self.activeBoms : activeBoms // ignore: cast_nullable_to_non_nullable
as List<BomHeaderModel>,isPreviewLoading: null == isPreviewLoading ? _self.isPreviewLoading : isPreviewLoading // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as BomPreviewModel?,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as List<IngredientAvailabilityRow>,hasShortfall: null == hasShortfall ? _self.hasShortfall : hasShortfall // ignore: cast_nullable_to_non_nullable
as bool,allowNegativeStock: null == allowNegativeStock ? _self.allowNegativeStock : allowNegativeStock // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of ProductionOrderFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BomPreviewModelCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $BomPreviewModelCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductionOrderFormState].
extension ProductionOrderFormStatePatterns on ProductionOrderFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionOrderFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionOrderFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionOrderFormState value)  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionOrderFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? branchId,  String? bomHeaderId,  String qtyToProduce,  String notes,  List<BomHeaderModel> activeBoms,  bool isPreviewLoading,  BomPreviewModel? preview,  List<IngredientAvailabilityRow> availability,  bool hasShortfall,  bool allowNegativeStock,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionOrderFormState() when $default != null:
return $default(_that.branchId,_that.bomHeaderId,_that.qtyToProduce,_that.notes,_that.activeBoms,_that.isPreviewLoading,_that.preview,_that.availability,_that.hasShortfall,_that.allowNegativeStock,_that.isLoading,_that.isSubmitting,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? branchId,  String? bomHeaderId,  String qtyToProduce,  String notes,  List<BomHeaderModel> activeBoms,  bool isPreviewLoading,  BomPreviewModel? preview,  List<IngredientAvailabilityRow> availability,  bool hasShortfall,  bool allowNegativeStock,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderFormState():
return $default(_that.branchId,_that.bomHeaderId,_that.qtyToProduce,_that.notes,_that.activeBoms,_that.isPreviewLoading,_that.preview,_that.availability,_that.hasShortfall,_that.allowNegativeStock,_that.isLoading,_that.isSubmitting,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? branchId,  String? bomHeaderId,  String qtyToProduce,  String notes,  List<BomHeaderModel> activeBoms,  bool isPreviewLoading,  BomPreviewModel? preview,  List<IngredientAvailabilityRow> availability,  bool hasShortfall,  bool allowNegativeStock,  bool isLoading,  bool isSubmitting,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderFormState() when $default != null:
return $default(_that.branchId,_that.bomHeaderId,_that.qtyToProduce,_that.notes,_that.activeBoms,_that.isPreviewLoading,_that.preview,_that.availability,_that.hasShortfall,_that.allowNegativeStock,_that.isLoading,_that.isSubmitting,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ProductionOrderFormState implements ProductionOrderFormState {
  const _ProductionOrderFormState({this.branchId, this.bomHeaderId, this.qtyToProduce = '', this.notes = '',  List<BomHeaderModel> activeBoms = const [], this.isPreviewLoading = false, this.preview,  List<IngredientAvailabilityRow> availability = const [], this.hasShortfall = false, this.allowNegativeStock = false, this.isLoading = false, this.isSubmitting = false,  Map<String, String> errors = const {}}): _activeBoms = activeBoms,_availability = availability,_errors = errors;
  

@override final  String? branchId;
@override final  String? bomHeaderId;
@override@JsonKey() final  String qtyToProduce;
@override@JsonKey() final  String notes;
 final  List<BomHeaderModel> _activeBoms;
@override@JsonKey() List<BomHeaderModel> get activeBoms {
  if (_activeBoms is EqualUnmodifiableListView) return _activeBoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeBoms);
}

@override@JsonKey() final  bool isPreviewLoading;
@override final  BomPreviewModel? preview;
 final  List<IngredientAvailabilityRow> _availability;
@override@JsonKey() List<IngredientAvailabilityRow> get availability {
  if (_availability is EqualUnmodifiableListView) return _availability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availability);
}

@override@JsonKey() final  bool hasShortfall;
@override@JsonKey() final  bool allowNegativeStock;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of ProductionOrderFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionOrderFormStateCopyWith<_ProductionOrderFormState> get copyWith => __$ProductionOrderFormStateCopyWithImpl<_ProductionOrderFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionOrderFormState&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.bomHeaderId, bomHeaderId) || other.bomHeaderId == bomHeaderId)&&(identical(other.qtyToProduce, qtyToProduce) || other.qtyToProduce == qtyToProduce)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.activeBoms, _activeBoms)&&(identical(other.isPreviewLoading, isPreviewLoading) || other.isPreviewLoading == isPreviewLoading)&&(identical(other.preview, preview) || other.preview == preview)&&const DeepCollectionEquality().equals(other.availability, _availability)&&(identical(other.hasShortfall, hasShortfall) || other.hasShortfall == hasShortfall)&&(identical(other.allowNegativeStock, allowNegativeStock) || other.allowNegativeStock == allowNegativeStock)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,branchId,bomHeaderId,qtyToProduce,notes,const DeepCollectionEquality().hash(_activeBoms),isPreviewLoading,preview,const DeepCollectionEquality().hash(_availability),hasShortfall,allowNegativeStock,isLoading,isSubmitting,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'ProductionOrderFormState(branchId: $branchId, bomHeaderId: $bomHeaderId, qtyToProduce: $qtyToProduce, notes: $notes, activeBoms: $activeBoms, isPreviewLoading: $isPreviewLoading, preview: $preview, availability: $availability, hasShortfall: $hasShortfall, allowNegativeStock: $allowNegativeStock, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ProductionOrderFormStateCopyWith<$Res> implements $ProductionOrderFormStateCopyWith<$Res> {
  factory _$ProductionOrderFormStateCopyWith(_ProductionOrderFormState value, $Res Function(_ProductionOrderFormState) _then) = __$ProductionOrderFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? branchId, String? bomHeaderId, String qtyToProduce, String notes, List<BomHeaderModel> activeBoms, bool isPreviewLoading, BomPreviewModel? preview, List<IngredientAvailabilityRow> availability, bool hasShortfall, bool allowNegativeStock, bool isLoading, bool isSubmitting, Map<String, String> errors
});


@override $BomPreviewModelCopyWith<$Res>? get preview;

}
/// @nodoc
class __$ProductionOrderFormStateCopyWithImpl<$Res>
    implements _$ProductionOrderFormStateCopyWith<$Res> {
  __$ProductionOrderFormStateCopyWithImpl(this._self, this._then);

  final _ProductionOrderFormState _self;
  final $Res Function(_ProductionOrderFormState) _then;

/// Create a copy of ProductionOrderFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = freezed,Object? bomHeaderId = freezed,Object? qtyToProduce = null,Object? notes = null,Object? activeBoms = null,Object? isPreviewLoading = null,Object? preview = freezed,Object? availability = null,Object? hasShortfall = null,Object? allowNegativeStock = null,Object? isLoading = null,Object? isSubmitting = null,Object? errors = null,}) {
  return _then(_ProductionOrderFormState(
branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,bomHeaderId: freezed == bomHeaderId ? _self.bomHeaderId : bomHeaderId // ignore: cast_nullable_to_non_nullable
as String?,qtyToProduce: null == qtyToProduce ? _self.qtyToProduce : qtyToProduce // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,activeBoms: null == activeBoms ? _self._activeBoms : activeBoms // ignore: cast_nullable_to_non_nullable
as List<BomHeaderModel>,isPreviewLoading: null == isPreviewLoading ? _self.isPreviewLoading : isPreviewLoading // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as BomPreviewModel?,availability: null == availability ? _self._availability : availability // ignore: cast_nullable_to_non_nullable
as List<IngredientAvailabilityRow>,hasShortfall: null == hasShortfall ? _self.hasShortfall : hasShortfall // ignore: cast_nullable_to_non_nullable
as bool,allowNegativeStock: null == allowNegativeStock ? _self.allowNegativeStock : allowNegativeStock // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of ProductionOrderFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BomPreviewModelCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $BomPreviewModelCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

// dart format on
