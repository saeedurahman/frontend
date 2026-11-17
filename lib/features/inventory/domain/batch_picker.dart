import 'package:decimal/decimal.dart';

/// What the business chose for batches (pulled `inventory.*` settings).
class InventoryPolicy {
  const InventoryPolicy({
    this.pickPolicy = 'fifo',
    this.expiredSale = 'warn',
    this.nearExpiryDays = defaultNearExpiryDays,
  });

  /// `fifo` (oldest stock first) or `fefo` (earliest expiry first).
  final String pickPolicy;

  /// `block`, `warn` or `allow` selling expired stock.
  final String expiredSale;

  /// A batch expiring within this many days is shown as "near expiry".
  final int nearExpiryDays;

  static const defaultNearExpiryDays = 30;
  static const settingNearExpiryDays = 'inventory.near_expiry_days';

  bool get isFefo => pickPolicy == 'fefo';
  bool get blocksExpired => expiredSale == 'block';
  bool get warnsExpired => expiredSale == 'warn';

  /// Reads the `app_settings` map of the pulled settings entity. Unknown or
  /// missing values fall back to the backend defaults (fifo, warn).
  factory InventoryPolicy.fromSettings(Map<String, dynamic>? appSettings) {
    String pick(String key, List<String> allowed, String fallback) {
      var v = appSettings?[key];
      if (v is Map) v = v['value'];
      final s = '$v'.trim().toLowerCase();
      return allowed.contains(s) ? s : fallback;
    }

    var days = appSettings?[settingNearExpiryDays];
    if (days is Map) days = days['value'];
    return InventoryPolicy(
      pickPolicy: pick('inventory.pick_policy', const ['fifo', 'fefo'], 'fifo'),
      expiredSale: pick('inventory.expired_sale', const ['block', 'warn', 'allow'], 'warn'),
      nearExpiryDays: int.tryParse('$days') ?? defaultNearExpiryDays,
    );
  }

  InventoryPolicy copyWith({String? pickPolicy, String? expiredSale, int? nearExpiryDays}) =>
      InventoryPolicy(
        pickPolicy: pickPolicy ?? this.pickPolicy,
        expiredSale: expiredSale ?? this.expiredSale,
        nearExpiryDays: nearExpiryDays ?? this.nearExpiryDays,
      );
}

/// Stock on hand for one batch (one `stock_batch` group, after taking away
/// the sales that have not reached the server yet).
class StockBatch {
  const StockBatch({
    required this.batchNo,
    required this.expiry,
    required this.qty,
    this.receivedAt,
  });

  final String? batchNo;

  /// `YYYY-MM-DD`, or null for a batch without an expiry.
  final String? expiry;
  final Decimal qty;
  final DateTime? receivedAt;
}

/// How soon a date is, for colouring chips.
enum ExpiryStatus { none, ok, near, expired }

abstract final class ExpiryClock {
  static DateTime? parse(String? iso) {
    if (iso == null || iso.trim().isEmpty) return null;
    final d = DateTime.tryParse(iso.trim());
    return d == null ? null : DateTime(d.year, d.month, d.day);
  }

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Whole days from [today] to [expiry]; negative once expired.
  static int? daysLeft(String? expiry, DateTime today) {
    final e = parse(expiry);
    if (e == null) return null;
    return e.difference(dateOnly(today)).inDays;
  }

  static ExpiryStatus status(String? expiry, DateTime today, int nearDays) {
    final days = daysLeft(expiry, today);
    if (days == null) return ExpiryStatus.none;
    if (days < 0) return ExpiryStatus.expired;
    if (days <= nearDays) return ExpiryStatus.near;
    return ExpiryStatus.ok;
  }
}

/// One batch taking part of a line's quantity.
class BatchSlice {
  const BatchSlice({
    required this.batchNo,
    required this.expiry,
    required this.qty,
    this.expired = false,
    this.daysLeft,
  });

  final String? batchNo;
  final String? expiry;
  final Decimal qty;
  final bool expired;
  final int? daysLeft;

  ExpiryStatus statusFor(int nearDays) {
    if (expiry == null) return ExpiryStatus.none;
    if (expired) return ExpiryStatus.expired;
    final d = daysLeft;
    if (d != null && d <= nearDays) return ExpiryStatus.near;
    return ExpiryStatus.ok;
  }

  /// The `sale.create` line `batches` entry.
  Map<String, dynamic> toPayload() => {
        'batch_no': batchNo,
        'expiry_date': expiry,
        'qty': qty.toString(),
      };

  Map<String, dynamic> toJson() => {
        'batch_no': batchNo,
        'expiry_date': expiry,
        'qty': qty.toString(),
        'expired': expired,
        if (daysLeft != null) 'days_left': daysLeft,
      };

  factory BatchSlice.fromJson(Map<String, dynamic> json) => BatchSlice(
        batchNo: json['batch_no'] as String?,
        expiry: json['expiry_date'] as String?,
        qty: Decimal.tryParse('${json['qty']}') ?? Decimal.zero,
        expired: json['expired'] == true,
        daysLeft: json['days_left'] is int ? json['days_left'] as int : null,
      );

  @override
  bool operator ==(Object other) =>
      other is BatchSlice &&
      other.batchNo == batchNo &&
      other.expiry == expiry &&
      other.qty == qty;

  @override
  int get hashCode => Object.hash(batchNo, expiry, qty);
}

/// The outcome of picking batches for one line.
class BatchAllocation {
  const BatchAllocation({
    required this.slices,
    required this.shortfall,
    required this.skippedExpiredQty,
    required this.blocked,
  });

  /// Batches to take stock from, in picking order.
  final List<BatchSlice> slices;

  /// Quantity no batch could cover (stock without a batch, or none left).
  final Decimal shortfall;

  /// Expired stock that was left alone because expired sales are blocked.
  final Decimal skippedExpiredQty;

  /// Expired sales are blocked and only expired stock could cover the line.
  final bool blocked;

  bool get usesExpired => slices.any((s) => s.expired);

  Decimal get expiredQty => slices.fold(
        Decimal.zero,
        (sum, s) => s.expired ? sum + s.qty : sum,
      );

  static final empty = BatchAllocation(
    slices: const [],
    shortfall: Decimal.zero,
    skippedExpiredQty: Decimal.zero,
    blocked: false,
  );
}

/// Chooses which batches a sale line takes stock from. Mirrors the server's
/// picking (`fifo_service.consume_fifo_layers`), so what the receipt shows is
/// what the server will record.
abstract final class BatchPicker {
  /// [batches] must already have pending local sales taken off. [untracked] is
  /// stock that sits in no batch (it can cover a shortfall without blocking).
  static BatchAllocation allocate({
    required List<StockBatch> batches,
    required Decimal qty,
    required InventoryPolicy policy,
    required DateTime today,
    Decimal? untracked,
  }) {
    if (qty <= Decimal.zero) return BatchAllocation.empty;
    final day = ExpiryClock.dateOnly(today);

    bool isExpired(StockBatch b) {
      final e = ExpiryClock.parse(b.expiry);
      return e != null && e.isBefore(day);
    }

    final sorted = [
      for (final b in batches)
        if (b.qty > Decimal.zero) b,
    ]..sort((a, b) => _compare(a, b, policy.isFefo));

    var skipped = Decimal.zero;
    final usable = <StockBatch>[];
    for (final b in sorted) {
      if (policy.blocksExpired && isExpired(b)) {
        skipped += b.qty;
      } else {
        usable.add(b);
      }
    }

    var remaining = qty;
    final slices = <BatchSlice>[];
    for (final b in usable) {
      if (remaining <= Decimal.zero) break;
      final take = b.qty < remaining ? b.qty : remaining;
      slices.add(BatchSlice(
        batchNo: b.batchNo,
        expiry: b.expiry,
        qty: take,
        expired: isExpired(b),
        daysLeft: ExpiryClock.daysLeft(b.expiry, day),
      ));
      remaining -= take;
    }

    final spare = untracked ?? Decimal.zero;
    final blocked = policy.blocksExpired &&
        skipped > Decimal.zero &&
        remaining > spare;
    return BatchAllocation(
      slices: slices,
      shortfall: remaining,
      skippedExpiredQty: skipped,
      blocked: blocked,
    );
  }

  static int _compare(StockBatch a, StockBatch b, bool fefo) {
    int byReceived() {
      final x = a.receivedAt;
      final y = b.receivedAt;
      if (x == null && y == null) return (a.batchNo ?? '').compareTo(b.batchNo ?? '');
      if (x == null) return 1;
      if (y == null) return -1;
      return x.compareTo(y);
    }

    if (fefo) {
      final x = ExpiryClock.parse(a.expiry);
      final y = ExpiryClock.parse(b.expiry);
      if (x != null && y != null) {
        final c = x.compareTo(y);
        if (c != 0) return c;
      } else if (x == null && y != null) {
        return 1;
      } else if (x != null && y == null) {
        return -1;
      }
    }
    return byReceived();
  }
}
