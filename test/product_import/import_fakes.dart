import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/features/product_import/data/import_file_picker.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/domain/import_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';

ImportFile csvFile(String text, {String name = 'products.csv'}) =>
    ImportFile(name: name, bytes: Uint8List.fromList(utf8.encode(text)), kind: ImportFileKind.csv);

/// A report like the server's, with only what a test names.
ImportReport report({
  bool dryRun = true,
  int total = 0,
  int create = 0,
  int update = 0,
  int unchanged = 0,
  int errors = 0,
  int warnings = 0,
  ImportSetup setup = const ImportSetup(),
  List<ProblemGroup> groups = const [],
  List<ProblemGroup> warningGroups = const [],
  List<ImportRow> rows = const [],
  String? batchId,
}) =>
    ImportReport(
      dryRun: dryRun,
      summary: ImportSummary(
        totalRows: total == 0 ? create + update + unchanged + errors : total,
        create: create,
        update: update,
        unchanged: unchanged,
        errors: errors,
        warnings: warnings,
        applied: dryRun ? 0 : create + update,
      ),
      setup: setup,
      groups: groups,
      warningGroups: warningGroups,
      rows: rows,
      batchId: batchId,
    );

const kgUnit = PickOption('u-kg', 'Kilogram');
const pktUnit = PickOption('u-pkt', 'Packet');
const groceries = PickOption('c-groc', 'Groceries');

ImportBatch batch({
  String id = 'b1',
  ImportBatchStatus status = ImportBatchStatus.active,
  bool canUndo = true,
  int created = 24,
  int updated = 0,
  String filename = 'products.csv',
}) =>
    ImportBatch(
      id: id,
      filename: filename,
      status: status,
      createdCount: created,
      updatedCount: updated,
      canUndo: canUndo,
      createdAt: DateTime(2026, 11, 20, 10, 30),
      createdBy: 'Owner',
    );

/// Records what the screen asks for; answers come from the closures.
class FakeImportRepository implements ProductImportRepository {
  FakeImportRepository({
    this.online = true,
    this.pickOptions = const ImportPickOptions(units: [kgUnit, pktUnit], categories: [groceries]),
    this.dryRunReport,
    this.applyReport,
    List<ImportBatch>? batchList,
  }) : batchList = batchList ?? [];

  bool online;
  ImportPickOptions pickOptions;
  ImportReport? dryRunReport;
  ImportReport? applyReport;
  List<ImportBatch> batchList;

  /// Answers by call, when a test needs the report to depend on the options.
  ImportReport Function(ImportOptions options, bool dryRun)? reportFor;
  Failure? runFailure;
  Failure? undoFailure;
  UndoResult undoResult = const UndoResult(productsRemoved: 24);
  ImportTemplate? templateResult;
  Failure? templateFailure;
  String? branch;

  final calls = <({ImportFile file, ImportOptions options, bool dryRun})>[];
  final undone = <String>[];
  final templates = <ImportFileKind>[];
  int refreshes = 0;
  int batchLoads = 0;
  final _online = StreamController<bool>.broadcast();

  void setOnline(bool v) {
    online = v;
    _online.add(v);
  }

  Future<void> dispose() => _online.close();

  @override
  bool get isOnline => online;

  @override
  Stream<bool> get onlineChanges => _online.stream;

  @override
  String? get branchId => branch;

  @override
  Future<ImportPickOptions> options() async => pickOptions;

  @override
  Future<Either<Failure, ImportReport>> run(
    ImportFile file,
    ImportOptions options, {
    required bool dryRun,
  }) async {
    calls.add((file: file, options: options, dryRun: dryRun));
    if (runFailure != null) return Left(runFailure!);
    final r = reportFor?.call(options, dryRun) ?? (dryRun ? dryRunReport : applyReport) ?? report(dryRun: dryRun);
    return Right(r);
  }

  @override
  Future<Either<Failure, ImportTemplate>> template(ImportFileKind kind) async {
    templates.add(kind);
    if (templateFailure != null) return Left(templateFailure!);
    return Right(
      templateResult ??
          ImportTemplate(
            fileName: 'products_template.${kind.extension}',
            bytes: Uint8List.fromList(utf8.encode('name,price\n')),
            kind: kind,
          ),
    );
  }

  @override
  Future<Either<Failure, List<ImportBatch>>> batches() async {
    batchLoads++;
    return Right(List.of(batchList));
  }

  @override
  Future<Either<Failure, UndoResult>> undo(String batchId) async {
    undone.add(batchId);
    if (undoFailure != null) return Left(undoFailure!);
    batchList = [
      for (final b in batchList)
        if (b.id == batchId)
          batch(id: b.id, status: ImportBatchStatus.undone, canUndo: false, created: b.createdCount)
        else
          b,
    ];
    return Right(undoResult);
  }

  @override
  Future<void> refreshCatalog() async => refreshes++;
}

/// A [FileSaverService] that keeps what was saved and never opens a dialog.
class FakeFiles extends Fake implements FileSaverService {
  final saved = <({String name, Uint8List bytes})>[];
  final opened = <String>[];
  String? savePath = r'C:\Users\test\Downloads\file';

  @override
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  }) async {
    if (savePath == null) return null;
    saved.add((name: suggestedName, bytes: bytes));
    return '$savePath\\$suggestedName';
  }

  @override
  Future<void> openFolder(String filePath) async => opened.add(filePath);
}

/// Hands the dialog a file without a native window.
class FakePicker extends ImportFilePicker {
  FakePicker(super.files);

  PickedFile? next;
  int picks = 0;

  @override
  Future<PickedFile?> pick() async {
    picks++;
    return next;
  }
}
