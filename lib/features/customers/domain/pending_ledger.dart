import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';

/// A repository that holds ledger lines the server does not have yet (actions
/// saved on this device and waiting to be sent).
abstract interface class PendingLedgerSource {
  Future<List<CustomerLedgerEntryModel>> pendingLedger(
    String customerId, {
    String? branchId,
  });
}

/// A customer's account as this device holds it.
class DeviceLedger {
  const DeviceLedger({required this.lines, this.olderNeedsInternet = false});

  /// Newest first, over every branch: the recent lines that were pulled, with
  /// the ones waiting to be sent on top. A line whose running balance can't be
  /// proven from these rows has none.
  final List<CustomerLedgerEntryModel> lines;

  /// The account goes further back than this device's copy.
  final bool olderNeedsInternet;
}

/// A repository that keeps pulled account lines on this device.
abstract interface class DeviceLedgerSource {
  /// Null when the account is not on this device.
  Future<DeviceLedger?> deviceLedger(String customerId);
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
