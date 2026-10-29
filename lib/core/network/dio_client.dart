import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/session/session_signals.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';
import 'package:frantend/core/network/interceptors/forbidden_interceptor.dart';
import 'package:frantend/core/network/interceptors/logging_interceptor.dart';
import 'package:frantend/core/network/interceptors/retry_interceptor.dart';
import 'package:frantend/core/network/interceptors/subscription_interceptor.dart';
import 'package:frantend/core/network/interceptors/timeout_interceptor.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:injectable/injectable.dart';

/// The one authenticated HTTP client. Every request either reaches the
/// server or fails visibly: there is no interceptor that pretends a mutation
/// succeeded.
@lazySingleton
class DioClient {
  DioClient({
    required SecureStorage secureStorage,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: kDefaultApiTimeout,
        receiveTimeout: kDefaultApiTimeout,
        sendTimeout: kDefaultApiTimeout,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
      ),
    );

    final authInterceptor = AuthInterceptor(
      secureStorage,
      dio: _dio,
      onSessionExpired: () async {
        await secureStorage.clearAuthSession();
        // Flip the router guard so the UI redirects to login.
        final guard = sl<AuthGuard>();
        if (guard.isAuthenticated) guard.setAuthenticated(false);
      },
    );

    _dio.interceptors.addAll([
      TimeoutInterceptor(),
      authInterceptor,
      SubscriptionInterceptor(onFailure: SessionSignals.subscriptionFailure),
      ForbiddenInterceptor(onForbidden: SessionSignals.forbidden),
      // POS-critical paths are never auto-retried (see RetryInterceptor);
      // other idempotent reads get a single retry.
      RetryInterceptor(dio: _dio, retries: 1),
      LoggingInterceptor(),
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
