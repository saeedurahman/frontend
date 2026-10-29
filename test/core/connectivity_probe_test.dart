import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/network/interceptors/timeout_interceptor.dart';

import '../helpers/fake_http.dart';

void main() {
  /// A scripted server: each call consumes the next outcome.
  ///   Duration  -> success with that latency
  ///   Object    -> throws it
  ReachabilityPing scripted(List<Object> script, {List<Duration>? timeouts}) {
    var i = 0;
    return (timeout) async {
      timeouts?.add(timeout);
      final step = script[i < script.length ? i++ : script.length - 1];
      if (step is Duration) return step;
      throw step;
    };
  }

  const fast = Duration(milliseconds: 80);
  final down = DioException(
    requestOptions: RequestOptions(path: '/time'),
    type: DioExceptionType.connectionTimeout,
  );

  HttpConnectivityProbe build(
    ReachabilityPing ping, {
    Stream<bool>? hint,
    int failuresBeforeOffline = 2,
  }) =>
      HttpConnectivityProbe(
        ping: ping,
        hint: hint,
        failuresBeforeOffline: failuresBeforeOffline,
      );

  test('uses a 3 second probe timeout', () {
    final seen = <Duration>[];
    fakeAsync((async) {
      final probe = build(scripted([fast], timeouts: seen));
      probe.check();
      async.flushMicrotasks();
      probe.dispose();
    });
    expect(seen.single, const Duration(seconds: 3));
  });

  test('starts optimistic: online until a probe says otherwise', () {
    final probe = build(scripted([fast]));
    expect(probe.current, ReachabilityStatus.online);
    expect(probe.isReachable, isTrue);
    probe.dispose();
  });

  test('one dropped probe does not flip to offline (debounce)', () {
    fakeAsync((async) {
      final probe = build(scripted([down, fast]));
      final events = <ReachabilityStatus>[];
      probe.status.listen(events.add);

      probe.check();
      async.flushMicrotasks();
      expect(probe.current, ReachabilityStatus.online);
      expect(events, isEmpty);
      probe.dispose();
    });
  });

  test('two consecutive failures report offline, success reports online', () {
    fakeAsync((async) {
      final probe = build(scripted([down, down, fast]));
      final events = <ReachabilityStatus>[];
      probe.status.listen(events.add);

      probe.check();
      async.flushMicrotasks();
      probe.check();
      async.flushMicrotasks();
      expect(probe.current, ReachabilityStatus.offline);
      expect(probe.isReachable, isFalse);

      probe.check();
      async.flushMicrotasks();
      expect(probe.current, ReachabilityStatus.online);
      expect(events, [ReachabilityStatus.offline, ReachabilityStatus.online]);
      probe.dispose();
    });
  });

  test('a slow answer is degraded, not offline', () {
    fakeAsync((async) {
      final probe = build(scripted([const Duration(seconds: 2)]));
      probe.check();
      async.flushMicrotasks();
      expect(probe.current, ReachabilityStatus.degraded);
      expect(probe.isReachable, isTrue);
      probe.dispose();
    });
  });

  test('a 5xx from /time is degraded (server up but unhealthy)', () {
    fakeAsync((async) {
      final bad = DioException(
        requestOptions: RequestOptions(path: '/time'),
        type: DioExceptionType.badResponse,
      );
      final probe = build(scripted([bad]));
      probe.check();
      async.flushMicrotasks();
      expect(probe.current, ReachabilityStatus.degraded);
      probe.dispose();
    });
  });

  test('status stream emits only on change', () {
    fakeAsync((async) {
      final probe = build(scripted([fast, fast, fast]));
      final events = <ReachabilityStatus>[];
      probe.status.listen(events.add);
      for (var i = 0; i < 3; i++) {
        probe.check();
        async.flushMicrotasks();
      }
      expect(events, isEmpty);
      probe.dispose();
    });
  });

  test('offline probing backs off exponentially up to the cap', () {
    fakeAsync((async) {
      final probe = build(scripted([down]));
      final delays = <Duration>[];
      for (var i = 0; i < 8; i++) {
        probe.check();
        async.flushMicrotasks();
        if (probe.current == ReachabilityStatus.offline) {
          delays.add(probe.nextDelay);
        }
      }
      expect(delays, [
        const Duration(seconds: 2),
        const Duration(seconds: 4),
        const Duration(seconds: 8),
        const Duration(seconds: 16),
        const Duration(seconds: 32),
        const Duration(seconds: 60),
        const Duration(seconds: 60),
      ]);
      probe.dispose();
    });
  });

  test('recovery resets the backoff', () {
    fakeAsync((async) {
      final probe = build(scripted([down, down, down, fast, down, down]));
      for (var i = 0; i < 3; i++) {
        probe.check();
        async.flushMicrotasks();
      }
      expect(probe.nextDelay, const Duration(seconds: 4));
      probe.check();
      async.flushMicrotasks();
      expect(probe.current, ReachabilityStatus.online);
      for (var i = 0; i < 2; i++) {
        probe.check();
        async.flushMicrotasks();
      }
      expect(probe.nextDelay, const Duration(seconds: 2));
      probe.dispose();
    });
  });

  test('start() probes periodically on a timer', () {
    fakeAsync((async) {
      var calls = 0;
      final probe = build((timeout) async {
        calls++;
        return fast;
      });
      probe.start();
      async.flushMicrotasks();
      expect(calls, 1);
      async.elapse(const Duration(seconds: 31));
      expect(calls, 2);
      probe.stop();
      async.elapse(const Duration(minutes: 5));
      expect(calls, 2, reason: 'stop() cancels the schedule');
      probe.dispose();
    });
  });

  test('an OS connectivity hint triggers a (debounced) re-probe', () {
    fakeAsync((async) {
      final hint = StreamController<bool>.broadcast();
      var calls = 0;
      final probe = build((timeout) async {
        calls++;
        return fast;
      }, hint: hint.stream);
      probe.start();
      async.flushMicrotasks();
      expect(calls, 1);

      hint.add(false);
      hint.add(true);
      hint.add(false);
      async.elapse(const Duration(milliseconds: 600));
      expect(calls, 2, reason: 'three hints collapse into one probe');
      probe.dispose();
      hint.close();
    });
  });

  test('concurrent check() calls share one request', () {
    fakeAsync((async) {
      var calls = 0;
      final probe = build((timeout) async {
        calls++;
        return fast;
      });
      probe.check();
      probe.check();
      probe.check();
      async.flushMicrotasks();
      expect(calls, 1);
      probe.dispose();
    });
  });

  group('forApi (real Dio path)', () {
    test('GETs /time without auth, with no retry flag', () async {
      final adapter = FakeAdapter((o) => jsonResponse({'now': 1}));
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))
        ..httpClientAdapter = adapter;
      final probe = HttpConnectivityProbe.forApi(dio: dio);

      final status = await probe.check();

      expect(status, ReachabilityStatus.online);
      final request = adapter.requests.single;
      expect(request.path, '/time');
      expect(request.method, 'GET');
      expect(request.extra['no_retry'], isTrue);
      expect(request.connectTimeout, const Duration(seconds: 3));
      expect(request.headers.containsKey('Authorization'), isFalse);
      probe.dispose();
    });

    test('a server error is degraded', () async {
      final adapter = FakeAdapter((o) => jsonResponse({}, status: 503));
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))
        ..httpClientAdapter = adapter;
      final probe = HttpConnectivityProbe.forApi(dio: dio);
      expect(await probe.check(), ReachabilityStatus.degraded);
      probe.dispose();
    });

    test('the probe path is POS-critical so it is never auto-retried', () {
      expect(TimeoutInterceptor.isPosCritical('/time'), isTrue);
    });
  });
}
