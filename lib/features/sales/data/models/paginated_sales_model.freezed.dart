// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_sales_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedSalesModel _$PaginatedSalesModelFromJson(Map<String, dynamic> json) {
  return _PaginatedSalesModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedSalesModel {
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<SaleListItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this PaginatedSalesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedSalesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedSalesModelCopyWith<PaginatedSalesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedSalesModelCopyWith<$Res> {
  factory $PaginatedSalesModelCopyWith(
    PaginatedSalesModel value,
    $Res Function(PaginatedSalesModel) then,
  ) = _$PaginatedSalesModelCopyWithImpl<$Res, PaginatedSalesModel>;
  @useResult
  $Res call({int total, int skip, int limit, List<SaleListItemModel> items});
}

/// @nodoc
class _$PaginatedSalesModelCopyWithImpl<$Res, $Val extends PaginatedSalesModel>
    implements $PaginatedSalesModelCopyWith<$Res> {
  _$PaginatedSalesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedSalesModel
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
                      as List<SaleListItemModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedSalesModelImplCopyWith<$Res>
    implements $PaginatedSalesModelCopyWith<$Res> {
  factory _$$PaginatedSalesModelImplCopyWith(
    _$PaginatedSalesModelImpl value,
    $Res Function(_$PaginatedSalesModelImpl) then,
  ) = __$$PaginatedSalesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int skip, int limit, List<SaleListItemModel> items});
}

/// @nodoc
class __$$PaginatedSalesModelImplCopyWithImpl<$Res>
    extends _$PaginatedSalesModelCopyWithImpl<$Res, _$PaginatedSalesModelImpl>
    implements _$$PaginatedSalesModelImplCopyWith<$Res> {
  __$$PaginatedSalesModelImplCopyWithImpl(
    _$PaginatedSalesModelImpl _value,
    $Res Function(_$PaginatedSalesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedSalesModel
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
      _$PaginatedSalesModelImpl(
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
                  as List<SaleListItemModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedSalesModelImpl implements _PaginatedSalesModel {
  const _$PaginatedSalesModelImpl({
    required this.total,
    required this.skip,
    required this.limit,
    final List<SaleListItemModel> items = const [],
  }) : _items = items;

  factory _$PaginatedSalesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedSalesModelImplFromJson(json);

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  final List<SaleListItemModel> _items;
  @override
  @JsonKey()
  List<SaleListItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginatedSalesModel(total: $total, skip: $skip, limit: $limit, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedSalesModelImpl &&
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

  /// Create a copy of PaginatedSalesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedSalesModelImplCopyWith<_$PaginatedSalesModelImpl> get copyWith =>
      __$$PaginatedSalesModelImplCopyWithImpl<_$PaginatedSalesModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedSalesModelImplToJson(this);
  }
}

abstract class _PaginatedSalesModel implements PaginatedSalesModel {
  const factory _PaginatedSalesModel({
    required final int total,
    required final int skip,
    required final int limit,
    final List<SaleListItemModel> items,
  }) = _$PaginatedSalesModelImpl;

  factory _PaginatedSalesModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedSalesModelImpl.fromJson;

  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;
  @override
  List<SaleListItemModel> get items;

  /// Create a copy of PaginatedSalesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedSalesModelImplCopyWith<_$PaginatedSalesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
