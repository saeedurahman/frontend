import 'package:flutter_test/flutter_test.dart';

import 'sync_rig.dart';

/// 10 000 products on the device: every POS lookup must stay well under the
/// 50 ms target (measured on the in-memory database, median of several runs).
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

  Future<int> medianMs(Future<void> Function() run) async {
    await run(); // warm-up (query plan, JIT)
    final times = <int>[];
    for (var i = 0; i < 7; i++) {
      final watch = Stopwatch()..start();
      await run();
      times.add(watch.elapsedMilliseconds);
    }
    times.sort();
    final median = times[times.length ~/ 2];
    // ignore: avoid_print
    print('  median over 7 runs: $median ms (10 001 products)');
    return median;
  }

  test('the data is really there', () async {
    expect((await rig.catalog.products(limit: 1)).total, 10001);
  });

  test('search by name < 50 ms', () async {
    final ms = await medianMs(() async {
      final r = await rig.catalog.products(search: 'number 4321 ');
      expect(r.items, isNotEmpty);
    });
    expect(ms, lessThan(50), reason: 'took $ms ms');
  });

  test('search by sku < 50 ms', () async {
    final ms = await medianMs(() async {
      final r = await rig.catalog.products(search: 'sku9876');
      expect(r.items, isNotEmpty);
    });
    expect(ms, lessThan(50), reason: 'took $ms ms');
  });

  test('search by partial barcode < 50 ms', () async {
    final ms = await medianMs(() async {
      final r = await rig.catalog.products(search: '890000000555');
      expect(r.items, isNotEmpty);
    });
    expect(ms, lessThan(50), reason: 'took $ms ms');
  });

  test('exact barcode scan (full product) < 50 ms', () async {
    final ms = await medianMs(() async {
      final p = await rig.catalog.productByBarcode('89${'7777'.padLeft(11, '0')}');
      expect(p?.id, 'bulk-7777');
    });
    expect(ms, lessThan(50), reason: 'took $ms ms');
  });

  test('category filter + first page < 50 ms', () async {
    final ms = await medianMs(() async {
      final r = await rig.catalog.products(categoryId: 'cat-7', limit: 60);
      expect(r.items, hasLength(60));
      expect(r.total, 500);
    });
    expect(ms, lessThan(50), reason: 'took $ms ms');
  });

  test('unfiltered first page of the grid < 50 ms', () async {
    final ms = await medianMs(() async {
      final r = await rig.catalog.products(limit: 60);
      expect(r.items, hasLength(60));
    });
    expect(ms, lessThan(50), reason: 'took $ms ms');
  });
}
