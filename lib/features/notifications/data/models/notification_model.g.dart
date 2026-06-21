// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String?,
  userId: json['user_id'] as String?,
  notificationType: json['notification_type'] as String,
  channel: json['channel'] as String,
  title: json['title'] as String,
  body: json['body'] as String?,
  payloadJson: json['payload_json'] as Map<String, dynamic>? ?? const {},
  isRead: json['is_read'] as bool? ?? false,
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'user_id': instance.userId,
  'notification_type': instance.notificationType,
  'channel': instance.channel,
  'title': instance.title,
  'body': instance.body,
  'payload_json': instance.payloadJson,
  'is_read': instance.isRead,
  'read_at': instance.readAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};
