// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductionOrderBomSummaryModel _$ProductionOrderBomSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductionOrderBomSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ProductionOrderBomSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'output_qty')
  String get outputQty => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this ProductionOrderBomSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductionOrderBomSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionOrderBomSummaryModelCopyWith<ProductionOrderBomSummaryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionOrderBomSummaryModelCopyWith<$Res> {
  factory $ProductionOrderBomSummaryModelCopyWith(
    ProductionOrderBomSummaryModel value,
    $Res Function(ProductionOrderBomSummaryModel) then,
  ) =
      _$ProductionOrderBomSummaryModelCopyWithImpl<
        $Res,
        ProductionOrderBomSummaryModel
      >;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'output_qty') String outputQty,
    int version,
  });
}

/// @nodoc
class _$ProductionOrderBomSummaryModelCopyWithImpl<
  $Res,
  $Val extends ProductionOrderBomSummaryModel
>
    implements $ProductionOrderBomSummaryModelCopyWith<$Res> {
  _$ProductionOrderBomSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionOrderBomSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? outputQty = null,
    Object? version = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            outputQty: null == outputQty
                ? _value.outputQty
                : outputQty // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductionOrderBomSummaryModelImplCopyWith<$Res>
    implements $ProductionOrderBomSummaryModelCopyWith<$Res> {
  factory _$$ProductionOrderBomSummaryModelImplCopyWith(
    _$ProductionOrderBomSummaryModelImpl value,
    $Res Function(_$ProductionOrderBomSummaryModelImpl) then,
  ) = __$$ProductionOrderBomSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'output_qty') String outputQty,
    int version,
  });
}

/// @nodoc
class __$$ProductionOrderBomSummaryModelImplCopyWithImpl<$Res>
    extends
        _$ProductionOrderBomSummaryModelCopyWithImpl<
          $Res,
          _$ProductionOrderBomSummaryModelImpl
        >
    implements _$$ProductionOrderBomSummaryModelImplCopyWith<$Res> {
  __$$ProductionOrderBomSummaryModelImplCopyWithImpl(
    _$ProductionOrderBomSummaryModelImpl _value,
    $Res Function(_$ProductionOrderBomSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductionOrderBomSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? outputQty = null,
    Object? version = null,
  }) {
    return _then(
      _$ProductionOrderBomSummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        outputQty: null == outputQty
            ? _value.outputQty
            : outputQty // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionOrderBomSummaryModelImpl
    implements _ProductionOrderBomSummaryModel {
  const _$ProductionOrderBomSummaryModelImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'product_name') required this.productName,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'output_qty') required this.outputQty,
    this.version = 1,
  });

  factory _$ProductionOrderBomSummaryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ProductionOrderBomSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'output_qty')
  final String outputQty;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'ProductionOrderBomSummaryModel(id: $id, name: $name, productId: $productId, productName: $productName, variationId: $variationId, outputQty: $outputQty, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionOrderBomSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.outputQty, outputQty) ||
                other.outputQty == outputQty) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    productId,
    productName,
    variationId,
    outputQty,
    version,
  );

  /// Create a copy of ProductionOrderBomSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionOrderBomSummaryModelImplCopyWith<
    _$ProductionOrderBomSummaryModelImpl
  >
  get copyWith =>
      __$$ProductionOrderBomSummaryModelImplCopyWithImpl<
        _$ProductionOrderBomSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionOrderBomSummaryModelImplToJson(this);
  }
}

abstract class _ProductionOrderBomSummaryModel
    implements ProductionOrderBomSummaryModel {
  const factory _ProductionOrderBomSummaryModel({
    required final String id,
    required final String name,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'product_name') required final String productName,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'output_qty') required final String outputQty,
    final int version,
  }) = _$ProductionOrderBomSummaryModelImpl;

  factory _ProductionOrderBomSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ProductionOrderBomSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'output_qty')
  String get outputQty;
  @override
  int get version;

  /// Create a copy of ProductionOrderBomSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionOrderBomSummaryModelImplCopyWith<
    _$ProductionOrderBomSummaryModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

ProductionLineModel _$ProductionLineModelFromJson(Map<String, dynamic> json) {
  return _ProductionLineModel.fromJson(json);
}

/// @nodoc
mixin _$ProductionLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_consumed')
  String get qtyConsumed => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit => throw _privateConstructorUsedError;

  /// Serializes this ProductionLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionLineModelCopyWith<ProductionLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionLineModelCopyWith<$Res> {
  factory $ProductionLineModelCopyWith(
    ProductionLineModel value,
    $Res Function(ProductionLineModel) then,
  ) = _$ProductionLineModelCopyWithImpl<$Res, ProductionLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_consumed') String qtyConsumed,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
  });
}

/// @nodoc
class _$ProductionLineModelCopyWithImpl<$Res, $Val extends ProductionLineModel>
    implements $ProductionLineModelCopyWith<$Res> {
  _$ProductionLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? qtyConsumed = null,
    Object? costPerUnit = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qtyConsumed: null == qtyConsumed
                ? _value.qtyConsumed
                : qtyConsumed // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerUnit: null == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductionLineModelImplCopyWith<$Res>
    implements $ProductionLineModelCopyWith<$Res> {
  factory _$$ProductionLineModelImplCopyWith(
    _$ProductionLineModelImpl value,
    $Res Function(_$ProductionLineModelImpl) then,
  ) = __$$ProductionLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_consumed') String qtyConsumed,
    @JsonKey(name: 'cost_per_unit') String costPerUnit,
  });
}

/// @nodoc
class __$$ProductionLineModelImplCopyWithImpl<$Res>
    extends _$ProductionLineModelCopyWithImpl<$Res, _$ProductionLineModelImpl>
    implements _$$ProductionLineModelImplCopyWith<$Res> {
  __$$ProductionLineModelImplCopyWithImpl(
    _$ProductionLineModelImpl _value,
    $Res Function(_$ProductionLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? qtyConsumed = null,
    Object? costPerUnit = null,
  }) {
    return _then(
      _$ProductionLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qtyConsumed: null == qtyConsumed
            ? _value.qtyConsumed
            : qtyConsumed // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerUnit: null == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionLineModelImpl implements _ProductionLineModel {
  const _$ProductionLineModelImpl({
    required this.id,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'product_name') required this.productName,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'qty_consumed') required this.qtyConsumed,
    @JsonKey(name: 'cost_per_unit') required this.costPerUnit,
  });

  factory _$ProductionLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'qty_consumed')
  final String qtyConsumed;
  @override
  @JsonKey(name: 'cost_per_unit')
  final String costPerUnit;

  @override
  String toString() {
    return 'ProductionLineModel(id: $id, productId: $productId, productName: $productName, variationId: $variationId, qtyConsumed: $qtyConsumed, costPerUnit: $costPerUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qtyConsumed, qtyConsumed) ||
                other.qtyConsumed == qtyConsumed) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    productName,
    variationId,
    qtyConsumed,
    costPerUnit,
  );

  /// Create a copy of ProductionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionLineModelImplCopyWith<_$ProductionLineModelImpl> get copyWith =>
      __$$ProductionLineModelImplCopyWithImpl<_$ProductionLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionLineModelImplToJson(this);
  }
}

abstract class _ProductionLineModel implements ProductionLineModel {
  const factory _ProductionLineModel({
    required final String id,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'product_name') required final String productName,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'qty_consumed') required final String qtyConsumed,
    @JsonKey(name: 'cost_per_unit') required final String costPerUnit,
  }) = _$ProductionLineModelImpl;

  factory _ProductionLineModel.fromJson(Map<String, dynamic> json) =
      _$ProductionLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'qty_consumed')
  String get qtyConsumed;
  @override
  @JsonKey(name: 'cost_per_unit')
  String get costPerUnit;

  /// Create a copy of ProductionLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionLineModelImplCopyWith<_$ProductionLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductionOrderModel _$ProductionOrderModelFromJson(Map<String, dynamic> json) {
  return _ProductionOrderModel.fromJson(json);
}

/// @nodoc
mixin _$ProductionOrderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bom_header_id')
  String get bomHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'production_number')
  String get productionNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_to_produce')
  String get qtyToProduce => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_produced')
  String get qtyProduced => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  String? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  ProductionOrderBomSummaryModel get bom => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  String? get deletedAt => throw _privateConstructorUsedError;
  List<ProductionLineModel> get lines => throw _privateConstructorUsedError;

  /// Serializes this ProductionOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductionOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionOrderModelCopyWith<ProductionOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionOrderModelCopyWith<$Res> {
  factory $ProductionOrderModelCopyWith(
    ProductionOrderModel value,
    $Res Function(ProductionOrderModel) then,
  ) = _$ProductionOrderModelCopyWithImpl<$Res, ProductionOrderModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'bom_header_id') String bomHeaderId,
    @JsonKey(name: 'production_number') String productionNumber,
    String status,
    @JsonKey(name: 'qty_to_produce') String qtyToProduce,
    @JsonKey(name: 'qty_produced') String qtyProduced,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'completed_at') String? completedAt,
    String? notes,
    ProductionOrderBomSummaryModel bom,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    List<ProductionLineModel> lines,
  });

  $ProductionOrderBomSummaryModelCopyWith<$Res> get bom;
}

/// @nodoc
class _$ProductionOrderModelCopyWithImpl<
  $Res,
  $Val extends ProductionOrderModel
>
    implements $ProductionOrderModelCopyWith<$Res> {
  _$ProductionOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? bomHeaderId = null,
    Object? productionNumber = null,
    Object? status = null,
    Object? qtyToProduce = null,
    Object? qtyProduced = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? bom = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? lines = null,
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
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            bomHeaderId: null == bomHeaderId
                ? _value.bomHeaderId
                : bomHeaderId // ignore: cast_nullable_to_non_nullable
                      as String,
            productionNumber: null == productionNumber
                ? _value.productionNumber
                : productionNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            qtyToProduce: null == qtyToProduce
                ? _value.qtyToProduce
                : qtyToProduce // ignore: cast_nullable_to_non_nullable
                      as String,
            qtyProduced: null == qtyProduced
                ? _value.qtyProduced
                : qtyProduced // ignore: cast_nullable_to_non_nullable
                      as String,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            bom: null == bom
                ? _value.bom
                : bom // ignore: cast_nullable_to_non_nullable
                      as ProductionOrderBomSummaryModel,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<ProductionLineModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductionOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductionOrderBomSummaryModelCopyWith<$Res> get bom {
    return $ProductionOrderBomSummaryModelCopyWith<$Res>(_value.bom, (value) {
      return _then(_value.copyWith(bom: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductionOrderModelImplCopyWith<$Res>
    implements $ProductionOrderModelCopyWith<$Res> {
  factory _$$ProductionOrderModelImplCopyWith(
    _$ProductionOrderModelImpl value,
    $Res Function(_$ProductionOrderModelImpl) then,
  ) = __$$ProductionOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'bom_header_id') String bomHeaderId,
    @JsonKey(name: 'production_number') String productionNumber,
    String status,
    @JsonKey(name: 'qty_to_produce') String qtyToProduce,
    @JsonKey(name: 'qty_produced') String qtyProduced,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'completed_at') String? completedAt,
    String? notes,
    ProductionOrderBomSummaryModel bom,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    List<ProductionLineModel> lines,
  });

  @override
  $ProductionOrderBomSummaryModelCopyWith<$Res> get bom;
}

/// @nodoc
class __$$ProductionOrderModelImplCopyWithImpl<$Res>
    extends _$ProductionOrderModelCopyWithImpl<$Res, _$ProductionOrderModelImpl>
    implements _$$ProductionOrderModelImplCopyWith<$Res> {
  __$$ProductionOrderModelImplCopyWithImpl(
    _$ProductionOrderModelImpl _value,
    $Res Function(_$ProductionOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductionOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? bomHeaderId = null,
    Object? productionNumber = null,
    Object? status = null,
    Object? qtyToProduce = null,
    Object? qtyProduced = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? bom = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$ProductionOrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        bomHeaderId: null == bomHeaderId
            ? _value.bomHeaderId
            : bomHeaderId // ignore: cast_nullable_to_non_nullable
                  as String,
        productionNumber: null == productionNumber
            ? _value.productionNumber
            : productionNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        qtyToProduce: null == qtyToProduce
            ? _value.qtyToProduce
            : qtyToProduce // ignore: cast_nullable_to_non_nullable
                  as String,
        qtyProduced: null == qtyProduced
            ? _value.qtyProduced
            : qtyProduced // ignore: cast_nullable_to_non_nullable
                  as String,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        bom: null == bom
            ? _value.bom
            : bom // ignore: cast_nullable_to_non_nullable
                  as ProductionOrderBomSummaryModel,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<ProductionLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionOrderModelImpl implements _ProductionOrderModel {
  const _$ProductionOrderModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'bom_header_id') required this.bomHeaderId,
    @JsonKey(name: 'production_number') required this.productionNumber,
    required this.status,
    @JsonKey(name: 'qty_to_produce') required this.qtyToProduce,
    @JsonKey(name: 'qty_produced') this.qtyProduced = '0',
    @JsonKey(name: 'started_at') this.startedAt,
    @JsonKey(name: 'completed_at') this.completedAt,
    this.notes,
    required this.bom,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'deleted_at') this.deletedAt,
    final List<ProductionLineModel> lines = const [],
  }) : _lines = lines;

  factory _$ProductionOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionOrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'bom_header_id')
  final String bomHeaderId;
  @override
  @JsonKey(name: 'production_number')
  final String productionNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'qty_to_produce')
  final String qtyToProduce;
  @override
  @JsonKey(name: 'qty_produced')
  final String qtyProduced;
  @override
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @override
  final String? notes;
  @override
  final ProductionOrderBomSummaryModel bom;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final List<ProductionLineModel> _lines;
  @override
  @JsonKey()
  List<ProductionLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'ProductionOrderModel(id: $id, businessId: $businessId, branchId: $branchId, bomHeaderId: $bomHeaderId, productionNumber: $productionNumber, status: $status, qtyToProduce: $qtyToProduce, qtyProduced: $qtyProduced, startedAt: $startedAt, completedAt: $completedAt, notes: $notes, bom: $bom, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.bomHeaderId, bomHeaderId) ||
                other.bomHeaderId == bomHeaderId) &&
            (identical(other.productionNumber, productionNumber) ||
                other.productionNumber == productionNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.qtyToProduce, qtyToProduce) ||
                other.qtyToProduce == qtyToProduce) &&
            (identical(other.qtyProduced, qtyProduced) ||
                other.qtyProduced == qtyProduced) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.bom, bom) || other.bom == bom) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    bomHeaderId,
    productionNumber,
    status,
    qtyToProduce,
    qtyProduced,
    startedAt,
    completedAt,
    notes,
    bom,
    createdAt,
    updatedAt,
    deletedAt,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of ProductionOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionOrderModelImplCopyWith<_$ProductionOrderModelImpl>
  get copyWith =>
      __$$ProductionOrderModelImplCopyWithImpl<_$ProductionOrderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionOrderModelImplToJson(this);
  }
}

abstract class _ProductionOrderModel implements ProductionOrderModel {
  const factory _ProductionOrderModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'bom_header_id') required final String bomHeaderId,
    @JsonKey(name: 'production_number') required final String productionNumber,
    required final String status,
    @JsonKey(name: 'qty_to_produce') required final String qtyToProduce,
    @JsonKey(name: 'qty_produced') final String qtyProduced,
    @JsonKey(name: 'started_at') final String? startedAt,
    @JsonKey(name: 'completed_at') final String? completedAt,
    final String? notes,
    required final ProductionOrderBomSummaryModel bom,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'updated_at') required final String updatedAt,
    @JsonKey(name: 'deleted_at') final String? deletedAt,
    final List<ProductionLineModel> lines,
  }) = _$ProductionOrderModelImpl;

  factory _ProductionOrderModel.fromJson(Map<String, dynamic> json) =
      _$ProductionOrderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'bom_header_id')
  String get bomHeaderId;
  @override
  @JsonKey(name: 'production_number')
  String get productionNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'qty_to_produce')
  String get qtyToProduce;
  @override
  @JsonKey(name: 'qty_produced')
  String get qtyProduced;
  @override
  @JsonKey(name: 'started_at')
  String? get startedAt;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  String? get notes;
  @override
  ProductionOrderBomSummaryModel get bom;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  String? get deletedAt;
  @override
  List<ProductionLineModel> get lines;

  /// Create a copy of ProductionOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionOrderModelImplCopyWith<_$ProductionOrderModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
