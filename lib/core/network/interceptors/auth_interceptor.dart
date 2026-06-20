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
  final List<_QueuedRequest> _retryQueue = [];

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
        _retryQueue.add(_QueuedRequest(err, handler));
        return;
      }

      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          final token = await _secureStorage.getAccessToken();
          
          // Retry the original request
          err.requestOptions.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerPrefix}$token';
          final response = await _dio.fetch<dynamic>(err.requestOptions);
          handler.resolve(response);

          // Retry all queued requests
          for (final queued in _retryQueue) {
            try {
              queued.err.requestOptions.headers[ApiConstants.authorizationHeader] =
                  '${ApiConstants.bearerPrefix}$token';
              final queuedResponse = await _dio.fetch<dynamic>(queued.err.requestOptions);
              queued.handler.resolve(queuedResponse);
            } catch (e) {
              queued.handler.reject(DioException(
                requestOptions: queued.err.requestOptions,
                error: e,
              ));
            }
          }
          _retryQueue.clear();
          return;
        }
      } catch (e) {
        AppLogger.error('Token refresh failed', error: e);
      } finally {
        _isRefreshing = false;
      }

      // If refresh failed, reject all queued requests and the original request
      for (final queued in _retryQueue) {
        queued.handler.next(queued.err);
      }
      _retryQueue.clear();

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

class _QueuedRequest {
  _QueuedRequest(this.err, this.handler);
  final DioException err;
  final ErrorInterceptorHandler handler;
}
