import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_store.dart';

/// What the signed-in user may do, as delivered by the pulled `user` + `role`
/// rows (README: users carry `role_ids`/`branch_ids`, roles carry
/// `permission_keys`).
class PulledAccess {
  const PulledAccess({
    required this.permissionKeys,
    required this.branchIds,
    required this.permissionsVersion,
  });

  final List<String> permissionKeys;
  final List<String> branchIds;
  final String permissionsVersion;
}

class SnapshotProgress {
  const SnapshotProgress({this.pages = 0, this.rows = 0, this.done = false});
  final int pages;
  final int rows;
  final bool done;
}

class PullOutcome {
  int pages = 0;
  int changes = 0;
  bool snapshotRan = false;
  bool unreachable = false;
  bool restricted = false;
  Duration? retryAfter;
  bool deviceRevoked = false;
  String? message;

  /// Entities touched, to decide what to refresh.
  final Set<String> touched = {};
}

/// Snapshot + delta pull. The cursor is committed in the same transaction as
/// the page it belongs to, so a crash can only ever re-deliver a page (upserts
/// are idempotent), never skip one.
class PullService {
  PullService({
    required SyncStore store,
    required SyncApi api,
    SyncConfig config = const SyncConfig(),
    this.currentUserId,
    this.onAccess,
    this.onProgress,
  })  : _store = store,
        _api = api,
        _config = config;

  final SyncStore _store;
  final SyncApi _api;
  final SyncConfig _config;

  /// Id of the signed-in user (to find their row among the pulled users).
  final Future<String?> Function()? currentUserId;

  /// Called when the user's permissions / branch scope may have changed.
  final void Function(PulledAccess access)? onAccess;
  final void Function(SnapshotProgress progress)? onProgress;

  static const _inProgress = 'snapshot_in_progress';

  Future<PullOutcome> pullAll({bool forceSnapshot = false}) async {
    final outcome = PullOutcome();
    try {
      // Sales the server accepted before this pull started: the balances this
      // pull delivers contain them.
      final awaitingStock = await _store.stockUnconfirmedSales();
      if (forceSnapshot) await _beginSnapshot();
      if (!await _store.hasSnapshot || await _snapshotInProgress()) {
        await _snapshot(outcome);
      }
      var resyncs = 0;
      while (true) {
        final cursor = await _store.meta(SyncStore.cursorKey);
        final PullPage page;
        try {
          page = await _api.pull(since: cursor, limit: _config.pageLimit);
        } on InvalidCursorException {
          if (resyncs++ >= 1) rethrow;
          await _beginSnapshot();
          await _snapshot(outcome);
          continue;
        }

        if (page.fullResyncRequired) {
          if (resyncs++ >= 1) {
            throw const SyncServerException('Server keeps asking for a full resync');
          }
          await _beginSnapshot();
          await _snapshot(outcome);
          continue;
        }

        await _store.transaction(() async {
          await _store.applyChanges(page.changes);
          if (page.nextCursor != null) {
            await _store.setMeta(SyncStore.cursorKey, page.nextCursor);
          }
          // Same commit as the last page: the stock shown never counts a
          // sale twice (pulled balance + still subtracted) or not at all.
          if (!page.hasMore && !page.restricted) {
            await _store.confirmStockFor(awaitingStock);
          }
        });
        outcome.pages++;
        outcome.changes += page.changes.length;
        outcome.touched.addAll(page.changes.map((c) => c.entity));
        outcome.restricted = page.restricted;
        await _store.setMeta('restricted', page.restricted ? '1' : '0');
        await _refreshAccess(page.permissionsVersion, outcome.touched);

        if (!page.hasMore) break;
      }
      await _store.setMeta(SyncStore.lastPullAtKey, _store.now().toUtc().toIso8601String());
    } on DeviceRevokedException catch (e) {
      outcome.deviceRevoked = true;
      outcome.message = e.message;
    } on RateLimitedException catch (e) {
      outcome.retryAfter = e.retryAfter;
      outcome.unreachable = true;
    } on SyncApiException catch (e) {
      outcome.unreachable = true;
      outcome.message = e.message;
    }
    return outcome;
  }

  Future<bool> _snapshotInProgress() async => (await _store.meta(_inProgress)) == '1';

  Future<void> _beginSnapshot() => _store.transaction(() async {
        await _store.clearSyncedData();
        await _store.setMeta(SyncStore.snapshotCompleteKey, '0');
        await _store.setMeta(SyncStore.cursorKey, null);
        await _store.setMeta(SyncStore.snapshotTokenKey, null);
        await _store.setMeta(SyncStore.snapshotCursorKey, null);
        await _store.setMeta(_inProgress, '1');
      });

  Future<void> _snapshot(PullOutcome outcome) async {
    outcome.snapshotRan = true;
    if (!await _snapshotInProgress()) await _beginSnapshot();

    var pages = 0;
    var rows = 0;
    onProgress?.call(const SnapshotProgress());
    while (true) {
      final token = await _store.meta(SyncStore.snapshotTokenKey);
      final page = await _api.snapshot(pageToken: token, limit: _config.pageLimit);
      await _store.transaction(() async {
        await _store.applyChanges(page.changes);
        await _store.setMeta(SyncStore.snapshotTokenKey, page.nextPageToken);
        await _store.setMeta(SyncStore.snapshotCursorKey, page.cursor);
        if (!page.hasMore) {
          // The cursor is only adopted once every page is in.
          await _store.setMeta(SyncStore.cursorKey, page.cursor);
          await _store.setMeta(SyncStore.snapshotCompleteKey, '1');
          await _store.setMeta(_inProgress, '0');
          await _store.setMeta(SyncStore.snapshotTokenKey, null);
        }
      });
      pages++;
      rows += page.changes.length;
      outcome.changes += page.changes.length;
      outcome.touched.addAll(page.changes.map((c) => c.entity));
      onProgress?.call(SnapshotProgress(pages: pages, rows: rows, done: !page.hasMore));
      if (!page.hasMore) {
        await _refreshAccess(page.permissionsVersion, outcome.touched, force: true);
        break;
      }
    }
  }

  static const _accessEntities = {'user', 'role', 'branch', 'settings'};

  Future<void> _refreshAccess(
    String version,
    Set<String> touched, {
    bool force = false,
  }) async {
    final previous = await _store.meta(SyncStore.permissionsFingerprintKey);
    final changed = version.isNotEmpty && version != previous;
    if (!force && !changed && !touched.any(_accessEntities.contains)) return;
    if (changed) {
      await _store.setMeta(SyncStore.permissionsFingerprintKey, version);
    }
    final access = await resolveAccess(version.isEmpty ? (previous ?? '') : version);
    if (access != null) onAccess?.call(access);
  }

  /// Permission keys = union of the pulled roles of the signed-in user.
  Future<PulledAccess?> resolveAccess(String version) async {
    final userId = await currentUserId?.call();
    if (userId == null) return null;
    final user = await _store.entity('user', userId);
    if (user == null) return null;
    final roleIds = [for (final r in (user['role_ids'] as List? ?? const [])) '$r'];
    final keys = <String>{};
    for (final id in roleIds) {
      final role = await _store.entity('role', id);
      for (final k in (role?['permission_keys'] as List? ?? const [])) {
        keys.add('$k');
      }
    }
    return PulledAccess(
      permissionKeys: keys.toList()..sort(),
      branchIds: [for (final b in (user['branch_ids'] as List? ?? const [])) '$b'],
      permissionsVersion: version,
    );
  }
}
