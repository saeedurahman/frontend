import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';

/// Where the keyboard focus should go. [rowId] null means the scan field.
/// The [token] changes on every request so asking for the same place twice
/// still moves the focus.
class FocusRequest extends Equatable {
  const FocusRequest({this.token = 0, this.rowId, this.field});

  final int token;
  final String? rowId;
  final QuickAddField? field;

  bool get isScan => rowId == null;

  @override
  List<Object?> get props => [token, rowId, field];
}

enum ScanTone { success, warning, error }

/// One line under the scan field ("Lux Soap 100g added") and the sound to play.
class ScanFeedback extends Equatable {
  const ScanFeedback(this.token, this.tone, this.message);

  final int token;
  final ScanTone tone;
  final String message;

  @override
  List<Object?> get props => [token, tone, message];
}

/// "Row deleted. Undo" toast.
class UndoToast extends Equatable {
  const UndoToast(this.token, this.message);

  final int token;
  final String message;

  @override
  List<Object?> get props => [token, message];
}

/// Shown in the dialog after a save.
class QuickAddSummary extends Equatable {
  const QuickAddSummary({
    required this.token,
    required this.created,
    required this.updated,
    required this.needAttention,
    this.replayed = false,
  });

  final int token;
  final int created;
  final int updated;
  final int needAttention;
  final bool replayed;

  int get saved => created + updated;

  /// "42 added, 8 updated, 2 need attention"
  String get headline {
    final parts = <String>[
      if (created > 0 || (updated == 0 && needAttention == 0)) '$created added',
      if (updated > 0) '$updated updated',
      if (needAttention > 0) '$needAttention need attention',
    ];
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [token, created, updated, needAttention, replayed];
}

class QuickAddState extends Equatable {
  QuickAddState({
    this.loading = true,
    this.mode = QuickAddMode.openingStock,
    this.supplierId,
    this.supplierName,
    this.rows = const [],
    QuickAddSettings? settings,
    this.options = const QuickAddOptions(),
    this.online = true,
    this.saving = false,
    this.validated = false,
    this.focus = const FocusRequest(),
    this.feedback,
    this.undoToast,
    this.canUndo = false,
    this.restorable,
    this.summary,
    this.banner,
    this.lastCategoryId,
    this.lastCategoryLabel,
    this.highlightRowId,
  }) : settings = settings ?? QuickAddSettings.defaults;

  final bool loading;
  final QuickAddMode mode;
  final String? supplierId;
  final String? supplierName;

  /// Newest first.
  final List<QuickAddRow> rows;
  final QuickAddSettings settings;
  final QuickAddOptions options;
  final bool online;
  final bool saving;

  /// A save was tried: rows show their problems inline.
  final bool validated;
  final FocusRequest focus;
  final ScanFeedback? feedback;
  final UndoToast? undoToast;
  final bool canUndo;

  /// A saved draft with this many items waits for "Resume" / "Start fresh".
  final int? restorable;
  final QuickAddSummary? summary;

  /// Plain-words message about the last save problem (offline, server down).
  final String? banner;
  final String? lastCategoryId;
  final String? lastCategoryLabel;

  /// The row that was just scanned (highlighted).
  final String? highlightRowId;

  int get itemCount => rows.length;

  Decimal get totalQty => rows.fold(Decimal.zero, (a, r) => a + r.qty);

  Decimal get totalCost => rows.fold(
        Decimal.zero,
        (a, r) => a + r.qty * (r.cost ?? Decimal.zero),
      );

  /// Batch and Expiry columns are shown when the shop asks for them or any
  /// row needs them (a known product that tracks expiry).
  bool get showBatchExpiry => settings.askExpiry || rows.any((r) => r.trackExpiry);

  bool get hasUnsavedRows => rows.isNotEmpty;

  QuickAddRow? row(String id) {
    for (final r in rows) {
      if (r.id == id) return r;
    }
    return null;
  }

  QuickAddState copyWith({
    bool? loading,
    QuickAddMode? mode,
    String? supplierId,
    String? supplierName,
    bool clearSupplier = false,
    List<QuickAddRow>? rows,
    QuickAddSettings? settings,
    QuickAddOptions? options,
    bool? online,
    bool? saving,
    bool? validated,
    FocusRequest? focus,
    ScanFeedback? feedback,
    UndoToast? undoToast,
    bool clearUndoToast = false,
    bool? canUndo,
    int? restorable,
    bool clearRestorable = false,
    QuickAddSummary? summary,
    bool clearSummary = false,
    String? banner,
    bool clearBanner = false,
    String? lastCategoryId,
    String? lastCategoryLabel,
    bool clearLastCategory = false,
    String? highlightRowId,
    bool clearHighlight = false,
  }) =>
      QuickAddState(
        loading: loading ?? this.loading,
        mode: mode ?? this.mode,
        supplierId: clearSupplier ? null : (supplierId ?? this.supplierId),
        supplierName: clearSupplier ? null : (supplierName ?? this.supplierName),
        rows: rows ?? this.rows,
        settings: settings ?? this.settings,
        options: options ?? this.options,
        online: online ?? this.online,
        saving: saving ?? this.saving,
        validated: validated ?? this.validated,
        focus: focus ?? this.focus,
        feedback: feedback ?? this.feedback,
        undoToast: clearUndoToast ? null : (undoToast ?? this.undoToast),
        canUndo: canUndo ?? this.canUndo,
        restorable: clearRestorable ? null : (restorable ?? this.restorable),
        summary: clearSummary ? null : (summary ?? this.summary),
        banner: clearBanner ? null : (banner ?? this.banner),
        lastCategoryId:
            clearLastCategory ? null : (lastCategoryId ?? this.lastCategoryId),
        lastCategoryLabel: clearLastCategory
            ? null
            : (lastCategoryLabel ?? this.lastCategoryLabel),
        highlightRowId:
            clearHighlight ? null : (highlightRowId ?? this.highlightRowId),
      );

  @override
  List<Object?> get props => [
        loading,
        mode,
        supplierId,
        supplierName,
        rows,
        settings,
        options,
        online,
        saving,
        validated,
        focus,
        feedback,
        undoToast,
        canUndo,
        restorable,
        summary,
        banner,
        lastCategoryId,
        lastCategoryLabel,
        highlightRowId,
      ];
}
