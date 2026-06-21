import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/audit/data/models/audit_log_model.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_action_chip.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_diff_view.dart';
import 'package:intl/intl.dart';

class AuditLogDetailDialog extends StatelessWidget {
  const AuditLogDetailDialog({super.key, required this.log});

  final AuditLogModel log;

  static Future<void> show(BuildContext context, AuditLogModel log) {
    return showDialog<void>(
      context: context,
      builder: (_) => AuditLogDetailDialog(log: log),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ts = DateFormat('EEE, dd MMM yyyy  HH:mm:ss').format(log.createdAt.toLocal());

    return AlertDialog(
      title: Row(
        children: [
          AuditActionChip(action: log.action),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              log.tableName,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _metaRow('Timestamp', ts),
              _metaRow('User', log.userName ?? log.userId ?? '—'),
              _metaRow('Record', log.recordId),
              if (log.ipAddress != null) _metaRow('IP Address', log.ipAddress!),
              if (log.userAgent != null)
                _metaRow('User Agent', log.userAgent!, small: true),
              if (log.syncStatus.isNotEmpty)
                _metaRow('Sync Status', log.syncStatus),
              if (log.hasValueDiff) ...[
                const SizedBox(height: 16),
                const Text(
                  'Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AuditDiffView(
                  oldValues: log.oldValues,
                  newValues: log.newValues,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _metaRow(String label, String value, {bool small = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: small ? 11 : 13,
                color: small ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
