import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';

/// Mirrors backend [compute_ingredient_qty_for_production] for BOM form preview.
class BomQtyPreviewLine {
  const BomQtyPreviewLine({
    required this.ingredientProductId,
    this.ingredientProductName,
    this.ingredientVariationId,
    required this.qtyPerOutputUnit,
    required this.totalQtyRequired,
    required this.wastagePct,
  });

  final String ingredientProductId;
  final String? ingredientProductName;
  final String? ingredientVariationId;
  final Decimal qtyPerOutputUnit;
  final Decimal totalQtyRequired;
  final Decimal wastagePct;
}

/// Returns per-unit (with wastage) and total qty for a batch.
({Decimal perUnit, Decimal total}) computeIngredientQtyForProduction({
  required Decimal qtyRequired,
  required Decimal outputQty,
  required Decimal wastagePct,
  required Decimal qtyToProduce,
}) {
  if (outputQty <= Decimal.zero) {
    throw ArgumentError('outputQty must be positive');
  }

  final wastageFactor = Decimal.one +
      DecimalUtils.fromRational(wastagePct / Decimal.fromInt(100));
  final perUnit = DecimalUtils.roundMoney(
    DecimalUtils.fromRational(qtyRequired / outputQty) * wastageFactor,
  );
  final total = DecimalUtils.roundMoney(perUnit * qtyToProduce);
  return (perUnit: perUnit, total: total);
}

List<BomQtyPreviewLine> computeBomPreviewLines({
  required List<({
    String ingredientProductId,
    String? ingredientProductName,
    String? ingredientVariationId,
    Decimal qtyRequired,
    Decimal wastagePct,
  })> lines,
  required Decimal outputQty,
  required Decimal batchQty,
}) {
  return lines.map((line) {
    final computed = computeIngredientQtyForProduction(
      qtyRequired: line.qtyRequired,
      outputQty: outputQty,
      wastagePct: line.wastagePct,
      qtyToProduce: batchQty,
    );
    return BomQtyPreviewLine(
      ingredientProductId: line.ingredientProductId,
      ingredientProductName: line.ingredientProductName,
      ingredientVariationId: line.ingredientVariationId,
      qtyPerOutputUnit: computed.perUnit,
      totalQtyRequired: computed.total,
      wastagePct: line.wastagePct,
    );
  }).toList();
}
