import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';

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
    Decimal? cartDiscount,
  }) {
    final discount = cartDiscount ?? Decimal.zero;
    final itemDiscounts = sumItemDiscounts(items);
    final tax = sumTax(items);
    final subtotal = sumSubtotal(items);
    final total = subtotal - itemDiscounts - discount + tax;
    return total < Decimal.zero ? Decimal.zero : total;
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
        'unit_price': DecimalUtils.format(item.unitPrice),
        'discount_pct': DecimalUtils.format(discountPct),
        'discount_amount': DecimalUtils.format(discountAmount),
        'tax_rate': DecimalUtils.format(item.effectiveTaxRate),
        if (item.lineNote != null && item.lineNote!.isNotEmpty)
          'notes': item.lineNote,
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
