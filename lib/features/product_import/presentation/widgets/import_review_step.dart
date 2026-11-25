import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/product_import/domain/import_copy.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';
import 'package:frantend/features/product_import/presentation/widgets/import_widgets.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';

/// Step 2: what will happen, what needs setting up, what is wrong.
class ImportReviewStep extends StatelessWidget {
  const ImportReviewStep({
    super.key,
    required this.state,
    required this.onStartOver,
    required this.onAutoCreate,
    required this.onMapUnit,
    required this.onMapCategory,
    required this.onOnError,
    required this.onSearch,
    required this.onDownloadProblems,
  });

  final ProductImportState state;
  final VoidCallback onStartOver;
  final void Function(bool on) onAutoCreate;
  final void Function(String input, String? unitId) onMapUnit;
  final void Function(String input, String? categoryId) onMapCategory;
  final void Function(ImportOnError mode) onOnError;
  final void Function(String text) onSearch;
  final VoidCallback onDownloadProblems;

  @override
  Widget build(BuildContext context) {
    final report = state.report;
    if (report == null) return const SizedBox.shrink();
    final s = report.summary;
    return SingleChildScrollView(
      key: const ValueKey('import-review'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.file?.name ?? '',
                  key: const ValueKey('import-review-file'),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                key: const ValueKey('import-start-over'),
                onPressed: state.busy ? null : onStartOver,
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Choose another file'),
              ),
            ],
          ),
          SizedBox(
            height: 3,
            child: state.checking ? const LinearProgressIndicator() : null,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ImportChip(
                key: const ValueKey('import-chip-total'),
                label: 'Total',
                count: s.totalRows,
                color: AppColors.textPrimary,
              ),
              ImportChip(
                key: const ValueKey('import-chip-add'),
                label: 'Will add',
                count: s.create,
                color: AppColors.success,
              ),
              ImportChip(
                key: const ValueKey('import-chip-update'),
                label: 'Will update',
                count: s.update,
                color: AppColors.info,
              ),
              ImportChip(
                key: const ValueKey('import-chip-unchanged'),
                label: 'Unchanged',
                count: s.unchanged,
                color: AppColors.textSecondary,
              ),
              ImportChip(
                key: const ValueKey('import-chip-attention'),
                label: 'Needs your attention',
                count: s.errors,
                color: s.errors > 0 ? AppColors.error : AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (report.unknownColumns.isNotEmpty)
            ImportNotice(
              key: const ValueKey('import-unknown-columns'),
              icon: Icons.info_outline,
              color: AppColors.info,
              text:
                  'We did not use these columns: ${report.unknownColumns.join(', ')}.',
            ),
          if (!state.setup.isEmpty)
            _SetupCard(
              state: state,
              onAutoCreate: onAutoCreate,
              onMapUnit: onMapUnit,
              onMapCategory: onMapCategory,
            ),
          if (report.groups.isNotEmpty || s.errors > 0)
            _ProblemsCard(
              state: state,
              onOnError: onOnError,
              onDownload: onDownloadProblems,
            ),
          if (report.warningGroups.isNotEmpty) _WarningsCard(report: report),
          _RowsCard(state: state, onSearch: onSearch),
        ],
      ),
    );
  }
}

// ── a) setup needed ─────────────────────────────────────────────────────

class _SetupCard extends StatelessWidget {
  const _SetupCard({
    required this.state,
    required this.onAutoCreate,
    required this.onMapUnit,
    required this.onMapCategory,
  });

  final ProductImportState state;
  final void Function(bool on) onAutoCreate;
  final void Function(String input, String? unitId) onMapUnit;
  final void Function(String input, String? categoryId) onMapCategory;

  @override
  Widget build(BuildContext context) {
    final setup = state.setup;
    final unitsToCreate = [
      for (final i in setup.units)
        if (!state.unitMap.containsKey(i.input)) i.input,
    ];
    final categoriesToCreate = [
      for (final i in setup.categories)
        if (!state.categoryMap.containsKey(i.input)) i.input,
    ];
    final taxRates = [for (final i in setup.taxRates) i.input];
    return ImportCard(
      key: const ValueKey('import-setup-card'),
      icon: Icons.tune,
      color: AppColors.info,
      title: 'Setup needed',
      subtitle: 'Things in your file that your shop does not have yet',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ImportCopy.setupSentence(
              unitsToCreate: unitsToCreate,
              categoriesToCreate: categoriesToCreate,
              taxRatesToCreate: taxRates,
              createAutomatically: state.createAutomatically,
              canCreateTaxRates: state.canCreateTaxRates,
            ),
            key: const ValueKey('import-setup-sentence'),
            style: const TextStyle(fontSize: 14, height: 1.35),
          ),
          SwitchListTile(
            key: const ValueKey('import-auto-create'),
            contentPadding: EdgeInsets.zero,
            title: const Text('Create them automatically'),
            value: state.createAutomatically,
            onChanged: state.busy ? null : onAutoCreate,
          ),
          if (setup.units.isNotEmpty) ...[
            const _SubTitle('Units'),
            for (final item in setup.units)
              _MapRow(
                kind: 'unit',
                item: item,
                options: state.options.units,
                mapped: state.unitMap[item.input],
                autoCreate: state.createAutomatically,
                disabled: state.busy,
                onChanged: (id) => onMapUnit(item.input, id),
              ),
          ],
          if (setup.categories.isNotEmpty) ...[
            const _SubTitle('Categories'),
            for (final item in setup.categories)
              _MapRow(
                kind: 'category',
                item: item,
                options: state.options.categories,
                mapped: state.categoryMap[item.input],
                autoCreate: state.createAutomatically,
                disabled: state.busy,
                onChanged: (id) => onMapCategory(item.input, id),
              ),
          ],
          if (setup.taxRates.isNotEmpty) ...[
            const _SubTitle('Tax rates'),
            for (final item in setup.taxRates)
              Padding(
                key: ValueKey('import-tax-${item.input}'),
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  '${item.input}  ·  used in ${ImportCopy.plural(item.rowsCount, 'row')}'
                  '${state.createAutomatically && state.canCreateTaxRates ? '  ·  will be created' : '  ·  your usual tax is used'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 4),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.6,
      ),
    ),
  );
}

/// "pkt (used in 5 rows)  ->  [Create 'Packet' | an existing unit]".
class _MapRow extends StatelessWidget {
  const _MapRow({
    required this.kind,
    required this.item,
    required this.options,
    required this.mapped,
    required this.autoCreate,
    required this.disabled,
    required this.onChanged,
  });

  final String kind;
  final SetupItem item;
  final List<PickOption> options;
  final String? mapped;
  final bool autoCreate;
  final bool disabled;
  final void Function(String? id) onChanged;

  @override
  Widget build(BuildContext context) {
    final createName = (item.suggestedName ?? item.input).trim();
    final isSuggestion = mapped != null && mapped == item.suggestedId;
    // A choice must exist in the list: a mapped id that is not there (the
    // list is still loading) shows as "create" until it arrives.
    final value = options.any((o) => o.id == mapped) ? mapped : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${item.input}"',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  isSuggestion
                      ? 'Looks like one you already have'
                      : 'Used in ${ImportCopy.plural(item.rowsCount, 'row')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: InputDecorator(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  key: ValueKey('import-map-$kind-${item.input}'),
                  value: value,
                  isExpanded: true,
                  isDense: true,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        autoCreate ? "Create new: $createName" : "Don't create",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    for (final o in options)
                      DropdownMenuItem<String?>(
                        value: o.id,
                        child: Text(
                          'Use ${o.label}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: disabled ? null : onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── b) problems ─────────────────────────────────────────────────────────

class _ProblemsCard extends StatelessWidget {
  const _ProblemsCard({
    required this.state,
    required this.onOnError,
    required this.onDownload,
  });

  final ProductImportState state;
  final void Function(ImportOnError mode) onOnError;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final report = state.report!;
    final errors = report.summary.errors;
    return ImportCard(
      key: const ValueKey('import-problems-card'),
      icon: Icons.error_outline,
      color: AppColors.error,
      title: 'Problems to fix',
      subtitle:
          '${ImportCopy.plural(errors, 'row')} cannot be imported as they are',
      trailing: OutlinedButton.icon(
        key: const ValueKey('import-download-problems'),
        onPressed: onDownload,
        icon: const Icon(Icons.download, size: 18),
        label: const Text('Download rows with problems'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final g in report.groups)
            _GroupTile(group: g, report: report, error: true),
          const Divider(height: 24),
          const Text(
            'What should we do with these rows?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          RadioGroup<ImportOnError>(
            groupValue: state.onError,
            onChanged: (v) {
              if (v != null && !state.busy) onOnError(v);
            },
            child: const Column(
              children: [
                RadioListTile<ImportOnError>(
                  key: ValueKey('import-onerror-abort'),
                  value: ImportOnError.abort,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Stop if there are problems'),
                  subtitle: Text(
                    'Nothing is added. Fix your file, then choose it again.',
                  ),
                ),
                RadioListTile<ImportOnError>(
                  key: ValueKey('import-onerror-skip'),
                  value: ImportOnError.skip,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Skip problem rows and import the rest'),
                  subtitle: Text(
                    'The good rows are added. The problem rows are left out.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Price is missing: 3 rows", open it for up to 5 sample rows and the hint.
class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.group,
    required this.report,
    required this.error,
  });

  final ProblemGroup group;
  final ImportReport report;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final color = error ? AppColors.error : AppColors.warning;
    final samples = group.sampleRows.take(5).toList();
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: ValueKey('import-group-${group.code}'),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 4, bottom: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        leading: Icon(
          error ? Icons.cancel_outlined : Icons.warning_amber_rounded,
          color: color,
        ),
        title: Text(
          '${group.message}: ${ImportCopy.plural(group.rowsCount, 'row')}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        children: [
          for (final line in samples)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(_sample(line), style: const TextStyle(fontSize: 13)),
            ),
          if (group.rowsCount > samples.length)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'and ${group.rowsCount - samples.length} more',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          if (group.hint.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: AppColors.accentDark,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      group.hint,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _sample(int line) {
    final r = report.rowAt(line);
    final what = [
      if (r?.name != null && r!.name!.trim().isNotEmpty) r.name!.trim(),
      if (r?.sku != null && r!.sku!.trim().isNotEmpty) '(${r.sku!.trim()})',
    ].join(' ');
    return what.isEmpty ? 'Row $line' : 'Row $line: $what';
  }
}

// ── c) warnings ─────────────────────────────────────────────────────────

class _WarningsCard extends StatelessWidget {
  const _WarningsCard({required this.report});

  final ImportReport report;

  @override
  Widget build(BuildContext context) {
    final rows = report.summary.warnings;
    return Container(
      key: const ValueKey('import-warnings-card'),
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: const ValueKey('import-warnings'),
            initiallyExpanded: false,
            leading: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
            ),
            title: const Text(
              'Warnings',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${rows > 0 ? ImportCopy.plural(rows, 'row') : ImportCopy.plural(report.warningGroups.length, 'thing')} '
              'to look at. These do not stop the import.',
              style: const TextStyle(fontSize: 12.5),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final g in report.warningGroups)
                _GroupTile(group: g, report: report, error: false),
            ],
          ),
        ),
      ),
    );
  }
}

// ── d) all rows ─────────────────────────────────────────────────────────

class _RowsCard extends StatelessWidget {
  const _RowsCard({required this.state, required this.onSearch});

  final ProductImportState state;
  final void Function(String text) onSearch;

  @override
  Widget build(BuildContext context) {
    final report = state.report!;
    final q = state.search.trim().toLowerCase();
    final rows = q.isEmpty
        ? report.rows
        : [
            for (final r in report.rows)
              if (_matches(r, q)) r,
          ];
    return Container(
      key: const ValueKey('import-rows-card'),
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: const ValueKey('import-rows'),
            leading: const Icon(
              Icons.table_rows_outlined,
              color: AppColors.textSecondary,
            ),
            title: const Text(
              'See every row',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${ImportCopy.plural(report.summary.totalRows, 'row')} in your file',
              style: const TextStyle(fontSize: 12.5),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            children: [
              TextField(
                key: const ValueKey('import-rows-search'),
                onChanged: onSearch,
                decoration: const InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search by name, item code or barcode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const _RowHeader(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: rows.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No rows match your search.',
                          key: ValueKey('import-rows-empty'),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: rows.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) => _RowLine(row: rows[i]),
                      ),
              ),
              if (report.rowsTruncated)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Showing the first ${report.rows.length} rows. All '
                    '${report.summary.totalRows} rows are checked and imported.',
                    key: const ValueKey('import-rows-truncated'),
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _matches(ImportRow r, String q) =>
      (r.name ?? '').toLowerCase().contains(q) ||
      (r.sku ?? '').toLowerCase().contains(q) ||
      (r.barcode ?? '').toLowerCase().contains(q) ||
      '${r.row}' == q;
}

class _RowHeader extends StatelessWidget {
  const _RowHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    );
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          SizedBox(width: 46, child: Text('Row', style: style)),
          SizedBox(width: 86, child: Text('What happens', style: style)),
          Expanded(flex: 3, child: Text('Product', style: style)),
          Expanded(
            flex: 2,
            child: Tooltip(
              message: 'SKU = your own item code, optional',
              child: Text('Item code (SKU)', style: style),
            ),
          ),
          Expanded(flex: 4, child: Text('Notes', style: style)),
        ],
      ),
    );
  }
}

class _RowLine extends StatelessWidget {
  const _RowLine({required this.row});

  final ImportRow row;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (row.action) {
      'create' => ('New', AppColors.success),
      'update' => ('Update', AppColors.info),
      'unchanged' => ('No change', AppColors.textSecondary),
      _ => ('Problem', AppColors.error),
    };
    final notes = row.hasError
        ? row.errors.join('; ')
        : [
            ...row.warnings,
            if (row.warnings.isEmpty) ...row.changes,
          ].join('; ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text('${row.row}', style: const TextStyle(fontSize: 13)),
          ),
          SizedBox(
            width: 86,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              row.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              row.sku ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              notes,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 12.5,
                color: row.hasError ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
