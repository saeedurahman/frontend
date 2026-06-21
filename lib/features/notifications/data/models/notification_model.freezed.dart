// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String? get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_type')
  String get notificationType => throw _privateConstructorUsedError;
  String get channel => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'payload_json')
  Map<String, dynamic> get payloadJson => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'notification_type') String notificationType,
    String channel,
    String title,
    String? body,
    @JsonKey(name: 'payload_json') Map<String, dynamic> payloadJson,
    @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = freezed,
    Object? userId = freezed,
    Object? notificationType = null,
    Object? channel = null,
    Object? title = null,
    Object? body = freezed,
    Object? payloadJson = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? createdAt = null,
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
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            notificationType: null == notificationType
                ? _value.notificationType
                : notificationType // ignore: cast_nullable_to_non_nullable
                      as String,
            channel: null == channel
                ? _value.channel
                : channel // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String?,
            payloadJson: null == payloadJson
                ? _value.payloadJson
                : payloadJson // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            readAt: freezed == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'notification_type') String notificationType,
    String channel,
    String title,
    String? body,
    @JsonKey(name: 'payload_json') Map<String, dynamic> payloadJson,
    @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = freezed,
    Object? userId = freezed,
    Object? notificationType = null,
    Object? channel = null,
    Object? title = null,
    Object? body = freezed,
    Object? payloadJson = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$NotificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        notificationType: null == notificationType
            ? _value.notificationType
            : notificationType // ignore: cast_nullable_to_non_nullable
                  as String,
        channel: null == channel
            ? _value.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: freezed == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String?,
        payloadJson: null == payloadJson
            ? _value._payloadJson
            : payloadJson // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        readAt: freezed == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') this.branchId,
    @JsonKey(name: 'user_id') this.userId,
    @JsonKey(name: 'notification_type') required this.notificationType,
    required this.channel,
    required this.title,
    this.body,
    @JsonKey(name: 'payload_json')
    final Map<String, dynamic> payloadJson = const {},
    @JsonKey(name: 'is_read') this.isRead = false,
    @JsonKey(name: 'read_at') this.readAt,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _payloadJson = payloadJson,
       super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'notification_type')
  final String notificationType;
  @override
  final String channel;
  @override
  final String title;
  @override
  final String? body;
  final Map<String, dynamic> _payloadJson;
  @override
  @JsonKey(name: 'payload_json')
  Map<String, dynamic> get payloadJson {
    if (_payloadJson is EqualUnmodifiableMapView) return _payloadJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payloadJson);
  }

  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, businessId: $businessId, branchId: $branchId, userId: $userId, notificationType: $notificationType, channel: $channel, title: $title, body: $body, payloadJson: $payloadJson, isRead: $isRead, readAt: $readAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(
              other._payloadJson,
              _payloadJson,
            ) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    userId,
    notificationType,
    channel,
    title,
    body,
    const DeepCollectionEquality().hash(_payloadJson),
    isRead,
    readAt,
    createdAt,
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') final String? branchId,
    @JsonKey(name: 'user_id') final String? userId,
    @JsonKey(name: 'notification_type') required final String notificationType,
    required final String channel,
    required final String title,
    final String? body,
    @JsonKey(name: 'payload_json') final Map<String, dynamic> payloadJson,
    @JsonKey(name: 'is_read') final bool isRead,
    @JsonKey(name: 'read_at') final DateTime? readAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String? get branchId;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'notification_type')
  String get notificationType;
  @override
  String get channel;
  @override
  String get title;
  @override
  String? get body;
  @override
  @JsonKey(name: 'payload_json')
  Map<String, dynamic> get payloadJson;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
