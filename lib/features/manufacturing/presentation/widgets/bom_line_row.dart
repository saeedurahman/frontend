import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/bom_form_cubit.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/bom_form_state.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';

class BomLineRow extends StatelessWidget {
  const BomLineRow({
    super.key,
    required this.index,
    required this.line,
    required this.products,
    this.error,
  });

  final int index;
  final BomLineFormItem line;
  final List<ProductListItemModel> products;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BomFormCubit>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String?>(
                  initialValue: line.ingredientProductId,
                  decoration: const InputDecoration(labelText: 'Ingredient'),
                  items: products
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                  onChanged: (id) {
                    if (id != null) cubit.selectIngredientProduct(index, id);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String?>(
                  initialValue: line.ingredientVariationId,
                  decoration: const InputDecoration(labelText: 'Variation'),
                  items: line.variations
                      .map(
                        (v) => DropdownMenuItem(value: v.id, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: (id) => cubit.selectIngredientVariation(index, id),
                ),
              ),
              IconButton(
                onPressed: () => cubit.removeLine(index),
                icon: Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Qty required'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(text: line.qtyRequired)
                    ..selection = TextSelection.collapsed(
                      offset: line.qtyRequired.length,
                    ),
                  onChanged: (v) =>
                      cubit.updateLine(index, line.copyWith(qtyRequired: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Wastage %'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(text: line.wastagePct)
                    ..selection = TextSelection.collapsed(
                      offset: line.wastagePct.length,
                    ),
                  onChanged: (v) =>
                      cubit.updateLine(index, line.copyWith(wastagePct: v)),
                ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
        ],
      ),
    );
  }
}
