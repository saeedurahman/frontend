import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/restaurant/presentation/utils/table_status_colors.dart';

class TableStatusLegend extends StatelessWidget {
  const TableStatusLegend({super.key});

  static const _statuses = [
    'available',
    'occupied',
    'reserved',
    'billing',
    'cleaning',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final status in _statuses)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: TableStatusColors.background(status),
                  border: Border.all(color: TableStatusColors.border(status)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                TableStatusColors.label(status),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
