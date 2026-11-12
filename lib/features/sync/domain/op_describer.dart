import 'package:frantend/core/sync/outbox_op.dart';

/// A queued op in words a cashier understands.
class OpDescription {
  const OpDescription(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

abstract final class OpDescriber {
  static OpDescription describe(OutboxOp op) {
    final p = op.payload;
    final when = _when(op.occurredAt);
    switch (op.type) {
      case OpTypes.saleCreate:
        final lines = (p['lines'] as List?)?.length ?? 0;
        return OpDescription(
          'Sale ${p['client_receipt_no'] ?? ''}'.trim(),
          '$lines item(s) - $when',
        );
      case OpTypes.saleVoid:
        return OpDescription('Void a sale', when);
      case OpTypes.customerCreate:
        return OpDescription('New customer ${p['name'] ?? ''}'.trim(), when);
      case OpTypes.customerPayment:
        return OpDescription('Customer payment Rs ${p['amount'] ?? ''}'.trim(), when);
      case OpTypes.shiftOpen:
        return OpDescription('Shift opened', when);
      case OpTypes.shiftClose:
        return OpDescription('Shift closed', when);
      case OpTypes.expenseCreate:
        return OpDescription('Expense Rs ${p['amount'] ?? ''}'.trim(), when);
      case OpTypes.returnCreate:
        return OpDescription('Return', when);
      default:
        return OpDescription(op.type, when);
    }
  }

  static String _when(String iso) {
    final t = DateTime.tryParse(iso)?.toLocal();
    if (t == null) return '';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.day)}/${two(t.month)}/${t.year} ${two(t.hour)}:${two(t.minute)}';
  }

  static String statusLabel(OutboxOp op) => switch (op.status) {
        OutboxStatus.pending =>
          op.nextAttemptAt != null ? 'Waiting to retry' : 'Waiting to send',
        OutboxStatus.sending => 'Sending',
        OutboxStatus.applied => 'Sent',
        OutboxStatus.failed => 'Needs attention',
        OutboxStatus.rejected => 'Rejected by the server',
        _ => op.status,
      };
}
