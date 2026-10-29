import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorage {
  SecureStorage([SecureKeyStore? store])
      : _storage = store ?? const FlutterSecureKeyStore();

  final SecureKeyStore _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tenantIdKey = 'tenant_id';
  static const String _userIdKey = 'user_id';
  static const String _pinDeviceCacheKey = 'pin_device_cache';

  Future<String?> getAccessToken() => _storage.read(_accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(_refreshTokenKey);

  Future<String?> getTenantId() => _storage.read(_tenantIdKey);

  Future<String?> getUserId() => _storage.read(_userIdKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(_accessTokenKey, accessToken);
    await _storage.write(_refreshTokenKey, refreshToken);
  }

  Future<void> saveTenantId(String tenantId) =>
      _storage.write(_tenantIdKey, tenantId);

  Future<void> saveUserId(String userId) =>
      _storage.write(_userIdKey, userId);

  Future<void> clearAll() => _storage.deleteAll();

  Future<void> clearPinDeviceCache() => _storage.delete(_pinDeviceCacheKey);

  /// Clears auth session keys only; preserves PIN device cache.
  Future<void> clearAuthSession() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
    await _storage.delete(_tenantIdKey);
    await _storage.delete(_userIdKey);
  }

  Future<String?> getPinDeviceCache() => _storage.read(_pinDeviceCacheKey);

  Future<void> savePinDeviceCache(String json) =>
      _storage.write(_pinDeviceCacheKey, json);

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
