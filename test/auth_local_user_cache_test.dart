import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';

/// Minimal secure-storage fake for auth cache tests.
class _FakeSecureStorage extends SecureStorage {
  _FakeSecureStorage() : super();

  final Map<String, String> _store = {};

  @override
  Future<String?> getUserId() async => _store['user_id'];

  @override
  Future<void> saveUserId(String userId) async {
    _store['user_id'] = userId;
  }

  @override
  Future<String?> getAccessToken() async => _store['access_token'];

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _store['access_token'] = accessToken;
    _store['refresh_token'] = refreshToken;
  }

  @override
  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearAuthSession() async {
    _store.remove('access_token');
    _store.remove('refresh_token');
    _store.remove('tenant_id');
    _store.remove('user_id');
  }
}

void main() {
  group('AuthLocalDataSource RBAC cache', () {
    late AppDatabase database;
    late _FakeSecureStorage secureStorage;
    late AuthLocalDataSourceImpl dataSource;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      secureStorage = _FakeSecureStorage();
      dataSource = AuthLocalDataSourceImpl(secureStorage, database);
      await secureStorage.saveTokens(
        accessToken: 'token',
        refreshToken: 'refresh',
      );
      await secureStorage.saveUserId('mgr-1');
    });

    tearDown(() async {
      await database.close();
    });

    test('cacheUser persists and getCachedUser returns permission_keys', () async {
      const user = UserModel(
        id: 'mgr-1',
        name: 'Manager Ali',
        email: 'ali@shop.test',
        role: 'manager',
        businessSlug: 'my-shop',
        roles: ['manager'],
        permissionKeys: ['users.roles.manage', 'users.view'],
      );

      await dataSource.cacheUser(user);
      final cached = await dataSource.getCachedUser();

      expect(cached, isNotNull);
      expect(cached!.permissionKeys, user.permissionKeys);
      expect(cached.businessSlug, 'my-shop');
      expect(cached.roles, ['manager']);
      expect(cached.role, 'manager');
    });

    test('manager with users.roles.manage passes gate without owner fallback', () async {
      await dataSource.cacheUser(
        const UserModel(
          id: 'mgr-1',
          name: 'Manager',
          email: 'm@test.com',
          role: 'manager',
          permissionKeys: ['users.roles.manage'],
        ),
      );

      final cached = (await dataSource.getCachedUser())!;
      final allowed = UserRoleUtils.canManageRoles(
        role: cached.role,
        permissionKeys: cached.permissionKeys,
      );

      expect(allowed, isTrue);
      expect(UserRoleUtils.isOwner(cached.role), isFalse);
    });

    test('manager without users.roles.manage is denied', () async {
      await dataSource.cacheUser(
        const UserModel(
          id: 'mgr-1',
          name: 'Manager',
          email: 'm@test.com',
          role: 'manager',
          permissionKeys: ['users.view'],
        ),
      );

      final cached = (await dataSource.getCachedUser())!;
      expect(
        UserRoleUtils.canManageRoles(
          role: cached.role,
          permissionKeys: cached.permissionKeys,
        ),
        isFalse,
      );
    });

    test('offline read returns last cached permission_keys', () async {
      const keys = ['sales.returns.view', 'sales.cancel'];
      await dataSource.cacheUser(
        const UserModel(
          id: 'mgr-1',
          name: 'Cashier',
          email: 'c@test.com',
          role: 'cashier',
          permissionKeys: keys,
        ),
      );

      final offline = await dataSource.getCachedUser();
      expect(offline?.permissionKeys, keys);
      expect(offline?.permissionKeys, isNotEmpty);
    });

    test('row with NULL RBAC columns (post-migration, not yet re-cached) uses owner fallback',
        () async {
      final migratedDb = AppDatabase.forTesting(NativeDatabase.memory());
      await migratedDb.into(migratedDb.usersTable).insert(
            UsersTableCompanion.insert(
              id: 'owner-1',
              email: 'o@test.com',
              name: 'Owner',
              role: 'owner',
              updatedAt: DateTime.now(),
            ),
          );

      final storage = _FakeSecureStorage();
      final migratedSource = AuthLocalDataSourceImpl(storage, migratedDb);
      await storage.saveUserId('owner-1');

      final row = await migratedSource.getCachedUser();
      expect(row, isNotNull);
      expect(row!.permissionKeys, isEmpty);
      expect(row.businessSlug, isNull);
      expect(
        UserRoleUtils.canManageRoles(
          role: row.role,
          permissionKeys: row.permissionKeys,
        ),
        isTrue,
      );

      await migratedDb.close();
    });
  });

  group('PIN device cache independence', () {
    test('PinDeviceCacheData is unaffected by user Drift cache shape', () {
      const pinCache = PinDeviceCacheData(
        businessSlug: 'shop-a',
        staff: [PinStaffEntry(id: 'u1', fullName: 'Ali')],
      );

      final restored = PinDeviceCacheData.fromJson(pinCache.toJson());
      expect(restored.businessSlug, 'shop-a');
      expect(restored.staff, hasLength(1));
      expect(restored.staff.first.id, 'u1');
    });
  });
}
