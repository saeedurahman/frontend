import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/utils/string_list_json_codec.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? tenantId,
    String? userId,
  });
  Future<void> clearSession();
  Future<bool> hasSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._secureStorage, this._database);

  final SecureStorage _secureStorage;
  final AppDatabase _database;

  /// Persists RBAC fields from [user] into Drift.
  ///
  /// Permission keys are refreshed on login, PIN login, register, online
  /// [AuthRepository.getCurrentUser], and app cold-start refresh — not live
  /// mid-session when an admin changes roles without one of those triggers.
  @override
  Future<void> cacheUser(UserModel user) async {
    await _database.into(_database.usersTable).insertOnConflictUpdate(
          UsersTableCompanion.insert(
            id: user.id,
            email: user.email ?? user.phone ?? '',
            name: user.name,
            role: user.role,
            businessId: Value(user.businessId),
            branchId: Value(user.branchId),
            businessSlug: Value(user.businessSlug),
            rolesJson: Value(encodeStringListJson(user.roles)),
            permissionKeysJson: Value(encodeStringListJson(user.permissionKeys)),
            updatedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return null;

    final row = await (_database.select(_database.usersTable)
          ..where((t) => t.id.equals(userId)))
        .getSingleOrNull();

    if (row == null) return null;

    return UserModel(
      id: row.id,
      email: row.email,
      name: row.name,
      role: row.role,
      businessId: row.businessId,
      branchId: row.branchId,
      businessSlug: row.businessSlug,
      roles: decodeStringListJson(row.rolesJson),
      permissionKeys: decodeStringListJson(row.permissionKeysJson),
    );
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? tenantId,
    String? userId,
  }) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    if (tenantId != null) await _secureStorage.saveTenantId(tenantId);
    if (userId != null) await _secureStorage.saveUserId(userId);
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.clearAuthSession();
  }

  @override
  Future<bool> hasSession() => _secureStorage.hasValidSession();
}
