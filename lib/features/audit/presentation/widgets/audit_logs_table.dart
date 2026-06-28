import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/audit/data/models/audit_log_model.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_cubit.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_state.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_action_chip.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_log_detail_dialog.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:intl/intl.dart';

const _auditLogColumns = [
  AppDataTableColumn(label: 'Timestamp', flex: 2, sortable: true),
  AppDataTableColumn(label: 'User', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Action', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Table', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Record', flex: 1, sortable: true),
  AppDataTableColumn(label: 'IP Address', flex: 2, sortable: true),
];

class AuditLogsTable extends StatefulWidget {
  const AuditLogsTable({super.key, required this.state});

  final AuditLogsLoaded state;

  @override
  State<AuditLogsTable> createState() => _AuditLogsTableState();
}

class _AuditLogsTableState extends State<AuditLogsTable> {
  static final _timestampFormat = DateFormat('dd MMM yyyy  HH:mm:ss');

  int _currentPage = 1;
  int _pageSize = 10;

  AuditLogsLoaded get state => widget.state;

  Future<void> _ensurePageData(int page) async {
    final cubit = context.read<AuditLogsCubit>();
    final needed = page * _pageSize;

    while (mounted) {
      final current = cubit.state;
      if (current is! AuditLogsLoaded) return;
      if (current.logs.length >= needed || !current.hasMore) break;
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

  void _openDetail(BuildContext context, AuditLogModel log) {
    AuditLogDetailDialog.show(context, log);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaginatedDataTable<AuditLogModel>(
      columns: _auditLogColumns,
      items: state.logs,
      itemId: (log) => log.id,
      itemLabel: 'entries',
      paginationMode: AppTablePaginationMode.client,
      currentPage: _currentPage,
      limit: _pageSize,
      onGoToPage: _onGoToPage,
      onPageSizeChanged: _onPageSizeChanged,
      showSelection: false,
      sortCompare: _sortCompare,
      onRowTap: (log) => _openDetail(context, log),
      pagination: AppTablePaginationHelpers.client(
        totalItems: state.total,
        currentPage: _currentPage,
        pageSize: _pageSize,
        itemLabel: 'entries',
        onPageSizeChanged: _onPageSizeChanged,
        onGoToPage: _onGoToPage,
      ),
      rowBuilder: (context, log, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _auditLogColumns,
          showSelection: false,
          selected: selected,
          onSelected: onSelected,
          actions: AppTableActionButton(
            icon: Icons.visibility_outlined,
            tooltip: 'View details',
            onPressed: () => _openDetail(context, log),
          ),
          cells: [
            Text(
              _timestampFormat.format(log.createdAt.toLocal()),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              log.userName ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            AuditActionChip(action: log.action),
            Text(
              log.tableName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Tooltip(
              message: log.recordId,
              child: Text(
                log.shortRecordId,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              log.ipAddress ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  static int _sortCompare(AuditLogModel a, AuditLogModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.createdAt, b.createdAt),
      1 => compare(
          (a.userName ?? '').toLowerCase(),
          (b.userName ?? '').toLowerCase(),
        ),
      2 => compare(a.action.toLowerCase(), b.action.toLowerCase()),
      3 => compare(a.tableName.toLowerCase(), b.tableName.toLowerCase()),
      4 => compare(a.recordId.toLowerCase(), b.recordId.toLowerCase()),
      5 => compare(
          (a.ipAddress ?? '').toLowerCase(),
          (b.ipAddress ?? '').toLowerCase(),
        ),
      _ => 0,
    };
  }
}
