import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/inventory/domain/batch_picker.dart';

Decimal d(String v) => Decimal.parse(v);

StockBatch batch(String no, String? expiry, String qty, String received) => StockBatch(
      batchNo: no,
      expiry: expiry,
      qty: d(qty),
      receivedAt: DateTime.parse(received),
    );

final today = DateTime(2026, 11, 17);

// Received order: A (oldest) -> B -> C. Expiry order: B -> C -> A.
final stock = [
  batch('A', '2027-12-31', '5', '2026-01-01'),
  batch('B', '2027-01-31', '5', '2026-02-01'),
  batch('C', '2027-06-30', '5', '2026-03-01'),
];

List<String> names(BatchAllocation a) => [for (final s in a.slices) s.batchNo ?? ''];

void main() {
  const fifo = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'warn');
  const fefo = InventoryPolicy(pickPolicy: 'fefo', expiredSale: 'warn');

  group('FIFO vs FEFO', () {
    test('FIFO takes the batch that arrived first', () {
      final a = BatchPicker.allocate(batches: stock, qty: d('3'), policy: fifo, today: today);
      expect(names(a), ['A']);
      expect(a.slices.single.qty, d('3'));
    });

    test('FEFO takes the batch that expires first', () {
      final a = BatchPicker.allocate(batches: stock, qty: d('3'), policy: fefo, today: today);
      expect(names(a), ['B']);
    });

    test('FIFO splits across batches in arrival order', () {
      final a = BatchPicker.allocate(batches: stock, qty: d('12'), policy: fifo, today: today);
      expect(names(a), ['A', 'B', 'C']);
      expect([for (final s in a.slices) s.qty], [d('5'), d('5'), d('2')]);
      expect(a.shortfall, Decimal.zero);
    });

    test('FEFO splits across batches in expiry order', () {
      final a = BatchPicker.allocate(batches: stock, qty: d('12'), policy: fefo, today: today);
      expect(names(a), ['B', 'C', 'A']);
      expect([for (final s in a.slices) s.qty], [d('5'), d('5'), d('2')]);
    });

    test('FEFO puts batches with no expiry last', () {
      final a = BatchPicker.allocate(
        batches: [batch('N', null, '5', '2025-01-01'), ...stock],
        qty: d('16'),
        policy: fefo,
        today: today,
      );
      expect(names(a), ['B', 'C', 'A', 'N']);
    });

    test('asking for more than exists reports the shortfall', () {
      final a = BatchPicker.allocate(batches: stock, qty: d('20'), policy: fifo, today: today);
      expect(a.shortfall, d('5'));
      expect(a.slices.fold(Decimal.zero, (s, x) => s + x.qty), d('15'));
    });

    test('empty batches or a zero quantity give an empty plan', () {
      expect(BatchPicker.allocate(batches: const [], qty: d('1'), policy: fifo, today: today).slices,
          isEmpty);
      expect(BatchPicker.allocate(batches: stock, qty: d('0'), policy: fifo, today: today).slices,
          isEmpty);
    });
  });

  group('expired stock', () {
    final withExpired = [
      batch('OLD', '2026-10-01', '4', '2025-01-01'), // expired
      batch('OK', '2027-03-01', '10', '2026-01-01'),
    ];

    test('block skips expired batches and never sells them', () {
      const block = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'block');
      final a = BatchPicker.allocate(batches: withExpired, qty: d('3'), policy: block, today: today);
      expect(names(a), ['OK']);
      expect(a.usesExpired, isFalse);
      expect(a.skippedExpiredQty, d('4'));
      expect(a.blocked, isFalse);
    });

    test('block says blocked when only expired stock could cover the sale', () {
      const block = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'block');
      final a = BatchPicker.allocate(batches: withExpired, qty: d('12'), policy: block, today: today);
      expect(a.blocked, isTrue);
      expect(a.shortfall, d('2'));
    });

    test('block is not triggered when untracked stock covers the rest', () {
      const block = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'block');
      final a = BatchPicker.allocate(
        batches: withExpired,
        qty: d('12'),
        policy: block,
        today: today,
        untracked: d('5'),
      );
      expect(a.blocked, isFalse);
    });

    test('warn sells expired stock but flags it so the cashier must confirm', () {
      const warn = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'warn');
      final a = BatchPicker.allocate(batches: withExpired, qty: d('6'), policy: warn, today: today);
      expect(names(a), ['OLD', 'OK']);
      expect(a.usesExpired, isTrue);
      expect(a.expiredQty, d('4'));
      expect(a.blocked, isFalse);
      expect(warn.warnsExpired, isTrue);
      expect(warn.blocksExpired, isFalse);
    });

    test('allow sells expired stock without any prompt flag on the policy', () {
      const allow = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'allow');
      final a = BatchPicker.allocate(batches: withExpired, qty: d('6'), policy: allow, today: today);
      expect(names(a), ['OLD', 'OK']);
      expect(a.blocked, isFalse);
      expect(allow.warnsExpired, isFalse);
      expect(allow.blocksExpired, isFalse);
    });

    test('a batch that expires today can still be sold', () {
      const block = InventoryPolicy(pickPolicy: 'fifo', expiredSale: 'block');
      final a = BatchPicker.allocate(
        batches: [batch('T', '2026-11-17', '3', '2026-01-01')],
        qty: d('2'),
        policy: block,
        today: today,
      );
      expect(names(a), ['T']);
      expect(a.slices.single.expired, isFalse);
    });
  });

  group('expiry status and the near-expiry chip', () {
    test('status by days left', () {
      expect(ExpiryClock.status('2026-11-10', today, 30), ExpiryStatus.expired);
      expect(ExpiryClock.status('2026-11-17', today, 30), ExpiryStatus.near);
      expect(ExpiryClock.status('2026-12-17', today, 30), ExpiryStatus.near); // 30 days
      expect(ExpiryClock.status('2026-12-18', today, 30), ExpiryStatus.ok); // 31 days
      expect(ExpiryClock.status(null, today, 30), ExpiryStatus.none);
    });

    test('the window is configurable', () {
      expect(ExpiryClock.status('2027-01-10', today, 30), ExpiryStatus.ok);
      expect(ExpiryClock.status('2027-01-10', today, 90), ExpiryStatus.near);
    });

    test('a slice reports its own status', () {
      final slice = BatchSlice(
        batchNo: 'X',
        expiry: '2026-12-01',
        qty: d('1'),
        daysLeft: 14,
      );
      expect(slice.statusFor(30), ExpiryStatus.near);
      expect(slice.statusFor(7), ExpiryStatus.ok);
    });
  });

  group('settings', () {
    test('defaults when nothing was pulled', () {
      final p = InventoryPolicy.fromSettings(null);
      expect(p.pickPolicy, 'fifo');
      expect(p.expiredSale, 'warn');
      expect(p.nearExpiryDays, 30);
      expect(p.isFefo, isFalse);
    });

    test('reads pick policy, expired rule and the near-expiry window', () {
      final p = InventoryPolicy.fromSettings({
        'inventory.pick_policy': 'fefo',
        'inventory.expired_sale': 'block',
        'inventory.near_expiry_days': 45,
      });
      expect(p.isFefo, isTrue);
      expect(p.blocksExpired, isTrue);
      expect(p.nearExpiryDays, 45);
    });
  });

  test('a slice becomes the sale.create batch payload', () {
    final s = BatchSlice(batchNo: 'B1', expiry: '2027-05-31', qty: d('2'));
    expect(s.toPayload(), {'batch_no': 'B1', 'expiry_date': '2027-05-31', 'qty': '2'});
  });
}
