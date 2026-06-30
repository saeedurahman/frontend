import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';

/// Validates modifier selections against group rules before add-to-cart.
abstract final class ModifierSelectionValidator {
  static String? validateGroup({
    required ModifierGroupModel group,
    required Set<String> selectedModifierIds,
  }) {
    final activeOptions = group.modifiers.where((m) => m.isActive).toList();
    if (activeOptions.isEmpty) return null;

    final selectedCount = selectedModifierIds.length;
    final min = group.isRequired
        ? (group.minSelections > 0 ? group.minSelections : 1)
        : group.minSelections;

    if (selectedCount < min) {
      return '${group.name}: choose at least $min';
    }

    final max = _effectiveMax(group);
    if (max != null && selectedCount > max) {
      return '${group.name}: choose at most $max';
    }

    for (final id in selectedModifierIds) {
      if (!activeOptions.any((option) => option.id == id)) {
        return '${group.name}: invalid selection';
      }
    }

    return null;
  }

  static String? validateAll({
    required List<ModifierGroupModel> groups,
    required Map<String, Set<String>> selectionsByGroupId,
  }) {
    for (final group in groups) {
      final selected = selectionsByGroupId[group.id] ?? const {};
      final error = validateGroup(group: group, selectedModifierIds: selected);
      if (error != null) return error;
    }
    return null;
  }

  static int? _effectiveMax(ModifierGroupModel group) {
    if (group.selectionType == 'single') return 1;
    return group.maxSelections;
  }

  static String groupRuleLabel(ModifierGroupModel group) {
    final min = group.isRequired
        ? (group.minSelections > 0 ? group.minSelections : 1)
        : group.minSelections;
    final max = _effectiveMax(group);

    if (group.selectionType == 'single') {
      return group.isRequired ? 'Required · choose 1' : 'Optional · choose 1';
    }
    if (max != null && min > 0) {
      return 'Required · choose $min–$max';
    }
    if (max != null) {
      return 'Optional · up to $max';
    }
    if (min > 0) {
      return 'Choose at least $min';
    }
    return 'Optional';
  }
}
