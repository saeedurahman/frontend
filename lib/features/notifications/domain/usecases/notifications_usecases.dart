import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/notifications/data/models/paginated_notifications_model.dart';
import 'package:frantend/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, PaginatedNotificationsModel>> call({
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getNotifications(
        isRead: isRead,
        notificationType: notificationType,
        skip: skip,
        limit: limit,
      );
}

@injectable
class MarkNotificationsReadUseCase {
  const MarkNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, int>> call(List<String> notificationIds) =>
      _repository.markRead(notificationIds);
}

@injectable
class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, int>> call() => _repository.markAllRead();
}

@injectable
class DeleteNotificationUseCase {
  const DeleteNotificationUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteNotification(id);
}

@injectable
class CheckNotificationAlertsUseCase {
  const CheckNotificationAlertsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, ({int lowStock, int expiry})>> call() =>
      _repository.checkAlerts();
}
