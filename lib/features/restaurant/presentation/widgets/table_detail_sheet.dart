import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/presentation/utils/table_pos_navigation.dart';
import 'package:frantend/features/restaurant/presentation/utils/table_status_colors.dart';

Future<void> showTableDetailSheet(
  BuildContext context,
  DiningTableModel table,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final canOrder = canLaunchTableOrder(table);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Table ${table.tableNumber}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _DetailRow(
                label: 'Status',
                value: TableStatusColors.label(table.status),
              ),
              _DetailRow(
                label: 'Capacity',
                value: '${table.capacity} guests',
              ),
              if (table.activeSaleId != null) ...[
                const SizedBox(height: 8),
                _DetailRow(
                  label: 'Open tab',
                  value: 'Active',
                ),
              ],
              const SizedBox(height: 20),
              if (canOrder)
                FilledButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await launchTableOrder(context, table);
                  },
                  icon: const Icon(Icons.point_of_sale),
                  label: Text(tableOrderActionLabel(table)),
                )
              else
                const Text(
                  'This table is not available for ordering right now.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
