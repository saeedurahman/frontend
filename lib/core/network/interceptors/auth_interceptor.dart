import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/utils/logger.dart';

typedef OnSessionExpired = Future<void> Function();

/// Result of one refresh attempt.
enum RefreshOutcome {
  /// New tokens were stored.
  refreshed,

  /// The server refused the refresh token (401/400) or none is stored.
  rejected,

  /// Network/timeout/5xx: tokens are kept, the user stays signed in.
  unavailable,
}

/// Attaches credentials and transparently refreshes an expired access token.
///
/// - Concurrent 401s share ONE in-flight refresh ([_refreshInFlight]); every
///   waiter completes on success and on failure, so no request can hang.
/// - A request retried after a refresh carries `extra['retried'] = true` and
///   never re-enters the refresh flow.
/// - Login/PIN-login/register/refresh responses never trigger a refresh
///   (a wrong password must surface as "Invalid credentials").
/// - The session is cleared ONLY when the refresh endpoint rejects the refresh
///   token. 403 is a permission error and never touches the session.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._secureStorage, {
    this.onSessionExpired,
    Dio? dio,
  }) : _dio = dio;

  final SecureStorage _secureStorage;
  final Dio? _dio;

  /// Called when the refresh token was rejected. The callback owns clearing
  /// the stored tokens and notifying the UI.
  final OnSessionExpired? onSessionExpired;

  Future<RefreshOutcome>? _refreshInFlight;

  static const retriedKey = 'retried';

  static const _authExchangePaths = <String>[
    ApiConstants.login,
    ApiConstants.pinLogin,
    ApiConstants.register,
    ApiConstants.refreshToken,
  ];

  /// True for the credential-exchange endpoints (login, PIN login, register,
  /// refresh).
  static bool isAuthExchangePath(String path) {
    final clean = Uri.tryParse(path)?.path ?? path;
    return _authExchangePaths.any((p) => clean == p || clean.endsWith(p));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!isAuthExchangePath(options.path)) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix}$token';
      }
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
    final dio = _dio;
    final request = err.requestOptions;

    final shouldRefresh = err.response?.statusCode == 401 &&
        dio != null &&
        !isAuthExchangePath(request.path) &&
        request.extra[retriedKey] != true;
    if (!shouldRefresh) {
      // 403 and everything else: pass through untouched.
      return handler.next(err);
    }

    // Another request may already have refreshed while this one was in flight:
    // retry with the newer token instead of refreshing again.
    final current = await _secureStorage.getAccessToken();
    final sent = request.headers[ApiConstants.authorizationHeader];
    final alreadyRefreshed = current != null &&
        current.isNotEmpty &&
        sent != '${ApiConstants.bearerPrefix}$current';

    final outcome =
        alreadyRefreshed ? RefreshOutcome.refreshed : await _refreshOnce();

    switch (outcome) {
      case RefreshOutcome.refreshed:
        try {
          final token = await _secureStorage.getAccessToken();
          request.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerPrefix}$token';
          request.extra[retriedKey] = true;
          handler.resolve(await dio.fetch<dynamic>(request));
        } on DioException catch (e) {
          handler.next(e);
        }
      case RefreshOutcome.rejected:
        // The shared refresh already expired the session (once).
        handler.next(err);
      case RefreshOutcome.unavailable:
        // Keep the tokens; report a connectivity problem, not a logout.
        handler.next(
          DioException(
            requestOptions: request,
            type: DioExceptionType.connectionError,
            error: err.error,
            message: 'Could not refresh the session. Check your connection.',
          ),
        );
    }
  }

  Future<void> _expireSession() async {
    try {
      await onSessionExpired?.call();
    } catch (e) {
      AppLogger.error('Session expiry handler failed', error: e);
    }
  }

  Future<RefreshOutcome> _refreshOnce() {
    final running = _refreshInFlight;
    if (running != null) return running;
    final future = _refreshToken().then((outcome) async {
      // Runs once per refresh, however many requests were waiting on it.
      if (outcome == RefreshOutcome.rejected) await _expireSession();
      return outcome;
    }).whenComplete(() => _refreshInFlight = null);
    _refreshInFlight = future;
    return future;
  }

  Future<RefreshOutcome> _refreshToken() async {
    final dio = _dio;
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty || dio == null) {
      return RefreshOutcome.rejected;
    }

    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'skip_offline_queue': true}),
      );

      final data = response.data;
      final accessToken = data?['access_token'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        return RefreshOutcome.rejected;
      }
      final newRefresh = data?['refresh_token'] as String? ?? refreshToken;

      await _secureStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefresh,
      );
      return RefreshOutcome.refreshed;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 400) return RefreshOutcome.rejected;
      AppLogger.warning('Token refresh unavailable (status $status)');
      return RefreshOutcome.unavailable;
    } catch (e) {
      AppLogger.warning('Token refresh failed unexpectedly: ${e.runtimeType}');
      return RefreshOutcome.unavailable;
    }
  }
}
