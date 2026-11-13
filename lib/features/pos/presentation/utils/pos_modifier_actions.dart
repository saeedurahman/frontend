import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/offline/product_modifier_cache.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_perf.dart';
import 'package:frantend/features/restaurant/presentation/widgets/modifier_picker_sheet.dart';

/// Shows [ModifierPickerSheet] when the product has modifier groups.
///
/// The groups come from the local copy ([ProductModifierCache]); this is on
/// the add-to-cart path and must never wait for the server.
///
/// Returns null when the user cancels, empty list when the product has no groups.
Future<List<CartLineModifierModel>?> pickProductModifiers(
  BuildContext context, {
  required String productId,
  required String productName,
  ProductModifierCache? cache,
}) async {
  final source = cache ??
      (sl.isRegistered<ProductModifierCache>()
          ? sl<ProductModifierCache>()
          : null);
  if (source == null || !source.enabled) return const [];

  final groups = await PosPerf.measure(
    PosPerf.modifierLookup,
    budget: PosPerf.addToCartBudget,
    () => source.groupsFor(productId),
  );
  if (groups.isEmpty) return const [];

  if (!context.mounted) return null;

  return showModalBottomSheet<List<CartLineModifierModel>>(
    context: context,
    isScrollControlled: true,
    builder: (_) => ModifierPickerSheet(
      productName: productName,
      groups: groups,
    ),
  );
}
