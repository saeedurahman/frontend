import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/utils/pin_device_cache_roster_policy.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class SeedPinDeviceCacheUseCase {
  SeedPinDeviceCacheUseCase(this._cache, this._getUsers);

  final PinDeviceCache _cache;
  final GetUsersUseCase _getUsers;

  Future<void> call(User user) async {
    final slug = user.businessSlug?.trim();
    if (slug == null || slug.isEmpty) return;

    final existing = await _cache.read();
    final now = DateTime.now().toUtc();

    if (UserRoleUtils.canViewUsers(
      role: user.role,
      permissionKeys: user.permissionKeys,
    )) {
      final result = await _getUsers();
      await result.fold(
        (_) async {
          await _cache.write(
            PinDeviceCacheData(
              businessSlug: slug,
              staff: existing?.staff ?? const [],
              lastFullRefreshAt: existing?.lastFullRefreshAt,
            ),
          );
        },
        (users) async {
          await _cache.write(
            PinDeviceCacheData(
              businessSlug: slug,
              staff: activeUsersToPinRoster(users),
              lastFullRefreshAt: now.toIso8601String(),
            ),
          );
        },
      );
      return;
    }

    await _cache.write(
      PinDeviceCacheData(
        businessSlug: slug,
        staff: mergeSelfPinRoster(
          existing: existing?.staff,
          userId: user.id,
          userName: user.name,
          now: now,
        ),
        lastFullRefreshAt: existing?.lastFullRefreshAt,
      ),
    );
  }
}
