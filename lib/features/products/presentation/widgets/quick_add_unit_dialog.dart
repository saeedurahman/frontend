import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/presentation/cubit/units_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/units_state.dart';

class QuickAddUnitDialog extends StatefulWidget {
  const QuickAddUnitDialog({super.key});

  static Future<UnitModel?> show(BuildContext context) async {
    final unitsCubit = context.read<UnitsCubit>();
    return showDialog<UnitModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: unitsCubit,
        child: const QuickAddUnitDialog(),
      ),
    );
  }

  @override
  State<QuickAddUnitDialog> createState() => _QuickAddUnitDialogState();
}

class _QuickAddUnitDialogState extends State<QuickAddUnitDialog> {
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  bool _isBaseUnit = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final symbol = _symbolController.text.trim();
    if (name.isEmpty || symbol.isEmpty) return;
    setState(() => _saving = true);
    final created = await context.read<UnitsCubit>().create(
          name: name,
          symbol: symbol,
          isBaseUnit: _isBaseUnit,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (created != null) Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Unit'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Unit name'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _symbolController,
              decoration: const InputDecoration(labelText: 'Symbol'),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Is base unit'),
              value: _isBaseUnit,
              onChanged: (v) => setState(() => _isBaseUnit = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
