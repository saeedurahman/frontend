import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/notifications/data/models/paginated_notifications_model.dart';
import 'package:frantend/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:frantend/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';

class _FakeAuthLocal extends Fake implements AuthLocalDataSource {
  _FakeAuthLocal(this.user);
  final UserModel? user;

  @override
  Future<UserModel?> getCachedUser() async => user;
}

class _FakeRepo extends Fake implements NotificationsRepository {
  int checkAlertsCalls = 0;

  @override
  Future<Either<Failure, PaginatedNotificationsModel>> getNotifications({
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  }) async =>
      const Right(
        PaginatedNotificationsModel(
            total: 0, unreadCount: 0, skip: 0, limit: 50),
      );

  @override
  Future<Either<Failure, ({int lowStock, int expiry})>> checkAlerts() async {
    checkAlertsCalls++;
    return const Right((lowStock: 0, expiry: 0));
  }
}

NotificationsCubit _cubit(_FakeRepo repo, UserModel? user) =>
    NotificationsCubit(
      getNotificationsUseCase: GetNotificationsUseCase(repo),
      markNotificationsReadUseCase: MarkNotificationsReadUseCase(repo),
      markAllNotificationsReadUseCase: MarkAllNotificationsReadUseCase(repo),
      deleteNotificationUseCase: DeleteNotificationUseCase(repo),
      checkNotificationAlertsUseCase: CheckNotificationAlertsUseCase(repo),
      authLocalDataSource: _FakeAuthLocal(user),
    );

void main() {
  test('cashier (no notifications.manage) never calls check-alerts', () async {
    final repo = _FakeRepo();
    final cubit = _cubit(
      repo,
      const UserModel(
        id: 'u',
        name: 'Cashier',
        role: 'cashier',
        permissionKeys: ['notifications.view', 'sales.create'],
      ),
    );

    await cubit.startSession();
    await cubit.triggerCheckAlerts();

    expect(repo.checkAlertsCalls, 0);
    await cubit.close();
  });

  test('user with notifications.manage checks alerts', () async {
    final repo = _FakeRepo();
    final cubit = _cubit(
      repo,
      const UserModel(
        id: 'u',
        name: 'Manager',
        role: 'manager',
        permissionKeys: ['notifications.view', 'notifications.manage'],
      ),
    );

    await cubit.startSession();

    expect(repo.checkAlertsCalls, 1);
    await cubit.close();
  });
}
