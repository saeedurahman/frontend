import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/manufacturing/domain/utils/bom_qty_calculator.dart';

void main() {
  group('computeIngredientQtyForProduction', () {
    test('matches backend BOM preview case (flour, 10% wastage)', () {
      final result = computeIngredientQtyForProduction(
        qtyRequired: Decimal.parse('5'),
        outputQty: Decimal.parse('10'),
        wastagePct: Decimal.parse('10'),
        qtyToProduce: Decimal.parse('20'),
      );

      expect(result.perUnit, Decimal.parse('0.55'));
      expect(result.total, Decimal.parse('11'));
    });

    test('zero wastage scales linearly with batch qty', () {
      final result = computeIngredientQtyForProduction(
        qtyRequired: Decimal.parse('2'),
        outputQty: Decimal.parse('1'),
        wastagePct: Decimal.zero,
        qtyToProduce: Decimal.parse('5'),
      );

      expect(result.perUnit, Decimal.parse('2'));
      expect(result.total, Decimal.parse('10'));
    });

    test('throws when output qty is zero', () {
      expect(
        () => computeIngredientQtyForProduction(
          qtyRequired: Decimal.one,
          outputQty: Decimal.zero,
          wastagePct: Decimal.zero,
          qtyToProduce: Decimal.one,
        ),
        throwsArgumentError,
      );
    });
  });

  group('computeBomPreviewLines', () {
    test('returns one preview row per ingredient line', () {
      final lines = computeBomPreviewLines(
        outputQty: Decimal.parse('10'),
        batchQty: Decimal.parse('20'),
        lines: [
          (
            ingredientProductId: 'flour-id',
            ingredientProductName: 'Flour',
            ingredientVariationId: null,
            qtyRequired: Decimal.parse('5'),
            wastagePct: Decimal.parse('10'),
          ),
        ],
      );

      expect(lines, hasLength(1));
      expect(lines.first.ingredientProductName, 'Flour');
      expect(lines.first.totalQtyRequired, Decimal.parse('11'));
    });
  });
}
