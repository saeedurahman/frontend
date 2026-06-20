// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductListItemModel _$ProductListItemModelFromJson(Map<String, dynamic> json) {
  return _ProductListItemModel.fromJson(json);
}

/// @nodoc
mixin _$ProductListItemModel {
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
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_id')
  String? get brandId => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;

  /// Serializes this ProductListItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductListItemModelCopyWith<ProductListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductListItemModelCopyWith<$Res> {
  factory $ProductListItemModelCopyWith(
    ProductListItemModel value,
    $Res Function(ProductListItemModel) then,
  ) = _$ProductListItemModelCopyWithImpl<$Res, ProductListItemModel>;
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
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? categoryName,
    String? brandName,
  });
}

/// @nodoc
class _$ProductListItemModelCopyWithImpl<
  $Res,
  $Val extends ProductListItemModel
>
    implements $ProductListItemModelCopyWith<$Res> {
  _$ProductListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductListItemModel
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
    Object? categoryId = freezed,
    Object? brandId = freezed,
    Object? imageUrl = freezed,
    Object? categoryName = freezed,
    Object? brandName = freezed,
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
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandId: freezed == brandId
                ? _value.brandId
                : brandId // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryName: freezed == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandName: freezed == brandName
                ? _value.brandName
                : brandName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductListItemModelImplCopyWith<$Res>
    implements $ProductListItemModelCopyWith<$Res> {
  factory _$$ProductListItemModelImplCopyWith(
    _$ProductListItemModelImpl value,
    $Res Function(_$ProductListItemModelImpl) then,
  ) = __$$ProductListItemModelImplCopyWithImpl<$Res>;
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
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? categoryName,
    String? brandName,
  });
}

/// @nodoc
class __$$ProductListItemModelImplCopyWithImpl<$Res>
    extends _$ProductListItemModelCopyWithImpl<$Res, _$ProductListItemModelImpl>
    implements _$$ProductListItemModelImplCopyWith<$Res> {
  __$$ProductListItemModelImplCopyWithImpl(
    _$ProductListItemModelImpl _value,
    $Res Function(_$ProductListItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductListItemModel
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
    Object? categoryId = freezed,
    Object? brandId = freezed,
    Object? imageUrl = freezed,
    Object? categoryName = freezed,
    Object? brandName = freezed,
  }) {
    return _then(
      _$ProductListItemModelImpl(
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
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandId: freezed == brandId
            ? _value.brandId
            : brandId // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryName: freezed == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandName: freezed == brandName
            ? _value.brandName
            : brandName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductListItemModelImpl implements _ProductListItemModel {
  const _$ProductListItemModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    this.sku,
    @JsonKey(name: 'product_type') required this.productType,
    @JsonKey(name: 'tracking_type') required this.trackingType,
    @JsonKey(name: 'is_sellable') this.isSellable = true,
    @JsonKey(name: 'is_purchasable') this.isPurchasable = true,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'category_id') this.categoryId,
    @JsonKey(name: 'brand_id') this.brandId,
    @JsonKey(name: 'image_url') this.imageUrl,
    this.categoryName,
    this.brandName,
  });

  factory _$ProductListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductListItemModelImplFromJson(json);

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
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'brand_id')
  final String? brandId;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String? categoryName;
  @override
  final String? brandName;

  @override
  String toString() {
    return 'ProductListItemModel(id: $id, businessId: $businessId, name: $name, sku: $sku, productType: $productType, trackingType: $trackingType, isSellable: $isSellable, isPurchasable: $isPurchasable, isActive: $isActive, categoryId: $categoryId, brandId: $brandId, imageUrl: $imageUrl, categoryName: $categoryName, brandName: $brandName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductListItemModelImpl &&
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
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
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
    categoryId,
    brandId,
    imageUrl,
    categoryName,
    brandName,
  );

  /// Create a copy of ProductListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductListItemModelImplCopyWith<_$ProductListItemModelImpl>
  get copyWith =>
      __$$ProductListItemModelImplCopyWithImpl<_$ProductListItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductListItemModelImplToJson(this);
  }
}

abstract class _ProductListItemModel implements ProductListItemModel {
  const factory _ProductListItemModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    final String? sku,
    @JsonKey(name: 'product_type') required final String productType,
    @JsonKey(name: 'tracking_type') required final String trackingType,
    @JsonKey(name: 'is_sellable') final bool isSellable,
    @JsonKey(name: 'is_purchasable') final bool isPurchasable,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'category_id') final String? categoryId,
    @JsonKey(name: 'brand_id') final String? brandId,
    @JsonKey(name: 'image_url') final String? imageUrl,
    final String? categoryName,
    final String? brandName,
  }) = _$ProductListItemModelImpl;

  factory _ProductListItemModel.fromJson(Map<String, dynamic> json) =
      _$ProductListItemModelImpl.fromJson;

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
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'brand_id')
  String? get brandId;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String? get categoryName;
  @override
  String? get brandName;

  /// Create a copy of ProductListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductListItemModelImplCopyWith<_$ProductListItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
