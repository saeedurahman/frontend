import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/sales/data/models/paginated_sales_model.dart';
import 'package:frantend/features/sales/data/models/sale_list_item_model.dart';

/// What the sales list says about a sale's relation to the server.
enum SaleSyncBadge {
  /// The server has it (or nothing to say).
  none,

  /// Saved on this device, waiting to be sent: "Not synced yet".
  notSynced,

  /// The server refused it or it kept failing: "Needs attention".
  needsAttention;

  String? get label => switch (this) {
        SaleSyncBadge.none => null,
        SaleSyncBadge.notSynced => 'Not synced yet',
        SaleSyncBadge.needsAttention => 'Needs attention',
      };
}

/// Sync state per sale id for the rows the list currently shows.
///
/// A side table instead of a field on `SaleListItemModel`: that model is
/// generated (freezed) and the server never sends this.
abstract final class SaleSyncBadges {
  static final Map<String, SaleSyncBadge> _byId = {};

  static SaleSyncBadge of(String saleId) => _byId[saleId] ?? SaleSyncBadge.none;

  static void set(String saleId, SaleSyncBadge badge) {
    if (badge == SaleSyncBadge.none) {
      _byId.remove(saleId);
    } else {
      _byId[saleId] = badge;
    }
  }

  static void clear() => _byId.clear();

  static SaleSyncBadge fromState(String? syncState) => switch (syncState) {
        'pending' || 'sending' => SaleSyncBadge.notSynced,
        'failed' || 'rejected' || 'discarded' => SaleSyncBadge.needsAttention,
        _ => SaleSyncBadge.none,
      };
}

/// The sales list, answered from the device: pulled recent sales
/// (`sale_summary`) merged with this device's own sales (`local_sales`).
///
/// * a sale made here and not confirmed yet shows from the local record
///   (with its badge);
/// * once the server's own summary is here it wins (official number);
/// * filtering, searching and paging happen in Dart over a bounded set
///   (the pulled window is "last N days", the local table is capped).
class LocalHistory {
  LocalHistory(this._store);

  final SyncStore _store;

  static const _localCap = 500;

  Future<PaginatedSalesModel> sales({
    String? branchId,
    String? customerId,
    String? status,
    String? saleType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    final q = (search ?? '').trim().toLowerCase();
    final byId = <String, _Row>{};

    // Pulled summaries first…
    final conditions = [
      if (branchId != null) 'branch_id = ?',
      if (customerId != null) 'parent_id = ?',
    ];
    final summaries = await _store.entities(
      'sale_summary',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      args: [
        if (branchId != null) branchId,
        if (customerId != null) customerId,
      ],
      orderBy: 'id',
    );
    for (final s in summaries) {
      final item = _fromSummary(s);
      if (item != null) byId['${item['id']}'] = _Row(item, SaleSyncBadge.none);
    }

    // …then this device's own sales.
    for (final row in await _store.sales(limit: _localCap)) {
      if (row['sync_state'] == 'discarded') continue;
      final id = '${row['id']}';
      final badge = SaleSyncBadges.fromState(row['sync_state'] as String?);
      if (badge == SaleSyncBadge.none && byId.containsKey(id)) continue;
      if (branchId != null && row['branch_id'] != branchId) continue;
      if (customerId != null && row['customer_id'] != customerId) continue;
      byId[id] = _Row(_fromLocal(row), badge);
    }

    final rows = byId.values.where((r) {
      final item = r.json;
      if (status != null && item['status'] != status) return false;
      if (saleType != null && item['sale_type'] != saleType) return false;
      final sold = DateTime.tryParse('${item['sold_at']}')?.toLocal();
      if (sold != null) {
        if (dateFrom != null && sold.isBefore(dateFrom)) return false;
        if (dateTo != null && sold.isAfter(dateTo)) return false;
      }
      if (q.isNotEmpty && !_matches(item, q)) return false;
      return true;
    }).toList()
      ..sort((a, b) => '${b.json['sold_at']}'.compareTo('${a.json['sold_at']}'));

    final page = rows.skip(skip).take(limit).toList();
    for (final r in page) {
      SaleSyncBadges.set('${r.json['id']}', r.badge);
    }
    return PaginatedSalesModel(
      total: rows.length,
      skip: skip,
      limit: limit,
      items: [for (final r in page) SaleListItemModel.fromJson(r.json)],
    );
  }

  /// Local sales that the server's list does not have (yet): appended to the
  /// online list so a sale never disappears between "saved" and "synced".
  Future<List<SaleListItemModel>> pendingOnly({
    String? branchId,
    String? customerId,
  }) async {
    final out = <SaleListItemModel>[];
    for (final row in await _store.sales(limit: _localCap)) {
      final badge = SaleSyncBadges.fromState(row['sync_state'] as String?);
      if (badge == SaleSyncBadge.none || row['sync_state'] == 'discarded') {
        continue;
      }
      if (branchId != null && row['branch_id'] != branchId) continue;
      if (customerId != null && row['customer_id'] != customerId) continue;
      SaleSyncBadges.set('${row['id']}', badge);
      out.add(SaleListItemModel.fromJson(_fromLocal(row)));
    }
    return out;
  }

  static bool _matches(Map<String, dynamic> item, String q) {
    final sold = '${item['sold_at']}';
    final hay = [
      item['sale_number'],
      item['customer_name'],
      sold.length >= 10 ? sold.substring(0, 10) : sold,
      ...((item['product_names'] as List?) ?? const []),
    ].whereType<Object>().join(' ').toLowerCase();
    return hay.contains(q);
  }

  static Decimal _dec(Object? v) => Decimal.tryParse('${v ?? 0}') ?? Decimal.zero;

  static Map<String, dynamic>? _fromSummary(Map<String, dynamic> s) {
    final id = s['id']?.toString();
    if (id == null) return null;
    final totals = s['totals'] is Map ? s['totals'] as Map : const {};
    final total = _dec(s['total_amount'] ?? totals['total']);
    var paid = Decimal.zero;
    final methods = <String>[];
    for (final p in (s['payments'] as List? ?? const [])) {
      if (p is! Map) continue;
      final m = '${p['payment_method']}';
      if (m.isNotEmpty && !methods.contains(m)) methods.add(m);
      if (m != 'credit') paid += _dec(p['amount']);
    }
    final customer = s['customer'] is Map ? s['customer'] as Map : null;
    return {
      'id': id,
      'business_id': s['business_id'] ?? '',
      'branch_id': s['branch_id'] ?? '',
      'customer_id': s['customer_id'],
      'sale_number': '${s['sale_number'] ?? s['number'] ?? ''}',
      'sale_type': s['sale_type'] ?? 'pos',
      'status': s['status'] ?? 'completed',
      'sold_at': '${s['sold_at'] ?? s['created_at'] ?? ''}',
      'total_amount': total.toStringAsFixed(2),
      'total_paid': paid.toStringAsFixed(2),
      'balance_due': (total - paid).toStringAsFixed(2),
      'customer_name': s['customer_name'] ?? customer?['name'],
      'cashier_name': s['cashier_name'],
      'item_count': s['item_count'],
      'product_names': <String>[],
      'payment_methods': methods,
    };
  }

  static Map<String, dynamic> _fromLocal(Map<String, Object?> row) {
    final lines = jsonDecode('${row['lines']}') as List;
    final payments = jsonDecode('${row['payments']}') as List;
    final names = <String>[];
    for (final l in lines) {
      final n = l is Map ? '${l['product_name'] ?? ''}'.trim() : '';
      if (n.isNotEmpty && !names.contains(n)) names.add(n);
    }
    final methods = <String>[];
    for (final p in payments) {
      final m = p is Map ? '${p['payment_method']}' : '';
      if (m.isNotEmpty && !methods.contains(m)) methods.add(m);
    }
    final total = _dec(row['total_amount']);
    final paid = _dec(row['total_paid']);
    return {
      'id': row['id'],
      'business_id': '',
      'branch_id': row['branch_id'],
      'customer_id': row['customer_id'],
      'sale_number': '${row['official_number'] ?? row['receipt_no']}',
      'sale_type': 'pos',
      'status': row['status'] == 'voided' ? 'voided' : 'completed',
      'sold_at': '${row['sold_at']}',
      'total_amount': total.toStringAsFixed(2),
      'total_paid': paid.toStringAsFixed(2),
      'balance_due': (total - paid).toStringAsFixed(2),
      'customer_name': row['customer_name'],
      'item_count': lines.length,
      'product_names': names,
      'payment_methods': methods,
    };
  }
}

class _Row {
  _Row(this.json, this.badge);
  final Map<String, dynamic> json;
  final SaleSyncBadge badge;
}
