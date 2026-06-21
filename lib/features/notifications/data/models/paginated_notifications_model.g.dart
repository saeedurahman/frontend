// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedNotificationsModelImpl _$$PaginatedNotificationsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedNotificationsModelImpl(
  total: (json['total'] as num).toInt(),
  unreadCount: (json['unread_count'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PaginatedNotificationsModelImplToJson(
  _$PaginatedNotificationsModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'unread_count': instance.unreadCount,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};
