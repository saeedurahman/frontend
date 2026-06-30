// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StaffRoleModel _$StaffRoleModelFromJson(Map<String, dynamic> json) {
  return _StaffRoleModel.fromJson(json);
}

/// @nodoc
mixin _$StaffRoleModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this StaffRoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffRoleModelCopyWith<StaffRoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffRoleModelCopyWith<$Res> {
  factory $StaffRoleModelCopyWith(
    StaffRoleModel value,
    $Res Function(StaffRoleModel) then,
  ) = _$StaffRoleModelCopyWithImpl<$Res, StaffRoleModel>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$StaffRoleModelCopyWithImpl<$Res, $Val extends StaffRoleModel>
    implements $StaffRoleModelCopyWith<$Res> {
  _$StaffRoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StaffRoleModelImplCopyWith<$Res>
    implements $StaffRoleModelCopyWith<$Res> {
  factory _$$StaffRoleModelImplCopyWith(
    _$StaffRoleModelImpl value,
    $Res Function(_$StaffRoleModelImpl) then,
  ) = __$$StaffRoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$StaffRoleModelImplCopyWithImpl<$Res>
    extends _$StaffRoleModelCopyWithImpl<$Res, _$StaffRoleModelImpl>
    implements _$$StaffRoleModelImplCopyWith<$Res> {
  __$$StaffRoleModelImplCopyWithImpl(
    _$StaffRoleModelImpl _value,
    $Res Function(_$StaffRoleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StaffRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$StaffRoleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffRoleModelImpl implements _StaffRoleModel {
  const _$StaffRoleModelImpl({required this.id, required this.name});

  factory _$StaffRoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffRoleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'StaffRoleModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffRoleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of StaffRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffRoleModelImplCopyWith<_$StaffRoleModelImpl> get copyWith =>
      __$$StaffRoleModelImplCopyWithImpl<_$StaffRoleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffRoleModelImplToJson(this);
  }
}

abstract class _StaffRoleModel implements StaffRoleModel {
  const factory _StaffRoleModel({
    required final String id,
    required final String name,
  }) = _$StaffRoleModelImpl;

  factory _StaffRoleModel.fromJson(Map<String, dynamic> json) =
      _$StaffRoleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of StaffRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffRoleModelImplCopyWith<_$StaffRoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
