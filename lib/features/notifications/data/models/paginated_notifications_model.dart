import 'package:frantend/core/utils/json_num.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/notifications/data/models/notification_model.dart';

part 'paginated_notifications_model.freezed.dart';
part 'paginated_notifications_model.g.dart';

@freezed
abstract class PaginatedNotificationsModel with _$PaginatedNotificationsModel {
  const factory PaginatedNotificationsModel({
    @JsonKey(fromJson: JsonNum.intOr) required int total,
    @JsonKey(name: 'unread_count', fromJson: JsonNum.intOr) required int unreadCount,
    @JsonKey(fromJson: JsonNum.intOr) required int skip,
    @JsonKey(fromJson: JsonNum.intOr) required int limit,
    @Default([]) List<NotificationModel> items,
  }) = _PaginatedNotificationsModel;

  factory PaginatedNotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedNotificationsModelFromJson(json);
}
