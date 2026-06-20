import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';

class QuickAddExpenseCategoryDialog extends StatefulWidget {
  const QuickAddExpenseCategoryDialog({super.key});

  static Future<ExpenseCategoryModel?> show(BuildContext context) async {
    final cubit = context.read<ExpenseCategoriesCubit>();
    return showDialog<ExpenseCategoryModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const QuickAddExpenseCategoryDialog(),
      ),
    );
  }

  @override
  State<QuickAddExpenseCategoryDialog> createState() =>
      _QuickAddExpenseCategoryDialogState();
}

class _QuickAddExpenseCategoryDialogState
    extends State<QuickAddExpenseCategoryDialog> {
  final _nameController = TextEditingController();
  String? _parentId;
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
    final created = await context.read<ExpenseCategoriesCubit>().create(
          name,
          parentId: _parentId,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (created != null) Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Expense Category'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category name'),
              autofocus: true,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            BlocBuilder<ExpenseCategoriesCubit, ExpenseCategoriesState>(
              builder: (context, state) {
                final categories = switch (state) {
                  ExpenseCategoriesLoaded(:final categories) => categories,
                  _ => <ExpenseCategoryModel>[],
                };
                final flat = flattenExpenseCategories(categories);
                return DropdownButtonFormField<String?>(
                  initialValue: _parentId,
                  decoration: const InputDecoration(
                    labelText: 'Parent category (optional)',
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...flat.map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _parentId = v),
                );
              },
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
