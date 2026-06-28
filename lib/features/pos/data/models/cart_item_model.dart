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

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
        'product_name': productName,
        if (variationName != null) 'variation_name': variationName,
        if (sku != null) 'sku': sku,
        'unit_price': unitPrice.toString(),
        'qty': qty.toString(),
        if (itemDiscountPct != null)
          'item_discount_pct': itemDiscountPct!.toString(),
        if (itemDiscountAmount != null)
          'item_discount_amount': itemDiscountAmount!.toString(),
        if (taxRateId != null) 'tax_rate_id': taxRateId,
        if (taxRateName != null) 'tax_rate_name': taxRateName,
        if (taxRate != null) 'tax_rate': taxRate!.toString(),
        if (lineNote != null) 'line_note': lineNote,
        if (maxAvailableStock != null)
          'max_available_stock': maxAvailableStock!.toString(),
        'price_manual': priceManual,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      productName: json['product_name'] as String,
      variationName: json['variation_name'] as String?,
      sku: json['sku'] as String?,
      unitPrice: Decimal.tryParse(json['unit_price']?.toString() ?? '') ??
          Decimal.zero,
      qty: Decimal.tryParse(json['qty']?.toString() ?? '') ?? Decimal.one,
      itemDiscountPct: json['item_discount_pct'] != null
          ? Decimal.tryParse(json['item_discount_pct'].toString())
          : null,
      itemDiscountAmount: json['item_discount_amount'] != null
          ? Decimal.tryParse(json['item_discount_amount'].toString())
          : null,
      taxRateId: json['tax_rate_id'] as String?,
      taxRateName: json['tax_rate_name'] as String?,
      taxRate: json['tax_rate'] != null
          ? Decimal.tryParse(json['tax_rate'].toString())
          : null,
      lineNote: json['line_note'] as String?,
      maxAvailableStock: json['max_available_stock'] != null
          ? Decimal.tryParse(json['max_available_stock'].toString())
          : null,
      priceManual: json['price_manual'] as bool? ?? false,
    );
  }
}
