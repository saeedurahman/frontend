import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';

void main() {
  const preview = BomPreviewModel(
    bomHeaderId: 'bom-1',
    productId: 'finished-1',
    outputQty: '10',
    qtyToProduce: '20',
    lines: [
      BomPreviewLineModel(
        ingredientProductId: 'flour-id',
        ingredientProductName: 'Flour',
        qtyPerOutputUnit: '0.55',
        totalQtyRequired: '11',
      ),
      BomPreviewLineModel(
        ingredientProductId: 'sugar-id',
        ingredientProductName: 'Sugar',
        qtyPerOutputUnit: '0.2',
        totalQtyRequired: '4',
      ),
    ],
  );

  group('joinPreviewWithStock', () {
    test('flags shortfall when required exceeds available', () {
      final rows = joinPreviewWithStock(
        preview: preview,
        allowNegativeStock: false,
        balances: const [
          StockBalanceModel(
            productId: 'flour-id',
            branchId: 'branch-1',
            currentQty: '8',
          ),
          StockBalanceModel(
            productId: 'sugar-id',
            branchId: 'branch-1',
            currentQty: '10',
          ),
        ],
      );

      expect(rows, hasLength(2));
      expect(rows[0].isShort, isTrue);
      expect(rows[0].requiredQty, Decimal.parse('11'));
      expect(rows[0].availableQty, Decimal.parse('8'));
      expect(rows[1].isShort, isFalse);
    });

    test('does not flag shortfall when negative stock allowed', () {
      final rows = joinPreviewWithStock(
        preview: preview,
        allowNegativeStock: true,
        balances: const [
          StockBalanceModel(
            productId: 'flour-id',
            branchId: 'branch-1',
            currentQty: '0',
          ),
        ],
      );

      expect(rows.first.isShort, isFalse);
    });

    test('sums balances for matching product and variation', () {
      final rows = joinPreviewWithStock(
        preview: const BomPreviewModel(
          bomHeaderId: 'bom-1',
          productId: 'finished-1',
          outputQty: '1',
          qtyToProduce: '1',
          lines: [
            BomPreviewLineModel(
              ingredientProductId: 'flour-id',
              ingredientProductName: 'Flour',
              ingredientVariationId: 'var-1',
              qtyPerOutputUnit: '2',
              totalQtyRequired: '2',
            ),
          ],
        ),
        allowNegativeStock: false,
        balances: const [
          StockBalanceModel(
            productId: 'flour-id',
            variationId: 'var-1',
            branchId: 'branch-1',
            currentQty: '1',
          ),
          StockBalanceModel(
            productId: 'flour-id',
            variationId: 'var-1',
            branchId: 'branch-1',
            currentQty: '1.5',
          ),
        ],
      );

      expect(rows.single.availableQty, Decimal.parse('2.5'));
      expect(rows.single.isShort, isFalse);
    });
  });

  group('hasIngredientShortfall', () {
    test('returns true when any row is short', () {
      expect(
        hasIngredientShortfall([
          IngredientAvailabilityRow(
            productId: 'a',
            productName: 'A',
            requiredQty: Decimal.parse('1'),
            availableQty: Decimal.parse('2'),
            isShort: false,
          ),
          IngredientAvailabilityRow(
            productId: 'b',
            productName: 'B',
            requiredQty: Decimal.parse('3'),
            availableQty: Decimal.parse('1'),
            isShort: true,
          ),
        ]),
        isTrue,
      );
    });
  });
}
