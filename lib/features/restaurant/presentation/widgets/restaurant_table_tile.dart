import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/presentation/utils/table_status_colors.dart';

class RestaurantTableTile extends StatelessWidget {
  const RestaurantTableTile({
    super.key,
    required this.table,
    required this.onTap,
  });

  final DiningTableModel table;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = TableStatusColors.border(table.status);

    return Semantics(
      button: true,
      label: 'Table ${table.tableNumber}, ${TableStatusColors.label(table.status)}',
      child: Material(
        color: TableStatusColors.background(table.status),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minWidth: 96, minHeight: 96),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  table.tableNumber,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  TableStatusColors.label(table.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${table.capacity} seats',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
