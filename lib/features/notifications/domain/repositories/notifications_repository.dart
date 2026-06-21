import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/notifications/data/models/paginated_notifications_model.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, PaginatedNotificationsModel>> getNotifications({
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, int>> markRead(List<String> notificationIds);

  Future<Either<Failure, int>> markAllRead();

  Future<Either<Failure, void>> deleteNotification(String id);

  Future<Either<Failure, ({int lowStock, int expiry})>> checkAlerts();
}
