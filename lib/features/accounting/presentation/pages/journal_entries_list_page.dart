import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entries_list_cubit.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entries_list_state.dart';
import 'package:frantend/features/accounting/presentation/utils/accounting_navigation.dart';
import 'package:frantend/features/accounting/presentation/widgets/journal_status_chip.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

const _journalTableColumns = [
  AppDataTableColumn(label: 'Entry #', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Date', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Description', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Debit', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Credit', flex: 2, sortable: true),
];

class JournalEntriesListPage extends StatelessWidget {
  const JournalEntriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JournalEntriesListCubit>()..init(),
      child: const _JournalEntriesListView(),
    );
  }
}

class _JournalEntriesListView extends StatelessWidget {
  const _JournalEntriesListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalEntriesListCubit, JournalEntriesListState>(
      listener: (context, state) {
        if (state is JournalEntriesListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is JournalEntriesListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view journal entries",
          );
        }

        final count = switch (state) {
          JournalEntriesListLoaded(:final entries) => entries.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(
              total: count,
              canCreate: state is JournalEntriesListLoaded && state.canCreate,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is JournalEntriesListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                JournalEntriesListInitial() || JournalEntriesListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                JournalEntriesListLoaded(:final entries) when entries.isEmpty =>
                  const EmptyState(
                    icon: Icons.menu_book_outlined,
                    message: 'No journal entries found',
                  ),
                JournalEntriesListLoaded loaded => _EntriesTable(
                    entries: loaded.entries,
                  ),
                JournalEntriesListError(:final message) =>
                  Center(child: Text(message)),
                JournalEntriesListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.total, required this.canCreate});

  final int total;
  final bool canCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Journal Entries', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total entries)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () => openCoaList(context),
          icon: const Icon(Icons.account_tree_outlined, size: 18),
          label: const Text('Chart of Accounts'),
        ),
        if (canCreate) ...[
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final created = await context.push<bool>(
                RouteNames.accountingJournalNew,
              );
              if (created == true && context.mounted) {
                await context.read<JournalEntriesListCubit>().refresh();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Journal Entry'),
          ),
        ],
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final JournalEntriesListLoaded state;

  static const _statusTabs = [
    (null, 'All'),
    (JournalEntryStatus.draft, 'Draft'),
    (JournalEntryStatus.posted, 'Posted'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JournalEntriesListCubit>();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ..._statusTabs.map(
          (tab) => ChoiceChip(
            label: Text(tab.$2),
            selected: state.statusFilter == tab.$1,
            onSelected: (_) => cubit.filterByStatus(tab.$1),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (range != null) {
              await cubit.setDateRange(from: range.start, to: range.end);
            }
          },
          icon: const Icon(Icons.date_range, size: 18),
          label: Text(
            state.dateFrom != null && state.dateTo != null
                ? '${DateFormatter.formatDate(state.dateFrom!)} – ${DateFormatter.formatDate(state.dateTo!)}'
                : 'Date range',
          ),
        ),
        if (state.dateFrom != null || state.dateTo != null)
          TextButton(
            onPressed: () => cubit.setDateRange(from: null, to: null),
            child: const Text('Clear dates'),
          ),
      ],
    );
  }
}

class _EntriesTable extends StatelessWidget {
  const _EntriesTable({required this.entries});

  final List<JournalEntryListModel> entries;

  String _formatDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormatter.formatDate(parsed);
  }

  int _sortCompare(JournalEntryListModel a, JournalEntryListModel b, int col) {
    return switch (col) {
      0 => a.entryNumber.compareTo(b.entryNumber),
      1 => a.entryDate.compareTo(b.entryDate),
      2 => (a.description ?? '').compareTo(b.description ?? ''),
      3 => a.status.compareTo(b.status),
      4 => a.totalDebit.compareTo(b.totalDebit),
      5 => a.totalCredit.compareTo(b.totalCredit),
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppPaginatedDataTable<JournalEntryListModel>(
      columns: _journalTableColumns,
      items: entries,
      itemId: (entry) => entry.id,
      itemLabel: 'entries',
      paginationMode: AppTablePaginationMode.summary,
      sortCompare: _sortCompare,
      onRowTap: (entry) => context.push(
        RouteNames.accountingJournalDetailPath(entry.id),
      ),
      rowBuilder: (context, entry, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _journalTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Text(
              entry.entryNumber,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(_formatDate(entry.entryDate)),
            Text(
              entry.description ?? '—',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            JournalStatusChip(status: entry.status),
            Text(formatPKR(double.tryParse(entry.totalDebit) ?? 0)),
            Text(formatPKR(double.tryParse(entry.totalCredit) ?? 0)),
          ],
          actions: AppTableActionButton(
            icon: Icons.chevron_right,
            tooltip: 'View',
            onPressed: () => context.push(
              RouteNames.accountingJournalDetailPath(entry.id),
            ),
          ),
        );
      },
    );
  }
}
