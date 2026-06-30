// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floor_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FloorPlanModel _$FloorPlanModelFromJson(Map<String, dynamic> json) {
  return _FloorPlanModel.fromJson(json);
}

/// @nodoc
mixin _$FloorPlanModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
  Map<String, dynamic> get layoutJson => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FloorPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FloorPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FloorPlanModelCopyWith<FloorPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloorPlanModelCopyWith<$Res> {
  factory $FloorPlanModelCopyWith(
    FloorPlanModel value,
    $Res Function(FloorPlanModel) then,
  ) = _$FloorPlanModelCopyWithImpl<$Res, FloorPlanModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    String name,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    Map<String, dynamic> layoutJson,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$FloorPlanModelCopyWithImpl<$Res, $Val extends FloorPlanModel>
    implements $FloorPlanModelCopyWith<$Res> {
  _$FloorPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FloorPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? layoutJson = null,
    Object? createdAt = freezed,
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
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            layoutJson: null == layoutJson
                ? _value.layoutJson
                : layoutJson // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$FloorPlanModelImplCopyWith<$Res>
    implements $FloorPlanModelCopyWith<$Res> {
  factory _$$FloorPlanModelImplCopyWith(
    _$FloorPlanModelImpl value,
    $Res Function(_$FloorPlanModelImpl) then,
  ) = __$$FloorPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    String name,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    Map<String, dynamic> layoutJson,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$FloorPlanModelImplCopyWithImpl<$Res>
    extends _$FloorPlanModelCopyWithImpl<$Res, _$FloorPlanModelImpl>
    implements _$$FloorPlanModelImplCopyWith<$Res> {
  __$$FloorPlanModelImplCopyWithImpl(
    _$FloorPlanModelImpl _value,
    $Res Function(_$FloorPlanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FloorPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? layoutJson = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FloorPlanModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        layoutJson: null == layoutJson
            ? _value._layoutJson
            : layoutJson // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$FloorPlanModelImpl implements _FloorPlanModel {
  const _$FloorPlanModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    required this.name,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    final Map<String, dynamic> layoutJson = const {},
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _layoutJson = layoutJson;

  factory _$FloorPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FloorPlanModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  final String name;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, dynamic> _layoutJson;
  @override
  @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
  Map<String, dynamic> get layoutJson {
    if (_layoutJson is EqualUnmodifiableMapView) return _layoutJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_layoutJson);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'FloorPlanModel(id: $id, businessId: $businessId, branchId: $branchId, name: $name, sortOrder: $sortOrder, isActive: $isActive, layoutJson: $layoutJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FloorPlanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._layoutJson,
              _layoutJson,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
    name,
    sortOrder,
    isActive,
    const DeepCollectionEquality().hash(_layoutJson),
    createdAt,
    updatedAt,
  );

  /// Create a copy of FloorPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FloorPlanModelImplCopyWith<_$FloorPlanModelImpl> get copyWith =>
      __$$FloorPlanModelImplCopyWithImpl<_$FloorPlanModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FloorPlanModelImplToJson(this);
  }
}

abstract class _FloorPlanModel implements FloorPlanModel {
  const factory _FloorPlanModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    required final String name,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    final Map<String, dynamic> layoutJson,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$FloorPlanModelImpl;

  factory _FloorPlanModel.fromJson(Map<String, dynamic> json) =
      _$FloorPlanModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  String get name;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
  Map<String, dynamic> get layoutJson;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of FloorPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FloorPlanModelImplCopyWith<_$FloorPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FloorPlanWithTablesModel _$FloorPlanWithTablesModelFromJson(
  Map<String, dynamic> json,
) {
  return _FloorPlanWithTablesModel.fromJson(json);
}

/// @nodoc
mixin _$FloorPlanWithTablesModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
  Map<String, dynamic> get layoutJson => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _diningTableListFromJson)
  List<DiningTableModel> get tables => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FloorPlanWithTablesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FloorPlanWithTablesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FloorPlanWithTablesModelCopyWith<FloorPlanWithTablesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloorPlanWithTablesModelCopyWith<$Res> {
  factory $FloorPlanWithTablesModelCopyWith(
    FloorPlanWithTablesModel value,
    $Res Function(FloorPlanWithTablesModel) then,
  ) = _$FloorPlanWithTablesModelCopyWithImpl<$Res, FloorPlanWithTablesModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    String name,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    Map<String, dynamic> layoutJson,
    @JsonKey(fromJson: _diningTableListFromJson) List<DiningTableModel> tables,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$FloorPlanWithTablesModelCopyWithImpl<
  $Res,
  $Val extends FloorPlanWithTablesModel
>
    implements $FloorPlanWithTablesModelCopyWith<$Res> {
  _$FloorPlanWithTablesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FloorPlanWithTablesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? layoutJson = null,
    Object? tables = null,
    Object? createdAt = freezed,
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
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            layoutJson: null == layoutJson
                ? _value.layoutJson
                : layoutJson // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            tables: null == tables
                ? _value.tables
                : tables // ignore: cast_nullable_to_non_nullable
                      as List<DiningTableModel>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$FloorPlanWithTablesModelImplCopyWith<$Res>
    implements $FloorPlanWithTablesModelCopyWith<$Res> {
  factory _$$FloorPlanWithTablesModelImplCopyWith(
    _$FloorPlanWithTablesModelImpl value,
    $Res Function(_$FloorPlanWithTablesModelImpl) then,
  ) = __$$FloorPlanWithTablesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    String name,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    Map<String, dynamic> layoutJson,
    @JsonKey(fromJson: _diningTableListFromJson) List<DiningTableModel> tables,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$FloorPlanWithTablesModelImplCopyWithImpl<$Res>
    extends
        _$FloorPlanWithTablesModelCopyWithImpl<
          $Res,
          _$FloorPlanWithTablesModelImpl
        >
    implements _$$FloorPlanWithTablesModelImplCopyWith<$Res> {
  __$$FloorPlanWithTablesModelImplCopyWithImpl(
    _$FloorPlanWithTablesModelImpl _value,
    $Res Function(_$FloorPlanWithTablesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FloorPlanWithTablesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? layoutJson = null,
    Object? tables = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FloorPlanWithTablesModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        layoutJson: null == layoutJson
            ? _value._layoutJson
            : layoutJson // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        tables: null == tables
            ? _value._tables
            : tables // ignore: cast_nullable_to_non_nullable
                  as List<DiningTableModel>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$FloorPlanWithTablesModelImpl implements _FloorPlanWithTablesModel {
  const _$FloorPlanWithTablesModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    required this.name,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    final Map<String, dynamic> layoutJson = const {},
    @JsonKey(fromJson: _diningTableListFromJson)
    final List<DiningTableModel> tables = const [],
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _layoutJson = layoutJson,
       _tables = tables;

  factory _$FloorPlanWithTablesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FloorPlanWithTablesModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  final String name;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, dynamic> _layoutJson;
  @override
  @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
  Map<String, dynamic> get layoutJson {
    if (_layoutJson is EqualUnmodifiableMapView) return _layoutJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_layoutJson);
  }

  final List<DiningTableModel> _tables;
  @override
  @JsonKey(fromJson: _diningTableListFromJson)
  List<DiningTableModel> get tables {
    if (_tables is EqualUnmodifiableListView) return _tables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tables);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'FloorPlanWithTablesModel(id: $id, businessId: $businessId, branchId: $branchId, name: $name, sortOrder: $sortOrder, isActive: $isActive, layoutJson: $layoutJson, tables: $tables, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FloorPlanWithTablesModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._layoutJson,
              _layoutJson,
            ) &&
            const DeepCollectionEquality().equals(other._tables, _tables) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
    name,
    sortOrder,
    isActive,
    const DeepCollectionEquality().hash(_layoutJson),
    const DeepCollectionEquality().hash(_tables),
    createdAt,
    updatedAt,
  );

  /// Create a copy of FloorPlanWithTablesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FloorPlanWithTablesModelImplCopyWith<_$FloorPlanWithTablesModelImpl>
  get copyWith =>
      __$$FloorPlanWithTablesModelImplCopyWithImpl<
        _$FloorPlanWithTablesModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FloorPlanWithTablesModelImplToJson(this);
  }
}

abstract class _FloorPlanWithTablesModel implements FloorPlanWithTablesModel {
  const factory _FloorPlanWithTablesModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    required final String name,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    final Map<String, dynamic> layoutJson,
    @JsonKey(fromJson: _diningTableListFromJson)
    final List<DiningTableModel> tables,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$FloorPlanWithTablesModelImpl;

  factory _FloorPlanWithTablesModel.fromJson(Map<String, dynamic> json) =
      _$FloorPlanWithTablesModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  String get name;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
  Map<String, dynamic> get layoutJson;
  @override
  @JsonKey(fromJson: _diningTableListFromJson)
  List<DiningTableModel> get tables;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of FloorPlanWithTablesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FloorPlanWithTablesModelImplCopyWith<_$FloorPlanWithTablesModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FloorLayoutModel _$FloorLayoutModelFromJson(Map<String, dynamic> json) {
  return _FloorLayoutModel.fromJson(json);
}

/// @nodoc
mixin _$FloorLayoutModel {
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
  List<FloorPlanWithTablesModel> get floorPlans =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
  List<DiningTableModel> get unassignedTables =>
      throw _privateConstructorUsedError;

  /// Serializes this FloorLayoutModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FloorLayoutModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FloorLayoutModelCopyWith<FloorLayoutModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloorLayoutModelCopyWith<$Res> {
  factory $FloorLayoutModelCopyWith(
    FloorLayoutModel value,
    $Res Function(FloorLayoutModel) then,
  ) = _$FloorLayoutModelCopyWithImpl<$Res, FloorLayoutModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
    List<FloorPlanWithTablesModel> floorPlans,
    @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
    List<DiningTableModel> unassignedTables,
  });
}

/// @nodoc
class _$FloorLayoutModelCopyWithImpl<$Res, $Val extends FloorLayoutModel>
    implements $FloorLayoutModelCopyWith<$Res> {
  _$FloorLayoutModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FloorLayoutModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = null,
    Object? floorPlans = null,
    Object? unassignedTables = null,
  }) {
    return _then(
      _value.copyWith(
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            floorPlans: null == floorPlans
                ? _value.floorPlans
                : floorPlans // ignore: cast_nullable_to_non_nullable
                      as List<FloorPlanWithTablesModel>,
            unassignedTables: null == unassignedTables
                ? _value.unassignedTables
                : unassignedTables // ignore: cast_nullable_to_non_nullable
                      as List<DiningTableModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FloorLayoutModelImplCopyWith<$Res>
    implements $FloorLayoutModelCopyWith<$Res> {
  factory _$$FloorLayoutModelImplCopyWith(
    _$FloorLayoutModelImpl value,
    $Res Function(_$FloorLayoutModelImpl) then,
  ) = __$$FloorLayoutModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
    List<FloorPlanWithTablesModel> floorPlans,
    @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
    List<DiningTableModel> unassignedTables,
  });
}

/// @nodoc
class __$$FloorLayoutModelImplCopyWithImpl<$Res>
    extends _$FloorLayoutModelCopyWithImpl<$Res, _$FloorLayoutModelImpl>
    implements _$$FloorLayoutModelImplCopyWith<$Res> {
  __$$FloorLayoutModelImplCopyWithImpl(
    _$FloorLayoutModelImpl _value,
    $Res Function(_$FloorLayoutModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FloorLayoutModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = null,
    Object? floorPlans = null,
    Object? unassignedTables = null,
  }) {
    return _then(
      _$FloorLayoutModelImpl(
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        floorPlans: null == floorPlans
            ? _value._floorPlans
            : floorPlans // ignore: cast_nullable_to_non_nullable
                  as List<FloorPlanWithTablesModel>,
        unassignedTables: null == unassignedTables
            ? _value._unassignedTables
            : unassignedTables // ignore: cast_nullable_to_non_nullable
                  as List<DiningTableModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FloorLayoutModelImpl implements _FloorLayoutModel {
  const _$FloorLayoutModelImpl({
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
    final List<FloorPlanWithTablesModel> floorPlans = const [],
    @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
    final List<DiningTableModel> unassignedTables = const [],
  }) : _floorPlans = floorPlans,
       _unassignedTables = unassignedTables;

  factory _$FloorLayoutModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FloorLayoutModelImplFromJson(json);

  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  final List<FloorPlanWithTablesModel> _floorPlans;
  @override
  @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
  List<FloorPlanWithTablesModel> get floorPlans {
    if (_floorPlans is EqualUnmodifiableListView) return _floorPlans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_floorPlans);
  }

  final List<DiningTableModel> _unassignedTables;
  @override
  @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
  List<DiningTableModel> get unassignedTables {
    if (_unassignedTables is EqualUnmodifiableListView)
      return _unassignedTables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unassignedTables);
  }

  @override
  String toString() {
    return 'FloorLayoutModel(branchId: $branchId, floorPlans: $floorPlans, unassignedTables: $unassignedTables)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FloorLayoutModelImpl &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            const DeepCollectionEquality().equals(
              other._floorPlans,
              _floorPlans,
            ) &&
            const DeepCollectionEquality().equals(
              other._unassignedTables,
              _unassignedTables,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    branchId,
    const DeepCollectionEquality().hash(_floorPlans),
    const DeepCollectionEquality().hash(_unassignedTables),
  );

  /// Create a copy of FloorLayoutModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FloorLayoutModelImplCopyWith<_$FloorLayoutModelImpl> get copyWith =>
      __$$FloorLayoutModelImplCopyWithImpl<_$FloorLayoutModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FloorLayoutModelImplToJson(this);
  }
}

abstract class _FloorLayoutModel implements FloorLayoutModel {
  const factory _FloorLayoutModel({
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
    final List<FloorPlanWithTablesModel> floorPlans,
    @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
    final List<DiningTableModel> unassignedTables,
  }) = _$FloorLayoutModelImpl;

  factory _FloorLayoutModel.fromJson(Map<String, dynamic> json) =
      _$FloorLayoutModelImpl.fromJson;

  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
  List<FloorPlanWithTablesModel> get floorPlans;
  @override
  @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
  List<DiningTableModel> get unassignedTables;

  /// Create a copy of FloorLayoutModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FloorLayoutModelImplCopyWith<_$FloorLayoutModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiningTableModel _$DiningTableModelFromJson(Map<String, dynamic> json) {
  return _DiningTableModel.fromJson(json);
}

/// @nodoc
mixin _$DiningTableModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_plan_id')
  String? get floorPlanId => throw _privateConstructorUsedError;
  @JsonKey(name: 'table_number')
  String get tableNumber => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'pos_x')
  String? get posX => throw _privateConstructorUsedError;
  @JsonKey(name: 'pos_y')
  String? get posY => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_sale_id')
  String? get activeSaleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DiningTableModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiningTableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiningTableModelCopyWith<DiningTableModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiningTableModelCopyWith<$Res> {
  factory $DiningTableModelCopyWith(
    DiningTableModel value,
    $Res Function(DiningTableModel) then,
  ) = _$DiningTableModelCopyWithImpl<$Res, DiningTableModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'floor_plan_id') String? floorPlanId,
    @JsonKey(name: 'table_number') String tableNumber,
    int capacity,
    String status,
    @JsonKey(name: 'pos_x') String? posX,
    @JsonKey(name: 'pos_y') String? posY,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'active_sale_id') String? activeSaleId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$DiningTableModelCopyWithImpl<$Res, $Val extends DiningTableModel>
    implements $DiningTableModelCopyWith<$Res> {
  _$DiningTableModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiningTableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? floorPlanId = freezed,
    Object? tableNumber = null,
    Object? capacity = null,
    Object? status = null,
    Object? posX = freezed,
    Object? posY = freezed,
    Object? isActive = null,
    Object? activeSaleId = freezed,
    Object? createdAt = freezed,
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
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            floorPlanId: freezed == floorPlanId
                ? _value.floorPlanId
                : floorPlanId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tableNumber: null == tableNumber
                ? _value.tableNumber
                : tableNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            posX: freezed == posX
                ? _value.posX
                : posX // ignore: cast_nullable_to_non_nullable
                      as String?,
            posY: freezed == posY
                ? _value.posY
                : posY // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            activeSaleId: freezed == activeSaleId
                ? _value.activeSaleId
                : activeSaleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$DiningTableModelImplCopyWith<$Res>
    implements $DiningTableModelCopyWith<$Res> {
  factory _$$DiningTableModelImplCopyWith(
    _$DiningTableModelImpl value,
    $Res Function(_$DiningTableModelImpl) then,
  ) = __$$DiningTableModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'floor_plan_id') String? floorPlanId,
    @JsonKey(name: 'table_number') String tableNumber,
    int capacity,
    String status,
    @JsonKey(name: 'pos_x') String? posX,
    @JsonKey(name: 'pos_y') String? posY,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'active_sale_id') String? activeSaleId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$DiningTableModelImplCopyWithImpl<$Res>
    extends _$DiningTableModelCopyWithImpl<$Res, _$DiningTableModelImpl>
    implements _$$DiningTableModelImplCopyWith<$Res> {
  __$$DiningTableModelImplCopyWithImpl(
    _$DiningTableModelImpl _value,
    $Res Function(_$DiningTableModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiningTableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? floorPlanId = freezed,
    Object? tableNumber = null,
    Object? capacity = null,
    Object? status = null,
    Object? posX = freezed,
    Object? posY = freezed,
    Object? isActive = null,
    Object? activeSaleId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DiningTableModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        floorPlanId: freezed == floorPlanId
            ? _value.floorPlanId
            : floorPlanId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tableNumber: null == tableNumber
            ? _value.tableNumber
            : tableNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        posX: freezed == posX
            ? _value.posX
            : posX // ignore: cast_nullable_to_non_nullable
                  as String?,
        posY: freezed == posY
            ? _value.posY
            : posY // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        activeSaleId: freezed == activeSaleId
            ? _value.activeSaleId
            : activeSaleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$DiningTableModelImpl implements _DiningTableModel {
  const _$DiningTableModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'floor_plan_id') this.floorPlanId,
    @JsonKey(name: 'table_number') required this.tableNumber,
    this.capacity = 4,
    required this.status,
    @JsonKey(name: 'pos_x') this.posX,
    @JsonKey(name: 'pos_y') this.posY,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'active_sale_id') this.activeSaleId,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$DiningTableModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiningTableModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'floor_plan_id')
  final String? floorPlanId;
  @override
  @JsonKey(name: 'table_number')
  final String tableNumber;
  @override
  @JsonKey()
  final int capacity;
  @override
  final String status;
  @override
  @JsonKey(name: 'pos_x')
  final String? posX;
  @override
  @JsonKey(name: 'pos_y')
  final String? posY;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'active_sale_id')
  final String? activeSaleId;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'DiningTableModel(id: $id, businessId: $businessId, branchId: $branchId, floorPlanId: $floorPlanId, tableNumber: $tableNumber, capacity: $capacity, status: $status, posX: $posX, posY: $posY, isActive: $isActive, activeSaleId: $activeSaleId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiningTableModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.floorPlanId, floorPlanId) ||
                other.floorPlanId == floorPlanId) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.posX, posX) || other.posX == posX) &&
            (identical(other.posY, posY) || other.posY == posY) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.activeSaleId, activeSaleId) ||
                other.activeSaleId == activeSaleId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
    floorPlanId,
    tableNumber,
    capacity,
    status,
    posX,
    posY,
    isActive,
    activeSaleId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DiningTableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiningTableModelImplCopyWith<_$DiningTableModelImpl> get copyWith =>
      __$$DiningTableModelImplCopyWithImpl<_$DiningTableModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiningTableModelImplToJson(this);
  }
}

abstract class _DiningTableModel implements DiningTableModel {
  const factory _DiningTableModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'floor_plan_id') final String? floorPlanId,
    @JsonKey(name: 'table_number') required final String tableNumber,
    final int capacity,
    required final String status,
    @JsonKey(name: 'pos_x') final String? posX,
    @JsonKey(name: 'pos_y') final String? posY,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'active_sale_id') final String? activeSaleId,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$DiningTableModelImpl;

  factory _DiningTableModel.fromJson(Map<String, dynamic> json) =
      _$DiningTableModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'floor_plan_id')
  String? get floorPlanId;
  @override
  @JsonKey(name: 'table_number')
  String get tableNumber;
  @override
  int get capacity;
  @override
  String get status;
  @override
  @JsonKey(name: 'pos_x')
  String? get posX;
  @override
  @JsonKey(name: 'pos_y')
  String? get posY;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'active_sale_id')
  String? get activeSaleId;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of DiningTableModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiningTableModelImplCopyWith<_$DiningTableModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
