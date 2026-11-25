import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_widgets.dart';
import 'package:frantend/features/product_import/presentation/widgets/recent_imports.dart';

/// Step 1: choose (or drop) a file, or download the template.
class ImportChooseStep extends StatefulWidget {
  const ImportChooseStep({
    super.key,
    required this.state,
    required this.canUndo,
    required this.onChoose,
    required this.onDropped,
    required this.onTemplate,
    required this.onRetry,
    required this.onUndoBatch,
  });

  final ProductImportState state;
  final bool canUndo;
  final VoidCallback onChoose;

  /// A file dropped on the window: its name and a way to read it.
  final void Function(String name, Future<List<int>> Function() read) onDropped;
  final void Function(ImportFileKind kind) onTemplate;
  final VoidCallback onRetry;
  final void Function(ImportBatch batch) onUndoBatch;

  @override
  State<ImportChooseStep> createState() => _ImportChooseStepState();
}

class _ImportChooseStepState extends State<ImportChooseStep> {
  bool _hovering = false;

  /// Help for the words a shop owner may not know.
  static const columns = <(String, String, String)>[
    ('name', 'Name', "The product's name. Required."),
    ('sku', 'SKU', 'SKU = your own item code, optional'),
    (
      'barcode',
      'Barcode',
      'The number printed under the barcode lines, optional',
    ),
    (
      'category',
      'Category',
      'A group like Groceries or Medicines. New groups are created for you.',
    ),
    (
      'unit',
      'Unit',
      'How you count it: kg, litre, packet, piece... Any spelling works.',
    ),
    ('cost', 'Cost', 'What you pay your supplier for one unit, optional'),
    ('price', 'Price', 'What you sell one unit for'),
    (
      'stock',
      'Opening stock',
      'How many you have on the shelf today, optional',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final file = s.file;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropTarget(
            onDragEntered: (_) => setState(() => _hovering = true),
            onDragExited: (_) => setState(() => _hovering = false),
            onDragDone: (details) {
              setState(() => _hovering = false);
              if (details.files.isEmpty || s.busy) return;
              final f = details.files.first;
              widget.onDropped(f.name, f.readAsBytes);
            },
            child: AnimatedContainer(
              key: const ValueKey('import-drop-zone'),
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: _hovering
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _hovering ? AppColors.primary : AppColors.border,
                  width: _hovering ? 2 : 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    file == null
                        ? Icons.cloud_upload_outlined
                        : Icons.description_outlined,
                    size: 44,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  if (file == null) ...[
                    const Text(
                      'Drag your file here',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'An Excel (.xlsx) or CSV (.csv) file with your products',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ] else ...[
                    Text(
                      file.name,
                      key: const ValueKey('import-file-name'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _size(file.sizeBytes),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  if (s.checking)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Checking your file...',
                          key: ValueKey('import-checking'),
                        ),
                      ],
                    )
                  else
                    Wrap(
                      spacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          key: const ValueKey('import-choose-file'),
                          onPressed: s.busy ? null : widget.onChoose,
                          icon: const Icon(Icons.folder_open),
                          label: Text(
                            file == null
                                ? 'Choose file'
                                : 'Choose another file',
                          ),
                        ),
                        if (file != null && s.offline)
                          OutlinedButton.icon(
                            key: const ValueKey('import-retry'),
                            onPressed: widget.onRetry,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try again'),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ImportCard(
            icon: Icons.download_for_offline_outlined,
            color: AppColors.info,
            title: 'Not sure how to write your file?',
            subtitle:
                'Download a template made for your shop. It already has your units and '
                'categories, and a few examples you can delete.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('import-template-xlsx'),
                      onPressed: s.busy
                          ? null
                          : () => widget.onTemplate(ImportFileKind.xlsx),
                      icon: const Icon(Icons.table_chart_outlined, size: 18),
                      label: const Text('Download Excel template'),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('import-template-csv'),
                      onPressed: s.busy
                          ? null
                          : () => widget.onTemplate(ImportFileKind.csv),
                      icon: const Icon(Icons.description_outlined, size: 18),
                      label: const Text('Download CSV template'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'What the columns mean (hover for help)',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (final (key, label, help) in columns)
                      Tooltip(
                        key: ValueKey('import-help-$key'),
                        message: help,
                        waitDuration: const Duration(milliseconds: 250),
                        child: Chip(
                          avatar: const Icon(
                            Icons.help_outline,
                            size: 16,
                            color: AppColors.info,
                          ),
                          label: Text(
                            label,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: AppColors.info.withValues(
                            alpha: 0.07,
                          ),
                          side: BorderSide.none,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          RecentImports(
            batches: s.batches,
            loading: s.batchesLoading,
            canUndoPermission: widget.canUndo,
            busy: s.busy,
            onUndo: widget.onUndoBatch,
          ),
        ],
      ),
    );
  }

  static String _size(int bytes) {
    if (bytes < 1024) return '$bytes bytes';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
