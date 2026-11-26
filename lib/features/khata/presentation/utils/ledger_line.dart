import 'package:decimal/decimal.dart';
import 'package:flutter/painting.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/domain/pending_ledger.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_wording.dart';

/// One row of a customer or supplier account, in the words the screen shows.
class LedgerLine {
  const LedgerLine({
    required this.id,
    required this.party,
    required this.type,
    required this.typeLabel,
    required this.amount,
    this.isExpense = false,
    this.when,
    this.runningBalance,
    this.sourceLabel = '',
    this.reference,
    this.shiftId,
    this.note,
    this.isReversed = false,
    this.isReversal = false,
    this.reversalOfId,
    this.reversedById,
    this.canReverse = false,
  });

  final String id;
  final LedgerParty party;

  /// The server's `entry_type`.
  final String type;

  /// A supplier bill that is an expense, not goods.
  final bool isExpense;
  final String typeLabel;

  /// Ledger sign: negative = owed, positive = payment / credit.
  final Decimal amount;
  final DateTime? when;
  final Decimal? runningBalance;

  /// "Paid from": "Drawer", "Bank", "Easypaisa", ...; empty when not a payment.
  final String sourceLabel;
  final String? reference;
  final String? shiftId;
  final String? note;
  final bool isReversed;
  final bool isReversal;
  final String? reversalOfId;
  final String? reversedById;
  final bool canReverse;

  /// "Drawer · slip-1" style detail line.
  String get detail {
    final parts = <String>[
      if (sourceLabel.isNotEmpty) sourceLabel,
      if (reference != null && reference!.isNotEmpty) '#$reference',
    ];
    return parts.join(' · ');
  }

  /// The amount column: "Goods +1,000.00", "Paid -300.00".
  ({String text, Color color}) get amountView => LedgerWording.amount(
        type: type,
        amount: amount,
        party: party,
        isExpense: isExpense,
      );

  /// The balance column: "Rs. 600.00 we owe". Null when there is no balance.
  ({String text, Color color})? get balanceView {
    final value = runningBalance;
    return value == null ? null : LedgerWording.balance(value, party);
  }

  /// On the supplier side the server books goods received as `sale`; to the
  /// shop owner it is never a sale.
  static String supplierTypeLabel(String type, {bool isExpense = false}) =>
      switch (type) {
        'sale' || 'purchase' =>
          isExpense ? KhataText.expenseOnCredit : KhataText.goodsReceived,
        'refund' => 'Refund',
        'payment' => 'Payment made',
        'reversal' => 'Payment reversed',
        'adjustment' => 'Adjustment',
        'correction' => 'Correction',
        'opening_balance' => 'Opening balance',
        'return' || 'return_' => 'Goods returned',
        _ => _humanize(type),
      };

  static String customerTypeLabel(String type) => switch (type) {
        'sale' => 'Credit sale',
        'payment' => 'Payment received',
        'return' || 'return_' => 'Return',
        'opening_balance' => 'Opening balance',
        'adjustment' => 'Adjustment',
        'refund' => 'Refund',
        'reversal' => 'Payment reversed',
        'correction' => 'Correction',
        _ => _humanize(type),
      };

  static String _humanize(String type) {
    final spaced = type.replaceAll('_', ' ').trim();
    if (spaced.isEmpty) return 'Entry';
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  /// A customer ledger row. Only a real customer payment that is not already
  /// undone (and is not itself an undo) can be reversed.
  factory LedgerLine.fromCustomer(
    CustomerLedgerEntryModel e, {
    String? runningBalance,
  }) {
    final type = switch (e.entryType) {
      LedgerEntryType.sale => 'sale',
      LedgerEntryType.payment => 'payment',
      LedgerEntryType.return_ => 'return_',
      LedgerEntryType.openingBalance => 'opening_balance',
      LedgerEntryType.adjustment => 'adjustment',
      LedgerEntryType.refund => 'refund',
      LedgerEntryType.reversal => 'reversal',
      LedgerEntryType.correction => 'correction',
    };
    // Cash that went into a till is, to the owner, "the drawer".
    final intoDrawer = e.paymentSource == 'cash' && e.registerShiftId != null;
    return LedgerLine(
      id: e.id,
      party: LedgerParty.customer,
      type: type,
      typeLabel: customerTypeLabel(type),
      amount: Decimal.tryParse(e.amount) ?? Decimal.zero,
      when: e.entryAt == null ? null : DateTime.tryParse(e.entryAt!)?.toLocal(),
      runningBalance:
          runningBalance == null ? null : Decimal.tryParse(runningBalance),
      sourceLabel: PaymentSource.describe(
        intoDrawer ? PaymentSource.drawer.apiValue : e.paymentSource,
      ),
      reference: e.referenceNo,
      shiftId: e.registerShiftId,
      note: e.notes,
      isReversed: e.isReversed,
      isReversal: e.isReversal || e.entryType == LedgerEntryType.reversal,
      reversalOfId: e.reversalOfId,
      reversedById: e.reversedById,
      // A line the server does not have yet has nothing to reverse there.
      canReverse: e.entryType == LedgerEntryType.payment &&
          !e.isReversed &&
          !e.isReversal &&
          !e.isOnDeviceOnly,
    );
  }

  factory LedgerLine.fromSupplier(SupplierLedgerEntry e) {
    final isExpense = e.referenceType == 'expense';
    return LedgerLine(
      id: e.id,
      party: LedgerParty.supplier,
      type: e.entryType,
      isExpense: isExpense,
      typeLabel: supplierTypeLabel(e.entryType, isExpense: isExpense),
      amount: e.amount,
      when: e.entryAt,
      runningBalance: e.runningBalance,
      sourceLabel: PaymentSource.describe(e.paymentSource),
      reference: e.referenceNo,
      shiftId: e.registerShiftId,
      note: e.notes,
      isReversed: e.isReversed,
      isReversal: e.isReversal,
      reversalOfId: e.reversalOfId,
      reversedById: e.reversedById,
      canReverse: e.canReverse,
    );
  }
}
