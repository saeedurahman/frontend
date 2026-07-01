// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_preview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BomPreviewLineModel _$BomPreviewLineModelFromJson(Map<String, dynamic> json) {
  return _BomPreviewLineModel.fromJson(json);
}

/// @nodoc
mixin _$BomPreviewLineModel {
  @JsonKey(name: 'ingredient_product_id')
  String get ingredientProductId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_product_name')
  String get ingredientProductName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_variation_id')
  String? get ingredientVariationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_per_output_unit')
  String get qtyPerOutputUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_qty_required')
  String get totalQtyRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'wastage_pct')
  String get wastagePct => throw _privateConstructorUsedError;

  /// Serializes this BomPreviewLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BomPreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BomPreviewLineModelCopyWith<BomPreviewLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BomPreviewLineModelCopyWith<$Res> {
  factory $BomPreviewLineModelCopyWith(
    BomPreviewLineModel value,
    $Res Function(BomPreviewLineModel) then,
  ) = _$BomPreviewLineModelCopyWithImpl<$Res, BomPreviewLineModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ingredient_product_id') String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name') String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,
    @JsonKey(name: 'qty_per_output_unit') String qtyPerOutputUnit,
    @JsonKey(name: 'total_qty_required') String totalQtyRequired,
    @JsonKey(name: 'wastage_pct') String wastagePct,
  });
}

/// @nodoc
class _$BomPreviewLineModelCopyWithImpl<$Res, $Val extends BomPreviewLineModel>
    implements $BomPreviewLineModelCopyWith<$Res> {
  _$BomPreviewLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BomPreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientProductId = null,
    Object? ingredientProductName = null,
    Object? ingredientVariationId = freezed,
    Object? qtyPerOutputUnit = null,
    Object? totalQtyRequired = null,
    Object? wastagePct = null,
  }) {
    return _then(
      _value.copyWith(
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
            qtyPerOutputUnit: null == qtyPerOutputUnit
                ? _value.qtyPerOutputUnit
                : qtyPerOutputUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQtyRequired: null == totalQtyRequired
                ? _value.totalQtyRequired
                : totalQtyRequired // ignore: cast_nullable_to_non_nullable
                      as String,
            wastagePct: null == wastagePct
                ? _value.wastagePct
                : wastagePct // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BomPreviewLineModelImplCopyWith<$Res>
    implements $BomPreviewLineModelCopyWith<$Res> {
  factory _$$BomPreviewLineModelImplCopyWith(
    _$BomPreviewLineModelImpl value,
    $Res Function(_$BomPreviewLineModelImpl) then,
  ) = __$$BomPreviewLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ingredient_product_id') String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name') String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') String? ingredientVariationId,
    @JsonKey(name: 'qty_per_output_unit') String qtyPerOutputUnit,
    @JsonKey(name: 'total_qty_required') String totalQtyRequired,
    @JsonKey(name: 'wastage_pct') String wastagePct,
  });
}

/// @nodoc
class __$$BomPreviewLineModelImplCopyWithImpl<$Res>
    extends _$BomPreviewLineModelCopyWithImpl<$Res, _$BomPreviewLineModelImpl>
    implements _$$BomPreviewLineModelImplCopyWith<$Res> {
  __$$BomPreviewLineModelImplCopyWithImpl(
    _$BomPreviewLineModelImpl _value,
    $Res Function(_$BomPreviewLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BomPreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientProductId = null,
    Object? ingredientProductName = null,
    Object? ingredientVariationId = freezed,
    Object? qtyPerOutputUnit = null,
    Object? totalQtyRequired = null,
    Object? wastagePct = null,
  }) {
    return _then(
      _$BomPreviewLineModelImpl(
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
        qtyPerOutputUnit: null == qtyPerOutputUnit
            ? _value.qtyPerOutputUnit
            : qtyPerOutputUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQtyRequired: null == totalQtyRequired
            ? _value.totalQtyRequired
            : totalQtyRequired // ignore: cast_nullable_to_non_nullable
                  as String,
        wastagePct: null == wastagePct
            ? _value.wastagePct
            : wastagePct // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BomPreviewLineModelImpl implements _BomPreviewLineModel {
  const _$BomPreviewLineModelImpl({
    @JsonKey(name: 'ingredient_product_id') required this.ingredientProductId,
    @JsonKey(name: 'ingredient_product_name')
    required this.ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id') this.ingredientVariationId,
    @JsonKey(name: 'qty_per_output_unit') required this.qtyPerOutputUnit,
    @JsonKey(name: 'total_qty_required') required this.totalQtyRequired,
    @JsonKey(name: 'wastage_pct') this.wastagePct = '0',
  });

  factory _$BomPreviewLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BomPreviewLineModelImplFromJson(json);

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
  @JsonKey(name: 'qty_per_output_unit')
  final String qtyPerOutputUnit;
  @override
  @JsonKey(name: 'total_qty_required')
  final String totalQtyRequired;
  @override
  @JsonKey(name: 'wastage_pct')
  final String wastagePct;

  @override
  String toString() {
    return 'BomPreviewLineModel(ingredientProductId: $ingredientProductId, ingredientProductName: $ingredientProductName, ingredientVariationId: $ingredientVariationId, qtyPerOutputUnit: $qtyPerOutputUnit, totalQtyRequired: $totalQtyRequired, wastagePct: $wastagePct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BomPreviewLineModelImpl &&
            (identical(other.ingredientProductId, ingredientProductId) ||
                other.ingredientProductId == ingredientProductId) &&
            (identical(other.ingredientProductName, ingredientProductName) ||
                other.ingredientProductName == ingredientProductName) &&
            (identical(other.ingredientVariationId, ingredientVariationId) ||
                other.ingredientVariationId == ingredientVariationId) &&
            (identical(other.qtyPerOutputUnit, qtyPerOutputUnit) ||
                other.qtyPerOutputUnit == qtyPerOutputUnit) &&
            (identical(other.totalQtyRequired, totalQtyRequired) ||
                other.totalQtyRequired == totalQtyRequired) &&
            (identical(other.wastagePct, wastagePct) ||
                other.wastagePct == wastagePct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ingredientProductId,
    ingredientProductName,
    ingredientVariationId,
    qtyPerOutputUnit,
    totalQtyRequired,
    wastagePct,
  );

  /// Create a copy of BomPreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BomPreviewLineModelImplCopyWith<_$BomPreviewLineModelImpl> get copyWith =>
      __$$BomPreviewLineModelImplCopyWithImpl<_$BomPreviewLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BomPreviewLineModelImplToJson(this);
  }
}

abstract class _BomPreviewLineModel implements BomPreviewLineModel {
  const factory _BomPreviewLineModel({
    @JsonKey(name: 'ingredient_product_id')
    required final String ingredientProductId,
    @JsonKey(name: 'ingredient_product_name')
    required final String ingredientProductName,
    @JsonKey(name: 'ingredient_variation_id')
    final String? ingredientVariationId,
    @JsonKey(name: 'qty_per_output_unit')
    required final String qtyPerOutputUnit,
    @JsonKey(name: 'total_qty_required') required final String totalQtyRequired,
    @JsonKey(name: 'wastage_pct') final String wastagePct,
  }) = _$BomPreviewLineModelImpl;

  factory _BomPreviewLineModel.fromJson(Map<String, dynamic> json) =
      _$BomPreviewLineModelImpl.fromJson;

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
  @JsonKey(name: 'qty_per_output_unit')
  String get qtyPerOutputUnit;
  @override
  @JsonKey(name: 'total_qty_required')
  String get totalQtyRequired;
  @override
  @JsonKey(name: 'wastage_pct')
  String get wastagePct;

  /// Create a copy of BomPreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BomPreviewLineModelImplCopyWith<_$BomPreviewLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BomPreviewModel _$BomPreviewModelFromJson(Map<String, dynamic> json) {
  return _BomPreviewModel.fromJson(json);
}

/// @nodoc
mixin _$BomPreviewModel {
  @JsonKey(name: 'bom_header_id')
  String get bomHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'output_qty')
  String get outputQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_to_produce')
  String get qtyToProduce => throw _privateConstructorUsedError;
  List<BomPreviewLineModel> get lines => throw _privateConstructorUsedError;

  /// Serializes this BomPreviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BomPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BomPreviewModelCopyWith<BomPreviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BomPreviewModelCopyWith<$Res> {
  factory $BomPreviewModelCopyWith(
    BomPreviewModel value,
    $Res Function(BomPreviewModel) then,
  ) = _$BomPreviewModelCopyWithImpl<$Res, BomPreviewModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'bom_header_id') String bomHeaderId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'output_qty') String outputQty,
    @JsonKey(name: 'qty_to_produce') String qtyToProduce,
    List<BomPreviewLineModel> lines,
  });
}

/// @nodoc
class _$BomPreviewModelCopyWithImpl<$Res, $Val extends BomPreviewModel>
    implements $BomPreviewModelCopyWith<$Res> {
  _$BomPreviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BomPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bomHeaderId = null,
    Object? productId = null,
    Object? outputQty = null,
    Object? qtyToProduce = null,
    Object? lines = null,
  }) {
    return _then(
      _value.copyWith(
            bomHeaderId: null == bomHeaderId
                ? _value.bomHeaderId
                : bomHeaderId // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            outputQty: null == outputQty
                ? _value.outputQty
                : outputQty // ignore: cast_nullable_to_non_nullable
                      as String,
            qtyToProduce: null == qtyToProduce
                ? _value.qtyToProduce
                : qtyToProduce // ignore: cast_nullable_to_non_nullable
                      as String,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<BomPreviewLineModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BomPreviewModelImplCopyWith<$Res>
    implements $BomPreviewModelCopyWith<$Res> {
  factory _$$BomPreviewModelImplCopyWith(
    _$BomPreviewModelImpl value,
    $Res Function(_$BomPreviewModelImpl) then,
  ) = __$$BomPreviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'bom_header_id') String bomHeaderId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'output_qty') String outputQty,
    @JsonKey(name: 'qty_to_produce') String qtyToProduce,
    List<BomPreviewLineModel> lines,
  });
}

/// @nodoc
class __$$BomPreviewModelImplCopyWithImpl<$Res>
    extends _$BomPreviewModelCopyWithImpl<$Res, _$BomPreviewModelImpl>
    implements _$$BomPreviewModelImplCopyWith<$Res> {
  __$$BomPreviewModelImplCopyWithImpl(
    _$BomPreviewModelImpl _value,
    $Res Function(_$BomPreviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BomPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bomHeaderId = null,
    Object? productId = null,
    Object? outputQty = null,
    Object? qtyToProduce = null,
    Object? lines = null,
  }) {
    return _then(
      _$BomPreviewModelImpl(
        bomHeaderId: null == bomHeaderId
            ? _value.bomHeaderId
            : bomHeaderId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        outputQty: null == outputQty
            ? _value.outputQty
            : outputQty // ignore: cast_nullable_to_non_nullable
                  as String,
        qtyToProduce: null == qtyToProduce
            ? _value.qtyToProduce
            : qtyToProduce // ignore: cast_nullable_to_non_nullable
                  as String,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<BomPreviewLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BomPreviewModelImpl implements _BomPreviewModel {
  const _$BomPreviewModelImpl({
    @JsonKey(name: 'bom_header_id') required this.bomHeaderId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'output_qty') required this.outputQty,
    @JsonKey(name: 'qty_to_produce') required this.qtyToProduce,
    final List<BomPreviewLineModel> lines = const [],
  }) : _lines = lines;

  factory _$BomPreviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BomPreviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'bom_header_id')
  final String bomHeaderId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'output_qty')
  final String outputQty;
  @override
  @JsonKey(name: 'qty_to_produce')
  final String qtyToProduce;
  final List<BomPreviewLineModel> _lines;
  @override
  @JsonKey()
  List<BomPreviewLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'BomPreviewModel(bomHeaderId: $bomHeaderId, productId: $productId, outputQty: $outputQty, qtyToProduce: $qtyToProduce, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BomPreviewModelImpl &&
            (identical(other.bomHeaderId, bomHeaderId) ||
                other.bomHeaderId == bomHeaderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.outputQty, outputQty) ||
                other.outputQty == outputQty) &&
            (identical(other.qtyToProduce, qtyToProduce) ||
                other.qtyToProduce == qtyToProduce) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bomHeaderId,
    productId,
    outputQty,
    qtyToProduce,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of BomPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BomPreviewModelImplCopyWith<_$BomPreviewModelImpl> get copyWith =>
      __$$BomPreviewModelImplCopyWithImpl<_$BomPreviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BomPreviewModelImplToJson(this);
  }
}

abstract class _BomPreviewModel implements BomPreviewModel {
  const factory _BomPreviewModel({
    @JsonKey(name: 'bom_header_id') required final String bomHeaderId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'output_qty') required final String outputQty,
    @JsonKey(name: 'qty_to_produce') required final String qtyToProduce,
    final List<BomPreviewLineModel> lines,
  }) = _$BomPreviewModelImpl;

  factory _BomPreviewModel.fromJson(Map<String, dynamic> json) =
      _$BomPreviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'bom_header_id')
  String get bomHeaderId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'output_qty')
  String get outputQty;
  @override
  @JsonKey(name: 'qty_to_produce')
  String get qtyToProduce;
  @override
  List<BomPreviewLineModel> get lines;

  /// Create a copy of BomPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BomPreviewModelImplCopyWith<_$BomPreviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
