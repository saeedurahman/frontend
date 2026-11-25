import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';

/// The shop's units and categories, for the "use an existing one" dropdowns.
class ImportPickOptions {
  const ImportPickOptions({this.units = const [], this.categories = const []});

  final List<PickOption> units;
  final List<PickOption> categories;
}

abstract class ProductImportRepository {
  /// False when the server cannot be reached: importing needs the internet.
  bool get isOnline;

  Stream<bool> get onlineChanges;

  /// The branch that receives opening stock (null: the server picks the only one).
  String? get branchId;

  Future<ImportPickOptions> options();

  /// `dry_run: true` checks the file and writes nothing; `false` applies it.
  Future<Either<Failure, ImportReport>> run(
    ImportFile file,
    ImportOptions options, {
    required bool dryRun,
  });

  /// The template built from THIS business (its units, categories, tax rates).
  Future<Either<Failure, ImportTemplate>> template(ImportFileKind kind);

  Future<Either<Failure, List<ImportBatch>>> batches();

  Future<Either<Failure, UndoResult>> undo(String batchId);

  /// Brings the server's changes into the local catalog right away so the
  /// Products list, the POS and the pickers show them without waiting.
  Future<void> refreshCatalog();
}
