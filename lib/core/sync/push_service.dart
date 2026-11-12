import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_store.dart';

class PushOutcome {
  PushOutcome();

  int sent = 0;
  int applied = 0;
  int failed = 0;
  int retryScheduled = 0;

  /// Sale ids the server flagged (oversold, price_mismatch ...).
  final List<String> flaggedSales = [];

  /// The server could not be reached / answered 5xx: everything stays pending.
  bool unreachable = false;
  Duration? retryAfter;
  bool deviceRevoked = false;
  String? message;
}

/// Sends the outbox, oldest first, in batches of up to `maxOps`.
class PushService {
  PushService({
    required SyncStore store,
    required SyncApi api,
    required IdGenerator ids,
    SyncConfig config = const SyncConfig(),
  })  : _store = store,
        _api = api,
        _ids = ids,
        _config = config,
        _batchMax = config.maxOps;

  final SyncStore _store;
  final SyncApi _api;
  final IdGenerator _ids;
  final SyncConfig _config;
  int _batchMax;

  Future<PushOutcome> pushAll() async {
    final outcome = PushOutcome();
    // Each round may unlock dependants; stop when nothing is eligible.
    for (var round = 0; round < 1000; round++) {
      final batch = await _store.nextBatch(_batchMax);
      if (batch.isEmpty) break;
      await _store.transaction(() => _store.markSending(batch.map((o) => o.opId)));
      outcome.sent += batch.length;

      final PushResponse response;
      try {
        response = await _api.push(
          batchId: _ids.opId(),
          ops: [for (final o in batch) o.toEnvelope()],
        );
      } on DeviceRevokedException catch (e) {
        outcome.deviceRevoked = true;
        outcome.message = e.message;
        await _store.transaction(() => _store.releaseUnsent(batch.map((o) => o.opId)));
        return outcome;
      } on BatchTooLargeException {
        await _store.transaction(() => _store.releaseUnsent(batch.map((o) => o.opId)));
        if (_batchMax <= 1) {
          // A single op is too big: it can never be sent as is.
          await _store.transaction(() async {
            await _store.markFailed(
              batch.first.opId,
              code: 'payload_too_large',
              message: SyncErrorText.explain('payload_too_large'),
            );
          });
          _batchMax = _config.maxOps;
          continue;
        }
        _batchMax = (_batchMax ~/ 2).clamp(1, _config.maxOps);
        outcome.sent -= batch.length;
        continue;
      } on RateLimitedException catch (e) {
        await _store.transaction(
          () => _store.releaseUnsent(batch.map((o) => o.opId), delay: e.retryAfter),
        );
        outcome.retryAfter = e.retryAfter;
        outcome.unreachable = true;
        return outcome;
      } on SyncApiException catch (e) {
        // Offline, timeout, 5xx, anything else whole-request: keep pending.
        await _store.transaction(() => _store.releaseUnsent(batch.map((o) => o.opId)));
        outcome.unreachable = true;
        outcome.message = e.message;
        return outcome;
      }

      await _store.transaction(() async {
        final byId = {for (final r in response.results) r.opId: r};
        final unanswered = <String>[];
        for (final op in batch) {
          final result = byId[op.opId];
          if (result == null) {
            unanswered.add(op.opId);
            continue;
          }
          await _apply(op, result, outcome);
        }
        if (unanswered.isNotEmpty) await _store.releaseUnsent(unanswered);
        await _store.setMeta(SyncStore.lastPushAtKey, _store.now().toUtc().toIso8601String());
      });
      _batchMax = _config.maxOps;
    }
    return outcome;
  }

  Future<void> _apply(OutboxOp op, OpResult result, PushOutcome outcome) async {
    if (result.isDone) {
      await _store.markApplied(op.opId);
      outcome.applied++;
      await _onApplied(op, result, outcome);
      return;
    }

    final error = result.error ??
        const OpError(code: 'internal_error', message: '', retryable: true);
    final text = SyncErrorText.explain(error.code, error.message);
    final attempts = op.attempts + 1; // markSending counted this attempt

    if (error.retryable) {
      final isSubscription = error.code.startsWith('subscription_');
      if (!isSubscription && attempts >= _config.maxAttempts) {
        await _store.markFailed(
          op.opId,
          code: error.code,
          message: text,
          status: OutboxStatus.failed,
          retryable: true,
        );
        outcome.failed++;
        await _onFailed(op);
      } else {
        await _store.scheduleRetry(
          op.opId,
          code: error.code,
          message: text,
          delay: isSubscription
              ? RetryBackoff.steps.last
              : RetryBackoff.forAttempt(attempts),
        );
        outcome.retryScheduled++;
      }
      return;
    }

    await _store.markFailed(op.opId, code: error.code, message: text);
    outcome.failed++;
    await _onFailed(op);
  }

  Future<void> _onApplied(OutboxOp op, OpResult result, PushOutcome outcome) async {
    switch (op.type) {
      case OpTypes.saleCreate:
        final id = '${op.payload['id']}';
        await _store.markSaleSynced(
          id,
          officialNumber: result.officialNumber,
          flags: result.flags,
        );
        if (result.flags.isNotEmpty) outcome.flaggedSales.add(id);
      case OpTypes.shiftOpen:
        await _store.updateShift('${op.payload['id']}', {'sync_state': 'synced'});
      case OpTypes.shiftClose:
        await _store.updateShift('${op.payload['shift_id']}', {'sync_state': 'synced'});
      case OpTypes.saleVoid:
        await _store.setSaleStatus('${op.payload['sale_id']}', 'voided');
        await _store.setSaleState('${op.payload['sale_id']}', 'synced');
    }
  }

  Future<void> _onFailed(OutboxOp op) async {
    if (op.type == OpTypes.saleCreate) {
      await _store.setSaleState('${op.payload['id']}', 'failed');
    }
  }
}
