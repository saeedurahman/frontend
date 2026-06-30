import 'package:decimal/decimal.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';

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
    this.serverLineId,
    this.modifiers = const [],
  });

  final String productId;
  final String? variationId;
  final String productName;
  final String? variationName;
  final String? sku;
  /// Per-unit price including modifier adjustments.
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
  /// Set after dine-in line sync (Phase 4).
  final String? serverLineId;
  final List<CartLineModifierModel> modifiers;

  Decimal get modifierTotalPerUnit => cartModifierTotalPerUnit(modifiers);

  Decimal get baseUnitPrice => unitPrice - modifierTotalPerUnit;

  Decimal get effectiveDiscountPct => itemDiscountPct ?? Decimal.zero;
  Decimal get effectiveDiscountAmount => itemDiscountAmount ?? Decimal.zero;
  Decimal get effectiveTaxRate => taxRate ?? Decimal.zero;

  Decimal get lineSubtotal => unitPrice * qty;

  Decimal get lineDiscount {
    final amounts = PricingEngine.calculateLineTotal(
      qty: qty,
      unitPrice: unitPrice,
      discountPct: effectiveDiscountPct,
      discountAmount: effectiveDiscountAmount,
      taxRate: Decimal.zero,
    );
    return amounts.effectiveDiscount;
  }

  Decimal get lineTax {
    final amounts = PricingEngine.calculateLineTotal(
      qty: qty,
      unitPrice: unitPrice,
      discountPct: effectiveDiscountPct,
      discountAmount: effectiveDiscountAmount,
      taxRate: effectiveTaxRate,
    );
    return amounts.taxAmount;
  }

  Decimal get lineTotal {
    final amounts = PricingEngine.calculateLineTotal(
      qty: qty,
      unitPrice: unitPrice,
      discountPct: effectiveDiscountPct,
      discountAmount: effectiveDiscountAmount,
      taxRate: effectiveTaxRate,
    );
    return amounts.lineTotal;
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
    String? serverLineId,
    List<CartLineModifierModel>? modifiers,
    bool clearLineNote = false,
    bool clearTax = false,
    bool clearServerLineId = false,
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
      serverLineId:
          clearServerLineId ? null : (serverLineId ?? this.serverLineId),
      modifiers: modifiers ?? this.modifiers,
    );
  }

  String get cartKey => buildCartLineKey(
        productId: productId,
        variationId: variationId,
        modifiers: modifiers,
      );

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
        if (serverLineId != null) 'server_line_id': serverLineId,
        if (modifiers.isNotEmpty)
          'modifiers': modifiers.map((m) => m.toJson()).toList(),
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final rawModifiers = json['modifiers'] as List<dynamic>? ?? const [];
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
      serverLineId: json['server_line_id'] as String?,
      modifiers: rawModifiers
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (entry) => CartLineModifierModel.fromJson(
              Map<String, dynamic>.from(entry),
            ),
          )
          .toList(),
    );
  }
}
