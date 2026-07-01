// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BusinessConfigModel _$BusinessConfigModelFromJson(Map<String, dynamic> json) {
  return _BusinessConfigModel.fromJson(json);
}

/// @nodoc
mixin _$BusinessConfigModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_restaurant')
  bool get enableRestaurant => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_manufacturing')
  bool get enableManufacturing => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_accounting')
  bool get enableAccounting => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_weight_billing')
  bool get enableWeightBilling => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_kot')
  bool get enableKot => throw _privateConstructorUsedError;
  @JsonKey(name: 'fifo_costing_enabled')
  bool get fifoCostingEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'allow_negative_stock')
  bool get allowNegativeStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'config_json')
  Map<String, dynamic> get configJson => throw _privateConstructorUsedError;

  /// Serializes this BusinessConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessConfigModelCopyWith<BusinessConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessConfigModelCopyWith<$Res> {
  factory $BusinessConfigModelCopyWith(
    BusinessConfigModel value,
    $Res Function(BusinessConfigModel) then,
  ) = _$BusinessConfigModelCopyWithImpl<$Res, BusinessConfigModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'enable_restaurant') bool enableRestaurant,
    @JsonKey(name: 'enable_manufacturing') bool enableManufacturing,
    @JsonKey(name: 'enable_accounting') bool enableAccounting,
    @JsonKey(name: 'enable_weight_billing') bool enableWeightBilling,
    @JsonKey(name: 'enable_kot') bool enableKot,
    @JsonKey(name: 'fifo_costing_enabled') bool fifoCostingEnabled,
    @JsonKey(name: 'allow_negative_stock') bool allowNegativeStock,
    @JsonKey(name: 'config_json') Map<String, dynamic> configJson,
  });
}

/// @nodoc
class _$BusinessConfigModelCopyWithImpl<$Res, $Val extends BusinessConfigModel>
    implements $BusinessConfigModelCopyWith<$Res> {
  _$BusinessConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? enableRestaurant = null,
    Object? enableManufacturing = null,
    Object? enableAccounting = null,
    Object? enableWeightBilling = null,
    Object? enableKot = null,
    Object? fifoCostingEnabled = null,
    Object? allowNegativeStock = null,
    Object? configJson = null,
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
            enableRestaurant: null == enableRestaurant
                ? _value.enableRestaurant
                : enableRestaurant // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableManufacturing: null == enableManufacturing
                ? _value.enableManufacturing
                : enableManufacturing // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableAccounting: null == enableAccounting
                ? _value.enableAccounting
                : enableAccounting // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableWeightBilling: null == enableWeightBilling
                ? _value.enableWeightBilling
                : enableWeightBilling // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableKot: null == enableKot
                ? _value.enableKot
                : enableKot // ignore: cast_nullable_to_non_nullable
                      as bool,
            fifoCostingEnabled: null == fifoCostingEnabled
                ? _value.fifoCostingEnabled
                : fifoCostingEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowNegativeStock: null == allowNegativeStock
                ? _value.allowNegativeStock
                : allowNegativeStock // ignore: cast_nullable_to_non_nullable
                      as bool,
            configJson: null == configJson
                ? _value.configJson
                : configJson // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessConfigModelImplCopyWith<$Res>
    implements $BusinessConfigModelCopyWith<$Res> {
  factory _$$BusinessConfigModelImplCopyWith(
    _$BusinessConfigModelImpl value,
    $Res Function(_$BusinessConfigModelImpl) then,
  ) = __$$BusinessConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'enable_restaurant') bool enableRestaurant,
    @JsonKey(name: 'enable_manufacturing') bool enableManufacturing,
    @JsonKey(name: 'enable_accounting') bool enableAccounting,
    @JsonKey(name: 'enable_weight_billing') bool enableWeightBilling,
    @JsonKey(name: 'enable_kot') bool enableKot,
    @JsonKey(name: 'fifo_costing_enabled') bool fifoCostingEnabled,
    @JsonKey(name: 'allow_negative_stock') bool allowNegativeStock,
    @JsonKey(name: 'config_json') Map<String, dynamic> configJson,
  });
}

/// @nodoc
class __$$BusinessConfigModelImplCopyWithImpl<$Res>
    extends _$BusinessConfigModelCopyWithImpl<$Res, _$BusinessConfigModelImpl>
    implements _$$BusinessConfigModelImplCopyWith<$Res> {
  __$$BusinessConfigModelImplCopyWithImpl(
    _$BusinessConfigModelImpl _value,
    $Res Function(_$BusinessConfigModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? enableRestaurant = null,
    Object? enableManufacturing = null,
    Object? enableAccounting = null,
    Object? enableWeightBilling = null,
    Object? enableKot = null,
    Object? fifoCostingEnabled = null,
    Object? allowNegativeStock = null,
    Object? configJson = null,
  }) {
    return _then(
      _$BusinessConfigModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        enableRestaurant: null == enableRestaurant
            ? _value.enableRestaurant
            : enableRestaurant // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableManufacturing: null == enableManufacturing
            ? _value.enableManufacturing
            : enableManufacturing // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableAccounting: null == enableAccounting
            ? _value.enableAccounting
            : enableAccounting // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableWeightBilling: null == enableWeightBilling
            ? _value.enableWeightBilling
            : enableWeightBilling // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableKot: null == enableKot
            ? _value.enableKot
            : enableKot // ignore: cast_nullable_to_non_nullable
                  as bool,
        fifoCostingEnabled: null == fifoCostingEnabled
            ? _value.fifoCostingEnabled
            : fifoCostingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowNegativeStock: null == allowNegativeStock
            ? _value.allowNegativeStock
            : allowNegativeStock // ignore: cast_nullable_to_non_nullable
                  as bool,
        configJson: null == configJson
            ? _value._configJson
            : configJson // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessConfigModelImpl implements _BusinessConfigModel {
  const _$BusinessConfigModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'enable_restaurant') this.enableRestaurant = false,
    @JsonKey(name: 'enable_manufacturing') this.enableManufacturing = false,
    @JsonKey(name: 'enable_accounting') this.enableAccounting = false,
    @JsonKey(name: 'enable_weight_billing') this.enableWeightBilling = false,
    @JsonKey(name: 'enable_kot') this.enableKot = false,
    @JsonKey(name: 'fifo_costing_enabled') this.fifoCostingEnabled = true,
    @JsonKey(name: 'allow_negative_stock') this.allowNegativeStock = false,
    @JsonKey(name: 'config_json')
    final Map<String, dynamic> configJson = const {},
  }) : _configJson = configJson;

  factory _$BusinessConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessConfigModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'enable_restaurant')
  final bool enableRestaurant;
  @override
  @JsonKey(name: 'enable_manufacturing')
  final bool enableManufacturing;
  @override
  @JsonKey(name: 'enable_accounting')
  final bool enableAccounting;
  @override
  @JsonKey(name: 'enable_weight_billing')
  final bool enableWeightBilling;
  @override
  @JsonKey(name: 'enable_kot')
  final bool enableKot;
  @override
  @JsonKey(name: 'fifo_costing_enabled')
  final bool fifoCostingEnabled;
  @override
  @JsonKey(name: 'allow_negative_stock')
  final bool allowNegativeStock;
  final Map<String, dynamic> _configJson;
  @override
  @JsonKey(name: 'config_json')
  Map<String, dynamic> get configJson {
    if (_configJson is EqualUnmodifiableMapView) return _configJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_configJson);
  }

  @override
  String toString() {
    return 'BusinessConfigModel(id: $id, businessId: $businessId, enableRestaurant: $enableRestaurant, enableManufacturing: $enableManufacturing, enableAccounting: $enableAccounting, enableWeightBilling: $enableWeightBilling, enableKot: $enableKot, fifoCostingEnabled: $fifoCostingEnabled, allowNegativeStock: $allowNegativeStock, configJson: $configJson)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessConfigModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.enableRestaurant, enableRestaurant) ||
                other.enableRestaurant == enableRestaurant) &&
            (identical(other.enableManufacturing, enableManufacturing) ||
                other.enableManufacturing == enableManufacturing) &&
            (identical(other.enableAccounting, enableAccounting) ||
                other.enableAccounting == enableAccounting) &&
            (identical(other.enableWeightBilling, enableWeightBilling) ||
                other.enableWeightBilling == enableWeightBilling) &&
            (identical(other.enableKot, enableKot) ||
                other.enableKot == enableKot) &&
            (identical(other.fifoCostingEnabled, fifoCostingEnabled) ||
                other.fifoCostingEnabled == fifoCostingEnabled) &&
            (identical(other.allowNegativeStock, allowNegativeStock) ||
                other.allowNegativeStock == allowNegativeStock) &&
            const DeepCollectionEquality().equals(
              other._configJson,
              _configJson,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    enableRestaurant,
    enableManufacturing,
    enableAccounting,
    enableWeightBilling,
    enableKot,
    fifoCostingEnabled,
    allowNegativeStock,
    const DeepCollectionEquality().hash(_configJson),
  );

  /// Create a copy of BusinessConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessConfigModelImplCopyWith<_$BusinessConfigModelImpl> get copyWith =>
      __$$BusinessConfigModelImplCopyWithImpl<_$BusinessConfigModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessConfigModelImplToJson(this);
  }
}

abstract class _BusinessConfigModel implements BusinessConfigModel {
  const factory _BusinessConfigModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'enable_restaurant') final bool enableRestaurant,
    @JsonKey(name: 'enable_manufacturing') final bool enableManufacturing,
    @JsonKey(name: 'enable_accounting') final bool enableAccounting,
    @JsonKey(name: 'enable_weight_billing') final bool enableWeightBilling,
    @JsonKey(name: 'enable_kot') final bool enableKot,
    @JsonKey(name: 'fifo_costing_enabled') final bool fifoCostingEnabled,
    @JsonKey(name: 'allow_negative_stock') final bool allowNegativeStock,
    @JsonKey(name: 'config_json') final Map<String, dynamic> configJson,
  }) = _$BusinessConfigModelImpl;

  factory _BusinessConfigModel.fromJson(Map<String, dynamic> json) =
      _$BusinessConfigModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'enable_restaurant')
  bool get enableRestaurant;
  @override
  @JsonKey(name: 'enable_manufacturing')
  bool get enableManufacturing;
  @override
  @JsonKey(name: 'enable_accounting')
  bool get enableAccounting;
  @override
  @JsonKey(name: 'enable_weight_billing')
  bool get enableWeightBilling;
  @override
  @JsonKey(name: 'enable_kot')
  bool get enableKot;
  @override
  @JsonKey(name: 'fifo_costing_enabled')
  bool get fifoCostingEnabled;
  @override
  @JsonKey(name: 'allow_negative_stock')
  bool get allowNegativeStock;
  @override
  @JsonKey(name: 'config_json')
  Map<String, dynamic> get configJson;

  /// Create a copy of BusinessConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessConfigModelImplCopyWith<_$BusinessConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
