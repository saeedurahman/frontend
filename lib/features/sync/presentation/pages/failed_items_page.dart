import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/sync/sync_status.dart';

/// Skeleton for the screen that will list changes the server rejected, with
/// retry / discard actions. The sync engine (Phase 4b) fills it; today it
/// only reports the (always zero) count so the route, navigation and chip
/// link already exist.
class FailedItemsPage extends StatelessWidget {
  const FailedItemsPage({super.key, this.source});

  final SyncStatusSource? source;

  @override
  Widget build(BuildContext context) {
    final src = source ?? sl<SyncStatusSource>();
    return StreamBuilder<SyncStatus>(
      stream: src.changes,
      initialData: src.current,
      builder: (context, snapshot) {
        final failed = (snapshot.data ?? src.current).failed;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  failed == 0
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  size: 48,
                  color: failed == 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(height: 12),
                Text(
                  failed == 0
                      ? 'Nothing needs attention'
                      : '$failed change(s) need attention',
                  key: const Key('failed-items-headline'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Changes the server could not accept will be listed here '
                  'with options to retry or discard them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
