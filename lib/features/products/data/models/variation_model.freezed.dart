// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VariationModel _$VariationModelFromJson(Map<String, dynamic> json) {
  return _VariationModel.fromJson(json);
}

/// @nodoc
mixin _$VariationModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String? get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_grams')
  String? get weightGrams => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  List<BarcodeModel> get barcodes => throw _privateConstructorUsedError;
  UnitModel? get unit => throw _privateConstructorUsedError;

  /// Serializes this VariationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VariationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariationModelCopyWith<VariationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariationModelCopyWith<$Res> {
  factory $VariationModelCopyWith(
    VariationModel value,
    $Res Function(VariationModel) then,
  ) = _$VariationModelCopyWithImpl<$Res, VariationModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'product_id') String productId,
    String name,
    String? sku,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'weight_grams') String? weightGrams,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    List<BarcodeModel> barcodes,
    UnitModel? unit,
  });

  $UnitModelCopyWith<$Res>? get unit;
}

/// @nodoc
class _$VariationModelCopyWithImpl<$Res, $Val extends VariationModel>
    implements $VariationModelCopyWith<$Res> {
  _$VariationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VariationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? productId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? unitId = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? weightGrams = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? barcodes = null,
    Object? unit = freezed,
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
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitId: freezed == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            weightGrams: freezed == weightGrams
                ? _value.weightGrams
                : weightGrams // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcodes: null == barcodes
                ? _value.barcodes
                : barcodes // ignore: cast_nullable_to_non_nullable
                      as List<BarcodeModel>,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as UnitModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of VariationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnitModelCopyWith<$Res>? get unit {
    if (_value.unit == null) {
      return null;
    }

    return $UnitModelCopyWith<$Res>(_value.unit!, (value) {
      return _then(_value.copyWith(unit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VariationModelImplCopyWith<$Res>
    implements $VariationModelCopyWith<$Res> {
  factory _$$VariationModelImplCopyWith(
    _$VariationModelImpl value,
    $Res Function(_$VariationModelImpl) then,
  ) = __$$VariationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'product_id') String productId,
    String name,
    String? sku,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'weight_grams') String? weightGrams,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    List<BarcodeModel> barcodes,
    UnitModel? unit,
  });

  @override
  $UnitModelCopyWith<$Res>? get unit;
}

/// @nodoc
class __$$VariationModelImplCopyWithImpl<$Res>
    extends _$VariationModelCopyWithImpl<$Res, _$VariationModelImpl>
    implements _$$VariationModelImplCopyWith<$Res> {
  __$$VariationModelImplCopyWithImpl(
    _$VariationModelImpl _value,
    $Res Function(_$VariationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VariationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? productId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? unitId = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? weightGrams = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? barcodes = null,
    Object? unit = freezed,
  }) {
    return _then(
      _$VariationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: freezed == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitId: freezed == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        weightGrams: freezed == weightGrams
            ? _value.weightGrams
            : weightGrams // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcodes: null == barcodes
            ? _value._barcodes
            : barcodes // ignore: cast_nullable_to_non_nullable
                  as List<BarcodeModel>,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as UnitModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VariationModelImpl implements _VariationModel {
  const _$VariationModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'product_id') required this.productId,
    required this.name,
    this.sku,
    @JsonKey(name: 'unit_id') this.unitId,
    @JsonKey(name: 'is_default') this.isDefault = false,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'weight_grams') this.weightGrams,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    final List<BarcodeModel> barcodes = const [],
    this.unit,
  }) : _barcodes = barcodes;

  factory _$VariationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariationModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  final String name;
  @override
  final String? sku;
  @override
  @JsonKey(name: 'unit_id')
  final String? unitId;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'weight_grams')
  final String? weightGrams;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final List<BarcodeModel> _barcodes;
  @override
  @JsonKey()
  List<BarcodeModel> get barcodes {
    if (_barcodes is EqualUnmodifiableListView) return _barcodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_barcodes);
  }

  @override
  final UnitModel? unit;

  @override
  String toString() {
    return 'VariationModel(id: $id, businessId: $businessId, productId: $productId, name: $name, sku: $sku, unitId: $unitId, isDefault: $isDefault, isActive: $isActive, weightGrams: $weightGrams, createdAt: $createdAt, updatedAt: $updatedAt, barcodes: $barcodes, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._barcodes, _barcodes) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    productId,
    name,
    sku,
    unitId,
    isDefault,
    isActive,
    weightGrams,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_barcodes),
    unit,
  );

  /// Create a copy of VariationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariationModelImplCopyWith<_$VariationModelImpl> get copyWith =>
      __$$VariationModelImplCopyWithImpl<_$VariationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VariationModelImplToJson(this);
  }
}

abstract class _VariationModel implements VariationModel {
  const factory _VariationModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'product_id') required final String productId,
    required final String name,
    final String? sku,
    @JsonKey(name: 'unit_id') final String? unitId,
    @JsonKey(name: 'is_default') final bool isDefault,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'weight_grams') final String? weightGrams,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final List<BarcodeModel> barcodes,
    final UnitModel? unit,
  }) = _$VariationModelImpl;

  factory _VariationModel.fromJson(Map<String, dynamic> json) =
      _$VariationModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  String get name;
  @override
  String? get sku;
  @override
  @JsonKey(name: 'unit_id')
  String? get unitId;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'weight_grams')
  String? get weightGrams;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  List<BarcodeModel> get barcodes;
  @override
  UnitModel? get unit;

  /// Create a copy of VariationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariationModelImplCopyWith<_$VariationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
