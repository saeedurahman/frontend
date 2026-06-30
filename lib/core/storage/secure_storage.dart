import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorage {
  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tenantIdKey = 'tenant_id';
  static const String _userIdKey = 'user_id';
  static const String _pinDeviceCacheKey = 'pin_device_cache';

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<String?> getTenantId() => _storage.read(key: _tenantIdKey);

  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> saveTenantId(String tenantId) =>
      _storage.write(key: _tenantIdKey, value: tenantId);

  Future<void> saveUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);

  Future<void> clearAll() => _storage.deleteAll();

  /// Clears auth session keys only; preserves PIN device cache.
  Future<void> clearAuthSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tenantIdKey);
    await _storage.delete(key: _userIdKey);
  }

  Future<String?> getPinDeviceCache() => _storage.read(key: _pinDeviceCacheKey);

  Future<void> savePinDeviceCache(String json) =>
      _storage.write(key: _pinDeviceCacheKey, value: json);

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
