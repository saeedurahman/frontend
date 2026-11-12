import 'dart:convert';

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
      'lines': jsonDecode(row['lines']! as String),
      'payments': [
        for (var i = 0; i < payments.length; i++)
          {...Map<String, dynamic>.from(payments[i] as Map), 'id': '$id:$i'},
      ],
      // "offline" = the server has not confirmed this sale yet.
      'offline': row['sync_state'] != 'synced',
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
