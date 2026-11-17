import 'package:decimal/decimal.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/domain/utils/line_price_breakdown.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

/// Which tax rate a line gets (same order as the server):
///
/// 1. tax disabled -> none (zero)
/// 2. product marked tax-free -> none (zero)
/// 3. the product's own tax rate, if it has one
/// 4. otherwise the business default rate (`tax.default_rate_id`), else none
abstract final class TaxRateResolver {
  /// The rate a new line for a product gets, or null for "no tax".
  static TaxRateModel? forProduct({
    required TaxSettings tax,
    required bool taxExempt,
    required String? ownRateId,
    required List<TaxRateModel> rates,
    required TaxRateModel? defaultRate,
  }) {
    if (!tax.enabled || taxExempt) return null;
    if (ownRateId != null) {
      for (final r in rates) {
        if (r.id == ownRateId) return r;
      }
    }
    return defaultRate;
  }

  /// The business default rate: `tax.default_rate_id` among the active rates.
  static TaxRateModel? defaultRateOf(
    TaxSettings tax,
    List<TaxRateModel> rates,
  ) {
    final id = tax.defaultRateId;
    if (id == null) return null;
    for (final r in rates) {
      if (r.id == id && r.isActive) return r;
    }
    return null;
  }

  /// Applies [rate] to a cart line (keeps every other field).
  static CartItemModel apply(
    CartItemModel item,
    TaxRateModel? rate, {
    required bool taxExempt,
    required String? ownRateId,
  }) {
    final base = item.copyWith(
      taxExempt: taxExempt,
      ownTaxRateId: ownRateId,
      clearOwnTaxRateId: ownRateId == null,
    );
    if (rate == null) return base.copyWith(clearTax: true);
    return base.copyWith(
      taxRateId: rate.id,
      taxRateName: '${rate.name} ${rate.rate}%',
      taxRate: Decimal.tryParse(rate.rate) ?? Decimal.zero,
    );
  }

  /// The small tag on a product card: "+17% GST" when tax is added on top,
  /// "incl. tax" when the shelf price already has it, null for tax-free items
  /// or when the business does not charge tax.
  static String? cardTag({
    required TaxSettings tax,
    required bool taxExempt,
    required String? ownRateId,
    required List<TaxRateModel> rates,
    required TaxRateModel? defaultRate,
  }) {
    final rate = forProduct(
      tax: tax,
      taxExempt: taxExempt,
      ownRateId: ownRateId,
      rates: rates,
      defaultRate: defaultRate,
    );
    final value = rate == null ? null : Decimal.tryParse(rate.rate);
    if (value == null || value <= Decimal.zero) return null;
    if (tax.inclusive) return 'incl. tax';
    return '+${LinePriceBreakdown.rateText(value)}% ${tax.label}';
  }
}
