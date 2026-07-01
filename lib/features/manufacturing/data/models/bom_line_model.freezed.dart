// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BomLineModel _$BomLineModelFromJson(Map<String, dynamic> json) {
  return _BomLineModel.fromJson(json);
}

/// @nodoc
mixin _$BomLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bom_header_id')
  String get bomHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_product_id')
  String get ingredientProductId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_product_name')
  String get ingredientProductName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_variation_id')
  String? get ingredientVariationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_required')
  String get qtyRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String? get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'wastage_pct')
  String get wastagePct => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this BomLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BomLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BomLineModelCopyWith<BomLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BomLineModelCopyWith<$Res> {
  factory $BomLineModelCopyWith(
    BomLineModel value,
    $Res Function(BomLineModel) then,
  ) = _$BomLineModelCopyWithImpl<$Res, BomLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'bom_header_id') String bomHeaderId,
    @JsonKey(name: 'ingredient_product_id') String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name') String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,
    @JsonKey(name: 'qty_required') String qtyRequired,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'wastage_pct') String wastagePct,
    @JsonKey(name: 'sort_order') int sortOrder,
  });
}

/// @nodoc
class _$BomLineModelCopyWithImpl<$Res, $Val extends BomLineModel>
    implements $BomLineModelCopyWith<$Res> {
  _$BomLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BomLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? bomHeaderId = null,
    Object? ingredientProductId = null,
    Object? ingredientProductName = null,
    Object? ingredientVariationId = freezed,
    Object? qtyRequired = null,
    Object? unitId = freezed,
    Object? wastagePct = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as String,
            bomHeaderId: null == bomHeaderId
                ? _value.bomHeaderId
                : bomHeaderId // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredientProductId: null == ingredientProductId
                ? _value.ingredientProductId
                : ingredientProductId // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredientProductName: null == ingredientProductName
                ? _value.ingredientProductName
                : ingredientProductName // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredientVariationId: freezed == ingredientVariationId
                ? _value.ingredientVariationId
                : ingredientVariationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qtyRequired: null == qtyRequired
                ? _value.qtyRequired
                : qtyRequired // ignore: cast_nullable_to_non_nullable
                      as String,
            unitId: freezed == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String?,
            wastagePct: null == wastagePct
                ? _value.wastagePct
                : wastagePct // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BomLineModelImplCopyWith<$Res>
    implements $BomLineModelCopyWith<$Res> {
  factory _$$BomLineModelImplCopyWith(
    _$BomLineModelImpl value,
    $Res Function(_$BomLineModelImpl) then,
  ) = __$$BomLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'bom_header_id') String bomHeaderId,
    @JsonKey(name: 'ingredient_product_id') String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name') String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,
    @JsonKey(name: 'qty_required') String qtyRequired,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'wastage_pct') String wastagePct,
    @JsonKey(name: 'sort_order') int sortOrder,
  });
}

/// @nodoc
class __$$BomLineModelImplCopyWithImpl<$Res>
    extends _$BomLineModelCopyWithImpl<$Res, _$BomLineModelImpl>
    implements _$$BomLineModelImplCopyWith<$Res> {
  __$$BomLineModelImplCopyWithImpl(
    _$BomLineModelImpl _value,
    $Res Function(_$BomLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BomLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? bomHeaderId = null,
    Object? ingredientProductId = null,
    Object? ingredientProductName = null,
    Object? ingredientVariationId = freezed,
    Object? qtyRequired = null,
    Object? unitId = freezed,
    Object? wastagePct = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$BomLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        bomHeaderId: null == bomHeaderId
            ? _value.bomHeaderId
            : bomHeaderId // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredientProductId: null == ingredientProductId
            ? _value.ingredientProductId
            : ingredientProductId // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredientProductName: null == ingredientProductName
            ? _value.ingredientProductName
            : ingredientProductName // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredientVariationId: freezed == ingredientVariationId
            ? _value.ingredientVariationId
            : ingredientVariationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qtyRequired: null == qtyRequired
            ? _value.qtyRequired
            : qtyRequired // ignore: cast_nullable_to_non_nullable
                  as String,
        unitId: freezed == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String?,
        wastagePct: null == wastagePct
            ? _value.wastagePct
            : wastagePct // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BomLineModelImpl implements _BomLineModel {
  const _$BomLineModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'bom_header_id') required this.bomHeaderId,
    @JsonKey(name: 'ingredient_product_id') required this.ingredientProductId,
    @JsonKey(name: 'ingredient_product_name')
    required this.ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') this.ingredientVariationId,
    @JsonKey(name: 'qty_required') required this.qtyRequired,
    @JsonKey(name: 'unit_id') this.unitId,
    @JsonKey(name: 'wastage_pct') this.wastagePct = '0',
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
  });

  factory _$BomLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BomLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'bom_header_id')
  final String bomHeaderId;
  @override
  @JsonKey(name: 'ingredient_product_id')
  final String ingredientProductId;
  @override
  @JsonKey(name: 'ingredient_product_name')
  final String ingredientProductName;
  @override
  @JsonKey(name: 'ingredient_variation_id')
  final String? ingredientVariationId;
  @override
  @JsonKey(name: 'qty_required')
  final String qtyRequired;
  @override
  @JsonKey(name: 'unit_id')
  final String? unitId;
  @override
  @JsonKey(name: 'wastage_pct')
  final String wastagePct;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @override
  String toString() {
    return 'BomLineModel(id: $id, businessId: $businessId, bomHeaderId: $bomHeaderId, ingredientProductId: $ingredientProductId, ingredientProductName: $ingredientProductName, ingredientVariationId: $ingredientVariationId, qtyRequired: $qtyRequired, unitId: $unitId, wastagePct: $wastagePct, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BomLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.bomHeaderId, bomHeaderId) ||
                other.bomHeaderId == bomHeaderId) &&
            (identical(other.ingredientProductId, ingredientProductId) ||
                other.ingredientProductId == ingredientProductId) &&
            (identical(other.ingredientProductName, ingredientProductName) ||
                other.ingredientProductName == ingredientProductName) &&
            (identical(other.ingredientVariationId, ingredientVariationId) ||
                other.ingredientVariationId == ingredientVariationId) &&
            (identical(other.qtyRequired, qtyRequired) ||
                other.qtyRequired == qtyRequired) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.wastagePct, wastagePct) ||
                other.wastagePct == wastagePct) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    bomHeaderId,
    ingredientProductId,
    ingredientProductName,
    ingredientVariationId,
    qtyRequired,
    unitId,
    wastagePct,
    sortOrder,
  );

  /// Create a copy of BomLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BomLineModelImplCopyWith<_$BomLineModelImpl> get copyWith =>
      __$$BomLineModelImplCopyWithImpl<_$BomLineModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BomLineModelImplToJson(this);
  }
}

abstract class _BomLineModel implements BomLineModel {
  const factory _BomLineModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'bom_header_id') required final String bomHeaderId,
    @JsonKey(name: 'ingredient_product_id')
    required final String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name')
    required final String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id')
    final String? ingredientVariationId,
    @JsonKey(name: 'qty_required') required final String qtyRequired,
    @JsonKey(name: 'unit_id') final String? unitId,
    @JsonKey(name: 'wastage_pct') final String wastagePct,
    @JsonKey(name: 'sort_order') final int sortOrder,
  }) = _$BomLineModelImpl;

  factory _BomLineModel.fromJson(Map<String, dynamic> json) =
      _$BomLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'bom_header_id')
  String get bomHeaderId;
  @override
  @JsonKey(name: 'ingredient_product_id')
  String get ingredientProductId;
  @override
  @JsonKey(name: 'ingredient_product_name')
  String get ingredientProductName;
  @override
  @JsonKey(name: 'ingredient_variation_id')
  String? get ingredientVariationId;
  @override
  @JsonKey(name: 'qty_required')
  String get qtyRequired;
  @override
  @JsonKey(name: 'unit_id')
  String? get unitId;
  @override
  @JsonKey(name: 'wastage_pct')
  String get wastagePct;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Create a copy of BomLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BomLineModelImplCopyWith<_$BomLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
