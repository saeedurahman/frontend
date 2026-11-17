import 'package:frantend/features/pos/domain/utils/tax_groups.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_totals.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';

/// Cart-level discount distribution and totals.
abstract final class PosCalculations {
  static Decimal sumSubtotal(List<CartItemModel> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + item.lineSubtotal);
  }

  static Decimal sumItemDiscounts(List<CartItemModel> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + item.lineDiscount);
  }

  static Decimal computeCartDiscountAmount({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
  }) {
    if (cartDiscountType == null || cartDiscountValue <= Decimal.zero) {
      return Decimal.zero;
    }
    final subtotal = sumSubtotal(items);
    if (subtotal <= Decimal.zero) return Decimal.zero;

    if (cartDiscountType == 'percentage') {
      return DecimalUtils.fromRational(
        subtotal * cartDiscountValue / Decimal.fromInt(100),
      );
    }
    return cartDiscountValue > subtotal ? subtotal : cartDiscountValue;
  }

  static Decimal sumTax(List<CartItemModel> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + item.lineTax);
  }

  static Decimal grandTotal(
    List<CartItemModel> items, {
    String? cartDiscountType,
    Decimal? cartDiscount,
    TaxSettings? tax,
  }) =>
      computeAuthoritativeTotals(
        items: items,
        cartDiscountType: cartDiscountType,
        cartDiscountValue: cartDiscount ?? Decimal.zero,
        tax: tax,
      ).totalAmount;

  /// Authoritative no-scheme totals matching backend pricing_engine + buildSaleLines.
  ///
  /// [tax] defaults to the settings in force on this device: exclusive or
  /// inclusive prices, and the rounding of the grand total.
  static PosSaleTotals computeAuthoritativeTotals({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
    TaxSettings? tax,
  }) {
    if (items.isEmpty) return PosSaleTotals.zero;
    final settings = tax ?? TaxSettingsHolder.current;

    final builtLines = buildSaleLines(
      items: items,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountValue,
      tax: settings,
    );

    final lineAmounts = builtLines.map((line) {
      return PricingEngine.calculateLineTotal(
        qty: Decimal.tryParse('${line['qty']}') ?? Decimal.zero,
        unitPrice: Decimal.tryParse('${line['unit_price']}') ?? Decimal.zero,
        discountPct: Decimal.tryParse('${line['discount_pct']}') ?? Decimal.zero,
        discountAmount:
            Decimal.tryParse('${line['discount_amount']}') ?? Decimal.zero,
        taxRate: Decimal.tryParse('${line['tax_rate']}') ?? Decimal.zero,
        inclusive: settings.inclusive,
      );
    }).toList();

    final totals = PricingEngine.totalsOf(
      lineAmounts,
      roundingMode: settings.roundingMode,
    );
    return PosSaleTotals(
      subtotal: totals.subtotal,
      totalDiscount: totals.totalDiscount,
      totalTax: totals.totalTax,
      totalAmount: totals.totalAmount,
      netAmount: totals.netAmount,
      exactTotal: totals.exactTotal,
      roundingAmount: totals.roundingAmount,
    );
  }

  /// Tax of the cart by rate ("GST 17%: 2.04"), priced like the totals.
  static List<TaxGroup> computeTaxGroups({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
    TaxSettings? tax,
  }) {
    if (items.isEmpty) return const [];
    final settings = tax ?? TaxSettingsHolder.current;
    final lines = buildSaleLines(
      items: items,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountValue,
      tax: settings,
    );
    return TaxGroup.group([
      for (final line in lines)
        () {
          final rate = Decimal.tryParse('${line['tax_rate']}') ?? Decimal.zero;
          final a = PricingEngine.calculateLineTotal(
            qty: Decimal.tryParse('${line['qty']}') ?? Decimal.zero,
            unitPrice:
                Decimal.tryParse('${line['unit_price']}') ?? Decimal.zero,
            discountPct:
                Decimal.tryParse('${line['discount_pct']}') ?? Decimal.zero,
            discountAmount:
                Decimal.tryParse('${line['discount_amount']}') ?? Decimal.zero,
            taxRate: rate,
            inclusive: settings.inclusive,
          );
          return (rate: rate, net: a.netAmount, tax: a.taxAmount);
        }(),
    ], label: settings.label);
  }

  /// Distributes cart discount into line payloads for API request.
  static List<Map<String, dynamic>> buildSaleLines({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
    TaxSettings? tax,
  }) {
    if (items.isEmpty) return [];
    final settings = tax ?? TaxSettingsHolder.current;

    final distributedAmounts = _distributeFixedCartDiscount(
      items: items,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountValue,
    );

    return List.generate(items.length, (index) {
      final item = items[index];
      var discountPct = item.effectiveDiscountPct;
      var discountAmount = item.effectiveDiscountAmount;

      if (cartDiscountType == 'percentage' && cartDiscountValue > Decimal.zero) {
        discountPct = discountPct + cartDiscountValue;
        final hundred = Decimal.fromInt(100);
        if (discountPct > hundred) discountPct = hundred;
      } else if (distributedAmounts[index] > Decimal.zero) {
        // Same as the server's price_cart: the line's own discount and its
        // share of the cart discount become one amount discount.
        discountAmount = item.lineDiscount + distributedAmounts[index];
        discountPct = Decimal.zero;
      }

      return {
        'product_id': item.productId,
        if (item.variationId != null) 'variation_id': item.variationId,
        'qty': DecimalUtils.format(item.qty),
        // Final price of ONE unit, modifiers included (the offline sync
        // contract: the server accepts `catalog` or `catalog + modifiers`).
        // Totals, receipts and the recorded sale all derive from this.
        'unit_price': DecimalUtils.format(item.unitPrice),
        'discount_pct': DecimalUtils.format(discountPct),
        'discount_amount': DecimalUtils.format(discountAmount),
        'tax_rate': DecimalUtils.format(item.taxRateUnder(settings)),
        if (item.lineNote != null && item.lineNote!.isNotEmpty)
          'notes': item.lineNote,
        if (item.modifiers.isNotEmpty)
          'modifier_ids':
              item.modifiers.map((modifier) => modifier.modifierId).toList(),
        if (item.modifiers.isNotEmpty)
          'modifiers': [
            for (final modifier in item.modifiers)
              {
                'modifier_id': modifier.modifierId,
                'name': modifier.modifierName,
                'price': DecimalUtils.format(modifier.priceDelta),
                'qty': '1',
              },
          ],
        'line_order': index + 1,
      };
    });
  }

  /// Splits a fixed cart discount across lines (backend
  /// `distribute_cart_discount`): pro rata to what each line is worth after
  /// its own discount, each share rounded to the cent, the last line takes
  /// the remainder, never negative and never above its line.
  @visibleForTesting
  static List<Decimal> distributeFixedCartDiscount({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
  }) =>
      _distributeFixedCartDiscount(
        items: items,
        cartDiscountType: cartDiscountType,
        cartDiscountValue: cartDiscountValue,
      );

  static List<Decimal> _distributeFixedCartDiscount({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
  }) {
    if (cartDiscountType != 'fixed' || cartDiscountValue <= Decimal.zero) {
      return List<Decimal>.filled(items.length, Decimal.zero);
    }
    return PricingEngine.distributeCartDiscount(
      [
        for (final item in items)
          PricingEngine.round2(item.lineSubtotal) - item.lineDiscount,
      ],
      cartDiscountValue,
    );
  }
}
