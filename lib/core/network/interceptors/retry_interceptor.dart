import 'package:dio/dio.dart';
import 'package:frantend/core/utils/uuid_utils.dart';

/// Retries transient failures and stamps POSTs with an idempotency key.
///
/// - GET/HEAD/PUT/DELETE are retried on timeouts and connection errors.
/// - POST gets an `Idempotency-Key` (one UUID per logical request; the same
///   [RequestOptions], and therefore the same key, is reused by every retry,
///   including the one after a token refresh).
/// - POST/PATCH are only auto-retried when the request provably never reached
///   the server (connection timeout) AND carries a key. So /sales, /payments
///   and /expenses are never auto-retried without a key, and never after a
///   send/receive timeout (the server may have committed).
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 1),
  }) : _dio = dio;

  static const idempotencyHeader = 'Idempotency-Key';
  static const _idempotentMethods = {'GET', 'HEAD', 'PUT', 'DELETE'};

  final Dio _dio;
  final int retries;
  final Duration retryDelay;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'POST' && !_hasKey(options.headers)) {
      options.headers[idempotencyHeader] = UuidUtils.v4();
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final attempt = (extra['retry_attempt'] as int?) ?? 0;

    if (!shouldRetry(err) || attempt >= retries) {
      return handler.next(err);
    }

    await Future<void>.delayed(retryDelay * (attempt + 1));

    try {
      final response = await _dio.fetch<dynamic>(
        err.requestOptions.copyWith(
          extra: {...extra, 'retry_attempt': attempt + 1},
        ),
      );
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool shouldRetry(DioException err) {
    final options = err.requestOptions;
    if (options.extra['no_retry'] == true) return false;

    final transient = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
    if (!transient) return false;

    if (_idempotentMethods.contains(options.method.toUpperCase())) return true;

    // Non-idempotent: only when the connection was never established, and
    // only with a key the backend can dedupe on.
    return _hasKey(options.headers) &&
        err.type == DioExceptionType.connectionTimeout;
  }

  static bool _hasKey(Map<String, dynamic> headers) => headers.keys.any(
        (k) => k.toLowerCase() == idempotencyHeader.toLowerCase(),
      );
}
