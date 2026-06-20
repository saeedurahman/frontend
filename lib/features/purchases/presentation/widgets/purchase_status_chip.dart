import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';

class PurchaseStatusChip extends StatelessWidget {
  const PurchaseStatusChip({super.key, required this.status});

  final String status;

  static String labelFor(String status) => switch (status) {
        PurchaseOrderStatus.draft => 'Draft',
        PurchaseOrderStatus.ordered => 'Submitted',
        PurchaseOrderStatus.partial => 'Partially Received',
        PurchaseOrderStatus.received => 'Completed',
        PurchaseOrderStatus.cancelled => 'Cancelled',
        _ => status,
      };

  Color get _color => switch (status) {
        PurchaseOrderStatus.draft => AppColors.textSecondary,
        PurchaseOrderStatus.ordered => AppColors.info,
        PurchaseOrderStatus.partial => AppColors.warning,
        PurchaseOrderStatus.received => AppColors.success,
        PurchaseOrderStatus.cancelled => AppColors.error,
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
