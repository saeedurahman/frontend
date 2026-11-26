import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';

/// A repository that holds ledger lines the server does not have yet (actions
/// saved on this device and waiting to be sent).
abstract interface class PendingLedgerSource {
  Future<List<CustomerLedgerEntryModel>> pendingLedger(
    String customerId, {
    String? branchId,
  });
}

/// `reference_type` marks of the lines that exist only on this device. The
/// server never sends these.
abstract final class PendingLedgerMarks {
  /// Saved here, not sent yet.
  static const waiting = 'pending_sync';

  /// The server refused it or it kept failing.
  static const needsAttention = 'sync_failed';
}

extension PendingLedgerEntry on CustomerLedgerEntryModel {
  bool get isOnDeviceOnly =>
      referenceType == PendingLedgerMarks.waiting ||
      referenceType == PendingLedgerMarks.needsAttention;
}
