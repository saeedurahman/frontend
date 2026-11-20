// QuickAddRepositoryImpl over the real offline stack (in-memory database) and a
// fake HTTP adapter: write-through into the local catalog, store events, the
// synthetic-barcode hand-over, Idempotency-Key on the wire, failure mapping.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/quick_add/data/quick_add_remote_datasource.dart';
import 'package:frantend/features/quick_add/data/quick_add_repository_impl.dart';
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';

import '../helpers/fake_http.dart';
import 'quick_add_fakes.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Probe extends Fake implements ConnectivityProbe {
  _Probe(this.reachable);
  bool reachable;
  final _c = StreamController<ReachabilityStatus>.broadcast();

  @override
  bool get isReachable => reachable;

  @override
  Stream<ReachabilityStatus> get status => _c.stream;

  void set(bool online) {
    reachable = online;
    _c.add(online ? ReachabilityStatus.online : ReachabilityStatus.offline);
  }
}

void main() {
  late AppDatabase db;
  late SyncStore store;
  late LocalCatalog catalog;
  late _Probe probe;
  late FakeAdapter adapter;
  late QuickAddRepositoryImpl repo;
  late FakeQuickAddRepository unused;
  var syncs = 0;
  FakeHandler handler = (o) => jsonResponse(<String, dynamic>{});

  setUp(() async {
    syncs = 0;
    handler = (o) => jsonResponse(<String, dynamic>{});
    unused = FakeQuickAddRepository();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = SyncStore(db);
    catalog = LocalCatalog(store, businessId: () async => 'b1');
    probe = _Probe(true);
    adapter = FakeAdapter((o) => handler(o));
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
    repo = QuickAddRepositoryImpl(
      remote: QuickAddRemoteDataSource(_Dio(dio)),
      catalog: catalog,
      probe: probe,
      errorHandler: const ErrorHandler(),
      branchId: () => 'branch-1',
      syncNow: () async => syncs++,
    );
    await catalog.rememberPriceList({
      'id': 'pl-default',
      'name': 'Retail',
      'list_type': 'retail',
      'is_default': true,
      'is_active': true,
    });
  });

  tearDown(() async {
    await unused.dispose();
    store.dispose();
    await db.close();
  });

  QuickAddRow newRow({
    String id = 'line-1',
    String barcode = '8900000000012',
    String name = 'Lux Soap',
    String? sale = '92',
    bool update = false,
  }) =>
      QuickAddRow(
        id: id,
        barcode: barcode,
        name: name,
        unitId: 'u-piece',
        unitLabel: 'Piece',
        categoryId: 'c-soap',
        categoryLabel: 'Soap',
        qty: dec('3'),
        cost: dec('80'),
        salePrice: sale == null ? null : dec(sale),
        updatePrice: update,
      );

  QuickAddRequest request(List<QuickAddRow> rows) =>
      QuickAddRequest(mode: QuickAddMode.openingStock, branchId: 'branch-1', rows: rows);

  QuickAddResponse created(List<QuickAddRow> rows) => QuickAddResponse(
        created: rows.length,
        updated: 0,
        failed: 0,
        lines: [
          for (final r in rows)
            QuickAddLineResult(
              clientLineId: r.id,
              outcome: LineOutcome.created,
              productId: 'prod-${r.id}',
              variationId: 'var-${r.id}',
            ),
        ],
      );

  group('write-through and store events', () {
    test('a saved new product is in the local catalog at once, with its price', () async {
      final row = newRow();
      var events = 0;
      final sub = catalog.changes.listen((_) => events++);

      await repo.writeThrough(request([row]), created([row]));
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      final known = await repo.findLocal(BarcodeNormalizer.normalize(row.barcode));
      expect(known, isNotNull);
      expect(known!.id, 'prod-line-1');
      expect(known.name, 'Lux Soap');
      expect(known.variationId, 'var-line-1');
      expect(known.salePrice, dec('92'));
      expect(known.unitLabel, 'Piece');
      expect(known.categoryId, 'c-soap');

      expect(events, greaterThan(0), reason: 'Products list / POS grid / pickers listen to this');
      expect(syncs, 1, reason: 'stock arrives with the pull that follows the save');
    });

    test('the product is on the POS grid list (catalog.products) after the save', () async {
      final rows = [newRow(), newRow(id: 'line-2', barcode: barcodeN(2), name: 'Sunsilk')];
      await repo.writeThrough(request(rows), created(rows));
      final page = await catalog.products(limit: 50);
      expect(page.items.map((p) => p.name), containsAll(['Lux Soap', 'Sunsilk']));
    });

    test('a failed line is not written', () async {
      final ok = newRow();
      final bad = newRow(id: 'line-2', barcode: barcodeN(2), name: 'Bad');
      await repo.writeThrough(
        request([ok, bad]),
        QuickAddResponse(created: 1, updated: 0, failed: 1, lines: [
          ...created([ok]).lines,
          const QuickAddLineResult(
            clientLineId: 'line-2',
            outcome: LineOutcome.failed,
            errorCode: 'invalid_unit',
          ),
        ]),
      );
      expect(await repo.findLocal(BarcodeNormalizer.normalize(barcodeN(2))), isNull);
      expect(await repo.findLocal(BarcodeNormalizer.normalize(ok.barcode)), isNotNull);
    });

    test('a known product whose price was edited gets the new price', () async {
      final row = newRow(sale: '95', update: true);
      const updated = QuickAddResponse(created: 0, updated: 1, failed: 0, lines: [
        QuickAddLineResult(
          clientLineId: 'line-1',
          outcome: LineOutcome.updated,
          productId: 'p-existing',
          variationId: 'v-existing',
        ),
      ]);
      await repo.writeThrough(request([row]), updated);
      expect(await catalog.price('p-existing', variationId: 'v-existing'), dec('95'));
    });

    test('the made-up barcode id is replaced when the pull brings the real one', () async {
      final row = newRow();
      await repo.writeThrough(request([row]), created([row]));
      const pid = 'prod-line-1';

      Future<List<String>> ids() async =>
          [for (final b in await store.entities('barcode', where: 'parent_id = ?', args: [pid])) '${b['id']}'];

      expect(await ids(), ['${LocalCatalog.syntheticBarcodePrefix}$pid:${row.barcode}']);

      // The pull delivers the real row for the same code.
      await store.putEntity('barcode', 'real-barcode-id', {
        'id': 'real-barcode-id',
        'business_id': 'b1',
        'parent_id': pid,
        'product_id': pid,
        'variation_id': 'var-line-1',
        'barcode': row.barcode,
        'barcode_type': 'EAN13',
        'is_primary': true,
      });
      await catalog.dropSyntheticBarcodes([pid]);
      expect(await ids(), ['real-barcode-id']);
      expect(await repo.findLocal(BarcodeNormalizer.normalize(row.barcode)), isNotNull);
    });

    test('a failing sync after the save never throws', () async {
      final failing = QuickAddRepositoryImpl(
        remote: QuickAddRemoteDataSource(_Dio(Dio()..httpClientAdapter = adapter)),
        catalog: catalog,
        probe: probe,
        errorHandler: const ErrorHandler(),
        branchId: () => 'branch-1',
        syncNow: () async => throw StateError('offline'),
      );
      final row = newRow();
      await failing.writeThrough(request([row]), created([row]));
      expect(await failing.findLocal(BarcodeNormalizer.normalize(row.barcode)), isNotNull);
    });
  });

  group('settings and pickers (offline, from the pulled data)', () {
    test('defaults when nothing was pulled', () async {
      final s = await repo.settings();
      expect(s.askCost, isTrue);
      expect(s.askExpiry, isFalse);
      expect(s.defaultMarginPercent, dec('15'));
    });

    test('pulled settings are used, and a change is announced', () async {
      final changes = <bool>[];
      final sub = repo.settingsChanges.listen((s) => changes.add(s.askExpiry));

      // A pull applies its changes in a transaction; the store announces it then.
      await store.transaction(() => store.putEntity('settings', 's1', {
            'id': 's1',
            'business_id': 'b1',
            'app_settings': {
              'quick_add.ask_cost': {'value': false},
              'quick_add.ask_expiry': true,
              'pricing.default_margin_percent': 20,
              'pricing.suggested_price_rounding': 'nearest_5',
              'inventory.require_batch': true,
            },
          }));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final s = await repo.settings();
      expect(s.askCost, isFalse);
      expect(s.askExpiry, isTrue);
      expect(s.defaultMarginPercent, dec('20'));
      expect(s.rounding, 'nearest_5');
      expect(s.requireBatch, isTrue);
      expect(changes, contains(true));
      await sub.cancel();
    });

    test('units and categories come from the local copy; Piece is the default unit', () async {
      for (final u in [('u-kg', 'Kg'), ('u-piece', 'Piece')]) {
        await store.putEntity('unit', u.$1, {
          'id': u.$1,
          'business_id': 'b1',
          'name': u.$2,
          'symbol': u.$2,
          'is_active': true,
        });
      }
      await store.putEntity('category', 'c-food', {
        'id': 'c-food',
        'business_id': 'b1',
        'name': 'Food',
        'is_active': true,
      });
      await store.putEntity('category', 'c-snack', {
        'id': 'c-snack',
        'business_id': 'b1',
        'parent_id': 'c-food',
        'name': 'Snacks',
        'is_active': true,
      });
      final o = await repo.options();
      expect(o.units.map((u) => u.label), containsAll(['Kg', 'Piece']));
      expect(o.defaultUnit?.label, 'Piece');
      expect(o.categories.map((c) => c.label), containsAll(['Food', 'Food › Snacks']));
    });

    test('suppliers are loaded only online and never block when slow', () async {
      final withSuppliers = QuickAddRepositoryImpl(
        remote: QuickAddRemoteDataSource(_Dio(Dio()..httpClientAdapter = adapter)),
        catalog: catalog,
        probe: probe,
        errorHandler: const ErrorHandler(),
        branchId: () => null,
        syncNow: () async {},
        suppliers: () async => const [PickOption('s-1', 'Ali Traders')],
      );
      expect((await withSuppliers.options()).suppliers, hasLength(1));
      probe.set(false);
      expect((await withSuppliers.options()).suppliers, hasLength(1)); // cached
    });
  });

  group('network', () {
    test('save sends the Idempotency-Key and the body, and reads the answer', () async {
      handler = (o) => jsonResponse({
            'created': 1,
            'updated': 0,
            'failed': 0,
            'lines': [
              {'client_line_id': 'line-1', 'status': 'created', 'product_id': 'p1', 'variation_id': 'v1'},
            ],
          });
      final r = await repo.submit(request([newRow()]), idempotencyKey: 'key-123');
      final res = r.getOrElse(() => throw StateError('expected success'));
      expect(res.created, 1);
      expect(res.replayed, isFalse);

      final sent = adapter.requests.single;
      expect(sent.method, 'POST');
      expect(sent.path, endsWith('/products/quick-add'));
      expect(sent.headers['Idempotency-Key'], 'key-123');
      expect(sent.data['mode'], 'opening_stock');
      expect((sent.data['lines'] as List).single['barcode'], '8900000000012');
    });

    test('a replayed answer is flagged', () async {
      handler = (o) => jsonResponse(
            {'created': 1, 'updated': 0, 'failed': 0, 'lines': []},
            headers: {'idempotent-replay': ['true']},
          );
      final r = await repo.submit(request([newRow()]), idempotencyKey: 'k');
      expect(r.getOrElse(() => throw StateError('x')).replayed, isTrue);
    });

    test('HTTP errors become plain failures', () async {
      handler = (o) => jsonResponse({'detail': 'no'}, status: 403);
      var r = await repo.submit(request([newRow()]), idempotencyKey: 'k');
      expect(r.swap().getOrElse(() => throw StateError('x')), isA<PermissionDeniedFailure>());

      handler = (o) => jsonResponse({'detail': 'slow down'}, status: 429, headers: {
            'retry-after': ['30'],
          });
      r = await repo.submit(request([newRow()]), idempotencyKey: 'k');
      expect(r.swap().getOrElse(() => throw StateError('x')), isA<RateLimitFailure>());

      handler = (o) => throw DioException(
            requestOptions: o,
            type: DioExceptionType.connectionError,
          );
      r = await repo.submit(request([newRow()]), idempotencyKey: 'k');
      expect(r.swap().getOrElse(() => throw StateError('x')), isA<NetworkFailure>());
    });

    test('lookup: found product, not found, failure and offline', () async {
      final code = BarcodeNormalizer.normalize('8900000000012');
      handler = (o) => jsonResponse({
            'found': true,
            'product': {'id': 'p9', 'name': 'Found It', 'sale_price': '60.00', 'stock_on_hand': '4'},
          });
      var l = await repo.lookupRemote(code);
      expect(l?.product?.name, 'Found It');
      expect(l?.product?.salePrice, dec('60'));
      expect(adapter.requests.last.queryParameters['barcode'], '8900000000012');

      handler = (o) => jsonResponse({'found': false});
      l = await repo.lookupRemote(code);
      expect(l?.found, isFalse);

      handler = (o) => jsonResponse({'detail': 'boom'}, status: 500);
      expect(await repo.lookupRemote(code), isNull);

      final before = adapter.requests.length;
      probe.set(false);
      expect(await repo.lookupRemote(code), isNull);
      expect(adapter.requests.length, before, reason: 'offline: no request at all');
    });

    test('online status follows the probe', () async {
      expect(repo.isOnline, isTrue);
      final seen = <bool>[];
      final sub = repo.onlineChanges.listen(seen.add);
      probe.set(false);
      probe.set(true);
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(seen, [false, true]);
      expect(repo.isOnline, isTrue);
    });
  });
}
