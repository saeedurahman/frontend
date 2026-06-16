import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/utils/logger.dart';

typedef OnUnauthorized = Future<void> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._secureStorage, {
    this.onUnauthorized,
    Dio? dio,
  }) : _dio = dio;

  final SecureStorage _secureStorage;
  final Dio? _dio;
  final OnUnauthorized? onUnauthorized;

  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix}$token';
    }

    final tenantId = await _secureStorage.getTenantId();
    if (tenantId != null && tenantId.isNotEmpty) {
      options.headers[ApiConstants.tenantHeader] = tenantId;
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && _dio != null) {
      if (_isRefreshing) {
        return handler.next(err);
      }

      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          final token = await _secureStorage.getAccessToken();
          err.requestOptions.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerPrefix}$token';
          final response = await _dio.fetch<dynamic>(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        AppLogger.error('Token refresh failed', error: e);
      } finally {
        _isRefreshing = false;
      }

      await onUnauthorized?.call();
      return handler.next(err);
    }

    if (err.response?.statusCode == 403) {
      await onUnauthorized?.call();
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty || _dio == null) {
      return false;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {ApiConstants.authorizationHeader: ''},
          extra: {'skip_offline_queue': true},
        ),
      );

      final data = response.data;
      if (data == null) return false;

      final accessToken = data['access_token'] as String?;
      final newRefreshToken = data['refresh_token'] as String? ?? refreshToken;

      if (accessToken == null) return false;

      await _secureStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
