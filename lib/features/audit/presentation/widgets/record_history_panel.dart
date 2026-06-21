import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/audit/data/models/audit_log_model.dart';
import 'package:frantend/features/audit/presentation/cubit/record_history_cubit.dart';
import 'package:frantend/features/audit/presentation/cubit/record_history_state.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_action_chip.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_diff_view.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_log_detail_dialog.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:intl/intl.dart';

/// Embeddable audit history for a single record (future "View History" entry points).
class RecordHistoryPanel extends StatelessWidget {
  const RecordHistoryPanel({
    super.key,
    required this.tableName,
    required this.recordId,
    this.title,
  });

  final String tableName;
  final String recordId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecordHistoryCubit>()..init(tableName, recordId),
      child: _RecordHistoryView(title: title ?? 'Change history'),
    );
  }
}

class _RecordHistoryView extends StatelessWidget {
  const _RecordHistoryView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordHistoryCubit, RecordHistoryState>(
      builder: (context, state) {
        if (state is RecordHistoryAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view audit logs",
          );
        }
        if (state is RecordHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RecordHistoryError) {
          return Center(child: Text(state.message));
        }
        if (state is! RecordHistoryLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (state.logs.isEmpty)
              const EmptyState(
                icon: Icons.history,
                message: 'No audit history for this record',
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: state.logs.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index >= state.logs.length) {
                      return TextButton(
                        onPressed: state.isLoadingMore
                            ? null
                            : () => context.read<RecordHistoryCubit>().loadMore(),
                        child: state.isLoadingMore
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Load more'),
                      );
                    }
                    final log = state.logs[index];
                    return _RecordHistoryTile(log: log);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RecordHistoryTile extends StatelessWidget {
  const _RecordHistoryTile({required this.log});

  final AuditLogModel log;

  @override
  Widget build(BuildContext context) {
    final ts = DateFormat('dd MMM yyyy HH:mm:ss').format(log.createdAt.toLocal());

    return InkWell(
      onTap: () => AuditLogDetailDialog.show(context, log),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AuditActionChip(action: log.action),
                const SizedBox(width: 8),
                Text(
                  ts,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  log.userName ?? '—',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            if (log.hasValueDiff) ...[
              const SizedBox(height: 8),
              AuditDiffView(
                oldValues: log.oldValues,
                newValues: log.newValues,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
