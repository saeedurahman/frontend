import 'package:dio/dio.dart';
import 'package:frantend/core/utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      'REQUEST [${options.method}] ${options.uri}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      'RESPONSE [${response.statusCode}] ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}: ${err.message}',
    );
    handler.next(err);
  }
}
