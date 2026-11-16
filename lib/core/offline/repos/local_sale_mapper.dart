import 'dart:convert';

import 'package:frantend/core/offline/sale_line_modifiers.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

/// Turns a `local_sales` row into the model the receipt / sale screens use.
abstract final class LocalSaleMapper {
  /// `sale_number` is the official number once the server gave one, the device
  /// receipt number before that. Receipts show both (see [numbersLine]).
  static SaleResponseModel toResponse(Map<String, Object?> row, {Map<String, dynamic>? customer}) {
    final id = row['id']! as String;
    final payments = jsonDecode(row['payments']! as String) as List;
    return SaleResponseModel.fromJson({
      'id': id,
      'sale_number': (row['official_number'] as String?) ?? row['receipt_no'],
      'branch_id': row['branch_id'],
      'customer_id': row['customer_id'],
      'sale_type': 'pos',
      'sale_status': row['status'] == 'voided' ? 'voided' : 'completed',
      'register_shift_id': row['shift_id'],
      'subtotal': row['subtotal'],
      'total_discount': row['total_discount'],
      'total_tax': row['total_tax'],
      'total_amount': row['total_amount'],
      'total_paid': row['total_paid'],
      'notes': row['notes'],
      'sold_at': row['sold_at'],
      'created_at': row['sold_at'],
      if (customer != null) 'customer': customer,
      'lines': [
        for (final line in jsonDecode(row['lines']! as String) as List)
          _line(Map<String, dynamic>.from(line as Map)),
      ],
      'payments': [
        for (var i = 0; i < payments.length; i++)
          {...Map<String, dynamic>.from(payments[i] as Map), 'id': '$id:$i'},
      ],
      // "offline" = the server has not confirmed this sale yet.
      'offline': row['sync_state'] != 'synced',
    });
  }

  /// Modifiers ride in the line `notes`, in the server's own
  /// `restaurant:{...}` encoding, so a reprint of a local sale and a sale
  /// loaded from the server are parsed by the same code.
  static Map<String, dynamic> _line(Map<String, dynamic> line) {
    final modifiers = SaleLineModifier.listFrom(line['modifiers']);
    final out = {...line}..remove('modifiers');
    if (modifiers.isNotEmpty) {
      out['notes'] = SaleLineModifier.encodeNotes(
        line['notes']?.toString(),
        modifiers,
      );
    }
    return out;
  }

  /// A recent sale the server delivered as a `sale_summary` (no lines): what
  /// the sale screen can show without the network. `lines` stays empty; the
  /// screen says that full details need the server.
  static SaleResponseModel fromSummary(
    Map<String, dynamic> s, {
    Map<String, dynamic>? customer,
  }) {
    final totals = s['totals'] is Map ? Map<String, dynamic>.from(s['totals'] as Map) : const {};
    final payments = [
      for (final p in (s['payments'] as List? ?? const []))
        Map<String, dynamic>.from(p as Map),
    ];
    var paid = 0.0;
    for (final p in payments) {
      if (p['payment_method'] != 'credit') {
        paid += double.tryParse('${p['amount']}') ?? 0;
      }
    }
    final total = '${s['total_amount'] ?? totals['total'] ?? '0'}';
    final cust = customer ??
        (s['customer'] is Map ? Map<String, dynamic>.from(s['customer'] as Map) : null);
    return SaleResponseModel.fromJson({
      'id': s['id'],
      'sale_number': s['sale_number'] ?? s['number'],
      'branch_id': s['branch_id'] ?? '',
      'customer_id': s['customer_id'],
      'sale_type': s['sale_type'] ?? 'pos',
      'sale_status': s['status'] ?? 'completed',
      'subtotal': totals['subtotal'],
      'total_discount': totals['discount'],
      'total_tax': totals['tax'],
      'total_amount': total,
      'total_paid': paid.toStringAsFixed(2),
      'sold_at': s['sold_at'],
      'created_at': s['created_at'] ?? s['sold_at'],
      if (cust != null && cust['name'] != null)
        'customer': {
          'id': cust['id'] ?? s['customer_id'] ?? '',
          'business_id': cust['business_id'] ?? '',
          'name': cust['name'],
          if (cust['phone'] != null) 'phone': cust['phone'],
        },
      'lines': const [],
      'payments': [
        for (var i = 0; i < payments.length; i++)
          {...payments[i], 'id': '${s['id']}:$i'},
      ],
      'offline': false,
    });
  }

  /// `Receipt D3F9-0001 · Official INV-20261029-0042` (official only once synced).
  static String numbersLine(Map<String, Object?> row) {
    final official = row['official_number'] as String?;
    final device = '${row['receipt_no']}';
    return official == null
        ? 'Receipt $device (pending sync)'
        : 'Receipt $device  |  Official $official';
  }

  static List<String> flags(Map<String, Object?> row) => [
        for (final f in jsonDecode('${row['flags'] ?? '[]'}') as List) '$f',
      ];
}
