// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_products_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedProductsModel _$PaginatedProductsModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedProductsModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedProductsModel {
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<ProductListItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this PaginatedProductsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedProductsModelCopyWith<PaginatedProductsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedProductsModelCopyWith<$Res> {
  factory $PaginatedProductsModelCopyWith(
    PaginatedProductsModel value,
    $Res Function(PaginatedProductsModel) then,
  ) = _$PaginatedProductsModelCopyWithImpl<$Res, PaginatedProductsModel>;
  @useResult
  $Res call({int total, int skip, int limit, List<ProductListItemModel> items});
}

/// @nodoc
class _$PaginatedProductsModelCopyWithImpl<
  $Res,
  $Val extends PaginatedProductsModel
>
    implements $PaginatedProductsModelCopyWith<$Res> {
  _$PaginatedProductsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            skip: null == skip
                ? _value.skip
                : skip // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ProductListItemModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedProductsModelImplCopyWith<$Res>
    implements $PaginatedProductsModelCopyWith<$Res> {
  factory _$$PaginatedProductsModelImplCopyWith(
    _$PaginatedProductsModelImpl value,
    $Res Function(_$PaginatedProductsModelImpl) then,
  ) = __$$PaginatedProductsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int skip, int limit, List<ProductListItemModel> items});
}

/// @nodoc
class __$$PaginatedProductsModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedProductsModelCopyWithImpl<$Res, _$PaginatedProductsModelImpl>
    implements _$$PaginatedProductsModelImplCopyWith<$Res> {
  __$$PaginatedProductsModelImplCopyWithImpl(
    _$PaginatedProductsModelImpl _value,
    $Res Function(_$PaginatedProductsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? items = null,
  }) {
    return _then(
      _$PaginatedProductsModelImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ProductListItemModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedProductsModelImpl implements _PaginatedProductsModel {
  const _$PaginatedProductsModelImpl({
    required this.total,
    required this.skip,
    required this.limit,
    final List<ProductListItemModel> items = const [],
  }) : _items = items;

  factory _$PaginatedProductsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedProductsModelImplFromJson(json);

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  final List<ProductListItemModel> _items;
  @override
  @JsonKey()
  List<ProductListItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginatedProductsModel(total: $total, skip: $skip, limit: $limit, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedProductsModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    skip,
    limit,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of PaginatedProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedProductsModelImplCopyWith<_$PaginatedProductsModelImpl>
  get copyWith =>
      __$$PaginatedProductsModelImplCopyWithImpl<_$PaginatedProductsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedProductsModelImplToJson(this);
  }
}

abstract class _PaginatedProductsModel implements PaginatedProductsModel {
  const factory _PaginatedProductsModel({
    required final int total,
    required final int skip,
    required final int limit,
    final List<ProductListItemModel> items,
  }) = _$PaginatedProductsModelImpl;

  factory _PaginatedProductsModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedProductsModelImpl.fromJson;

  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;
  @override
  List<ProductListItemModel> get items;

  /// Create a copy of PaginatedProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedProductsModelImplCopyWith<_$PaginatedProductsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
