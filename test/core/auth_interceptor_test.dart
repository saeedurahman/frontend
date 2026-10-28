import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';

import '../helpers/fake_http.dart';

void main() {
  late FakeSecureStorage storage;
  late int expiredCalls;
  late int refreshCalls;

  Dio buildDio(FakeHandler handler) {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dio.httpClientAdapter = FakeAdapter(handler);
    dio.interceptors.add(
      AuthInterceptor(
        storage,
        dio: dio,
        onSessionExpired: () async {
          expiredCalls++;
          await storage.clearAuthSession();
        },
      ),
    );
    return dio;
  }

  setUp(() {
    storage = FakeSecureStorage(access: 'old', refresh: 'r1', tenant: 't1');
    expiredCalls = 0;
    refreshCalls = 0;
  });

  ResponseBody refreshOk() {
    refreshCalls++;
    return jsonResponse({'access_token': 'new', 'refresh_token': 'r2'});
  }

  test('403 never clears the session and surfaces as a 403', () async {
    final dio = buildDio((o) => jsonResponse({'detail': 'no'}, status: 403));

    await expectLater(
      dio.get<dynamic>('/products'),
      throwsA(
        isA<DioException>().having((e) => e.response?.statusCode, 'code', 403),
      ),
    );

    expect(expiredCalls, 0);
    expect(await storage.getAccessToken(), 'old');
    expect(await storage.getRefreshToken(), 'r1');
    expect(await storage.getTenantId(), 't1');
  });

  test('401 refreshes once and retries with the new token', () async {
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') return refreshOk();
      return o.headers['Authorization'] == 'Bearer new'
          ? jsonResponse({'ok': true})
          : jsonResponse({'detail': 'expired'}, status: 401);
    });

    final response = await dio.get<dynamic>('/products');

    expect(response.statusCode, 200);
    expect(refreshCalls, 1);
    expect(response.requestOptions.extra['retried'], isTrue);
    expect(await storage.getAccessToken(), 'new');
    expect(await storage.getRefreshToken(), 'r2',
        reason: 'rotated refresh token must be persisted');
    expect(expiredCalls, 0);
  });

  test('the next refresh sends the rotated refresh token, not the old one',
      () async {
    final sentRefreshTokens = <String>[];
    var accessGen = 0;
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') {
        final sent = (o.data as Map)['refresh_token'] as String;
        sentRefreshTokens.add(sent);
        accessGen++;
        return jsonResponse({
          'access_token': 'a$accessGen',
          'refresh_token': 'r${accessGen + 1}',
        });
      }
      // Only the most recent access token is accepted.
      return o.headers['Authorization'] == 'Bearer a$accessGen' && accessGen > 0
          ? jsonResponse({'ok': true})
          : jsonResponse({'detail': 'expired'}, status: 401);
    });

    await dio.get<dynamic>('/products'); // refresh #1 with r1 -> r2
    // Server expires the access token again.
    accessGen++;
    await dio.get<dynamic>('/products'); // refresh #2 must use r2

    expect(sentRefreshTokens.first, 'r1');
    expect(sentRefreshTokens.last, 'r2');
    expect(await storage.getRefreshToken(), 'r4');
  });

  test('concurrent 401s share ONE refresh and all complete', () async {
    final refreshGate = Completer<void>();
    final dio = buildDio((o) async {
      if (o.path == '/auth/refresh') {
        await refreshGate.future;
        return refreshOk();
      }
      return o.headers['Authorization'] == 'Bearer new'
          ? jsonResponse({'path': o.path})
          : jsonResponse({'detail': 'expired'}, status: 401);
    });

    final calls = [
      dio.get<dynamic>('/a'),
      dio.get<dynamic>('/b'),
      dio.get<dynamic>('/c'),
    ];
    await Future<void>.delayed(const Duration(milliseconds: 50));
    refreshGate.complete();

    final responses = await Future.wait(calls).timeout(
      const Duration(seconds: 5),
    );

    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(refreshCalls, 1);
  });

  test('a retried request that 401s again completes (no deadlock)', () async {
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') return refreshOk();
      return jsonResponse({'detail': 'still no'}, status: 401);
    });

    await expectLater(
      dio.get<dynamic>('/products').timeout(const Duration(seconds: 5)),
      throwsA(
        isA<DioException>().having((e) => e.response?.statusCode, 'code', 401),
      ),
    );

    expect(refreshCalls, 1, reason: 'must not refresh again for the retry');
    // The refresh itself succeeded, so the session is not torn down.
    expect(expiredCalls, 0);
  });

  test('refresh rejected (401) clears the session and notifies once',
      () async {
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') {
        refreshCalls++;
        return jsonResponse({'detail': 'bad refresh'}, status: 401);
      }
      return jsonResponse({'detail': 'expired'}, status: 401);
    });

    final calls = [dio.get<dynamic>('/a'), dio.get<dynamic>('/b')];
    for (final call in calls) {
      await expectLater(call, throwsA(isA<DioException>()));
    }

    expect(refreshCalls, 1);
    expect(expiredCalls, 1, reason: 'one refresh, one expiry');
    expect(await storage.getAccessToken(), isNull);
    expect(await storage.getRefreshToken(), isNull);
  });

  test('refresh rejected with 400 also logs out', () async {
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') {
        return jsonResponse({'detail': 'invalid'}, status: 400);
      }
      return jsonResponse({'detail': 'expired'}, status: 401);
    });

    await expectLater(dio.get<dynamic>('/a'), throwsA(isA<DioException>()));

    expect(expiredCalls, 1);
    expect(await storage.getAccessToken(), isNull);
  });

  test('network error during refresh keeps tokens and reports connectivity',
      () async {
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') {
        throw DioException(
          requestOptions: o,
          type: DioExceptionType.connectionError,
        );
      }
      return jsonResponse({'detail': 'expired'}, status: 401);
    });

    await expectLater(
      dio.get<dynamic>('/products'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );

    expect(expiredCalls, 0);
    expect(await storage.getAccessToken(), 'old');
    expect(await storage.getRefreshToken(), 'r1');
  });

  test('refresh 500 keeps tokens', () async {
    final dio = buildDio((o) {
      if (o.path == '/auth/refresh') {
        return jsonResponse({'detail': 'boom'}, status: 500);
      }
      return jsonResponse({'detail': 'expired'}, status: 401);
    });

    await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

    expect(expiredCalls, 0);
    expect(await storage.getRefreshToken(), 'r1');
  });

  for (final path in [
    '/auth/login',
    '/auth/login/pin',
    '/auth/register',
  ]) {
    test('401 from $path does not trigger a refresh', () async {
      final adapter = <String>[];
      final dio = buildDio((o) {
        adapter.add(o.path);
        return jsonResponse({'detail': 'Invalid credentials'}, status: 401);
      });

      await expectLater(
        dio.post<dynamic>(path, data: {'password': 'x'}),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'code', 401),
        ),
      );

      expect(adapter, [path]);
      expect(expiredCalls, 0);
      expect(await storage.getRefreshToken(), 'r1');
    });
  }

  test('credential endpoints are sent without a stale bearer token', () async {
    final dio = buildDio((o) => jsonResponse({'ok': true}));
    final response = await dio.post<dynamic>('/auth/login', data: {});
    expect(response.requestOptions.headers.containsKey('Authorization'),
        isFalse);
  });

  test('no refresh token stored -> session expires', () async {
    storage = FakeSecureStorage(access: 'old');
    final dio = buildDio((o) => jsonResponse({'detail': 'x'}, status: 401));

    await expectLater(dio.get<dynamic>('/a'), throwsA(isA<DioException>()));

    expect(expiredCalls, 1);
  });

  test('isAuthExchangePath', () {
    expect(AuthInterceptor.isAuthExchangePath('/auth/login'), isTrue);
    expect(AuthInterceptor.isAuthExchangePath('/auth/login/pin'), isTrue);
    expect(AuthInterceptor.isAuthExchangePath('/auth/register'), isTrue);
    expect(AuthInterceptor.isAuthExchangePath('/auth/refresh'), isTrue);
    expect(AuthInterceptor.isAuthExchangePath('/auth/me'), isFalse);
    expect(AuthInterceptor.isAuthExchangePath('/sales'), isFalse);
  });
}
