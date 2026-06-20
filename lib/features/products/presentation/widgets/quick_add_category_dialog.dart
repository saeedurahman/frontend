import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:frantend/features/products/presentation/utils/category_utils.dart';

class QuickAddCategoryDialog extends StatefulWidget {
  const QuickAddCategoryDialog({super.key});

  static Future<CategoryModel?> show(BuildContext context) async {
    final categoriesCubit = context.read<CategoriesCubit>();
    return showDialog<CategoryModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: categoriesCubit,
        child: const QuickAddCategoryDialog(),
      ),
    );
  }

  @override
  State<QuickAddCategoryDialog> createState() => _QuickAddCategoryDialogState();
}

class _QuickAddCategoryDialogState extends State<QuickAddCategoryDialog> {
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
    final created = await context.read<CategoriesCubit>().create(
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
      title: const Text('New Category'),
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
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                final categories = switch (state) {
                  CategoriesLoaded(:final categories) => categories,
                  _ => <CategoryModel>[],
                };
                final flat = flattenCategories(categories);
                return DropdownButtonFormField<String?>(
                  value: _parentId,
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
