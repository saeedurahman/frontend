// The header sync chip: every state transition (fake engine), and the reasons
// it used to stay on "Syncing" (real engine, fake server).
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_status.dart';
import 'package:frantend/shared/widgets/sync/sync_status_chip.dart';

import '../helpers/fake_http.dart';
import 'fake_sync_server.dart';
import 'sync_rig.dart';

/// An engine whose state the test sets by hand.
class _FakeEngine extends Fake implements SyncEngine {
  final _states = StreamController<SyncEngineState>.broadcast(sync: true);

  @override
  SyncEngineState state = const SyncEngineState();

  @override
  Stream<SyncEngineState> get states => _states.stream;

  void emit({bool syncing = false, int pending = 0, int sending = 0, int failed = 0}) {
    state = SyncEngineState(
      syncing: syncing,
      counts: OutboxCounts(pending: pending, sending: sending, failed: failed),
    );
    _states.add(state);
  }
}

/// The server answers "more to come" without ever moving on.
class _StuckFeed extends FakeSyncServer {
  bool stuck = false;

  @override
  Future<PullPage> pull({String? since, int limit = 500, String? branchId}) async {
    if (!stuck) return super.pull(since: since, limit: limit, branchId: branchId);
    pullCalls++;
    return PullPage(
      changes: const [],
      nextCursor: since,
      hasMore: true,
      permissionsVersion: permissionsVersion,
    );
  }
}

/// The saved place of a half-finished first download is no longer accepted.
class _StaleToken extends FakeSyncServer {
  bool rejectNextToken = false;

  @override
  Future<SnapshotPage> snapshot({String? pageToken, int limit = 500}) async {
    if (pageToken != null && rejectNextToken) {
      rejectNextToken = false;
      throw const InvalidCursorException('invalid cursor');
    }
    return super.snapshot(pageToken: pageToken, limit: limit);
  }
}

class _BrokenStorage extends Fake implements SecureStorage {
  @override
  Future<String?> getAccessToken() async => throw StateError('key store unreadable');
}

SyncEngine _engineOver(
  SyncRig rig,
  SyncApi api, {
  Future<void> Function()? afterSync,
}) =>
    SyncEngine(
      store: rig.store,
      push: PushService(store: rig.store, api: api, ids: rig.ids, config: rig.config),
      pull: PullService(store: rig.store, api: api, config: rig.config),
      probe: rig.probe,
      config: rig.config,
      hooks: SyncHooks(afterSync: afterSync),
    );

void main() {
  group('chip states from a fake engine', () {
    late _FakeEngine engine;
    late FixedConnectivityProbe probe;

    setUp(() {
      engine = _FakeEngine();
      probe = FixedConnectivityProbe();
    });

    // The source subscribes inside the test, so pump() delivers its events.
    Future<void> show(WidgetTester tester) => tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: SyncStatusChip(source: EngineSyncStatusSource(engine, probe)),
            ),
          ),
        ));

    /// Delivers the stream events, then rebuilds.
    Future<void> settle(WidgetTester tester) async {
      await tester.pump();
      await tester.pump();
    }

    void expectChip(String label, {required bool spinner}) {
      expect(find.text(label), findsOneWidget);
      expect(
        find.byType(CircularProgressIndicator),
        spinner ? findsOneWidget : findsNothing,
        reason: label,
      );
    }

    testWidgets('idle is "All synced" with a green dot and no spinner',
        (tester) async {
      await show(tester);
      expectChip('All synced', spinner: false);
      final dot = tester.widget<Icon>(find.byIcon(Icons.circle));
      expect(dot.color, AppColors.online);
      expect(dot.size, lessThan(12));
    });

    testWidgets('idle -> syncing -> idle', (tester) async {
      await show(tester);
      engine.emit(syncing: true);
      await settle(tester);
      expectChip('Syncing…', spinner: true);

      engine.emit();
      await settle(tester);
      expectChip('All synced', spinner: false);
    });

    testWidgets('waiting -> syncing -> all synced', (tester) async {
      await show(tester);
      engine.emit(pending: 2);
      await settle(tester);
      expectChip('2 waiting', spinner: false);

      engine.emit(syncing: true, sending: 2);
      await settle(tester);
      expectChip('Syncing…', spinner: true);

      engine.emit();
      await settle(tester);
      expectChip('All synced', spinner: false);
    });

    testWidgets('syncing -> needs attention -> all synced', (tester) async {
      await show(tester);
      engine.emit(syncing: true, sending: 1);
      await settle(tester);

      engine.emit(failed: 1);
      await settle(tester);
      expectChip('1 needs attention', spinner: false);

      engine.emit(failed: 3, pending: 1);
      await settle(tester);
      expectChip('3 need attention', spinner: false);

      engine.emit();
      await settle(tester);
      expectChip('All synced', spinner: false);
    });

    testWidgets('offline wins over everything, and back', (tester) async {
      await show(tester);
      engine.emit(syncing: true, pending: 2, failed: 1);
      await settle(tester);

      probe.set(ReachabilityStatus.offline);
      await settle(tester);
      expectChip('Offline', spinner: false);

      probe.set(ReachabilityStatus.online);
      engine.emit(pending: 2);
      await settle(tester);
      expectChip('2 waiting', spinner: false);
    });

    testWidgets('a slow server (degraded) is not shown as offline',
        (tester) async {
      await show(tester);
      probe.set(ReachabilityStatus.degraded);
      await settle(tester);
      expectChip('All synced', spinner: false);
    });
  });

  group('the real engine is only "syncing" while work runs', () {
    late SyncRig rig;
    setUp(() => rig = SyncRig()..seedServer());
    tearDown(() => rig.dispose());

    /// Every distinct value of `syncing` seen during [body].
    Future<List<bool>> flags(SyncEngine engine, Future<void> Function() body) async {
      final seen = <bool>[engine.state.syncing];
      final sub = engine.states.listen((s) {
        if (s.syncing != seen.last) seen.add(s.syncing);
      });
      await body();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      return seen;
    }

    test('first download shows it, then idle', () async {
      expect(await flags(rig.engine, () => rig.sync(manual: false)), [false, true, false]);
    });

    test('a background check that finds nothing never shows it', () async {
      await rig.sync();
      expect(await flags(rig.engine, () => rig.sync(manual: false)), [false]);
      expect(rig.engine.state.lastError, isNull);
    });

    test('incoming changes show it', () async {
      await rig.sync();
      rig.product('p2', 'Sugar 1kg', 'S1');
      expect(await flags(rig.engine, () => rig.sync(manual: false)), [false, true, false]);
    });

    test('queued work shows it, then idle with nothing waiting', () async {
      await rig.sync();
      await rig.sell();
      expect(await flags(rig.engine, () => rig.sync(manual: false)), [false, true, false]);
      expect(rig.engine.state.counts.unfinished, 0);
    });

    test('"Sync now" shows it even when there is nothing to do', () async {
      await rig.sync();
      expect(await flags(rig.engine, () => rig.sync()), [false, true, false]);
    });

    test('unreachable server: idle again, the work stays waiting', () async {
      await rig.sync();
      await rig.sell();
      rig.server.offline = true;
      await rig.sync(manual: false);
      expect(rig.engine.state.syncing, isFalse);
      expect(rig.engine.state.counts.pending, 1);
    });

    test('follow-up requests after a sync do not keep it spinning', () async {
      final gate = Completer<void>();
      final reached = Completer<void>();
      final engine = _engineOver(rig, rig.server, afterSync: () {
        reached.complete();
        return gate.future;
      });
      final running = engine.syncNow(manual: true);
      await reached.future;
      expect(engine.state.syncing, isFalse);
      gate.complete();
      await running;
      engine.dispose();
    });

    test('a button press while a cycle runs still shows progress', () async {
      await rig.sync();
      final gate = Completer<void>();
      var runs = 0;
      final engine = _engineOver(rig, rig.server,
          afterSync: () => runs++ == 0 ? gate.future : Future<void>.value());
      final first = engine.syncNow();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final seen = await flags(engine, () async {
        final second = engine.syncNow(manual: true);
        gate.complete();
        await Future.wait([first, second]);
      });
      expect(seen, [false, true, false]);
      engine.dispose();
    });

    test('a feed that never moves on ends the cycle with a problem', () async {
      final server = _StuckFeed()..put('settings', 'biz', {'business_name': 'Demo'});
      final engine = _engineOver(rig, server);
      await engine.syncNow(manual: true);
      server.stuck = true;
      await engine.syncNow(manual: true).timeout(const Duration(seconds: 5));
      expect(engine.state.syncing, isFalse);
      expect(engine.state.lastError, contains('same changes'));
      engine.dispose();
    });

    test('a refused download token restarts the first download', () async {
      final server = _StaleToken()..snapshotPageSize = 1;
      server.put('settings', 'biz', {'business_name': 'Demo'});
      server.put('category', 'cat-1', {'id': 'cat-1', 'name': 'Grocery'});
      server.rejectNextToken = true;
      final engine = _engineOver(rig, server);
      await engine.syncNow(manual: true);
      expect(engine.state.lastError, isNull);
      expect(engine.state.hasData, isTrue);
      expect(engine.state.syncing, isFalse);
      engine.dispose();
    });

    test('state that cannot be re-read still ends idle', () async {
      await rig.sync();
      await rig.sell();
      final seen = await flags(rig.engine, () async {
        // The tables disappear under the engine's feet.
        await rig.db.customStatement('ALTER TABLE outbox RENAME TO outbox_gone');
        await rig.sync();
      });
      expect(seen.last, isFalse);
      expect(rig.engine.state.lastError, isNotNull);
    });
  });

  test('an unreadable key store does not leave a request hanging', () async {
    final adapter = FakeAdapter((_) => jsonResponse({'ok': true}));
    final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(AuthInterceptor(_BrokenStorage(), dio: dio));
    final response = await dio
        .get<Object?>('/sync/pull')
        .timeout(const Duration(seconds: 5));
    expect(response.statusCode, 200);
  });
}
