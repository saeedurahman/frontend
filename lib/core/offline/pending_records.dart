/// Records saved on this device that the server does not have yet. Lists show
/// them beside the server's rows until the outbox has sent them.
abstract final class PendingRecords {
  static const _prefix = 'pending:';

  /// Shown where the server's document number would be.
  static const waiting = 'Pending sync';

  /// The server refused it or it kept failing.
  static const needsAttention = 'Not sent';

  static const cannotOpenYet =
      'This is saved on this computer and has not reached the server yet. '
      'You can open it after it syncs.';

  static String id(String opId) => '$_prefix$opId';

  static bool isPendingId(String id) => id.startsWith(_prefix);
}
