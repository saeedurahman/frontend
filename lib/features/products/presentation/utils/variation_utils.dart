import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';

const _localPrefix = 'local:';

/// Stable dropdown value for a variation row (server id or local index key).
String variationDropdownValue(VariationFormItem variation, int index) =>
    variation.id ?? '$_localPrefix$index';

bool isLocalVariationKey(String? key) => key?.startsWith(_localPrefix) ?? false;

int? localVariationIndex(String key) {
  if (!isLocalVariationKey(key)) return null;
  return int.tryParse(key.substring(_localPrefix.length));
}

/// Maps a barcode's variation link to a server variation id after create.
String? resolveBarcodeVariationId({
  required String? linkKey,
  required List<VariationFormItem> formVariations,
  required List<VariationModel> createdVariations,
}) {
  if (linkKey == null) return null;
  if (!isLocalVariationKey(linkKey)) return linkKey;

  final index = localVariationIndex(linkKey);
  if (index == null) return null;

  final namedEntries = formVariations
      .asMap()
      .entries
      .where((e) => e.value.name.trim().isNotEmpty)
      .toList();

  final entry = namedEntries.where((e) => e.key == index).firstOrNull;
  if (entry == null) return null;

  for (final created in createdVariations) {
    if (created.name == entry.value.name.trim()) return created.id;
  }
  return null;
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

/// Returns [selectedKey] only if it exists exactly once in dropdown items.
String? resolveVariationDropdownValue(
  List<VariationFormItem> variations,
  String? selectedKey,
) {
  if (selectedKey == null) return null;

  final values = variations
      .asMap()
      .entries
      .where((e) => e.value.name.trim().isNotEmpty)
      .map((e) => variationDropdownValue(e.value, e.key));

  return values.contains(selectedKey) ? selectedKey : null;
}
