import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/inventory/data/batch_stock_source.dart';
import 'package:frantend/features/inventory/domain/batch_picker.dart';
import 'package:frantend/features/inventory/presentation/widgets/batch_chip.dart';

import '../sync/sync_rig.dart';

Decimal d(String v) => Decimal.parse(v);

Map<String, dynamic> withBatches(Map<String, dynamic> body, List<Map<String, dynamic>> batches) => {
      ...body,
      'lines': [
        for (final l in body['lines'] as List) {...Map<String, dynamic>.from(l as Map), 'batches': batches},
      ],
    };

void main() {
  late SyncRig rig;
  late BatchStockSource source;

  void putBatch(String id, String batchNo, String expiry, String qty, String received) {
    rig.server.put('stock_batch', id, {
      'id': id,
      'product_id': 'p1',
      'branch_id': kBranch,
      'batch_no': batchNo,
      'expiry_date': expiry,
      'qty_remaining': qty,
      'received_at': received,
    });
  }

  setUp(() async {
    rig = SyncRig();
    rig.seedServer(stock: 20);
    putBatch('sb1', 'A', '2027-12-31', '5', '2026-01-01T00:00:00Z');
    putBatch('sb2', 'B', '2027-01-31', '5', '2026-02-01T00:00:00Z');
    putBatch('sb3', 'C', '2027-06-30', '5', '2026-03-01T00:00:00Z');
    await rig.sync();
    source = BatchStockSource(rig.store, clock: () => DateTime(2026, 11, 17));
  });

  tearDown(() => rig.dispose());

  test('stock_batch rows are pulled into the entities table', () async {
    final batches = await source.batches(kBranch, 'p1');
    expect(batches.map((b) => b.batchNo).toSet(), {'A', 'B', 'C'});
    expect(batches.fold(Decimal.zero, (s, b) => s + b.qty), d('15'));
  });

  test('the policy defaults to FIFO / warn when no setting was pulled', () async {
    final p = await source.policy();
    expect(p.pickPolicy, 'fifo');
    expect(p.expiredSale, 'warn');
  });

  test('the policy follows the pulled settings', () async {
    rig.server.put('settings', 'biz', {
      'business_name': 'Demo',
      'app_settings': {'inventory.pick_policy': 'fefo', 'inventory.expired_sale': 'block'},
    });
    await rig.sync();
    final p = await source.policy();
    expect(p.isFefo, isTrue);
    expect(p.blocksExpired, isTrue);
  });

  test('a product without batch rows has no plan (the server picks as usual)', () async {
    final plan = await source.plan(kBranch, 'p-none', qty: d('1'));
    expect(plan, isNull);
  });

  group('pending local sales are subtracted', () {
    Future<Map<String, Object?>> sellFromBatch(String batchNo, String expiry, String qty) {
      return rig.writer.saveSale(withBatches(rig.cartBody(qty: qty), [
        {'batch_no': batchNo, 'expiry_date': expiry, 'qty': qty},
      ]));
    }

    test('a second sale does not pick stock the first one already took', () async {
      const fifo = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'warn');
      final first = await source.plan(kBranch, 'p1', qty: d('4'), policy: fifo);
      expect(first!.slices.single.batchNo, 'A');
      expect(first.slices.single.qty, d('4'));

      await sellFromBatch('A', '2027-12-31', '4');

      final second = await source.plan(kBranch, 'p1', qty: d('4'), policy: fifo);
      expect([for (final s in second!.slices) '${s.batchNo}:${s.qty}'], ['A:1', 'B:3']);
    });

    test('a batch used up by pending sales disappears', () async {
      await sellFromBatch('A', '2027-12-31', '5');
      final batches = await source.batches(kBranch, 'p1');
      expect(batches.map((b) => b.batchNo), isNot(contains('A')));
    });
  });

  group('sale.create payload', () {
    test('the picked batches travel with the line to the server', () async {
      await rig.writer.saveSale(withBatches(rig.cartBody(qty: '7'), [
        {'batch_no': 'A', 'expiry_date': '2027-12-31', 'qty': '5'},
        {'batch_no': 'B', 'expiry_date': '2027-01-31', 'qty': '2'},
      ]));
      await rig.sync();

      final op = rig.server.receivedOps.firstWhere((o) => o['type'] == 'sale.create');
      final lines = (op['payload'] as Map)['lines'] as List;
      expect((lines.single as Map)['batches'], [
        {'batch_no': 'A', 'expiry_date': '2027-12-31', 'qty': '5'},
        {'batch_no': 'B', 'expiry_date': '2027-01-31', 'qty': '2'},
      ]);
    });

    test('a line without batches sends none', () async {
      await rig.writer.saveSale(rig.cartBody());
      await rig.sync();
      final op = rig.server.receivedOps.firstWhere((o) => o['type'] == 'sale.create');
      final line = ((op['payload'] as Map)['lines'] as List).single as Map;
      expect(line.containsKey('batches'), isFalse);
    });
  });

  group('BatchChip', () {
    Future<void> show(WidgetTester t, BatchSlice slice, {int near = 30}) => t.pumpWidget(
          MaterialApp(
            home: Scaffold(body: BatchChip(slice: slice, nearDays: near)),
          ),
        );

    testWidgets('shows the batch number and expiry', (t) async {
      await show(t, BatchSlice(batchNo: 'B77', expiry: '2027-05-31', qty: d('2'), daysLeft: 200));
      expect(find.byKey(const Key('batch-chip-B77')), findsOneWidget);
      expect(find.textContaining('B77'), findsOneWidget);
    });

    testWidgets('near expiry and expired get a different colour than a safe batch', (t) async {
      Color? bg(WidgetTester t) {
        final c = t.widget<Container>(find.byKey(const Key('batch-chip-X')));
        return (c.decoration as BoxDecoration?)?.color;
      }

      await show(t, BatchSlice(batchNo: 'X', expiry: '2027-05-31', qty: d('1'), daysLeft: 200));
      final ok = bg(t);
      await show(t, BatchSlice(batchNo: 'X', expiry: '2026-12-01', qty: d('1'), daysLeft: 14));
      final near = bg(t);
      await show(t, BatchSlice(batchNo: 'X', expiry: '2026-01-01', qty: d('1'), expired: true, daysLeft: -300));
      final expired = bg(t);
      expect({ok, near, expired}, hasLength(3));
    });
  });
}
