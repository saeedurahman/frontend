// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PermissionModel _$PermissionModelFromJson(Map<String, dynamic> json) {
  return _PermissionModel.fromJson(json);
}

/// @nodoc
mixin _$PermissionModel {
  @JsonKey(name: 'permission_key')
  String get permissionKey => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this PermissionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionModelCopyWith<PermissionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionModelCopyWith<$Res> {
  factory $PermissionModelCopyWith(
    PermissionModel value,
    $Res Function(PermissionModel) then,
  ) = _$PermissionModelCopyWithImpl<$Res, PermissionModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'permission_key') String permissionKey,
    String description,
  });
}

/// @nodoc
class _$PermissionModelCopyWithImpl<$Res, $Val extends PermissionModel>
    implements $PermissionModelCopyWith<$Res> {
  _$PermissionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? permissionKey = null, Object? description = null}) {
    return _then(
      _value.copyWith(
            permissionKey: null == permissionKey
                ? _value.permissionKey
                : permissionKey // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PermissionModelImplCopyWith<$Res>
    implements $PermissionModelCopyWith<$Res> {
  factory _$$PermissionModelImplCopyWith(
    _$PermissionModelImpl value,
    $Res Function(_$PermissionModelImpl) then,
  ) = __$$PermissionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'permission_key') String permissionKey,
    String description,
  });
}

/// @nodoc
class __$$PermissionModelImplCopyWithImpl<$Res>
    extends _$PermissionModelCopyWithImpl<$Res, _$PermissionModelImpl>
    implements _$$PermissionModelImplCopyWith<$Res> {
  __$$PermissionModelImplCopyWithImpl(
    _$PermissionModelImpl _value,
    $Res Function(_$PermissionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? permissionKey = null, Object? description = null}) {
    return _then(
      _$PermissionModelImpl(
        permissionKey: null == permissionKey
            ? _value.permissionKey
            : permissionKey // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionModelImpl implements _PermissionModel {
  const _$PermissionModelImpl({
    @JsonKey(name: 'permission_key') required this.permissionKey,
    required this.description,
  });

  factory _$PermissionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionModelImplFromJson(json);

  @override
  @JsonKey(name: 'permission_key')
  final String permissionKey;
  @override
  final String description;

  @override
  String toString() {
    return 'PermissionModel(permissionKey: $permissionKey, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionModelImpl &&
            (identical(other.permissionKey, permissionKey) ||
                other.permissionKey == permissionKey) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, permissionKey, description);

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionModelImplCopyWith<_$PermissionModelImpl> get copyWith =>
      __$$PermissionModelImplCopyWithImpl<_$PermissionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionModelImplToJson(this);
  }
}

abstract class _PermissionModel implements PermissionModel {
  const factory _PermissionModel({
    @JsonKey(name: 'permission_key') required final String permissionKey,
    required final String description,
  }) = _$PermissionModelImpl;

  factory _PermissionModel.fromJson(Map<String, dynamic> json) =
      _$PermissionModelImpl.fromJson;

  @override
  @JsonKey(name: 'permission_key')
  String get permissionKey;
  @override
  String get description;

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionModelImplCopyWith<_$PermissionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PermissionModuleModel _$PermissionModuleModelFromJson(
  Map<String, dynamic> json,
) {
  return _PermissionModuleModel.fromJson(json);
}

/// @nodoc
mixin _$PermissionModuleModel {
  String get module => throw _privateConstructorUsedError;
  List<PermissionModel> get permissions => throw _privateConstructorUsedError;

  /// Serializes this PermissionModuleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionModuleModelCopyWith<PermissionModuleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionModuleModelCopyWith<$Res> {
  factory $PermissionModuleModelCopyWith(
    PermissionModuleModel value,
    $Res Function(PermissionModuleModel) then,
  ) = _$PermissionModuleModelCopyWithImpl<$Res, PermissionModuleModel>;
  @useResult
  $Res call({String module, List<PermissionModel> permissions});
}

/// @nodoc
class _$PermissionModuleModelCopyWithImpl<
  $Res,
  $Val extends PermissionModuleModel
>
    implements $PermissionModuleModelCopyWith<$Res> {
  _$PermissionModuleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? module = null, Object? permissions = null}) {
    return _then(
      _value.copyWith(
            module: null == module
                ? _value.module
                : module // ignore: cast_nullable_to_non_nullable
                      as String,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<PermissionModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PermissionModuleModelImplCopyWith<$Res>
    implements $PermissionModuleModelCopyWith<$Res> {
  factory _$$PermissionModuleModelImplCopyWith(
    _$PermissionModuleModelImpl value,
    $Res Function(_$PermissionModuleModelImpl) then,
  ) = __$$PermissionModuleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String module, List<PermissionModel> permissions});
}

/// @nodoc
class __$$PermissionModuleModelImplCopyWithImpl<$Res>
    extends
        _$PermissionModuleModelCopyWithImpl<$Res, _$PermissionModuleModelImpl>
    implements _$$PermissionModuleModelImplCopyWith<$Res> {
  __$$PermissionModuleModelImplCopyWithImpl(
    _$PermissionModuleModelImpl _value,
    $Res Function(_$PermissionModuleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PermissionModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? module = null, Object? permissions = null}) {
    return _then(
      _$PermissionModuleModelImpl(
        module: null == module
            ? _value.module
            : module // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<PermissionModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionModuleModelImpl implements _PermissionModuleModel {
  const _$PermissionModuleModelImpl({
    required this.module,
    final List<PermissionModel> permissions = const [],
  }) : _permissions = permissions;

  factory _$PermissionModuleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionModuleModelImplFromJson(json);

  @override
  final String module;
  final List<PermissionModel> _permissions;
  @override
  @JsonKey()
  List<PermissionModel> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  String toString() {
    return 'PermissionModuleModel(module: $module, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionModuleModelImpl &&
            (identical(other.module, module) || other.module == module) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    module,
    const DeepCollectionEquality().hash(_permissions),
  );

  /// Create a copy of PermissionModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionModuleModelImplCopyWith<_$PermissionModuleModelImpl>
  get copyWith =>
      __$$PermissionModuleModelImplCopyWithImpl<_$PermissionModuleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionModuleModelImplToJson(this);
  }
}

abstract class _PermissionModuleModel implements PermissionModuleModel {
  const factory _PermissionModuleModel({
    required final String module,
    final List<PermissionModel> permissions,
  }) = _$PermissionModuleModelImpl;

  factory _PermissionModuleModel.fromJson(Map<String, dynamic> json) =
      _$PermissionModuleModelImpl.fromJson;

  @override
  String get module;
  @override
  List<PermissionModel> get permissions;

  /// Create a copy of PermissionModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionModuleModelImplCopyWith<_$PermissionModuleModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PermissionsCatalogModel _$PermissionsCatalogModelFromJson(
  Map<String, dynamic> json,
) {
  return _PermissionsCatalogModel.fromJson(json);
}

/// @nodoc
mixin _$PermissionsCatalogModel {
  List<PermissionModuleModel> get modules => throw _privateConstructorUsedError;

  /// Serializes this PermissionsCatalogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionsCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionsCatalogModelCopyWith<PermissionsCatalogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionsCatalogModelCopyWith<$Res> {
  factory $PermissionsCatalogModelCopyWith(
    PermissionsCatalogModel value,
    $Res Function(PermissionsCatalogModel) then,
  ) = _$PermissionsCatalogModelCopyWithImpl<$Res, PermissionsCatalogModel>;
  @useResult
  $Res call({List<PermissionModuleModel> modules});
}

/// @nodoc
class _$PermissionsCatalogModelCopyWithImpl<
  $Res,
  $Val extends PermissionsCatalogModel
>
    implements $PermissionsCatalogModelCopyWith<$Res> {
  _$PermissionsCatalogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionsCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? modules = null}) {
    return _then(
      _value.copyWith(
            modules: null == modules
                ? _value.modules
                : modules // ignore: cast_nullable_to_non_nullable
                      as List<PermissionModuleModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PermissionsCatalogModelImplCopyWith<$Res>
    implements $PermissionsCatalogModelCopyWith<$Res> {
  factory _$$PermissionsCatalogModelImplCopyWith(
    _$PermissionsCatalogModelImpl value,
    $Res Function(_$PermissionsCatalogModelImpl) then,
  ) = __$$PermissionsCatalogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PermissionModuleModel> modules});
}

/// @nodoc
class __$$PermissionsCatalogModelImplCopyWithImpl<$Res>
    extends
        _$PermissionsCatalogModelCopyWithImpl<
          $Res,
          _$PermissionsCatalogModelImpl
        >
    implements _$$PermissionsCatalogModelImplCopyWith<$Res> {
  __$$PermissionsCatalogModelImplCopyWithImpl(
    _$PermissionsCatalogModelImpl _value,
    $Res Function(_$PermissionsCatalogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PermissionsCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? modules = null}) {
    return _then(
      _$PermissionsCatalogModelImpl(
        modules: null == modules
            ? _value._modules
            : modules // ignore: cast_nullable_to_non_nullable
                  as List<PermissionModuleModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionsCatalogModelImpl implements _PermissionsCatalogModel {
  const _$PermissionsCatalogModelImpl({
    final List<PermissionModuleModel> modules = const [],
  }) : _modules = modules;

  factory _$PermissionsCatalogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionsCatalogModelImplFromJson(json);

  final List<PermissionModuleModel> _modules;
  @override
  @JsonKey()
  List<PermissionModuleModel> get modules {
    if (_modules is EqualUnmodifiableListView) return _modules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modules);
  }

  @override
  String toString() {
    return 'PermissionsCatalogModel(modules: $modules)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionsCatalogModelImpl &&
            const DeepCollectionEquality().equals(other._modules, _modules));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_modules));

  /// Create a copy of PermissionsCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionsCatalogModelImplCopyWith<_$PermissionsCatalogModelImpl>
  get copyWith =>
      __$$PermissionsCatalogModelImplCopyWithImpl<
        _$PermissionsCatalogModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionsCatalogModelImplToJson(this);
  }
}

abstract class _PermissionsCatalogModel implements PermissionsCatalogModel {
  const factory _PermissionsCatalogModel({
    final List<PermissionModuleModel> modules,
  }) = _$PermissionsCatalogModelImpl;

  factory _PermissionsCatalogModel.fromJson(Map<String, dynamic> json) =
      _$PermissionsCatalogModelImpl.fromJson;

  @override
  List<PermissionModuleModel> get modules;

  /// Create a copy of PermissionsCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionsCatalogModelImplCopyWith<_$PermissionsCatalogModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
