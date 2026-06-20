import 'package:frantend/features/products/data/models/category_model.dart';

/// Flattens nested category trees and removes duplicate IDs.
List<CategoryModel> flattenCategories(List<CategoryModel> categories) {
  final seen = <String>{};
  final result = <CategoryModel>[];

  void walk(List<CategoryModel> nodes) {
    for (final category in nodes) {
      if (seen.add(category.id)) {
        result.add(category);
        if (category.children.isNotEmpty) {
          walk(category.children);
        }
      }
    }
  }

  walk(categories);
  return result;
}

/// Ensures [selectedId] appears exactly once in dropdown items.
List<CategoryModel> categoriesForDropdown(
  List<CategoryModel> categories, {
  String? selectedId,
  CategoryModel? fallback,
}) {
  final flat = flattenCategories(categories);
  if (selectedId == null) return flat;
  if (flat.any((c) => c.id == selectedId)) return flat;
  if (fallback != null && fallback.id == selectedId) {
    return [...flat, fallback];
  }
  return flat;
}
