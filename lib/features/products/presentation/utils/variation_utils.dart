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

/// The `variations` and `barcodes` parts of a create-product request.
///
/// The backend creates the product, its variations and every barcode in one
/// transaction, so a barcode is not sent on its own: one that is linked to a
/// variation row of the form (`local:<index>`) goes into that variation's
/// `barcodes`, any other goes to the product's `barcodes`. A barcode linked to
/// a row that has no name (and so is not sent) falls back to the product.
///
/// Only the first barcode marked primary stays primary (the backend rejects
/// more than one).
Map<String, dynamic> createBarcodePayload(
  List<VariationFormItem> variations,
  List<BarcodeFormItem> barcodes,
) {
  final sent = <int>[
    for (var i = 0; i < variations.length; i++)
      if (variations[i].name.trim().isNotEmpty) i,
  ];
  final byVariation = <int, List<Map<String, dynamic>>>{};
  final productLevel = <Map<String, dynamic>>[];
  var primaryTaken = false;
  for (final b in barcodes) {
    final code = b.barcode.trim();
    if (code.isEmpty) continue;
    final primary = b.isPrimary && !primaryTaken;
    if (primary) primaryTaken = true;
    final item = <String, dynamic>{
      'barcode': code,
      'barcode_type': b.barcodeType,
      'is_primary': primary,
    };
    final index = b.variationId == null ? null : localVariationIndex(b.variationId!);
    if (index != null && sent.contains(index)) {
      (byVariation[index] ??= []).add(item);
    } else {
      productLevel.add(item);
    }
  }
  return {
    if (sent.isNotEmpty)
      'variations': [
        for (final i in sent)
          {
            'name': variations[i].name.trim(),
            if (variations[i].sku != null && variations[i].sku!.isNotEmpty)
              'sku': variations[i].sku,
            if (variations[i].unitId != null) 'unit_id': variations[i].unitId,
            'is_default': variations[i].isDefault,
            if (variations[i].weightGrams != null && variations[i].weightGrams!.isNotEmpty)
              'weight_grams': variations[i].weightGrams,
            if (byVariation[i] != null) 'barcodes': byVariation[i],
          },
      ],
    if (productLevel.isNotEmpty) 'barcodes': productLevel,
  };
}
