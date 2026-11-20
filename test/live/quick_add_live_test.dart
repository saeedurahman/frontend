// Quick Add by Scan against a REAL backend (see live_backend.dart for how to
// start it on the TEST database).
//
// One throw-away business, the real QuickAddRepositoryImpl + remote datasource
// + cubit, a real (in-memory) local catalog. 100 generated lines are scanned and
// saved in opening-stock mode, 100 more in purchase mode against a supplier, and
// the server (stock, price list, supplier ledger, products list) is checked.
import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/quick_add/data/quick_add_remote_datasource.dart';
import 'package:frantend/features/quick_add/data/quick_add_repository_impl.dart';
import 'package:frantend/features/quick_add/data/shared_prefs_draft_store.dart';
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';

import '../quick_add/quick_add_fakes.dart' show barcodeN, dec, SeqIds;
import 'live_backend.dart';
import 'products_rig.dart';

class _Probe extends Fake implements ConnectivityProbe {
  @override
  bool get isReachable => true;

  @override
  Stream<ReachabilityStatus> get status => const Stream.empty();
}

class _Uuid extends IdGenerator {
  final _inner = SeqIds();
  final _run = DateTime.now().microsecondsSinceEpoch;

  @override
  String newId() => 'live-$_run-${_inner.newId()}';
}

void main() {
  if (liveSkip != false) {
    test('live quick add tests', () {}, skip: liveSkip);
    return;
  }

  const lines = 100;
  late LiveTenant tenant;
  late ProductsRig products;
  late QuickAddRepositoryImpl repo;
  late String supplierId;
  var syncs = 0;
  final runStamp = DateTime.now().millisecondsSinceEpoch % 100000;

  /// 12-digit stem unique to this run and batch; barcodeN-style valid EAN-13.
  String code(int batch, int n) =>
      barcodeN(batch * 1000 + n).replaceRange(3, 4, '${runStamp % 10}');

  double sumStock(List<dynamic> balances, Set<String> productIds) => balances
      .cast<Map>()
      .where((b) => productIds.contains(b['product_id']))
      .fold<double>(0, (s, b) => s + double.parse('${b['current_qty']}'));

  setUpAll(() async {
    tenant = await LiveTenant.register(liveApiBase()!, label: 'Sehat QuickAdd');
    products = ProductsRig(tenant);
    supplierId = (await tenant.post('/suppliers', {
      'name': 'Al Shifa Distributors',
      'phone': '3001234567',
      'payment_terms_days': 15,
    }))['id'] as String;

    // What the app would already have pulled: the unit and the price lists.
    await products.catalog.rememberUnit(const UnitModel(
      id: '',
      name: 'Piece',
      symbol: 'pc',
      isBaseUnit: true,
    ).copyWith(id: tenant.unitId));
    for (final l in await tenant.getList('/prices/lists')) {
      await products.catalog.rememberPriceList(Map<String, dynamic>.from(l as Map));
    }

    repo = QuickAddRepositoryImpl(
      remote: QuickAddRemoteDataSource(tenant.client),
      catalog: products.catalog,
      probe: _Probe(),
      errorHandler: const ErrorHandler(),
      branchId: () => tenant.branchId,
      syncNow: () async => syncs++,
      suppliers: () async {
        final list = await tenant.getList('/suppliers');
        return [
          for (final s in list.cast<Map>()) PickOption('${s['id']}', '${s['name']}'),
        ];
      },
    );
  });

  tearDownAll(() async {
    await products.dispose();
  });

  /// Scans [count] distinct codes of [batch], types name/cost/price into each
  /// new row like a cashier would, and rescans the first [rescans] codes once.
  Future<QuickAddCubit> fill(
    int batch,
    int count, {
    required QuickAddMode mode,
    int rescans = 10,
    String? supplier,
  }) async {
    final cubit = QuickAddCubit(
      repository: repo,
      draftStore: MemoryQuickAddDraftStore(),
      ids: _Uuid(),
      draftDebounce: const Duration(days: 1),
    );
    await cubit.start();
    if (mode == QuickAddMode.purchase) {
      cubit.setMode(mode);
      cubit.setSupplier(supplier, 'Al Shifa Distributors');
    }
    for (var n = 0; n < count; n++) {
      await cubit.scan(code(batch, n));
      final row = cubit.state.rows.first;
      cubit
        ..setText(row.id, QuickAddField.name, 'Live item b$batch #$n')
        ..setText(row.id, QuickAddField.qty, '${2 + n % 5}')
        ..setText(row.id, QuickAddField.cost, '${10 + n}')
        ..setText(row.id, QuickAddField.salePrice, '${20 + 2 * n}');
    }
    for (var n = 0; n < rescans; n++) {
      await cubit.scan(code(batch, n)); // +1 qty on that row
    }
    return cubit;
  }

  double expectedQty(int n, int rescans) => (2 + n % 5) + (n < rescans ? 1 : 0);

  test('100 lines in opening-stock mode, then 100 in purchase mode, then an idempotent replay',
      () async {
    final total = Stopwatch()..start();

    // ── opening stock ───────────────────────────────────────────────────
    final scanClock = Stopwatch()..start();
    final a = await fill(1, lines, mode: QuickAddMode.openingStock);
    scanClock.stop();
    expect(a.state.itemCount, lines, reason: 'rescans must raise qty, not add rows');
    expect(a.state.rows.every((r) => r.error == null), isTrue);

    final saveA = Stopwatch()..start();
    await a.save();
    saveA.stop();
    final sumA = a.state.summary;
    expect(a.state.banner, isNull, reason: 'save banner: ${a.state.banner}');
    expect(sumA, isNotNull);
    expect(sumA!.created, lines);
    expect(sumA.updated, 0);
    expect(a.state.rows, isEmpty, reason: 'saved rows leave the list');
    expect(syncs, greaterThan(0), reason: 'a pull is asked for after the write');

    // Server: products, stock, prices.
    final listedA = await tenant.get('/products', query: {'limit': 200});
    expect(listedA['total'], lines);
    final byBarcode = <String, String>{}; // barcode -> product id
    for (final p in (listedA['items'] as List).cast<Map>()) {
      expect(p['needs_attention'], isTrue, reason: 'no category / picture yet');
      expect((p['missing'] as List), contains('category'));
      expect((p['missing'] as List), isNot(contains('price')), reason: 'prices were sent');
    }
    final idsA = <String>{};
    for (var n = 0; n < lines; n++) {
      final lookup = await tenant.get('/products/lookup', query: {'barcode': code(1, n)});
      expect(lookup['found'], isTrue, reason: 'barcode ${code(1, n)}');
      final prod = Map<String, dynamic>.from(lookup['product'] as Map);
      byBarcode[code(1, n)] = prod['id'] as String;
      idsA.add(prod['id'] as String);
      expect(double.parse('${prod['sale_price']}'), 20.0 + 2 * n);
      expect(double.parse('${prod['stock_on_hand']}'), expectedQty(n, 10), reason: 'line $n');
    }
    expect(idsA.length, lines);
    var balances = await tenant.getList('/stock/balances', query: {'branch_id': tenant.branchId});
    var expectedTotal = 0.0;
    for (var n = 0; n < lines; n++) {
      expectedTotal += expectedQty(n, 10);
    }
    expect(sumStock(balances, idsA), expectedTotal);

    final lists = await tenant.getList('/prices/lists');
    final retail = Map<String, dynamic>.from(
      lists.cast<Map>().firstWhere((l) => l['is_default'] == true),
    );
    final items = await tenant.get('/prices/lists/${retail['id']}/items', query: {'limit': 200});
    expect(items['total'], lines, reason: 'one price-list item per product');

    // Local catalog was written through at once (no sync needed).
    final localHit = await repo.findLocal(BarcodeNormalizer.normalize(code(1, 0)));
    expect(localHit, isNotNull);
    expect(localHit!.id, byBarcode[code(1, 0)]);
    expect(localHit.salePrice, dec('20'));

    // Products list cubit (real repository): all lines visible, all "need details".
    await products.list.loadProducts();
    final listState = products.list.state;
    expect(listState, isA<ProductsListLoaded>());
    expect((listState as ProductsListLoaded).total, lines);
    products.list.filterNeedsDetails(true);
    await Future<void>.delayed(const Duration(seconds: 2));
    expect((products.list.state as ProductsListLoaded).total, lines);
    products.list.filterNeedsDetails(false);

    // ── purchase mode against a supplier ────────────────────────────────
    final b = await fill(2, lines, mode: QuickAddMode.purchase, supplier: supplierId);
    expect(b.state.supplierId, supplierId);
    final saveB = Stopwatch()..start();
    await b.save();
    saveB.stop();
    expect(b.state.banner, isNull, reason: 'purchase save banner: ${b.state.banner}');
    expect(b.state.summary!.created, lines);

    final idsB = <String>{};
    var costB = 0.0;
    var qtyB = 0.0;
    for (var n = 0; n < lines; n++) {
      final lookup = await tenant.get('/products/lookup', query: {'barcode': code(2, n)});
      expect(lookup['found'], isTrue);
      idsB.add((lookup['product'] as Map)['id'] as String);
      final q = expectedQty(n, 10);
      qtyB += q;
      costB += q * (10 + n);
    }
    expect(idsB.length, lines);
    balances = await tenant.getList('/stock/balances', query: {'branch_id': tenant.branchId});
    expect(sumStock(balances, idsB), qtyB);

    final ledger = await tenant.get('/supplier-ledger/$supplierId/balance');
    expect(double.parse('${ledger['balance']}'), -costB,
        reason: 'the supplier is owed qty x cost of every received line');

    final purchases = await tenant.getList('/purchases/orders');
    expect(purchases.where((p) => (p as Map)['supplier_id'] == supplierId), hasLength(1),
        reason: 'ONE purchase order for the whole save');

    // ── idempotent replay of the same request (same key) ────────────────
    final replayRows = <QuickAddRow>[
      QuickAddRow(
        id: 'replay-1',
        barcode: code(3, 0),
        name: 'Replay item',
        unitId: tenant.unitId,
        unitLabel: 'Piece',
        qty: dec('5'),
        cost: dec('10'),
        salePrice: dec('15'),
      ),
    ];
    final req = QuickAddRequest(
      mode: QuickAddMode.openingStock,
      branchId: tenant.branchId,
      rows: replayRows,
    );
    final first = (await repo.submit(req, idempotencyKey: 'live-key-$runStamp-1'))
        .getOrElse(() => throw StateError('first submit failed'));
    final second = (await repo.submit(req, idempotencyKey: 'live-key-$runStamp-1'))
        .getOrElse(() => throw StateError('replay failed'));
    expect(first.created, 1);
    expect(first.replayed, isFalse);
    expect(second.replayed, isTrue, reason: 'Idempotent-Replay header');
    expect(second.lines.single.productId, first.lines.single.productId);
    balances = await tenant.getList('/stock/balances', query: {'branch_id': tenant.branchId});
    expect(sumStock(balances, {first.lines.single.productId!}), 5.0,
        reason: 'the replay must not book the stock twice');

    // Rescan of a saved barcode in a fresh session sees the product locally and
    // an update (not a duplicate) on save.
    final c = QuickAddCubit(
      repository: repo,
      draftStore: MemoryQuickAddDraftStore(),
      ids: _Uuid(),
      draftDebounce: const Duration(days: 1),
    );
    await c.start();
    await c.scan(code(1, 3));
    expect(c.state.rows.single.isKnown, isTrue);
    expect(c.state.rows.single.productId, byBarcode[code(1, 3)]);
    c.setText(c.state.rows.single.id, QuickAddField.cost, '50');
    await c.save();
    expect(c.state.summary!.updated, 1);
    expect(c.state.summary!.created, 0);
    balances = await tenant.getList('/stock/balances', query: {'branch_id': tenant.branchId});
    expect(sumStock(balances, {byBarcode[code(1, 3)]!}), expectedQty(3, 10) + 1);

    total.stop();
    // ignore: avoid_print
    print('QUICK ADD LIVE TIMINGS: scan+type $lines lines = ${scanClock.elapsedMilliseconds} ms, '
        'save opening stock = ${saveA.elapsedMilliseconds} ms, '
        'save purchase = ${saveB.elapsedMilliseconds} ms, '
        'whole test = ${total.elapsedMilliseconds} ms');

    unawaited(a.close());
    unawaited(b.close());
    unawaited(c.close());
    expect(Decimal.parse('1'), dec('1'));
  }, timeout: const Timeout(Duration(minutes: 5)));
}
