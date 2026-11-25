import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/product_import/domain/import_copy.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_widgets.dart';
import 'package:frantend/features/product_import/presentation/widgets/recent_imports.dart';

/// Step 3: what was done, and what to do next.
class ImportDoneStep extends StatelessWidget {
  const ImportDoneStep({
    super.key,
    required this.state,
    required this.canUndo,
    required this.onReviewDetails,
    required this.onUndo,
    required this.onUndoBatch,
  });

  final ProductImportState state;

  /// The user may undo imports (products.update + products.delete).
  final bool canUndo;
  final VoidCallback onReviewDetails;
  final VoidCallback onUndo;
  final void Function(ImportBatch batch) onUndoBatch;

  @override
  Widget build(BuildContext context) {
    final applied = state.applied;
    if (applied == null) return const SizedBox.shrink();
    final s = applied.summary;
    final batch = state.appliedBatch;
    final undone =
        state.undoResult != null || batch?.status == ImportBatchStatus.undone;

    final extra = <String>[
      if ((batch?.createdUnits ?? 0) > 0)
        ImportCopy.plural(batch!.createdUnits, 'new unit'),
      if ((batch?.createdCategories ?? 0) > 0)
        ImportCopy.plural(
          batch!.createdCategories,
          'new category',
          'new categories',
        ),
    ];

    final undoEnabled =
        !undone && batch != null && batch.canUndo && canUndo && !state.undoing;
    final undoHelp = undone
        ? 'This import was undone.'
        : !canUndo
        ? 'Only people who may edit and delete products can undo an import.'
        : batch == null
        ? 'Checking if this import can be undone...'
        : batch.status == ImportBatchStatus.expired
        ? 'This import is more than 24 hours old, so it can no longer be undone.'
        : 'Made a mistake? You can undo this import for 24 hours.';

    return SingleChildScrollView(
      key: const ValueKey('import-done'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Icon(
            undone ? Icons.undo_rounded : Icons.check_circle,
            size: 64,
            color: undone ? AppColors.textSecondary : AppColors.success,
          ),
          const SizedBox(height: 12),
          Text(
            undone ? 'Import undone' : ImportCopy.resultHeadline(s),
            key: const ValueKey('import-result-headline'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          if (!undone && extra.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'We also created ${extra.join(' and ')} for you.',
                key: const ValueKey('import-result-created'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          if (!undone && s.errors > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${ImportCopy.plural(s.errors, 'row')} with problems ${s.errors == 1 ? 'was' : 'were'} left out.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          const SizedBox(height: 18),
          if (state.undoMessage != null)
            ImportNotice(
              key: const ValueKey('import-undo-message'),
              icon: state.undoResult != null
                  ? Icons.check_circle_outline
                  : Icons.info_outline,
              color: state.undoResult != null
                  ? AppColors.success
                  : AppColors.warning,
              text: state.undoMessage!,
            ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              if (s.create > 0 && !undone)
                FilledButton.icon(
                  key: const ValueKey('import-review-details'),
                  onPressed: onReviewDetails,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Review products needing details'),
                ),
              OutlinedButton.icon(
                key: const ValueKey('import-undo'),
                onPressed: undoEnabled ? onUndo : null,
                icon: state.undoing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.undo),
                label: const Text('Undo this import'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            undoHelp,
            key: const ValueKey('import-undo-help'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          RecentImports(
            batches: state.batches,
            loading: state.batchesLoading,
            canUndoPermission: canUndo,
            busy: state.busy,
            onUndo: onUndoBatch,
          ),
        ],
      ),
    );
  }
}
