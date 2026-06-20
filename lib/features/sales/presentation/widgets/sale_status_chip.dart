import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';

class SaleStatusChip extends StatelessWidget {
  const SaleStatusChip({super.key, required this.status});

  final String status;

  static String labelFor(String status) => switch (status) {
        SaleStatus.draft => 'Draft',
        SaleStatus.held => 'Held',
        SaleStatus.completed => 'Completed',
        SaleStatus.partiallyPaid => 'Partially Paid',
        SaleStatus.cancelled => 'Cancelled',
        SaleStatus.voided => 'Voided',
        _ => status,
      };

  Color get _color => switch (status) {
        SaleStatus.draft => AppColors.textSecondary,
        SaleStatus.held => AppColors.info,
        SaleStatus.completed => AppColors.success,
        SaleStatus.partiallyPaid => AppColors.warning,
        SaleStatus.cancelled => AppColors.error,
        SaleStatus.voided => AppColors.error,
        _ => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        labelFor(status),
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
