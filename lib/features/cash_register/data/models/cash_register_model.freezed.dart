// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_register_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CashRegisterModel _$CashRegisterModelFromJson(Map<String, dynamic> json) {
  return _CashRegisterModel.fromJson(json);
}

/// @nodoc
mixin _$CashRegisterModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_identifier')
  String? get deviceIdentifier => throw _privateConstructorUsedError;

  /// Serializes this CashRegisterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashRegisterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashRegisterModelCopyWith<CashRegisterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashRegisterModelCopyWith<$Res> {
  factory $CashRegisterModelCopyWith(
    CashRegisterModel value,
    $Res Function(CashRegisterModel) then,
  ) = _$CashRegisterModelCopyWithImpl<$Res, CashRegisterModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    String name,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'device_identifier') String? deviceIdentifier,
  });
}

/// @nodoc
class _$CashRegisterModelCopyWithImpl<$Res, $Val extends CashRegisterModel>
    implements $CashRegisterModelCopyWith<$Res> {
  _$CashRegisterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashRegisterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? name = null,
    Object? isActive = null,
    Object? deviceIdentifier = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            deviceIdentifier: freezed == deviceIdentifier
                ? _value.deviceIdentifier
                : deviceIdentifier // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CashRegisterModelImplCopyWith<$Res>
    implements $CashRegisterModelCopyWith<$Res> {
  factory _$$CashRegisterModelImplCopyWith(
    _$CashRegisterModelImpl value,
    $Res Function(_$CashRegisterModelImpl) then,
  ) = __$$CashRegisterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'branch_id') String branchId,
    String name,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'device_identifier') String? deviceIdentifier,
  });
}

/// @nodoc
class __$$CashRegisterModelImplCopyWithImpl<$Res>
    extends _$CashRegisterModelCopyWithImpl<$Res, _$CashRegisterModelImpl>
    implements _$$CashRegisterModelImplCopyWith<$Res> {
  __$$CashRegisterModelImplCopyWithImpl(
    _$CashRegisterModelImpl _value,
    $Res Function(_$CashRegisterModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CashRegisterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? name = null,
    Object? isActive = null,
    Object? deviceIdentifier = freezed,
  }) {
    return _then(
      _$CashRegisterModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        deviceIdentifier: freezed == deviceIdentifier
            ? _value.deviceIdentifier
            : deviceIdentifier // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CashRegisterModelImpl implements _CashRegisterModel {
  const _$CashRegisterModelImpl({
    required this.id,
    @JsonKey(name: 'branch_id') required this.branchId,
    required this.name,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'device_identifier') this.deviceIdentifier,
  });

  factory _$CashRegisterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashRegisterModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  final String name;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'device_identifier')
  final String? deviceIdentifier;

  @override
  String toString() {
    return 'CashRegisterModel(id: $id, branchId: $branchId, name: $name, isActive: $isActive, deviceIdentifier: $deviceIdentifier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashRegisterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.deviceIdentifier, deviceIdentifier) ||
                other.deviceIdentifier == deviceIdentifier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, branchId, name, isActive, deviceIdentifier);

  /// Create a copy of CashRegisterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashRegisterModelImplCopyWith<_$CashRegisterModelImpl> get copyWith =>
      __$$CashRegisterModelImplCopyWithImpl<_$CashRegisterModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CashRegisterModelImplToJson(this);
  }
}

abstract class _CashRegisterModel implements CashRegisterModel {
  const factory _CashRegisterModel({
    required final String id,
    @JsonKey(name: 'branch_id') required final String branchId,
    required final String name,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'device_identifier') final String? deviceIdentifier,
  }) = _$CashRegisterModelImpl;

  factory _CashRegisterModel.fromJson(Map<String, dynamic> json) =
      _$CashRegisterModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  String get name;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'device_identifier')
  String? get deviceIdentifier;

  /// Create a copy of CashRegisterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashRegisterModelImplCopyWith<_$CashRegisterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
