// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PriceListModel _$PriceListModelFromJson(Map<String, dynamic> json) {
  return _PriceListModel.fromJson(json);
}

/// @nodoc
mixin _$PriceListModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'list_type')
  String get listType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_from')
  String? get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_to')
  String? get validTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this PriceListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceListModelCopyWith<PriceListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceListModelCopyWith<$Res> {
  factory $PriceListModelCopyWith(
    PriceListModel value,
    $Res Function(PriceListModel) then,
  ) = _$PriceListModelCopyWithImpl<$Res, PriceListModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'list_type') String listType,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_to') String? validTo,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$PriceListModelCopyWithImpl<$Res, $Val extends PriceListModel>
    implements $PriceListModelCopyWith<$Res> {
  _$PriceListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? listType = null,
    Object? isDefault = null,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? isActive = null,
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
            listType: null == listType
                ? _value.listType
                : listType // ignore: cast_nullable_to_non_nullable
                      as String,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            validFrom: freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as String?,
            validTo: freezed == validTo
                ? _value.validTo
                : validTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriceListModelImplCopyWith<$Res>
    implements $PriceListModelCopyWith<$Res> {
  factory _$$PriceListModelImplCopyWith(
    _$PriceListModelImpl value,
    $Res Function(_$PriceListModelImpl) then,
  ) = __$$PriceListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'list_type') String listType,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_to') String? validTo,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$PriceListModelImplCopyWithImpl<$Res>
    extends _$PriceListModelCopyWithImpl<$Res, _$PriceListModelImpl>
    implements _$$PriceListModelImplCopyWith<$Res> {
  __$$PriceListModelImplCopyWithImpl(
    _$PriceListModelImpl _value,
    $Res Function(_$PriceListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? listType = null,
    Object? isDefault = null,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$PriceListModelImpl(
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
        listType: null == listType
            ? _value.listType
            : listType // ignore: cast_nullable_to_non_nullable
                  as String,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        validFrom: freezed == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as String?,
        validTo: freezed == validTo
            ? _value.validTo
            : validTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceListModelImpl implements _PriceListModel {
  const _$PriceListModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    @JsonKey(name: 'list_type') required this.listType,
    @JsonKey(name: 'is_default') this.isDefault = false,
    @JsonKey(name: 'valid_from') this.validFrom,
    @JsonKey(name: 'valid_to') this.validTo,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$PriceListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceListModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  @JsonKey(name: 'list_type')
  final String listType;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'valid_from')
  final String? validFrom;
  @override
  @JsonKey(name: 'valid_to')
  final String? validTo;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'PriceListModel(id: $id, businessId: $businessId, name: $name, listType: $listType, isDefault: $isDefault, validFrom: $validFrom, validTo: $validTo, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceListModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.listType, listType) ||
                other.listType == listType) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validTo, validTo) || other.validTo == validTo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    listType,
    isDefault,
    validFrom,
    validTo,
    isActive,
  );

  /// Create a copy of PriceListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceListModelImplCopyWith<_$PriceListModelImpl> get copyWith =>
      __$$PriceListModelImplCopyWithImpl<_$PriceListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceListModelImplToJson(this);
  }
}

abstract class _PriceListModel implements PriceListModel {
  const factory _PriceListModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    @JsonKey(name: 'list_type') required final String listType,
    @JsonKey(name: 'is_default') final bool isDefault,
    @JsonKey(name: 'valid_from') final String? validFrom,
    @JsonKey(name: 'valid_to') final String? validTo,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$PriceListModelImpl;

  factory _PriceListModel.fromJson(Map<String, dynamic> json) =
      _$PriceListModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  @JsonKey(name: 'list_type')
  String get listType;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'valid_from')
  String? get validFrom;
  @override
  @JsonKey(name: 'valid_to')
  String? get validTo;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of PriceListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceListModelImplCopyWith<_$PriceListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceListItemModel _$PriceListItemModelFromJson(Map<String, dynamic> json) {
  return _PriceListItemModel.fromJson(json);
}

/// @nodoc
mixin _$PriceListItemModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_list_id')
  String get priceListId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  String get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_qty')
  String? get minQty => throw _privateConstructorUsedError;

  /// Serializes this PriceListItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceListItemModelCopyWith<PriceListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceListItemModelCopyWith<$Res> {
  factory $PriceListItemModelCopyWith(
    PriceListItemModel value,
    $Res Function(PriceListItemModel) then,
  ) = _$PriceListItemModelCopyWithImpl<$Res, PriceListItemModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'price_list_id') String priceListId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'min_qty') String? minQty,
  });
}

/// @nodoc
class _$PriceListItemModelCopyWithImpl<$Res, $Val extends PriceListItemModel>
    implements $PriceListItemModelCopyWith<$Res> {
  _$PriceListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? priceListId = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? unitPrice = null,
    Object? minQty = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            priceListId: null == priceListId
                ? _value.priceListId
                : priceListId // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as String,
            minQty: freezed == minQty
                ? _value.minQty
                : minQty // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriceListItemModelImplCopyWith<$Res>
    implements $PriceListItemModelCopyWith<$Res> {
  factory _$$PriceListItemModelImplCopyWith(
    _$PriceListItemModelImpl value,
    $Res Function(_$PriceListItemModelImpl) then,
  ) = __$$PriceListItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'price_list_id') String priceListId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'min_qty') String? minQty,
  });
}

/// @nodoc
class __$$PriceListItemModelImplCopyWithImpl<$Res>
    extends _$PriceListItemModelCopyWithImpl<$Res, _$PriceListItemModelImpl>
    implements _$$PriceListItemModelImplCopyWith<$Res> {
  __$$PriceListItemModelImplCopyWithImpl(
    _$PriceListItemModelImpl _value,
    $Res Function(_$PriceListItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? priceListId = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? unitPrice = null,
    Object? minQty = freezed,
  }) {
    return _then(
      _$PriceListItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        priceListId: null == priceListId
            ? _value.priceListId
            : priceListId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as String,
        minQty: freezed == minQty
            ? _value.minQty
            : minQty // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceListItemModelImpl implements _PriceListItemModel {
  const _$PriceListItemModelImpl({
    required this.id,
    @JsonKey(name: 'price_list_id') required this.priceListId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    @JsonKey(name: 'min_qty') this.minQty,
  });

  factory _$PriceListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceListItemModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'price_list_id')
  final String priceListId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  @JsonKey(name: 'unit_price')
  final String unitPrice;
  @override
  @JsonKey(name: 'min_qty')
  final String? minQty;

  @override
  String toString() {
    return 'PriceListItemModel(id: $id, priceListId: $priceListId, productId: $productId, variationId: $variationId, unitPrice: $unitPrice, minQty: $minQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceListItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priceListId, priceListId) ||
                other.priceListId == priceListId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.minQty, minQty) || other.minQty == minQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    priceListId,
    productId,
    variationId,
    unitPrice,
    minQty,
  );

  /// Create a copy of PriceListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceListItemModelImplCopyWith<_$PriceListItemModelImpl> get copyWith =>
      __$$PriceListItemModelImplCopyWithImpl<_$PriceListItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceListItemModelImplToJson(this);
  }
}

abstract class _PriceListItemModel implements PriceListItemModel {
  const factory _PriceListItemModel({
    required final String id,
    @JsonKey(name: 'price_list_id') required final String priceListId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    @JsonKey(name: 'unit_price') required final String unitPrice,
    @JsonKey(name: 'min_qty') final String? minQty,
  }) = _$PriceListItemModelImpl;

  factory _PriceListItemModel.fromJson(Map<String, dynamic> json) =
      _$PriceListItemModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'price_list_id')
  String get priceListId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  @JsonKey(name: 'unit_price')
  String get unitPrice;
  @override
  @JsonKey(name: 'min_qty')
  String? get minQty;

  /// Create a copy of PriceListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceListItemModelImplCopyWith<_$PriceListItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductPriceModel _$ProductPriceModelFromJson(Map<String, dynamic> json) {
  return _ProductPriceModel.fromJson(json);
}

/// @nodoc
mixin _$ProductPriceModel {
  @JsonKey(name: 'unit_price')
  String? get unitPrice => throw _privateConstructorUsedError;

  /// Serializes this ProductPriceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductPriceModelCopyWith<ProductPriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductPriceModelCopyWith<$Res> {
  factory $ProductPriceModelCopyWith(
    ProductPriceModel value,
    $Res Function(ProductPriceModel) then,
  ) = _$ProductPriceModelCopyWithImpl<$Res, ProductPriceModel>;
  @useResult
  $Res call({@JsonKey(name: 'unit_price') String? unitPrice});
}

/// @nodoc
class _$ProductPriceModelCopyWithImpl<$Res, $Val extends ProductPriceModel>
    implements $ProductPriceModelCopyWith<$Res> {
  _$ProductPriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? unitPrice = freezed}) {
    return _then(
      _value.copyWith(
            unitPrice: freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductPriceModelImplCopyWith<$Res>
    implements $ProductPriceModelCopyWith<$Res> {
  factory _$$ProductPriceModelImplCopyWith(
    _$ProductPriceModelImpl value,
    $Res Function(_$ProductPriceModelImpl) then,
  ) = __$$ProductPriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'unit_price') String? unitPrice});
}

/// @nodoc
class __$$ProductPriceModelImplCopyWithImpl<$Res>
    extends _$ProductPriceModelCopyWithImpl<$Res, _$ProductPriceModelImpl>
    implements _$$ProductPriceModelImplCopyWith<$Res> {
  __$$ProductPriceModelImplCopyWithImpl(
    _$ProductPriceModelImpl _value,
    $Res Function(_$ProductPriceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? unitPrice = freezed}) {
    return _then(
      _$ProductPriceModelImpl(
        unitPrice: freezed == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductPriceModelImpl implements _ProductPriceModel {
  const _$ProductPriceModelImpl({@JsonKey(name: 'unit_price') this.unitPrice});

  factory _$ProductPriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductPriceModelImplFromJson(json);

  @override
  @JsonKey(name: 'unit_price')
  final String? unitPrice;

  @override
  String toString() {
    return 'ProductPriceModel(unitPrice: $unitPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductPriceModelImpl &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unitPrice);

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductPriceModelImplCopyWith<_$ProductPriceModelImpl> get copyWith =>
      __$$ProductPriceModelImplCopyWithImpl<_$ProductPriceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductPriceModelImplToJson(this);
  }
}

abstract class _ProductPriceModel implements ProductPriceModel {
  const factory _ProductPriceModel({
    @JsonKey(name: 'unit_price') final String? unitPrice,
  }) = _$ProductPriceModelImpl;

  factory _ProductPriceModel.fromJson(Map<String, dynamic> json) =
      _$ProductPriceModelImpl.fromJson;

  @override
  @JsonKey(name: 'unit_price')
  String? get unitPrice;

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductPriceModelImplCopyWith<_$ProductPriceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
