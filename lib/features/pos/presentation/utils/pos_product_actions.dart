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
  debugPrint(
    '[POS:AddToCart] product="${product.name}" id=${product.id} '
    'variationId=$variationId manualPrice=$manualUnitPrice',
  );
  final outcome = await cubit.addToCart(
    product,
    variationId: variationId,
    manualUnitPrice: manualUnitPrice,
  );
  debugPrint('[POS:AddToCart] outcome=${outcome.result} message=${outcome.message}');

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
  debugPrint('[POS:GridTap] product="${product.name}" id=${product.id}');
  final details = await cubit.getProductDetails(product.id);
  if (!context.mounted) {
    debugPrint('[POS:GridTap] ABORT — context unmounted after getProductDetails');
    return false;
  }

  final variationCount = details?.variations.length ?? 0;
  debugPrint('[POS:GridTap] variations=$variationCount');

  if (details != null && details.variations.length > 1) {
    debugPrint('[POS:GridTap] MULTI-variation → show picker');
    final variation = await showModalBottomSheet<VariationModel>(
      context: context,
      builder: (ctx) => _VariationPicker(variations: details.variations),
    );
    if (variation == null) {
      debugPrint('[POS:GridTap] picker cancelled');
      return false;
    }
    debugPrint('[POS:GridTap] picked variation="${variation.name}" id=${variation.id}');
    return addProductWithPricePrompt(
      context,
      cubit,
      product: product,
      variationId: variation.id,
      variationName: variation.name,
    );
  }

  debugPrint('[POS:GridTap] SINGLE/no-variation → add directly');
  return addProductWithPricePrompt(context, cubit, product: product);
}

Future<bool> addBarcodeWithPricePrompt(
  BuildContext context,
  PosCubit cubit,
  String barcode,
) async {
  debugPrint('[POS:Barcode] lookup barcode="$barcode"');
  final product = await cubit.getListItemByBarcode(barcode);
  if (product == null) {
    debugPrint('[POS:Barcode] NOT FOUND for "$barcode"');
    return false;
  }
  if (!context.mounted) {
    debugPrint('[POS:Barcode] ABORT — context unmounted');
    return false;
  }
  debugPrint('[POS:Barcode] FOUND "${product.name}" id=${product.id} → grid tap flow');
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
