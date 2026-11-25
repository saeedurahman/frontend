import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/product_import/domain/import_copy.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:intl/intl.dart';

/// The last imports with their Undo status.
class RecentImports extends StatelessWidget {
  const RecentImports({
    super.key,
    required this.batches,
    required this.loading,
    required this.canUndoPermission,
    required this.busy,
    required this.onUndo,
    this.limit = 5,
  });

  final List<ImportBatch> batches;
  final bool loading;

  /// The user may undo imports (products.update + products.delete).
  final bool canUndoPermission;
  final bool busy;
  final void Function(ImportBatch batch) onUndo;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('import-recent'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            const Text(
              'Recent imports',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(width: 8),
            if (loading)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (batches.isEmpty && !loading)
          const Text(
            'Nothing imported yet. Your imports will be listed here, and you can undo one for 24 hours.',
            key: ValueKey('import-recent-empty'),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          )
        else
          for (final b in batches.take(limit))
            _BatchTile(
              batch: b,
              canUndoPermission: canUndoPermission,
              busy: busy,
              onUndo: () => onUndo(b),
            ),
      ],
    );
  }
}

class _BatchTile extends StatelessWidget {
  const _BatchTile({
    required this.batch,
    required this.canUndoPermission,
    required this.busy,
    required this.onUndo,
  });

  final ImportBatch batch;
  final bool canUndoPermission;
  final bool busy;
  final VoidCallback onUndo;

  static final _when = DateFormat('d MMM, h:mm a');

  @override
  Widget build(BuildContext context) {
    final color = switch (batch.status) {
      ImportBatchStatus.active => AppColors.success,
      ImportBatchStatus.undone => AppColors.textSecondary,
      ImportBatchStatus.expired => AppColors.warning,
    };
    final counts = <String>[
      if (batch.createdCount > 0) '${batch.createdCount} added',
      if (batch.updatedCount > 0) '${batch.updatedCount} updated',
    ];
    final created = <String>[
      if (batch.createdUnits > 0)
        ImportCopy.plural(batch.createdUnits, 'new unit'),
      if (batch.createdCategories > 0)
        ImportCopy.plural(
          batch.createdCategories,
          'new category',
          'new categories',
        ),
    ];
    final when = batch.createdAt == null ? '' : _when.format(batch.createdAt!);
    return Container(
      key: ValueKey('import-recent-${batch.id}'),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            batch.source == 'xlsx'
                ? Icons.table_chart_outlined
                : Icons.description_outlined,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.filename.isEmpty ? 'Import' : batch.filename,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
                Text(
                  [
                    if (counts.isNotEmpty) counts.join(', '),
                    if (created.isNotEmpty) created.join(', '),
                    if (when.isNotEmpty) when,
                    if (batch.createdBy != null) 'by ${batch.createdBy}',
                  ].join('  ·  '),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            key: ValueKey('import-recent-status-${batch.id}'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ImportCopy.statusLabel(batch.status),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (batch.canUndo && canUndoPermission) ...[
            const SizedBox(width: 8),
            TextButton(
              key: ValueKey('import-recent-undo-${batch.id}'),
              onPressed: busy ? null : onUndo,
              child: const Text('Undo'),
            ),
          ],
        ],
      ),
    );
  }
}
