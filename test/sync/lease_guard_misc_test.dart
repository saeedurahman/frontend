import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/core/sync/http_sync_api.dart';
import 'package:frantend/core/sync/lease_service.dart';
import 'package:frantend/core/sync/outbox_pending_work_guard.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/usecases/logout_usecase.dart';

import '../helpers/fake_http.dart';
import 'sync_rig.dart';

String _b64u(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

String _iso(DateTime t) => t.toUtc().toIso8601String().replaceFirst('.000Z', 'Z');

class _Repo extends Fake implements AuthRepository {
  int logouts = 0;
  @override
  Future<Either<Failure, void>> logout() async {
    logouts++;
    return const Right(null);
  }
}

void main() {
  // ── lease ───────────────────────────────────────────────────────────────
  group('subscription lease (Ed25519)', () {
    final keys = ed.generateKey();
    final publicKey = _b64u(keys.publicKey.bytes);
    final t0 = DateTime.utc(2026, 10, 29, 8);

    Map<String, dynamic> lease({
      String business = kBusiness,
      DateTime? validUntil,
      DateTime? serverTime,
      ed.PrivateKey? signWith,
    }) {
      final doc = {
        'v': 1,
        'business_id': business,
        'valid_until': _iso(validUntil ?? t0.add(const Duration(days: 7))),
        'server_time': _iso(serverTime ?? t0),
      };
      final sorted = Map.fromEntries(doc.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      final sig = ed.sign(
        signWith ?? keys.privateKey,
        utf8.encode(jsonEncode(sorted)),
      );
      return {...doc, 'signature': _b64u(sig)};
    }

    late SyncRig rig;
    late DateTime now;
    late LeaseService service;

    setUp(() {
      rig = SyncRig(start: t0);
      now = t0;
      service = LeaseService(
        store: rig.store,
        publicKey: publicKey,
        graceDays: 3,
        clock: () => now,
        businessId: () async => kBusiness,
      );
    });

    tearDown(() => rig.dispose());

    test('canonical JSON matches the server (sorted keys, no whitespace)', () {
      expect(
        LeaseVerifier.canonicalJson({'b': 1, 'a': 'x'}),
        '{"a":"x","b":1}',
      );
    });

    test('a genuine lease verifies and is valid until valid_until', () async {
      expect(await service.ingest(lease()), isTrue);
      expect((await service.evaluate()).state, LeaseState.valid);
      now = t0.add(const Duration(days: 6, hours: 23));
      expect((await service.evaluate()).state, LeaseState.valid);
    });

    test('a tampered lease is refused and the previous one is kept', () async {
      await service.ingest(lease());
      final bad = lease()..['valid_until'] = _iso(t0.add(const Duration(days: 400)));
      expect(await service.ingest(bad), isFalse);
      now = t0.add(const Duration(days: 8));
      expect((await service.evaluate()).state, LeaseState.grace);
    });

    test('a lease signed with another key or for another business is refused',
        () async {
      final other = ed.generateKey();
      expect(await service.ingest(lease(signWith: other.privateKey)), isFalse);
      expect(await service.ingest(lease(business: 'someone-else')), isFalse);
      expect((await service.evaluate()).state, LeaseState.none);
    });

    test('malformed leases never throw', () async {
      expect(await service.ingest(null), isFalse);
      expect(await service.ingest('nope'), isFalse);
      expect(await service.ingest({'v': 1}), isFalse);
      expect(await service.ingest({...lease(), 'extra': 1}), isFalse);
    });

    test('after expiry: warning for GRACE_DAYS, then the app is blocked',
        () async {
      await service.ingest(lease());

      now = t0.add(const Duration(days: 7, minutes: 1));
      var v = await service.evaluate();
      expect(v.state, LeaseState.grace);
      expect(v.warns, isTrue);
      expect(v.blocksApp, isFalse, reason: 'POS keeps working in grace');
      expect(v.graceLeft(now)!.inDays, 2);

      now = t0.add(const Duration(days: 9, hours: 23));
      expect((await service.evaluate()).state, LeaseState.grace);

      now = t0.add(const Duration(days: 10, minutes: 1));
      v = await service.evaluate();
      expect(v.state, LeaseState.lapsed);
      expect(v.blocksApp, isTrue);
    });

    test('a device clock set back before the lease was issued is rolled back',
        () async {
      await service.ingest(lease());
      now = t0.subtract(const Duration(hours: 1));
      final v = await service.evaluate();
      expect(v.state, LeaseState.clockRolledBack);
      expect(v.blocksApp, isTrue);
    });

    test('small clock skew (< 5 minutes) is tolerated', () async {
      await service.ingest(lease());
      now = t0.subtract(const Duration(minutes: 4));
      expect((await service.evaluate()).state, LeaseState.valid);
    });

    test('monotonic guard: going back after a later reading is rejected',
        () async {
      await service.ingest(lease());
      now = t0.add(const Duration(days: 3));
      expect((await service.evaluate()).state, LeaseState.valid);

      // Clock rolled back to day 1: before "last seen" but after server_time.
      now = t0.add(const Duration(days: 1));
      expect((await service.evaluate()).state, LeaseState.clockRolledBack);
    });

    test('a fresh online lease resets the monotonic reference', () async {
      await service.ingest(lease());
      now = t0.add(const Duration(days: 3));
      await service.evaluate();

      // Server time now = day 3: the signed lease is the reference again.
      final fresh = lease(
        serverTime: t0.add(const Duration(days: 3)),
        validUntil: t0.add(const Duration(days: 10)),
      );
      expect(await service.ingest(fresh), isTrue);
      expect((await service.evaluate()).state, LeaseState.valid);
    });

    test('without a configured key nothing is enforced', () async {
      final off = LeaseService(store: rig.store, publicKey: '', clock: () => now);
      expect(off.enforced, isFalse);
      expect(await off.ingest(lease()), isFalse);
      final v = await off.evaluate();
      expect(v.state, LeaseState.notRequired);
      expect(v.blocksApp, isFalse);
    });

    test('verdicts are broadcast for the UI', () async {
      final seen = <LeaseState>[];
      final sub = service.verdicts.listen((v) => seen.add(v.state));
      await service.ingest(lease());
      now = t0.add(const Duration(days: 8));
      await service.evaluate();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(seen, [LeaseState.valid, LeaseState.grace]);
    });
  });

  // ── pending work guard ──────────────────────────────────────────────────
  group('PendingWorkGuard', () {
    late SyncRig rig;
    setUp(() async {
      rig = SyncRig();
      rig.seedServer();
      await rig.sync();
    });
    tearDown(() => rig.dispose());

    test('counts pending + failed outbox items and parked orders', () async {
      var held = 2;
      final guard = OutboxPendingWorkGuard(rig.store, heldOrders: () async => held);
      expect(await guard.summary(), const PendingWorkSummary(held: 2));

      rig.server.errors['customer.create'] =
          const OpError(code: 'permission_denied', message: 'no');
      await rig.writer.createCustomer({'name': 'A'});
      await rig.sync(); // rejected
      rig.server.offline = true;
      await rig.sell();
      await rig.sync();

      final summary = await guard.summary();
      expect(summary, const PendingWorkSummary(unsynced: 1, failed: 1, held: 2));
      expect(summary.total, 4);
      held = 0;
      expect((await guard.summary()).total, 2);
    });

    test('an applied op no longer counts', () async {
      final guard = OutboxPendingWorkGuard(rig.store);
      await rig.sell();
      expect((await guard.summary()).unsynced, 1);
      await rig.sync();
      expect((await guard.summary()).total, 0);
    });

    test('logout is blocked with the breakdown; nothing is wiped', () async {
      rig.server.offline = true;
      await rig.sell();
      final repo = _Repo();
      final guard = OutboxPendingWorkGuard(rig.store, heldOrders: () async => 1);

      final result = await LogoutUseCase(repo, guard)();

      final failure = result.fold((f) => f, (_) => null) as PendingWorkFailure;
      expect(failure.unsynced, 1);
      expect(failure.held, 1);
      expect(failure.pendingCount, 2);
      expect(repo.logouts, 0);
      expect((await rig.store.sales()), hasLength(1));
    });

    test('the owner can force it', () async {
      rig.server.offline = true;
      await rig.sell();
      final repo = _Repo();
      final result = await LogoutUseCase(repo, OutboxPendingWorkGuard(rig.store))(force: true);
      expect(result.isRight(), isTrue);
      expect(repo.logouts, 1);
    });

    test('logout proceeds once everything is synced', () async {
      await rig.sell();
      await rig.sync();
      final repo = _Repo();
      final result = await LogoutUseCase(repo, OutboxPendingWorkGuard(rig.store))();
      expect(result.isRight(), isTrue);
    });

    test('tenant switch with unsent work is refused, not wiped', () async {
      final keys = InMemorySecureKeyStore();
      final lifecycle = LocalDataLifecycle(
        database: rig.db,
        offlineCredentials: OfflineCredentialVerifier(
          store: keys,
          hasher: Pbkdf2CredentialHasher(iterations: 10),
        ),
        secureStore: keys,
        pendingWork: OutboxPendingWorkGuard(rig.store),
      );
      await lifecycle.onTenantSignedIn('tenant-1');
      rig.server.offline = true;
      await rig.sell();

      await expectLater(
        lifecycle.onTenantSignedIn('tenant-2'),
        throwsA(isA<PendingWorkException>()),
      );
      expect(await rig.store.sales(), hasLength(1));
      expect(keys.values[LocalDataLifecycle.lastTenantKey], 'tenant-1');
    });

    test('with nothing pending a tenant switch wipes every table', () async {
      final keys = InMemorySecureKeyStore();
      final lifecycle = LocalDataLifecycle(
        database: rig.db,
        offlineCredentials: OfflineCredentialVerifier(
          store: keys,
          hasher: Pbkdf2CredentialHasher(iterations: 10),
        ),
        secureStore: keys,
        pendingWork: OutboxPendingWorkGuard(rig.store),
      );
      await lifecycle.onTenantSignedIn('tenant-1');
      expect(await lifecycle.onTenantSignedIn('tenant-2'), isTrue);
      expect((await rig.catalog.products()).total, 0);
      expect(await rig.store.hasSnapshot, isFalse);
      expect(await rig.store.meta(SyncStore.cursorKey), isNull);
    });

    test('wipe clears sales, shifts, outbox, stock and entities', () async {
      await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.zero);
      await rig.sell();
      await rig.db.wipeTenantData();
      for (final table in [
        'entities', 'stock_levels', 'outbox', 'local_sales', 'local_shifts', 'deferred_changes',
      ]) {
        final n = await rig.db.customSelect('SELECT COUNT(*) AS n FROM $table').getSingle();
        expect(n.read<int>('n'), 0, reason: table);
      }
    });
  });

  // ── HTTP transport ──────────────────────────────────────────────────────
  group('HttpSyncApi', () {
    HttpSyncApi api(FakeAdapter adapter) {
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
      return HttpSyncApi(
        dio: dio,
        deviceId: () async => 'dev-1',
        deviceName: () async => 'Front till',
        appVersion: '9.9',
      );
    }

    test('pull sends since, limit and device_id', () async {
      final adapter = FakeAdapter((o) => jsonResponse({
            'changes': [
              {'entity': 'product', 'id': 'p1', 'op': 'upsert', 'seq': 5, 'data': {'name': 'A'}},
              {'entity': 'product', 'id': 'p2', 'op': 'delete', 'seq': 6, 'data': null},
            ],
            'next_cursor': 'c6',
            'has_more': true,
            'server_time': '2026-10-29T08:21:00Z',
            'permissions_version': 'pv',
            'entities': ['product'],
          }));
      final page = await api(adapter).pull(since: 'c4', limit: 100);
      final q = adapter.requests.single.queryParameters;
      expect(q['since'], 'c4');
      expect(q['limit'], 100);
      expect(q['device_id'], 'dev-1');
      expect(adapter.requests.single.path, '/sync/pull');
      expect(page.hasMore, isTrue);
      expect(page.changes.last.isDelete, isTrue);
      expect(page.nextCursor, 'c6');
    });

    test('snapshot passes the page token and device id', () async {
      final adapter = FakeAdapter((o) => jsonResponse({
            'changes': <dynamic>[],
            'next_page_token': null,
            'has_more': false,
            'cursor': 'c1',
            'permissions_version': 'pv',
            'entities': <dynamic>[],
          }));
      final page = await api(adapter).snapshot(pageToken: 'tok');
      expect(adapter.requests.single.queryParameters['page_token'], 'tok');
      expect(adapter.requests.single.queryParameters['device_id'], 'dev-1');
      expect(page.cursor, 'c1');
    });

    test('push body follows the README (device, batch, app version, ops)', () async {
      final adapter = FakeAdapter((o) => jsonResponse({
            'batch_id': 'b1',
            'server_time': '2026-10-29T08:30:00Z',
            'results': [
              {
                'op_id': 'o1', 'status': 'applied', 'server_id': 's1',
                'official_number': 'INV-1', 'flags': ['oversold'], 'error': null,
                'original_status': null,
              },
              {
                'op_id': 'o2', 'status': 'rejected',
                'error': {'code': 'unknown_product', 'message': 'm', 'retryable': false},
              },
            ],
          }));
      final res = await api(adapter).push(batchId: 'b1', ops: [
        {'op_id': 'o1', 'type': 'sale.create', 'payload': <String, dynamic>{}},
      ]);
      final body = adapter.requests.single.data as Map;
      expect(body['device_id'], 'dev-1');
      expect(body['batch_id'], 'b1');
      expect(body['device_name'], 'Front till');
      expect(body['app_version'], '9.9');
      expect((body['ops'] as List).single['type'], 'sale.create');
      expect(res.results.first.flags, ['oversold']);
      expect(res.results.first.officialNumber, 'INV-1');
      expect(res.results.last.error!.code, 'unknown_product');
      expect(adapter.requests.single.extra['no_retry'], isTrue);
    });

    Future<Object?> failWith(int status, Object body, {Map<String, List<String>>? headers}) async {
      final adapter = FakeAdapter((o) => jsonResponse(body, status: status, headers: headers ?? {}));
      try {
        await api(adapter).pull();
      } catch (e) {
        return e;
      }
      return null;
    }

    test('whole-request errors are typed', () async {
      expect(
        await failWith(403, {'detail': {'code': 'device_revoked', 'message': 'gone'}}),
        isA<DeviceRevokedException>(),
      );
      expect(
        await failWith(413, {'detail': {'code': 'batch_too_large', 'message': 'big'}}),
        isA<BatchTooLargeException>(),
      );
      expect(
        await failWith(400, {'detail': {'code': 'invalid_cursor', 'message': 'bad'}}),
        isA<InvalidCursorException>(),
      );
      expect(await failWith(503, {'detail': 'down'}), isA<SyncServerException>());
    });

    test('429 carries Retry-After', () async {
      final e = await failWith(429, {'detail': 'slow'}, headers: {
        'retry-after': ['17'],
      });
      expect((e as RateLimitedException).retryAfter, const Duration(seconds: 17));
    });

    test('no connection is "unreachable", not a server error', () async {
      final adapter = FakeAdapter(
        (o) => throw DioException(requestOptions: o, type: DioExceptionType.connectionError),
      );
      await expectLater(api(adapter).pull(), throwsA(isA<SyncUnreachableException>()));
    });

    test('flags parses the review list', () async {
      final adapter = FakeAdapter((o) => jsonResponse({
            'total': 1, 'skip': 0, 'limit': 50,
            'items': [
              {
                'id': 's1', 'sale_number': 'INV-1', 'client_receipt_no': 'D1-0001',
                'flags': ['oversold', 'price_mismatch'], 'total_amount': '210.00',
                'cashier_name': 'Ali', 'sold_at': '2026-10-29T08:00:00Z', 'status': 'completed',
              },
            ],
          }));
      final flags = await api(adapter).flags(flag: 'oversold');
      expect(adapter.requests.single.queryParameters['flag'], 'oversold');
      expect(flags.single.flags, ['oversold', 'price_mismatch']);
      expect(flags.single.clientReceiptNo, 'D1-0001');
    });
  });

  // ── migration ───────────────────────────────────────────────────────────
  group('schema v6 -> v7', () {
    test('adds the offline tables and leaves existing data alone', () async {
      final v6 = NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE held_orders_table (id TEXT PRIMARY KEY, label TEXT, '
            'cart_items_json TEXT, created_at INTEGER)',
          );
          raw.execute("INSERT INTO held_orders_table VALUES ('h1','Order','{}',1)");
          raw.execute('PRAGMA user_version = 6');
        },
      );
      final db = AppDatabase.forTesting(v6);
      addTearDown(db.close);

      final tables = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .get();
      final names = tables.map((r) => r.read<String>('name')).toSet();
      expect(names, containsAll([
        'entities', 'stock_levels', 'outbox', 'local_sales', 'local_shifts',
        'sync_meta', 'deferred_changes',
      ]));
      final held = await db.customSelect('SELECT id FROM held_orders_table').get();
      expect(held.single.read<String>('id'), 'h1');
      expect(db.schemaVersion, 7);
    });

    test('a fresh install gets everything too', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final store = SyncStore(db);
      expect(await store.hasSnapshot, isFalse);
      expect((await store.counts()).unfinished, 0);
      expect(await store.nextReceiptNumber(), 1);
    });

    test('the DDL is idempotent', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();
      // Running the migration step again must not fail or drop data.
      final store = SyncStore(db);
      await store.setMeta('k', 'v');
      for (final stmt in const ['SELECT 1']) {
        await db.customStatement(stmt);
      }
      expect(await store.meta('k'), 'v');
    });
  });
}

