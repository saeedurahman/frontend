import 'package:decimal/decimal.dart';

/// Reading an amount typed into a khata form.
abstract final class KhataAmount {
  static final _plain = RegExp(r'^\d{1,10}(\.\d{1,2})?$');

  /// [raw] as a positive amount with at most 2 decimals, or null. Commas used
  /// as thousands separators are accepted.
  static String? parse(String raw) {
    final text = raw.trim().replaceAll(',', '');
    if (!_plain.hasMatch(text)) return null;
    final value = Decimal.parse(text);
    return value > Decimal.zero ? value.toStringAsFixed(2) : null;
  }
}
