import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'sync_rig.dart';

/// 10 000 products on the device: every POS lookup must stay quick.
///
/// A loaded machine slows everything down, so no single run and no tight
/// number decides. Each lookup is the median of several runs, taken in turn
/// with a **baseline** (read and decode every product, what a lookup must never
/// need): the limit is [_budgetMs] or the baseline, whichever is larger, and
/// the indexed lookups must also beat the baseline.
const _runs = 9;
const double _budgetMs = 250;

void main() {
  late SyncRig rig;

  setUpAll(() async {
    rig = SyncRig();
    rig.seedServer();
    await rig.sync();
    await rig.store.transaction(() async {
      for (var i = 0; i < 10000; i++) {
        final id = 'bulk-$i';
        await rig.store.putEntity('product', id, {
          'id': id,
          'name': 'Product number $i ${i.isEven ? 'rice' : 'sugar'}',
          'sku': 'SKU$i',
          'category_id': 'cat-${i % 20}',
          'is_active': true,
          'is_sellable': true,
          'product_type': 'standard',
          'tracking_type': 'none',
        });
        await rig.store.putEntity('barcode', 'bc-$i', {
          'id': 'bc-$i',
          'product_id': id,
          'barcode': '89${i.toString().padLeft(11, '0')}',
        });
      }
    });
  });

  tearDownAll(() => rig.dispose());

  Future<int> timeUs(Future<void> Function() run) async {
    final watch = Stopwatch()..start();
    await run();
    return watch.elapsedMicroseconds;
  }

  int median(List<int> times) => (times..sort())[times.length ~/ 2];

  /// [run]'s median against the baseline measured alongside it.
  Future<void> expectFast(
    Future<void> Function() run, {
    bool beatsBaseline = false,
  }) async {
    Future<void> readEverything() async {
      expect((await rig.store.entities('product')).length, 10001);
    }

    await run(); // warm-up (query plan, JIT)
    await readEverything();
    final lookups = <int>[];
    final baselines = <int>[];
    for (var i = 0; i < _runs; i++) {
      lookups.add(await timeUs(run));
      baselines.add(await timeUs(readEverything));
    }
    final took = median(lookups) / 1000;
    final baseline = median(baselines) / 1000;
    final summary = 'median over $_runs runs: ${took.toStringAsFixed(1)} ms '
        '(reading all 10 001 products: ${baseline.toStringAsFixed(1)} ms)';
    // ignore: avoid_print
    print('  $summary');
    expect(took, lessThan(max(_budgetMs, baseline)), reason: summary);
    if (beatsBaseline) expect(took, lessThan(baseline), reason: summary);
  }

  test('the data is really there', () async {
    expect((await rig.catalog.products(limit: 1)).total, 10001);
  });

  test('search by name is quick', () async {
    await expectFast(() async {
      final r = await rig.catalog.products(search: 'number 4321 ');
      expect(r.items, isNotEmpty);
    });
  });

  test('search by sku is quick', () async {
    await expectFast(() async {
      final r = await rig.catalog.products(search: 'sku9876');
      expect(r.items, isNotEmpty);
    });
  });

  test('search by partial barcode is quick', () async {
    await expectFast(() async {
      final r = await rig.catalog.products(search: '890000000555');
      expect(r.items, isNotEmpty);
    });
  });

  test('exact barcode scan (full product) is quick', () async {
    await expectFast(beatsBaseline: true, () async {
      final p = await rig.catalog.productByBarcode('89${'7777'.padLeft(11, '0')}');
      expect(p?.id, 'bulk-7777');
    });
  });

  test('category filter + first page is quick', () async {
    await expectFast(() async {
      final r = await rig.catalog.products(categoryId: 'cat-7', limit: 60);
      expect(r.items, hasLength(60));
      expect(r.total, 500);
    });
  });

  test('unfiltered first page of the grid is quick', () async {
    await expectFast(beatsBaseline: true, () async {
      final r = await rig.catalog.products(limit: 60);
      expect(r.items, hasLength(60));
    });
  });
}
