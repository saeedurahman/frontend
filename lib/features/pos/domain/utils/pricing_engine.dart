import 'package:decimal/decimal.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/utils/decimal_utils.dart';

/// Mirrors backend `app/services/pricing_engine.py` exactly (Decimal only,
/// ROUND_HALF_UP = half away from zero).
///
///  * exclusive: net = qty*price - discount; tax = round2(net*rate/100);
///    total = net + tax
///  * inclusive: gross = qty*price - discount; tax = round2(gross*rate/(100+rate));
///    net = gross - tax; total = gross  (so net + tax == gross exactly)
///  * grand total: exact = sum(net) + sum(tax); only that total is rounded to
///    the nearest 1/5/10; rounding_amount = rounded - exact (signed).
class LineAmounts {
  const LineAmounts({
    required this.lineSubtotal,
    required this.effectiveDiscount,
    required this.netAmount,
    required this.taxAmount,
    required this.lineTotal,
  });

  final Decimal lineSubtotal;
  final Decimal effectiveDiscount;

  /// Amount before tax (the "net" of both modes).
  final Decimal netAmount;
  final Decimal taxAmount;

  /// Line gross: net + tax.
  final Decimal lineTotal;

  /// Older name of [netAmount].
  Decimal get taxableAmount => netAmount;
}

/// Totals of a whole sale (what the server stores on the sale).
class SaleAmounts {
  const SaleAmounts({
    required this.subtotal,
    required this.totalDiscount,
    required this.netAmount,
    required this.totalTax,
    required this.exactTotal,
    required this.roundingAmount,
    required this.totalAmount,
  });

  final Decimal subtotal;
  final Decimal totalDiscount;
  final Decimal netAmount;
  final Decimal totalTax;
  final Decimal exactTotal;
  final Decimal roundingAmount;
  final Decimal totalAmount;

  static SaleAmounts get zero => SaleAmounts(
        subtotal: Decimal.zero,
        totalDiscount: Decimal.zero,
        netAmount: Decimal.zero,
        totalTax: Decimal.zero,
        exactTotal: Decimal.zero,
        roundingAmount: Decimal.zero,
        totalAmount: Decimal.zero,
      );

  Map<String, Decimal> toMap() => {
        'subtotal': subtotal,
        'total_discount': totalDiscount,
        'net_amount': netAmount,
        'total_tax': totalTax,
        'exact_total': exactTotal,
        'rounding_amount': roundingAmount,
        'total_amount': totalAmount,
      };
}

/// One cart line as the engine reads it.
class PricingLine {
  const PricingLine({
    required this.qty,
    required this.unitPrice,
    required this.taxRate,
    this.discountPct,
    this.discountAmount,
  });

  final Decimal qty;
  final Decimal unitPrice;
  final Decimal taxRate;
  final Decimal? discountPct;
  final Decimal? discountAmount;
}

abstract final class PricingEngine {
  static final _hundred = Decimal.fromInt(100);

  static Decimal round2(Decimal value) => DecimalUtils.roundMoney(value);

  static Decimal _div2(Decimal numerator, Decimal denominator) =>
      DecimalUtils.fromRational(numerator / denominator);

  static LineAmounts calculateLineTotal({
    required Decimal qty,
    required Decimal unitPrice,
    required Decimal discountPct,
    required Decimal discountAmount,
    required Decimal taxRate,
    bool inclusive = false,
  }) {
    final lineSubtotal = round2(qty * unitPrice);
    final pctDiscount = _div2(lineSubtotal * discountPct, _hundred);
    var effectiveDiscount = round2(
      discountAmount > pctDiscount ? discountAmount : pctDiscount,
    );
    // A discount can never push a line below zero.
    if (effectiveDiscount > lineSubtotal) effectiveDiscount = lineSubtotal;
    final afterDiscount = round2(lineSubtotal - effectiveDiscount);

    final Decimal net;
    final Decimal tax;
    final Decimal total;
    if (inclusive) {
      tax = taxRate > Decimal.zero
          ? _div2(afterDiscount * taxRate, _hundred + taxRate)
          : Decimal.zero;
      net = afterDiscount - tax;
      total = afterDiscount;
    } else {
      net = afterDiscount;
      tax = _div2(net * taxRate, _hundred);
      total = net + tax;
    }
    return LineAmounts(
      lineSubtotal: lineSubtotal,
      effectiveDiscount: effectiveDiscount,
      netAmount: net,
      taxAmount: tax,
      lineTotal: total,
    );
  }

  /// Spreads a fixed cart discount over lines in proportion to what each is
  /// still worth after its own discount (`distribute_cart_discount`). Shares
  /// are rounded to the cent, the last line takes the remainder, none is
  /// negative or above its line, and they add up to
  /// `min(cartDiscount, sum(lineAmounts))`.
  static List<Decimal> distributeCartDiscount(
    List<Decimal> lineAmounts,
    Decimal cartDiscount,
  ) {
    final n = lineAmounts.length;
    if (n == 0) return const [];
    final amounts = [
      for (final a in lineAmounts) a < Decimal.zero ? Decimal.zero : a,
    ];
    final total = amounts.fold(Decimal.zero, (a, b) => a + b);
    var target = round2(cartDiscount);
    if (target < Decimal.zero) target = Decimal.zero;
    if (target > total) target = total;
    if (target <= Decimal.zero || total <= Decimal.zero) {
      return List<Decimal>.filled(n, Decimal.zero);
    }

    final shares = List<Decimal>.filled(n, Decimal.zero);
    var allocated = Decimal.zero;
    for (var i = 0; i < n - 1; i++) {
      final raw = _div2(target * amounts[i], total);
      shares[i] = raw < amounts[i] ? raw : amounts[i];
      allocated += shares[i];
    }
    var remainder = target - allocated;
    if (remainder < Decimal.zero) remainder = Decimal.zero;
    shares[n - 1] = remainder < amounts[n - 1] ? remainder : amounts[n - 1];
    // Whatever the last line could not absorb goes to lines with headroom.
    var leftover = target - shares.fold(Decimal.zero, (a, b) => a + b);
    for (var i = 0; i < n && leftover > Decimal.zero; i++) {
      final room = amounts[i] - shares[i];
      final take = room < leftover ? room : leftover;
      if (take > Decimal.zero) {
        shares[i] += take;
        leftover -= take;
      }
    }
    return shares;
  }

  /// `(rounded_total, rounding_amount)` for the grand total, half away from
  /// zero to the step of [mode] (`none`, `nearest_1`, `nearest_5`,
  /// `nearest_10`).
  static (Decimal, Decimal) roundTotal(Decimal exactTotal, String? mode) {
    final exact = round2(exactTotal);
    final step = TaxSettings.roundingStep(mode);
    if (step == null) return (exact, Decimal.zero);
    final stepD = Decimal.fromInt(step);
    final steps = DecimalUtils.fromRational(exact / stepD, fractionDigits: 0);
    final rounded = round2(steps * stepD);
    return (rounded, rounded - exact);
  }

  /// Sums per-line amounts; only the grand total is rounded.
  static SaleAmounts totalsOf(
    List<LineAmounts> lines, {
    String? roundingMode = 'none',
  }) {
    var subtotal = Decimal.zero;
    var discount = Decimal.zero;
    var net = Decimal.zero;
    var tax = Decimal.zero;
    for (final line in lines) {
      subtotal += line.lineSubtotal;
      discount += line.effectiveDiscount;
      net += line.netAmount;
      tax += line.taxAmount;
    }
    subtotal = round2(subtotal);
    discount = round2(discount);
    net = round2(net);
    tax = round2(tax);
    final exact = round2(net + tax);
    final (total, rounding) = roundTotal(exact, roundingMode);
    return SaleAmounts(
      subtotal: subtotal,
      totalDiscount: discount,
      netAmount: net,
      totalTax: tax,
      exactTotal: exact,
      roundingAmount: rounding,
      totalAmount: total,
    );
  }

  /// Map form of [totalsOf] (older callers).
  static Map<String, Decimal> calculateSaleTotals(
    List<LineAmounts> lines, {
    String? roundingMode = 'none',
  }) =>
      totalsOf(lines, roundingMode: roundingMode).toMap();

  /// Prices a whole cart (`price_cart`): line discounts, then a fixed
  /// cart-level discount folded into the lines, then the totals.
  static (List<LineAmounts>, SaleAmounts) priceCart(
    List<PricingLine> lines, {
    bool inclusive = false,
    String? roundingMode = 'none',
    Decimal? cartDiscount,
  }) {
    LineAmounts one(PricingLine l, {Decimal? extraDiscount}) =>
        calculateLineTotal(
          qty: l.qty,
          unitPrice: l.unitPrice,
          discountPct: extraDiscount == null
              ? (l.discountPct ?? Decimal.zero)
              : Decimal.zero,
          discountAmount: extraDiscount ?? (l.discountAmount ?? Decimal.zero),
          taxRate: l.taxRate,
          inclusive: inclusive,
        );

    var base = [for (final l in lines) one(l)];
    if (cartDiscount != null && cartDiscount > Decimal.zero) {
      final shares = distributeCartDiscount(
        [for (final b in base) b.lineSubtotal - b.effectiveDiscount],
        cartDiscount,
      );
      base = [
        for (var i = 0; i < lines.length; i++)
          one(lines[i], extraDiscount: base[i].effectiveDiscount + shares[i]),
      ];
    }
    return (base, totalsOf(base, roundingMode: roundingMode));
  }
}
