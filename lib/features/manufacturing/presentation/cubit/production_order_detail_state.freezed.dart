// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_order_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductionOrderDetailState {

 ProductionOrderModel? get order; bool get isLoading; bool get isUpdating; bool get isEditingDraft; String? get draftBomHeaderId; String get draftQtyToProduce; String get draftNotes; List<BomHeaderModel> get activeBoms; bool get isPreviewLoading; BomPreviewModel? get completionPreview; List<IngredientAvailabilityRow> get completionAvailability; bool get allowNegativeStock; bool get canCreate; bool get canComplete; bool get canCancel; Map<String, String> get errors; String? get loadError;
/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionOrderDetailStateCopyWith<ProductionOrderDetailState> get copyWith => _$ProductionOrderDetailStateCopyWithImpl<ProductionOrderDetailState>(this as ProductionOrderDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductionOrderDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionOrderDetailState&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isUpdating, _this.isUpdating) || other.isUpdating == _this.isUpdating)&&(identical(other.isEditingDraft, _this.isEditingDraft) || other.isEditingDraft == _this.isEditingDraft)&&(identical(other.draftBomHeaderId, _this.draftBomHeaderId) || other.draftBomHeaderId == _this.draftBomHeaderId)&&(identical(other.draftQtyToProduce, _this.draftQtyToProduce) || other.draftQtyToProduce == _this.draftQtyToProduce)&&(identical(other.draftNotes, _this.draftNotes) || other.draftNotes == _this.draftNotes)&&const DeepCollectionEquality().equals(other.activeBoms, _this.activeBoms)&&(identical(other.isPreviewLoading, _this.isPreviewLoading) || other.isPreviewLoading == _this.isPreviewLoading)&&(identical(other.completionPreview, _this.completionPreview) || other.completionPreview == _this.completionPreview)&&const DeepCollectionEquality().equals(other.completionAvailability, _this.completionAvailability)&&(identical(other.allowNegativeStock, _this.allowNegativeStock) || other.allowNegativeStock == _this.allowNegativeStock)&&(identical(other.canCreate, _this.canCreate) || other.canCreate == _this.canCreate)&&(identical(other.canComplete, _this.canComplete) || other.canComplete == _this.canComplete)&&(identical(other.canCancel, _this.canCancel) || other.canCancel == _this.canCancel)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&(identical(other.loadError, _this.loadError) || other.loadError == _this.loadError));
}


@override
int get hashCode {
  final _this = this as ProductionOrderDetailState;
  return Object.hash(runtimeType,_this.order,_this.isLoading,_this.isUpdating,_this.isEditingDraft,_this.draftBomHeaderId,_this.draftQtyToProduce,_this.draftNotes,const DeepCollectionEquality().hash(_this.activeBoms),_this.isPreviewLoading,_this.completionPreview,const DeepCollectionEquality().hash(_this.completionAvailability),_this.allowNegativeStock,_this.canCreate,_this.canComplete,_this.canCancel,const DeepCollectionEquality().hash(_this.errors),_this.loadError);
}

@override
String toString() {
  final _this = this as ProductionOrderDetailState;
  return 'ProductionOrderDetailState(order: ${_this.order}, isLoading: ${_this.isLoading}, isUpdating: ${_this.isUpdating}, isEditingDraft: ${_this.isEditingDraft}, draftBomHeaderId: ${_this.draftBomHeaderId}, draftQtyToProduce: ${_this.draftQtyToProduce}, draftNotes: ${_this.draftNotes}, activeBoms: ${_this.activeBoms}, isPreviewLoading: ${_this.isPreviewLoading}, completionPreview: ${_this.completionPreview}, completionAvailability: ${_this.completionAvailability}, allowNegativeStock: ${_this.allowNegativeStock}, canCreate: ${_this.canCreate}, canComplete: ${_this.canComplete}, canCancel: ${_this.canCancel}, errors: ${_this.errors}, loadError: ${_this.loadError})';
}


}

/// @nodoc
abstract mixin class $ProductionOrderDetailStateCopyWith<$Res>  {
  factory $ProductionOrderDetailStateCopyWith(ProductionOrderDetailState value, $Res Function(ProductionOrderDetailState) _then) = _$ProductionOrderDetailStateCopyWithImpl;
@useResult
$Res call({
 ProductionOrderModel? order, bool isLoading, bool isUpdating, bool isEditingDraft, String? draftBomHeaderId, String draftQtyToProduce, String draftNotes, List<BomHeaderModel> activeBoms, bool isPreviewLoading, BomPreviewModel? completionPreview, List<IngredientAvailabilityRow> completionAvailability, bool allowNegativeStock, bool canCreate, bool canComplete, bool canCancel, Map<String, String> errors, String? loadError
});


$ProductionOrderModelCopyWith<$Res>? get order;$BomPreviewModelCopyWith<$Res>? get completionPreview;

}
/// @nodoc
class _$ProductionOrderDetailStateCopyWithImpl<$Res>
    implements $ProductionOrderDetailStateCopyWith<$Res> {
  _$ProductionOrderDetailStateCopyWithImpl(this._self, this._then);

  final ProductionOrderDetailState _self;
  final $Res Function(ProductionOrderDetailState) _then;

/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = freezed,Object? isLoading = null,Object? isUpdating = null,Object? isEditingDraft = null,Object? draftBomHeaderId = freezed,Object? draftQtyToProduce = null,Object? draftNotes = null,Object? activeBoms = null,Object? isPreviewLoading = null,Object? completionPreview = freezed,Object? completionAvailability = null,Object? allowNegativeStock = null,Object? canCreate = null,Object? canComplete = null,Object? canCancel = null,Object? errors = null,Object? loadError = freezed,}) {
  return _then(ProductionOrderDetailState(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as ProductionOrderModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,isEditingDraft: null == isEditingDraft ? _self.isEditingDraft : isEditingDraft // ignore: cast_nullable_to_non_nullable
as bool,draftBomHeaderId: freezed == draftBomHeaderId ? _self.draftBomHeaderId : draftBomHeaderId // ignore: cast_nullable_to_non_nullable
as String?,draftQtyToProduce: null == draftQtyToProduce ? _self.draftQtyToProduce : draftQtyToProduce // ignore: cast_nullable_to_non_nullable
as String,draftNotes: null == draftNotes ? _self.draftNotes : draftNotes // ignore: cast_nullable_to_non_nullable
as String,activeBoms: null == activeBoms ? _self.activeBoms : activeBoms // ignore: cast_nullable_to_non_nullable
as List<BomHeaderModel>,isPreviewLoading: null == isPreviewLoading ? _self.isPreviewLoading : isPreviewLoading // ignore: cast_nullable_to_non_nullable
as bool,completionPreview: freezed == completionPreview ? _self.completionPreview : completionPreview // ignore: cast_nullable_to_non_nullable
as BomPreviewModel?,completionAvailability: null == completionAvailability ? _self.completionAvailability : completionAvailability // ignore: cast_nullable_to_non_nullable
as List<IngredientAvailabilityRow>,allowNegativeStock: null == allowNegativeStock ? _self.allowNegativeStock : allowNegativeStock // ignore: cast_nullable_to_non_nullable
as bool,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,canComplete: null == canComplete ? _self.canComplete : canComplete // ignore: cast_nullable_to_non_nullable
as bool,canCancel: null == canCancel ? _self.canCancel : canCancel // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductionOrderModelCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $ProductionOrderModelCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BomPreviewModelCopyWith<$Res>? get completionPreview {
    if (_self.completionPreview == null) {
    return null;
  }

  return $BomPreviewModelCopyWith<$Res>(_self.completionPreview!, (value) {
    return _then(_self.copyWith(completionPreview: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductionOrderDetailState].
extension ProductionOrderDetailStatePatterns on ProductionOrderDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionOrderDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionOrderDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionOrderDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionOrderDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionOrderDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductionOrderModel? order,  bool isLoading,  bool isUpdating,  bool isEditingDraft,  String? draftBomHeaderId,  String draftQtyToProduce,  String draftNotes,  List<BomHeaderModel> activeBoms,  bool isPreviewLoading,  BomPreviewModel? completionPreview,  List<IngredientAvailabilityRow> completionAvailability,  bool allowNegativeStock,  bool canCreate,  bool canComplete,  bool canCancel,  Map<String, String> errors,  String? loadError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionOrderDetailState() when $default != null:
return $default(_that.order,_that.isLoading,_that.isUpdating,_that.isEditingDraft,_that.draftBomHeaderId,_that.draftQtyToProduce,_that.draftNotes,_that.activeBoms,_that.isPreviewLoading,_that.completionPreview,_that.completionAvailability,_that.allowNegativeStock,_that.canCreate,_that.canComplete,_that.canCancel,_that.errors,_that.loadError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductionOrderModel? order,  bool isLoading,  bool isUpdating,  bool isEditingDraft,  String? draftBomHeaderId,  String draftQtyToProduce,  String draftNotes,  List<BomHeaderModel> activeBoms,  bool isPreviewLoading,  BomPreviewModel? completionPreview,  List<IngredientAvailabilityRow> completionAvailability,  bool allowNegativeStock,  bool canCreate,  bool canComplete,  bool canCancel,  Map<String, String> errors,  String? loadError)  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderDetailState():
return $default(_that.order,_that.isLoading,_that.isUpdating,_that.isEditingDraft,_that.draftBomHeaderId,_that.draftQtyToProduce,_that.draftNotes,_that.activeBoms,_that.isPreviewLoading,_that.completionPreview,_that.completionAvailability,_that.allowNegativeStock,_that.canCreate,_that.canComplete,_that.canCancel,_that.errors,_that.loadError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductionOrderModel? order,  bool isLoading,  bool isUpdating,  bool isEditingDraft,  String? draftBomHeaderId,  String draftQtyToProduce,  String draftNotes,  List<BomHeaderModel> activeBoms,  bool isPreviewLoading,  BomPreviewModel? completionPreview,  List<IngredientAvailabilityRow> completionAvailability,  bool allowNegativeStock,  bool canCreate,  bool canComplete,  bool canCancel,  Map<String, String> errors,  String? loadError)?  $default,) {final _that = this;
switch (_that) {
case _ProductionOrderDetailState() when $default != null:
return $default(_that.order,_that.isLoading,_that.isUpdating,_that.isEditingDraft,_that.draftBomHeaderId,_that.draftQtyToProduce,_that.draftNotes,_that.activeBoms,_that.isPreviewLoading,_that.completionPreview,_that.completionAvailability,_that.allowNegativeStock,_that.canCreate,_that.canComplete,_that.canCancel,_that.errors,_that.loadError);case _:
  return null;

}
}

}

/// @nodoc


class _ProductionOrderDetailState implements ProductionOrderDetailState {
  const _ProductionOrderDetailState({this.order, this.isLoading = false, this.isUpdating = false, this.isEditingDraft = false, this.draftBomHeaderId, this.draftQtyToProduce = '', this.draftNotes = '',  List<BomHeaderModel> activeBoms = const [], this.isPreviewLoading = false, this.completionPreview,  List<IngredientAvailabilityRow> completionAvailability = const [], this.allowNegativeStock = false, this.canCreate = false, this.canComplete = false, this.canCancel = false,  Map<String, String> errors = const {}, this.loadError}): _activeBoms = activeBoms,_completionAvailability = completionAvailability,_errors = errors;
  

@override final  ProductionOrderModel? order;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isUpdating;
@override@JsonKey() final  bool isEditingDraft;
@override final  String? draftBomHeaderId;
@override@JsonKey() final  String draftQtyToProduce;
@override@JsonKey() final  String draftNotes;
 final  List<BomHeaderModel> _activeBoms;
@override@JsonKey() List<BomHeaderModel> get activeBoms {
  if (_activeBoms is EqualUnmodifiableListView) return _activeBoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeBoms);
}

@override@JsonKey() final  bool isPreviewLoading;
@override final  BomPreviewModel? completionPreview;
 final  List<IngredientAvailabilityRow> _completionAvailability;
@override@JsonKey() List<IngredientAvailabilityRow> get completionAvailability {
  if (_completionAvailability is EqualUnmodifiableListView) return _completionAvailability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completionAvailability);
}

@override@JsonKey() final  bool allowNegativeStock;
@override@JsonKey() final  bool canCreate;
@override@JsonKey() final  bool canComplete;
@override@JsonKey() final  bool canCancel;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

@override final  String? loadError;

/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionOrderDetailStateCopyWith<_ProductionOrderDetailState> get copyWith => __$ProductionOrderDetailStateCopyWithImpl<_ProductionOrderDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionOrderDetailState&&(identical(other.order, order) || other.order == order)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.isEditingDraft, isEditingDraft) || other.isEditingDraft == isEditingDraft)&&(identical(other.draftBomHeaderId, draftBomHeaderId) || other.draftBomHeaderId == draftBomHeaderId)&&(identical(other.draftQtyToProduce, draftQtyToProduce) || other.draftQtyToProduce == draftQtyToProduce)&&(identical(other.draftNotes, draftNotes) || other.draftNotes == draftNotes)&&const DeepCollectionEquality().equals(other.activeBoms, _activeBoms)&&(identical(other.isPreviewLoading, isPreviewLoading) || other.isPreviewLoading == isPreviewLoading)&&(identical(other.completionPreview, completionPreview) || other.completionPreview == completionPreview)&&const DeepCollectionEquality().equals(other.completionAvailability, _completionAvailability)&&(identical(other.allowNegativeStock, allowNegativeStock) || other.allowNegativeStock == allowNegativeStock)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.canComplete, canComplete) || other.canComplete == canComplete)&&(identical(other.canCancel, canCancel) || other.canCancel == canCancel)&&const DeepCollectionEquality().equals(other.errors, _errors)&&(identical(other.loadError, loadError) || other.loadError == loadError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,order,isLoading,isUpdating,isEditingDraft,draftBomHeaderId,draftQtyToProduce,draftNotes,const DeepCollectionEquality().hash(_activeBoms),isPreviewLoading,completionPreview,const DeepCollectionEquality().hash(_completionAvailability),allowNegativeStock,canCreate,canComplete,canCancel,const DeepCollectionEquality().hash(_errors),loadError);
}

@override
String toString() {
    return 'ProductionOrderDetailState(order: $order, isLoading: $isLoading, isUpdating: $isUpdating, isEditingDraft: $isEditingDraft, draftBomHeaderId: $draftBomHeaderId, draftQtyToProduce: $draftQtyToProduce, draftNotes: $draftNotes, activeBoms: $activeBoms, isPreviewLoading: $isPreviewLoading, completionPreview: $completionPreview, completionAvailability: $completionAvailability, allowNegativeStock: $allowNegativeStock, canCreate: $canCreate, canComplete: $canComplete, canCancel: $canCancel, errors: $errors, loadError: $loadError)';
}


}

/// @nodoc
abstract mixin class _$ProductionOrderDetailStateCopyWith<$Res> implements $ProductionOrderDetailStateCopyWith<$Res> {
  factory _$ProductionOrderDetailStateCopyWith(_ProductionOrderDetailState value, $Res Function(_ProductionOrderDetailState) _then) = __$ProductionOrderDetailStateCopyWithImpl;
@override @useResult
$Res call({
 ProductionOrderModel? order, bool isLoading, bool isUpdating, bool isEditingDraft, String? draftBomHeaderId, String draftQtyToProduce, String draftNotes, List<BomHeaderModel> activeBoms, bool isPreviewLoading, BomPreviewModel? completionPreview, List<IngredientAvailabilityRow> completionAvailability, bool allowNegativeStock, bool canCreate, bool canComplete, bool canCancel, Map<String, String> errors, String? loadError
});


@override $ProductionOrderModelCopyWith<$Res>? get order;@override $BomPreviewModelCopyWith<$Res>? get completionPreview;

}
/// @nodoc
class __$ProductionOrderDetailStateCopyWithImpl<$Res>
    implements _$ProductionOrderDetailStateCopyWith<$Res> {
  __$ProductionOrderDetailStateCopyWithImpl(this._self, this._then);

  final _ProductionOrderDetailState _self;
  final $Res Function(_ProductionOrderDetailState) _then;

/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = freezed,Object? isLoading = null,Object? isUpdating = null,Object? isEditingDraft = null,Object? draftBomHeaderId = freezed,Object? draftQtyToProduce = null,Object? draftNotes = null,Object? activeBoms = null,Object? isPreviewLoading = null,Object? completionPreview = freezed,Object? completionAvailability = null,Object? allowNegativeStock = null,Object? canCreate = null,Object? canComplete = null,Object? canCancel = null,Object? errors = null,Object? loadError = freezed,}) {
  return _then(_ProductionOrderDetailState(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as ProductionOrderModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,isEditingDraft: null == isEditingDraft ? _self.isEditingDraft : isEditingDraft // ignore: cast_nullable_to_non_nullable
as bool,draftBomHeaderId: freezed == draftBomHeaderId ? _self.draftBomHeaderId : draftBomHeaderId // ignore: cast_nullable_to_non_nullable
as String?,draftQtyToProduce: null == draftQtyToProduce ? _self.draftQtyToProduce : draftQtyToProduce // ignore: cast_nullable_to_non_nullable
as String,draftNotes: null == draftNotes ? _self.draftNotes : draftNotes // ignore: cast_nullable_to_non_nullable
as String,activeBoms: null == activeBoms ? _self._activeBoms : activeBoms // ignore: cast_nullable_to_non_nullable
as List<BomHeaderModel>,isPreviewLoading: null == isPreviewLoading ? _self.isPreviewLoading : isPreviewLoading // ignore: cast_nullable_to_non_nullable
as bool,completionPreview: freezed == completionPreview ? _self.completionPreview : completionPreview // ignore: cast_nullable_to_non_nullable
as BomPreviewModel?,completionAvailability: null == completionAvailability ? _self._completionAvailability : completionAvailability // ignore: cast_nullable_to_non_nullable
as List<IngredientAvailabilityRow>,allowNegativeStock: null == allowNegativeStock ? _self.allowNegativeStock : allowNegativeStock // ignore: cast_nullable_to_non_nullable
as bool,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,canComplete: null == canComplete ? _self.canComplete : canComplete // ignore: cast_nullable_to_non_nullable
as bool,canCancel: null == canCancel ? _self.canCancel : canCancel // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductionOrderModelCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $ProductionOrderModelCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ProductionOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BomPreviewModelCopyWith<$Res>? get completionPreview {
    if (_self.completionPreview == null) {
    return null;
  }

  return $BomPreviewModelCopyWith<$Res>(_self.completionPreview!, (value) {
    return _then(_self.copyWith(completionPreview: value));
  });
}
}

// dart format on
