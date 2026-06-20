// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_expenses_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedExpensesModel _$PaginatedExpensesModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedExpensesModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedExpensesModel {
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<ExpenseListItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this PaginatedExpensesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedExpensesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedExpensesModelCopyWith<PaginatedExpensesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedExpensesModelCopyWith<$Res> {
  factory $PaginatedExpensesModelCopyWith(
    PaginatedExpensesModel value,
    $Res Function(PaginatedExpensesModel) then,
  ) = _$PaginatedExpensesModelCopyWithImpl<$Res, PaginatedExpensesModel>;
  @useResult
  $Res call({int total, int skip, int limit, List<ExpenseListItemModel> items});
}

/// @nodoc
class _$PaginatedExpensesModelCopyWithImpl<
  $Res,
  $Val extends PaginatedExpensesModel
>
    implements $PaginatedExpensesModelCopyWith<$Res> {
  _$PaginatedExpensesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedExpensesModel
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
                      as List<ExpenseListItemModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedExpensesModelImplCopyWith<$Res>
    implements $PaginatedExpensesModelCopyWith<$Res> {
  factory _$$PaginatedExpensesModelImplCopyWith(
    _$PaginatedExpensesModelImpl value,
    $Res Function(_$PaginatedExpensesModelImpl) then,
  ) = __$$PaginatedExpensesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int skip, int limit, List<ExpenseListItemModel> items});
}

/// @nodoc
class __$$PaginatedExpensesModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedExpensesModelCopyWithImpl<$Res, _$PaginatedExpensesModelImpl>
    implements _$$PaginatedExpensesModelImplCopyWith<$Res> {
  __$$PaginatedExpensesModelImplCopyWithImpl(
    _$PaginatedExpensesModelImpl _value,
    $Res Function(_$PaginatedExpensesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedExpensesModel
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
      _$PaginatedExpensesModelImpl(
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
                  as List<ExpenseListItemModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedExpensesModelImpl implements _PaginatedExpensesModel {
  const _$PaginatedExpensesModelImpl({
    required this.total,
    required this.skip,
    required this.limit,
    final List<ExpenseListItemModel> items = const [],
  }) : _items = items;

  factory _$PaginatedExpensesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedExpensesModelImplFromJson(json);

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  final List<ExpenseListItemModel> _items;
  @override
  @JsonKey()
  List<ExpenseListItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginatedExpensesModel(total: $total, skip: $skip, limit: $limit, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedExpensesModelImpl &&
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

  /// Create a copy of PaginatedExpensesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedExpensesModelImplCopyWith<_$PaginatedExpensesModelImpl>
  get copyWith =>
      __$$PaginatedExpensesModelImplCopyWithImpl<_$PaginatedExpensesModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedExpensesModelImplToJson(this);
  }
}

abstract class _PaginatedExpensesModel implements PaginatedExpensesModel {
  const factory _PaginatedExpensesModel({
    required final int total,
    required final int skip,
    required final int limit,
    final List<ExpenseListItemModel> items,
  }) = _$PaginatedExpensesModelImpl;

  factory _PaginatedExpensesModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedExpensesModelImpl.fromJson;

  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;
  @override
  List<ExpenseListItemModel> get items;

  /// Create a copy of PaginatedExpensesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedExpensesModelImplCopyWith<_$PaginatedExpensesModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
