// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bom_header_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BomHeaderModel _$BomHeaderModelFromJson(Map<String, dynamic> json) {
  return _BomHeaderModel.fromJson(json);
}

/// @nodoc
mixin _$BomHeaderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'output_qty')
  String get outputQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  String? get deletedAt => throw _privateConstructorUsedError;
  List<BomLineModel> get lines => throw _privateConstructorUsedError;

  /// Serializes this BomHeaderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BomHeaderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BomHeaderModelCopyWith<BomHeaderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BomHeaderModelCopyWith<$Res> {
  factory $BomHeaderModelCopyWith(
    BomHeaderModel value,
    $Res Function(BomHeaderModel) then,
  ) = _$BomHeaderModelCopyWithImpl<$Res, BomHeaderModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    String name,
    @JsonKey(name: 'output_qty') String outputQty,
    @JsonKey(name: 'is_active') bool isActive,
    int version,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    List<BomLineModel> lines,
  });
}

/// @nodoc
class _$BomHeaderModelCopyWithImpl<$Res, $Val extends BomHeaderModel>
    implements $BomHeaderModelCopyWith<$Res> {
  _$BomHeaderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BomHeaderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? name = null,
    Object? outputQty = null,
    Object? isActive = null,
    Object? version = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            outputQty: null == outputQty
                ? _value.outputQty
                : outputQty // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
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
                      as List<BomLineModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BomHeaderModelImplCopyWith<$Res>
    implements $BomHeaderModelCopyWith<$Res> {
  factory _$$BomHeaderModelImplCopyWith(
    _$BomHeaderModelImpl value,
    $Res Function(_$BomHeaderModelImpl) then,
  ) = __$$BomHeaderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    String name,
    @JsonKey(name: 'output_qty') String outputQty,
    @JsonKey(name: 'is_active') bool isActive,
    int version,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    List<BomLineModel> lines,
  });
}

/// @nodoc
class __$$BomHeaderModelImplCopyWithImpl<$Res>
    extends _$BomHeaderModelCopyWithImpl<$Res, _$BomHeaderModelImpl>
    implements _$$BomHeaderModelImplCopyWith<$Res> {
  __$$BomHeaderModelImplCopyWithImpl(
    _$BomHeaderModelImpl _value,
    $Res Function(_$BomHeaderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BomHeaderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? name = null,
    Object? outputQty = null,
    Object? isActive = null,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$BomHeaderModelImpl(
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
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        outputQty: null == outputQty
            ? _value.outputQty
            : outputQty // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
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
                  as List<BomLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BomHeaderModelImpl implements _BomHeaderModel {
  const _$BomHeaderModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'product_name') required this.productName,
    @JsonKey(name: 'variation_id') this.variationId,
    required this.name,
    @JsonKey(name: 'output_qty') required this.outputQty,
    @JsonKey(name: 'is_active') this.isActive = true,
    this.version = 1,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'deleted_at') this.deletedAt,
    final List<BomLineModel> lines = const [],
  }) : _lines = lines;

  factory _$BomHeaderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BomHeaderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
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
  final String name;
  @override
  @JsonKey(name: 'output_qty')
  final String outputQty;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final List<BomLineModel> _lines;
  @override
  @JsonKey()
  List<BomLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'BomHeaderModel(id: $id, businessId: $businessId, productId: $productId, productName: $productName, variationId: $variationId, name: $name, outputQty: $outputQty, isActive: $isActive, version: $version, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BomHeaderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.outputQty, outputQty) ||
                other.outputQty == outputQty) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.version, version) || other.version == version) &&
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
    productId,
    productName,
    variationId,
    name,
    outputQty,
    isActive,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of BomHeaderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BomHeaderModelImplCopyWith<_$BomHeaderModelImpl> get copyWith =>
      __$$BomHeaderModelImplCopyWithImpl<_$BomHeaderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BomHeaderModelImplToJson(this);
  }
}

abstract class _BomHeaderModel implements BomHeaderModel {
  const factory _BomHeaderModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'product_name') required final String productName,
    @JsonKey(name: 'variation_id') final String? variationId,
    required final String name,
    @JsonKey(name: 'output_qty') required final String outputQty,
    @JsonKey(name: 'is_active') final bool isActive,
    final int version,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'updated_at') required final String updatedAt,
    @JsonKey(name: 'deleted_at') final String? deletedAt,
    final List<BomLineModel> lines,
  }) = _$BomHeaderModelImpl;

  factory _BomHeaderModel.fromJson(Map<String, dynamic> json) =
      _$BomHeaderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
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
  String get name;
  @override
  @JsonKey(name: 'output_qty')
  String get outputQty;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  int get version;
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
  List<BomLineModel> get lines;

  /// Create a copy of BomHeaderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BomHeaderModelImplCopyWith<_$BomHeaderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
