import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/sync/sync_status.dart';

/// Compact connection / sync indicator: Online, Offline, Syncing, N pending,
/// N failed. Tapping a "failed" chip opens the failed-items page via
/// [onFailedTap].
class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({super.key, this.source, this.onFailedTap});

  /// Defaults to the registered [SyncStatusSource].
  final SyncStatusSource? source;
  final VoidCallback? onFailedTap;

  @override
  Widget build(BuildContext context) {
    final src = source ?? sl<SyncStatusSource>();
    return StreamBuilder<SyncStatus>(
      stream: src.changes,
      initialData: src.current,
      builder: (context, snapshot) => SyncStatusChipView(
        status: snapshot.data ?? src.current,
        onTap: (snapshot.data ?? src.current).kind == SyncStatusKind.failed
            ? onFailedTap
            : null,
      ),
    );
  }
}

/// Stateless rendering of one [SyncStatus].
class SyncStatusChipView extends StatelessWidget {
  const SyncStatusChipView({super.key, required this.status, this.onTap});

  final SyncStatus status;
  final VoidCallback? onTap;

  static Color colorFor(SyncStatusKind kind) => switch (kind) {
        SyncStatusKind.online => AppColors.online,
        SyncStatusKind.offline => AppColors.offline,
        SyncStatusKind.failed => AppColors.error,
        SyncStatusKind.pending => AppColors.warning,
        SyncStatusKind.syncing => AppColors.info,
      };

  static IconData iconFor(SyncStatusKind kind) => switch (kind) {
        SyncStatusKind.online => Icons.cloud_done_outlined,
        SyncStatusKind.offline => Icons.cloud_off,
        SyncStatusKind.failed => Icons.error_outline,
        SyncStatusKind.pending => Icons.cloud_upload_outlined,
        SyncStatusKind.syncing => Icons.sync,
      };

  @override
  Widget build(BuildContext context) {
    final kind = status.kind;
    final color = colorFor(kind);
    final chip = Container(
      key: const Key('sync-status-chip'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kind == SyncStatusKind.syncing)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          else
            Icon(iconFor(kind), size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return chip;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: chip,
    );
  }
}
