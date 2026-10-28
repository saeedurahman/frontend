import 'package:dio/dio.dart';

/// Default timeout for ordinary API calls.
const Duration kDefaultApiTimeout = Duration(seconds: 15);

/// Timeout for slow endpoints (reports, exports, uploads).
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
