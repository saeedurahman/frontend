import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';

enum AddToCartResult {
  added,
  needsVariation,
  needsPrice,
  insufficientStock,
  syncFailed,
}

/// Context for showing the manual price dialog after [AddToCartResult.needsPrice].
class PendingPricePrompt {
  const PendingPricePrompt({
    required this.product,
    this.variationId,
    this.variationName,
    this.modifiers = const [],
  });

  final ProductListItemModel product;
  final String? variationId;
  final String? variationName;
  final List<CartLineModifierModel> modifiers;
}
