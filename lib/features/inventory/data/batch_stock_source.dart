import 'package:decimal/decimal.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/inventory/domain/batch_picker.dart';

/// A line's batches together with the rules they were picked under.
class BatchPlan {
  const BatchPlan({required this.allocation, required this.policy});

  final BatchAllocation allocation;
  final InventoryPolicy policy;

  List<BatchSlice> get slices => allocation.slices;
}

/// Reads batch stock from the data pulled to this device (`stock_batch`) and
/// the inventory settings, and picks batches for a quantity. Works offline;
/// sales that have not synced yet are taken off the batch quantities so two
/// sales in a row never pick the same stock.
class BatchStockSource {
  BatchStockSource(this._store, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final SyncStore _store;
  final DateTime Function() _clock;

  DateTime get today => ExpiryClock.dateOnly(_clock());

  /// `inventory.pick_policy`, `inventory.expired_sale` and the near-expiry
  /// window from the pulled settings (defaults when nothing was pulled).
  Future<InventoryPolicy> policy() async {
    final rows = await _store.entities('settings', limit: 1);
    final raw = rows.isEmpty ? null : rows.first['app_settings'];
    return InventoryPolicy.fromSettings(raw is Map ? raw.cast<String, dynamic>() : null);
  }

  /// Every batch of the product in [branchId] that still has stock, grouped by
  /// batch number and expiry, with pending local sales subtracted.
  Future<List<StockBatch>> batches(
    String branchId,
    String productId, {
    String? variationId,
  }) async {
    final rows = await _store.entities(
      'stock_batch',
      where: 'parent_id = ? AND (branch_id = ? OR branch_id IS NULL)',
      args: [productId, branchId],
    );
    final pending = await _store.pendingBatchQuantities(branchId);

    final groups = <String, _Group>{};
    for (final r in rows) {
      final rowVariation = r['variation_id'];
      if (variationId != null && rowVariation != null && '$rowVariation' != variationId) {
        continue;
      }
      final batchNo = _clean(r['batch_no']);
      final expiry = _clean(r['expiry_date']);
      final qty = Decimal.tryParse('${r['qty_remaining']}') ?? Decimal.zero;
      final received = DateTime.tryParse('${r['received_at'] ?? ''}');
      final g = groups.putIfAbsent('${batchNo ?? ''}|${expiry ?? ''}', () => _Group(batchNo, expiry));
      g.qty += qty;
      if (received != null && (g.received == null || received.isBefore(g.received!))) {
        g.received = received;
      }
    }

    final out = <StockBatch>[];
    for (final g in groups.values) {
      final taken = pending[SyncStore.batchKey(productId, variationId, g.batchNo, g.expiry)] ??
          Decimal.zero;
      final left = g.qty - taken;
      if (left > Decimal.zero) {
        out.add(StockBatch(batchNo: g.batchNo, expiry: g.expiry, qty: left, receivedAt: g.received));
      }
    }
    return out;
  }

  /// Picks batches for [qty] of a product, or null when the product has no
  /// batch stock at all (nothing to track; the server picks as usual).
  /// [totalStock] is the product's whole on-hand quantity (batch or not); the
  /// part no batch holds can still cover a sale when expired stock is blocked.
  Future<BatchPlan?> plan(
    String branchId,
    String productId, {
    String? variationId,
    required Decimal qty,
    Decimal? totalStock,
    InventoryPolicy? policy,
  }) async {
    final rules = policy ?? await this.policy();
    final list = await batches(branchId, productId, variationId: variationId);
    if (list.isEmpty) return null;
    Decimal? untracked;
    if (totalStock != null) {
      final inBatches = list.fold(Decimal.zero, (sum, b) => sum + b.qty);
      final spare = totalStock - inBatches;
      untracked = spare > Decimal.zero ? spare : Decimal.zero;
    }
    return BatchPlan(
      allocation: BatchPicker.allocate(
        batches: list,
        qty: qty,
        policy: rules,
        today: _clock(),
        untracked: untracked,
      ),
      policy: rules,
    );
  }

  static String? _clean(Object? v) {
    final s = v == null ? '' : '$v'.trim();
    return s.isEmpty || s == 'null' ? null : s;
  }
}

class _Group {
  _Group(this.batchNo, this.expiry);

  final String? batchNo;
  final String? expiry;
  Decimal qty = Decimal.zero;
  DateTime? received;
}
