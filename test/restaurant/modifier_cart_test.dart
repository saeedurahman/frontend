import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/presentation/utils/modifier_selection_validator.dart';

void main() {
  group('buildCartLineKey', () {
    test('different modifier sets produce different keys', () {
      final modA = CartLineModifierModel(
        modifierId: 'mod-a',
        groupId: 'grp-1',
        groupName: 'Size',
        modifierName: 'Large',
        priceDelta: Decimal.fromInt(50),
      );
      final modB = CartLineModifierModel(
        modifierId: 'mod-b',
        groupId: 'grp-1',
        groupName: 'Size',
        modifierName: 'Small',
        priceDelta: Decimal.zero,
      );

      final keyA = buildCartLineKey(
        productId: 'prod-1',
        variationId: 'var-1',
        modifiers: [modA],
      );
      final keyB = buildCartLineKey(
        productId: 'prod-1',
        variationId: 'var-1',
        modifiers: [modB],
      );

      expect(keyA, isNot(keyB));
      expect(keyA, contains('mod-a'));
    });
  });

  group('CartItemModel', () {
    test('baseUnitPrice excludes modifier deltas', () {
      final item = CartItemModel(
        productId: 'prod-1',
        productName: 'Burger',
        unitPrice: Decimal.fromInt(550),
        qty: Decimal.one,
        modifiers: [
          CartLineModifierModel(
            modifierId: 'mod-1',
            groupId: 'grp-1',
            groupName: 'Extra',
            modifierName: 'Cheese',
            priceDelta: Decimal.fromInt(50),
          ),
        ],
      );

      expect(item.baseUnitPrice, Decimal.fromInt(500));
      expect(item.modifierTotalPerUnit, Decimal.fromInt(50));
    });
  });

  group('ModifierSelectionValidator', () {
    const group = ModifierGroupModel(
      id: 'grp-1',
      businessId: 'biz-1',
      name: 'Extras',
      selectionType: 'multiple',
      minSelections: 1,
      maxSelections: 2,
      isRequired: true,
      modifiers: [
        ModifierModel(
          id: 'mod-1',
          businessId: 'biz-1',
          modifierGroupId: 'grp-1',
          name: 'Cheese',
        ),
        ModifierModel(
          id: 'mod-2',
          businessId: 'biz-1',
          modifierGroupId: 'grp-1',
          name: 'Olives',
        ),
      ],
    );

    test('blocks when required group has no selection', () {
      expect(
        ModifierSelectionValidator.validateGroup(
          group: group,
          selectedModifierIds: const {},
        ),
        isNotNull,
      );
    });

    test('accepts valid selection count', () {
      expect(
        ModifierSelectionValidator.validateGroup(
          group: group,
          selectedModifierIds: const {'mod-1'},
        ),
        isNull,
      );
    });
  });

  group('buildSaleLines', () {
    test('includes modifier_ids and base unit price', () {
      final item = CartItemModel(
        productId: 'prod-1',
        productName: 'Burger',
        unitPrice: Decimal.fromInt(550),
        qty: Decimal.one,
        modifiers: [
          CartLineModifierModel(
            modifierId: 'mod-1',
            groupId: 'grp-1',
            groupName: 'Extra',
            modifierName: 'Cheese',
            priceDelta: Decimal.fromInt(50),
          ),
        ],
      );

      final lines = PosCalculations.buildSaleLines(
        items: [item],
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );

      expect(lines.single['unit_price'], '500.00');
      expect(lines.single['modifier_ids'], ['mod-1']);
    });
  });
}
