import 'dart:convert';

/// Lifecycle of one queued operation.
///
/// ```
///            enqueue
///               v
///   +-------> pending --(picked for a batch)--> sending
///   |            ^                                 |
///   |            |  network / 5xx / retryable      +--> applied   (done)
///   |            +---------------------------------+--> pending   (retryable, backoff)
///   |  user "Retry"                                +--> failed    (retries exhausted,
///   +------------ failed / rejected <--------------+                or blocked by a failed dependency)
///                                                  +--> rejected  (server said no, final)
/// ```
/// App start resets `sending` to `pending` (the response may have been lost;
/// the server answers a re-sent op id with `duplicate`).
abstract final class OutboxStatus {
  static const pending = 'pending';
  static const sending = 'sending';
  static const applied = 'applied';
  static const failed = 'failed';
  static const rejected = 'rejected';

  /// Not finished: counts as unsynced work.
  static const unfinished = [pending, sending, failed, rejected];

  /// Needs the user (or an exhausted retry) before it moves again.
  static const needsAttention = [failed, rejected];
}

/// Every operation type the server accepts (README, "Op types").
abstract final class OpTypes {
  static const customerCreate = 'customer.create';
  static const shiftOpen = 'shift.open';
  static const shiftClose = 'shift.close';
  static const saleCreate = 'sale.create';
  static const saleVoid = 'sale.void';
  static const customerPayment = 'customer.payment';
  static const expenseCreate = 'expense.create';
  static const returnCreate = 'return.create';
}

class OutboxOp {
  const OutboxOp({
    required this.opId,
    required this.type,
    required this.payload,
    required this.status,
    required this.attempts,
    required this.createdAt,
    required this.occurredAt,
    this.nextAttemptAt,
    this.errorCode,
    this.errorMessage,
    this.retryable = false,
    this.dependsOn = const [],
    this.entity,
    this.entityId,
  });

  factory OutboxOp.fromRow(Map<String, Object?> row) => OutboxOp(
        opId: row['op_id']! as String,
        type: row['type']! as String,
        payload: Map<String, dynamic>.from(
          jsonDecode(row['payload']! as String) as Map,
        ),
        status: row['status']! as String,
        attempts: (row['attempts'] as int?) ?? 0,
        nextAttemptAt: row['next_attempt_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row['next_attempt_at']! as int),
        errorCode: row['error_code'] as String?,
        errorMessage: row['error_message'] as String?,
        retryable: (row['retryable'] as int?) == 1,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
        occurredAt: row['occurred_at']! as String,
        dependsOn: [
          for (final d in jsonDecode(row['depends_on']! as String) as List) '$d',
        ],
        entity: row['entity'] as String?,
        entityId: row['entity_id'] as String?,
      );

  final String opId;
  final String type;
  final Map<String, dynamic> payload;
  final String status;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? errorCode;
  final String? errorMessage;
  final bool retryable;
  final DateTime createdAt;

  /// ISO-8601 UTC device time of the action (becomes sold_at / opened_at ...).
  final String occurredAt;
  final List<String> dependsOn;

  /// The synced entity this op changes (so a pull never overwrites it).
  final String? entity;
  final String? entityId;

  bool get needsAttention => OutboxStatus.needsAttention.contains(status);

  /// The wire envelope for `POST /sync/push`.
  Map<String, dynamic> toEnvelope() => {
        'op_id': opId,
        'type': type,
        'client_created_at': createdAt.toUtc().toIso8601String(),
        'occurred_at': occurredAt,
        if (dependsOn.isNotEmpty) 'depends_on': dependsOn,
        'payload': payload,
      };
}

class OutboxCounts {
  const OutboxCounts({
    this.pending = 0,
    this.sending = 0,
    this.failed = 0,
  });

  /// Waiting to be sent (includes retry-scheduled ops).
  final int pending;
  final int sending;

  /// `failed` + `rejected`: the user must look at these.
  final int failed;

  /// Everything not yet confirmed by the server.
  int get unfinished => pending + sending + failed;
}

/// Backoff for retryable outcomes: 5s, 15s, 60s, 5m, 15m (then 15m).
abstract final class RetryBackoff {
  static const steps = <Duration>[
    Duration(seconds: 5),
    Duration(seconds: 15),
    Duration(seconds: 60),
    Duration(minutes: 5),
    Duration(minutes: 15),
  ];

  /// [attempts] = number of attempts made so far (>= 1).
  static Duration forAttempt(int attempts) {
    final index = (attempts - 1).clamp(0, steps.length - 1);
    return steps[index];
  }
}
