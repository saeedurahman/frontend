import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/offline/local_history.dart';
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

/// "Not synced yet" / "Needs attention" for a sale this device has not
/// finished sending. Renders nothing for a sale the server has.
class SaleSyncBadgeChip extends StatelessWidget {
  const SaleSyncBadgeChip({super.key, required this.badge});

  final SaleSyncBadge badge;

  @override
  Widget build(BuildContext context) {
    final label = badge.label;
    if (label == null) return const SizedBox.shrink();
    final color = badge == SaleSyncBadge.needsAttention
        ? AppColors.error
        : AppColors.offline;
    return Container(
      key: Key('sale-sync-badge-${badge.name}'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
