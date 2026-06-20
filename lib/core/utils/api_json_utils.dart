/// Normalizes API JSON values for Flutter models (Decimal/UUID fields, aliases).
abstract final class ApiJsonUtils {
  static String stringValue(dynamic value, {String fallback = '0'}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static Map<String, dynamic> normalizeSaleResponse(Map<String, dynamic> raw) {
    final json = Map<String, dynamic>.from(raw);

    json['sale_status'] ??= json['status'];
    json['sale_type'] ??= json['sale_type'] ?? 'pos';

    if (json['total_amount'] == null) {
      final payments = json['payments'] as List<dynamic>? ?? [];
      var total = 0.0;
      for (final payment in payments) {
        if (payment is Map) {
          total += double.tryParse('${payment['amount']}') ?? 0;
        }
      }
      if (total == 0) {
        final lines = json['lines'] as List<dynamic>? ?? [];
        for (final line in lines) {
          if (line is! Map) continue;
          final qty = double.tryParse('${line['qty']}') ?? 0;
          final price = double.tryParse('${line['unit_price']}') ?? 0;
          total += qty * price;
        }
      }
      json['total_amount'] = total.toStringAsFixed(2);
    } else {
      json['total_amount'] = stringValue(json['total_amount']);
    }

    if (json['total_paid'] == null) {
      final payments = json['payments'] as List<dynamic>? ?? [];
      var paid = 0.0;
      for (final payment in payments) {
        if (payment is Map) {
          paid += double.tryParse('${payment['amount']}') ?? 0;
        }
      }
      json['total_paid'] = paid.toStringAsFixed(2);
    } else {
      json['total_paid'] = stringValue(json['total_paid']);
    }

    if (json['register_shift_id'] != null) {
      json['register_shift_id'] = '${json['register_shift_id']}';
    }

    final lines = json['lines'] as List<dynamic>? ?? [];
    json['lines'] = lines.map((line) {
      if (line is! Map) return line;
      final m = Map<String, dynamic>.from(line);
      for (final key in [
        'qty',
        'unit_price',
        'discount_pct',
        'discount_amount',
        'tax_rate',
        'tax_amount',
        'cost_per_unit',
      ]) {
        if (m.containsKey(key) && m[key] != null) {
          m[key] = stringValue(m[key]);
        }
      }
      if (m['line_total'] == null) {
        final qty = double.tryParse('${m['qty']}') ?? 0;
        final price = double.tryParse('${m['unit_price']}') ?? 0;
        final discount = double.tryParse('${m['discount_amount']}') ?? 0;
        final tax = double.tryParse('${m['tax_amount']}') ?? 0;
        m['line_total'] = (qty * price - discount + tax).toStringAsFixed(2);
      } else {
        m['line_total'] = stringValue(m['line_total']);
      }
      return m;
    }).toList();

    final payments = json['payments'] as List<dynamic>? ?? [];
    json['payments'] = payments.map((payment) {
      if (payment is! Map) return payment;
      final m = Map<String, dynamic>.from(payment);
      if (m['amount'] != null) {
        m['amount'] = stringValue(m['amount']);
      }
      return m;
    }).toList();

    return json;
  }
}
