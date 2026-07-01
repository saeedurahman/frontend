import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';

class ProductionLinesTable extends StatelessWidget {
  const ProductionLinesTable({super.key, required this.lines});

  final List<ProductionLineModel> lines;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return Text(
        'Ingredient consumption will appear here after completion.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      );
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      border: TableBorder.all(color: AppColors.border),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
          children: const [
            _HeaderCell('Ingredient'),
            _HeaderCell('Qty consumed'),
            _HeaderCell('Cost / unit'),
          ],
        ),
        ...lines.map(
          (line) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(line.productName, style: AppTextStyles.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(line.qtyConsumed, style: AppTextStyles.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(line.costPerUnit, style: AppTextStyles.bodySmall),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
