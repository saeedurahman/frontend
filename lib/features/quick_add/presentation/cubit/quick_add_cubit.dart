import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/paid_now_hook.dart';
import 'package:frantend/features/khata/presentation/cubit/paid_now_cubit.dart'
    show receivedMessage;
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';
import 'package:frantend/features/quick_add/domain/expiry_parser.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';
import 'package:frantend/features/quick_add/domain/scan_interpreter.dart';

import 'quick_add_state.dart';

/// What Ctrl+Z takes back: the last scan or the last delete.
sealed class _Undo {}

class _UndoNewRow extends _Undo {
  _UndoNewRow(this.rowId);
  final String rowId;
}

class _UndoIncrement extends _Undo {
  _UndoIncrement(this.before, this.index);
  final QuickAddRow before;
  final int index;
}

class _UndoDelete extends _Undo {
  _UndoDelete(this.row, this.index);
  final QuickAddRow row;
  final int index;
}

/// The Quick Add screen's brain: scan -> row, keyboard flow, undo, draft, save.
///
/// Scanning never waits for the network: a barcode the local copy does not
/// know becomes a new row at once and the server lookup (1.5 s cap) fills it
/// in when it answers.
class QuickAddCubit extends Cubit<QuickAddState> {
  QuickAddCubit({
    required QuickAddRepository repository,
    required QuickAddDraftStore draftStore,
    required IdGenerator ids,
    ProductSuggestionProvider suggestions = const NoProductSuggestions(),
    Duration draftDebounce = const Duration(milliseconds: 300),
    DateTime Function()? clock,
  })  : _repo = repository,
        _drafts = draftStore,
        _ids = ids,
        _suggestions = suggestions,
        _draftDebounce = draftDebounce,
        _clock = clock ?? DateTime.now,
        super(QuickAddState());

  final QuickAddRepository _repo;
  final QuickAddDraftStore _drafts;
  final IdGenerator _ids;
  final ProductSuggestionProvider _suggestions;
  final Duration _draftDebounce;
  final DateTime Function() _clock;

  final List<_Undo> _undo = [];
  static const _maxUndo = 100;

  QuickAddDraft? _pendingDraft;
  Timer? _draftTimer;
  Future<void> _scanQueue = Future.value();
  StreamSubscription<QuickAddSettings>? _settingsSub;
  StreamSubscription<bool>? _onlineSub;
  int _seq = 0;
  int _tokens = 0;

  /// The save in flight / last failed: reused only while the body is the same.
  String? _attemptKey;
  String? _attemptHash;

  int get _nextToken => ++_tokens;

  // ── start / stop ──────────────────────────────────────────────────────

  Future<void> start() async {
    final settings = await _repo.settings();
    final options = await _repo.options();
    emit(state.copyWith(
      loading: false,
      settings: settings,
      options: options,
      online: _repo.isOnline,
      focus: FocusRequest(token: _nextToken),
    ));
    _settingsSub = _repo.settingsChanges.listen((s) {
      if (!isClosed) emit(state.copyWith(settings: s));
    });
    _onlineSub = _repo.onlineChanges.listen((v) {
      if (!isClosed) emit(state.copyWith(online: v));
    });
    final draft = await _drafts.load();
    if (draft != null && draft.rows.isNotEmpty && !isClosed) {
      _pendingDraft = draft;
      emit(state.copyWith(restorable: draft.itemCount));
    }
  }

  /// "Resume your Quick Add draft (37 items)".
  void resumeDraft() {
    final d = _pendingDraft;
    if (d == null) return;
    _pendingDraft = null;
    _seq = d.seq;
    for (final r in d.rows) {
      if (r.seq > _seq) _seq = r.seq;
    }
    _attemptKey = d.attemptKey;
    _attemptHash = d.attemptHash;
    emit(state.copyWith(
      mode: d.mode,
      supplierId: d.supplierId,
      supplierName: d.supplierName,
      clearSupplier: d.supplierId == null,
      rows: [...d.rows]..sort((a, b) => b.seq.compareTo(a.seq)),
      lastCategoryId: d.lastCategoryId,
      lastCategoryLabel: d.lastCategoryLabel,
      clearRestorable: true,
      focus: FocusRequest(token: _nextToken),
    ));
  }

  /// "Start fresh": the saved draft is thrown away.
  Future<void> discardDraft() async {
    _pendingDraft = null;
    emit(state.copyWith(clearRestorable: true, focus: FocusRequest(token: _nextToken)));
    await _drafts.clear();
  }

  @override
  Future<void> close() async {
    _draftTimer?.cancel();
    await _settingsSub?.cancel();
    await _onlineSub?.cancel();
    if (state.rows.isNotEmpty && _pendingDraft == null) {
      try {
        await _drafts.save(_draft());
      } catch (_) {}
    }
    return super.close();
  }

  /// Reloads the pickers (suppliers arrive late when the app started offline).
  Future<void> refreshOptions() async {
    final options = await _repo.options();
    if (!isClosed) emit(state.copyWith(options: options));
  }

  // ── mode / supplier ───────────────────────────────────────────────────

  void setMode(QuickAddMode mode) {
    if (mode == state.mode) return;
    emit(state.copyWith(mode: mode, validated: false, clearBanner: true));
    _persist();
  }

  void setSupplier(String? id, String? name) {
    emit(state.copyWith(
      supplierId: id,
      supplierName: name,
      clearSupplier: id == null,
      clearBanner: true,
    ));
    _persist();
  }

  // ── scanning ──────────────────────────────────────────────────────────

  /// Handles one scan. Scans are handled strictly in order, so two fast scans
  /// of the same code always end up as one row with quantity 2.
  Future<void> scan(String raw) {
    final next = _scanQueue.then((_) => _handleScan(raw)).catchError((Object _) {});
    _scanQueue = next;
    return next;
  }

  Future<void> _handleScan(String raw) async {
    if (isClosed || state.restorable != null) return;
    final input = ScanInterpreter.interpret(raw, now: _clock());
    if (input.isEmpty) {
      _feedback(ScanTone.error, 'That does not look like a barcode. Please scan again.');
      _focusScan();
      return;
    }
    final barcode = input.barcode;

    // Same item again: one more on its row.
    final at = _findRow(input);
    if (at >= 0) {
      _incrementRow(at, input);
      return;
    }

    final known = await _repo.findLocal(barcode);
    if (isClosed) return;
    if (known != null) {
      _addRow(_knownRow(input, known), askName: false);
      return;
    }

    final online = _repo.isOnline;
    final row = _newRow(input, lookupPending: online);
    _addRow(row, askName: true);
    unawaited(_enrich(row.id, barcode, online: online));
  }

  int _findRow(ScanInput input) {
    for (var i = 0; i < state.rows.length; i++) {
      final r = state.rows[i];
      if (r.error?.code == 'barcode_deleted') continue;
      if (!BarcodeNormalizer.normalize(r.barcode).sameItemAs(input.barcode)) continue;
      final batch = input.batch;
      if (batch != null && r.batchNo.trim().isNotEmpty && r.batchNo.trim() != batch.trim()) {
        continue; // another batch of the same product is its own line
      }
      return i;
    }
    return -1;
  }

  QuickAddRow _knownRow(ScanInput input, KnownProduct p) {
    final b = input.barcode;
    return QuickAddRow(
      id: _ids.newId(),
      barcode: b.canonical,
      rawBarcode: b.raw,
      barcodeWarning: b.hasBadCheckDigit,
      name: p.name,
      brand: p.brand ?? '',
      unitId: p.unitId,
      unitLabel: p.unitLabel,
      categoryId: p.categoryId,
      cost: p.costPrice,
      salePrice: p.salePrice,
      currentStock: p.stockOnHand,
      trackExpiry: p.trackExpiry,
      productId: p.id,
      variationId: p.variationId,
      imageUrl: p.imageUrl,
      batchNo: input.batch ?? '',
      expiry: input.expiry,
      suggestionSource: 'shop',
      seq: ++_seq,
    );
  }

  QuickAddRow _newRow(ScanInput input, {required bool lookupPending}) {
    final b = input.barcode;
    final settings = state.settings;
    return QuickAddRow(
      id: _ids.newId(),
      barcode: b.canonical,
      rawBarcode: b.raw,
      barcodeWarning: b.hasBadCheckDigit,
      unitLabel: state.options.defaultUnit?.label,
      categoryId: state.lastCategoryId,
      categoryLabel: state.lastCategoryLabel,
      trackExpiry: settings.askExpiry,
      batchNo: input.batch ?? '',
      expiry: input.expiry,
      lookupPending: lookupPending,
      seq: ++_seq,
    );
  }

  void _addRow(QuickAddRow row, {required bool askName}) {
    final settings = state.settings;
    final stop = QuickAddFlow.firstStop(row, settings, state.mode);
    _undo.add(_UndoNewRow(row.id));
    _trimUndo();
    final warn = row.barcodeWarning;
    emit(state.copyWith(
      rows: [row, ...state.rows],
      highlightRowId: row.id,
      canUndo: true,
      validated: false,
      clearBanner: true,
      focus: stop == null
          ? FocusRequest(token: _nextToken)
          : FocusRequest(token: _nextToken, rowId: row.id, field: stop),
      feedback: ScanFeedback(
        _nextToken,
        warn ? ScanTone.warning : ScanTone.success,
        warn
            ? 'Added, but the barcode may be misread (its check digit does not match). Please check it.'
            : row.isKnown
                ? '${row.name} added'
                : 'New item. Type its name.',
      ),
    ));
    _persist();
  }

  void _incrementRow(int index, ScanInput input) {
    final before = state.rows[index];
    _undo.add(_UndoIncrement(before, index));
    _trimUndo();
    var row = before.copyWith(
      qty: before.qty + Decimal.one,
      pulse: before.pulse + 1,
      seq: ++_seq,
    );
    // A GS1 scan can complete a row's batch / expiry.
    if (input.batch != null && row.batchNo.trim().isEmpty) {
      row = row.copyWith(batchNo: input.batch);
    }
    if (input.expiry != null && row.expiry == null) {
      row = row.copyWith(expiry: input.expiry);
    }
    final rows = [...state.rows]..removeAt(index);
    emit(state.copyWith(
      rows: [row, ...rows],
      highlightRowId: row.id,
      canUndo: true,
      validated: false,
      focus: FocusRequest(token: _nextToken),
      feedback: ScanFeedback(
        _nextToken,
        ScanTone.success,
        '${row.name.trim().isEmpty ? 'Item' : row.name}: ${row.qty}',
      ),
    ));
    _persist();
  }

  /// Server lookup + catalogue suggestion for an unknown barcode. Runs behind
  /// the scenes: the row already exists and the owner may be typing in it.
  Future<void> _enrich(String rowId, NormalizedBarcode barcode, {required bool online}) async {
    ProductLookup? lookup;
    if (online) {
      try {
        lookup = await _repo.lookupRemote(barcode);
      } catch (_) {}
    }
    ProductSuggestion? suggestion = lookup?.suggestion;
    if (suggestion == null && lookup?.product == null) {
      try {
        suggestion = await _suggestions.suggest(barcode);
      } catch (_) {}
    }
    if (isClosed) return;
    final current = state.row(rowId);
    if (current == null) return;

    var row = current.copyWith(lookupPending: false);
    final product = lookup?.product;
    if (product != null) {
      row = row.copyWith(
        name: row.hasName ? row.name : product.name,
        brand: row.brand.isEmpty ? (product.brand ?? '') : row.brand,
        unitId: product.unitId,
        unitLabel: product.unitLabel,
        categoryId: product.categoryId,
        cost: row.cost ?? product.costPrice,
        salePrice: product.salePrice,
        salePriceSuggested: false,
        currentStock: product.stockOnHand,
        trackExpiry: product.trackExpiry || row.trackExpiry,
        productId: product.id,
        variationId: product.variationId,
        imageUrl: product.imageUrl,
        suggestionSource: 'shop',
      );
    } else if (suggestion != null) {
      row = _applySuggestion(row, suggestion);
    }
    _replaceRow(row, persist: true);
  }

  QuickAddRow _applySuggestion(QuickAddRow row, ProductSuggestion s) {
    var r = row;
    if (!r.nameTouched && r.name.trim().isEmpty && s.name != null) r = r.copyWith(name: s.name);
    if (r.brand.isEmpty && s.brand != null) r = r.copyWith(brand: s.brand);
    if (r.packSize.isEmpty && s.packSize != null) r = r.copyWith(packSize: s.packSize);
    if (r.imageUrl == null && s.imageUrl != null) r = r.copyWith(imageUrl: s.imageUrl);
    if (s.mrp != null) r = r.copyWith(mrp: s.mrp);
    if (s.unitHint != null && r.unitId == null) {
      final match = _matchOption(state.options.units, s.unitHint!);
      if (match != null) r = r.copyWith(unitId: match.id, unitLabel: match.label);
    }
    if (s.categoryHint != null && r.categoryId == null) {
      final match = _matchOption(state.options.categories, s.categoryHint!);
      if (match != null) r = r.copyWith(categoryId: match.id, categoryLabel: match.label);
    }
    r = r.copyWith(suggestionSource: s.source);
    return _suggestPrice(r);
  }

  static PickOption? _matchOption(List<PickOption> options, String hint) {
    final h = hint.trim().toLowerCase();
    for (final o in options) {
      if (o.label.trim().toLowerCase() == h) return o;
    }
    return null;
  }

  // ── editing cells ─────────────────────────────────────────────────────

  QuickAddRow _suggestPrice(QuickAddRow row) {
    if (row.isKnown) return row;
    // Only a price the owner has not set themselves may be replaced.
    if (row.salePrice != null && !row.salePriceSuggested) return row;
    final s = state.settings.suggest(mrp: row.mrp, cost: row.cost);
    return s == null
        ? row.copyWith(clearSalePrice: true, salePriceSuggested: false)
        : row.copyWith(salePrice: s, salePriceSuggested: true);
  }

  static Decimal? _number(String text) {
    final t = text.trim().replaceAll(',', '');
    return t.isEmpty ? null : Decimal.tryParse(t);
  }

  /// Applies typed text of a cell. Numbers that do not parse are ignored (the
  /// cell only lets digits through anyway).
  void setText(String rowId, QuickAddField field, String text) {
    final row = state.row(rowId);
    if (row == null) return;
    var r = row.copyWith(clearError: true);
    switch (field) {
      case QuickAddField.barcode:
        final n = BarcodeNormalizer.normalize(text);
        r = r.copyWith(
          barcode: n.isEmpty ? text.trim() : n.canonical,
          barcodeWarning: n.hasBadCheckDigit,
        );
        if (r.barcode != row.barcode && row.isKnown) {
          // A different code is not that product any more.
          r = QuickAddRow(
            id: r.id,
            barcode: r.barcode,
            rawBarcode: r.rawBarcode,
            barcodeWarning: r.barcodeWarning,
            name: r.name,
            nameTouched: true,
            brand: r.brand,
            unitLabel: state.options.defaultUnit?.label,
            categoryId: r.categoryId,
            categoryLabel: r.categoryLabel,
            newCategoryName: r.newCategoryName,
            qty: r.qty,
            cost: r.cost,
            salePrice: r.salePrice,
            batchNo: r.batchNo,
            expiry: r.expiry,
            trackExpiry: state.settings.askExpiry,
            seq: r.seq,
            pulse: r.pulse,
          );
        }
      case QuickAddField.name:
        r = r.copyWith(name: text, nameTouched: true);
      case QuickAddField.brand:
        r = r.copyWith(brand: text);
      case QuickAddField.qty:
        r = r.copyWith(qty: _number(text) ?? Decimal.zero);
      case QuickAddField.cost:
        final cost = _number(text);
        r = cost == null ? r.copyWith(clearCost: true) : r.copyWith(cost: cost);
        r = _suggestPrice(r);
      case QuickAddField.salePrice:
        final price = _number(text);
        r = price == null
            ? r.copyWith(clearSalePrice: true, salePriceSuggested: false)
            : r.copyWith(
                salePrice: price,
                salePriceSuggested: false,
                updatePrice: row.isKnown ? true : row.updatePrice,
              );
      case QuickAddField.batch:
        r = r.copyWith(batchNo: text);
      case QuickAddField.expiry:
      case QuickAddField.unit:
      case QuickAddField.category:
        return; // pickers / date have their own methods
    }
    _replaceRow(r, persist: true, validated: false);
  }

  void setExpiry(String rowId, DateTime? date) {
    final row = state.row(rowId);
    if (row == null) return;
    _replaceRow(
      date == null
          ? row.copyWith(clearExpiry: true, clearError: true)
          : row.copyWith(expiry: date, clearError: true),
      persist: true,
      validated: false,
    );
  }

  /// Convenience for the Expiry cell: text like `06/2027`.
  DateTime? setExpiryText(String rowId, String text) {
    final parsed = ExpiryParser.parse(text, now: _clock());
    setExpiry(rowId, parsed);
    return parsed;
  }

  void setUnit(String rowId, PickOption? unit) {
    final row = state.row(rowId);
    if (row == null) return;
    _replaceRow(
      unit == null
          ? row.copyWith(clearUnit: true, clearError: true)
          : row.copyWith(unitId: unit.id, unitLabel: unit.label, clearError: true),
      persist: true,
      validated: false,
    );
  }

  /// A unit the shop does not have yet ("Create 'Strip'"): the server creates
  /// it while saving.
  void setNewUnit(String rowId, String name) {
    final row = state.row(rowId);
    final clean = name.trim();
    if (row == null || clean.isEmpty) return;
    _replaceRow(
      row
          .copyWith(clearUnit: true, clearError: true)
          .copyWith(unitLabel: clean, newUnitName: clean),
      persist: true,
      validated: false,
    );
  }

  /// Same for a category. Unlike a picked category it is not carried to the
  /// next scans: it has no id until the server creates it.
  void setNewCategory(String rowId, String name) {
    final row = state.row(rowId);
    final clean = name.trim();
    if (row == null || clean.isEmpty) return;
    _replaceRow(
      row
          .copyWith(clearCategory: true, clearError: true)
          .copyWith(categoryLabel: clean, newCategoryName: clean),
      persist: true,
      validated: false,
    );
  }

  /// A category picked for a row becomes the default for the next scans.
  void setCategory(String rowId, PickOption? category) {
    final row = state.row(rowId);
    if (row == null) return;
    _replaceRow(
      category == null
          ? row.copyWith(clearCategory: true, clearError: true)
          : row.copyWith(
              categoryId: category.id,
              categoryLabel: category.label,
              clearError: true,
            ),
      persist: true,
      validated: false,
      lastCategory: category,
    );
  }

  /// "No expiry date" / "Has an expiry date" for one row.
  void setTrackExpiry(String rowId, bool track) {
    final row = state.row(rowId);
    if (row == null) return;
    _replaceRow(
      row.copyWith(
        trackExpiry: track,
        clearError: true,
        clearExpiry: !track,
        batchNo: track ? row.batchNo : '',
      ),
      persist: true,
      validated: false,
    );
  }

  /// Enter / Tab on the sale price: the suggested value is now the owner's.
  void confirmSuggestedPrice(String rowId) {
    final row = state.row(rowId);
    if (row == null || !row.salePriceSuggested) return;
    _replaceRow(row.copyWith(salePriceSuggested: false), persist: true);
  }

  void _replaceRow(
    QuickAddRow row, {
    bool persist = false,
    bool? validated,
    PickOption? lastCategory,
  }) {
    final i = state.rows.indexWhere((r) => r.id == row.id);
    if (i < 0) return;
    final rows = [...state.rows]..[i] = row;
    emit(state.copyWith(
      rows: rows,
      validated: validated,
      lastCategoryId: lastCategory?.id,
      lastCategoryLabel: lastCategory?.label,
    ));
    if (persist) _persist();
  }

  // ── keyboard flow ─────────────────────────────────────────────────────

  /// Enter in a cell: next step of the flow, else back to the scan field.
  void enterPressed(String rowId, QuickAddField from) {
    final row = state.row(rowId);
    if (row == null) {
      _focusScan();
      return;
    }
    if (from == QuickAddField.salePrice) confirmSuggestedPrice(rowId);
    final next = QuickAddFlow.nextAfter(
      state.row(rowId) ?? row,
      from,
      state.settings,
      state.mode,
    );
    emit(state.copyWith(
      focus: next == null
          ? FocusRequest(token: _nextToken)
          : FocusRequest(token: _nextToken, rowId: rowId, field: next),
    ));
  }

  void focusScan() => _focusScan();

  /// Puts the keyboard focus on a row itself (arrow keys, Delete).
  void focusRow(String rowId) =>
      emit(state.copyWith(focus: FocusRequest(token: _nextToken, rowId: rowId)));

  void _focusScan() => emit(state.copyWith(focus: FocusRequest(token: _nextToken)));

  // ── delete / undo ─────────────────────────────────────────────────────

  void deleteRow(String rowId) {
    final i = state.rows.indexWhere((r) => r.id == rowId);
    if (i < 0) return;
    final row = state.rows[i];
    _undo.add(_UndoDelete(row, i));
    _trimUndo();
    final rows = [...state.rows]..removeAt(i);
    emit(state.copyWith(
      rows: rows,
      canUndo: true,
      clearHighlight: state.highlightRowId == rowId,
      undoToast: UndoToast(_nextToken, '${row.hasName ? row.name : row.barcode} removed'),
      focus: FocusRequest(token: _nextToken),
    ));
    _persist();
  }

  /// Ctrl+Z: takes back the last scan or delete.
  void undo() {
    if (_undo.isEmpty) return;
    final op = _undo.removeLast();
    var rows = [...state.rows];
    String message;
    switch (op) {
      case _UndoNewRow(:final rowId):
        rows.removeWhere((r) => r.id == rowId);
        message = 'Last scan undone';
      case _UndoIncrement(:final before, :final index):
        rows.removeWhere((r) => r.id == before.id);
        rows.insert(index.clamp(0, rows.length), before);
        message = 'Last scan undone';
      case _UndoDelete(:final row, :final index):
        rows.insert(index.clamp(0, rows.length), row);
        message = '${row.hasName ? row.name : row.barcode} is back';
    }
    emit(state.copyWith(
      rows: rows,
      canUndo: _undo.isNotEmpty,
      clearUndoToast: true,
      clearHighlight: true,
      feedback: ScanFeedback(_nextToken, ScanTone.success, message),
      focus: FocusRequest(token: _nextToken),
    ));
    _persist();
  }

  void _trimUndo() {
    if (_undo.length > _maxUndo) _undo.removeRange(0, _undo.length - _maxUndo);
  }

  // ── save ──────────────────────────────────────────────────────────────

  /// The "Paid now" section of the screen. Set by the page; null = no payment
  /// is ever sent (everything stays on credit).
  PaidNowHook? paidNow;

  /// The bill total of the list: quantity x cost per row (rows without a cost
  /// count as zero until the owner types it).
  Decimal get purchaseTotal {
    var sum = Decimal.zero;
    for (final r in state.rows) {
      final cost = r.cost;
      if (cost == null || r.qty <= Decimal.zero) continue;
      sum += r.qty * cost;
    }
    return sum.round(scale: 2);
  }

  QuickAddRequest _request(
    List<QuickAddRow> rows, {
    ReceiptPaymentInput? payment,
  }) =>
      QuickAddRequest(
        mode: state.mode,
        supplierId: state.supplierId,
        branchId: _repo.branchId,
        // Oldest first, so the server creates products in scan order.
        rows: rows.reversed.toList(),
        payment: payment,
      );

  static String _hash(QuickAddRequest r) =>
      sha1.convert(utf8.encode(jsonEncode(r.toJson()))).toString();

  /// Checks every row; returns true when all are fine. Problems are put on
  /// the rows (red) and the focus goes to the first one.
  bool validateAll() {
    final settings = state.settings;
    var firstBad = true;
    FocusRequest? focus;
    final rows = <QuickAddRow>[];
    var bad = 0;
    for (final r in state.rows) {
      final errors = QuickAddValidator.validate(
        r,
        settings: settings,
        mode: state.mode,
        now: _clock(),
      );
      if (errors.isEmpty) {
        rows.add(r.error == null ? r : r.copyWith(clearError: true));
        continue;
      }
      bad++;
      final field = errors.keys.first;
      rows.add(r.copyWith(error: RowError(message: errors[field]!, field: field)));
      if (firstBad) {
        firstBad = false;
        focus = FocusRequest(token: _nextToken, rowId: r.id, field: field);
      }
    }
    emit(state.copyWith(rows: rows, validated: true));
    if (bad > 0) {
      emit(state.copyWith(
        focus: focus,
        banner: bad == 1
            ? '1 item needs a change before saving. It is marked in red.'
            : '$bad items need a change before saving. They are marked in red.',
        feedback: ScanFeedback(_nextToken, ScanTone.error, 'Please fix the red items'),
      ));
      return false;
    }
    return true;
  }

  /// Ctrl+S / "Save all".
  Future<void> save() async {
    if (state.saving || state.rows.isEmpty || state.restorable != null) return;
    emit(state.copyWith(clearBanner: true, clearSummary: true));
    if (!validateAll()) return;

    if (state.mode == QuickAddMode.purchase && state.supplierId == null) {
      emit(state.copyWith(
        banner: 'Pick the supplier first. The stock is booked on their account.',
        feedback: ScanFeedback(_nextToken, ScanTone.error, 'Pick the supplier first'),
      ));
      return;
    }

    final online = _repo.isOnline;
    if (!online) {
      emit(state.copyWith(
        online: false,
        banner: "You're offline. Your list is safe on this computer. "
            'Connect to the internet, then tap Save all.',
        feedback: ScanFeedback(_nextToken, ScanTone.error, 'No internet. Draft kept.'),
      ));
      await _saveDraftNow();
      return;
    }

    final isPurchase = state.mode == QuickAddMode.purchase;
    final hook = isPurchase ? paidNow : null;
    final total = purchaseTotal;
    final blocked = hook?.blockingProblem(total);
    if (blocked != null) {
      emit(state.copyWith(
        banner: blocked,
        feedback: ScanFeedback(_nextToken, ScanTone.error, 'Check "Paid now"'),
      ));
      return;
    }
    final payment = hook?.inputFor(total);

    final request = _request(state.rows, payment: payment);
    final hash = _hash(request);
    // Same list as the failed try: same key, so the server can tell it is a
    // retry and never books the stock twice.
    if (_attemptHash != hash || _attemptKey == null) {
      _attemptKey = _ids.newId();
      _attemptHash = hash;
    }
    final key = _attemptKey!;
    emit(state.copyWith(saving: true, online: true));
    await _saveDraftNow();

    final result = await _repo.submit(request, idempotencyKey: key);
    if (isClosed) return;
    await result.fold<Future<void>>(
      (failure) async {
        final code = failure is ServerFailure
            ? failure.code
            : failure is ConflictFailure
                ? failure.code
                : null;
        // A clear "no" from the server means nothing was saved: the next try
        // is a fresh one (for example after the shift was opened).
        if (code != null) {
          _attemptKey = null;
          _attemptHash = null;
        }
        final plain = KhataText.forCode(code);
        final text = plain ?? _failureText(failure);
        if (plain != null) hook?.explain(code, plain);
        emit(state.copyWith(
          saving: false,
          banner: text,
          feedback: ScanFeedback(_nextToken, ScanTone.error, 'Not saved'),
          online: failure is NetworkFailure ? false : state.online,
        ));
      },
      (response) => _applyResponse(request, response, hook),
    );
  }

  String _failureText(Failure f) {
    if (f is NetworkFailure) {
      return 'Could not reach the server. Nothing was lost: your list is still here. '
          'Tap Save all again, items are never added twice.';
    }
    if (f is PermissionDeniedFailure) {
      return "You don't have permission to add products or stock. Ask the owner.";
    }
    if (f is RateLimitFailure) {
      return 'Too many saves in a short time. Wait a little and tap Save all again.';
    }
    final m = f.message.trim();
    return m.isEmpty ? UserErrorMessage.generic : m;
  }

  Future<void> _applyResponse(
    QuickAddRequest request,
    QuickAddResponse response, [
    PaidNowHook? hook,
  ]) async {
    final byId = {for (final l in response.lines) l.clientLineId: l};
    final kept = <QuickAddRow>[];
    var created = 0;
    var updated = 0;
    for (final r in state.rows) {
      final line = byId[r.id];
      if (line == null) {
        // The server said nothing about this line: keep it, never guess.
        kept.add(r.copyWith(
          error: const RowError(
            message: 'The server did not answer for this item. Check Products, then save again.',
          ),
        ));
      } else if (line.ok) {
        if (line.outcome == LineOutcome.created) {
          created++;
        } else {
          updated++;
        }
      } else {
        kept.add(r.copyWith(
          error: RowError(
            code: line.errorCode,
            message: QuickAddMessages.forCode(line.errorCode, fallback: line.errorMessage),
            field: QuickAddMessages.fieldFor(line.errorCode),
          ),
        ));
      }
    }

    try {
      await _repo.writeThrough(request, response);
    } catch (_) {
      // The server already has the data; the next pull brings it in.
    }
    if (isClosed) return;

    final paid = response.paymentResult;
    if (hook != null) await hook.saved(paid: paid != null, result: paid);
    if (isClosed) return;

    _attemptKey = null;
    _attemptHash = null;
    _undo.clear();
    emit(state.copyWith(
      saving: false,
      rows: kept,
      canUndo: false,
      validated: kept.isNotEmpty,
      clearHighlight: true,
      clearUndoToast: true,
      summary: QuickAddSummary(
        token: _nextToken,
        created: created,
        updated: updated,
        needAttention: kept.length,
        replayed: response.replayed,
        paidNote: paid == null
            ? null
            : receivedMessage(paid, purchaseTotal),
      ),
      focus: kept.isEmpty
          ? FocusRequest(token: _nextToken)
          : FocusRequest(
              token: _nextToken,
              rowId: kept.first.id,
              field: kept.first.error?.field,
            ),
    ));
    if (kept.isEmpty) {
      _draftTimer?.cancel();
      await _drafts.clear();
    } else {
      await _saveDraftNow();
    }
  }

  void dismissSummary() => emit(state.copyWith(clearSummary: true, focus: FocusRequest(token: _nextToken)));

  // ── draft ─────────────────────────────────────────────────────────────

  QuickAddDraft _draft() => QuickAddDraft(
        mode: state.mode,
        supplierId: state.supplierId,
        supplierName: state.supplierName,
        rows: state.rows,
        lastCategoryId: state.lastCategoryId,
        lastCategoryLabel: state.lastCategoryLabel,
        seq: _seq,
        attemptKey: _attemptKey,
        attemptHash: _attemptHash,
      );

  /// Called after every change; the write itself is debounced.
  void _persist() {
    if (_pendingDraft != null) return; // do not overwrite a draft not yet resumed
    _draftTimer?.cancel();
    if (_draftDebounce == Duration.zero) {
      unawaited(_saveDraftNow());
      return;
    }
    _draftTimer = Timer(_draftDebounce, () => unawaited(_saveDraftNow()));
  }

  Future<void> _saveDraftNow() async {
    if (_pendingDraft != null) return;
    _draftTimer?.cancel();
    try {
      if (state.rows.isEmpty) {
        await _drafts.clear();
      } else {
        await _drafts.save(_draft());
      }
    } catch (_) {
      // A full disk must not stop the scanning.
    }
  }

  /// Writes the draft now (used before the screen is left).
  Future<void> flushDraft() => _saveDraftNow();

  /// Throws the whole list away (after the owner confirmed).
  Future<void> clearAll() async {
    _undo.clear();
    _attemptKey = null;
    _attemptHash = null;
    emit(state.copyWith(
      rows: const [],
      canUndo: false,
      validated: false,
      clearBanner: true,
      clearHighlight: true,
      clearUndoToast: true,
      focus: FocusRequest(token: _nextToken),
    ));
    await _drafts.clear();
  }

  void _feedback(ScanTone tone, String message) =>
      emit(state.copyWith(feedback: ScanFeedback(_nextToken, tone, message)));
}
