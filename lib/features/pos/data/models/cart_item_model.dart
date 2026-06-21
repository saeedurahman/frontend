import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';

/// Local cart line — not serialized from API.
class CartItemModel {
  const CartItemModel({
    required this.productId,
    this.variationId,
    required this.productName,
    this.variationName,
    this.sku,
    required this.unitPrice,
    required this.qty,
    this.itemDiscountPct,
    this.itemDiscountAmount,
    this.taxRateId,
    this.taxRateName,
    this.taxRate,
    this.lineNote,
    this.maxAvailableStock,
    this.priceManual = false,
  });

  final String productId;
  final String? variationId;
  final String productName;
  final String? variationName;
  final String? sku;
  final Decimal unitPrice;
  final Decimal qty;
  final Decimal? itemDiscountPct;
  final Decimal? itemDiscountAmount;
  final String? taxRateId;
  final String? taxRateName;
  final Decimal? taxRate;
  final String? lineNote;
  final Decimal? maxAvailableStock;
  final bool priceManual;

  Decimal get effectiveDiscountPct => itemDiscountPct ?? Decimal.zero;
  Decimal get effectiveDiscountAmount => itemDiscountAmount ?? Decimal.zero;
  Decimal get effectiveTaxRate => taxRate ?? Decimal.zero;

  Decimal get lineSubtotal => unitPrice * qty;

  Decimal get lineDiscount {
    final pctDiscount = DecimalUtils.fromRational(
      lineSubtotal * effectiveDiscountPct / Decimal.fromInt(100),
    );
    return DecimalUtils.roundMoney(pctDiscount + effectiveDiscountAmount);
  }

  Decimal get lineTax {
    final taxable = lineSubtotal - lineDiscount;
    if (taxable <= Decimal.zero) return Decimal.zero;
    return DecimalUtils.fromRational(
      taxable * effectiveTaxRate / Decimal.fromInt(100),
    );
  }

  Decimal get lineTotal {
    final total = lineSubtotal - lineDiscount + lineTax;
    return total < Decimal.zero ? Decimal.zero : total;
  }

  CartItemModel copyWith({
    String? productId,
    String? variationId,
    String? productName,
    String? variationName,
    String? sku,
    Decimal? unitPrice,
    Decimal? qty,
    Decimal? itemDiscountPct,
    Decimal? itemDiscountAmount,
    String? taxRateId,
    String? taxRateName,
    Decimal? taxRate,
    String? lineNote,
    Decimal? maxAvailableStock,
    bool? priceManual,
    bool clearLineNote = false,
    bool clearTax = false,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      variationId: variationId ?? this.variationId,
      productName: productName ?? this.productName,
      variationName: variationName ?? this.variationName,
      sku: sku ?? this.sku,
      unitPrice: unitPrice ?? this.unitPrice,
      qty: qty ?? this.qty,
      itemDiscountPct: itemDiscountPct ?? this.itemDiscountPct,
      itemDiscountAmount: itemDiscountAmount ?? this.itemDiscountAmount,
      taxRateId: clearTax ? null : (taxRateId ?? this.taxRateId),
      taxRateName: clearTax ? null : (taxRateName ?? this.taxRateName),
      taxRate: clearTax ? null : (taxRate ?? this.taxRate),
      lineNote: clearLineNote ? null : (lineNote ?? this.lineNote),
      maxAvailableStock: maxAvailableStock ?? this.maxAvailableStock,
      priceManual: priceManual ?? this.priceManual,
    );
  }

  String get cartKey =>
      variationId != null ? '$productId:$variationId' : productId;
}
