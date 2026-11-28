import 'package:decimal/decimal.dart';
import 'package:flutter/painting.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/domain/pending_ledger.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/ledger_note.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/domain/statement_wording.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
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
    this.source,
    this.canReverseEntry = false,
    this.pending = false,
    this.needsAttention = false,
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

  /// How it was paid, empty when not a payment: on a supplier account "Cash
  /// drawer", "Bank", ...; on a customer's, the statement's words ("Cash",
  /// "Bank transfer").
  final String sourceLabel;
  final String? reference;
  final String? shiftId;
  final String? note;
  final bool isReversed;
  final bool isReversal;
  final String? reversalOfId;
  final String? reversedById;
  /// A payment that can be reversed.
  final bool canReverse;

  /// "opening" or "manual" for entries written by hand.
  final String? source;

  /// A hand-written entry that can be reversed.
  final bool canReverseEntry;

  /// A supplier payment recorded on this device and not on the server yet.
  final bool pending;

  /// ... and sending it needs the user.
  final bool needsAttention;

  /// "Bank · #slip-1" style detail line.
  String get detail {
    final parts = <String>[
      if (sourceLabel.isNotEmpty) sourceLabel,
      if (reference != null && reference!.isNotEmpty) '#$reference',
    ];
    return parts.join(' · ');
  }

  /// The amount column: "Goods received 1,000.00", "Paid 300.00".
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
  static String supplierTypeLabel(
    String type, {
    bool isExpense = false,
    String? source,
    String? manualKind,
  }) =>
      _handWritten(type, source, manualKind) ??
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

  /// Names for entries written by hand, and for their reversals.
  static String? _handWritten(String type, String? source, String? kind) {
    if (source == null) return null;
    if (type == 'reversal') return EntryText.reversedEntryLine;
    return switch (ManualKind.parse(kind)) {
      ManualKind.udhaarGiven => EntryText.udhaarLine,
      ManualKind.goodsOnCredit => EntryText.goodsLine,
      _ => null,
    };
  }

  /// The words of the customer's statement.
  static String customerTypeLabel(
    String type, {
    String? source,
    String? manualKind,
  }) =>
      _handWritten(type, source, manualKind) ??
      switch (type) {
        'sale' => 'Credit sale',
        'payment' => 'Payment received',
        'return' || 'return_' => 'Goods returned',
        'opening_balance' => 'Opening balance',
        'adjustment' || 'correction' => 'Adjustment',
        'refund' => 'Credit sale cancelled',
        'reversal' => 'Payment reversed',
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
    final text = LedgerNote.read(type, e.notes, reference: e.referenceNo);
    return LedgerLine(
      id: e.id,
      party: LedgerParty.customer,
      type: type,
      typeLabel: customerTypeLabel(
        type,
        source: e.source,
        manualKind: e.manualKind,
      ),
      source: e.source,
      canReverseEntry: e.source != null &&
          !e.isReversed &&
          !e.isReversal &&
          e.entryType != LedgerEntryType.reversal &&
          !e.isOnDeviceOnly,
      amount: Decimal.tryParse(e.amount) ?? Decimal.zero,
      when: e.entryAt == null ? null : DateTime.tryParse(e.entryAt!)?.toLocal(),
      runningBalance:
          runningBalance == null ? null : Decimal.tryParse(runningBalance),
      // The customer's statement: cash is "Cash", wherever the shop put it.
      sourceLabel: StatementWording.source(e.paymentSource),
      reference: text.reference,
      shiftId: e.registerShiftId,
      note: text.note,
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
    final text = LedgerNote.read(e.entryType, e.notes, reference: e.referenceNo);
    return LedgerLine(
      id: e.id,
      party: LedgerParty.supplier,
      type: e.entryType,
      isExpense: isExpense,
      typeLabel: supplierTypeLabel(
        e.entryType,
        isExpense: isExpense,
        source: e.source,
        manualKind: e.manualKind,
      ),
      source: e.source,
      canReverseEntry: e.canReverseEntry,
      amount: e.amount,
      when: e.entryAt,
      runningBalance: e.runningBalance,
      sourceLabel: PaymentSource.describe(e.paymentSource),
      reference: text.reference,
      shiftId: e.registerShiftId,
      note: text.note,
      isReversed: e.isReversed,
      isReversal: e.isReversal,
      reversalOfId: e.reversalOfId,
      reversedById: e.reversedById,
      canReverse: e.canReverse,
      pending: e.pending,
      needsAttention: e.needsAttention,
    );
  }
}
