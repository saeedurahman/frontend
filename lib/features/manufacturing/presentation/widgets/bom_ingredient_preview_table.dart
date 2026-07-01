import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/manufacturing/domain/utils/bom_qty_calculator.dart';

class BomIngredientPreviewTable extends StatelessWidget {
  const BomIngredientPreviewTable({
    super.key,
    required this.lines,
  });

  final List<BomQtyPreviewLine> lines;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return Text(
        'Add ingredient lines and quantities to see batch requirements.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      );
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: AppColors.border),
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppColors.border.withValues(alpha: 0.3)),
          children: const [
            _HeaderCell('Ingredient'),
            _HeaderCell('Per unit'),
            _HeaderCell('Batch total'),
            _HeaderCell('Wastage %'),
          ],
        ),
        ...lines.map((line) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  line.ingredientProductName ?? line.ingredientProductId,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DecimalUtils.format(line.qtyPerOutputUnit, fractionDigits: 4),
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DecimalUtils.format(line.totalQtyRequired, fractionDigits: 4),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DecimalUtils.format(line.wastagePct, fractionDigits: 2),
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          );
        }),
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
