import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_outcome.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_result.dart';
import 'package:frantend/features/pos/presentation/widgets/manual_price_dialog.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/utils/app_alerts.dart';

/// Adds a product to the cart, prompting for manual price when needed.
Future<bool> addProductWithPricePrompt(
  BuildContext context,
  PosCubit cubit, {
  required ProductListItemModel product,
  String? variationId,
  String? variationName,
  Decimal? manualUnitPrice,
}) async {
  final outcome = await cubit.addToCart(
    product,
    variationId: variationId,
    manualUnitPrice: manualUnitPrice,
  );

  switch (outcome.result) {
    case AddToCartResult.added:
      return true;
    case AddToCartResult.needsVariation:
      return false;
    case AddToCartResult.needsPrice:
      final pending = outcome.pendingPrice;
      if (pending == null || !context.mounted) return false;

      final price = await ManualPriceDialog.show(
        context,
        productName: pending.product.name,
        variationName: pending.variationName,
      );
      if (price == null || !context.mounted) return false;

      return addProductWithPricePrompt(
        context,
        cubit,
        product: pending.product,
        variationId: pending.variationId,
        variationName: pending.variationName,
        manualUnitPrice: price,
      );
    case AddToCartResult.insufficientStock:
      if (context.mounted && outcome.message != null) {
        AppAlerts.showErrorMessage(context, outcome.message!);
      }
      return false;
  }
}

Future<bool> addProductFromGridTap(
  BuildContext context,
  PosCubit cubit,
  ProductListItemModel product,
) async {
  final details = await cubit.getProductDetails(product.id);
  if (!context.mounted) return false;

  if (details != null && details.variations.length > 1) {
    final variation = await showModalBottomSheet<VariationModel>(
      context: context,
      builder: (ctx) => _VariationPicker(variations: details.variations),
    );
    if (variation == null) return false;
    return addProductWithPricePrompt(
      context,
      cubit,
      product: product,
      variationId: variation.id,
      variationName: variation.name,
    );
  }

  return addProductWithPricePrompt(context, cubit, product: product);
}

Future<bool> addBarcodeWithPricePrompt(
  BuildContext context,
  PosCubit cubit,
  String barcode,
) async {
  final product = await cubit.getListItemByBarcode(barcode);
  if (product == null || !context.mounted) return false;
  return addProductFromGridTap(context, cubit, product);
}

class _VariationPicker extends StatelessWidget {
  const _VariationPicker({required this.variations});

  final List<VariationModel> variations;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Variation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...variations.map(
            (v) => ListTile(
              title: Text(v.name),
              subtitle: v.sku != null ? Text(v.sku!) : null,
              onTap: () => Navigator.pop(context, v),
            ),
          ),
        ],
      ),
    );
  }
}
