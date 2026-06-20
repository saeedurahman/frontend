import 'package:frantend/features/products/data/models/product_list_item_model.dart';

enum AddToCartResult {
  added,
  needsVariation,
  needsPrice,
  insufficientStock,
}

/// Context for showing the manual price dialog after [AddToCartResult.needsPrice].
class PendingPricePrompt {
  const PendingPricePrompt({
    required this.product,
    this.variationId,
    this.variationName,
  });

  final ProductListItemModel product;
  final String? variationId;
  final String? variationName;
}
