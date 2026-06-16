import 'package:dio/dio.dart';
import 'package:frantend/core/error/exceptions.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ErrorHandler {
  const ErrorHandler();

  Failure mapExceptionToFailure(Object error) {
    if (error is Failure) return error;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return NetworkFailure(error.message ?? 'Connection error');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = _extractMessage(error.response?.data);
          if (statusCode == 401 || statusCode == 403) {
            return AuthFailure(message);
          }
          return ServerFailure(message);
        default:
          return ServerFailure(error.message ?? 'Request failed');
      }
    }

    if (error is AuthException) return AuthFailure(error.message);
    if (error is NetworkException) return NetworkFailure(error.message);
    if (error is CacheException) return CacheFailure(error.message);
    if (error is ServerException) return ServerFailure(error.message);
    if (error is ValidationException) return ValidationFailure(error.message);
    if (error is SyncException) return SyncFailure(error.message);

    return UnknownFailure(error.toString());
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['detail']?.toString() ??
          data['message']?.toString() ??
          'Server error occurred';
    }
    return 'Server error occurred';
  }
}
