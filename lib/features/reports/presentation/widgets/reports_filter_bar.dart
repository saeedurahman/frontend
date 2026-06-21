import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter_cubit.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';

class ReportsFilterBar extends StatelessWidget {
  const ReportsFilterBar({
    super.key,
    required this.onFilterChanged,
  });

  final ValueChanged<ReportsFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsFilterCubit, ReportsFilterState>(
      builder: (context, filterState) {
        final filter = filterState.filter;
        final filterCubit = context.read<ReportsFilterCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets(context, filterCubit, filter),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.date_range, size: 18),
                label: Text(
                  filter.presetLabel == 'Custom Range'
                      ? '${_fmt(filter.dateFrom)} – ${_fmt(filter.dateTo)}'
                      : 'Custom Range',
                ),
                onPressed: () => _pickCustomRange(context, filterCubit, filter),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _presets(
    BuildContext context,
    ReportsFilterCubit cubit,
    ReportsFilter filter,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final presets = <(String, DateTime, DateTime)>[
      ('Today', today, today),
      ('Yesterday', today.subtract(const Duration(days: 1)),
          today.subtract(const Duration(days: 1))),
      ('This Week', today.subtract(Duration(days: today.weekday - 1)), today),
      ('Last 7 Days', today.subtract(const Duration(days: 6)), today),
      ('This Month', DateTime(now.year, now.month, 1), today),
      ('Last Month', DateTime(now.year, now.month - 1, 1),
          DateTime(now.year, now.month, 0)),
      ('This Quarter', DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1),
          today),
    ];

    return presets.map((preset) {
      final selected = filter.presetLabel == preset.$1;
      return ActionChip(
        label: Text(preset.$1),
        backgroundColor:
            selected ? AppColors.primary.withValues(alpha: 0.12) : null,
        onPressed: () {
          cubit.applyRange(
            from: preset.$2,
            to: preset.$3,
            presetLabel: preset.$1,
          );
          onFilterChanged(cubit.state.filter);
        },
      );
    }).toList();
  }

  Future<void> _pickCustomRange(
    BuildContext context,
    ReportsFilterCubit cubit,
    ReportsFilter filter,
  ) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: filter.dateFrom, end: filter.dateTo),
    );
    if (range == null) return;
    cubit.applyRange(
      from: range.start,
      to: range.end,
      presetLabel: 'Custom Range',
    );
    onFilterChanged(cubit.state.filter);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
