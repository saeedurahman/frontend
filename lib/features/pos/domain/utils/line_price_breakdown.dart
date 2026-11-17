import 'package:decimal/decimal.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';

/// The small worked example under the total in the quantity popup, priced by
/// the same engine as the cart. Empty when no tax applies to the line.
///
/// Exclusive: `Price 6.00 x 2 = 12.00`, `GST 17%: 2.04`, `Total 14.04`.
/// Inclusive: `Price 6.00 x 2 = 12.00 (includes GST 17%: 1.74)`, `Total 12.00`.
abstract final class LinePriceBreakdown {
  static List<String> lines({
    required Decimal qty,
    required Decimal unitPrice,
    required Decimal taxRate,
    required TaxSettings tax,
  }) {
    if (!tax.enabled || taxRate <= Decimal.zero) return const [];
    final amounts = PricingEngine.calculateLineTotal(
      qty: qty,
      unitPrice: unitPrice,
      discountPct: Decimal.zero,
      discountAmount: Decimal.zero,
      taxRate: taxRate,
      inclusive: tax.inclusive,
    );
    final price = formatMoneyNumber(unitPrice);
    final subtotal = formatMoneyNumber(amounts.lineSubtotal);
    final taxText = '${tax.label} ${rateText(taxRate)}%: '
        '${formatMoneyNumber(amounts.taxAmount)}';
    final head = 'Price $price x ${qtyText(qty)} = $subtotal';
    if (tax.inclusive) {
      return [
        '$head (includes $taxText)',
        'Total ${formatMoneyNumber(amounts.lineTotal)}',
      ];
    }
    return [
      head,
      taxText,
      'Total ${formatMoneyNumber(amounts.lineTotal)}',
    ];
  }

  /// 17.000 -> "17", 17.5 -> "17.5".
  static String rateText(Decimal rate) => _trim(rate);

  static String qtyText(Decimal qty) => _trim(qty);

  static String _trim(Decimal value) {
    var text = value.toString();
    if (text.contains('.')) {
      text = text.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return text;
  }
}
