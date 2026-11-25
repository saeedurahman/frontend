import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/product_import/data/import_file_picker.dart';
import 'package:frantend/features/product_import/domain/import_copy.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/domain/import_repository.dart';
import 'package:frantend/features/product_import/domain/problem_rows_export.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_cubit.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_choose_step.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_done_step.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_review_step.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_widgets.dart';

/// Import products from a .csv or .xlsx file in three steps:
/// choose the file, review what will happen, done.
class ProductImportDialog extends StatefulWidget {
  const ProductImportDialog({
    super.key,
    this.cubit,
    this.files,
    this.picker,
    this.canUndo = true,
    this.onChanged,
    this.onReviewNeedsDetails,
  });

  /// Tests pass their own; the app builds one from the repository.
  final ProductImportCubit? cubit;
  final FileSaverService? files;
  final ImportFilePicker? picker;

  /// The user may undo imports (products.update + products.delete).
  final bool canUndo;

  /// Called when the dialog closes after products were added or removed.
  final VoidCallback? onChanged;

  /// "Review products needing details": the caller opens its list filtered.
  final VoidCallback? onReviewNeedsDetails;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onChanged,
    VoidCallback? onReviewNeedsDetails,
  }) {
    // No access scope above (a test, a preview): nothing to enforce.
    bool can(String permission) {
      try {
        return context.read<AccessCubit>().state.can(permission);
      } catch (_) {
        return true;
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductImportDialog(
        canUndo: can(Perm.productsUpdate) && can(Perm.productsDelete),
        cubit: ProductImportCubit(
          repository: sl<ProductImportRepository>(),
          canCreateTaxRates: can(Perm.settingsManage),
        ),
        onChanged: onChanged,
        onReviewNeedsDetails: onReviewNeedsDetails,
      ),
    );
  }

  @override
  State<ProductImportDialog> createState() => _ProductImportDialogState();
}

class _ProductImportDialogState extends State<ProductImportDialog> {
  late final ProductImportCubit _cubit;
  late final FileSaverService _files;
  late final ImportFilePicker _picker;

  /// Something was added or undone: the caller refreshes when we close.
  bool _changed = false;

  /// "Saved to ...", with a way to open the folder.
  String? _savedNote;
  String? _savedPath;

  @override
  void initState() {
    super.initState();
    _cubit =
        widget.cubit ??
        ProductImportCubit(repository: sl<ProductImportRepository>());
    _files = widget.files ?? sl<FileSaverService>();
    _picker = widget.picker ?? ImportFilePicker(_files);
    unawaited(_cubit.start());
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  // ── actions ──────────────────────────────────────────────────────────

  Future<void> _choose() async {
    final picked = await _picker.pick();
    await _handle(picked);
  }

  Future<void> _dropped(String name, Future<List<int>> Function() read) async {
    await _handle(await _picker.fromDrop(name, read));
  }

  Future<void> _handle(PickedFile? picked) async {
    if (picked == null || !mounted) return;
    setState(() => _savedNote = null);
    switch (picked) {
      case PickedOk(:final file):
        await _cubit.chooseFile(file);
      case PickedWrongType(:final name):
        _cubit.rejectFile(name);
      case PickedUnreadable(:final name):
        _cubit.unreadableFile(name);
    }
  }

  Future<void> _template(ImportFileKind kind) async {
    final t = await _cubit.downloadTemplate(kind);
    if (t == null || !mounted) return;
    final path = await _files.saveFileWithDialog(
      t.fileName,
      t.bytes,
      extensions: [kind.extension],
    );
    if (path != null && mounted) {
      setState(() {
        _savedNote = 'Template saved. Fill it in, then choose it here.';
        _savedPath = path;
      });
    }
  }

  Future<void> _downloadProblems() async {
    final s = _cubit.state;
    final file = s.file;
    final report = s.report;
    if (file == null || report == null) return;
    final export = ProblemRowsExport.build(file, report);
    final path = await _files.saveFileWithDialog(
      ProblemRowsExport.fileNameFor(file),
      export.bytes,
      extensions: const ['csv'],
    );
    if (path != null && mounted) {
      setState(() {
        _savedNote =
            '${ImportCopy.plural(export.rows, 'row')} with problems saved. '
            'Fix them, then import that file.'
            '${export.missing > 0 ? ' ${export.missing} more rows have problems; after fixing these, check again to see them.' : ''}';
        _savedPath = path;
      });
    }
  }

  Future<void> _undo(ImportBatch batch) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const ValueKey('import-undo-confirm'),
        title: const Text('Undo this import?'),
        content: Text(
          'The ${ImportCopy.plural(batch.createdCount, 'product')} added by '
          '"${batch.filename}" will be removed and the stock it added is taken back. '
          '${batch.updatedCount > 0 ? 'Products it only changed go back to how they were. ' : ''}'
          'Units and categories it created stay. '
          'If a product was already sold or used, the import cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            key: const ValueKey('import-undo-confirm-yes'),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Undo import'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _cubit.undo(batch.id);
    }
  }

  void _close() {
    if (_changed) widget.onChanged?.call();
    Navigator.of(context).pop();
  }

  void _reviewDetails() {
    if (_changed) widget.onChanged?.call();
    Navigator.of(context).pop();
    widget.onReviewNeedsDetails?.call();
  }

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductImportCubit>.value(
      value: _cubit,
      child: BlocConsumer<ProductImportCubit, ProductImportState>(
        listener: (context, s) {
          if (s.applied != null || s.undoResult != null) _changed = true;
        },
        builder: (context, s) {
          return PopScope(
            canPop: !s.busy,
            child: Dialog(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 980,
                  maxHeight: 780,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(s),
                      const SizedBox(height: 14),
                      ImportStepper(current: s.step),
                      const SizedBox(height: 14),
                      if (s.offline)
                        ImportNotice(
                          key: const ValueKey('import-offline'),
                          icon: Icons.wifi_off,
                          color: AppColors.warning,
                          text:
                              "You're offline. Importing needs the internet. "
                              '${s.file != null ? 'Your file is kept here. ' : ''}'
                              'Connect, then tap Try again.',
                          action: s.file == null
                              ? null
                              : TextButton(
                                  key: const ValueKey('import-offline-retry'),
                                  onPressed: _cubit.retry,
                                  child: const Text('Try again'),
                                ),
                        ),
                      if (s.error != null)
                        ImportNotice(
                          key: const ValueKey('import-error'),
                          icon: Icons.error_outline,
                          color: AppColors.error,
                          text: s.error!,
                        ),
                      if (_savedNote != null)
                        ImportNotice(
                          key: const ValueKey('import-saved-note'),
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                          text: _savedNote!,
                          action: _savedPath == null
                              ? null
                              : TextButton(
                                  onPressed: () =>
                                      _files.openFolder(_savedPath!),
                                  child: const Text('Open folder'),
                                ),
                        ),
                      if (s.applying)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Column(
                            key: ValueKey('import-progress'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(),
                              SizedBox(height: 6),
                              Text(
                                'Adding your products. Big files can take a minute. Please wait...',
                              ),
                            ],
                          ),
                        ),
                      Expanded(child: _body(s)),
                      const SizedBox(height: 10),
                      _footer(s),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(ProductImportState s) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.file_upload_outlined,
            color: AppColors.primary,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Import products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(
                'Add or update many products at once from an Excel or CSV file',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          key: const ValueKey('import-close-x'),
          tooltip: 'Close',
          onPressed: s.busy ? null : _close,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _body(ProductImportState s) {
    switch (s.step) {
      case ImportStep.choose:
        return ImportChooseStep(
          state: s,
          canUndo: widget.canUndo,
          onChoose: _choose,
          onDropped: _dropped,
          onTemplate: _template,
          onRetry: _cubit.retry,
          onUndoBatch: _undo,
        );
      case ImportStep.review:
        return ImportReviewStep(
          state: s,
          onStartOver: _cubit.startOver,
          onAutoCreate: _cubit.setCreateAutomatically,
          onMapUnit: _cubit.mapUnit,
          onMapCategory: _cubit.mapCategory,
          onOnError: _cubit.setOnError,
          onSearch: _cubit.setSearch,
          onDownloadProblems: _downloadProblems,
        );
      case ImportStep.done:
        return ImportDoneStep(
          state: s,
          canUndo: widget.canUndo,
          onReviewDetails: _reviewDetails,
          onUndo: () {
            final b = s.appliedBatch;
            if (b != null) _undo(b);
          },
          onUndoBatch: _undo,
        );
    }
  }

  Widget _footer(ProductImportState s) {
    switch (s.step) {
      case ImportStep.choose:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              key: const ValueKey('import-cancel'),
              onPressed: s.busy ? null : _close,
              child: const Text('Cancel'),
            ),
          ],
        );
      case ImportStep.review:
        return Row(
          children: [
            Expanded(
              child: s.applyHint == null
                  ? const SizedBox.shrink()
                  : Text(
                      s.applyHint!,
                      key: const ValueKey('import-apply-hint'),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
            ),
            TextButton(
              key: const ValueKey('import-cancel'),
              onPressed: s.busy ? null : _close,
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              key: const ValueKey('import-apply'),
              onPressed: s.canApply ? _cubit.apply : null,
              icon: s.applying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(
                s.applying ? 'Adding...' : ImportCopy.applyLabel(s.summary),
              ),
            ),
          ],
        );
      case ImportStep.done:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              key: const ValueKey('import-close'),
              onPressed: s.busy ? null : _close,
              child: const Text('Close'),
            ),
          ],
        );
    }
  }
}
