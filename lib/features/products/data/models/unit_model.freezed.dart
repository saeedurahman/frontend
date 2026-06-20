// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) {
  return _UnitModel.fromJson(json);
}

/// @nodoc
mixin _$UnitModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_base_unit')
  bool get isBaseUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this UnitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitModelCopyWith<UnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitModelCopyWith<$Res> {
  factory $UnitModelCopyWith(UnitModel value, $Res Function(UnitModel) then) =
      _$UnitModelCopyWithImpl<$Res, UnitModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    String symbol,
    @JsonKey(name: 'is_base_unit') bool isBaseUnit,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$UnitModelCopyWithImpl<$Res, $Val extends UnitModel>
    implements $UnitModelCopyWith<$Res> {
  _$UnitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? symbol = null,
    Object? isBaseUnit = null,
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
            symbol: null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                      as String,
            isBaseUnit: null == isBaseUnit
                ? _value.isBaseUnit
                : isBaseUnit // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$UnitModelImplCopyWith<$Res>
    implements $UnitModelCopyWith<$Res> {
  factory _$$UnitModelImplCopyWith(
    _$UnitModelImpl value,
    $Res Function(_$UnitModelImpl) then,
  ) = __$$UnitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    String symbol,
    @JsonKey(name: 'is_base_unit') bool isBaseUnit,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$UnitModelImplCopyWithImpl<$Res>
    extends _$UnitModelCopyWithImpl<$Res, _$UnitModelImpl>
    implements _$$UnitModelImplCopyWith<$Res> {
  __$$UnitModelImplCopyWithImpl(
    _$UnitModelImpl _value,
    $Res Function(_$UnitModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? symbol = null,
    Object? isBaseUnit = null,
    Object? isActive = null,
  }) {
    return _then(
      _$UnitModelImpl(
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
        symbol: null == symbol
            ? _value.symbol
            : symbol // ignore: cast_nullable_to_non_nullable
                  as String,
        isBaseUnit: null == isBaseUnit
            ? _value.isBaseUnit
            : isBaseUnit // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$UnitModelImpl implements _UnitModel {
  const _$UnitModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    required this.symbol,
    @JsonKey(name: 'is_base_unit') this.isBaseUnit = false,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$UnitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  final String symbol;
  @override
  @JsonKey(name: 'is_base_unit')
  final bool isBaseUnit;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'UnitModel(id: $id, businessId: $businessId, name: $name, symbol: $symbol, isBaseUnit: $isBaseUnit, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.isBaseUnit, isBaseUnit) ||
                other.isBaseUnit == isBaseUnit) &&
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
    symbol,
    isBaseUnit,
    isActive,
  );

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitModelImplCopyWith<_$UnitModelImpl> get copyWith =>
      __$$UnitModelImplCopyWithImpl<_$UnitModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitModelImplToJson(this);
  }
}

abstract class _UnitModel implements UnitModel {
  const factory _UnitModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    required final String symbol,
    @JsonKey(name: 'is_base_unit') final bool isBaseUnit,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$UnitModelImpl;

  factory _UnitModel.fromJson(Map<String, dynamic> json) =
      _$UnitModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  String get symbol;
  @override
  @JsonKey(name: 'is_base_unit')
  bool get isBaseUnit;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitModelImplCopyWith<_$UnitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnitConversionModel _$UnitConversionModelFromJson(Map<String, dynamic> json) {
  return _UnitConversionModel.fromJson(json);
}

/// @nodoc
mixin _$UnitConversionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_unit_id')
  String get fromUnitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_unit_id')
  String get toUnitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversion_factor')
  String get conversionFactor => throw _privateConstructorUsedError;

  /// Serializes this UnitConversionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnitConversionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitConversionModelCopyWith<UnitConversionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitConversionModelCopyWith<$Res> {
  factory $UnitConversionModelCopyWith(
    UnitConversionModel value,
    $Res Function(UnitConversionModel) then,
  ) = _$UnitConversionModelCopyWithImpl<$Res, UnitConversionModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'from_unit_id') String fromUnitId,
    @JsonKey(name: 'to_unit_id') String toUnitId,
    @JsonKey(name: 'conversion_factor') String conversionFactor,
  });
}

/// @nodoc
class _$UnitConversionModelCopyWithImpl<$Res, $Val extends UnitConversionModel>
    implements $UnitConversionModelCopyWith<$Res> {
  _$UnitConversionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnitConversionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUnitId = null,
    Object? toUnitId = null,
    Object? conversionFactor = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUnitId: null == fromUnitId
                ? _value.fromUnitId
                : fromUnitId // ignore: cast_nullable_to_non_nullable
                      as String,
            toUnitId: null == toUnitId
                ? _value.toUnitId
                : toUnitId // ignore: cast_nullable_to_non_nullable
                      as String,
            conversionFactor: null == conversionFactor
                ? _value.conversionFactor
                : conversionFactor // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UnitConversionModelImplCopyWith<$Res>
    implements $UnitConversionModelCopyWith<$Res> {
  factory _$$UnitConversionModelImplCopyWith(
    _$UnitConversionModelImpl value,
    $Res Function(_$UnitConversionModelImpl) then,
  ) = __$$UnitConversionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'from_unit_id') String fromUnitId,
    @JsonKey(name: 'to_unit_id') String toUnitId,
    @JsonKey(name: 'conversion_factor') String conversionFactor,
  });
}

/// @nodoc
class __$$UnitConversionModelImplCopyWithImpl<$Res>
    extends _$UnitConversionModelCopyWithImpl<$Res, _$UnitConversionModelImpl>
    implements _$$UnitConversionModelImplCopyWith<$Res> {
  __$$UnitConversionModelImplCopyWithImpl(
    _$UnitConversionModelImpl _value,
    $Res Function(_$UnitConversionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitConversionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUnitId = null,
    Object? toUnitId = null,
    Object? conversionFactor = null,
  }) {
    return _then(
      _$UnitConversionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUnitId: null == fromUnitId
            ? _value.fromUnitId
            : fromUnitId // ignore: cast_nullable_to_non_nullable
                  as String,
        toUnitId: null == toUnitId
            ? _value.toUnitId
            : toUnitId // ignore: cast_nullable_to_non_nullable
                  as String,
        conversionFactor: null == conversionFactor
            ? _value.conversionFactor
            : conversionFactor // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitConversionModelImpl implements _UnitConversionModel {
  const _$UnitConversionModelImpl({
    required this.id,
    @JsonKey(name: 'from_unit_id') required this.fromUnitId,
    @JsonKey(name: 'to_unit_id') required this.toUnitId,
    @JsonKey(name: 'conversion_factor') required this.conversionFactor,
  });

  factory _$UnitConversionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitConversionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'from_unit_id')
  final String fromUnitId;
  @override
  @JsonKey(name: 'to_unit_id')
  final String toUnitId;
  @override
  @JsonKey(name: 'conversion_factor')
  final String conversionFactor;

  @override
  String toString() {
    return 'UnitConversionModel(id: $id, fromUnitId: $fromUnitId, toUnitId: $toUnitId, conversionFactor: $conversionFactor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitConversionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUnitId, fromUnitId) ||
                other.fromUnitId == fromUnitId) &&
            (identical(other.toUnitId, toUnitId) ||
                other.toUnitId == toUnitId) &&
            (identical(other.conversionFactor, conversionFactor) ||
                other.conversionFactor == conversionFactor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fromUnitId, toUnitId, conversionFactor);

  /// Create a copy of UnitConversionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitConversionModelImplCopyWith<_$UnitConversionModelImpl> get copyWith =>
      __$$UnitConversionModelImplCopyWithImpl<_$UnitConversionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitConversionModelImplToJson(this);
  }
}

abstract class _UnitConversionModel implements UnitConversionModel {
  const factory _UnitConversionModel({
    required final String id,
    @JsonKey(name: 'from_unit_id') required final String fromUnitId,
    @JsonKey(name: 'to_unit_id') required final String toUnitId,
    @JsonKey(name: 'conversion_factor') required final String conversionFactor,
  }) = _$UnitConversionModelImpl;

  factory _UnitConversionModel.fromJson(Map<String, dynamic> json) =
      _$UnitConversionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'from_unit_id')
  String get fromUnitId;
  @override
  @JsonKey(name: 'to_unit_id')
  String get toUnitId;
  @override
  @JsonKey(name: 'conversion_factor')
  String get conversionFactor;

  /// Create a copy of UnitConversionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitConversionModelImplCopyWith<_$UnitConversionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
