import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/shared/widgets/layout/sign_out_flow.dart';
import 'package:decimal/decimal.dart';

import '../helpers/fake_http.dart';

class _GuardCount implements PendingWorkGuard {
  _GuardCount(this.count);
  final int count;
  @override
  Future<int> pendingCount() async => count;
}

class _Repo extends Fake implements AuthRepository {
  int logouts = 0;
  @override
  Future<Either<Failure, void>> logout() async {
    logouts++;
    return const Right(null);
  }
}

void main() {
  late AppDatabase db;
  late InMemorySecureKeyStore keys;
  late OfflineCredentialVerifier verifier;
  late int pinRosterClears;
  late LocalDataLifecycle lifecycle;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    keys = InMemorySecureKeyStore();
    verifier = OfflineCredentialVerifier(
      store: keys,
      hasher: Pbkdf2CredentialHasher(iterations: 10),
    );
    pinRosterClears = 0;
    lifecycle = LocalDataLifecycle(
      database: db,
      offlineCredentials: verifier,
      secureStore: keys,
      clearPinRoster: () async => pinRosterClears++,
    );
  });

  tearDown(() => db.close());

  Future<void> seedTenantData() async {
    await db.into(db.masterDataCacheTable).insert(
          MasterDataCacheTableCompanion.insert(
            cacheKey: 'products',
            jsonData: '[]',
            cachedAt: DateTime.now(),
          ),
        );
    await db.into(db.usersTable).insert(
          UsersTableCompanion.insert(
            id: 'u1',
            email: 'a@b.c',
            name: 'Ali',
            role: 'owner',
            updatedAt: DateTime.now(),
          ),
        );
    await db.heldOrdersDao.saveHeldOrder(
      HeldOrderModel(
        id: 'h1',
        label: 'Order',
        createdAt: DateTime.now(),
        cartItems: [
          CartItemModel(
            productId: 'p',
            productName: 'P',
            unitPrice: Decimal.one,
            qty: Decimal.one,
          ),
        ],
        itemCount: 1,
        totalAmount: Decimal.one,
      ),
      scope: const HeldOrderScope(tenantId: 't', branchId: 'b', userId: 'u'),
    );
    await verifier.enroll(
      kind: OfflineCredentialKind.password,
      tenantKey: 'acme',
      identity: '+92300',
      userId: 'u1',
      secret: 'x',
    );
  }

  Future<int> rows() async =>
      (await db.select(db.masterDataCacheTable).get()).length +
      (await db.select(db.usersTable).get()).length +
      (await db.select(db.heldOrdersTable).get()).length;

  group('local data lifecycle', () {
    test('logout wipes every tenant-scoped table and the verifiers', () async {
      await seedTenantData();
      expect(await rows(), 3);

      await lifecycle.wipeOnLogout();

      expect(await rows(), 0);
      expect(keys.values.containsKey(OfflineCredentialVerifier.storageKey),
          isFalse);
      expect(pinRosterClears, 0, reason: 'PIN roster outlives a plain logout');
    });

    test('device identity is not tenant data and survives a wipe', () async {
      keys.values['device_id'] = 'keep-me';
      await seedTenantData();
      await lifecycle.wipeOnLogout();
      expect(keys.values['device_id'], 'keep-me');
    });

    test('tenant switch also clears the PIN roster', () async {
      await seedTenantData();
      await lifecycle.wipeOnTenantSwitch();
      expect(await rows(), 0);
      expect(pinRosterClears, 1);
    });

    test('first sign-in and re-sign-in to the same business keep data',
        () async {
      await seedTenantData();
      expect(await lifecycle.onTenantSignedIn('t1'), isFalse);
      expect(await lifecycle.onTenantSignedIn('t1'), isFalse);
      expect(await rows(), 3);
    });

    test('signing into a different business wipes the old one', () async {
      await lifecycle.onTenantSignedIn('t1');
      await seedTenantData();
      expect(await lifecycle.onTenantSignedIn('t2'), isTrue);
      expect(await rows(), 0);
      expect(pinRosterClears, 1);
      expect(keys.values[LocalDataLifecycle.lastTenantKey], 't2');
    });

    test('a null/empty tenant id is ignored', () async {
      await seedTenantData();
      expect(await lifecycle.onTenantSignedIn(null), isFalse);
      expect(await lifecycle.onTenantSignedIn(''), isFalse);
      expect(await rows(), 3);
    });

    test('branch switch drops cached reads but keeps parked orders', () async {
      await seedTenantData();
      await lifecycle.wipeOnBranchSwitch();
      expect(await db.select(db.masterDataCacheTable).get(), isEmpty);
      expect(await db.select(db.heldOrdersTable).get(), hasLength(1));
      expect(await db.select(db.usersTable).get(), hasLength(1));
    });
  });

  group('PendingWorkGuard', () {
    test('the shipped stub reports nothing pending', () async {
      expect(await const NoPendingWorkGuard().pendingCount(), 0);
    });

    test('logout is blocked, and changes nothing, while work is pending',
        () async {
      final repo = _Repo();
      final result = await LogoutUseCase(repo, _GuardCount(3))();
      expect(result.fold((f) => f, (_) => null), const PendingWorkFailure(3));
      expect(repo.logouts, 0);
    });

    test('logout proceeds when nothing is pending', () async {
      final repo = _Repo();
      final result = await LogoutUseCase(repo, const NoPendingWorkGuard())();
      expect(result.isRight(), isTrue);
      expect(repo.logouts, 1);
    });

    test('the dialog explains how many changes are at risk', () {
      expect(pendingWorkMessage(4), contains('4 change(s)'));
      expect(pendingWorkMessage(4), contains('sign out again'));
    });
  });

  group('schema v6', () {
    test('only local-by-nature tables remain', () async {
      final names = db.allTables.map((t) => t.actualTableName).toSet();
      expect(names, {
        'master_data_cache_table',
        'held_orders_table',
        'users_table',
      });
      expect(db.schemaVersion, 6);
    });

    test('upgrading from v5 drops the legacy fake-offline tables', () async {
      final legacy = NativeDatabase.memory(
        setup: (raw) {
          for (final t in AppDatabase.legacyTables) {
            raw.execute('CREATE TABLE $t (id TEXT PRIMARY KEY)');
          }
          raw.execute('PRAGMA user_version = 5');
        },
      );
      final upgraded = AppDatabase.forTesting(legacy);
      addTearDown(upgraded.close);

      // Opening runs onUpgrade(5 -> 6).
      await upgraded.customSelect('SELECT 1').get();
      final tables = await upgraded
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .get();
      final names = tables.map((r) => r.read<String>('name')).toSet();
      for (final gone in AppDatabase.legacyTables) {
        expect(names, isNot(contains(gone)));
      }
    });
  });

  group('no code path pretends a mutation succeeded', () {
    test('the fake-offline machinery is gone from lib/', () {
      const banned = [
        'OfflineInterceptor',
        'skip_offline_queue',
        'SyncQueue',
        'SyncManager',
        'SyncWorker',
        'ConflictResolver',
        'PendingSalesDao',
        'pendingSales',
        '_applyOptimisticStock',
        'OFFLINE-',
        'NetworkInfo',
      ];
      final hits = <String>[];
      for (final f in Directory('lib').listSync(recursive: true)) {
        if (f is! File || !f.path.endsWith('.dart')) continue;
        if (f.path.endsWith('.freezed.dart') || f.path.endsWith('.g.dart')) {
          continue;
        }
        final text = f.readAsStringSync();
        for (final word in banned) {
          if (text.contains(word)) hits.add('${f.path}: $word');
        }
      }
      expect(hits, isEmpty);
    });

    Dio unreachableClient(FakeAdapter adapter) {
      final client = DioClient(secureStorage: FakeSecureStorage());
      client.dio.httpClientAdapter = adapter;
      return client.dio;
    }

    test('a POST with no connection throws; it is never answered 202',
        () async {
      final adapter = FakeAdapter(
        (o) => throw DioException(
          requestOptions: o,
          type: DioExceptionType.connectionError,
        ),
      );
      final dio = unreachableClient(adapter);

      await expectLater(
        dio.post<dynamic>('/sales', data: {'id': 's1'}),
        throwsA(
          isA<DioException>()
              .having((e) => e.type, 'type', DioExceptionType.connectionError),
        ),
      );
      expect(adapter.requests, hasLength(1), reason: 'no retry freeze');
    });

    test('POS calls use short timeouts, reports keep the long one', () async {
      final adapter = FakeAdapter((o) => jsonResponse({'ok': true}));
      final dio = unreachableClient(adapter);

      await dio.get<dynamic>('/shifts/my-active');
      await dio.get<dynamic>('/analytics/sales-summary');

      expect(adapter.requests[0].connectTimeout, const Duration(seconds: 5));
      expect(adapter.requests[0].receiveTimeout, const Duration(seconds: 5));
      expect(adapter.requests[1].receiveTimeout, const Duration(seconds: 60));
    });
  });
}
