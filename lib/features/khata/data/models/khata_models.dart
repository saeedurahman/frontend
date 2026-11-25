import 'package:decimal/decimal.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';

Decimal khataDecimal(Object? value) =>
    Decimal.tryParse('${value ?? ''}'.trim()) ?? Decimal.zero;

Decimal? _decimalOrNull(Object? value) =>
    value == null ? null : Decimal.tryParse('$value'.trim());

DateTime? _date(Object? value) =>
    value == null ? null : DateTime.tryParse('$value')?.toLocal();

String? _text(Object? value) {
  if (value == null) return null;
  final s = '$value'.trim();
  return s.isEmpty ? null : s;
}

/// One row of a supplier account. Negative amount = we owe the supplier more.
class SupplierLedgerEntry {
  const SupplierLedgerEntry({
    required this.id,
    required this.supplierId,
    required this.entryType,
    required this.amount,
    this.branchId,
    this.entryAt,
    this.notes,
    this.referenceType,
    this.referenceId,
    this.paymentSource,
    this.referenceNo,
    this.registerShiftId,
    this.registerTransactionId,
    this.reversalOfId,
    this.reversedById,
    this.reversedAt,
    this.runningBalance,
  });

  factory SupplierLedgerEntry.fromJson(Map<String, dynamic> json) {
    return SupplierLedgerEntry(
      id: '${json['id']}',
      supplierId: '${json['supplier_id']}',
      branchId: _text(json['branch_id']),
      entryType: '${json['entry_type'] ?? ''}',
      amount: khataDecimal(json['amount']),
      entryAt: _date(json['entry_at'] ?? json['created_at']),
      notes: _text(json['notes']),
      referenceType: _text(json['reference_type']),
      referenceId: _text(json['reference_id']),
      paymentSource: _text(json['payment_source']),
      referenceNo: _text(json['reference_no']),
      registerShiftId: _text(json['register_shift_id']),
      registerTransactionId: _text(json['register_transaction_id']),
      reversalOfId: _text(json['reversal_of_id']),
      reversedById: _text(json['reversed_by_id']),
      reversedAt: _date(json['reversed_at']),
      runningBalance: _decimalOrNull(json['running_balance']),
    );
  }

  final String id;
  final String supplierId;
  final String? branchId;
  final String entryType;
  final Decimal amount;
  final DateTime? entryAt;
  final String? notes;
  final String? referenceType;
  final String? referenceId;
  final String? paymentSource;
  final String? referenceNo;
  final String? registerShiftId;
  final String? registerTransactionId;
  final String? reversalOfId;
  final String? reversedById;
  final DateTime? reversedAt;
  final Decimal? runningBalance;

  bool get isReversed => reversedAt != null || reversedById != null;
  bool get isReversal => reversalOfId != null || entryType == 'reversal';
  bool get isPayment => entryType == 'payment';

  /// A real payment that has not been undone yet.
  bool get canReverse => isPayment && !isReversed && !isReversal;
}

class SupplierLedgerPage {
  const SupplierLedgerPage({
    required this.items,
    required this.total,
    required this.balance,
    this.skip = 0,
    this.limit = 50,
  });

  factory SupplierLedgerPage.fromJson(Map<String, dynamic> json) {
    final raw = json['items'];
    return SupplierLedgerPage(
      items: raw is List
          ? raw
              .whereType<Map<dynamic, dynamic>>()
              .map((e) =>
                  SupplierLedgerEntry.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      total: int.tryParse('${json['total']}') ?? 0,
      skip: int.tryParse('${json['skip']}') ?? 0,
      limit: int.tryParse('${json['limit']}') ?? 50,
      balance: khataDecimal(json['balance']),
    );
  }

  final List<SupplierLedgerEntry> items;
  final int total;
  final int skip;
  final int limit;

  /// Whole-ledger balance (negative = we owe).
  final Decimal balance;
}

/// What the server answers to a supplier payment (and to the `payment` object
/// of a goods receipt / Quick Add).
class SupplierPaymentResult {
  const SupplierPaymentResult({
    required this.id,
    required this.amount,
    required this.paymentSource,
    required this.balanceBefore,
    required this.balance,
    this.supplierId,
    this.reference,
    this.note,
    this.entryAt,
    this.registerShiftId,
    this.registerTransactionId,
    this.isAdvance = false,
    this.advanceAmount,
  });

  factory SupplierPaymentResult.fromJson(Map<String, dynamic> json) {
    final balance = khataDecimal(json['balance']);
    final advance = _decimalOrNull(json['advance_amount']);
    return SupplierPaymentResult(
      id: '${json['id']}',
      supplierId: _text(json['supplier_id']),
      amount: khataDecimal(json['amount']),
      paymentSource: PaymentSource.fromApi('${json['payment_source']}') ??
          PaymentSource.drawer,
      reference: _text(json['reference_no'] ?? json['reference']),
      note: _text(json['notes'] ?? json['note']),
      entryAt: _date(json['entry_at']),
      registerShiftId: _text(json['register_shift_id']),
      registerTransactionId: _text(json['register_transaction_id']),
      balanceBefore: khataDecimal(json['balance_before']),
      balance: balance,
      isAdvance: json['is_advance'] == true || balance > Decimal.zero,
      advanceAmount: advance,
    );
  }

  final String id;
  final String? supplierId;
  final Decimal amount;
  final PaymentSource paymentSource;
  final String? reference;
  final String? note;
  final DateTime? entryAt;
  final String? registerShiftId;
  final String? registerTransactionId;

  /// Negative = we owe the supplier.
  final Decimal balanceBefore;
  final Decimal balance;
  final bool isAdvance;
  final Decimal? advanceAmount;

  /// What we still owe after the payment (never negative).
  Decimal get owedAfter => balance < Decimal.zero ? -balance : Decimal.zero;
}

class PaymentReversalResult {
  const PaymentReversalResult({
    required this.reversalId,
    required this.originalId,
    required this.partyId,
    required this.amount,
    required this.reason,
    required this.drawerReversed,
    required this.balance,
    this.balanceBefore,
  });

  factory PaymentReversalResult.fromJson(Map<String, dynamic> json) {
    return PaymentReversalResult(
      reversalId: '${json['reversal_id']}',
      originalId: '${json['original_id']}',
      partyId: '${json['party_id']}',
      amount: khataDecimal(json['amount']),
      reason: '${json['reason'] ?? ''}',
      drawerReversed: json['drawer_reversed'] == true,
      balance: khataDecimal(json['balance']),
      balanceBefore: _decimalOrNull(json['balance_before']),
    );
  }

  final String reversalId;
  final String originalId;
  final String partyId;
  final Decimal amount;
  final String reason;
  final bool drawerReversed;
  final Decimal balance;
  final Decimal? balanceBefore;
}

/// The "paid now" part of a goods receipt or a Quick Add purchase.
class ReceiptPaymentInput {
  const ReceiptPaymentInput({
    required this.amount,
    required this.source,
    this.reference,
    this.note,
  });

  final Decimal amount;
  final PaymentSource source;
  final String? reference;
  final String? note;

  bool get isEmpty => amount <= Decimal.zero;

  /// The backend `payment` object.
  Map<String, dynamic> toJson() => {
        'amount': amount.toStringAsFixed(2),
        'payment_source': source.apiValue,
        if (reference != null && reference!.trim().isNotEmpty)
          'reference': reference!.trim(),
        if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      };
}

/// What a GRN / Quick Add answered about the payment that came with it.
class ReceiptPaymentResult {
  const ReceiptPaymentResult({
    required this.payment,
    this.totalAmount,
  });

  final SupplierPaymentResult payment;
  final Decimal? totalAmount;

  static ReceiptPaymentResult? fromResponse(
    Map<String, dynamic> json, {
    String totalKey = 'total_amount',
  }) {
    final raw = json['payment'];
    if (raw is! Map) return null;
    return ReceiptPaymentResult(
      payment: SupplierPaymentResult.fromJson(Map<String, dynamic>.from(raw)),
      totalAmount: _decimalOrNull(json[totalKey]),
    );
  }
}
