import 'dart:io' show HttpDate;

import 'package:dio/dio.dart';
import 'package:frantend/core/error/api_error_parser.dart';
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
          return mapStatus(
            error.response?.statusCode,
            error.response?.data,
            headers: error.response?.headers,
          );
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

  /// Maps an HTTP status + body to a typed [Failure].
  Failure mapStatus(int? statusCode, dynamic data, {Headers? headers}) {
    final message = ApiErrorParser.message(data);
    switch (statusCode) {
      case 401:
        return AuthFailure(message);
      case 402:
        return SubscriptionFailure.fromBody(data);
      case 403:
        return const PermissionDeniedFailure();
      case 404:
        return NotFoundFailure(
          data is Map && data['detail'] is String ? message : 'Not found',
        );
      case 409:
        return ConflictFailure(message);
      case 422:
        final fields = data is Map
            ? ApiErrorParser.fieldErrors(data['detail'])
            : const <String, String>{};
        return ValidationFailure(message, fields);
      case 429:
        return RateLimitFailure(
          retryAfterSeconds: parseRetryAfter(headers?.value('retry-after')),
        );
      default:
        return ServerFailure(message);
    }
  }

  /// `Retry-After` is either delta-seconds or an HTTP date.
  static int parseRetryAfter(String? value, {DateTime? now}) {
    if (value == null || value.trim().isEmpty) return 60;
    final seconds = int.tryParse(value.trim());
    if (seconds != null) return seconds < 1 ? 1 : seconds;
    try {
      final date = _parseHttpDate(value.trim());
      final delta = date.difference(now ?? DateTime.now().toUtc()).inSeconds;
      return delta < 1 ? 1 : delta;
    } catch (_) {
      return 60;
    }
  }

  static DateTime _parseHttpDate(String value) {
    // e.g. "Wed, 21 Oct 2026 07:28:00 GMT"
    return HttpDate.parse(value);
  }
}
