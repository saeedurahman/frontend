import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/restaurant/presentation/widgets/modifier_picker_sheet.dart';

/// Fetches product modifier groups and shows [ModifierPickerSheet] when needed.
///
/// Returns null when the user cancels, empty list when the product has no groups.
Future<List<CartLineModifierModel>?> pickProductModifiers(
  BuildContext context, {
  required String productId,
  required String productName,
}) async {
  final result = await sl<GetProductModifierGroupsUseCase>()(productId);
  final groups = result.fold(
    (_) => <ModifierGroupModel>[],
    (list) => list
        .where(
          (group) =>
              group.isActive &&
              group.modifiers.any((modifier) => modifier.isActive),
        )
        .toList(),
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
