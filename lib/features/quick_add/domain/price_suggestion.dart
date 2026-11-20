import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:rational/rational.dart';

/// Rounding of a suggested sale price (`pricing.suggested_price_rounding`).
/// Same words as `tax.rounding_mode`.
abstract final class PriceRounding {
  static const modes = ['none', 'nearest_1', 'nearest_5', 'nearest_10'];

  static String normalize(Object? mode) =>
      mode is String && modes.contains(mode) ? mode : 'nearest_1';

  static int? step(String mode) => switch (mode) {
        'nearest_1' => 1,
        'nearest_5' => 5,
        'nearest_10' => 10,
        _ => null,
      };

  /// Rounds half up to the step (Rs. 92.5 to the nearest 5 is Rs. 95); `none`
  /// keeps paisa, rounded half up to two places.
  static Decimal apply(Decimal value, String mode) {
    final step = PriceRounding.step(mode);
    if (step == null) {
      return DecimalUtils.fromRational(value.toRational());
    }
    final s = Rational.fromInt(step);
    final units = (value.toRational() / s).round();
    return (Rational(units) * s).toDecimal();
  }
}

/// The price Quick Add suggests, so the owner only confirms it.
abstract final class PriceSuggestion {
  /// `cost x (1 + margin / 100)`, rounded by [rounding]. Null when the cost is
  /// missing or not above zero (nothing sensible to suggest).
  static Decimal? fromCost({
    required Decimal? cost,
    required Decimal marginPercent,
    required String rounding,
  }) {
    if (cost == null || cost <= Decimal.zero) return null;
    final factor = Rational.one + marginPercent.toRational() / Rational.fromInt(100);
    final raw = (cost.toRational() * factor).toDecimal(scaleOnInfinitePrecision: 10);
    return PriceRounding.apply(raw, PriceRounding.normalize(rounding));
  }

  /// The suggestion for a row: the printed price (MRP) wins, else cost + margin.
  static Decimal? forRow({
    Decimal? mrp,
    Decimal? cost,
    required Decimal marginPercent,
    required String rounding,
  }) {
    if (mrp != null && mrp > Decimal.zero) return mrp;
    return fromCost(cost: cost, marginPercent: marginPercent, rounding: rounding);
  }
}
