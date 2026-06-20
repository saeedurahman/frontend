// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BarcodeModel _$BarcodeModelFromJson(Map<String, dynamic> json) {
  return _BarcodeModel.fromJson(json);
}

/// @nodoc
mixin _$BarcodeModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'barcode_type')
  String get barcodeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;

  /// Serializes this BarcodeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarcodeModelCopyWith<BarcodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeModelCopyWith<$Res> {
  factory $BarcodeModelCopyWith(
    BarcodeModel value,
    $Res Function(BarcodeModel) then,
  ) = _$BarcodeModelCopyWithImpl<$Res, BarcodeModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String barcode,
    @JsonKey(name: 'barcode_type') String barcodeType,
    @JsonKey(name: 'is_primary') bool isPrimary,
  });
}

/// @nodoc
class _$BarcodeModelCopyWithImpl<$Res, $Val extends BarcodeModel>
    implements $BarcodeModelCopyWith<$Res> {
  _$BarcodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? barcode = null,
    Object? barcodeType = null,
    Object? isPrimary = null,
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
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            barcodeType: null == barcodeType
                ? _value.barcodeType
                : barcodeType // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$BarcodeModelImplCopyWith<$Res>
    implements $BarcodeModelCopyWith<$Res> {
  factory _$$BarcodeModelImplCopyWith(
    _$BarcodeModelImpl value,
    $Res Function(_$BarcodeModelImpl) then,
  ) = __$$BarcodeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String barcode,
    @JsonKey(name: 'barcode_type') String barcodeType,
    @JsonKey(name: 'is_primary') bool isPrimary,
  });
}

/// @nodoc
class __$$BarcodeModelImplCopyWithImpl<$Res>
    extends _$BarcodeModelCopyWithImpl<$Res, _$BarcodeModelImpl>
    implements _$$BarcodeModelImplCopyWith<$Res> {
  __$$BarcodeModelImplCopyWithImpl(
    _$BarcodeModelImpl _value,
    $Res Function(_$BarcodeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variationId = freezed,
    Object? barcode = null,
    Object? barcodeType = null,
    Object? isPrimary = null,
  }) {
    return _then(
      _$BarcodeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        barcodeType: null == barcodeType
            ? _value.barcodeType
            : barcodeType // ignore: cast_nullable_to_non_nullable
                  as String,
        isPrimary: null == isPrimary
            ? _value.isPrimary
            : isPrimary // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BarcodeModelImpl implements _BarcodeModel {
  const _$BarcodeModelImpl({
    required this.id,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    required this.barcode,
    @JsonKey(name: 'barcode_type') this.barcodeType = 'EAN13',
    @JsonKey(name: 'is_primary') this.isPrimary = false,
  });

  factory _$BarcodeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarcodeModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  final String barcode;
  @override
  @JsonKey(name: 'barcode_type')
  final String barcodeType;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @override
  String toString() {
    return 'BarcodeModel(id: $id, productId: $productId, variationId: $variationId, barcode: $barcode, barcodeType: $barcodeType, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarcodeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.barcodeType, barcodeType) ||
                other.barcodeType == barcodeType) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    variationId,
    barcode,
    barcodeType,
    isPrimary,
  );

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarcodeModelImplCopyWith<_$BarcodeModelImpl> get copyWith =>
      __$$BarcodeModelImplCopyWithImpl<_$BarcodeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarcodeModelImplToJson(this);
  }
}

abstract class _BarcodeModel implements BarcodeModel {
  const factory _BarcodeModel({
    required final String id,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    required final String barcode,
    @JsonKey(name: 'barcode_type') final String barcodeType,
    @JsonKey(name: 'is_primary') final bool isPrimary,
  }) = _$BarcodeModelImpl;

  factory _BarcodeModel.fromJson(Map<String, dynamic> json) =
      _$BarcodeModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  String get barcode;
  @override
  @JsonKey(name: 'barcode_type')
  String get barcodeType;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarcodeModelImplCopyWith<_$BarcodeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
