import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/production_status_chip.dart';

class ProductionOrderSummaryCard extends StatelessWidget {
  const ProductionOrderSummaryCard({
    super.key,
    required this.order,
    this.branchName,
  });

  final ProductionOrderModel order;
  final String? branchName;

  String? _formatDate(String? raw) {
    if (raw == null) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormatter.formatDateTime(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(order.productionNumber, style: AppTextStyles.headlineMedium),
              const SizedBox(width: 12),
              ProductionStatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          _Row('Product', order.bom.productName),
          _Row('Recipe', '${order.bom.name} (v${order.bom.version})'),
          _Row('Branch', branchName ?? order.branchId),
          _Row(
            'Qty',
            order.status == ProductionOrderStatus.completed
                ? '${order.qtyProduced} / ${order.qtyToProduce}'
                : order.qtyToProduce,
          ),
          if (order.startedAt != null)
            _Row('Started', _formatDate(order.startedAt)),
          if (order.completedAt != null)
            _Row('Completed', _formatDate(order.completedAt)),
          if (order.notes != null && order.notes!.isNotEmpty)
            _Row('Notes', order.notes!),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value!, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
