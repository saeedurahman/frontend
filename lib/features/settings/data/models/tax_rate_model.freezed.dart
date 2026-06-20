// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_rate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaxRateModel _$TaxRateModelFromJson(Map<String, dynamic> json) {
  return _TaxRateModel.fromJson(json);
}

/// @nodoc
mixin _$TaxRateModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get rate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_compound')
  bool get isCompound => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this TaxRateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxRateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxRateModelCopyWith<TaxRateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxRateModelCopyWith<$Res> {
  factory $TaxRateModelCopyWith(
    TaxRateModel value,
    $Res Function(TaxRateModel) then,
  ) = _$TaxRateModelCopyWithImpl<$Res, TaxRateModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    String rate,
    @JsonKey(name: 'is_compound') bool isCompound,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$TaxRateModelCopyWithImpl<$Res, $Val extends TaxRateModel>
    implements $TaxRateModelCopyWith<$Res> {
  _$TaxRateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxRateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? rate = null,
    Object? isCompound = null,
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
            rate: null == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompound: null == isCompound
                ? _value.isCompound
                : isCompound // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TaxRateModelImplCopyWith<$Res>
    implements $TaxRateModelCopyWith<$Res> {
  factory _$$TaxRateModelImplCopyWith(
    _$TaxRateModelImpl value,
    $Res Function(_$TaxRateModelImpl) then,
  ) = __$$TaxRateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    String rate,
    @JsonKey(name: 'is_compound') bool isCompound,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$TaxRateModelImplCopyWithImpl<$Res>
    extends _$TaxRateModelCopyWithImpl<$Res, _$TaxRateModelImpl>
    implements _$$TaxRateModelImplCopyWith<$Res> {
  __$$TaxRateModelImplCopyWithImpl(
    _$TaxRateModelImpl _value,
    $Res Function(_$TaxRateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxRateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? rate = null,
    Object? isCompound = null,
    Object? isActive = null,
  }) {
    return _then(
      _$TaxRateModelImpl(
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
        rate: null == rate
            ? _value.rate
            : rate // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompound: null == isCompound
            ? _value.isCompound
            : isCompound // ignore: cast_nullable_to_non_nullable
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
class _$TaxRateModelImpl implements _TaxRateModel {
  const _$TaxRateModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    required this.rate,
    @JsonKey(name: 'is_compound') this.isCompound = false,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$TaxRateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxRateModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  final String rate;
  @override
  @JsonKey(name: 'is_compound')
  final bool isCompound;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'TaxRateModel(id: $id, businessId: $businessId, name: $name, rate: $rate, isCompound: $isCompound, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxRateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.isCompound, isCompound) ||
                other.isCompound == isCompound) &&
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
    rate,
    isCompound,
    isActive,
  );

  /// Create a copy of TaxRateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxRateModelImplCopyWith<_$TaxRateModelImpl> get copyWith =>
      __$$TaxRateModelImplCopyWithImpl<_$TaxRateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxRateModelImplToJson(this);
  }
}

abstract class _TaxRateModel implements TaxRateModel {
  const factory _TaxRateModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    required final String rate,
    @JsonKey(name: 'is_compound') final bool isCompound,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$TaxRateModelImpl;

  factory _TaxRateModel.fromJson(Map<String, dynamic> json) =
      _$TaxRateModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  String get rate;
  @override
  @JsonKey(name: 'is_compound')
  bool get isCompound;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of TaxRateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxRateModelImplCopyWith<_$TaxRateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
