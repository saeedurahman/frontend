// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettingModel _$AppSettingModelFromJson(Map<String, dynamic> json) {
  return _AppSettingModel.fromJson(json);
}

/// @nodoc
mixin _$AppSettingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String? get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'setting_key')
  String get settingKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'setting_value')
  Map<String, dynamic> get settingValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppSettingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingModelCopyWith<AppSettingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingModelCopyWith<$Res> {
  factory $AppSettingModelCopyWith(
    AppSettingModel value,
    $Res Function(AppSettingModel) then,
  ) = _$AppSettingModelCopyWithImpl<$Res, AppSettingModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'setting_key') String settingKey,
    @JsonKey(name: 'setting_value') Map<String, dynamic> settingValue,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$AppSettingModelCopyWithImpl<$Res, $Val extends AppSettingModel>
    implements $AppSettingModelCopyWith<$Res> {
  _$AppSettingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = freezed,
    Object? settingKey = null,
    Object? settingValue = null,
    Object? updatedAt = freezed,
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
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            settingKey: null == settingKey
                ? _value.settingKey
                : settingKey // ignore: cast_nullable_to_non_nullable
                      as String,
            settingValue: null == settingValue
                ? _value.settingValue
                : settingValue // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingModelImplCopyWith<$Res>
    implements $AppSettingModelCopyWith<$Res> {
  factory _$$AppSettingModelImplCopyWith(
    _$AppSettingModelImpl value,
    $Res Function(_$AppSettingModelImpl) then,
  ) = __$$AppSettingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'setting_key') String settingKey,
    @JsonKey(name: 'setting_value') Map<String, dynamic> settingValue,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$AppSettingModelImplCopyWithImpl<$Res>
    extends _$AppSettingModelCopyWithImpl<$Res, _$AppSettingModelImpl>
    implements _$$AppSettingModelImplCopyWith<$Res> {
  __$$AppSettingModelImplCopyWithImpl(
    _$AppSettingModelImpl _value,
    $Res Function(_$AppSettingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = freezed,
    Object? settingKey = null,
    Object? settingValue = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AppSettingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        settingKey: null == settingKey
            ? _value.settingKey
            : settingKey // ignore: cast_nullable_to_non_nullable
                  as String,
        settingValue: null == settingValue
            ? _value._settingValue
            : settingValue // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingModelImpl implements _AppSettingModel {
  const _$AppSettingModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') this.branchId,
    @JsonKey(name: 'setting_key') required this.settingKey,
    @JsonKey(name: 'setting_value')
    required final Map<String, dynamic> settingValue,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _settingValue = settingValue;

  factory _$AppSettingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @override
  @JsonKey(name: 'setting_key')
  final String settingKey;
  final Map<String, dynamic> _settingValue;
  @override
  @JsonKey(name: 'setting_value')
  Map<String, dynamic> get settingValue {
    if (_settingValue is EqualUnmodifiableMapView) return _settingValue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settingValue);
  }

  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'AppSettingModel(id: $id, businessId: $businessId, branchId: $branchId, settingKey: $settingKey, settingValue: $settingValue, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.settingKey, settingKey) ||
                other.settingKey == settingKey) &&
            const DeepCollectionEquality().equals(
              other._settingValue,
              _settingValue,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    settingKey,
    const DeepCollectionEquality().hash(_settingValue),
    updatedAt,
  );

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingModelImplCopyWith<_$AppSettingModelImpl> get copyWith =>
      __$$AppSettingModelImplCopyWithImpl<_$AppSettingModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingModelImplToJson(this);
  }
}

abstract class _AppSettingModel implements AppSettingModel {
  const factory _AppSettingModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') final String? branchId,
    @JsonKey(name: 'setting_key') required final String settingKey,
    @JsonKey(name: 'setting_value')
    required final Map<String, dynamic> settingValue,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$AppSettingModelImpl;

  factory _AppSettingModel.fromJson(Map<String, dynamic> json) =
      _$AppSettingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String? get branchId;
  @override
  @JsonKey(name: 'setting_key')
  String get settingKey;
  @override
  @JsonKey(name: 'setting_value')
  Map<String, dynamic> get settingValue;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of AppSettingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingModelImplCopyWith<_$AppSettingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
