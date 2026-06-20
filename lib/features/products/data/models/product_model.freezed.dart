// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_type')
  String get productType => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracking_type')
  String get trackingType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_sellable')
  bool get isSellable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_purchasable')
  bool get isPurchasable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'shelf_life_days')
  int? get shelfLifeDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock_level')
  String? get minStockLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_stock_level')
  String? get maxStockLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  CategoryModel? get category => throw _privateConstructorUsedError;
  BrandModel? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_unit')
  UnitModel? get baseUnit => throw _privateConstructorUsedError;
  List<VariationModel> get variations => throw _privateConstructorUsedError;
  List<BarcodeModel> get barcodes => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    String? sku,
    @JsonKey(name: 'product_type') String productType,
    @JsonKey(name: 'tracking_type') String trackingType,
    @JsonKey(name: 'is_sellable') bool isSellable,
    @JsonKey(name: 'is_purchasable') bool isPurchasable,
    @JsonKey(name: 'is_active') bool isActive,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'shelf_life_days') int? shelfLifeDays,
    @JsonKey(name: 'min_stock_level') String? minStockLevel,
    @JsonKey(name: 'max_stock_level') String? maxStockLevel,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    CategoryModel? category,
    BrandModel? brand,
    @JsonKey(name: 'base_unit') UnitModel? baseUnit,
    List<VariationModel> variations,
    List<BarcodeModel> barcodes,
  });

  $CategoryModelCopyWith<$Res>? get category;
  $BrandModelCopyWith<$Res>? get brand;
  $UnitModelCopyWith<$Res>? get baseUnit;
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? productType = null,
    Object? trackingType = null,
    Object? isSellable = null,
    Object? isPurchasable = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? shelfLifeDays = freezed,
    Object? minStockLevel = freezed,
    Object? maxStockLevel = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? baseUnit = freezed,
    Object? variations = null,
    Object? barcodes = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String?,
            productType: null == productType
                ? _value.productType
                : productType // ignore: cast_nullable_to_non_nullable
                      as String,
            trackingType: null == trackingType
                ? _value.trackingType
                : trackingType // ignore: cast_nullable_to_non_nullable
                      as String,
            isSellable: null == isSellable
                ? _value.isSellable
                : isSellable // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPurchasable: null == isPurchasable
                ? _value.isPurchasable
                : isPurchasable // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            shelfLifeDays: freezed == shelfLifeDays
                ? _value.shelfLifeDays
                : shelfLifeDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            minStockLevel: freezed == minStockLevel
                ? _value.minStockLevel
                : minStockLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxStockLevel: freezed == maxStockLevel
                ? _value.maxStockLevel
                : maxStockLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CategoryModel?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as BrandModel?,
            baseUnit: freezed == baseUnit
                ? _value.baseUnit
                : baseUnit // ignore: cast_nullable_to_non_nullable
                      as UnitModel?,
            variations: null == variations
                ? _value.variations
                : variations // ignore: cast_nullable_to_non_nullable
                      as List<VariationModel>,
            barcodes: null == barcodes
                ? _value.barcodes
                : barcodes // ignore: cast_nullable_to_non_nullable
                      as List<BarcodeModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandModelCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $BrandModelCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnitModelCopyWith<$Res>? get baseUnit {
    if (_value.baseUnit == null) {
      return null;
    }

    return $UnitModelCopyWith<$Res>(_value.baseUnit!, (value) {
      return _then(_value.copyWith(baseUnit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    String? sku,
    @JsonKey(name: 'product_type') String productType,
    @JsonKey(name: 'tracking_type') String trackingType,
    @JsonKey(name: 'is_sellable') bool isSellable,
    @JsonKey(name: 'is_purchasable') bool isPurchasable,
    @JsonKey(name: 'is_active') bool isActive,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'shelf_life_days') int? shelfLifeDays,
    @JsonKey(name: 'min_stock_level') String? minStockLevel,
    @JsonKey(name: 'max_stock_level') String? maxStockLevel,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    CategoryModel? category,
    BrandModel? brand,
    @JsonKey(name: 'base_unit') UnitModel? baseUnit,
    List<VariationModel> variations,
    List<BarcodeModel> barcodes,
  });

  @override
  $CategoryModelCopyWith<$Res>? get category;
  @override
  $BrandModelCopyWith<$Res>? get brand;
  @override
  $UnitModelCopyWith<$Res>? get baseUnit;
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? productType = null,
    Object? trackingType = null,
    Object? isSellable = null,
    Object? isPurchasable = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? shelfLifeDays = freezed,
    Object? minStockLevel = freezed,
    Object? maxStockLevel = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? baseUnit = freezed,
    Object? variations = null,
    Object? barcodes = null,
  }) {
    return _then(
      _$ProductModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: freezed == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String?,
        productType: null == productType
            ? _value.productType
            : productType // ignore: cast_nullable_to_non_nullable
                  as String,
        trackingType: null == trackingType
            ? _value.trackingType
            : trackingType // ignore: cast_nullable_to_non_nullable
                  as String,
        isSellable: null == isSellable
            ? _value.isSellable
            : isSellable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPurchasable: null == isPurchasable
            ? _value.isPurchasable
            : isPurchasable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        shelfLifeDays: freezed == shelfLifeDays
            ? _value.shelfLifeDays
            : shelfLifeDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        minStockLevel: freezed == minStockLevel
            ? _value.minStockLevel
            : minStockLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxStockLevel: freezed == maxStockLevel
            ? _value.maxStockLevel
            : maxStockLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryModel?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as BrandModel?,
        baseUnit: freezed == baseUnit
            ? _value.baseUnit
            : baseUnit // ignore: cast_nullable_to_non_nullable
                  as UnitModel?,
        variations: null == variations
            ? _value._variations
            : variations // ignore: cast_nullable_to_non_nullable
                  as List<VariationModel>,
        barcodes: null == barcodes
            ? _value._barcodes
            : barcodes // ignore: cast_nullable_to_non_nullable
                  as List<BarcodeModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    this.sku,
    @JsonKey(name: 'product_type') required this.productType,
    @JsonKey(name: 'tracking_type') required this.trackingType,
    @JsonKey(name: 'is_sellable') this.isSellable = true,
    @JsonKey(name: 'is_purchasable') this.isPurchasable = true,
    @JsonKey(name: 'is_active') this.isActive = true,
    this.description,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'shelf_life_days') this.shelfLifeDays,
    @JsonKey(name: 'min_stock_level') this.minStockLevel,
    @JsonKey(name: 'max_stock_level') this.maxStockLevel,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    this.category,
    this.brand,
    @JsonKey(name: 'base_unit') this.baseUnit,
    final List<VariationModel> variations = const [],
    final List<BarcodeModel> barcodes = const [],
  }) : _variations = variations,
       _barcodes = barcodes;

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  final String? sku;
  @override
  @JsonKey(name: 'product_type')
  final String productType;
  @override
  @JsonKey(name: 'tracking_type')
  final String trackingType;
  @override
  @JsonKey(name: 'is_sellable')
  final bool isSellable;
  @override
  @JsonKey(name: 'is_purchasable')
  final bool isPurchasable;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'shelf_life_days')
  final int? shelfLifeDays;
  @override
  @JsonKey(name: 'min_stock_level')
  final String? minStockLevel;
  @override
  @JsonKey(name: 'max_stock_level')
  final String? maxStockLevel;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  final CategoryModel? category;
  @override
  final BrandModel? brand;
  @override
  @JsonKey(name: 'base_unit')
  final UnitModel? baseUnit;
  final List<VariationModel> _variations;
  @override
  @JsonKey()
  List<VariationModel> get variations {
    if (_variations is EqualUnmodifiableListView) return _variations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variations);
  }

  final List<BarcodeModel> _barcodes;
  @override
  @JsonKey()
  List<BarcodeModel> get barcodes {
    if (_barcodes is EqualUnmodifiableListView) return _barcodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_barcodes);
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, businessId: $businessId, name: $name, sku: $sku, productType: $productType, trackingType: $trackingType, isSellable: $isSellable, isPurchasable: $isPurchasable, isActive: $isActive, description: $description, imageUrl: $imageUrl, shelfLifeDays: $shelfLifeDays, minStockLevel: $minStockLevel, maxStockLevel: $maxStockLevel, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, brand: $brand, baseUnit: $baseUnit, variations: $variations, barcodes: $barcodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.trackingType, trackingType) ||
                other.trackingType == trackingType) &&
            (identical(other.isSellable, isSellable) ||
                other.isSellable == isSellable) &&
            (identical(other.isPurchasable, isPurchasable) ||
                other.isPurchasable == isPurchasable) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.shelfLifeDays, shelfLifeDays) ||
                other.shelfLifeDays == shelfLifeDays) &&
            (identical(other.minStockLevel, minStockLevel) ||
                other.minStockLevel == minStockLevel) &&
            (identical(other.maxStockLevel, maxStockLevel) ||
                other.maxStockLevel == maxStockLevel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.baseUnit, baseUnit) ||
                other.baseUnit == baseUnit) &&
            const DeepCollectionEquality().equals(
              other._variations,
              _variations,
            ) &&
            const DeepCollectionEquality().equals(other._barcodes, _barcodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    name,
    sku,
    productType,
    trackingType,
    isSellable,
    isPurchasable,
    isActive,
    description,
    imageUrl,
    shelfLifeDays,
    minStockLevel,
    maxStockLevel,
    createdAt,
    updatedAt,
    category,
    brand,
    baseUnit,
    const DeepCollectionEquality().hash(_variations),
    const DeepCollectionEquality().hash(_barcodes),
  ]);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    final String? sku,
    @JsonKey(name: 'product_type') required final String productType,
    @JsonKey(name: 'tracking_type') required final String trackingType,
    @JsonKey(name: 'is_sellable') final bool isSellable,
    @JsonKey(name: 'is_purchasable') final bool isPurchasable,
    @JsonKey(name: 'is_active') final bool isActive,
    final String? description,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'shelf_life_days') final int? shelfLifeDays,
    @JsonKey(name: 'min_stock_level') final String? minStockLevel,
    @JsonKey(name: 'max_stock_level') final String? maxStockLevel,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final CategoryModel? category,
    final BrandModel? brand,
    @JsonKey(name: 'base_unit') final UnitModel? baseUnit,
    final List<VariationModel> variations,
    final List<BarcodeModel> barcodes,
  }) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  String? get sku;
  @override
  @JsonKey(name: 'product_type')
  String get productType;
  @override
  @JsonKey(name: 'tracking_type')
  String get trackingType;
  @override
  @JsonKey(name: 'is_sellable')
  bool get isSellable;
  @override
  @JsonKey(name: 'is_purchasable')
  bool get isPurchasable;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'shelf_life_days')
  int? get shelfLifeDays;
  @override
  @JsonKey(name: 'min_stock_level')
  String? get minStockLevel;
  @override
  @JsonKey(name: 'max_stock_level')
  String? get maxStockLevel;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  CategoryModel? get category;
  @override
  BrandModel? get brand;
  @override
  @JsonKey(name: 'base_unit')
  UnitModel? get baseUnit;
  @override
  List<VariationModel> get variations;
  @override
  List<BarcodeModel> get barcodes;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
