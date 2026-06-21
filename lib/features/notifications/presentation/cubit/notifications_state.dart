import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/notifications/data/models/notification_model.dart';

part 'notifications_state.freezed.dart';

enum NotificationFilter { all, unread }

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = NotificationsInitial;

  const factory NotificationsState.loading() = NotificationsLoading;

  const factory NotificationsState.loaded({
    required List<NotificationModel> notifications,
    required int total,
    required int skip,
    required int limit,
    required int unreadCount,
    @Default(NotificationFilter.all) NotificationFilter filter,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isCheckingAlerts,
    String? errorMessage,
  }) = NotificationsLoaded;

  const factory NotificationsState.error(String message) = NotificationsError;
}
