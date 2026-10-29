import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frantend/core/network/interceptors/timeout_interceptor.dart';
import 'package:frantend/core/utils/uuid_utils.dart';

/// Hands out one `Idempotency-Key` per *logical* money action.
///
/// A user who taps "Pay" again after a failed attempt sends the same
/// method + path + body; that must reuse the key of the earlier attempt (the
/// server may already have committed it). A different body is a new action and
/// gets a new key. The key is forgotten once the action definitively finished.
class IdempotencyKeyRegistry {
  IdempotencyKeyRegistry({
    this.ttl = const Duration(minutes: 15),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration ttl;
  final DateTime Function() _clock;
  final Map<String, ({String key, DateTime issuedAt})> _issued = {};

  /// POSTs whose retry must not create a second record.
  static final _moneyPaths = <RegExp>[
    RegExp(r'^/sales$'),
    RegExp(r'^/sales/[^/]+/(payments|complete)$'),
    RegExp(r'^/returns$'),
    RegExp(r'^/expenses$'),
    RegExp(r'^/expenses/[^/]+/payments$'),
    RegExp(r'^/customers/[^/]+/payments$'),
  ];

  static bool tracksPath(String path) {
    final clean = Uri.tryParse(path)?.path ?? path;
    return _moneyPaths.any((r) => r.hasMatch(clean));
  }

  /// Stable fingerprint of a request, or null if it cannot be fingerprinted.
  static String? fingerprint(RequestOptions options) {
    try {
      final path = Uri.tryParse(options.path)?.path ?? options.path;
      return '${options.method.toUpperCase()} $path ${jsonEncode(options.data)}';
    } catch (_) {
      return null;
    }
  }

  String keyFor(String fingerprint) {
    final now = _clock();
    final existing = _issued[fingerprint];
    if (existing != null && now.difference(existing.issuedAt) < ttl) {
      return existing.key;
    }
    final key = UuidUtils.v4();
    _issued[fingerprint] = (key: key, issuedAt: now);
    _issued.removeWhere((_, v) => now.difference(v.issuedAt) >= ttl);
    return key;
  }

  void release(String fingerprint) => _issued.remove(fingerprint);

  int get pending => _issued.length;
}

/// Retries transient failures and stamps POSTs with an idempotency key.
///
/// - POS-critical paths ([TimeoutInterceptor.isPosCritical]) are never
///   auto-retried: no multi-attempt freeze at the counter.
/// - Other GET/HEAD/PUT/DELETE are retried on timeouts and connection errors.
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
    IdempotencyKeyRegistry? registry,
  })  : _dio = dio,
        registry = registry ?? IdempotencyKeyRegistry();

  final IdempotencyKeyRegistry registry;
  static const _fingerprintExtra = 'idempotency_fingerprint';

  static const idempotencyHeader = 'Idempotency-Key';
  static const _idempotentMethods = {'GET', 'HEAD', 'PUT', 'DELETE'};

  final Dio _dio;
  final int retries;
  final Duration retryDelay;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'POST' && !_hasKey(options.headers)) {
      final fp = IdempotencyKeyRegistry.tracksPath(options.path)
          ? IdempotencyKeyRegistry.fingerprint(options)
          : null;
      if (fp != null) {
        options.extra[_fingerprintExtra] = fp;
        options.headers[idempotencyHeader] = registry.keyFor(fp);
      } else {
        options.headers[idempotencyHeader] = UuidUtils.v4();
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _releaseKey(response.requestOptions);
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final attempt = (extra['retry_attempt'] as int?) ?? 0;

    if (!shouldRetry(err) || attempt >= retries) {
      // A definite client-side rejection means the action did not happen, so
      // the next tap is a new attempt. Timeouts/5xx stay ambiguous: keep the
      // key so a re-tap dedupes against a possible earlier commit.
      final status = err.response?.statusCode;
      if (status != null &&
          status >= 400 &&
          status < 500 &&
          status != 408 &&
          status != 409 &&
          status != 429) {
        _releaseKey(err.requestOptions);
      }
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

  void _releaseKey(RequestOptions options) {
    final fp = options.extra[_fingerprintExtra];
    if (fp is String) registry.release(fp);
  }

  bool shouldRetry(DioException err) {
    final options = err.requestOptions;
    if (options.extra['no_retry'] == true) return false;
    // POS-critical calls fail fast; the cashier decides whether to retry.
    if (TimeoutInterceptor.isPosCritical(options.path)) return false;

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
