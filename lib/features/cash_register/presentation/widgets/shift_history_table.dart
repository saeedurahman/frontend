import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_state.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:go_router/go_router.dart';

const _shiftHistoryColumns = [
  AppDataTableColumn(label: 'Cashier', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Register', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Opened', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Closed', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Duration', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Opening Float', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Expected', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Counted', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Variance', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 1, sortable: true),
];

class ShiftHistoryTable extends StatefulWidget {
  const ShiftHistoryTable({super.key, required this.state});

  final ShiftHistoryState state;

  @override
  State<ShiftHistoryTable> createState() => _ShiftHistoryTableState();
}

class _ShiftHistoryTableState extends State<ShiftHistoryTable> {
  int _currentPage = 1;
  int _pageSize = 10;

  ShiftHistoryState get state => widget.state;

  int get _paginationTotal {
    if (state.hasMore) {
      return state.shifts.length + _pageSize;
    }
    return state.shifts.length;
  }

  Future<void> _ensurePageData(int page) async {
    final cubit = context.read<ShiftHistoryCubit>();
    final needed = page * _pageSize;

    while (mounted) {
      final current = cubit.state;
      if (current.shifts.length >= needed || !current.hasMore) break;
      if (current.isLoadingMore) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        continue;
      }
      await cubit.loadMore();
    }
  }

  Future<void> _onGoToPage(int page) async {
    await _ensurePageData(page);
    if (!mounted) return;
    setState(() => _currentPage = page);
  }

  void _onPageSizeChanged(int size) {
    setState(() {
      _pageSize = size;
      _currentPage = 1;
    });
  }

  void _openShift(BuildContext context, RegisterShiftModel shift) {
    if (shift.status == 'open') {
      context.go(RouteNames.cashRegister);
    } else {
      context.push(RouteNames.shiftDetailPath(shift.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShiftHistoryCubit>();

    return AppPaginatedDataTable<RegisterShiftModel>(
      columns: _shiftHistoryColumns,
      items: state.shifts,
      itemId: (shift) => shift.id,
      itemLabel: 'shifts',
      paginationMode: AppTablePaginationMode.client,
      currentPage: _currentPage,
      limit: _pageSize,
      onGoToPage: _onGoToPage,
      onPageSizeChanged: _onPageSizeChanged,
      pagination: AppTablePaginationHelpers.client(
        totalItems: _paginationTotal,
        currentPage: _currentPage,
        pageSize: _pageSize,
        itemLabel: 'shifts',
        onPageSizeChanged: _onPageSizeChanged,
        onGoToPage: _onGoToPage,
      ),
      sortCompare: (a, b, column) => _sortCompare(a, b, column, cubit),
      onRowTap: (shift) => _openShift(context, shift),
      rowBuilder: (context, shift, {required selected, required onSelected}) {
        final variance = shift.cashDifference == null
            ? Decimal.zero
            : DecimalUtils.parse(shift.cashDifference!);
        final varianceColor = ShiftFormatUtils.varianceColor(variance);

        return AppDataTableRowLayout(
          columns: _shiftHistoryColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Text(
              shift.openedByName ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text(
              cubit.registerName(shift.cashRegisterId) ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text(
              ShiftFormatUtils.formatDateTime(shift.openedAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              ShiftFormatUtils.formatDateTime(shift.closedAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              ShiftFormatUtils.formatDuration(
                shift.openedAt,
                closedAt: shift.closedAt,
              ),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text(
              ShiftFormatUtils.formatMoney(shift.openingFloat),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text(
              ShiftFormatUtils.formatMoney(shift.expectedCash),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text(
              ShiftFormatUtils.formatMoney(shift.actualCash),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text(
              shift.cashDifference == null
                  ? '—'
                  : ShiftFormatUtils.varianceLabel(variance),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: varianceColor,
              ),
            ),
            _ShiftStatusChip(status: shift.status),
          ],
          actions: AppTableActionButton(
            icon: Icons.chevron_right,
            tooltip: 'View',
            onPressed: () => _openShift(context, shift),
          ),
        );
      },
    );
  }

  static int _sortCompare(
    RegisterShiftModel a,
    RegisterShiftModel b,
    int column,
    ShiftHistoryCubit cubit,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          (a.openedByName ?? '').toLowerCase(),
          (b.openedByName ?? '').toLowerCase(),
        ),
      1 => compare(
          (cubit.registerName(a.cashRegisterId) ?? '').toLowerCase(),
          (cubit.registerName(b.cashRegisterId) ?? '').toLowerCase(),
        ),
      2 => compare(
          (a.openedAt ?? '').toLowerCase(),
          (b.openedAt ?? '').toLowerCase(),
        ),
      3 => compare(
          (a.closedAt ?? '').toLowerCase(),
          (b.closedAt ?? '').toLowerCase(),
        ),
      4 => compare(
          ShiftFormatUtils.formatDuration(a.openedAt, closedAt: a.closedAt),
          ShiftFormatUtils.formatDuration(b.openedAt, closedAt: b.closedAt),
        ),
      5 => compare(
          double.tryParse(a.openingFloat) ?? 0,
          double.tryParse(b.openingFloat) ?? 0,
        ),
      6 => compare(
          double.tryParse(a.expectedCash ?? '0') ?? 0,
          double.tryParse(b.expectedCash ?? '0') ?? 0,
        ),
      7 => compare(
          double.tryParse(a.actualCash ?? '0') ?? 0,
          double.tryParse(b.actualCash ?? '0') ?? 0,
        ),
      8 => compare(
          DecimalUtils.parse(a.cashDifference ?? '0'),
          DecimalUtils.parse(b.cashDifference ?? '0'),
        ),
      9 => compare(a.status.toLowerCase(), b.status.toLowerCase()),
      _ => 0,
    };
  }
}

class _ShiftStatusChip extends StatelessWidget {
  const _ShiftStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isOpen = status == 'open';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isOpen ? AppColors.success : AppColors.textSecondary)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isOpen ? AppColors.success : AppColors.textSecondary,
        ),
      ),
    );
  }
}
