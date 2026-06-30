// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RoleFormState {
  String get mode => throw _privateConstructorUsedError;
  String? get roleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isSystem => throw _privateConstructorUsedError;
  PermissionsCatalogModel? get catalog => throw _privateConstructorUsedError;
  List<String> get selectedPermissionKeys => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  bool get accessDenied => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of RoleFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleFormStateCopyWith<RoleFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleFormStateCopyWith<$Res> {
  factory $RoleFormStateCopyWith(
    RoleFormState value,
    $Res Function(RoleFormState) then,
  ) = _$RoleFormStateCopyWithImpl<$Res, RoleFormState>;
  @useResult
  $Res call({
    String mode,
    String? roleId,
    String name,
    String description,
    bool isSystem,
    PermissionsCatalogModel? catalog,
    List<String> selectedPermissionKeys,
    bool isLoading,
    bool isSubmitting,
    bool isDeleting,
    bool accessDenied,
    Map<String, String> errors,
  });

  $PermissionsCatalogModelCopyWith<$Res>? get catalog;
}

/// @nodoc
class _$RoleFormStateCopyWithImpl<$Res, $Val extends RoleFormState>
    implements $RoleFormStateCopyWith<$Res> {
  _$RoleFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? roleId = freezed,
    Object? name = null,
    Object? description = null,
    Object? isSystem = null,
    Object? catalog = freezed,
    Object? selectedPermissionKeys = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isDeleting = null,
    Object? accessDenied = null,
    Object? errors = null,
  }) {
    return _then(
      _value.copyWith(
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String,
            roleId: freezed == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            isSystem: null == isSystem
                ? _value.isSystem
                : isSystem // ignore: cast_nullable_to_non_nullable
                      as bool,
            catalog: freezed == catalog
                ? _value.catalog
                : catalog // ignore: cast_nullable_to_non_nullable
                      as PermissionsCatalogModel?,
            selectedPermissionKeys: null == selectedPermissionKeys
                ? _value.selectedPermissionKeys
                : selectedPermissionKeys // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDeleting: null == isDeleting
                ? _value.isDeleting
                : isDeleting // ignore: cast_nullable_to_non_nullable
                      as bool,
            accessDenied: null == accessDenied
                ? _value.accessDenied
                : accessDenied // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }

  /// Create a copy of RoleFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PermissionsCatalogModelCopyWith<$Res>? get catalog {
    if (_value.catalog == null) {
      return null;
    }

    return $PermissionsCatalogModelCopyWith<$Res>(_value.catalog!, (value) {
      return _then(_value.copyWith(catalog: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoleFormStateImplCopyWith<$Res>
    implements $RoleFormStateCopyWith<$Res> {
  factory _$$RoleFormStateImplCopyWith(
    _$RoleFormStateImpl value,
    $Res Function(_$RoleFormStateImpl) then,
  ) = __$$RoleFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String mode,
    String? roleId,
    String name,
    String description,
    bool isSystem,
    PermissionsCatalogModel? catalog,
    List<String> selectedPermissionKeys,
    bool isLoading,
    bool isSubmitting,
    bool isDeleting,
    bool accessDenied,
    Map<String, String> errors,
  });

  @override
  $PermissionsCatalogModelCopyWith<$Res>? get catalog;
}

/// @nodoc
class __$$RoleFormStateImplCopyWithImpl<$Res>
    extends _$RoleFormStateCopyWithImpl<$Res, _$RoleFormStateImpl>
    implements _$$RoleFormStateImplCopyWith<$Res> {
  __$$RoleFormStateImplCopyWithImpl(
    _$RoleFormStateImpl _value,
    $Res Function(_$RoleFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoleFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? roleId = freezed,
    Object? name = null,
    Object? description = null,
    Object? isSystem = null,
    Object? catalog = freezed,
    Object? selectedPermissionKeys = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isDeleting = null,
    Object? accessDenied = null,
    Object? errors = null,
  }) {
    return _then(
      _$RoleFormStateImpl(
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
        roleId: freezed == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        isSystem: null == isSystem
            ? _value.isSystem
            : isSystem // ignore: cast_nullable_to_non_nullable
                  as bool,
        catalog: freezed == catalog
            ? _value.catalog
            : catalog // ignore: cast_nullable_to_non_nullable
                  as PermissionsCatalogModel?,
        selectedPermissionKeys: null == selectedPermissionKeys
            ? _value._selectedPermissionKeys
            : selectedPermissionKeys // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDeleting: null == isDeleting
            ? _value.isDeleting
            : isDeleting // ignore: cast_nullable_to_non_nullable
                  as bool,
        accessDenied: null == accessDenied
            ? _value.accessDenied
            : accessDenied // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$RoleFormStateImpl implements _RoleFormState {
  const _$RoleFormStateImpl({
    this.mode = 'create',
    this.roleId,
    this.name = '',
    this.description = '',
    this.isSystem = false,
    this.catalog,
    final List<String> selectedPermissionKeys = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.isDeleting = false,
    this.accessDenied = false,
    final Map<String, String> errors = const {},
  }) : _selectedPermissionKeys = selectedPermissionKeys,
       _errors = errors;

  @override
  @JsonKey()
  final String mode;
  @override
  final String? roleId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isSystem;
  @override
  final PermissionsCatalogModel? catalog;
  final List<String> _selectedPermissionKeys;
  @override
  @JsonKey()
  List<String> get selectedPermissionKeys {
    if (_selectedPermissionKeys is EqualUnmodifiableListView)
      return _selectedPermissionKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedPermissionKeys);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool isDeleting;
  @override
  @JsonKey()
  final bool accessDenied;
  final Map<String, String> _errors;
  @override
  @JsonKey()
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  String toString() {
    return 'RoleFormState(mode: $mode, roleId: $roleId, name: $name, description: $description, isSystem: $isSystem, catalog: $catalog, selectedPermissionKeys: $selectedPermissionKeys, isLoading: $isLoading, isSubmitting: $isSubmitting, isDeleting: $isDeleting, accessDenied: $accessDenied, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleFormStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.catalog, catalog) || other.catalog == catalog) &&
            const DeepCollectionEquality().equals(
              other._selectedPermissionKeys,
              _selectedPermissionKeys,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.accessDenied, accessDenied) ||
                other.accessDenied == accessDenied) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    mode,
    roleId,
    name,
    description,
    isSystem,
    catalog,
    const DeepCollectionEquality().hash(_selectedPermissionKeys),
    isLoading,
    isSubmitting,
    isDeleting,
    accessDenied,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of RoleFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleFormStateImplCopyWith<_$RoleFormStateImpl> get copyWith =>
      __$$RoleFormStateImplCopyWithImpl<_$RoleFormStateImpl>(this, _$identity);
}

abstract class _RoleFormState implements RoleFormState {
  const factory _RoleFormState({
    final String mode,
    final String? roleId,
    final String name,
    final String description,
    final bool isSystem,
    final PermissionsCatalogModel? catalog,
    final List<String> selectedPermissionKeys,
    final bool isLoading,
    final bool isSubmitting,
    final bool isDeleting,
    final bool accessDenied,
    final Map<String, String> errors,
  }) = _$RoleFormStateImpl;

  @override
  String get mode;
  @override
  String? get roleId;
  @override
  String get name;
  @override
  String get description;
  @override
  bool get isSystem;
  @override
  PermissionsCatalogModel? get catalog;
  @override
  List<String> get selectedPermissionKeys;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  bool get isDeleting;
  @override
  bool get accessDenied;
  @override
  Map<String, String> get errors;

  /// Create a copy of RoleFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleFormStateImplCopyWith<_$RoleFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
