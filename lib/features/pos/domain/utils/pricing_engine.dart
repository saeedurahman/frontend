import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';

/// Mirrors backend [pricing_engine.py] for authoritative POS totals.
class LineAmounts {
  const LineAmounts({
    required this.lineSubtotal,
    required this.effectiveDiscount,
    required this.taxableAmount,
    required this.taxAmount,
    required this.lineTotal,
  });

  final Decimal lineSubtotal;
  final Decimal effectiveDiscount;
  final Decimal taxableAmount;
  final Decimal taxAmount;
  final Decimal lineTotal;
}

abstract final class PricingEngine {
  static Decimal round2(Decimal value) => DecimalUtils.roundMoney(value);

  static LineAmounts calculateLineTotal({
    required Decimal qty,
    required Decimal unitPrice,
    required Decimal discountPct,
    required Decimal discountAmount,
    required Decimal taxRate,
  }) {
    final lineSubtotal = round2(qty * unitPrice);
    final pctDiscount = round2(
      DecimalUtils.fromRational(
        lineSubtotal * discountPct / Decimal.fromInt(100),
      ),
    );
    var effectiveDiscount = discountAmount > pctDiscount
        ? discountAmount
        : pctDiscount;
    effectiveDiscount = round2(effectiveDiscount);
    final taxableAmount = round2(lineSubtotal - effectiveDiscount);
    final taxAmount = taxableAmount <= Decimal.zero
        ? Decimal.zero
        : round2(
            DecimalUtils.fromRational(
              taxableAmount * taxRate / Decimal.fromInt(100),
            ),
          );
    final lineTotal = round2(taxableAmount + taxAmount);
    return LineAmounts(
      lineSubtotal: lineSubtotal,
      effectiveDiscount: effectiveDiscount,
      taxableAmount: taxableAmount,
      taxAmount: taxAmount,
      lineTotal: lineTotal,
    );
  }

  static Map<String, Decimal> calculateSaleTotals(List<LineAmounts> lines) {
    var subtotal = Decimal.zero;
    var totalDiscount = Decimal.zero;
    var totalTax = Decimal.zero;

    for (final line in lines) {
      subtotal += line.lineSubtotal;
      totalDiscount += line.effectiveDiscount;
      totalTax += line.taxAmount;
    }

    subtotal = round2(subtotal);
    totalDiscount = round2(totalDiscount);
    totalTax = round2(totalTax);
    final totalAmount = round2(subtotal - totalDiscount + totalTax);

    return {
      'subtotal': subtotal,
      'total_discount': totalDiscount,
      'total_tax': totalTax,
      'total_amount': totalAmount,
    };
  }
}
