import 'dart:async';

import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/logger.dart';

class SyncEngineState {
  const SyncEngineState({
    this.syncing = false,
    this.lastSyncedAt,
    this.lastError,
    this.counts = const OutboxCounts(),
    this.progress,
    this.hasData = true,
    this.deviceRevoked = false,
  });

  final bool syncing;
  final DateTime? lastSyncedAt;
  final String? lastError;
  final OutboxCounts counts;

  /// Set while the first snapshot is running ("Preparing your data").
  final SnapshotProgress? progress;

  /// False until the first snapshot has fully arrived.
  final bool hasData;
  final bool deviceRevoked;

  SyncEngineState copyWith({
    bool? syncing,
    DateTime? lastSyncedAt,
    String? lastError,
    bool clearError = false,
    OutboxCounts? counts,
    SnapshotProgress? progress,
    bool clearProgress = false,
    bool? hasData,
    bool? deviceRevoked,
  }) =>
      SyncEngineState(
        syncing: syncing ?? this.syncing,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        lastError: clearError ? null : (lastError ?? this.lastError),
        counts: counts ?? this.counts,
        progress: clearProgress ? null : (progress ?? this.progress),
        hasData: hasData ?? this.hasData,
        deviceRevoked: deviceRevoked ?? this.deviceRevoked,
      );
}

/// Hooks the app wires in (kept as callbacks so the engine stays testable).
class SyncHooks {
  const SyncHooks({
    this.onDeviceRevoked,
    this.onFlaggedSales,
    this.afterSync,
  });

  /// 403 device_revoked: wipe and force logout.
  final Future<void> Function(String message)? onDeviceRevoked;

  /// Sale ids the server flagged during the last push.
  final void Function(List<String> saleIds)? onFlaggedSales;

  /// Best-effort online extras after a successful pull (settings cache,
  /// active shift import, lease refresh). Never allowed to fail a sync.
  final Future<void> Function()? afterSync;

  SyncHooks copyWith({
    Future<void> Function(String message)? onDeviceRevoked,
    void Function(List<String> saleIds)? onFlaggedSales,
    Future<void> Function()? afterSync,
  }) =>
      SyncHooks(
        onDeviceRevoked: onDeviceRevoked ?? this.onDeviceRevoked,
        onFlaggedSales: onFlaggedSales ?? this.onFlaggedSales,
        afterSync: afterSync ?? this.afterSync,
      );
}

/// One brain for "push, then pull":
///
/// * single-flight: overlapping triggers coalesce into one extra run;
/// * triggers: start, resume, offline->online, right after an enqueue, a timer
///   (30 s while work is waiting, 5 min otherwise), manual "Sync now";
/// * server unreachable -> exponential backoff (5 s ... 5 min), ops stay pending.
class SyncEngine {
  SyncEngine({
    required SyncStore store,
    required PushService push,
    required PullService pull,
    required ConnectivityProbe probe,
    SyncConfig config = const SyncConfig(),
    this.hooks = const SyncHooks(),
  })  : _store = store,
        _push = push,
        _pull = pull,
        _probe = probe,
        _config = config;

  final SyncStore _store;
  final PushService _push;
  final PullService _pull;
  final ConnectivityProbe _probe;
  final SyncConfig _config;
  /// Replaceable after construction (the app attaches UI-level reactions).
  SyncHooks hooks;

  final StreamController<SyncEngineState> _states =
      StreamController<SyncEngineState>.broadcast();
  SyncEngineState _state = const SyncEngineState();
  Stream<SyncEngineState> get states => _states.stream;
  SyncEngineState get state => _state;

  Timer? _timer;
  Timer? _debounce;
  StreamSubscription<void>? _enqueueSub;
  StreamSubscription<void>? _changeSub;
  StreamSubscription<ReachabilityStatus>? _probeSub;
  Future<void>? _running;
  bool _rerun = false;
  bool _started = false;
  Duration _backoff = Duration.zero;
  ReachabilityStatus _lastProbe = ReachabilityStatus.online;

  void _emit(SyncEngineState next) {
    _state = next;
    if (!_states.isClosed) _states.add(next);
  }

  Future<void> refreshState() async {
    final counts = await _store.counts();
    final hasData = await _store.hasSnapshot;
    final last = await _store.meta(SyncStore.lastPullAtKey);
    _emit(_state.copyWith(
      counts: counts,
      hasData: hasData,
      lastSyncedAt: last == null ? null : DateTime.tryParse(last),
    ));
  }

  /// Starts the schedule. Safe to call twice.
  Future<void> start() async {
    if (_started) return;
    _started = true;
    // A `sending` op's response may have been lost with the app: resend it.
    await _store.resetSending();
    await refreshState();

    _enqueueSub = _store.enqueued.listen((_) => requestSync());
    _changeSub = _store.changes.listen((_) => unawaited(refreshState()));
    _lastProbe = _probe.current;
    _probeSub = _probe.status.listen((status) {
      final cameBack = _lastProbe == ReachabilityStatus.offline &&
          status != ReachabilityStatus.offline;
      _lastProbe = status;
      if (cameBack) {
        _backoff = Duration.zero;
        requestSync();
      }
    });
    requestSync();
  }

  void stop() {
    _started = false;
    _timer?.cancel();
    _debounce?.cancel();
    unawaited(_enqueueSub?.cancel());
    unawaited(_changeSub?.cancel());
    unawaited(_probeSub?.cancel());
    _enqueueSub = _changeSub = null;
    _probeSub = null;
  }

  /// "Resync all data": throw away the pulled copy and download it again.
  /// Refused (nothing is touched) while anything is still unsent, because the
  /// download replaces the local copy of the server's data.
  Future<void> resyncAll() async {
    final counts = await _store.counts();
    if (counts.unfinished > 0) {
      throw PendingWorkException(
        PendingWorkSummary(
          unsynced: counts.pending + counts.sending,
          failed: counts.failed,
        ),
      );
    }
    await syncNow(manual: true, forceSnapshot: true);
  }

  /// App came back to the foreground.
  void onResumed() => requestSync();

  /// Coalesces bursts (every enqueue asks for a sync).
  void requestSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      unawaited(syncNow());
    });
  }

  /// Runs push-then-pull now. [manual] ignores the "probe says offline" skip.
  Future<void> syncNow({bool manual = false, bool forceSnapshot = false}) {
    final running = _running;
    if (running != null) {
      _rerun = true;
      return running;
    }
    final future = _runLoop(manual: manual, forceSnapshot: forceSnapshot)
        .whenComplete(() => _running = null);
    _running = future;
    return future;
  }

  Future<void> _runLoop({required bool manual, required bool forceSnapshot}) async {
    var force = forceSnapshot;
    do {
      _rerun = false;
      await _cycle(manual: manual, forceSnapshot: force);
      force = false;
    } while (_rerun);
    _schedule();
  }

  Future<void> _cycle({required bool manual, required bool forceSnapshot}) async {
    if (!manual && _probe.current == ReachabilityStatus.offline) {
      await refreshState();
      return;
    }
    _emit(_state.copyWith(syncing: true, clearError: true));
    try {
      final push = await _push.pushAll();
      if (push.deviceRevoked) {
        _emit(_state.copyWith(deviceRevoked: true, lastError: push.message));
        await hooks.onDeviceRevoked?.call(push.message ?? 'This device was removed.');
        return;
      }
      if (push.flaggedSales.isNotEmpty) hooks.onFlaggedSales?.call(push.flaggedSales);

      await _store.transaction(() async {
        await _store.releaseDeferred();
        await _store.purgeApplied();
      });

      if (push.unreachable) {
        _failedContact(push.message, retryAfter: push.retryAfter);
        return;
      }

      final pull = await _pull.pullAll(forceSnapshot: forceSnapshot);
      if (pull.deviceRevoked) {
        _emit(_state.copyWith(deviceRevoked: true, lastError: pull.message));
        await hooks.onDeviceRevoked?.call(pull.message ?? 'This device was removed.');
        return;
      }
      if (pull.unreachable) {
        _failedContact(pull.message, retryAfter: pull.retryAfter);
        return;
      }

      await _store.transaction(() async {
        // Edits that were pending while their rows were pulled may be free now.
        await _store.releaseDeferred();
      });
      _backoff = Duration.zero;
      try {
        await hooks.afterSync?.call();
      } catch (e) {
        AppLogger.warning('Post-sync extras failed: $e');
      }
      _emit(_state.copyWith(clearError: true));
    } catch (e, st) {
      AppLogger.error('Sync cycle failed', error: e, stackTrace: st);
      _failedContact(e.toString());
    } finally {
      await refreshState();
      _emit(_state.copyWith(syncing: false, clearProgress: true));
    }
  }

  void _failedContact(String? message, {Duration? retryAfter}) {
    if (retryAfter != null) {
      _backoff = retryAfter;
    } else {
      _backoff = _backoff == Duration.zero
          ? _config.minBackoff
          : Duration(
              milliseconds: (_backoff.inMilliseconds * 2)
                  .clamp(0, _config.maxBackoff.inMilliseconds),
            );
    }
    _emit(_state.copyWith(lastError: message ?? 'Could not reach the server'));
  }

  /// Delay before the next automatic cycle.
  Duration get nextDelay {
    if (_backoff > Duration.zero) return _backoff;
    final c = _state.counts;
    return (c.pending + c.sending) > 0 ? _config.busyInterval : _config.idleInterval;
  }

  void _schedule() {
    _timer?.cancel();
    if (!_started) return;
    _timer = Timer(nextDelay, () => unawaited(syncNow()));
  }

  /// Reports download progress of the first snapshot to the UI.
  void reportProgress(SnapshotProgress progress) =>
      _emit(_state.copyWith(progress: progress));

  void dispose() {
    stop();
    unawaited(_states.close());
  }
}
