import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

const _lineNotesPrefix = 'restaurant:';

/// Maps dine-in tab sale lines ↔ local cart lines.
abstract final class DineInCartMapper {
  static List<CartItemModel> cartItemsFromSale(SaleResponseModel sale) {
    return sale.lines.map(cartItemFromSaleLine).toList();
  }

  static CartItemModel cartItemFromSaleLine(SaleLineModel line) {
    final (kitchenNotes, modifiers) = _decodeLineNotes(line.notes);
    final baseUnitPrice =
        Decimal.tryParse(line.unitPrice) ?? Decimal.zero;
    final modifierTotal = cartModifierTotalPerUnit(modifiers);
    return CartItemModel(
      productId: line.productId,
      variationId: line.variationId,
      productName: line.productName ?? 'Product',
      variationName: line.variationName,
      unitPrice: baseUnitPrice + modifierTotal,
      qty: Decimal.tryParse(line.qty) ?? Decimal.one,
      itemDiscountPct: Decimal.tryParse(line.discountPct),
      itemDiscountAmount: Decimal.tryParse(line.discountAmount),
      taxRate: Decimal.tryParse(line.taxRate),
      lineNote: kitchenNotes,
      serverLineId: line.id,
      modifiers: modifiers,
    );
  }

  static TabSaleLineRequest toTabLineRequest(
    CartItemModel item, {
    required int lineOrder,
    Decimal? syncQty,
  }) {
    final qty = syncQty ?? item.qty;
    return TabSaleLineRequest(
      productId: item.productId,
      variationId: item.variationId,
      qty: DecimalUtils.format(qty),
      unitPrice: DecimalUtils.format(
        item.modifiers.isEmpty ? item.unitPrice : item.baseUnitPrice,
      ),
      discountPct: DecimalUtils.format(item.effectiveDiscountPct),
      discountAmount: DecimalUtils.format(item.effectiveDiscountAmount),
      taxRate: DecimalUtils.format(item.effectiveTaxRate),
      notes: item.lineNote,
      lineOrder: lineOrder,
      modifierIds: item.modifiers.map((m) => m.modifierId).toList(),
    );
  }

  static (String?, List<CartLineModifierModel>) _decodeLineNotes(String? notes) {
    if (notes == null || !notes.startsWith(_lineNotesPrefix)) {
      return (notes, const []);
    }

    try {
      final payload = jsonDecode(notes.substring(_lineNotesPrefix.length))
          as Map<String, dynamic>;
      final kitchenNotes = payload['kitchen_notes'] as String?;
      final rawModifiers = payload['modifiers'];
      if (rawModifiers is! List) {
        return (kitchenNotes, const []);
      }

      final modifiers = rawModifiers
          .whereType<Map>()
          .map((entry) {
            final map = Map<String, dynamic>.from(entry);
            final modifierId = map['modifier_id']?.toString();
            final name = map['name']?.toString();
            if (modifierId == null || name == null) return null;
            return CartLineModifierModel(
              modifierId: modifierId,
              groupId: '',
              groupName: '',
              modifierName: name,
              priceDelta:
                  Decimal.tryParse(map['price_delta']?.toString() ?? '') ??
                      Decimal.zero,
            );
          })
          .whereType<CartLineModifierModel>()
          .toList();

      return (kitchenNotes, modifiers);
    } catch (_) {
      return (notes, const []);
    }
  }
}
