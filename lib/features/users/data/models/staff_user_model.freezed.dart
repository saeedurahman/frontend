// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StaffUserModel _$StaffUserModelFromJson(Map<String, dynamic> json) {
  return _StaffUserModel.fromJson(json);
}

/// @nodoc
mixin _$StaffUserModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String? get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_name')
  String? get branchName => throw _privateConstructorUsedError;
  List<StaffRoleModel> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login_at')
  String? get lastLoginAt => throw _privateConstructorUsedError;

  /// Serializes this StaffUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffUserModelCopyWith<StaffUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffUserModelCopyWith<$Res> {
  factory $StaffUserModelCopyWith(
    StaffUserModel value,
    $Res Function(StaffUserModel) then,
  ) = _$StaffUserModelCopyWithImpl<$Res, StaffUserModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'full_name') String fullName,
    String? phone,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'branch_name') String? branchName,
    List<StaffRoleModel> roles,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
  });
}

/// @nodoc
class _$StaffUserModelCopyWithImpl<$Res, $Val extends StaffUserModel>
    implements $StaffUserModelCopyWith<$Res> {
  _$StaffUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? branchId = freezed,
    Object? branchName = freezed,
    Object? roles = null,
    Object? isActive = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchName: freezed == branchName
                ? _value.branchName
                : branchName // ignore: cast_nullable_to_non_nullable
                      as String?,
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<StaffRoleModel>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastLoginAt: freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StaffUserModelImplCopyWith<$Res>
    implements $StaffUserModelCopyWith<$Res> {
  factory _$$StaffUserModelImplCopyWith(
    _$StaffUserModelImpl value,
    $Res Function(_$StaffUserModelImpl) then,
  ) = __$$StaffUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'full_name') String fullName,
    String? phone,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'branch_name') String? branchName,
    List<StaffRoleModel> roles,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
  });
}

/// @nodoc
class __$$StaffUserModelImplCopyWithImpl<$Res>
    extends _$StaffUserModelCopyWithImpl<$Res, _$StaffUserModelImpl>
    implements _$$StaffUserModelImplCopyWith<$Res> {
  __$$StaffUserModelImplCopyWithImpl(
    _$StaffUserModelImpl _value,
    $Res Function(_$StaffUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StaffUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? branchId = freezed,
    Object? branchName = freezed,
    Object? roles = null,
    Object? isActive = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _$StaffUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchName: freezed == branchName
            ? _value.branchName
            : branchName // ignore: cast_nullable_to_non_nullable
                  as String?,
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<StaffRoleModel>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastLoginAt: freezed == lastLoginAt
            ? _value.lastLoginAt
            : lastLoginAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffUserModelImpl implements _StaffUserModel {
  const _$StaffUserModelImpl({
    required this.id,
    @JsonKey(name: 'full_name') required this.fullName,
    this.phone,
    @JsonKey(name: 'branch_id') this.branchId,
    @JsonKey(name: 'branch_name') this.branchName,
    final List<StaffRoleModel> roles = const [],
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'last_login_at') this.lastLoginAt,
  }) : _roles = roles;

  factory _$StaffUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffUserModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @override
  @JsonKey(name: 'branch_name')
  final String? branchName;
  final List<StaffRoleModel> _roles;
  @override
  @JsonKey()
  List<StaffRoleModel> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;

  @override
  String toString() {
    return 'StaffUserModel(id: $id, fullName: $fullName, phone: $phone, branchId: $branchId, branchName: $branchName, roles: $roles, isActive: $isActive, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    phone,
    branchId,
    branchName,
    const DeepCollectionEquality().hash(_roles),
    isActive,
    lastLoginAt,
  );

  /// Create a copy of StaffUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffUserModelImplCopyWith<_$StaffUserModelImpl> get copyWith =>
      __$$StaffUserModelImplCopyWithImpl<_$StaffUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffUserModelImplToJson(this);
  }
}

abstract class _StaffUserModel implements StaffUserModel {
  const factory _StaffUserModel({
    required final String id,
    @JsonKey(name: 'full_name') required final String fullName,
    final String? phone,
    @JsonKey(name: 'branch_id') final String? branchId,
    @JsonKey(name: 'branch_name') final String? branchName,
    final List<StaffRoleModel> roles,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'last_login_at') final String? lastLoginAt,
  }) = _$StaffUserModelImpl;

  factory _StaffUserModel.fromJson(Map<String, dynamic> json) =
      _$StaffUserModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'branch_id')
  String? get branchId;
  @override
  @JsonKey(name: 'branch_name')
  String? get branchName;
  @override
  List<StaffRoleModel> get roles;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'last_login_at')
  String? get lastLoginAt;

  /// Create a copy of StaffUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffUserModelImplCopyWith<_$StaffUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
