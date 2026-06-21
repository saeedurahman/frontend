import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'notification_type') required String notificationType,
    required String channel,
    required String title,
    String? body,
    @JsonKey(name: 'payload_json') @Default({}) Map<String, dynamic> payloadJson,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  String? get relatedProductId {
    final value = payloadJson['product_id'];
    if (value == null) return null;
    return value.toString();
  }

  String get message => body ?? '';
}
