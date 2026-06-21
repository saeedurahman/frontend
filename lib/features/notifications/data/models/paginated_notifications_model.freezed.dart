// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_notifications_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedNotificationsModel _$PaginatedNotificationsModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedNotificationsModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedNotificationsModel {
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<NotificationModel> get items => throw _privateConstructorUsedError;

  /// Serializes this PaginatedNotificationsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedNotificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedNotificationsModelCopyWith<PaginatedNotificationsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedNotificationsModelCopyWith<$Res> {
  factory $PaginatedNotificationsModelCopyWith(
    PaginatedNotificationsModel value,
    $Res Function(PaginatedNotificationsModel) then,
  ) =
      _$PaginatedNotificationsModelCopyWithImpl<
        $Res,
        PaginatedNotificationsModel
      >;
  @useResult
  $Res call({
    int total,
    @JsonKey(name: 'unread_count') int unreadCount,
    int skip,
    int limit,
    List<NotificationModel> items,
  });
}

/// @nodoc
class _$PaginatedNotificationsModelCopyWithImpl<
  $Res,
  $Val extends PaginatedNotificationsModel
>
    implements $PaginatedNotificationsModelCopyWith<$Res> {
  _$PaginatedNotificationsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedNotificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? unreadCount = null,
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
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
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
                      as List<NotificationModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedNotificationsModelImplCopyWith<$Res>
    implements $PaginatedNotificationsModelCopyWith<$Res> {
  factory _$$PaginatedNotificationsModelImplCopyWith(
    _$PaginatedNotificationsModelImpl value,
    $Res Function(_$PaginatedNotificationsModelImpl) then,
  ) = __$$PaginatedNotificationsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int total,
    @JsonKey(name: 'unread_count') int unreadCount,
    int skip,
    int limit,
    List<NotificationModel> items,
  });
}

/// @nodoc
class __$$PaginatedNotificationsModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedNotificationsModelCopyWithImpl<
          $Res,
          _$PaginatedNotificationsModelImpl
        >
    implements _$$PaginatedNotificationsModelImplCopyWith<$Res> {
  __$$PaginatedNotificationsModelImplCopyWithImpl(
    _$PaginatedNotificationsModelImpl _value,
    $Res Function(_$PaginatedNotificationsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedNotificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? unreadCount = null,
    Object? skip = null,
    Object? limit = null,
    Object? items = null,
  }) {
    return _then(
      _$PaginatedNotificationsModelImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
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
                  as List<NotificationModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedNotificationsModelImpl
    implements _PaginatedNotificationsModel {
  const _$PaginatedNotificationsModelImpl({
    required this.total,
    @JsonKey(name: 'unread_count') required this.unreadCount,
    required this.skip,
    required this.limit,
    final List<NotificationModel> items = const [],
  }) : _items = items;

  factory _$PaginatedNotificationsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PaginatedNotificationsModelImplFromJson(json);

  @override
  final int total;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  final int skip;
  @override
  final int limit;
  final List<NotificationModel> _items;
  @override
  @JsonKey()
  List<NotificationModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginatedNotificationsModel(total: $total, unreadCount: $unreadCount, skip: $skip, limit: $limit, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedNotificationsModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    unreadCount,
    skip,
    limit,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of PaginatedNotificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedNotificationsModelImplCopyWith<_$PaginatedNotificationsModelImpl>
  get copyWith =>
      __$$PaginatedNotificationsModelImplCopyWithImpl<
        _$PaginatedNotificationsModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedNotificationsModelImplToJson(this);
  }
}

abstract class _PaginatedNotificationsModel
    implements PaginatedNotificationsModel {
  const factory _PaginatedNotificationsModel({
    required final int total,
    @JsonKey(name: 'unread_count') required final int unreadCount,
    required final int skip,
    required final int limit,
    final List<NotificationModel> items,
  }) = _$PaginatedNotificationsModelImpl;

  factory _PaginatedNotificationsModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedNotificationsModelImpl.fromJson;

  @override
  int get total;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  int get skip;
  @override
  int get limit;
  @override
  List<NotificationModel> get items;

  /// Create a copy of PaginatedNotificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedNotificationsModelImplCopyWith<_$PaginatedNotificationsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
