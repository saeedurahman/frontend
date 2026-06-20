// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VariationFormItem {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get unitId => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  String? get weightGrams => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of VariationFormItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariationFormItemCopyWith<VariationFormItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariationFormItemCopyWith<$Res> {
  factory $VariationFormItemCopyWith(
    VariationFormItem value,
    $Res Function(VariationFormItem) then,
  ) = _$VariationFormItemCopyWithImpl<$Res, VariationFormItem>;
  @useResult
  $Res call({
    String? id,
    String name,
    String? sku,
    String? unitId,
    bool isDefault,
    String? weightGrams,
    bool isActive,
  });
}

/// @nodoc
class _$VariationFormItemCopyWithImpl<$Res, $Val extends VariationFormItem>
    implements $VariationFormItemCopyWith<$Res> {
  _$VariationFormItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VariationFormItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? sku = freezed,
    Object? unitId = freezed,
    Object? isDefault = null,
    Object? weightGrams = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            weightGrams: freezed == weightGrams
                ? _value.weightGrams
                : weightGrams // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VariationFormItemImplCopyWith<$Res>
    implements $VariationFormItemCopyWith<$Res> {
  factory _$$VariationFormItemImplCopyWith(
    _$VariationFormItemImpl value,
    $Res Function(_$VariationFormItemImpl) then,
  ) = __$$VariationFormItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String name,
    String? sku,
    String? unitId,
    bool isDefault,
    String? weightGrams,
    bool isActive,
  });
}

/// @nodoc
class __$$VariationFormItemImplCopyWithImpl<$Res>
    extends _$VariationFormItemCopyWithImpl<$Res, _$VariationFormItemImpl>
    implements _$$VariationFormItemImplCopyWith<$Res> {
  __$$VariationFormItemImplCopyWithImpl(
    _$VariationFormItemImpl _value,
    $Res Function(_$VariationFormItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VariationFormItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? sku = freezed,
    Object? unitId = freezed,
    Object? isDefault = null,
    Object? weightGrams = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$VariationFormItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        weightGrams: freezed == weightGrams
            ? _value.weightGrams
            : weightGrams // ignore: cast_nullable_to_non_nullable
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

class _$VariationFormItemImpl implements _VariationFormItem {
  const _$VariationFormItemImpl({
    this.id,
    this.name = '',
    this.sku,
    this.unitId,
    this.isDefault = false,
    this.weightGrams,
    this.isActive = true,
  });

  @override
  final String? id;
  @override
  @JsonKey()
  final String name;
  @override
  final String? sku;
  @override
  final String? unitId;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final String? weightGrams;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'VariationFormItem(id: $id, name: $name, sku: $sku, unitId: $unitId, isDefault: $isDefault, weightGrams: $weightGrams, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariationFormItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    sku,
    unitId,
    isDefault,
    weightGrams,
    isActive,
  );

  /// Create a copy of VariationFormItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariationFormItemImplCopyWith<_$VariationFormItemImpl> get copyWith =>
      __$$VariationFormItemImplCopyWithImpl<_$VariationFormItemImpl>(
        this,
        _$identity,
      );
}

abstract class _VariationFormItem implements VariationFormItem {
  const factory _VariationFormItem({
    final String? id,
    final String name,
    final String? sku,
    final String? unitId,
    final bool isDefault,
    final String? weightGrams,
    final bool isActive,
  }) = _$VariationFormItemImpl;

  @override
  String? get id;
  @override
  String get name;
  @override
  String? get sku;
  @override
  String? get unitId;
  @override
  bool get isDefault;
  @override
  String? get weightGrams;
  @override
  bool get isActive;

  /// Create a copy of VariationFormItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariationFormItemImplCopyWith<_$VariationFormItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BarcodeFormItem {
  String? get id => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  String get barcodeType => throw _privateConstructorUsedError;
  String? get variationId => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;

  /// Create a copy of BarcodeFormItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarcodeFormItemCopyWith<BarcodeFormItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeFormItemCopyWith<$Res> {
  factory $BarcodeFormItemCopyWith(
    BarcodeFormItem value,
    $Res Function(BarcodeFormItem) then,
  ) = _$BarcodeFormItemCopyWithImpl<$Res, BarcodeFormItem>;
  @useResult
  $Res call({
    String? id,
    String barcode,
    String barcodeType,
    String? variationId,
    bool isPrimary,
  });
}

/// @nodoc
class _$BarcodeFormItemCopyWithImpl<$Res, $Val extends BarcodeFormItem>
    implements $BarcodeFormItemCopyWith<$Res> {
  _$BarcodeFormItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BarcodeFormItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = null,
    Object? barcodeType = null,
    Object? variationId = freezed,
    Object? isPrimary = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            barcodeType: null == barcodeType
                ? _value.barcodeType
                : barcodeType // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPrimary: null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BarcodeFormItemImplCopyWith<$Res>
    implements $BarcodeFormItemCopyWith<$Res> {
  factory _$$BarcodeFormItemImplCopyWith(
    _$BarcodeFormItemImpl value,
    $Res Function(_$BarcodeFormItemImpl) then,
  ) = __$$BarcodeFormItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String barcode,
    String barcodeType,
    String? variationId,
    bool isPrimary,
  });
}

/// @nodoc
class __$$BarcodeFormItemImplCopyWithImpl<$Res>
    extends _$BarcodeFormItemCopyWithImpl<$Res, _$BarcodeFormItemImpl>
    implements _$$BarcodeFormItemImplCopyWith<$Res> {
  __$$BarcodeFormItemImplCopyWithImpl(
    _$BarcodeFormItemImpl _value,
    $Res Function(_$BarcodeFormItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BarcodeFormItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = null,
    Object? barcodeType = null,
    Object? variationId = freezed,
    Object? isPrimary = null,
  }) {
    return _then(
      _$BarcodeFormItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        barcodeType: null == barcodeType
            ? _value.barcodeType
            : barcodeType // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPrimary: null == isPrimary
            ? _value.isPrimary
            : isPrimary // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BarcodeFormItemImpl implements _BarcodeFormItem {
  const _$BarcodeFormItemImpl({
    this.id,
    this.barcode = '',
    this.barcodeType = 'EAN13',
    this.variationId,
    this.isPrimary = false,
  });

  @override
  final String? id;
  @override
  @JsonKey()
  final String barcode;
  @override
  @JsonKey()
  final String barcodeType;
  @override
  final String? variationId;
  @override
  @JsonKey()
  final bool isPrimary;

  @override
  String toString() {
    return 'BarcodeFormItem(id: $id, barcode: $barcode, barcodeType: $barcodeType, variationId: $variationId, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarcodeFormItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.barcodeType, barcodeType) ||
                other.barcodeType == barcodeType) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    barcode,
    barcodeType,
    variationId,
    isPrimary,
  );

  /// Create a copy of BarcodeFormItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarcodeFormItemImplCopyWith<_$BarcodeFormItemImpl> get copyWith =>
      __$$BarcodeFormItemImplCopyWithImpl<_$BarcodeFormItemImpl>(
        this,
        _$identity,
      );
}

abstract class _BarcodeFormItem implements BarcodeFormItem {
  const factory _BarcodeFormItem({
    final String? id,
    final String barcode,
    final String barcodeType,
    final String? variationId,
    final bool isPrimary,
  }) = _$BarcodeFormItemImpl;

  @override
  String? get id;
  @override
  String get barcode;
  @override
  String get barcodeType;
  @override
  String? get variationId;
  @override
  bool get isPrimary;

  /// Create a copy of BarcodeFormItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarcodeFormItemImplCopyWith<_$BarcodeFormItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProductFormState {
  String get mode => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get localImagePath => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;
  String? get selectedBrandId => throw _privateConstructorUsedError;
  String? get selectedBaseUnitId => throw _privateConstructorUsedError;
  String get productType => throw _privateConstructorUsedError;
  String get trackingType => throw _privateConstructorUsedError;
  bool get isSellable => throw _privateConstructorUsedError;
  bool get isPurchasable => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int? get shelfLifeDays => throw _privateConstructorUsedError;
  String? get minStockLevel => throw _privateConstructorUsedError;
  String? get maxStockLevel => throw _privateConstructorUsedError;
  List<VariationFormItem> get variations => throw _privateConstructorUsedError;
  List<BarcodeFormItem> get barcodes => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of ProductFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductFormStateCopyWith<ProductFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductFormStateCopyWith<$Res> {
  factory $ProductFormStateCopyWith(
    ProductFormState value,
    $Res Function(ProductFormState) then,
  ) = _$ProductFormStateCopyWithImpl<$Res, ProductFormState>;
  @useResult
  $Res call({
    String mode,
    String? productId,
    String name,
    String? sku,
    String? description,
    String? imageUrl,
    String? localImagePath,
    String? selectedCategoryId,
    String? selectedBrandId,
    String? selectedBaseUnitId,
    String productType,
    String trackingType,
    bool isSellable,
    bool isPurchasable,
    bool isActive,
    int? shelfLifeDays,
    String? minStockLevel,
    String? maxStockLevel,
    List<VariationFormItem> variations,
    List<BarcodeFormItem> barcodes,
    bool isLoading,
    bool isSubmitting,
    Map<String, String> errors,
  });
}

/// @nodoc
class _$ProductFormStateCopyWithImpl<$Res, $Val extends ProductFormState>
    implements $ProductFormStateCopyWith<$Res> {
  _$ProductFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? productId = freezed,
    Object? name = null,
    Object? sku = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? localImagePath = freezed,
    Object? selectedCategoryId = freezed,
    Object? selectedBrandId = freezed,
    Object? selectedBaseUnitId = freezed,
    Object? productType = null,
    Object? trackingType = null,
    Object? isSellable = null,
    Object? isPurchasable = null,
    Object? isActive = null,
    Object? shelfLifeDays = freezed,
    Object? minStockLevel = freezed,
    Object? maxStockLevel = freezed,
    Object? variations = null,
    Object? barcodes = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errors = null,
  }) {
    return _then(
      _value.copyWith(
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            localImagePath: freezed == localImagePath
                ? _value.localImagePath
                : localImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedCategoryId: freezed == selectedCategoryId
                ? _value.selectedCategoryId
                : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedBrandId: freezed == selectedBrandId
                ? _value.selectedBrandId
                : selectedBrandId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedBaseUnitId: freezed == selectedBaseUnitId
                ? _value.selectedBaseUnitId
                : selectedBaseUnitId // ignore: cast_nullable_to_non_nullable
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
            variations: null == variations
                ? _value.variations
                : variations // ignore: cast_nullable_to_non_nullable
                      as List<VariationFormItem>,
            barcodes: null == barcodes
                ? _value.barcodes
                : barcodes // ignore: cast_nullable_to_non_nullable
                      as List<BarcodeFormItem>,
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
}

/// @nodoc
abstract class _$$ProductFormStateImplCopyWith<$Res>
    implements $ProductFormStateCopyWith<$Res> {
  factory _$$ProductFormStateImplCopyWith(
    _$ProductFormStateImpl value,
    $Res Function(_$ProductFormStateImpl) then,
  ) = __$$ProductFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String mode,
    String? productId,
    String name,
    String? sku,
    String? description,
    String? imageUrl,
    String? localImagePath,
    String? selectedCategoryId,
    String? selectedBrandId,
    String? selectedBaseUnitId,
    String productType,
    String trackingType,
    bool isSellable,
    bool isPurchasable,
    bool isActive,
    int? shelfLifeDays,
    String? minStockLevel,
    String? maxStockLevel,
    List<VariationFormItem> variations,
    List<BarcodeFormItem> barcodes,
    bool isLoading,
    bool isSubmitting,
    Map<String, String> errors,
  });
}

/// @nodoc
class __$$ProductFormStateImplCopyWithImpl<$Res>
    extends _$ProductFormStateCopyWithImpl<$Res, _$ProductFormStateImpl>
    implements _$$ProductFormStateImplCopyWith<$Res> {
  __$$ProductFormStateImplCopyWithImpl(
    _$ProductFormStateImpl _value,
    $Res Function(_$ProductFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? productId = freezed,
    Object? name = null,
    Object? sku = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? localImagePath = freezed,
    Object? selectedCategoryId = freezed,
    Object? selectedBrandId = freezed,
    Object? selectedBaseUnitId = freezed,
    Object? productType = null,
    Object? trackingType = null,
    Object? isSellable = null,
    Object? isPurchasable = null,
    Object? isActive = null,
    Object? shelfLifeDays = freezed,
    Object? minStockLevel = freezed,
    Object? maxStockLevel = freezed,
    Object? variations = null,
    Object? barcodes = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errors = null,
  }) {
    return _then(
      _$ProductFormStateImpl(
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: freezed == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        localImagePath: freezed == localImagePath
            ? _value.localImagePath
            : localImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedCategoryId: freezed == selectedCategoryId
            ? _value.selectedCategoryId
            : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedBrandId: freezed == selectedBrandId
            ? _value.selectedBrandId
            : selectedBrandId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedBaseUnitId: freezed == selectedBaseUnitId
            ? _value.selectedBaseUnitId
            : selectedBaseUnitId // ignore: cast_nullable_to_non_nullable
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
        variations: null == variations
            ? _value._variations
            : variations // ignore: cast_nullable_to_non_nullable
                  as List<VariationFormItem>,
        barcodes: null == barcodes
            ? _value._barcodes
            : barcodes // ignore: cast_nullable_to_non_nullable
                  as List<BarcodeFormItem>,
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

class _$ProductFormStateImpl implements _ProductFormState {
  const _$ProductFormStateImpl({
    this.mode = 'create',
    this.productId,
    this.name = '',
    this.sku,
    this.description,
    this.imageUrl,
    this.localImagePath,
    this.selectedCategoryId,
    this.selectedBrandId,
    this.selectedBaseUnitId,
    this.productType = 'standard',
    this.trackingType = 'none',
    this.isSellable = true,
    this.isPurchasable = true,
    this.isActive = true,
    this.shelfLifeDays,
    this.minStockLevel,
    this.maxStockLevel,
    final List<VariationFormItem> variations = const [],
    final List<BarcodeFormItem> barcodes = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    final Map<String, String> errors = const {},
  }) : _variations = variations,
       _barcodes = barcodes,
       _errors = errors;

  @override
  @JsonKey()
  final String mode;
  @override
  final String? productId;
  @override
  @JsonKey()
  final String name;
  @override
  final String? sku;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? localImagePath;
  @override
  final String? selectedCategoryId;
  @override
  final String? selectedBrandId;
  @override
  final String? selectedBaseUnitId;
  @override
  @JsonKey()
  final String productType;
  @override
  @JsonKey()
  final String trackingType;
  @override
  @JsonKey()
  final bool isSellable;
  @override
  @JsonKey()
  final bool isPurchasable;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final int? shelfLifeDays;
  @override
  final String? minStockLevel;
  @override
  final String? maxStockLevel;
  final List<VariationFormItem> _variations;
  @override
  @JsonKey()
  List<VariationFormItem> get variations {
    if (_variations is EqualUnmodifiableListView) return _variations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variations);
  }

  final List<BarcodeFormItem> _barcodes;
  @override
  @JsonKey()
  List<BarcodeFormItem> get barcodes {
    if (_barcodes is EqualUnmodifiableListView) return _barcodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_barcodes);
  }

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
    return 'ProductFormState(mode: $mode, productId: $productId, name: $name, sku: $sku, description: $description, imageUrl: $imageUrl, localImagePath: $localImagePath, selectedCategoryId: $selectedCategoryId, selectedBrandId: $selectedBrandId, selectedBaseUnitId: $selectedBaseUnitId, productType: $productType, trackingType: $trackingType, isSellable: $isSellable, isPurchasable: $isPurchasable, isActive: $isActive, shelfLifeDays: $shelfLifeDays, minStockLevel: $minStockLevel, maxStockLevel: $maxStockLevel, variations: $variations, barcodes: $barcodes, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductFormStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.localImagePath, localImagePath) ||
                other.localImagePath == localImagePath) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.selectedBrandId, selectedBrandId) ||
                other.selectedBrandId == selectedBrandId) &&
            (identical(other.selectedBaseUnitId, selectedBaseUnitId) ||
                other.selectedBaseUnitId == selectedBaseUnitId) &&
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
            (identical(other.shelfLifeDays, shelfLifeDays) ||
                other.shelfLifeDays == shelfLifeDays) &&
            (identical(other.minStockLevel, minStockLevel) ||
                other.minStockLevel == minStockLevel) &&
            (identical(other.maxStockLevel, maxStockLevel) ||
                other.maxStockLevel == maxStockLevel) &&
            const DeepCollectionEquality().equals(
              other._variations,
              _variations,
            ) &&
            const DeepCollectionEquality().equals(other._barcodes, _barcodes) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    mode,
    productId,
    name,
    sku,
    description,
    imageUrl,
    localImagePath,
    selectedCategoryId,
    selectedBrandId,
    selectedBaseUnitId,
    productType,
    trackingType,
    isSellable,
    isPurchasable,
    isActive,
    shelfLifeDays,
    minStockLevel,
    maxStockLevel,
    const DeepCollectionEquality().hash(_variations),
    const DeepCollectionEquality().hash(_barcodes),
    isLoading,
    isSubmitting,
    const DeepCollectionEquality().hash(_errors),
  ]);

  /// Create a copy of ProductFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductFormStateImplCopyWith<_$ProductFormStateImpl> get copyWith =>
      __$$ProductFormStateImplCopyWithImpl<_$ProductFormStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ProductFormState implements ProductFormState {
  const factory _ProductFormState({
    final String mode,
    final String? productId,
    final String name,
    final String? sku,
    final String? description,
    final String? imageUrl,
    final String? localImagePath,
    final String? selectedCategoryId,
    final String? selectedBrandId,
    final String? selectedBaseUnitId,
    final String productType,
    final String trackingType,
    final bool isSellable,
    final bool isPurchasable,
    final bool isActive,
    final int? shelfLifeDays,
    final String? minStockLevel,
    final String? maxStockLevel,
    final List<VariationFormItem> variations,
    final List<BarcodeFormItem> barcodes,
    final bool isLoading,
    final bool isSubmitting,
    final Map<String, String> errors,
  }) = _$ProductFormStateImpl;

  @override
  String get mode;
  @override
  String? get productId;
  @override
  String get name;
  @override
  String? get sku;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get localImagePath;
  @override
  String? get selectedCategoryId;
  @override
  String? get selectedBrandId;
  @override
  String? get selectedBaseUnitId;
  @override
  String get productType;
  @override
  String get trackingType;
  @override
  bool get isSellable;
  @override
  bool get isPurchasable;
  @override
  bool get isActive;
  @override
  int? get shelfLifeDays;
  @override
  String? get minStockLevel;
  @override
  String? get maxStockLevel;
  @override
  List<VariationFormItem> get variations;
  @override
  List<BarcodeFormItem> get barcodes;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  Map<String, String> get errors;

  /// Create a copy of ProductFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductFormStateImplCopyWith<_$ProductFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
