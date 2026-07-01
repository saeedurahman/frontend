// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_order_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductionOrderFormState {
  String? get branchId => throw _privateConstructorUsedError;
  String? get bomHeaderId => throw _privateConstructorUsedError;
  String get qtyToProduce => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  List<BomHeaderModel> get activeBoms => throw _privateConstructorUsedError;
  bool get isPreviewLoading => throw _privateConstructorUsedError;
  BomPreviewModel? get preview => throw _privateConstructorUsedError;
  List<IngredientAvailabilityRow> get availability =>
      throw _privateConstructorUsedError;
  bool get hasShortfall => throw _privateConstructorUsedError;
  bool get allowNegativeStock => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of ProductionOrderFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionOrderFormStateCopyWith<ProductionOrderFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionOrderFormStateCopyWith<$Res> {
  factory $ProductionOrderFormStateCopyWith(
    ProductionOrderFormState value,
    $Res Function(ProductionOrderFormState) then,
  ) = _$ProductionOrderFormStateCopyWithImpl<$Res, ProductionOrderFormState>;
  @useResult
  $Res call({
    String? branchId,
    String? bomHeaderId,
    String qtyToProduce,
    String notes,
    List<BomHeaderModel> activeBoms,
    bool isPreviewLoading,
    BomPreviewModel? preview,
    List<IngredientAvailabilityRow> availability,
    bool hasShortfall,
    bool allowNegativeStock,
    bool isLoading,
    bool isSubmitting,
    Map<String, String> errors,
  });

  $BomPreviewModelCopyWith<$Res>? get preview;
}

/// @nodoc
class _$ProductionOrderFormStateCopyWithImpl<
  $Res,
  $Val extends ProductionOrderFormState
>
    implements $ProductionOrderFormStateCopyWith<$Res> {
  _$ProductionOrderFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionOrderFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = freezed,
    Object? bomHeaderId = freezed,
    Object? qtyToProduce = null,
    Object? notes = null,
    Object? activeBoms = null,
    Object? isPreviewLoading = null,
    Object? preview = freezed,
    Object? availability = null,
    Object? hasShortfall = null,
    Object? allowNegativeStock = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errors = null,
  }) {
    return _then(
      _value.copyWith(
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bomHeaderId: freezed == bomHeaderId
                ? _value.bomHeaderId
                : bomHeaderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qtyToProduce: null == qtyToProduce
                ? _value.qtyToProduce
                : qtyToProduce // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            activeBoms: null == activeBoms
                ? _value.activeBoms
                : activeBoms // ignore: cast_nullable_to_non_nullable
                      as List<BomHeaderModel>,
            isPreviewLoading: null == isPreviewLoading
                ? _value.isPreviewLoading
                : isPreviewLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            preview: freezed == preview
                ? _value.preview
                : preview // ignore: cast_nullable_to_non_nullable
                      as BomPreviewModel?,
            availability: null == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as List<IngredientAvailabilityRow>,
            hasShortfall: null == hasShortfall
                ? _value.hasShortfall
                : hasShortfall // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowNegativeStock: null == allowNegativeStock
                ? _value.allowNegativeStock
                : allowNegativeStock // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductionOrderFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BomPreviewModelCopyWith<$Res>? get preview {
    if (_value.preview == null) {
      return null;
    }

    return $BomPreviewModelCopyWith<$Res>(_value.preview!, (value) {
      return _then(_value.copyWith(preview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductionOrderFormStateImplCopyWith<$Res>
    implements $ProductionOrderFormStateCopyWith<$Res> {
  factory _$$ProductionOrderFormStateImplCopyWith(
    _$ProductionOrderFormStateImpl value,
    $Res Function(_$ProductionOrderFormStateImpl) then,
  ) = __$$ProductionOrderFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? branchId,
    String? bomHeaderId,
    String qtyToProduce,
    String notes,
    List<BomHeaderModel> activeBoms,
    bool isPreviewLoading,
    BomPreviewModel? preview,
    List<IngredientAvailabilityRow> availability,
    bool hasShortfall,
    bool allowNegativeStock,
    bool isLoading,
    bool isSubmitting,
    Map<String, String> errors,
  });

  @override
  $BomPreviewModelCopyWith<$Res>? get preview;
}

/// @nodoc
class __$$ProductionOrderFormStateImplCopyWithImpl<$Res>
    extends
        _$ProductionOrderFormStateCopyWithImpl<
          $Res,
          _$ProductionOrderFormStateImpl
        >
    implements _$$ProductionOrderFormStateImplCopyWith<$Res> {
  __$$ProductionOrderFormStateImplCopyWithImpl(
    _$ProductionOrderFormStateImpl _value,
    $Res Function(_$ProductionOrderFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductionOrderFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = freezed,
    Object? bomHeaderId = freezed,
    Object? qtyToProduce = null,
    Object? notes = null,
    Object? activeBoms = null,
    Object? isPreviewLoading = null,
    Object? preview = freezed,
    Object? availability = null,
    Object? hasShortfall = null,
    Object? allowNegativeStock = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errors = null,
  }) {
    return _then(
      _$ProductionOrderFormStateImpl(
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bomHeaderId: freezed == bomHeaderId
            ? _value.bomHeaderId
            : bomHeaderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qtyToProduce: null == qtyToProduce
            ? _value.qtyToProduce
            : qtyToProduce // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        activeBoms: null == activeBoms
            ? _value._activeBoms
            : activeBoms // ignore: cast_nullable_to_non_nullable
                  as List<BomHeaderModel>,
        isPreviewLoading: null == isPreviewLoading
            ? _value.isPreviewLoading
            : isPreviewLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        preview: freezed == preview
            ? _value.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as BomPreviewModel?,
        availability: null == availability
            ? _value._availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as List<IngredientAvailabilityRow>,
        hasShortfall: null == hasShortfall
            ? _value.hasShortfall
            : hasShortfall // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowNegativeStock: null == allowNegativeStock
            ? _value.allowNegativeStock
            : allowNegativeStock // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$ProductionOrderFormStateImpl implements _ProductionOrderFormState {
  const _$ProductionOrderFormStateImpl({
    this.branchId,
    this.bomHeaderId,
    this.qtyToProduce = '',
    this.notes = '',
    final List<BomHeaderModel> activeBoms = const [],
    this.isPreviewLoading = false,
    this.preview,
    final List<IngredientAvailabilityRow> availability = const [],
    this.hasShortfall = false,
    this.allowNegativeStock = false,
    this.isLoading = false,
    this.isSubmitting = false,
    final Map<String, String> errors = const {},
  }) : _activeBoms = activeBoms,
       _availability = availability,
       _errors = errors;

  @override
  final String? branchId;
  @override
  final String? bomHeaderId;
  @override
  @JsonKey()
  final String qtyToProduce;
  @override
  @JsonKey()
  final String notes;
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
  final BomPreviewModel? preview;
  final List<IngredientAvailabilityRow> _availability;
  @override
  @JsonKey()
  List<IngredientAvailabilityRow> get availability {
    if (_availability is EqualUnmodifiableListView) return _availability;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availability);
  }

  @override
  @JsonKey()
  final bool hasShortfall;
  @override
  @JsonKey()
  final bool allowNegativeStock;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  final Map<String, String> _errors;
  @override
  @JsonKey()
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  String toString() {
    return 'ProductionOrderFormState(branchId: $branchId, bomHeaderId: $bomHeaderId, qtyToProduce: $qtyToProduce, notes: $notes, activeBoms: $activeBoms, isPreviewLoading: $isPreviewLoading, preview: $preview, availability: $availability, hasShortfall: $hasShortfall, allowNegativeStock: $allowNegativeStock, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionOrderFormStateImpl &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.bomHeaderId, bomHeaderId) ||
                other.bomHeaderId == bomHeaderId) &&
            (identical(other.qtyToProduce, qtyToProduce) ||
                other.qtyToProduce == qtyToProduce) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._activeBoms,
              _activeBoms,
            ) &&
            (identical(other.isPreviewLoading, isPreviewLoading) ||
                other.isPreviewLoading == isPreviewLoading) &&
            (identical(other.preview, preview) || other.preview == preview) &&
            const DeepCollectionEquality().equals(
              other._availability,
              _availability,
            ) &&
            (identical(other.hasShortfall, hasShortfall) ||
                other.hasShortfall == hasShortfall) &&
            (identical(other.allowNegativeStock, allowNegativeStock) ||
                other.allowNegativeStock == allowNegativeStock) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    branchId,
    bomHeaderId,
    qtyToProduce,
    notes,
    const DeepCollectionEquality().hash(_activeBoms),
    isPreviewLoading,
    preview,
    const DeepCollectionEquality().hash(_availability),
    hasShortfall,
    allowNegativeStock,
    isLoading,
    isSubmitting,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of ProductionOrderFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionOrderFormStateImplCopyWith<_$ProductionOrderFormStateImpl>
  get copyWith =>
      __$$ProductionOrderFormStateImplCopyWithImpl<
        _$ProductionOrderFormStateImpl
      >(this, _$identity);
}

abstract class _ProductionOrderFormState implements ProductionOrderFormState {
  const factory _ProductionOrderFormState({
    final String? branchId,
    final String? bomHeaderId,
    final String qtyToProduce,
    final String notes,
    final List<BomHeaderModel> activeBoms,
    final bool isPreviewLoading,
    final BomPreviewModel? preview,
    final List<IngredientAvailabilityRow> availability,
    final bool hasShortfall,
    final bool allowNegativeStock,
    final bool isLoading,
    final bool isSubmitting,
    final Map<String, String> errors,
  }) = _$ProductionOrderFormStateImpl;

  @override
  String? get branchId;
  @override
  String? get bomHeaderId;
  @override
  String get qtyToProduce;
  @override
  String get notes;
  @override
  List<BomHeaderModel> get activeBoms;
  @override
  bool get isPreviewLoading;
  @override
  BomPreviewModel? get preview;
  @override
  List<IngredientAvailabilityRow> get availability;
  @override
  bool get hasShortfall;
  @override
  bool get allowNegativeStock;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  Map<String, String> get errors;

  /// Create a copy of ProductionOrderFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionOrderFormStateImplCopyWith<_$ProductionOrderFormStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
