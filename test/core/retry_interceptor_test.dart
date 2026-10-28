import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/network/interceptors/retry_interceptor.dart';
import 'package:frantend/core/network/interceptors/timeout_interceptor.dart';

import '../helpers/fake_http.dart';

void main() {
  Dio build(FakeAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dio.httpClientAdapter = adapter;
    dio.interceptors.addAll([
      TimeoutInterceptor(),
      RetryInterceptor(dio: dio, retryDelay: Duration.zero),
    ]);
    return dio;
  }

  FakeAdapter failingThenOk(DioExceptionType type, {int failures = 1}) {
    var failed = 0;
    return FakeAdapter((o) {
      if (failed < failures) {
        failed++;
        throw DioException(requestOptions: o, type: type);
      }
      return jsonResponse({'ok': true});
    });
  }

  group('idempotent methods are retried', () {
    for (final method in ['GET', 'HEAD', 'PUT', 'DELETE']) {
      test(method, () async {
        final adapter = failingThenOk(DioExceptionType.receiveTimeout);
        final dio = build(adapter);

        final response = await dio.request<dynamic>(
          '/things/1',
          options: Options(method: method),
        );

        expect(response.statusCode, 200);
        expect(adapter.requests, hasLength(2));
      });
    }
  });

  test('POST gets an Idempotency-Key', () async {
    final adapter = FakeAdapter((o) => jsonResponse({'ok': true}));
    final dio = build(adapter);

    await dio.post<dynamic>('/customers', data: {});

    final key =
        adapter.requests.single.headers[RetryInterceptor.idempotencyHeader];
    expect(key, isA<String>());
    expect((key as String).length, 36);
  });

  test('a caller-supplied key is kept', () async {
    final adapter = FakeAdapter((o) => jsonResponse({'ok': true}));
    final dio = build(adapter);

    await dio.post<dynamic>(
      '/sales',
      data: {},
      options: Options(headers: {'Idempotency-Key': 'mine'}),
    );

    expect(adapter.requests.single.headers['Idempotency-Key'], 'mine');
  });

  test('each logical POST gets a different key', () async {
    final adapter = FakeAdapter((o) => jsonResponse({'ok': true}));
    final dio = build(adapter);

    await dio.post<dynamic>('/customers', data: {});
    await dio.post<dynamic>('/customers', data: {});

    final keys =
        adapter.requests.map((r) => r.headers['Idempotency-Key']).toSet();
    expect(keys, hasLength(2));
  });

  test('POST retry after a connection timeout reuses the SAME key', () async {
    final adapter = failingThenOk(DioExceptionType.connectionTimeout);
    final dio = build(adapter);

    final response = await dio.post<dynamic>('/customers', data: {});

    expect(response.statusCode, 200);
    expect(adapter.requests, hasLength(2));
    expect(
      adapter.requests[0].headers['Idempotency-Key'],
      adapter.requests[1].headers['Idempotency-Key'],
    );
  });

  group('same logical money action reuses its key', () {
    Future<List<Object?>> keysFor(
      Dio dio,
      FakeAdapter adapter,
      String path,
      List<Map<String, dynamic>> bodies,
    ) async {
      for (final body in bodies) {
        try {
          await dio.post<dynamic>(path, data: body);
        } on DioException {
          // expected for failing adapters
        }
      }
      return adapter.requests.map((r) => r.headers['Idempotency-Key']).toList();
    }

    for (final path in [
      '/sales',
      '/returns',
      '/expenses',
      '/expenses/e1/payments',
      '/customers/c1/payments',
      '/sales/s1/payments',
    ]) {
      test('POST $path: re-tap after a 500 sends the SAME key', () async {
        final adapter = FakeAdapter(
          (o) => jsonResponse({'detail': 'boom'}, status: 500),
        );
        final dio = build(adapter);
        final keys = await keysFor(dio, adapter, path, [
          {'amount': '10.00'},
          {'amount': '10.00'},
        ]);
        expect(keys, hasLength(2));
        expect(keys[0], keys[1]);
      });
    }

    test('a different body is a NEW action with a new key', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({'detail': 'boom'}, status: 500),
      );
      final dio = build(adapter);
      final keys = await keysFor(dio, adapter, '/sales', [
        {'amount': '10.00'},
        {'amount': '12.00'},
      ]);
      expect(keys.toSet(), hasLength(2));
    });

    test('after success the same body gets a fresh key', () async {
      final adapter = FakeAdapter((o) => jsonResponse({'ok': true}));
      final dio = build(adapter);
      final keys = await keysFor(dio, adapter, '/expenses', [
        {'amount': '5.00'},
        {'amount': '5.00'},
      ]);
      expect(keys.toSet(), hasLength(2));
    });

    test('after a 422 rejection the same body gets a fresh key', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({'detail': 'invalid'}, status: 422),
      );
      final dio = build(adapter);
      final keys = await keysFor(dio, adapter, '/returns', [
        {'qty': '1'},
        {'qty': '1'},
      ]);
      expect(keys.toSet(), hasLength(2));
    });

    test('a timeout keeps the key (server may have committed)', () async {
      final adapter = FakeAdapter((o) {
        throw DioException(
            requestOptions: o, type: DioExceptionType.receiveTimeout);
      });
      final dio = build(adapter);
      final keys = await keysFor(dio, adapter, '/sales', [
        {'amount': '1.00'},
        {'amount': '1.00'},
      ]);
      expect(keys[0], keys[1]);
    });

    test('non-money POSTs keep a fresh key per request', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({'detail': 'boom'}, status: 500),
      );
      final dio = build(adapter);
      final keys = await keysFor(dio, adapter, '/customers', [
        {'name': 'a'},
        {'name': 'a'},
      ]);
      expect(keys.toSet(), hasLength(2));
    });

    test('registry forgets keys after the TTL', () {
      var now = DateTime(2026, 1, 1);
      final registry = IdempotencyKeyRegistry(
        ttl: const Duration(minutes: 15),
        clock: () => now,
      );
      final first = registry.keyFor('POST /sales {}');
      expect(registry.keyFor('POST /sales {}'), first);
      now = now.add(const Duration(minutes: 16));
      expect(registry.keyFor('POST /sales {}'), isNot(first));
    });
  });

  for (final path in ['/sales', '/payments', '/expenses']) {
    for (final type in [
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.connectionError,
    ]) {
      test('POST $path is NOT auto-retried after ${type.name}', () async {
        final adapter = failingThenOk(type);
        final dio = build(adapter);

        await expectLater(
          dio.post<dynamic>(path, data: {}),
          throwsA(isA<DioException>()),
        );
        expect(adapter.requests, hasLength(1));
      });
    }
  }

  test('POST without a key is never retried', () {
    final interceptor = RetryInterceptor(dio: Dio());
    final err = DioException(
      requestOptions: RequestOptions(path: '/sales', method: 'POST'),
      type: DioExceptionType.connectionTimeout,
    );
    expect(interceptor.shouldRetry(err), isFalse);
  });

  test('HTTP errors (e.g. 500) are not retried', () async {
    final adapter = FakeAdapter((o) => jsonResponse({'d': 1}, status: 500));
    final dio = build(adapter);

    await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
    expect(adapter.requests, hasLength(1));
  });

  test('retries stop after the configured maximum', () async {
    final adapter =
        failingThenOk(DioExceptionType.connectionTimeout, failures: 99);
    final dio = build(adapter);

    await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
    expect(adapter.requests, hasLength(4)); // 1 + 3 retries
  });

  group('timeouts', () {
    test('default 15s, 60s for report/export/upload paths', () {
      expect(kDefaultApiTimeout, const Duration(seconds: 15));
      expect(kLongApiTimeout, const Duration(seconds: 60));
      for (final p in [
        '/analytics/sales-trend',
        '/invoice/export/sales',
        '/invoice/export/inventory',
        '/reports/x',
        '/products/upload',
      ]) {
        expect(TimeoutInterceptor.isLongRunning(p), isTrue, reason: p);
      }
      for (final p in ['/sales', '/products', '/auth/login']) {
        expect(TimeoutInterceptor.isLongRunning(p), isFalse, reason: p);
      }
    });

    test('interceptor applies the long timeout only to long paths', () async {
      final adapter = FakeAdapter((o) => jsonResponse({'ok': true}));
      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://test',
          receiveTimeout: kDefaultApiTimeout,
          sendTimeout: kDefaultApiTimeout,
        ),
      );
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(TimeoutInterceptor());

      await dio.get<dynamic>('/sales');
      await dio.get<dynamic>('/analytics/dashboard');

      expect(adapter.requests[0].receiveTimeout, kDefaultApiTimeout);
      expect(adapter.requests[1].receiveTimeout, kLongApiTimeout);
      expect(adapter.requests[1].sendTimeout, kLongApiTimeout);
    });
  });
}
