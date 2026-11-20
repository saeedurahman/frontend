import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';

import 'barcode_normalizer.dart';
import 'quick_add_flow.dart';
import 'quick_add_models.dart';
import 'quick_add_row.dart';
import 'quick_add_settings.dart';

/// A choice in a picker (unit, category, supplier).
class PickOption {
  const PickOption(this.id, this.label);

  final String id;
  final String label;

  @override
  bool operator ==(Object other) =>
      other is PickOption && other.id == id && other.label == label;

  @override
  int get hashCode => Object.hash(id, label);
}

/// The lists the screen's pickers need.
class QuickAddOptions {
  const QuickAddOptions({
    this.units = const [],
    this.categories = const [],
    this.suppliers = const [],
    this.defaultUnit,
  });

  final List<PickOption> units;
  final List<PickOption> categories;
  final List<PickOption> suppliers;

  /// The unit used when a row does not name one ("Piece").
  final PickOption? defaultUnit;
}

/// Future catalogue source for unknown barcodes (Master Catalogue / Open Food
/// Facts). Returns null when it knows nothing, which is the only answer today.
abstract class ProductSuggestionProvider {
  Future<ProductSuggestion?> suggest(NormalizedBarcode barcode);
}

class NoProductSuggestions implements ProductSuggestionProvider {
  const NoProductSuggestions();

  @override
  Future<ProductSuggestion?> suggest(NormalizedBarcode barcode) async => null;
}

/// Everything the Quick Add screen needs from the outside world.
///
/// Reads are local first; [submit] is the only call that needs the internet.
abstract class QuickAddRepository {
  /// Is the server reachable right now? (Saving needs it, scanning does not.)
  bool get isOnline;

  /// Fires when the answer of [isOnline] changes.
  Stream<bool> get onlineChanges;

  /// The branch stock is booked into (null = the server picks the only branch).
  String? get branchId;

  /// Settings in force on this device (pulled with the other settings).
  Future<QuickAddSettings> settings();

  /// Fires when the settings change (a pull or a save on this device).
  Stream<QuickAddSettings> get settingsChanges;

  Future<QuickAddOptions> options();

  /// A product of this shop with [barcode], from the local copy only. Fast.
  Future<KnownProduct?> findLocal(NormalizedBarcode barcode);

  /// `GET /products/lookup`, capped at [timeout]. Null when offline, slow or
  /// failed: the caller carries on as if the barcode were new.
  Future<ProductLookup?> lookupRemote(
    NormalizedBarcode barcode, {
    Duration timeout = const Duration(milliseconds: 1500),
  });

  /// `POST /products/quick-add` with [idempotencyKey]: a retry of the SAME body
  /// must send the SAME key so the server never books the stock twice.
  Future<Either<Failure, QuickAddResponse>> submit(
    QuickAddRequest request, {
    required String idempotencyKey,
  });

  /// After a save: puts the products into the local catalog and tells every
  /// open screen (products list, POS grid, pickers, stock).
  Future<void> writeThrough(QuickAddRequest request, QuickAddResponse response);
}

/// What the screen keeps on disk so a crash or restart loses nothing.
class QuickAddDraft {
  const QuickAddDraft({
    required this.mode,
    required this.rows,
    this.supplierId,
    this.supplierName,
    this.lastCategoryId,
    this.lastCategoryLabel,
    this.seq = 0,
    this.attemptKey,
    this.attemptHash,
  });

  final QuickAddMode mode;
  final String? supplierId;
  final String? supplierName;
  final List<QuickAddRow> rows;
  final String? lastCategoryId;
  final String? lastCategoryLabel;
  final int seq;

  /// Idempotency key of the save that was in flight, with a fingerprint of
  /// its body, so a retry after a crash reuses it.
  final String? attemptKey;
  final String? attemptHash;

  int get itemCount => rows.length;

  Map<String, dynamic> toJson() => {
        'v': 1,
        'mode': mode.apiValue,
        'supplier_id': supplierId,
        'supplier_name': supplierName,
        'last_category_id': lastCategoryId,
        'last_category': lastCategoryLabel,
        'seq': seq,
        'attempt_key': attemptKey,
        'attempt_hash': attemptHash,
        'rows': [for (final r in rows) r.toJson()],
      };

  static QuickAddDraft? fromJson(Map<String, dynamic>? j) {
    if (j == null) return null;
    try {
      return QuickAddDraft(
        mode: QuickAddMode.fromApi(j['mode']),
        supplierId: j['supplier_id'] as String?,
        supplierName: j['supplier_name'] as String?,
        lastCategoryId: j['last_category_id'] as String?,
        lastCategoryLabel: j['last_category'] as String?,
        seq: (j['seq'] as num?)?.toInt() ?? 0,
        attemptKey: j['attempt_key'] as String?,
        attemptHash: j['attempt_hash'] as String?,
        rows: [
          for (final r in (j['rows'] as List? ?? const []))
            QuickAddRow.fromJson(Map<String, dynamic>.from(r as Map)),
        ],
      );
    } catch (_) {
      return null; // a damaged draft must never block the screen
    }
  }
}

abstract class QuickAddDraftStore {
  Future<QuickAddDraft?> load();
  Future<void> save(QuickAddDraft draft);
  Future<void> clear();
}
