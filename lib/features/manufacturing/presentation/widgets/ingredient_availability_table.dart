import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';

class IngredientAvailabilityTable extends StatelessWidget {
  const IngredientAvailabilityTable({
    super.key,
    required this.rows,
    this.isLoading = false,
  });

  final List<IngredientAvailabilityRow> rows;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (rows.isEmpty) {
      return Text(
        'Select a BOM and quantity to preview ingredient availability.',
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
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
          children: const [
            _HeaderCell('Ingredient'),
            _HeaderCell('Required'),
            _HeaderCell('Available'),
            _HeaderCell('Status'),
          ],
        ),
        ...rows.map((row) {
          final shortColor = row.isShort ? AppColors.error : AppColors.success;
          return TableRow(
            decoration: row.isShort
                ? BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.06),
                  )
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(row.productName, style: AppTextStyles.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DecimalUtils.format(row.requiredQty, fractionDigits: 4),
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DecimalUtils.format(row.availableQty, fractionDigits: 4),
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  row.isShort ? 'Short' : 'OK',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: shortColor,
                    fontWeight: FontWeight.w600,
                  ),
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
