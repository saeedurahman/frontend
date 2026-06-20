// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseCategoryModel _$ExpenseCategoryModelFromJson(Map<String, dynamic> json) {
  return _ExpenseCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  List<ExpenseCategoryModel> get children => throw _privateConstructorUsedError;

  /// Serializes this ExpenseCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCategoryModelCopyWith<ExpenseCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryModelCopyWith<$Res> {
  factory $ExpenseCategoryModelCopyWith(
    ExpenseCategoryModel value,
    $Res Function(ExpenseCategoryModel) then,
  ) = _$ExpenseCategoryModelCopyWithImpl<$Res, ExpenseCategoryModel>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'is_active') bool isActive,
    List<ExpenseCategoryModel> children,
  });
}

/// @nodoc
class _$ExpenseCategoryModelCopyWithImpl<
  $Res,
  $Val extends ExpenseCategoryModel
>
    implements $ExpenseCategoryModelCopyWith<$Res> {
  _$ExpenseCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? isActive = null,
    Object? children = null,
  }) {
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
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<ExpenseCategoryModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseCategoryModelImplCopyWith<$Res>
    implements $ExpenseCategoryModelCopyWith<$Res> {
  factory _$$ExpenseCategoryModelImplCopyWith(
    _$ExpenseCategoryModelImpl value,
    $Res Function(_$ExpenseCategoryModelImpl) then,
  ) = __$$ExpenseCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'is_active') bool isActive,
    List<ExpenseCategoryModel> children,
  });
}

/// @nodoc
class __$$ExpenseCategoryModelImplCopyWithImpl<$Res>
    extends _$ExpenseCategoryModelCopyWithImpl<$Res, _$ExpenseCategoryModelImpl>
    implements _$$ExpenseCategoryModelImplCopyWith<$Res> {
  __$$ExpenseCategoryModelImplCopyWithImpl(
    _$ExpenseCategoryModelImpl _value,
    $Res Function(_$ExpenseCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? isActive = null,
    Object? children = null,
  }) {
    return _then(
      _$ExpenseCategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<ExpenseCategoryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseCategoryModelImpl implements _ExpenseCategoryModel {
  const _$ExpenseCategoryModelImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'parent_id') this.parentId,
    @JsonKey(name: 'is_active') this.isActive = true,
    final List<ExpenseCategoryModel> children = const [],
  }) : _children = children;

  factory _$ExpenseCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<ExpenseCategoryModel> _children;
  @override
  @JsonKey()
  List<ExpenseCategoryModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'ExpenseCategoryModel(id: $id, name: $name, parentId: $parentId, isActive: $isActive, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    parentId,
    isActive,
    const DeepCollectionEquality().hash(_children),
  );

  /// Create a copy of ExpenseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseCategoryModelImplCopyWith<_$ExpenseCategoryModelImpl>
  get copyWith =>
      __$$ExpenseCategoryModelImplCopyWithImpl<_$ExpenseCategoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseCategoryModelImplToJson(this);
  }
}

abstract class _ExpenseCategoryModel implements ExpenseCategoryModel {
  const factory _ExpenseCategoryModel({
    required final String id,
    required final String name,
    @JsonKey(name: 'parent_id') final String? parentId,
    @JsonKey(name: 'is_active') final bool isActive,
    final List<ExpenseCategoryModel> children,
  }) = _$ExpenseCategoryModelImpl;

  factory _ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  List<ExpenseCategoryModel> get children;

  /// Create a copy of ExpenseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseCategoryModelImplCopyWith<_$ExpenseCategoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
