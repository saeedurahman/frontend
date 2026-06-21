import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:frantend/features/notifications/data/models/paginated_notifications_model.dart';
import 'package:frantend/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({
    required NotificationsRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final NotificationsRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, PaginatedNotificationsModel>> getNotifications({
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      return Right(
        await _remote.getNotifications(
          isRead: isRead,
          notificationType: notificationType,
          skip: skip,
          limit: limit,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> markRead(List<String> notificationIds) async {
    try {
      return Right(await _remote.markRead(notificationIds));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> markAllRead() async {
    try {
      return Right(await _remote.markAllRead());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await _remote.deleteNotification(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ({int lowStock, int expiry})>> checkAlerts() async {
    try {
      return Right(await _remote.checkAlerts());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
