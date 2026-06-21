import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/notifications/data/models/notification_model.dart';

part 'paginated_notifications_model.freezed.dart';
part 'paginated_notifications_model.g.dart';

@freezed
class PaginatedNotificationsModel with _$PaginatedNotificationsModel {
  const factory PaginatedNotificationsModel({
    required int total,
    @JsonKey(name: 'unread_count') required int unreadCount,
    required int skip,
    required int limit,
    @Default([]) List<NotificationModel> items,
  }) = _PaginatedNotificationsModel;

  factory PaginatedNotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedNotificationsModelFromJson(json);
}
