import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/pos/domain/utils/dine_in_cart_mapper.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

void main() {
  group('DineInCartMapper', () {
    test('toTabLineRequest sends base unit price and modifier ids', () {
      final item = CartItemModel(
        productId: 'prod-1',
        productName: 'Burger',
        unitPrice: Decimal.parse('550'),
        qty: Decimal.one,
        modifiers: [
          CartLineModifierModel(
            modifierId: 'mod-1',
            groupId: 'grp-1',
            groupName: 'Add-ons',
            modifierName: 'Cheese',
            priceDelta: Decimal.parse('50'),
          ),
        ],
      );

      final request = DineInCartMapper.toTabLineRequest(item, lineOrder: 1);
      expect(request.unitPrice, '500.00');
      expect(request.modifierIds, ['mod-1']);
      expect(request.qty, '1.00');
    });

    test('cartItemsFromSale decodes restaurant line notes', () {
      const sale = SaleResponseModel(
        id: 'sale-1',
        branchId: 'branch-1',
        saleType: 'dine_in',
        saleStatus: 'held',
        lines: [
          SaleLineModel(
            id: 'line-1',
            productId: 'prod-1',
            qty: '2',
            unitPrice: '400',
            notes:
                'restaurant:{"kitchen_notes":"No onion","modifiers":[{"modifier_id":"mod-2","name":"Extra sauce","price_delta":"25"}]}',
            productName: 'Pasta',
          ),
        ],
      );

      final items = DineInCartMapper.cartItemsFromSale(sale);
      expect(items, hasLength(1));
      expect(items.first.serverLineId, 'line-1');
      expect(items.first.qty, Decimal.parse('2'));
      expect(items.first.unitPrice, Decimal.parse('425'));
      expect(items.first.lineNote, 'No onion');
      expect(items.first.modifiers.single.modifierName, 'Extra sauce');
    });
  });
}
