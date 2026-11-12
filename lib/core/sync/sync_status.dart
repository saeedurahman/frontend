import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/sync/sync_engine.dart';

/// What the sync chip shows. Pure data: the sync engine (Phase 4b) will feed
/// real numbers; until then pending/failed are always 0.
class SyncStatus extends Equatable {
  const SyncStatus({
    this.isOnline = true,
    this.isSyncing = false,
    this.pending = 0,
    this.failed = 0,
    this.lastSyncedAt,
    this.preparing = false,
  });

  static const idleOnline = SyncStatus();

  /// When the last pull finished (null: never).
  final DateTime? lastSyncedAt;

  /// The first snapshot is still downloading ("Preparing your data").
  final bool preparing;

  final bool isOnline;
  final bool isSyncing;

  /// Local changes waiting to be sent.
  final int pending;

  /// Local changes the server rejected; they need the user's attention.
  final int failed;

  SyncStatusKind get kind {
    if (!isOnline) return SyncStatusKind.offline;
    if (failed > 0) return SyncStatusKind.failed;
    if (isSyncing) return SyncStatusKind.syncing;
    if (pending > 0) return SyncStatusKind.pending;
    return SyncStatusKind.online;
  }

  /// Chip text: Online / Offline / Syncing / N pending / N failed.
  String get label => switch (kind) {
        SyncStatusKind.offline => 'Offline',
        SyncStatusKind.failed => '$failed failed',
        SyncStatusKind.syncing => 'Syncing',
        SyncStatusKind.pending => '$pending pending',
        SyncStatusKind.online => 'Online',
      };

  SyncStatus copyWith({
    bool? isOnline,
    bool? isSyncing,
    int? pending,
    int? failed,
    DateTime? lastSyncedAt,
    bool? preparing,
  }) =>
      SyncStatus(
        isOnline: isOnline ?? this.isOnline,
        isSyncing: isSyncing ?? this.isSyncing,
        pending: pending ?? this.pending,
        failed: failed ?? this.failed,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        preparing: preparing ?? this.preparing,
      );

  @override
  List<Object?> get props =>
      [isOnline, isSyncing, pending, failed, lastSyncedAt, preparing];
}

enum SyncStatusKind { online, offline, syncing, pending, failed }

/// Where the UI reads sync state from.
abstract class SyncStatusSource {
  SyncStatus get current;
  Stream<SyncStatus> get changes;
}

/// Always "online, 0 pending". For tests and previews.
class StubSyncStatusSource implements SyncStatusSource {
  const StubSyncStatusSource([this.current = SyncStatus.idleOnline]);

  @override
  final SyncStatus current;

  @override
  Stream<SyncStatus> get changes => const Stream.empty();
}

/// Connectivity only (counters 0). Kept for tests and previews; the app uses
/// [EngineSyncStatusSource].
class ProbeBackedSyncStatusSource implements SyncStatusSource {
  ProbeBackedSyncStatusSource(this._probe) {
    _sub = _probe.status.listen((_) => _controller.add(current));
  }

  final ConnectivityProbe _probe;
  final StreamController<SyncStatus> _controller =
      StreamController<SyncStatus>.broadcast();
  StreamSubscription<ReachabilityStatus>? _sub;

  @override
  SyncStatus get current =>
      SyncStatus(isOnline: _probe.current != ReachabilityStatus.offline);

  @override
  Stream<SyncStatus> get changes => _controller.stream;

  Future<void> dispose() async {
    await _sub?.cancel();
    await _controller.close();
  }
}

/// The real source: reachability from [ConnectivityProbe] plus the sync
/// engine's live outbox counters, syncing flag and last-synced time.
class EngineSyncStatusSource implements SyncStatusSource {
  EngineSyncStatusSource(this._engine, this._probe) {
    _subs = [
      _engine.states.listen((_) => _controller.add(current)),
      _probe.status.listen((_) => _controller.add(current)),
    ];
  }

  final SyncEngine _engine;
  final ConnectivityProbe _probe;
  final StreamController<SyncStatus> _controller =
      StreamController<SyncStatus>.broadcast();
  late final List<StreamSubscription<Object?>> _subs;

  @override
  SyncStatus get current {
    final s = _engine.state;
    return SyncStatus(
      isOnline: _probe.current != ReachabilityStatus.offline,
      isSyncing: s.syncing,
      pending: s.counts.pending + s.counts.sending,
      failed: s.counts.failed,
      lastSyncedAt: s.lastSyncedAt,
      preparing: !s.hasData || s.progress != null,
    );
  }

  @override
  Stream<SyncStatus> get changes => _controller.stream;

  Future<void> dispose() async {
    for (final s in _subs) {
      await s.cancel();
    }
    unawaited(_controller.close());
  }
}
