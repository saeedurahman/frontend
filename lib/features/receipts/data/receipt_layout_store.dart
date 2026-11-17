import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';

/// Layouts and assignments as this device has them (pulled `receipt_layout` /
/// `receipt_layout_assignment` entities). Reads never touch the network; when
/// nothing has been pulled the built-in classic receipt is used, so a fresh
/// install and an old server still print.
class ReceiptLayoutStore {
  ReceiptLayoutStore(this._store);

  final SyncStore _store;

  static const layoutEntity = 'receipt_layout';
  static const assignmentEntity = 'receipt_layout_assignment';

  Stream<void> get changes => _store.changes;

  /// Every pulled layout, active or not, by name.
  Future<List<ReceiptLayout>> layouts({bool activeOnly = false}) async {
    final rows = await _store.entities(layoutEntity, orderBy: 'search_text');
    final out = <ReceiptLayout>[];
    for (final r in rows) {
      try {
        final l = ReceiptLayout.fromJson(r);
        if (!activeOnly || l.isActive) out.add(l);
      } catch (_) {
        // A row this app version cannot read is skipped, never fatal.
      }
    }
    return out;
  }

  Future<ReceiptLayout?> layout(String id) async {
    final row = await _store.entity(layoutEntity, id);
    if (row == null) return null;
    try {
      return ReceiptLayout.fromJson(row);
    } catch (_) {
      return null;
    }
  }

  Future<List<ReceiptLayoutAssignment>> assignments() async {
    final rows = await _store.entities(assignmentEntity, orderBy: 'id');
    return [for (final r in rows) ReceiptLayoutAssignment.fromJson(r)];
  }

  /// The layout [channel] prints with: the branch's own assignment, else the
  /// business default, else the first thermal layout, else the built-in one.
  Future<ReceiptLayout> resolve(
    ReceiptChannel channel, {
    String? branchId,
    ReceiptLayout? fallback,
  }) async {
    final all = await assignments();
    final forChannel = [for (final a in all) if (a.channel == channel) a];
    final ordered = <ReceiptLayoutAssignment>[
      if (branchId != null)
        for (final a in forChannel)
          if (a.branchId == branchId) a,
      for (final a in forChannel)
        if (a.branchId == null) a,
    ];
    for (final a in ordered) {
      final id = a.layoutId;
      if (id == null) continue;
      final l = await layout(id);
      if (l != null && l.isActive) return l;
    }
    final active = await layouts(activeOnly: true);
    for (final l in active) {
      if (l.design == ReceiptDesign.thermalClassic) return l;
    }
    return fallback ?? ReceiptLayout.builtIn();
  }

  // ── local updates after a successful save on the server ───────────────

  /// Writes the server's answer straight into the local data so the editor
  /// and the next receipt use it before the next pull echoes it back.
  Future<void> putLayout(Map<String, dynamic> json) =>
      _store.putEntity(layoutEntity, '${json['id']}', json);

  Future<void> removeLayout(String id) => _store.deleteEntity(layoutEntity, id);

  Future<void> putAssignment(Map<String, dynamic> json) =>
      _store.putEntity(assignmentEntity, '${json['id']}', json);

  Future<void> removeAssignment(String id) =>
      _store.deleteEntity(assignmentEntity, id);
}
