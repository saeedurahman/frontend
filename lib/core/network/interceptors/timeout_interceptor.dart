import 'package:dio/dio.dart';

/// Default timeout for ordinary API calls, POS-critical ones included: a
/// cashier waiting at the counter must learn about a dead link in seconds,
/// not minutes.
const Duration kDefaultApiTimeout = Duration(seconds: 5);

/// Timeout for slow endpoints (reports, exports, uploads) only.
const Duration kLongApiTimeout = Duration(seconds: 60);

/// Gives report/export/upload endpoints [kLongApiTimeout] while everything
/// else keeps the [kDefaultApiTimeout] from the Dio base options.
class TimeoutInterceptor extends Interceptor {
  static const _longRunningMarkers = <String>[
    '/analytics',
    '/reports',
    '/export',
    '/upload',
    '/dashboard',
  ];

  static bool isLongRunning(String path) {
    final clean = (Uri.tryParse(path)?.path ?? path).toLowerCase();
    return _longRunningMarkers.any(clean.contains);
  }

  /// Calls the cashier is waiting on at the counter. They fail fast and are
  /// never auto-retried (the UI offers a retry; money POSTs carry an
  /// idempotency key so a manual retry cannot double-post).
  static const _posCriticalPrefixes = <String>[
    '/sales',
    '/shifts',
    '/registers',
    '/returns',
    '/expenses',
    '/customers',
    '/stock',
    '/time',
    '/products/barcode',
    '/prices',
    '/discount',
  ];

  static bool isPosCritical(String path) {
    final clean = (Uri.tryParse(path)?.path ?? path).toLowerCase();
    return _posCriticalPrefixes.any(clean.startsWith);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (isLongRunning(options.path)) {
      options
        ..receiveTimeout = kLongApiTimeout
        ..sendTimeout = kLongApiTimeout
        ..connectTimeout = kDefaultApiTimeout;
    }
    handler.next(options);
  }
}
