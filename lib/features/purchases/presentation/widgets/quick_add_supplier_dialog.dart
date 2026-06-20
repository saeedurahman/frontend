import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';

class QuickAddSupplierDialog extends StatefulWidget {
  const QuickAddSupplierDialog({super.key});

  static Future<SupplierModel?> show(BuildContext context) async {
    final cubit = context.read<SuppliersListCubit>();
    return showDialog<SupplierModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const QuickAddSupplierDialog(),
      ),
    );
  }

  @override
  State<QuickAddSupplierDialog> createState() => _QuickAddSupplierDialogState();
}

class _QuickAddSupplierDialogState extends State<QuickAddSupplierDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final created = await context.read<SuppliersListCubit>().createQuick(
          name: name,
          phone: _phoneController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (created != null) Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Supplier'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Supplier name *'),
              autofocus: true,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone (optional)'),
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
