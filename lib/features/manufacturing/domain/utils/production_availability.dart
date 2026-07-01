import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';

class IngredientAvailabilityRow {
  const IngredientAvailabilityRow({
    required this.productId,
    this.variationId,
    required this.productName,
    required this.requiredQty,
    required this.availableQty,
    required this.isShort,
  });

  final String productId;
  final String? variationId;
  final String productName;
  final Decimal requiredQty;
  final Decimal availableQty;
  final bool isShort;
}

String _balanceKey(String productId, String? variationId) =>
    '$productId::${variationId ?? ''}';

Decimal _parseQty(String value) =>
    DecimalUtils.roundMoney(Decimal.parse(value), fractionDigits: 4);

/// Joins BOM preview requirements with branch stock balances.
List<IngredientAvailabilityRow> joinPreviewWithStock({
  required BomPreviewModel preview,
  required List<StockBalanceModel> balances,
  required bool allowNegativeStock,
}) {
  final availableByKey = <String, Decimal>{};
  for (final balance in balances) {
    final key = _balanceKey(balance.productId, balance.variationId);
    final qty = _parseQty(balance.currentQty);
    availableByKey[key] = (availableByKey[key] ?? Decimal.zero) + qty;
  }

  return preview.lines.map((line) {
    final key = _balanceKey(
      line.ingredientProductId,
      line.ingredientVariationId,
    );
    final requiredQty = _parseQty(line.totalQtyRequired);
    final availableQty = availableByKey[key] ?? Decimal.zero;
    final isShort = !allowNegativeStock && requiredQty > availableQty;

    return IngredientAvailabilityRow(
      productId: line.ingredientProductId,
      variationId: line.ingredientVariationId,
      productName: line.ingredientProductName,
      requiredQty: requiredQty,
      availableQty: availableQty,
      isShort: isShort,
    );
  }).toList();
}

bool hasIngredientShortfall(List<IngredientAvailabilityRow> rows) =>
    rows.any((row) => row.isShort);
