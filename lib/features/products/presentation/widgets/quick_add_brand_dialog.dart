import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/brands_state.dart';

class QuickAddBrandDialog extends StatefulWidget {
  const QuickAddBrandDialog({super.key});

  static Future<BrandModel?> show(BuildContext context) async {
    final brandsCubit = context.read<BrandsCubit>();
    return showDialog<BrandModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: brandsCubit,
        child: const QuickAddBrandDialog(),
      ),
    );
  }

  @override
  State<QuickAddBrandDialog> createState() => _QuickAddBrandDialogState();
}

class _QuickAddBrandDialogState extends State<QuickAddBrandDialog> {
  final _nameController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final created = await context.read<BrandsCubit>().create(name);
    if (!mounted) return;
    setState(() => _saving = false);
    if (created != null) Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Brand'),
      content: SizedBox(
        width: 320,
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Brand name'),
          autofocus: true,
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
