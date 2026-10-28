import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';

DioException _bad(
  int status,
  Object? data, {
  Map<String, List<String>>? headers,
}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: data,
      headers: Headers.fromMap(headers ?? {}),
    ),
  );
}

void main() {
  const handler = ErrorHandler();

  group('status mapping', () {
    test('401 -> AuthFailure', () {
      expect(
        handler.mapExceptionToFailure(_bad(401, {'detail': 'nope'})),
        const AuthFailure('nope'),
      );
    });

    test('403 -> PermissionDeniedFailure with a clear message', () {
      final failure =
          handler.mapExceptionToFailure(_bad(403, {'detail': 'x'}));
      expect(failure, isA<PermissionDeniedFailure>());
      expect(failure.message, "You don't have permission to do this.");
    });

    test('404 -> NotFoundFailure', () {
      expect(
        handler.mapExceptionToFailure(_bad(404, {'detail': 'Sale not found'})),
        isA<NotFoundFailure>(),
      );
    });

    test('409 -> ConflictFailure carries the server message', () {
      final failure =
          handler.mapExceptionToFailure(_bad(409, {'detail': 'SKU exists'}));
      expect(failure, isA<ConflictFailure>());
      expect(failure.message, 'SKU exists');
    });

    test('500 -> ServerFailure', () {
      expect(
        handler.mapExceptionToFailure(_bad(500, 'oops')),
        isA<ServerFailure>(),
      );
    });

    test('network errors -> NetworkFailure', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionError,
      );
      expect(handler.mapExceptionToFailure(err), isA<NetworkFailure>());
    });
  });

  group('429', () {
    test('uses Retry-After seconds', () {
      final failure = handler.mapExceptionToFailure(
        _bad(
          429,
          {'detail': 'slow down'},
          headers: {
            'retry-after': ['42'],
          },
        ),
      );
      expect(failure, isA<RateLimitFailure>());
      expect((failure as RateLimitFailure).retryAfterSeconds, 42);
      expect(failure.message, 'Too many attempts, try again in 42 seconds');
    });

    test('defaults to 60s without a header', () {
      final failure = handler.mapExceptionToFailure(_bad(429, null));
      expect((failure as RateLimitFailure).retryAfterSeconds, 60);
    });

    test('parses an HTTP-date Retry-After', () {
      final now = DateTime.utc(2026, 10, 21, 7, 28, 0);
      expect(
        ErrorHandler.parseRetryAfter('Wed, 21 Oct 2026 07:28:30 GMT', now: now),
        30,
      );
    });

    test('garbage falls back to 60, zero is clamped to 1', () {
      expect(ErrorHandler.parseRetryAfter('soon'), 60);
      expect(ErrorHandler.parseRetryAfter('0'), 1);
      expect(ErrorHandler.parseRetryAfter(null), 60);
    });
  });

  group('422 validation', () {
    final body = {
      'detail': [
        {
          'loc': ['body', 'owner_phone'],
          'msg': 'field required',
          'type': 'value_error.missing',
        },
        {
          'loc': ['body', 'lines', 0, 'qty'],
          'msg': 'Value error, must be greater than 0',
        },
      ],
    };

    test('is parsed into per-field messages', () {
      final failure = handler.mapExceptionToFailure(_bad(422, body));
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).fieldErrors, {
        'owner_phone': 'field required',
        'lines.0.qty': 'must be greater than 0',
      });
    });

    test('message is readable, not a raw list dump', () {
      final failure = handler.mapExceptionToFailure(_bad(422, body));
      expect(
        failure.message,
        'Owner phone: field required\nLines › #1 › Qty: must be greater than 0',
      );
      expect(failure.message, isNot(contains('{')));
      expect(failure.message, isNot(contains('loc')));
    });

    test('string detail on 422 still works', () {
      final failure =
          handler.mapExceptionToFailure(_bad(422, {'detail': 'Bad thing'}));
      expect(failure.message, 'Bad thing');
      expect((failure as ValidationFailure).fieldErrors, isEmpty);
    });
  });

  group('ApiErrorParser', () {
    test('label humanises keys', () {
      expect(ApiErrorParser.label('new_password'), 'New password');
      expect(
        ApiErrorParser.label('lines.2.unit_price'),
        'Lines › #3 › Unit price',
      );
    });

    test('falls back to the message field then the default', () {
      expect(ApiErrorParser.message({'message': 'm'}), 'm');
      expect(ApiErrorParser.message(null), 'Server error occurred');
    });
  });
}
