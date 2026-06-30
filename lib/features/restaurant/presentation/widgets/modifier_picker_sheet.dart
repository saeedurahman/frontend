import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/presentation/utils/modifier_selection_validator.dart';

class ModifierPickerSheet extends StatefulWidget {
  const ModifierPickerSheet({
    super.key,
    required this.productName,
    required this.groups,
  });

  final String productName;
  final List<ModifierGroupModel> groups;

  @override
  State<ModifierPickerSheet> createState() => _ModifierPickerSheetState();
}

class _ModifierPickerSheetState extends State<ModifierPickerSheet> {
  final Map<String, Set<String>> _selections = {};

  @override
  void initState() {
    super.initState();
    for (final group in widget.groups) {
      _selections[group.id] = {};
    }
  }

  void _toggleSingle(ModifierGroupModel group, String modifierId) {
    setState(() => _selections[group.id] = {modifierId});
  }

  void _toggleMultiple(ModifierGroupModel group, String modifierId) {
    setState(() {
      final current = {...(_selections[group.id] ?? {})};
      if (current.contains(modifierId)) {
        current.remove(modifierId);
      } else {
        final max = group.selectionType == 'single'
            ? 1
            : group.maxSelections;
        if (max != null && current.length >= max) return;
        current.add(modifierId);
      }
      _selections[group.id] = current;
    });
  }

  List<CartLineModifierModel> _buildResult() {
    final result = <CartLineModifierModel>[];
    for (final group in widget.groups) {
      final selected = _selections[group.id] ?? const {};
      for (final modifier in group.modifiers) {
        if (selected.contains(modifier.id)) {
          result.add(
            CartLineModifierModel.fromModels(
              modifier: modifier,
              group: group,
            ),
          );
        }
      }
    }
    return result;
  }

  String? get _validationError => ModifierSelectionValidator.validateAll(
        groups: widget.groups,
        selectionsByGroupId: _selections,
      );

  @override
  Widget build(BuildContext context) {
    final canAdd = _validationError == null;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Customize your order',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  children: [
                    for (final group in widget.groups) ...[
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        ModifierSelectionValidator.groupRuleLabel(group),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...group.modifiers.where((m) => m.isActive).map(
                            (modifier) => _ModifierOptionTile(
                              modifier: modifier,
                              isSingle: group.selectionType == 'single',
                              selected: _selections[group.id]
                                      ?.contains(modifier.id) ??
                                  false,
                              onTap: () {
                                if (group.selectionType == 'single') {
                                  _toggleSingle(group, modifier.id);
                                } else {
                                  _toggleMultiple(group, modifier.id);
                                }
                              },
                            ),
                          ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              if (_validationError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _validationError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: FilledButton(
                    onPressed: canAdd
                        ? () => Navigator.pop(context, _buildResult())
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Add to order'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModifierOptionTile extends StatelessWidget {
  const _ModifierOptionTile({
    required this.modifier,
    required this.isSingle,
    required this.selected,
    required this.onTap,
  });

  final ModifierModel modifier;
  final bool isSingle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final delta = Decimal.tryParse(modifier.priceDelta) ?? Decimal.zero;
    final priceLabel = delta > Decimal.zero
        ? '+${formatPKR(delta)}'
        : null;

    return Semantics(
      label: modifier.name,
      selected: selected,
      button: true,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: isSingle
            ? Radio<bool>(
                value: true,
                groupValue: selected,
                onChanged: (_) => onTap(),
              )
            : Checkbox(
                value: selected,
                onChanged: (_) => onTap(),
              ),
        title: Text(modifier.name),
        trailing: priceLabel != null
            ? Text(
                priceLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
