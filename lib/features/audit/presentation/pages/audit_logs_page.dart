import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/audit/data/models/audit_log_model.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_cubit.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_state.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_action_chip.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_filter_bar.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_log_detail_dialog.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:intl/intl.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuditLogsCubit>()..init(),
      child: const _AuditLogsView(),
    );
  }
}

class _AuditLogsView extends StatefulWidget {
  const _AuditLogsView();

  @override
  State<_AuditLogsView> createState() => _AuditLogsViewState();
}

class _AuditLogsViewState extends State<_AuditLogsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels >= max - 200) {
      context.read<AuditLogsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditLogsCubit, AuditLogsState>(
      builder: (context, state) {
        if (state is AuditLogsAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view audit logs",
          );
        }

        final cubit = context.read<AuditLogsCubit>();
        final filters = switch (state) {
          AuditLogsLoading(:final filters) => filters,
          AuditLogsLoaded(:final filters) => filters,
          AuditLogsError(:final filters) => filters,
          _ => const AuditLogsFilters(),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Audit Logs', style: AppTextStyles.headlineMedium),
                const SizedBox(width: 12),
                if (state is AuditLogsLoaded)
                  Text(
                    '${state.total} entries',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh),
                  onPressed: state is AuditLogsLoading ? null : cubit.refresh,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AuditFilterBar(
              filters: filters,
              onApply: cubit.applyFilters,
              onClear: cubit.clearFilters,
            ),
            const SizedBox(height: 12),
            if (state is AuditLogsError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            Expanded(
              child: switch (state) {
                AuditLogsLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                AuditLogsLoaded(:final logs, :final isLoadingMore) =>
                  logs.isEmpty
                      ? const EmptyState(
                          icon: Icons.history,
                          message: 'No audit entries match your filters',
                        )
                      : _AuditLogTable(
                          logs: logs,
                          scrollController: _scrollController,
                          isLoadingMore: isLoadingMore,
                        ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}

class _AuditLogTable extends StatelessWidget {
  const _AuditLogTable({
    required this.logs,
    required this.scrollController,
    required this.isLoadingMore,
  });

  final List<AuditLogModel> logs;
  final ScrollController scrollController;
  final bool isLoadingMore;

  static final _tsFormat = DateFormat('dd MMM yyyy  HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppColors.primary.withValues(alpha: 0.06),
                ),
                columns: const [
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Action')),
                  DataColumn(label: Text('Table')),
                  DataColumn(label: Text('Record')),
                  DataColumn(label: Text('IP Address')),
                ],
                rows: logs
                    .map(
                      (log) => DataRow(
                        onSelectChanged: (_) =>
                            AuditLogDetailDialog.show(context, log),
                        cells: [
                          DataCell(
                            Text(
                              _tsFormat.format(log.createdAt.toLocal()),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          DataCell(Text(log.userName ?? '—')),
                          DataCell(AuditActionChip(action: log.action)),
                          DataCell(Text(log.tableName)),
                          DataCell(
                            Tooltip(
                              message: log.recordId,
                              child: Text(
                                log.shortRecordId,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              log.ipAddress ?? '—',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}
