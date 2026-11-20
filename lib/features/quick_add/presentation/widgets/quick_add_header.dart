import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_state.dart';

import 'quick_add_grid.dart';

/// Everything above the grid: notices, mode, counters, the scan field.
class QuickAddHeader extends StatelessWidget {
  const QuickAddHeader({
    super.key,
    required this.scanController,
    required this.scanNode,
    required this.onScanText,
    required this.onSave,
    required this.canOpeningStock,
    required this.canPurchase,
    required this.canSave,
    required this.soundOn,
    required this.onToggleSound,
  });

  final TextEditingController scanController;
  final FocusNode scanNode;
  final void Function(String text) onScanText;
  final VoidCallback onSave;
  final bool canOpeningStock;
  final bool canPurchase;
  final bool canSave;
  final bool soundOn;
  final VoidCallback onToggleSound;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocSelector<QuickAddCubit, QuickAddState, (bool, String?)>(
          selector: (s) => (s.online, s.banner),
          builder: (context, v) => _Notices(online: v.$1, banner: v.$2),
        ),
        const SizedBox(height: 8),
        _TopBar(
          canOpeningStock: canOpeningStock,
          canPurchase: canPurchase,
          canSave: canSave,
          onSave: onSave,
          soundOn: soundOn,
          onToggleSound: onToggleSound,
        ),
        const SizedBox(height: 10),
        _ScanField(controller: scanController, node: scanNode, onText: onScanText),
        const _FeedbackLine(),
      ],
    );
  }
}

class _Notices extends StatelessWidget {
  const _Notices({required this.online, required this.banner});

  final bool online;
  final String? banner;

  @override
  Widget build(BuildContext context) {
    Widget box(Color color, IconData icon, String text) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
            ],
          ),
        );
    return Column(
      children: [
        if (!online)
          box(
            AppColors.warning,
            Icons.cloud_off,
            "You're offline. Keep scanning: your list is saved on this computer. "
            'Connect to the internet to save it to your shop.',
          ),
        if (banner != null) box(AppColors.error, Icons.info_outline, banner!),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.canOpeningStock,
    required this.canPurchase,
    required this.canSave,
    required this.onSave,
    required this.soundOn,
    required this.onToggleSound,
  });

  final bool canOpeningStock;
  final bool canPurchase;
  final bool canSave;
  final VoidCallback onSave;
  final bool soundOn;
  final VoidCallback onToggleSound;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuickAddCubit>();
    return BlocBuilder<QuickAddCubit, QuickAddState>(
      buildWhen: (a, b) =>
          a.mode != b.mode ||
          a.supplierName != b.supplierName ||
          a.rows != b.rows ||
          a.saving != b.saving ||
          a.canUndo != b.canUndo ||
          a.options != b.options,
      builder: (context, state) {
        final purchase = state.mode == QuickAddMode.purchase;
        return Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SegmentedButton<QuickAddMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: QuickAddMode.openingStock,
                  enabled: canOpeningStock,
                  label: const Text('Opening stock'),
                  icon: const Icon(Icons.inventory_2_outlined, size: 18),
                ),
                ButtonSegment(
                  value: QuickAddMode.purchase,
                  enabled: canPurchase,
                  label: const Text('Purchase from supplier'),
                  icon: const Icon(Icons.local_shipping_outlined, size: 18),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: (s) {
                cubit.setMode(s.first);
                if (s.first == QuickAddMode.purchase && state.options.suppliers.isEmpty) {
                  cubit.refreshOptions();
                }
              },
            ),
            if (purchase)
              OutlinedButton.icon(
                icon: const Icon(Icons.storefront_outlined, size: 18),
                label: Text(state.supplierName ?? 'Pick supplier'),
                onPressed: () async {
                  final picked = await showQuickAddPicker(
                    context,
                    title: 'Supplier',
                    options: state.options.suppliers,
                  );
                  if (picked?.option != null) {
                    cubit.setSupplier(picked!.option!.id, picked.option!.label);
                  }
                },
              ),
            _Counter(label: 'Items', value: '${state.itemCount}'),
            _Counter(label: 'Total qty', value: state.totalQty.toString()),
            _Counter(label: 'Total cost', value: DecimalUtils.format(state.totalCost)),
            IconButton(
              tooltip: soundOn ? 'Beep is on. Tap to mute.' : 'Beep is muted. Tap to turn on.',
              icon: Icon(soundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined),
              onPressed: onToggleSound,
            ),
            IconButton(
              tooltip: 'Undo last scan or delete (Ctrl+Z)',
              icon: const Icon(Icons.undo),
              onPressed: state.canUndo ? cubit.undo : null,
            ),
            FilledButton.icon(
              icon: state.saving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(state.saving ? 'Saving...' : 'Save all (Ctrl+S)'),
              onPressed: canSave && !state.saving && state.rows.isNotEmpty ? onSave : null,
            ),
          ],
        );
      },
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// The big field the scanner types into. Always takes the focus back.
class _ScanField extends StatelessWidget {
  const _ScanField({required this.controller, required this.node, required this.onText});

  final TextEditingController controller;
  final FocusNode node;
  final void Function(String text) onText;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuickAddCubit>();
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final ctrl = HardwareKeyboard.instance.isControlPressed;
        if (ctrl && event.logicalKey == LogicalKeyboardKey.keyZ) {
          cubit.undo();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          controller.clear();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.text.isEmpty) {
          final rows = cubit.state.rows;
          if (rows.isNotEmpty) cubit.focusRow(rows.first.id);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: TextField(
        key: const ValueKey('quick-add-scan-field'),
        controller: controller,
        focusNode: node,
        autofocus: true,
        style: const TextStyle(fontSize: 22, letterSpacing: 1),
        textInputAction: TextInputAction.done,
        onEditingComplete: () {},
        decoration: InputDecoration(
          hintText: 'Scan a barcode (or type it and press Enter)',
          prefixIcon: const Icon(Icons.qr_code_scanner, size: 30),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 3),
          ),
        ),
        onSubmitted: (text) {
          onText(text);
          controller.clear();
          node.requestFocus();
        },
      ),
    );
  }
}

/// "Lux Soap 100g added" under the scan field (also the quiet-mode feedback).
class _FeedbackLine extends StatelessWidget {
  const _FeedbackLine();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QuickAddCubit, QuickAddState, ScanFeedback?>(
      selector: (s) => s.feedback,
      builder: (context, fb) {
        final color = switch (fb?.tone) {
          ScanTone.success => AppColors.success,
          ScanTone.warning => AppColors.warning,
          ScanTone.error => AppColors.error,
          null => AppColors.textSecondary,
        };
        final icon = switch (fb?.tone) {
          ScanTone.success => Icons.check_circle,
          ScanTone.warning => Icons.warning_amber_rounded,
          ScanTone.error => Icons.error,
          null => Icons.info_outline,
        };
        return Container(
          key: ValueKey('fb-${fb?.token}'),
          height: 30,
          margin: const EdgeInsets.only(top: 4),
          alignment: Alignment.centerLeft,
          child: fb == null
              ? const Text(
                  'Tip: Enter moves Name > Cost > Price > back to scan. Esc cancels. Ctrl+Z undoes.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                )
              : TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 250),
                  builder: (context, t, child) => Opacity(opacity: t, child: child),
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: color),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          fb.message,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
