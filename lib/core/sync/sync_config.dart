/// Tunables of the sync engine. Server-side limits (`SYNC_MAX_OPS` = 200,
/// `SYNC_MAX_PAYLOAD_BYTES` = 65536) are the backend defaults; a smaller batch
/// is always safe, and `413` halves it further at run time.
class SyncConfig {
  const SyncConfig({
    this.maxOps = const int.fromEnvironment('SYNC_MAX_OPS', defaultValue: 200),
    this.maxAttempts =
        const int.fromEnvironment('SYNC_MAX_ATTEMPTS', defaultValue: 10),
    this.pageLimit = 500,
    this.busyInterval = const Duration(seconds: 30),
    this.idleInterval = const Duration(minutes: 5),
    this.minBackoff = const Duration(seconds: 5),
    this.maxBackoff = const Duration(minutes: 5),
    this.appVersion = '1.0.0',
  });

  /// Ops per `POST /sync/push`.
  final int maxOps;

  /// Retryable failures before an op needs the user ("failed").
  final int maxAttempts;

  /// `limit` for pull / snapshot pages.
  final int pageLimit;

  /// Cycle period while ops are waiting / otherwise.
  final Duration busyInterval;
  final Duration idleInterval;

  /// Backoff while the server cannot be reached.
  final Duration minBackoff;
  final Duration maxBackoff;

  final String appVersion;
}

/// Plain-language text for the server's error codes (README, "Error codes").
abstract final class SyncErrorText {
  static const _known = <String, String>{
    'malformed_op': 'The app produced an item the server could not read.',
    'malformed_payload': 'The details of this item are not valid.',
    'payload_too_large': 'This item is too large to send.',
    'unsupported_op_type': 'The server does not accept this kind of item.',
    'occurred_too_old':
        'This was done too long ago (the device stayed offline for too many days).',
    'occurred_in_future':
        "This item is dated in the future - check this device's clock.",
    'permission_denied': 'Your account is not allowed to do this.',
    'branch_forbidden': 'Your account cannot work in this branch.',
    'unknown_product': 'A product in this sale no longer exists on the server.',
    'unknown_branch': 'The branch no longer exists on the server.',
    'unknown_register': 'The cash register is not known to the server yet.',
    'unknown_customer': 'The customer is not known to the server yet.',
    'unknown_shift': 'The shift is not known to the server yet.',
    'sale_not_synced': 'The original sale has not reached the server yet.',
    'duplicate_receipt':
        'A different sale already uses this receipt number on the server.',
    'idempotency_key_reused': 'This item was already used for something else.',
    'id_conflict': 'The server already has a different record with this id.',
    'id_exists': 'The server already has this record.',
    'shift_conflict': 'The server has a conflicting shift for this register.',
    'shift_already_closed': 'This shift was already closed on the server.',
    'sale_not_voidable':
        'This sale cannot be voided any more (its shift is closed or it is already voided).',
    'return_rejected': 'The server did not accept this return.',
    'insufficient_stock': 'Not enough stock on the server.',
    'dependency_missing': 'An earlier item this depends on has not been sent.',
    'dependency_failed': 'An earlier item this depends on has not been accepted.',
    'dependency_cycle': 'These items depend on each other in a loop.',
    'subscription_grace_readonly':
        'Your subscription is in its read-only period. Renew to send this.',
    'subscription_expired': 'Your subscription has expired. Renew to send this.',
    'subscription_suspended': 'Your subscription is suspended.',
    'subscription_cancelled': 'Your subscription was cancelled.',
    'no_open_shift':
        'Returns need an open shift. Open a shift, then press Retry.',
    'internal_error': 'The server had a problem. It will be tried again.',
  };

  static String explain(String? code, [String? serverMessage]) {
    final text = _known[code];
    if (text != null) return text;
    if (serverMessage != null && serverMessage.trim().isNotEmpty) {
      return serverMessage.trim();
    }
    return 'The server did not accept this item ($code).';
  }

  /// Plain explanations of the sale flags (README, "Offline sale acceptance").
  static const flagText = <String, String>{
    'price_mismatch':
        'A price on the receipt differs from the current catalog price. The receipt amount was kept.',
    'tax_mismatch':
        'The tax on a line differs from the product tax rate. The receipt amount was kept.',
    'oversold':
        'Stock went below zero because this was sold while offline. Check the stock count.',
    'credit_limit_exceeded':
        "The credit portion took the customer past their credit limit.",
    'cost_estimated':
        'There was not enough costed stock, so the last known cost was used for profit figures.',
    'shift_mismatch':
        'The shift on this sale was not open for you at that time. The sale is kept but no cash was posted to a drawer.',
    'subscription_expired':
        'This sale was accepted while the subscription was expired.',
  };

  static String flag(String code) =>
      flagText[code] ?? 'The server flagged this sale ($code).';
}
