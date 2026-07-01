// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_of_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChartOfAccountModel _$ChartOfAccountModelFromJson(Map<String, dynamic> json) {
  return _ChartOfAccountModel.fromJson(json);
}

/// @nodoc
mixin _$ChartOfAccountModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_code')
  String get accountCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_type')
  String get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_subtype')
  String? get accountSubtype => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_system')
  bool get isSystem => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  String? get deletedAt => throw _privateConstructorUsedError;
  List<ChartOfAccountModel> get children => throw _privateConstructorUsedError;

  /// Serializes this ChartOfAccountModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartOfAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartOfAccountModelCopyWith<ChartOfAccountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartOfAccountModelCopyWith<$Res> {
  factory $ChartOfAccountModelCopyWith(
    ChartOfAccountModel value,
    $Res Function(ChartOfAccountModel) then,
  ) = _$ChartOfAccountModelCopyWithImpl<$Res, ChartOfAccountModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'account_code') String accountCode,
    @JsonKey(name: 'account_name') String accountName,
    @JsonKey(name: 'account_type') String accountType,
    @JsonKey(name: 'account_subtype') String? accountSubtype,
    @JsonKey(name: 'is_system') bool isSystem,
    @JsonKey(name: 'is_active') bool isActive,
    String? description,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    List<ChartOfAccountModel> children,
  });
}

/// @nodoc
class _$ChartOfAccountModelCopyWithImpl<$Res, $Val extends ChartOfAccountModel>
    implements $ChartOfAccountModelCopyWith<$Res> {
  _$ChartOfAccountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartOfAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? parentId = freezed,
    Object? accountCode = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? accountSubtype = freezed,
    Object? isSystem = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? children = null,
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
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountCode: null == accountCode
                ? _value.accountCode
                : accountCode // ignore: cast_nullable_to_non_nullable
                      as String,
            accountName: null == accountName
                ? _value.accountName
                : accountName // ignore: cast_nullable_to_non_nullable
                      as String,
            accountType: null == accountType
                ? _value.accountType
                : accountType // ignore: cast_nullable_to_non_nullable
                      as String,
            accountSubtype: freezed == accountSubtype
                ? _value.accountSubtype
                : accountSubtype // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSystem: null == isSystem
                ? _value.isSystem
                : isSystem // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<ChartOfAccountModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChartOfAccountModelImplCopyWith<$Res>
    implements $ChartOfAccountModelCopyWith<$Res> {
  factory _$$ChartOfAccountModelImplCopyWith(
    _$ChartOfAccountModelImpl value,
    $Res Function(_$ChartOfAccountModelImpl) then,
  ) = __$$ChartOfAccountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'account_code') String accountCode,
    @JsonKey(name: 'account_name') String accountName,
    @JsonKey(name: 'account_type') String accountType,
    @JsonKey(name: 'account_subtype') String? accountSubtype,
    @JsonKey(name: 'is_system') bool isSystem,
    @JsonKey(name: 'is_active') bool isActive,
    String? description,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    List<ChartOfAccountModel> children,
  });
}

/// @nodoc
class __$$ChartOfAccountModelImplCopyWithImpl<$Res>
    extends _$ChartOfAccountModelCopyWithImpl<$Res, _$ChartOfAccountModelImpl>
    implements _$$ChartOfAccountModelImplCopyWith<$Res> {
  __$$ChartOfAccountModelImplCopyWithImpl(
    _$ChartOfAccountModelImpl _value,
    $Res Function(_$ChartOfAccountModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChartOfAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? parentId = freezed,
    Object? accountCode = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? accountSubtype = freezed,
    Object? isSystem = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? children = null,
  }) {
    return _then(
      _$ChartOfAccountModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountCode: null == accountCode
            ? _value.accountCode
            : accountCode // ignore: cast_nullable_to_non_nullable
                  as String,
        accountName: null == accountName
            ? _value.accountName
            : accountName // ignore: cast_nullable_to_non_nullable
                  as String,
        accountType: null == accountType
            ? _value.accountType
            : accountType // ignore: cast_nullable_to_non_nullable
                  as String,
        accountSubtype: freezed == accountSubtype
            ? _value.accountSubtype
            : accountSubtype // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSystem: null == isSystem
            ? _value.isSystem
            : isSystem // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<ChartOfAccountModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartOfAccountModelImpl implements _ChartOfAccountModel {
  const _$ChartOfAccountModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'parent_id') this.parentId,
    @JsonKey(name: 'account_code') required this.accountCode,
    @JsonKey(name: 'account_name') required this.accountName,
    @JsonKey(name: 'account_type') required this.accountType,
    @JsonKey(name: 'account_subtype') this.accountSubtype,
    @JsonKey(name: 'is_system') this.isSystem = false,
    @JsonKey(name: 'is_active') this.isActive = true,
    this.description,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'deleted_at') this.deletedAt,
    final List<ChartOfAccountModel> children = const [],
  }) : _children = children;

  factory _$ChartOfAccountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartOfAccountModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @override
  @JsonKey(name: 'account_code')
  final String accountCode;
  @override
  @JsonKey(name: 'account_name')
  final String accountName;
  @override
  @JsonKey(name: 'account_type')
  final String accountType;
  @override
  @JsonKey(name: 'account_subtype')
  final String? accountSubtype;
  @override
  @JsonKey(name: 'is_system')
  final bool isSystem;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final List<ChartOfAccountModel> _children;
  @override
  @JsonKey()
  List<ChartOfAccountModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'ChartOfAccountModel(id: $id, businessId: $businessId, parentId: $parentId, accountCode: $accountCode, accountName: $accountName, accountType: $accountType, accountSubtype: $accountSubtype, isSystem: $isSystem, isActive: $isActive, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartOfAccountModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.accountSubtype, accountSubtype) ||
                other.accountSubtype == accountSubtype) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    parentId,
    accountCode,
    accountName,
    accountType,
    accountSubtype,
    isSystem,
    isActive,
    description,
    createdAt,
    updatedAt,
    deletedAt,
    const DeepCollectionEquality().hash(_children),
  );

  /// Create a copy of ChartOfAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartOfAccountModelImplCopyWith<_$ChartOfAccountModelImpl> get copyWith =>
      __$$ChartOfAccountModelImplCopyWithImpl<_$ChartOfAccountModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartOfAccountModelImplToJson(this);
  }
}

abstract class _ChartOfAccountModel implements ChartOfAccountModel {
  const factory _ChartOfAccountModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'parent_id') final String? parentId,
    @JsonKey(name: 'account_code') required final String accountCode,
    @JsonKey(name: 'account_name') required final String accountName,
    @JsonKey(name: 'account_type') required final String accountType,
    @JsonKey(name: 'account_subtype') final String? accountSubtype,
    @JsonKey(name: 'is_system') final bool isSystem,
    @JsonKey(name: 'is_active') final bool isActive,
    final String? description,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'updated_at') required final String updatedAt,
    @JsonKey(name: 'deleted_at') final String? deletedAt,
    final List<ChartOfAccountModel> children,
  }) = _$ChartOfAccountModelImpl;

  factory _ChartOfAccountModel.fromJson(Map<String, dynamic> json) =
      _$ChartOfAccountModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;
  @override
  @JsonKey(name: 'account_code')
  String get accountCode;
  @override
  @JsonKey(name: 'account_name')
  String get accountName;
  @override
  @JsonKey(name: 'account_type')
  String get accountType;
  @override
  @JsonKey(name: 'account_subtype')
  String? get accountSubtype;
  @override
  @JsonKey(name: 'is_system')
  bool get isSystem;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  String? get description;
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
  List<ChartOfAccountModel> get children;

  /// Create a copy of ChartOfAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartOfAccountModelImplCopyWith<_$ChartOfAccountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
