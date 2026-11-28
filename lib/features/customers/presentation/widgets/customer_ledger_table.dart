import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/customers/domain/pending_ledger.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/customers/presentation/utils/ledger_entry_formatters.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/widgets/reverse_payment_dialog.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:intl/intl.dart';

const _ledgerTableColumns = [
  AppDataTableColumn(label: 'Date', flex: 2, sortable: true),
  AppDataTableColumn(label: KhataText.whatHappened, flex: 3, sortable: true),
  AppDataTableColumn(label: KhataText.paidFrom, flex: 2),
  AppDataTableColumn(label: 'Amount', flex: 2, sortable: true),
  AppDataTableColumn(
    label: KhataText.runningBalance,
    flex: 2,
    sortable: true,
  ),
];

class CustomerLedgerTable extends StatelessWidget {
  const CustomerLedgerTable({super.key, required this.state});

  final CustomerLedgerLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomerLedgerCubit>();
    // Hidden (not just disabled) for people who may not reverse payments.
    final canReverse = hasPermission(context, Perm.customersPaymentsReverse);
    final khata = khataRepositoryIfAny();
    final canReverseEntries =
        khata != null && hasPermission(context, Perm.customersLedgerManage);
    final showActions = canReverse || canReverseEntries;

    // A new line goes to the top, so the table leaves any column sort and
    // shows its first page.
    final newest = state.entries.isEmpty ? null : state.entries.first.entry.id;

    if (state.entries.isEmpty && !state.isLoadingMore) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          cubit.olderNeedsInternet
              ? KhataText.olderNeedInternet
              : cubit.ledgerNeedsConnection && !cubit.fromDevice
                  ? 'Ledger history is available when you are online.'
                  : 'No ledger entries yet',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    // At the end of an account this device only holds the recent part of.
    final atEnd = cubit.olderNeedsInternet &&
        state.currentPage >= cubit.totalPages(state);

    final table = AppPaginatedDataTable<LedgerDisplayRow>(
      columns: _ledgerTableColumns,
      items: state.entries,
      itemId: (row) => row.entry.id,
      itemLabel: 'entries',
      resetToken: newest,
      showSelection: false,
      showActions: showActions,
      actionsHeader: '',
      actionsWidth: 150,
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
        final line = LedgerLine.fromCustomer(
          entry,
          runningBalance: row.runningBalance,
        );
        final amount = line.amountView;
        final balance = line.balanceView;
        final struck = line.isReversed;
        final strike = struck ? TextDecoration.lineThrough : null;
        final muted = struck ? AppColors.textSecondary : AppColors.textPrimary;

        return AppDataTableRowLayout(
          columns: _ledgerTableColumns,
          showSelection: false,
          selected: selected,
          onSelected: onSelected,
          actionsWidth: showActions ? 150 : 0,
          actions: canReverse && line.canReverse
              ? _ReverseButton(
                  key: ValueKey('reverse_${entry.id}'),
                  label: KhataText.reversePayment,
                  onPressed: () => _reverse(context, line),
                )
              : canReverseEntries && line.canReverseEntry
                  ? _ReverseButton(
                      key: ValueKey('reverse_entry_${entry.id}'),
                      label: EntryText.reverseEntry,
                      onPressed: () => reverseKhataEntry(
                        context,
                        repository: khata,
                        type: PartyType.customer,
                        line: line,
                        name: state.customer.name,
                      ),
                    )
                  : const SizedBox.shrink(),
          cells: [
            Text(
              formatLedgerEntryDate(entry.entryAt),
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                decoration: strike,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      line.typeLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: muted,
                        decoration: strike,
                      ),
                    ),
                    if (struck)
                      const _Tag(
                        label: KhataText.reversedTag,
                        color: AppColors.warning,
                      ),
                    if (line.isReversal)
                      const _Tag(
                        label: KhataText.reversalTag,
                        color: AppColors.info,
                      ),
                    if (entry.referenceType == PendingLedgerMarks.waiting)
                      const _Tag(
                        label: KhataText.waitingToSyncTag,
                        color: AppColors.info,
                      ),
                    if (entry.referenceType ==
                        PendingLedgerMarks.needsAttention)
                      const _Tag(
                        label: KhataText.syncNeedsAttentionTag,
                        color: AppColors.error,
                      ),
                  ],
                ),
                if (line.note != null && line.note!.isNotEmpty)
                  Text(
                    line.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            Text(
              line.detail.isEmpty ? '—' : line.detail,
              style: TextStyle(fontSize: 12, color: muted, decoration: strike),
            ),
            Text(
              amount.text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: strike,
                color: struck ? AppColors.textSecondary : amount.color,
              ),
            ),
            Text(
              balance?.text ?? '—',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: balance?.color ?? AppColors.textPrimary,
              ),
            ),
          ],
        );
      },
    );

    return !atEnd
        ? table
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: table),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  KhataText.olderNeedInternet,
                  key: Key('ledger-older-offline'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          );
  }

  Future<void> _reverse(BuildContext context, LedgerLine line) async {
    final cubit = context.read<CustomerLedgerCubit>();
    final name = state.customer.name;
    final day = line.when == null
        ? ''
        : ' on ${DateFormat('dd MMM').format(line.when!)}';
    final done = await ReversePaymentDialog.show(
      context,
      summary: '${formatPKR(line.amount.abs())} received from $name$day',
      onSubmit: (reason) => cubit.reversePayment(line.id, reason),
    );
    if (done && context.mounted) {
      AppAlerts.showSuccessMessage(context, KhataText.reversed);
    }
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
      3 => compare(
          CustomerBalanceUtils.parseBalance(aEntry.amount),
          CustomerBalanceUtils.parseBalance(bEntry.amount),
        ),
      4 => compare(
          CustomerBalanceUtils.parseBalance(a.runningBalance),
          CustomerBalanceUtils.parseBalance(b.runningBalance),
        ),
      _ => 0,
    };
  }
}

class _ReverseButton extends StatelessWidget {
  const _ReverseButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.undo, size: 16),
        label: Text(label, overflow: TextOverflow.ellipsis),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.warning,
          textStyle: const TextStyle(fontSize: 12),
        ),
      );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
}
