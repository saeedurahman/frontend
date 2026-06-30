import 'package:decimal/decimal.dart';
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
  }) =>
      computeAuthoritativeTotals(
        items: items,
        cartDiscountType: cartDiscountType,
        cartDiscountValue: cartDiscount ?? Decimal.zero,
      ).totalAmount;

  /// Authoritative no-scheme totals matching backend pricing_engine + buildSaleLines.
  static PosSaleTotals computeAuthoritativeTotals({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
  }) {
    if (items.isEmpty) return PosSaleTotals.zero;

    final builtLines = buildSaleLines(
      items: items,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountValue,
    );

    final lineAmounts = builtLines.map((line) {
      return PricingEngine.calculateLineTotal(
        qty: Decimal.tryParse('${line['qty']}') ?? Decimal.zero,
        unitPrice: Decimal.tryParse('${line['unit_price']}') ?? Decimal.zero,
        discountPct: Decimal.tryParse('${line['discount_pct']}') ?? Decimal.zero,
        discountAmount:
            Decimal.tryParse('${line['discount_amount']}') ?? Decimal.zero,
        taxRate: Decimal.tryParse('${line['tax_rate']}') ?? Decimal.zero,
      );
    }).toList();

    final totals = PricingEngine.calculateSaleTotals(lineAmounts);
    return PosSaleTotals(
      subtotal: totals['subtotal']!,
      totalDiscount: totals['total_discount']!,
      totalTax: totals['total_tax']!,
      totalAmount: totals['total_amount']!,
    );
  }

  /// Distributes cart discount into line payloads for API request.
  static List<Map<String, dynamic>> buildSaleLines({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
  }) {
    if (items.isEmpty) return [];

    final subtotal = sumSubtotal(items);
    final distributedAmounts = _distributeFixedCartDiscount(
      items: items,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountValue,
      subtotal: subtotal,
    );

    return List.generate(items.length, (index) {
      final item = items[index];
      var discountPct = item.effectiveDiscountPct;
      var discountAmount = item.effectiveDiscountAmount;

      if (cartDiscountType == 'percentage' && cartDiscountValue > Decimal.zero) {
        discountPct = discountPct + cartDiscountValue;
      } else if (cartDiscountType == 'fixed' && cartDiscountValue > Decimal.zero) {
        discountAmount = discountAmount + distributedAmounts[index];
      }

      return {
        'product_id': item.productId,
        if (item.variationId != null) 'variation_id': item.variationId,
        'qty': DecimalUtils.format(item.qty),
        'unit_price': DecimalUtils.format(
          item.modifiers.isEmpty ? item.unitPrice : item.baseUnitPrice,
        ),
        'discount_pct': DecimalUtils.format(discountPct),
        'discount_amount': DecimalUtils.format(discountAmount),
        'tax_rate': DecimalUtils.format(item.effectiveTaxRate),
        if (item.lineNote != null && item.lineNote!.isNotEmpty)
          'notes': item.lineNote,
        if (item.modifiers.isNotEmpty)
          'modifier_ids':
              item.modifiers.map((modifier) => modifier.modifierId).toList(),
        'line_order': index + 1,
      };
    });
  }

  static List<Decimal> _distributeFixedCartDiscount({
    required List<CartItemModel> items,
    required String? cartDiscountType,
    required Decimal cartDiscountValue,
    required Decimal subtotal,
  }) {
    final result = List<Decimal>.filled(items.length, Decimal.zero);
    if (cartDiscountType != 'fixed' ||
        cartDiscountValue <= Decimal.zero ||
        subtotal <= Decimal.zero) {
      return result;
    }

    var distributed = Decimal.zero;
    for (var i = 0; i < items.length; i++) {
      if (i == items.length - 1) {
        result[i] = cartDiscountValue - distributed;
      } else {
        final lineSubtotal = items[i].lineSubtotal;
        final share = lineSubtotal.toDouble() / subtotal.toDouble();
        final lineDiscount = Decimal.parse(
          (cartDiscountValue.toDouble() * share).toStringAsFixed(2),
        );
        result[i] = lineDiscount;
        distributed = distributed + lineDiscount;
      }
    }
    return result;
  }
}
