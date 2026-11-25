import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:frantend/core/error/failures.dart';

/// What the owner picked: a .csv or .xlsx file, kept in memory so the choice
/// survives a dropped connection.
enum ImportFileKind {
  csv,
  xlsx;

  String get extension => name;
  String get apiSource => name;

  static ImportFileKind? fromFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.csv')) return csv;
    if (lower.endsWith('.xlsx')) return xlsx;
    return null;
  }
}

class ImportFile extends Equatable {
  const ImportFile({
    required this.name,
    required this.bytes,
    required this.kind,
  });

  final String name;
  final Uint8List bytes;
  final ImportFileKind kind;

  int get sizeBytes => bytes.length;

  /// The text of a CSV file (BOM removed). Null for Excel files.
  String? get csvText {
    if (kind != ImportFileKind.csv) return null;
    var b = bytes;
    if (b.length >= 3 && b[0] == 0xEF && b[1] == 0xBB && b[2] == 0xBF) {
      b = b.sublist(3);
    }
    return utf8.decode(b, allowMalformed: true);
  }

  @override
  List<Object?> get props => [name, bytes.length, kind];
}

/// `abort`: one bad row stops everything. `skip`: the good rows go in.
enum ImportOnError {
  abort,
  skip;

  String get api => name;
}

class ImportOptions extends Equatable {
  const ImportOptions({
    this.onError = ImportOnError.abort,
    this.createUnits = true,
    this.createCategories = true,
    this.createTaxRates = false,
    this.unitMap = const {},
    this.categoryMap = const {},
    this.branchId,
  });

  final ImportOnError onError;
  final bool createUnits;
  final bool createCategories;
  final bool createTaxRates;

  /// What the owner typed in the file (any spelling) -> an existing unit id.
  final Map<String, String> unitMap;
  final Map<String, String> categoryMap;
  final String? branchId;

  ImportOptions copyWith({
    ImportOnError? onError,
    bool? createUnits,
    bool? createCategories,
    bool? createTaxRates,
    Map<String, String>? unitMap,
    Map<String, String>? categoryMap,
  }) => ImportOptions(
    onError: onError ?? this.onError,
    createUnits: createUnits ?? this.createUnits,
    createCategories: createCategories ?? this.createCategories,
    createTaxRates: createTaxRates ?? this.createTaxRates,
    unitMap: unitMap ?? this.unitMap,
    categoryMap: categoryMap ?? this.categoryMap,
    branchId: branchId,
  );

  /// The option fields shared by the JSON body and the multipart form.
  Map<String, dynamic> toFields({required bool dryRun}) => {
    'dry_run': dryRun,
    'on_error': onError.api,
    'create_missing_units': createUnits,
    'create_missing_categories': createCategories,
    'create_missing_tax_rates': createTaxRates,
    'unit_map': unitMap,
    'category_map': categoryMap,
    if (branchId != null) 'branch_id': branchId,
  };

  @override
  List<Object?> get props => [
    onError,
    createUnits,
    createCategories,
    createTaxRates,
    unitMap,
    categoryMap,
    branchId,
  ];
}

class ImportSummary extends Equatable {
  const ImportSummary({
    this.totalRows = 0,
    this.create = 0,
    this.update = 0,
    this.unchanged = 0,
    this.errors = 0,
    this.warnings = 0,
    this.applied = 0,
  });

  final int totalRows;
  final int create;
  final int update;
  final int unchanged;
  final int errors;
  final int warnings;
  final int applied;

  /// Rows that would be written (or were) if the problem rows are skipped.
  int get writable => create + update;

  factory ImportSummary.fromJson(Map<String, dynamic> j) => ImportSummary(
    totalRows: _int(j['total_rows']),
    create: _int(j['create']),
    update: _int(j['update']),
    unchanged: _int(j['unchanged']),
    errors: _int(j['errors']),
    warnings: _int(j['warnings']),
    applied: _int(j['applied']),
  );

  @override
  List<Object?> get props => [
    totalRows,
    create,
    update,
    unchanged,
    errors,
    warnings,
    applied,
  ];
}

/// A unit / category / tax rate the file uses that the shop does not have yet.
class SetupItem extends Equatable {
  const SetupItem({
    required this.input,
    this.suggestedName,
    this.suggestedId,
    this.rowsCount = 0,
    this.willCreate = false,
    this.rate,
  });

  /// As written in the file ("pkt", "Groceries", "GST 17%").
  final String input;
  final String? suggestedName;

  /// A close existing one ("did you mean"), or null.
  final String? suggestedId;
  final int rowsCount;
  final bool willCreate;
  final String? rate;

  factory SetupItem.fromJson(Map<String, dynamic> j, {required String idKey}) =>
      SetupItem(
        input: '${j['input'] ?? ''}',
        suggestedName: j['suggested_name'] as String?,
        suggestedId: j[idKey] as String?,
        rowsCount: _int(j['rows_count']),
        willCreate: j['will_create'] == true,
        rate: j['rate']?.toString(),
      );

  @override
  List<Object?> get props => [
    input,
    suggestedName,
    suggestedId,
    rowsCount,
    willCreate,
    rate,
  ];
}

class ImportSetup extends Equatable {
  const ImportSetup({
    this.units = const [],
    this.categories = const [],
    this.taxRates = const [],
  });

  final List<SetupItem> units;
  final List<SetupItem> categories;
  final List<SetupItem> taxRates;

  bool get isEmpty => units.isEmpty && categories.isEmpty && taxRates.isEmpty;

  factory ImportSetup.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const ImportSetup();
    List<SetupItem> items(String key, String idKey) => [
      for (final e in (j[key] as List? ?? const []))
        if (e is Map)
          SetupItem.fromJson(Map<String, dynamic>.from(e), idKey: idKey),
    ];
    return ImportSetup(
      units: items('missing_units', 'suggested_unit_id'),
      categories: items('missing_categories', 'suggested_category_id'),
      taxRates: items('missing_tax_rates', 'suggested_tax_rate_id'),
    );
  }

  @override
  List<Object?> get props => [units, categories, taxRates];
}

/// Errors (or warnings) of one kind, e.g. "Price is missing: 3 rows".
class ProblemGroup extends Equatable {
  const ProblemGroup({
    required this.code,
    required this.message,
    required this.rowsCount,
    this.sampleRows = const [],
    this.hint = '',
  });

  final String code;
  final String message;
  final int rowsCount;
  final List<int> sampleRows;
  final String hint;

  factory ProblemGroup.fromJson(Map<String, dynamic> j) => ProblemGroup(
    code: '${j['code'] ?? ''}',
    message: '${j['message'] ?? ''}',
    rowsCount: _int(j['rows_count']),
    sampleRows: [
      for (final r in (j['sample_rows'] as List? ?? const [])) _int(r),
    ],
    hint: '${j['hint'] ?? ''}',
  );

  @override
  List<Object?> get props => [code, message, rowsCount, sampleRows, hint];
}

class ImportRow extends Equatable {
  const ImportRow({
    required this.row,
    required this.action,
    this.sku,
    this.barcode,
    this.name,
    this.changes = const [],
    this.errors = const [],
    this.warnings = const [],
    this.errorCodes = const [],
    this.warningCodes = const [],
  });

  /// The line in the file (the header is line 1).
  final int row;
  final String action;
  final String? sku;
  final String? barcode;
  final String? name;
  final List<String> changes;
  final List<String> errors;
  final List<String> warnings;
  final List<String> errorCodes;
  final List<String> warningCodes;

  bool get hasError => errors.isNotEmpty || action == 'error';

  factory ImportRow.fromJson(Map<String, dynamic> j) {
    List<String> strings(Object? v) => [
      for (final e in (v as List? ?? const [])) '$e',
    ];
    return ImportRow(
      row: _int(j['row']),
      action: '${j['action'] ?? ''}',
      sku: j['sku'] as String?,
      barcode: j['barcode'] as String?,
      name: j['name'] as String?,
      changes: strings(j['changes']),
      errors: strings(j['errors']),
      warnings: strings(j['warnings']),
      errorCodes: strings(j['error_codes']),
      warningCodes: strings(j['warning_codes']),
    );
  }

  @override
  List<Object?> get props => [
    row,
    action,
    sku,
    barcode,
    name,
    errors,
    warnings,
  ];
}

/// The answer of a dry run, and of an apply (the same shape).
class ImportReport extends Equatable {
  const ImportReport({
    required this.dryRun,
    required this.summary,
    this.unknownColumns = const [],
    this.setup = const ImportSetup(),
    this.groups = const [],
    this.warningGroups = const [],
    this.rows = const [],
    this.rowsTruncated = false,
    this.batchId,
  });

  final bool dryRun;
  final ImportSummary summary;
  final List<String> unknownColumns;
  final ImportSetup setup;
  final List<ProblemGroup> groups;
  final List<ProblemGroup> warningGroups;

  /// The first rows only (the server cuts the list at 200).
  final List<ImportRow> rows;
  final bool rowsTruncated;
  final String? batchId;

  bool get hasErrors => summary.errors > 0;

  ImportRow? rowAt(int line) {
    for (final r in rows) {
      if (r.row == line) return r;
    }
    return null;
  }

  factory ImportReport.fromJson(Map<String, dynamic> j) => ImportReport(
    dryRun: j['dry_run'] != false,
    summary: ImportSummary.fromJson(
      j['summary'] is Map
          ? Map<String, dynamic>.from(j['summary'] as Map)
          : const {},
    ),
    unknownColumns: [
      for (final c in (j['unknown_columns'] as List? ?? const [])) '$c',
    ],
    setup: ImportSetup.fromJson(
      j['setup'] is Map ? Map<String, dynamic>.from(j['setup'] as Map) : null,
    ),
    groups: [
      for (final g in (j['groups'] as List? ?? const []))
        if (g is Map) ProblemGroup.fromJson(Map<String, dynamic>.from(g)),
    ],
    warningGroups: [
      for (final g in (j['warning_groups'] as List? ?? const []))
        if (g is Map) ProblemGroup.fromJson(Map<String, dynamic>.from(g)),
    ],
    rows: [
      for (final r in (j['rows'] as List? ?? const []))
        if (r is Map) ImportRow.fromJson(Map<String, dynamic>.from(r)),
    ],
    rowsTruncated: j['rows_truncated'] == true,
    batchId: j['batch_id']?.toString(),
  );

  @override
  List<Object?> get props => [
    dryRun,
    summary,
    unknownColumns,
    setup,
    groups,
    warningGroups,
    rows,
    rowsTruncated,
    batchId,
  ];
}

enum ImportBatchStatus { active, undone, expired }

/// One applied import in the "Recent imports" list.
class ImportBatch extends Equatable {
  const ImportBatch({
    required this.id,
    required this.filename,
    required this.status,
    required this.createdCount,
    required this.updatedCount,
    required this.canUndo,
    this.source = 'csv',
    this.createdUnits = 0,
    this.createdCategories = 0,
    this.createdBy,
    this.createdAt,
    this.expiresAt,
    this.undoneAt,
  });

  final String id;
  final String filename;
  final String source;
  final ImportBatchStatus status;
  final int createdCount;
  final int updatedCount;
  final int createdUnits;
  final int createdCategories;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? undoneAt;
  final bool canUndo;

  factory ImportBatch.fromJson(Map<String, dynamic> j) {
    final by = j['created_by'];
    return ImportBatch(
      id: '${j['id']}',
      filename: '${j['filename'] ?? ''}',
      source: '${j['source'] ?? 'csv'}',
      status: switch ('${j['status']}') {
        'undone' => ImportBatchStatus.undone,
        'expired' => ImportBatchStatus.expired,
        _ => ImportBatchStatus.active,
      },
      createdCount: _int(j['created_count']),
      updatedCount: _int(j['updated_count']),
      createdUnits: _int(j['created_units']),
      createdCategories: _int(j['created_categories']),
      createdBy: by is Map ? by['name'] as String? : null,
      createdAt: _date(j['created_at']),
      expiresAt: _date(j['expires_at']),
      undoneAt: _date(j['undone_at']),
      canUndo: j['can_undo'] == true,
    );
  }

  @override
  List<Object?> get props => [
    id,
    filename,
    status,
    createdCount,
    updatedCount,
    canUndo,
    undoneAt,
  ];
}

class UndoResult extends Equatable {
  const UndoResult({this.productsRemoved = 0, this.productsRestored = 0});

  final int productsRemoved;
  final int productsRestored;

  factory UndoResult.fromJson(Map<String, dynamic> j) => UndoResult(
    productsRemoved: _int(j['products_removed']),
    productsRestored: _int(j['products_restored']),
  );

  @override
  List<Object?> get props => [productsRemoved, productsRestored];
}

/// The template the server built from this business.
class ImportTemplate extends Equatable {
  const ImportTemplate({
    required this.fileName,
    required this.bytes,
    required this.kind,
  });

  final String fileName;
  final Uint8List bytes;
  final ImportFileKind kind;

  @override
  List<Object?> get props => [fileName, bytes.length, kind];
}

/// A product that stops an undo ("sold since the import").
class BlockedProduct extends Equatable {
  const BlockedProduct({required this.name, required this.reasons});

  final String name;
  final List<String> reasons;

  @override
  List<Object?> get props => [name, reasons];
}

/// The import cannot go ahead: the server answered 422 `import_has_errors`.
/// The report is the same as a dry run's, so the screen can show it.
class ImportBlockedFailure extends Failure {
  const ImportBlockedFailure(super.message, this.report);

  final ImportReport? report;

  @override
  List<Object?> get props => [message, report];
}

/// The file itself cannot be read (wrong type, too big, formulas, too many rows).
class ImportFileFailure extends Failure {
  const ImportFileFailure(super.message);
}

/// The server refused an undo (409 with a code).
class UndoRefusedFailure extends Failure {
  const UndoRefusedFailure(
    super.message, {
    required this.code,
    this.blocked = const [],
  });

  /// `already_undone`, `undo_expired`, `undo_blocked`, `undo_failed`.
  final String code;
  final List<BlockedProduct> blocked;

  @override
  List<Object?> get props => [message, code, blocked];
}

int _int(Object? v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse('${v ?? ''}') ?? 0;
}

DateTime? _date(Object? v) =>
    v == null ? null : DateTime.tryParse('$v')?.toLocal();
