import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/shared/utils/quantity_expression.dart';
import 'package:frantend/shared/widgets/quantity/quantity_calculator_sheet.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_result.dart';
import 'package:frantend/features/pos/presentation/utils/pos_modifier_actions.dart';
import 'package:frantend/features/pos/presentation/widgets/manual_price_dialog.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/utils/app_alerts.dart';

/// Adds a product to the cart, optionally prompting for manual price when needed.
Future<bool> addProductWithPricePrompt(
  BuildContext context,
  PosCubit cubit, {
  required ProductListItemModel product,
  String? variationId,
  String? variationName,
  Decimal? manualUnitPrice,
  List<CartLineModifierModel> modifiers = const [],
  bool promptForPrice = true,
  Decimal? qty,
  bool rememberManualPrice = true,
}) async {
  debugPrint(
    '[POS:AddToCart] product="${product.name}" id=${product.id} '
    'variationId=$variationId manualPrice=$manualUnitPrice '
    'modifiers=${modifiers.length} qty=$qty',
  );
  final outcome = await cubit.addToCart(
    product,
    variationId: variationId,
    manualUnitPrice: manualUnitPrice,
    modifiers: modifiers,
    qty: qty,
    rememberManualPrice: rememberManualPrice,
  );
  debugPrint(
    '[POS:AddToCart] outcome=${outcome.result} message=${outcome.message}',
  );

  switch (outcome.result) {
    case AddToCartResult.added:
      // Added, but the shelf is nearly empty: tell the cashier.
      if (outcome.message != null && context.mounted) {
        AppAlerts.showInfoMessage(context, outcome.message!);
      }
      return true;
    case AddToCartResult.needsVariation:
      return false;
    case AddToCartResult.needsPrice:
      if (!promptForPrice) return false;

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
        modifiers: pending.modifiers,
        manualUnitPrice: price,
        qty: qty,
      );
    case AddToCartResult.insufficientStock:
      if (context.mounted && outcome.message != null) {
        AppAlerts.showErrorMessage(context, outcome.message!);
      }
      return false;
    case AddToCartResult.syncFailed:
      if (context.mounted && outcome.message != null) {
        AppAlerts.showErrorMessage(context, outcome.message!);
      }
      return false;
  }
}

Future<bool> addProductFromGridTap(
  BuildContext context,
  PosCubit cubit,
  ProductListItemModel product, {
  bool promptForPrice = true,
}) async {
  debugPrint('[POS:GridTap] product="${product.name}" id=${product.id}');
  final details = await cubit.getProductDetails(product.id);
  if (!context.mounted) {
    debugPrint(
      '[POS:GridTap] ABORT — context unmounted after getProductDetails',
    );
    return false;
  }

  final variationCount = details?.variations.length ?? 0;
  debugPrint('[POS:GridTap] variations=$variationCount');

  String? variationId;
  String? variationName;

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
    variationId = variation.id;
    variationName = variation.name;
    debugPrint(
      '[POS:GridTap] picked variation="${variation.name}" id=${variation.id}',
    );
  }

  if (!context.mounted) return false;

  final modifiers = await pickProductModifiers(
    context,
    productId: product.id,
    productName: product.name,
  );
  if (modifiers == null) {
    debugPrint('[POS:GridTap] modifier picker cancelled');
    return false;
  }

  if (!context.mounted) return false;

  debugPrint('[POS:GridTap] modifiers selected=${modifiers.length}');
  return addProductWithPricePrompt(
    context,
    cubit,
    product: product,
    variationId: variationId,
    variationName: variationName,
    modifiers: modifiers,
    promptForPrice: promptForPrice,
  );
}

// ── quantity calculator ────────────────────────────────────────────────────

/// Lets a popup hand keyboard focus back to the POS search box (the scanner
/// types there). Provided by the POS page; a no-op when absent.
class PosSearchFocus extends InheritedWidget {
  const PosSearchFocus({super.key, required this.node, required super.child});

  final FocusNode node;

  static void restore(BuildContext context) {
    if (!context.mounted) return;
    context
        .getInheritedWidgetOfExactType<PosSearchFocus>()
        ?.node
        .requestFocus();
  }

  @override
  bool updateShouldNotify(PosSearchFocus oldWidget) => node != oldWidget.node;
}

/// One quantity popup at a time: a fast double tap opens it once.
bool _quantityFlowBusy = false;

/// Shows a popup that is part of a quantity flow.
///
/// The guard is only held until the popup is on screen (from then on its
/// barrier swallows further taps) and taken again when it closes. It is
/// never held for as long as a popup is open: a popup torn down together
/// with its screen never completes, and must not lock the POS.
Future<T?> _modal<T>(Future<T?> Function() show) async {
  final future = show();
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => _quantityFlowBusy = false,
  );
  final result = await future;
  _quantityFlowBusy = true;
  return result;
}

Decimal? _stockOnHand(PosCubit cubit, String productId, ProductModel? details) {
  // Balances are loaded per product; they are exact for single-variation items.
  if ((details?.variations.length ?? 0) > 1) return null;
  return Decimal.tryParse(cubit.getDisplayStock(productId) ?? '');
}

QuantityCalculatorConfig _quantityConfig(
  PosCubit cubit, {
  required String productId,
  required String productName,
  required CartItemModel pricedLine,
  String? variationId,
  String? variationName,
  String? imageUrl,
  ProductModel? details,
  Decimal? unitPrice,
  Decimal? initialQuantity,
  bool canEditPrice = false,
  bool livePrice = false,
}) {
  UnitModel? unit = details?.baseUnit;
  for (final v in details?.variations ?? const <VariationModel>[]) {
    if (v.id == variationId && v.unit != null) unit = v.unit;
  }
  return QuantityCalculatorConfig(
    title: productName,
    subtitle: variationName,
    imageUrl: imageUrl ?? details?.imageUrl,
    unitPrice: unitPrice,
    priceUpdates: livePrice
        ? cubit.stream
            .map((_) =>
                cubit.getDisplayPrice(productId, variationId: variationId))
            .distinct()
        : null,
    unitLabel: unit?.symbol,
    allowDecimal: QuantityRules.unitAllowsDecimal(
      name: unit?.name,
      symbol: unit?.symbol,
    ),
    stock: _stockOnHand(cubit, productId, details),
    lowStockLevel: Decimal.tryParse(details?.minStockLevel ?? ''),
    // Only the owner's "do not sell below stock" setting blocks a sale.
    blockBelowStock: !cubit.allowBelowStock,
    initialQuantity: initialQuantity,
    canEditPrice: canEditPrice && cubit.canOverridePrice,
    // The cart's own maths (PricingEngine): discount and tax of the line.
    lineTotal: (qty, price) =>
        pricedLine.copyWith(qty: qty, unitPrice: price).lineTotal,
  );
}

/// Card tap / "Add to cart": asks for the quantity first (unless the device
/// setting "Ask quantity on product tap" is off), then adds the line.
///
/// A product that is already in the cart as one plain line opens in edit
/// mode (Update / Remove). Everything shown comes from the cubit's caches
/// and the local database, so the popup opens at once, also offline.
Future<bool> openProductFromGrid(
  BuildContext context,
  PosCubit cubit,
  ProductListItemModel product,
) async {
  if (!cubit.askQuantityOnTap) {
    return addProductFromGridTap(context, cubit, product);
  }
  if (_quantityFlowBusy) return false;
  _quantityFlowBusy = true;
  try {
    final details = await cubit.getProductDetails(product.id);
    if (!context.mounted) return false;

    // More than one variation: pick it first (it decides price and unit).
    String? pickedVariationId;
    VariationModel? variation;
    final variations = details?.variations ?? const <VariationModel>[];
    if (variations.length > 1) {
      variation = await _modal(
        () => showModalBottomSheet<VariationModel>(
          context: context,
          builder: (ctx) => _VariationPicker(variations: variations),
        ),
      );
      if (variation == null || !context.mounted) return false;
      pickedVariationId = variation.id;
    } else if (variations.isNotEmpty) {
      variation = variations.firstWhere(
        (v) => v.isDefault,
        orElse: () => variations.first,
      );
    }
    final variationId = variation?.id;

    // Already in the cart as one plain line: edit that line instead.
    final matches = <int>[
      for (var i = 0; i < cubit.state.cartItems.length; i++)
        if (cubit.state.cartItems[i].productId == product.id &&
            (variationId == null ||
                cubit.state.cartItems[i].variationId == variationId))
          i,
    ];
    if (matches.length == 1 &&
        cubit.state.cartItems[matches.single].modifiers.isEmpty) {
      _quantityFlowBusy = false;
      return await editCartLineQuantity(context, cubit, matches.single);
    }

    var price = await cubit.listPriceFor(
      product.id,
      variationId: variationId,
      details: details,
    );
    if (!context.mounted) return false;

    // No list price: the existing "set price" popup comes first.
    Decimal? typedPrice;
    if (price == null) {
      final variationName = pickedVariationId == null ? null : variation?.name;
      typedPrice = await _modal(
        () => ManualPriceDialog.show(
          context,
          productName: product.name,
          variationName: variationName,
        ),
      );
      if (typedPrice == null || !context.mounted) return false;
      price = typedPrice;
    }

    final defaultRate = cubit.state.defaultTaxRate;
    final unitPrice = price;
    final config = _quantityConfig(
      cubit,
      productId: product.id,
      productName: product.name,
      variationId: variationId,
      variationName: pickedVariationId == null ? null : variation?.name,
      imageUrl: product.imageUrl,
      details: details,
      unitPrice: unitPrice,
      canEditPrice: typedPrice == null,
      livePrice: typedPrice == null,
      pricedLine: CartItemModel(
        productId: product.id,
        productName: product.name,
        unitPrice: unitPrice,
        qty: Decimal.one,
        taxRate: defaultRate == null
            ? null
            : (Decimal.tryParse(defaultRate.rate) ?? Decimal.zero),
      ),
    );
    final result = await _modal(
      () => QuantityCalculatorSheet.show(context, config),
    );
    final qty = result?.quantity;
    if (qty == null || !context.mounted) return false;

    // Restaurant items: modifiers are chosen after the quantity.
    _quantityFlowBusy = false; // its own sheet guards itself
    final modifiers = await pickProductModifiers(
      context,
      productId: product.id,
      productName: product.name,
    );
    if (modifiers == null || !context.mounted) return false;

    final override = result?.unitPrice;
    return await addProductWithPricePrompt(
      context,
      cubit,
      product: product,
      variationId: pickedVariationId,
      variationName: pickedVariationId == null ? null : variation?.name,
      modifiers: modifiers,
      manualUnitPrice: override ?? typedPrice,
      // A price typed over a list price is for this sale only.
      rememberManualPrice: override == null,
      qty: qty,
      promptForPrice: false,
    );
  } finally {
    _quantityFlowBusy = false;
    if (context.mounted) PosSearchFocus.restore(context);
  }
}

/// Tap on a cart line's quantity: the same popup in edit mode. "Update"
/// replaces the quantity, "Remove" deletes the line.
Future<bool> editCartLineQuantity(
  BuildContext context,
  PosCubit cubit,
  int cartIndex,
) async {
  if (_quantityFlowBusy) return false;
  if (cartIndex < 0 || cartIndex >= cubit.state.cartItems.length) return false;
  _quantityFlowBusy = true;
  try {
    final item = cubit.state.cartItems[cartIndex];
    final key = item.cartKey;
    // Cached, else the local database (a resumed or table order was never
    // opened from the grid): the unit decides whether fractions are allowed.
    final details = await cubit.getProductDetails(item.productId);
    if (!context.mounted) return false;
    String? imageUrl;
    for (final p in cubit.state.products) {
      if (p.id == item.productId) imageUrl = p.imageUrl;
    }

    final config = _quantityConfig(
      cubit,
      productId: item.productId,
      productName: item.productName,
      variationId: item.variationId,
      variationName: item.variationName,
      imageUrl: imageUrl,
      details: details,
      unitPrice: item.unitPrice,
      initialQuantity: item.qty,
      canEditPrice: true,
      pricedLine: item,
    );
    final result = await _modal(
      () => QuantityCalculatorSheet.show(context, config),
    );
    if (result == null) return false;

    // The cart may have changed while the popup was open.
    final index = cubit.state.cartItems.indexWhere((i) => i.cartKey == key);
    if (index < 0) return false;
    if (result.action == QuantityCalculatorAction.remove) {
      cubit.removeFromCart(index);
      return true;
    }
    final price = result.unitPrice;
    if (price != null) cubit.updateCartItemPrice(index, price);
    cubit.updateCartItemQty(index, result.quantity!);
    return true;
  } finally {
    _quantityFlowBusy = false;
    if (context.mounted) PosSearchFocus.restore(context);
  }
}

/// Opens the manual price dialog, then adds the product with that price.
Future<bool> setProductPriceFromGrid(
  BuildContext context,
  PosCubit cubit,
  ProductListItemModel product,
) async {
  final details = await cubit.getProductDetails(product.id);
  if (!context.mounted) return false;

  String? variationId;
  String? variationName;

  if (details != null && details.variations.length > 1) {
    final variation = await showModalBottomSheet<VariationModel>(
      context: context,
      builder: (ctx) => _VariationPicker(variations: details.variations),
    );
    if (variation == null || !context.mounted) return false;
    variationId = variation.id;
    variationName = variation.name;
  }

  final modifiers = await pickProductModifiers(
    context,
    productId: product.id,
    productName: product.name,
  );
  if (modifiers == null || !context.mounted) return false;

  final price = await ManualPriceDialog.show(
    context,
    productName: product.name,
    variationName: variationName,
  );
  if (price == null || !context.mounted) return false;

  return addProductWithPricePrompt(
    context,
    cubit,
    product: product,
    variationId: variationId,
    variationName: variationName,
    modifiers: modifiers,
    manualUnitPrice: price,
    promptForPrice: false,
  );
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
  debugPrint(
    '[POS:Barcode] FOUND "${product.name}" id=${product.id} → grid tap flow',
  );
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
