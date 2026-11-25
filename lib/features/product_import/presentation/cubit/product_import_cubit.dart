import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/product_import/domain/import_copy.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/domain/import_repository.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';

/// The 3-step import: choose a file, review what will happen, done.
class ProductImportCubit extends Cubit<ProductImportState> {
  ProductImportCubit({
    required ProductImportRepository repository,
    bool canCreateTaxRates = false,
  }) : _repo = repository,
       super(ProductImportState(canCreateTaxRates: canCreateTaxRates));

  final ProductImportRepository _repo;
  StreamSubscription<bool>? _onlineSub;

  /// Answers of a check that is no longer the latest are dropped.
  int _seq = 0;

  /// The first answer for a file preselects the "did you mean" suggestions once.
  bool _suggestionsApplied = false;

  static const maxFileBytes = 5 * 1024 * 1024;

  // ── start ────────────────────────────────────────────────────────────

  Future<void> start() async {
    final options = await _repo.options();
    if (isClosed) return;
    emit(state.copyWith(options: options, offline: !_repo.isOnline));
    _onlineSub ??= _repo.onlineChanges.listen((online) {
      if (isClosed) return;
      if (online == state.offline) emit(state.copyWith(offline: !online));
    });
    await loadBatches();
  }

  @override
  Future<void> close() async {
    await _onlineSub?.cancel();
    return super.close();
  }

  Future<void> loadBatches() async {
    if (!_repo.isOnline) return;
    emit(state.copyWith(batchesLoading: true));
    final result = await _repo.batches();
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(batchesLoading: false)),
      (list) => emit(state.copyWith(batches: list, batchesLoading: false)),
    );
  }

  // ── step 1: the file ─────────────────────────────────────────────────

  /// The owner picked (or dropped) a file. It is kept even when the check
  /// cannot run (offline), so nothing has to be chosen again.
  Future<void> chooseFile(ImportFile file) async {
    _seq++;
    _suggestionsApplied = false;
    _onErrorTouched = false;
    emit(
      ProductImportState(
        options: state.options,
        batches: state.batches,
        canCreateTaxRates: state.canCreateTaxRates,
        file: file,
        createAutomatically: true,
        offline: !_repo.isOnline,
      ),
    );
    if (file.sizeBytes == 0) {
      emit(
        state.copyWith(
          clearFile: true,
          error: 'This file is empty. Choose a file with your products in it.',
        ),
      );
      return;
    }
    if (file.sizeBytes > maxFileBytes) {
      emit(
        state.copyWith(
          error:
              'This file is too big (over 5 MB). Split it into smaller files and import them one by one.',
        ),
      );
      return;
    }
    await _review(first: true);
  }

  /// Wrong file type: nothing is kept.
  void rejectFile(String name) {
    emit(
      state.copyWith(
        error:
            '"$name" is not a .csv or .xlsx file. Download the template, fill it in, '
            'and choose that file.',
      ),
    );
  }

  void unreadableFile(String name) {
    emit(
      state.copyWith(
        error:
            'We could not open "$name". Close it in other programs and try again.',
      ),
    );
  }

  /// Try again after a lost connection or an error.
  Future<void> retry() async {
    emit(state.copyWith(offline: !_repo.isOnline));
    if (state.file == null) return;
    if (state.step == ImportStep.review && state.report != null) {
      await _review();
    } else if (state.step == ImportStep.choose) {
      await _review(first: state.report == null);
    }
  }

  /// "Choose another file".
  void startOver() {
    _seq++;
    _onErrorTouched = false;
    emit(
      ProductImportState(
        options: state.options,
        batches: state.batches,
        canCreateTaxRates: state.canCreateTaxRates,
        offline: !_repo.isOnline,
      ),
    );
  }

  // ── step 2: review ───────────────────────────────────────────────────

  ImportOptions _importOptions({ImportOnError? onError}) => ImportOptions(
    onError: onError ?? state.onError,
    createUnits: state.createAutomatically,
    createCategories: state.createAutomatically,
    createTaxRates: state.createAutomatically && state.canCreateTaxRates,
    unitMap: state.unitMap,
    categoryMap: state.categoryMap,
    branchId: _repo.branchId,
  );

  Future<void> _review({bool first = false}) async {
    final file = state.file;
    if (file == null) return;
    if (!_repo.isOnline) {
      emit(state.copyWith(offline: true, checking: false));
      return;
    }
    final seq = ++_seq;
    emit(state.copyWith(checking: true, offline: false, clearError: true));
    final result = await _repo.run(file, _importOptions(), dryRun: true);
    if (isClosed || seq != _seq) return;

    await result.fold<Future<void>>(
      (failure) async => _onCheckFailure(failure),
      (report) async {
        final setup = _mergeSetup(state.setup, report.setup, reset: first);
        var next = state.copyWith(
          checking: false,
          report: report,
          setup: setup,
          step: ImportStep.review,
        );
        if (!_suggestionsApplied) {
          _suggestionsApplied = true;
          final units = {...state.unitMap};
          final categories = {...state.categoryMap};
          for (final i in report.setup.units) {
            if (i.suggestedId != null) units[i.input] = i.suggestedId!;
          }
          for (final i in report.setup.categories) {
            if (i.suggestedId != null) categories[i.input] = i.suggestedId!;
          }
          final changed =
              units.length != state.unitMap.length ||
              categories.length != state.categoryMap.length;
          if (changed) {
            // Check again with the suggestions applied before showing anything.
            emit(
              next.copyWith(
                unitMap: units,
                categoryMap: categories,
                step: state.step,
              ),
            );
            await _review();
            return;
          }
        }
        // Rows with problems: when some rows are fine, skipping is the helpful
        // default; when none is, there is nothing to skip to.
        if (!_onErrorTouched) {
          final s = report.summary;
          next = next.copyWith(
            onError: s.errors > 0 && (s.writable + s.unchanged) > 0
                ? ImportOnError.skip
                : ImportOnError.abort,
          );
        }
        emit(next);
      },
    );
  }

  bool _onErrorTouched = false;

  void _onCheckFailure(Failure failure) {
    if (failure is NetworkFailure) {
      emit(state.copyWith(checking: false, offline: true));
      return;
    }
    if (failure is ImportBlockedFailure && failure.report != null) {
      emit(
        state.copyWith(
          checking: false,
          report: failure.report,
          step: ImportStep.review,
          error: failure.message,
        ),
      );
      return;
    }
    emit(state.copyWith(checking: false, error: failure.message));
  }

  /// Keeps every setup item ever seen for this file (see
  /// [ProductImportState.setup]); newer numbers win.
  static ImportSetup _mergeSetup(
    ImportSetup old,
    ImportSetup fresh, {
    required bool reset,
  }) {
    List<SetupItem> merge(List<SetupItem> a, List<SetupItem> b) {
      final byKey = <String, SetupItem>{
        if (!reset)
          for (final i in a) _key(i.input): i,
      };
      for (final i in b) {
        byKey[_key(i.input)] = i;
      }
      return byKey.values.toList();
    }

    return ImportSetup(
      units: merge(old.units, fresh.units),
      categories: merge(old.categories, fresh.categories),
      taxRates: merge(old.taxRates, fresh.taxRates),
    );
  }

  static String _key(String input) => input.trim().toLowerCase();

  Future<void> setCreateAutomatically(bool on) async {
    if (state.createAutomatically == on) return;
    emit(state.copyWith(createAutomatically: on));
    await _review();
  }

  /// Map a unit written in the file to an existing one (null: create it).
  Future<void> mapUnit(String input, String? unitId) async {
    final map = {...state.unitMap};
    if (unitId == null) {
      map.remove(input);
    } else {
      map[input] = unitId;
    }
    emit(state.copyWith(unitMap: map));
    await _review();
  }

  Future<void> mapCategory(String input, String? categoryId) async {
    final map = {...state.categoryMap};
    if (categoryId == null) {
      map.remove(input);
    } else {
      map[input] = categoryId;
    }
    emit(state.copyWith(categoryMap: map));
    await _review();
  }

  void setOnError(ImportOnError mode) {
    _onErrorTouched = true;
    emit(state.copyWith(onError: mode));
  }

  void setSearch(String text) => emit(state.copyWith(search: text));

  // ── step 3: apply ────────────────────────────────────────────────────

  Future<void> apply() async {
    final file = state.file;
    if (file == null || !state.canApply) return;
    if (!_repo.isOnline) {
      emit(state.copyWith(offline: true));
      return;
    }
    _seq++;
    emit(state.copyWith(applying: true, clearError: true, offline: false));
    final result = await _repo.run(file, _importOptions(), dryRun: false);
    if (isClosed) return;

    await result.fold<Future<void>>(
      (failure) async {
        if (failure is NetworkFailure) {
          emit(state.copyWith(applying: false, offline: true));
        } else if (failure is ImportBlockedFailure) {
          emit(
            state.copyWith(
              applying: false,
              report: failure.report ?? state.report,
              error: 'Nothing was added. ${failure.message}',
            ),
          );
        } else {
          emit(state.copyWith(applying: false, error: failure.message));
        }
      },
      (report) async {
        emit(
          state.copyWith(
            applying: false,
            applied: report,
            step: ImportStep.done,
            clearUndo: true,
          ),
        );
        // The server's new products, units and categories reach this
        // computer before the owner leaves the dialog.
        await _repo.refreshCatalog();
        if (isClosed) return;
        await loadBatches();
        if (isClosed) return;
        final id = report.batchId;
        final batch = id == null
            ? null
            : state.batches.where((b) => b.id == id).firstOrNull;
        if (batch != null) emit(state.copyWith(appliedBatch: batch));
      },
    );
  }

  // ── undo ─────────────────────────────────────────────────────────────

  /// Undo an import (the one just made, or one in "Recent imports").
  Future<void> undo(String batchId) async {
    if (state.undoing) return;
    if (!_repo.isOnline) {
      emit(state.copyWith(offline: true));
      return;
    }
    emit(state.copyWith(undoing: true, clearUndo: true, clearError: true));
    final result = await _repo.undo(batchId);
    if (isClosed) return;
    await result.fold<Future<void>>(
      (failure) async {
        if (failure is UndoRefusedFailure) {
          emit(
            state.copyWith(
              undoing: false,
              undoMessage: ImportCopy.undoRefusal(
                failure.code,
                failure.message,
                failure.blocked,
              ),
            ),
          );
          await loadBatches(); // the list shows "expired" / "undone"
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(undoing: false, offline: true));
        } else {
          emit(state.copyWith(undoing: false, undoMessage: failure.message));
        }
      },
      (undone) async {
        emit(
          state.copyWith(
            undoing: false,
            undoResult: undone,
            undoMessage: _undoneText(undone),
          ),
        );
        await _repo.refreshCatalog();
        if (isClosed) return;
        await loadBatches();
        if (isClosed) return;
        final id = state.appliedBatch?.id;
        final fresh = id == null
            ? null
            : state.batches.where((b) => b.id == id).firstOrNull;
        if (fresh != null) emit(state.copyWith(appliedBatch: fresh));
      },
    );
  }

  static String _undoneText(UndoResult r) {
    final parts = <String>[
      if (r.productsRemoved > 0)
        '${ImportCopy.plural(r.productsRemoved, 'product')} removed',
      if (r.productsRestored > 0)
        '${ImportCopy.plural(r.productsRestored, 'product')} put back as they were',
    ];
    return parts.isEmpty
        ? 'The import was undone.'
        : 'The import was undone: ${parts.join(', ')}.';
  }

  /// A row of "Recent imports" the owner may undo.
  bool canUndoBatch(ImportBatch b) => b.canUndo && !state.undoing;

  // ── template ─────────────────────────────────────────────────────────

  /// The template of this business; the screen saves the bytes.
  Future<ImportTemplate?> downloadTemplate(ImportFileKind kind) async {
    if (!_repo.isOnline) {
      emit(state.copyWith(offline: true));
      return null;
    }
    final result = await _repo.template(kind);
    if (isClosed) return null;
    return result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(state.copyWith(offline: true));
      } else {
        emit(state.copyWith(error: failure.message));
      }
      return null;
    }, (t) => t);
  }
}
