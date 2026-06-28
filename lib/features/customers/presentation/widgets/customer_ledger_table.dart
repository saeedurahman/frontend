import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/customers/presentation/utils/ledger_entry_formatters.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';

const _ledgerTableColumns = [
  AppDataTableColumn(label: 'Date', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Type', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Amount', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Running Balance', flex: 2, sortable: true),
];

class CustomerLedgerTable extends StatelessWidget {
  const CustomerLedgerTable({super.key, required this.state});

  final CustomerLedgerLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomerLedgerCubit>();

    if (state.entries.isEmpty && !state.isLoadingMore) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          'No ledger entries yet',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return AppPaginatedDataTable<LedgerDisplayRow>(
      columns: _ledgerTableColumns,
      items: state.entries,
      itemId: (row) => row.entry.id,
      itemLabel: 'entries',
      showSelection: false,
      showActions: false,
      sortCompare: _sortCompare,
      currentPage: state.currentPage,
      limit: state.pageSize,
      onPageSizeChanged: cubit.setPageSize,
      onGoToPage: cubit.goToPage,
      pagination: AppTablePaginationHelpers.client(
        totalItems: cubit.paginationTotal(state),
        currentPage: state.currentPage,
        pageSize: state.pageSize,
        itemLabel: 'entries',
        onPageSizeChanged: cubit.setPageSize,
        onGoToPage: cubit.goToPage,
      ),
      rowBuilder: (context, row, {required selected, required onSelected}) {
        final entry = row.entry;
        final amount = CustomerBalanceUtils.parseBalance(entry.amount);
        final running = CustomerBalanceUtils.parseBalance(row.runningBalance);
        final amountIsNegative = amount < Decimal.zero;

        return AppDataTableRowLayout(
          columns: _ledgerTableColumns,
          showSelection: false,
          selected: selected,
          onSelected: onSelected,
          actionsWidth: 0,
          actions: const SizedBox.shrink(),
          cells: [
            Text(
              formatLedgerEntryDate(entry.entryAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              CustomerBalanceUtils.ledgerEntryTypeLabel(entry.entryType),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              DecimalUtils.format(amount),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: amountIsNegative ? AppColors.error : AppColors.success,
              ),
            ),
            Text(
              CustomerBalanceUtils.formatBalanceDisplay(row.runningBalance).text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: running < Decimal.zero
                    ? AppColors.error
                    : AppColors.textPrimary,
              ),
            ),
          ],
        );
      },
    );
  }

  static int _sortCompare(LedgerDisplayRow a, LedgerDisplayRow b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);
    final aEntry = a.entry;
    final bEntry = b.entry;

    return switch (column) {
      0 => compare(
          (aEntry.entryAt ?? aEntry.createdAt ?? '').toLowerCase(),
          (bEntry.entryAt ?? bEntry.createdAt ?? '').toLowerCase(),
        ),
      1 => compare(
          CustomerBalanceUtils.ledgerEntryTypeLabel(aEntry.entryType)
              .toLowerCase(),
          CustomerBalanceUtils.ledgerEntryTypeLabel(bEntry.entryType)
              .toLowerCase(),
        ),
      2 => compare(
          CustomerBalanceUtils.parseBalance(aEntry.amount),
          CustomerBalanceUtils.parseBalance(bEntry.amount),
        ),
      3 => compare(
          CustomerBalanceUtils.parseBalance(a.runningBalance),
          CustomerBalanceUtils.parseBalance(b.runningBalance),
        ),
      _ => 0,
    };
  }
}
