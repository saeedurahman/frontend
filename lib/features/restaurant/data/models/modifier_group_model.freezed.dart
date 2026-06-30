// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifier_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ModifierModel _$ModifierModelFromJson(Map<String, dynamic> json) {
  return _ModifierModel.fromJson(json);
}

/// @nodoc
mixin _$ModifierModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'modifier_group_id')
  String get modifierGroupId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_delta')
  String get priceDelta => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ModifierModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModifierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModifierModelCopyWith<ModifierModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModifierModelCopyWith<$Res> {
  factory $ModifierModelCopyWith(
    ModifierModel value,
    $Res Function(ModifierModel) then,
  ) = _$ModifierModelCopyWithImpl<$Res, ModifierModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'modifier_group_id') String modifierGroupId,
    String name,
    @JsonKey(name: 'price_delta') String priceDelta,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$ModifierModelCopyWithImpl<$Res, $Val extends ModifierModel>
    implements $ModifierModelCopyWith<$Res> {
  _$ModifierModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModifierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? modifierGroupId = null,
    Object? name = null,
    Object? priceDelta = null,
    Object? isActive = null,
    Object? sortOrder = null,
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
            modifierGroupId: null == modifierGroupId
                ? _value.modifierGroupId
                : modifierGroupId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            priceDelta: null == priceDelta
                ? _value.priceDelta
                : priceDelta // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$ModifierModelImplCopyWith<$Res>
    implements $ModifierModelCopyWith<$Res> {
  factory _$$ModifierModelImplCopyWith(
    _$ModifierModelImpl value,
    $Res Function(_$ModifierModelImpl) then,
  ) = __$$ModifierModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'modifier_group_id') String modifierGroupId,
    String name,
    @JsonKey(name: 'price_delta') String priceDelta,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$ModifierModelImplCopyWithImpl<$Res>
    extends _$ModifierModelCopyWithImpl<$Res, _$ModifierModelImpl>
    implements _$$ModifierModelImplCopyWith<$Res> {
  __$$ModifierModelImplCopyWithImpl(
    _$ModifierModelImpl _value,
    $Res Function(_$ModifierModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModifierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? modifierGroupId = null,
    Object? name = null,
    Object? priceDelta = null,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ModifierModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        modifierGroupId: null == modifierGroupId
            ? _value.modifierGroupId
            : modifierGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        priceDelta: null == priceDelta
            ? _value.priceDelta
            : priceDelta // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$ModifierModelImpl implements _ModifierModel {
  const _$ModifierModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'modifier_group_id') required this.modifierGroupId,
    required this.name,
    @JsonKey(name: 'price_delta') this.priceDelta = '0',
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$ModifierModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModifierModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'modifier_group_id')
  final String modifierGroupId;
  @override
  final String name;
  @override
  @JsonKey(name: 'price_delta')
  final String priceDelta;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'ModifierModel(id: $id, businessId: $businessId, modifierGroupId: $modifierGroupId, name: $name, priceDelta: $priceDelta, isActive: $isActive, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModifierModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.modifierGroupId, modifierGroupId) ||
                other.modifierGroupId == modifierGroupId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.priceDelta, priceDelta) ||
                other.priceDelta == priceDelta) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
    modifierGroupId,
    name,
    priceDelta,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ModifierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModifierModelImplCopyWith<_$ModifierModelImpl> get copyWith =>
      __$$ModifierModelImplCopyWithImpl<_$ModifierModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModifierModelImplToJson(this);
  }
}

abstract class _ModifierModel implements ModifierModel {
  const factory _ModifierModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'modifier_group_id') required final String modifierGroupId,
    required final String name,
    @JsonKey(name: 'price_delta') final String priceDelta,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$ModifierModelImpl;

  factory _ModifierModel.fromJson(Map<String, dynamic> json) =
      _$ModifierModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'modifier_group_id')
  String get modifierGroupId;
  @override
  String get name;
  @override
  @JsonKey(name: 'price_delta')
  String get priceDelta;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of ModifierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModifierModelImplCopyWith<_$ModifierModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ModifierGroupModel _$ModifierGroupModelFromJson(Map<String, dynamic> json) {
  return _ModifierGroupModel.fromJson(json);
}

/// @nodoc
mixin _$ModifierGroupModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'selection_type')
  String get selectionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_selections')
  int get minSelections => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_selections')
  int? get maxSelections => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_required')
  bool get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _modifierListFromJson)
  List<ModifierModel> get modifiers => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ModifierGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModifierGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModifierGroupModelCopyWith<ModifierGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModifierGroupModelCopyWith<$Res> {
  factory $ModifierGroupModelCopyWith(
    ModifierGroupModel value,
    $Res Function(ModifierGroupModel) then,
  ) = _$ModifierGroupModelCopyWithImpl<$Res, ModifierGroupModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'selection_type') String selectionType,
    @JsonKey(name: 'min_selections') int minSelections,
    @JsonKey(name: 'max_selections') int? maxSelections,
    @JsonKey(name: 'is_required') bool isRequired,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(fromJson: _modifierListFromJson) List<ModifierModel> modifiers,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$ModifierGroupModelCopyWithImpl<$Res, $Val extends ModifierGroupModel>
    implements $ModifierGroupModelCopyWith<$Res> {
  _$ModifierGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModifierGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? selectionType = null,
    Object? minSelections = null,
    Object? maxSelections = freezed,
    Object? isRequired = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? modifiers = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            selectionType: null == selectionType
                ? _value.selectionType
                : selectionType // ignore: cast_nullable_to_non_nullable
                      as String,
            minSelections: null == minSelections
                ? _value.minSelections
                : minSelections // ignore: cast_nullable_to_non_nullable
                      as int,
            maxSelections: freezed == maxSelections
                ? _value.maxSelections
                : maxSelections // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRequired: null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            modifiers: null == modifiers
                ? _value.modifiers
                : modifiers // ignore: cast_nullable_to_non_nullable
                      as List<ModifierModel>,
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
abstract class _$$ModifierGroupModelImplCopyWith<$Res>
    implements $ModifierGroupModelCopyWith<$Res> {
  factory _$$ModifierGroupModelImplCopyWith(
    _$ModifierGroupModelImpl value,
    $Res Function(_$ModifierGroupModelImpl) then,
  ) = __$$ModifierGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'selection_type') String selectionType,
    @JsonKey(name: 'min_selections') int minSelections,
    @JsonKey(name: 'max_selections') int? maxSelections,
    @JsonKey(name: 'is_required') bool isRequired,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(fromJson: _modifierListFromJson) List<ModifierModel> modifiers,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$ModifierGroupModelImplCopyWithImpl<$Res>
    extends _$ModifierGroupModelCopyWithImpl<$Res, _$ModifierGroupModelImpl>
    implements _$$ModifierGroupModelImplCopyWith<$Res> {
  __$$ModifierGroupModelImplCopyWithImpl(
    _$ModifierGroupModelImpl _value,
    $Res Function(_$ModifierGroupModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModifierGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? selectionType = null,
    Object? minSelections = null,
    Object? maxSelections = freezed,
    Object? isRequired = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? modifiers = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ModifierGroupModelImpl(
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
        selectionType: null == selectionType
            ? _value.selectionType
            : selectionType // ignore: cast_nullable_to_non_nullable
                  as String,
        minSelections: null == minSelections
            ? _value.minSelections
            : minSelections // ignore: cast_nullable_to_non_nullable
                  as int,
        maxSelections: freezed == maxSelections
            ? _value.maxSelections
            : maxSelections // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRequired: null == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        modifiers: null == modifiers
            ? _value._modifiers
            : modifiers // ignore: cast_nullable_to_non_nullable
                  as List<ModifierModel>,
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
class _$ModifierGroupModelImpl implements _ModifierGroupModel {
  const _$ModifierGroupModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    @JsonKey(name: 'selection_type') required this.selectionType,
    @JsonKey(name: 'min_selections') this.minSelections = 0,
    @JsonKey(name: 'max_selections') this.maxSelections,
    @JsonKey(name: 'is_required') this.isRequired = false,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(fromJson: _modifierListFromJson)
    final List<ModifierModel> modifiers = const [],
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _modifiers = modifiers;

  factory _$ModifierGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModifierGroupModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  @JsonKey(name: 'selection_type')
  final String selectionType;
  @override
  @JsonKey(name: 'min_selections')
  final int minSelections;
  @override
  @JsonKey(name: 'max_selections')
  final int? maxSelections;
  @override
  @JsonKey(name: 'is_required')
  final bool isRequired;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<ModifierModel> _modifiers;
  @override
  @JsonKey(fromJson: _modifierListFromJson)
  List<ModifierModel> get modifiers {
    if (_modifiers is EqualUnmodifiableListView) return _modifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modifiers);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'ModifierGroupModel(id: $id, businessId: $businessId, name: $name, selectionType: $selectionType, minSelections: $minSelections, maxSelections: $maxSelections, isRequired: $isRequired, sortOrder: $sortOrder, isActive: $isActive, modifiers: $modifiers, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModifierGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.selectionType, selectionType) ||
                other.selectionType == selectionType) &&
            (identical(other.minSelections, minSelections) ||
                other.minSelections == minSelections) &&
            (identical(other.maxSelections, maxSelections) ||
                other.maxSelections == maxSelections) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._modifiers,
              _modifiers,
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
    name,
    selectionType,
    minSelections,
    maxSelections,
    isRequired,
    sortOrder,
    isActive,
    const DeepCollectionEquality().hash(_modifiers),
    createdAt,
    updatedAt,
  );

  /// Create a copy of ModifierGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModifierGroupModelImplCopyWith<_$ModifierGroupModelImpl> get copyWith =>
      __$$ModifierGroupModelImplCopyWithImpl<_$ModifierGroupModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ModifierGroupModelImplToJson(this);
  }
}

abstract class _ModifierGroupModel implements ModifierGroupModel {
  const factory _ModifierGroupModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    @JsonKey(name: 'selection_type') required final String selectionType,
    @JsonKey(name: 'min_selections') final int minSelections,
    @JsonKey(name: 'max_selections') final int? maxSelections,
    @JsonKey(name: 'is_required') final bool isRequired,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(fromJson: _modifierListFromJson)
    final List<ModifierModel> modifiers,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$ModifierGroupModelImpl;

  factory _ModifierGroupModel.fromJson(Map<String, dynamic> json) =
      _$ModifierGroupModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  @JsonKey(name: 'selection_type')
  String get selectionType;
  @override
  @JsonKey(name: 'min_selections')
  int get minSelections;
  @override
  @JsonKey(name: 'max_selections')
  int? get maxSelections;
  @override
  @JsonKey(name: 'is_required')
  bool get isRequired;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(fromJson: _modifierListFromJson)
  List<ModifierModel> get modifiers;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of ModifierGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModifierGroupModelImplCopyWith<_$ModifierGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
