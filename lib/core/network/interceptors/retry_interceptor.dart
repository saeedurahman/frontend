import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 1),
  }) : _dio = dio;

  final Dio _dio;
  final int retries;
  final Duration retryDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final attempt = (extra['retry_attempt'] as int?) ?? 0;

    final shouldRetry = _shouldRetry(err) && attempt < retries;

    if (!shouldRetry) {
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

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }
    final statusCode = err.response?.statusCode;
    return statusCode != null && statusCode >= 500;
  }
}
