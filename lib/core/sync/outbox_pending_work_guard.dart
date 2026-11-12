import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/sync/sync_store.dart';

/// Real [PendingWorkGuard]: everything the server has not confirmed
/// (pending + sending + failed + rejected outbox ops) plus parked orders,
/// which live only on this device.
class OutboxPendingWorkGuard implements PendingWorkGuard {
  OutboxPendingWorkGuard(this._store, {Future<int> Function()? heldOrders})
      : _held = heldOrders;

  final SyncStore _store;
  final Future<int> Function()? _held;

  @override
  Future<PendingWorkSummary> summary() async {
    final c = await _store.counts();
    return PendingWorkSummary(
      unsynced: c.pending + c.sending,
      failed: c.failed,
      held: await _held?.call() ?? 0,
    );
  }

  @override
  Future<int> pendingCount() async => (await summary()).total;
}
