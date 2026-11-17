import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';

/// Tax of a sale grouped by rate: one row per rate ("GST 17%").
class TaxGroup {
  const TaxGroup({
    required this.rate,
    required this.net,
    required this.tax,
    this.label,
  });

  final Decimal rate;
  final Decimal net;
  final Decimal tax;
  final String? label;

  /// "17" / "17.5" (no trailing zeros).
  String get rateText {
    var text = rate.toString();
    if (text.contains('.')) {
      text = text.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return text;
  }

  /// "GST 17%".
  String title(String fallbackLabel) =>
      '${(label == null || label!.isEmpty) ? fallbackLabel : label} $rateText%';

  /// Groups (rate, net, tax) triples; lines without tax are left out. Sorted by
  /// rate so the order never depends on the cart order.
  static List<TaxGroup> group(
    Iterable<({Decimal rate, Decimal net, Decimal tax})> lines, {
    String? label,
  }) {
    final byRate = <String, ({Decimal rate, Decimal net, Decimal tax})>{};
    for (final l in lines) {
      if (l.rate <= Decimal.zero || l.tax == Decimal.zero) continue;
      final key = DecimalUtils.format(l.rate);
      final prev = byRate[key];
      byRate[key] = prev == null
          ? l
          : (rate: l.rate, net: prev.net + l.net, tax: prev.tax + l.tax);
    }
    final groups = [
      for (final g in byRate.values)
        TaxGroup(rate: g.rate, net: g.net, tax: g.tax, label: label),
    ]..sort((a, b) => a.rate.compareTo(b.rate));
    return groups;
  }
}
