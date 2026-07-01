// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_order_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductionOrderDetailState {
  ProductionOrderModel? get order => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  bool get isEditingDraft => throw _privateConstructorUsedError;
  String? get draftBomHeaderId => throw _privateConstructorUsedError;
  String get draftQtyToProduce => throw _privateConstructorUsedError;
  String get draftNotes => throw _privateConstructorUsedError;
  List<BomHeaderModel> get activeBoms => throw _privateConstructorUsedError;
  bool get isPreviewLoading => throw _privateConstructorUsedError;
  BomPreviewModel? get completionPreview => throw _privateConstructorUsedError;
  List<IngredientAvailabilityRow> get completionAvailability =>
      throw _privateConstructorUsedError;
  bool get allowNegativeStock => throw _privateConstructorUsedError;
  bool get canCreate => throw _privateConstructorUsedError;
  bool get canComplete => throw _privateConstructorUsedError;
  bool get canCancel => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;
  String? get loadError => throw _privateConstructorUsedError;

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionOrderDetailStateCopyWith<ProductionOrderDetailState>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionOrderDetailStateCopyWith<$Res> {
  factory $ProductionOrderDetailStateCopyWith(
    ProductionOrderDetailState value,
    $Res Function(ProductionOrderDetailState) then,
  ) =
      _$ProductionOrderDetailStateCopyWithImpl<
        $Res,
        ProductionOrderDetailState
      >;
  @useResult
  $Res call({
    ProductionOrderModel? order,
    bool isLoading,
    bool isUpdating,
    bool isEditingDraft,
    String? draftBomHeaderId,
    String draftQtyToProduce,
    String draftNotes,
    List<BomHeaderModel> activeBoms,
    bool isPreviewLoading,
    BomPreviewModel? completionPreview,
    List<IngredientAvailabilityRow> completionAvailability,
    bool allowNegativeStock,
    bool canCreate,
    bool canComplete,
    bool canCancel,
    Map<String, String> errors,
    String? loadError,
  });

  $ProductionOrderModelCopyWith<$Res>? get order;
  $BomPreviewModelCopyWith<$Res>? get completionPreview;
}

/// @nodoc
class _$ProductionOrderDetailStateCopyWithImpl<
  $Res,
  $Val extends ProductionOrderDetailState
>
    implements $ProductionOrderDetailStateCopyWith<$Res> {
  _$ProductionOrderDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = freezed,
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? isEditingDraft = null,
    Object? draftBomHeaderId = freezed,
    Object? draftQtyToProduce = null,
    Object? draftNotes = null,
    Object? activeBoms = null,
    Object? isPreviewLoading = null,
    Object? completionPreview = freezed,
    Object? completionAvailability = null,
    Object? allowNegativeStock = null,
    Object? canCreate = null,
    Object? canComplete = null,
    Object? canCancel = null,
    Object? errors = null,
    Object? loadError = freezed,
  }) {
    return _then(
      _value.copyWith(
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as ProductionOrderModel?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isUpdating: null == isUpdating
                ? _value.isUpdating
                : isUpdating // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEditingDraft: null == isEditingDraft
                ? _value.isEditingDraft
                : isEditingDraft // ignore: cast_nullable_to_non_nullable
                      as bool,
            draftBomHeaderId: freezed == draftBomHeaderId
                ? _value.draftBomHeaderId
                : draftBomHeaderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            draftQtyToProduce: null == draftQtyToProduce
                ? _value.draftQtyToProduce
                : draftQtyToProduce // ignore: cast_nullable_to_non_nullable
                      as String,
            draftNotes: null == draftNotes
                ? _value.draftNotes
                : draftNotes // ignore: cast_nullable_to_non_nullable
                      as String,
            activeBoms: null == activeBoms
                ? _value.activeBoms
                : activeBoms // ignore: cast_nullable_to_non_nullable
                      as List<BomHeaderModel>,
            isPreviewLoading: null == isPreviewLoading
                ? _value.isPreviewLoading
                : isPreviewLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            completionPreview: freezed == completionPreview
                ? _value.completionPreview
                : completionPreview // ignore: cast_nullable_to_non_nullable
                      as BomPreviewModel?,
            completionAvailability: null == completionAvailability
                ? _value.completionAvailability
                : completionAvailability // ignore: cast_nullable_to_non_nullable
                      as List<IngredientAvailabilityRow>,
            allowNegativeStock: null == allowNegativeStock
                ? _value.allowNegativeStock
                : allowNegativeStock // ignore: cast_nullable_to_non_nullable
                      as bool,
            canCreate: null == canCreate
                ? _value.canCreate
                : canCreate // ignore: cast_nullable_to_non_nullable
                      as bool,
            canComplete: null == canComplete
                ? _value.canComplete
                : canComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
            canCancel: null == canCancel
                ? _value.canCancel
                : canCancel // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            loadError: freezed == loadError
                ? _value.loadError
                : loadError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductionOrderModelCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $ProductionOrderModelCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BomPreviewModelCopyWith<$Res>? get completionPreview {
    if (_value.completionPreview == null) {
      return null;
    }

    return $BomPreviewModelCopyWith<$Res>(_value.completionPreview!, (value) {
      return _then(_value.copyWith(completionPreview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductionOrderDetailStateImplCopyWith<$Res>
    implements $ProductionOrderDetailStateCopyWith<$Res> {
  factory _$$ProductionOrderDetailStateImplCopyWith(
    _$ProductionOrderDetailStateImpl value,
    $Res Function(_$ProductionOrderDetailStateImpl) then,
  ) = __$$ProductionOrderDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ProductionOrderModel? order,
    bool isLoading,
    bool isUpdating,
    bool isEditingDraft,
    String? draftBomHeaderId,
    String draftQtyToProduce,
    String draftNotes,
    List<BomHeaderModel> activeBoms,
    bool isPreviewLoading,
    BomPreviewModel? completionPreview,
    List<IngredientAvailabilityRow> completionAvailability,
    bool allowNegativeStock,
    bool canCreate,
    bool canComplete,
    bool canCancel,
    Map<String, String> errors,
    String? loadError,
  });

  @override
  $ProductionOrderModelCopyWith<$Res>? get order;
  @override
  $BomPreviewModelCopyWith<$Res>? get completionPreview;
}

/// @nodoc
class __$$ProductionOrderDetailStateImplCopyWithImpl<$Res>
    extends
        _$ProductionOrderDetailStateCopyWithImpl<
          $Res,
          _$ProductionOrderDetailStateImpl
        >
    implements _$$ProductionOrderDetailStateImplCopyWith<$Res> {
  __$$ProductionOrderDetailStateImplCopyWithImpl(
    _$ProductionOrderDetailStateImpl _value,
    $Res Function(_$ProductionOrderDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = freezed,
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? isEditingDraft = null,
    Object? draftBomHeaderId = freezed,
    Object? draftQtyToProduce = null,
    Object? draftNotes = null,
    Object? activeBoms = null,
    Object? isPreviewLoading = null,
    Object? completionPreview = freezed,
    Object? completionAvailability = null,
    Object? allowNegativeStock = null,
    Object? canCreate = null,
    Object? canComplete = null,
    Object? canCancel = null,
    Object? errors = null,
    Object? loadError = freezed,
  }) {
    return _then(
      _$ProductionOrderDetailStateImpl(
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as ProductionOrderModel?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isUpdating: null == isUpdating
            ? _value.isUpdating
            : isUpdating // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEditingDraft: null == isEditingDraft
            ? _value.isEditingDraft
            : isEditingDraft // ignore: cast_nullable_to_non_nullable
                  as bool,
        draftBomHeaderId: freezed == draftBomHeaderId
            ? _value.draftBomHeaderId
            : draftBomHeaderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        draftQtyToProduce: null == draftQtyToProduce
            ? _value.draftQtyToProduce
            : draftQtyToProduce // ignore: cast_nullable_to_non_nullable
                  as String,
        draftNotes: null == draftNotes
            ? _value.draftNotes
            : draftNotes // ignore: cast_nullable_to_non_nullable
                  as String,
        activeBoms: null == activeBoms
            ? _value._activeBoms
            : activeBoms // ignore: cast_nullable_to_non_nullable
                  as List<BomHeaderModel>,
        isPreviewLoading: null == isPreviewLoading
            ? _value.isPreviewLoading
            : isPreviewLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        completionPreview: freezed == completionPreview
            ? _value.completionPreview
            : completionPreview // ignore: cast_nullable_to_non_nullable
                  as BomPreviewModel?,
        completionAvailability: null == completionAvailability
            ? _value._completionAvailability
            : completionAvailability // ignore: cast_nullable_to_non_nullable
                  as List<IngredientAvailabilityRow>,
        allowNegativeStock: null == allowNegativeStock
            ? _value.allowNegativeStock
            : allowNegativeStock // ignore: cast_nullable_to_non_nullable
                  as bool,
        canCreate: null == canCreate
            ? _value.canCreate
            : canCreate // ignore: cast_nullable_to_non_nullable
                  as bool,
        canComplete: null == canComplete
            ? _value.canComplete
            : canComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
        canCancel: null == canCancel
            ? _value.canCancel
            : canCancel // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        loadError: freezed == loadError
            ? _value.loadError
            : loadError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ProductionOrderDetailStateImpl implements _ProductionOrderDetailState {
  const _$ProductionOrderDetailStateImpl({
    this.order,
    this.isLoading = false,
    this.isUpdating = false,
    this.isEditingDraft = false,
    this.draftBomHeaderId,
    this.draftQtyToProduce = '',
    this.draftNotes = '',
    final List<BomHeaderModel> activeBoms = const [],
    this.isPreviewLoading = false,
    this.completionPreview,
    final List<IngredientAvailabilityRow> completionAvailability = const [],
    this.allowNegativeStock = false,
    this.canCreate = false,
    this.canComplete = false,
    this.canCancel = false,
    final Map<String, String> errors = const {},
    this.loadError,
  }) : _activeBoms = activeBoms,
       _completionAvailability = completionAvailability,
       _errors = errors;

  @override
  final ProductionOrderModel? order;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  @JsonKey()
  final bool isEditingDraft;
  @override
  final String? draftBomHeaderId;
  @override
  @JsonKey()
  final String draftQtyToProduce;
  @override
  @JsonKey()
  final String draftNotes;
  final List<BomHeaderModel> _activeBoms;
  @override
  @JsonKey()
  List<BomHeaderModel> get activeBoms {
    if (_activeBoms is EqualUnmodifiableListView) return _activeBoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeBoms);
  }

  @override
  @JsonKey()
  final bool isPreviewLoading;
  @override
  final BomPreviewModel? completionPreview;
  final List<IngredientAvailabilityRow> _completionAvailability;
  @override
  @JsonKey()
  List<IngredientAvailabilityRow> get completionAvailability {
    if (_completionAvailability is EqualUnmodifiableListView)
      return _completionAvailability;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completionAvailability);
  }

  @override
  @JsonKey()
  final bool allowNegativeStock;
  @override
  @JsonKey()
  final bool canCreate;
  @override
  @JsonKey()
  final bool canComplete;
  @override
  @JsonKey()
  final bool canCancel;
  final Map<String, String> _errors;
  @override
  @JsonKey()
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  final String? loadError;

  @override
  String toString() {
    return 'ProductionOrderDetailState(order: $order, isLoading: $isLoading, isUpdating: $isUpdating, isEditingDraft: $isEditingDraft, draftBomHeaderId: $draftBomHeaderId, draftQtyToProduce: $draftQtyToProduce, draftNotes: $draftNotes, activeBoms: $activeBoms, isPreviewLoading: $isPreviewLoading, completionPreview: $completionPreview, completionAvailability: $completionAvailability, allowNegativeStock: $allowNegativeStock, canCreate: $canCreate, canComplete: $canComplete, canCancel: $canCancel, errors: $errors, loadError: $loadError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionOrderDetailStateImpl &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.isEditingDraft, isEditingDraft) ||
                other.isEditingDraft == isEditingDraft) &&
            (identical(other.draftBomHeaderId, draftBomHeaderId) ||
                other.draftBomHeaderId == draftBomHeaderId) &&
            (identical(other.draftQtyToProduce, draftQtyToProduce) ||
                other.draftQtyToProduce == draftQtyToProduce) &&
            (identical(other.draftNotes, draftNotes) ||
                other.draftNotes == draftNotes) &&
            const DeepCollectionEquality().equals(
              other._activeBoms,
              _activeBoms,
            ) &&
            (identical(other.isPreviewLoading, isPreviewLoading) ||
                other.isPreviewLoading == isPreviewLoading) &&
            (identical(other.completionPreview, completionPreview) ||
                other.completionPreview == completionPreview) &&
            const DeepCollectionEquality().equals(
              other._completionAvailability,
              _completionAvailability,
            ) &&
            (identical(other.allowNegativeStock, allowNegativeStock) ||
                other.allowNegativeStock == allowNegativeStock) &&
            (identical(other.canCreate, canCreate) ||
                other.canCreate == canCreate) &&
            (identical(other.canComplete, canComplete) ||
                other.canComplete == canComplete) &&
            (identical(other.canCancel, canCancel) ||
                other.canCancel == canCancel) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.loadError, loadError) ||
                other.loadError == loadError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    order,
    isLoading,
    isUpdating,
    isEditingDraft,
    draftBomHeaderId,
    draftQtyToProduce,
    draftNotes,
    const DeepCollectionEquality().hash(_activeBoms),
    isPreviewLoading,
    completionPreview,
    const DeepCollectionEquality().hash(_completionAvailability),
    allowNegativeStock,
    canCreate,
    canComplete,
    canCancel,
    const DeepCollectionEquality().hash(_errors),
    loadError,
  );

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionOrderDetailStateImplCopyWith<_$ProductionOrderDetailStateImpl>
  get copyWith =>
      __$$ProductionOrderDetailStateImplCopyWithImpl<
        _$ProductionOrderDetailStateImpl
      >(this, _$identity);
}

abstract class _ProductionOrderDetailState
    implements ProductionOrderDetailState {
  const factory _ProductionOrderDetailState({
    final ProductionOrderModel? order,
    final bool isLoading,
    final bool isUpdating,
    final bool isEditingDraft,
    final String? draftBomHeaderId,
    final String draftQtyToProduce,
    final String draftNotes,
    final List<BomHeaderModel> activeBoms,
    final bool isPreviewLoading,
    final BomPreviewModel? completionPreview,
    final List<IngredientAvailabilityRow> completionAvailability,
    final bool allowNegativeStock,
    final bool canCreate,
    final bool canComplete,
    final bool canCancel,
    final Map<String, String> errors,
    final String? loadError,
  }) = _$ProductionOrderDetailStateImpl;

  @override
  ProductionOrderModel? get order;
  @override
  bool get isLoading;
  @override
  bool get isUpdating;
  @override
  bool get isEditingDraft;
  @override
  String? get draftBomHeaderId;
  @override
  String get draftQtyToProduce;
  @override
  String get draftNotes;
  @override
  List<BomHeaderModel> get activeBoms;
  @override
  bool get isPreviewLoading;
  @override
  BomPreviewModel? get completionPreview;
  @override
  List<IngredientAvailabilityRow> get completionAvailability;
  @override
  bool get allowNegativeStock;
  @override
  bool get canCreate;
  @override
  bool get canComplete;
  @override
  bool get canCancel;
  @override
  Map<String, String> get errors;
  @override
  String? get loadError;

  /// Create a copy of ProductionOrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionOrderDetailStateImplCopyWith<_$ProductionOrderDetailStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
