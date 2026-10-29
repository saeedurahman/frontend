import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:frantend/core/storage/secure_storage.dart';

/// In-memory [SecureStorage] (no platform channel).
class FakeSecureStorage implements SecureStorage {
  @override
  Future<void> clearPinDeviceCache() async => _pinCache = null;

  FakeSecureStorage({String? access, String? refresh, String? tenant})
      : _access = access,
        _refresh = refresh,
        _tenant = tenant;

  String? _access;
  String? _refresh;
  String? _tenant;
  String? _userId;
  String? _pinCache;

  @override
  Future<String?> getAccessToken() async => _access;

  @override
  Future<String?> getRefreshToken() async => _refresh;

  @override
  Future<String?> getTenantId() async => _tenant;

  @override
  Future<String?> getUserId() async => _userId;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _access = accessToken;
    _refresh = refreshToken;
  }

  @override
  Future<void> saveTenantId(String tenantId) async => _tenant = tenantId;

  @override
  Future<void> saveUserId(String userId) async => _userId = userId;

  @override
  Future<void> clearAll() async {
    await clearAuthSession();
    _pinCache = null;
  }

  @override
  Future<void> clearAuthSession() async {
    _access = null;
    _refresh = null;
    _tenant = null;
    _userId = null;
  }

  @override
  Future<String?> getPinDeviceCache() async => _pinCache;

  @override
  Future<void> savePinDeviceCache(String json) async => _pinCache = json;

  @override
  Future<bool> hasValidSession() async =>
      _access != null && _access!.isNotEmpty;
}

typedef FakeHandler = FutureOr<ResponseBody> Function(RequestOptions options);

/// A Dio adapter driven by a closure, recording every request it sees.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final FakeHandler handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(
  Object? body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
      ...headers,
    },
  );
}
