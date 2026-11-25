import 'package:equatable/equatable.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/domain/import_repository.dart';

/// The three steps of the dialog.
enum ImportStep { choose, review, done }

class ProductImportState extends Equatable {
  const ProductImportState({
    this.step = ImportStep.choose,
    this.file,
    this.checking = false,
    this.applying = false,
    this.report,
    this.setup = const ImportSetup(),
    this.createAutomatically = true,
    this.unitMap = const {},
    this.categoryMap = const {},
    this.onError = ImportOnError.abort,
    this.options = const ImportPickOptions(),
    this.error,
    this.offline = false,
    this.applied,
    this.appliedBatch,
    this.undoing = false,
    this.undoResult,
    this.undoMessage,
    this.batches = const [],
    this.batchesLoading = false,
    this.search = '',
    this.canCreateTaxRates = false,
  });

  final ImportStep step;
  final ImportFile? file;

  /// A check of the file is running.
  final bool checking;
  final bool applying;

  /// The latest check of the file.
  final ImportReport? report;

  /// Everything the file uses that the shop does not have, kept even after
  /// the owner maps an item to an existing one (so the choice can be changed).
  final ImportSetup setup;

  /// "Create them automatically".
  final bool createAutomatically;

  /// File spelling -> existing id, the owner's answers.
  final Map<String, String> unitMap;
  final Map<String, String> categoryMap;
  final ImportOnError onError;

  /// The shop's own units and categories, for the dropdowns.
  final ImportPickOptions options;

  /// A plain-words problem with the file or the server.
  final String? error;

  /// Importing needs the internet; the chosen file is kept.
  final bool offline;

  /// The answer of the apply (step 3).
  final ImportReport? applied;
  final ImportBatch? appliedBatch;
  final bool undoing;
  final UndoResult? undoResult;
  final String? undoMessage;

  /// The last imports, newest first.
  final List<ImportBatch> batches;
  final bool batchesLoading;
  final String search;
  final bool canCreateTaxRates;

  ImportSummary get summary => report?.summary ?? const ImportSummary();
  bool get busy => checking || applying || undoing;

  /// Only the owner's answer decides for rows with problems.
  bool get problemsBlock =>
      summary.errors > 0 && onError == ImportOnError.abort;

  bool get canApply =>
      report != null &&
      !busy &&
      !offline &&
      summary.writable > 0 &&
      !problemsBlock;

  /// Why Apply is off, in words (null when it is on).
  String? get applyHint {
    if (report == null || busy) return null;
    if (offline) return 'Connect to the internet to import.';
    if (summary.writable == 0) {
      return summary.errors > 0
          ? 'Every row has a problem. Fix the file and choose it again.'
          : 'There is nothing new to import in this file.';
    }
    if (problemsBlock)
      return 'Fix the problems, or choose "Skip problem rows".';
    return null;
  }

  ProductImportState copyWith({
    ImportStep? step,
    ImportFile? file,
    bool clearFile = false,
    bool? checking,
    bool? applying,
    ImportReport? report,
    bool clearReport = false,
    ImportSetup? setup,
    bool? createAutomatically,
    Map<String, String>? unitMap,
    Map<String, String>? categoryMap,
    ImportOnError? onError,
    ImportPickOptions? options,
    String? error,
    bool clearError = false,
    bool? offline,
    ImportReport? applied,
    bool clearApplied = false,
    ImportBatch? appliedBatch,
    bool? undoing,
    UndoResult? undoResult,
    String? undoMessage,
    bool clearUndo = false,
    List<ImportBatch>? batches,
    bool? batchesLoading,
    String? search,
  }) => ProductImportState(
    step: step ?? this.step,
    file: clearFile ? null : (file ?? this.file),
    checking: checking ?? this.checking,
    applying: applying ?? this.applying,
    report: clearReport ? null : (report ?? this.report),
    setup: setup ?? this.setup,
    createAutomatically: createAutomatically ?? this.createAutomatically,
    unitMap: unitMap ?? this.unitMap,
    categoryMap: categoryMap ?? this.categoryMap,
    onError: onError ?? this.onError,
    options: options ?? this.options,
    error: clearError ? null : (error ?? this.error),
    offline: offline ?? this.offline,
    applied: clearApplied ? null : (applied ?? this.applied),
    appliedBatch: clearApplied ? null : (appliedBatch ?? this.appliedBatch),
    undoing: undoing ?? this.undoing,
    undoResult: clearUndo ? null : (undoResult ?? this.undoResult),
    undoMessage: clearUndo ? null : (undoMessage ?? this.undoMessage),
    batches: batches ?? this.batches,
    batchesLoading: batchesLoading ?? this.batchesLoading,
    search: search ?? this.search,
    canCreateTaxRates: canCreateTaxRates,
  );

  @override
  List<Object?> get props => [
    step,
    file,
    checking,
    applying,
    report,
    setup,
    createAutomatically,
    unitMap,
    categoryMap,
    onError,
    error,
    offline,
    applied,
    appliedBatch,
    undoing,
    undoResult,
    undoMessage,
    batches,
    batchesLoading,
    search,
    canCreateTaxRates,
  ];
}
