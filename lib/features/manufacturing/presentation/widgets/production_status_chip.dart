import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';

class ProductionStatusChip extends StatelessWidget {
  const ProductionStatusChip({super.key, required this.status});

  final String status;

  static String labelFor(String status) => switch (status) {
        ProductionOrderStatus.draft => 'Draft',
        ProductionOrderStatus.inProgress => 'In progress',
        ProductionOrderStatus.completed => 'Completed',
        ProductionOrderStatus.cancelled => 'Cancelled',
        _ => status,
      };

  Color get _color => switch (status) {
        ProductionOrderStatus.draft => AppColors.textSecondary,
        ProductionOrderStatus.inProgress => AppColors.info,
        ProductionOrderStatus.completed => AppColors.success,
        ProductionOrderStatus.cancelled => AppColors.error,
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
