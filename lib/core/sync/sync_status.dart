import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';

/// What the sync chip shows. Pure data: the sync engine (Phase 4b) will feed
/// real numbers; until then pending/failed are always 0.
class SyncStatus extends Equatable {
  const SyncStatus({
    this.isOnline = true,
    this.isSyncing = false,
    this.pending = 0,
    this.failed = 0,
  });

  static const idleOnline = SyncStatus();

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
  }) =>
      SyncStatus(
        isOnline: isOnline ?? this.isOnline,
        isSyncing: isSyncing ?? this.isSyncing,
        pending: pending ?? this.pending,
        failed: failed ?? this.failed,
      );

  @override
  List<Object?> get props => [isOnline, isSyncing, pending, failed];
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

/// Real connectivity (from [ConnectivityProbe]) with stubbed queue counters:
/// there is no queue until Phase 4b, so pending/failed stay 0. The Online /
/// Offline part is truthful already.
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
