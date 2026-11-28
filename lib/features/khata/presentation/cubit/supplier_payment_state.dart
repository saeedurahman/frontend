import 'package:decimal/decimal.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';

/// Everything the "Pay supplier" screen shows.
class SupplierPaymentState {
  SupplierPaymentState({
    this.supplierId = '',
    this.supplierName = '',
    this.supplierPhone,
    this.loading = true,
    Decimal? balance,
    this.amountText = '',
    this.source = PaymentSource.ownerPocket,
    this.reference = '',
    this.note = '',
    this.paidOn,
    this.shiftId,
    this.checkingShift = false,
    this.openingShift = false,
    this.submitting = false,
    this.error,
    this.errorCode,
    this.offline = false,
    this.result,
    this.balanceKnown = true,
    this.balanceAsOf,
  }) : balance = balance ?? Decimal.zero;

  final String supplierId;
  final String supplierName;
  final String? supplierPhone;
  final bool loading;

  /// Ledger balance: negative = you owe the supplier.
  final Decimal balance;
  final String amountText;
  final PaymentSource source;
  final String reference;
  final String note;

  /// A past date picked by the user; null = now.
  final DateTime? paidOn;
  final String? shiftId;
  final bool checkingShift;
  final bool openingShift;
  final bool submitting;
  final String? error;
  final String? errorCode;

  /// The last try failed because there is no internet; the draft is kept.
  final bool offline;
  final SupplierPaymentResult? result;

  /// False when what is owed could not be read: no balance is shown.
  final bool balanceKnown;

  /// Set when the balance is the device's copy: when that was last updated.
  final DateTime? balanceAsOf;

  Decimal get owed => balance < Decimal.zero ? -balance : Decimal.zero;

  Decimal? get amount {
    final value = Decimal.tryParse(amountText.trim());
    return value != null && value > Decimal.zero ? value : null;
  }

  /// null = fine, otherwise the problem with the typed amount.
  String? get amountProblem {
    final text = amountText.trim();
    if (text.isEmpty) return null;
    final value = Decimal.tryParse(text);
    if (value == null || value <= Decimal.zero) return 'Enter an amount';
    final dot = text.indexOf('.');
    if (dot >= 0 && text.length - dot - 1 > 2) {
      return 'Use at most 2 digits after the point';
    }
    return null;
  }

  Decimal get balanceAfter => balance + (amount ?? Decimal.zero);

  /// What stays owed after this payment (never negative).
  Decimal get owedAfter =>
      balanceAfter < Decimal.zero ? -balanceAfter : Decimal.zero;

  /// What goes over the bill and becomes an advance with the supplier.
  Decimal get advanceAfter =>
      balanceAfter > Decimal.zero ? balanceAfter : Decimal.zero;

  bool get isAdvance =>
      balanceKnown && amount != null && advanceAfter > Decimal.zero;

  /// Cash drawer picked but the user has no open shift.
  bool get needsShift =>
      source.touchesDrawer && !checkingShift && shiftId == null;

  bool get futureDate =>
      paidOn != null && paidOn!.isAfter(DateTime.now().add(const Duration(minutes: 5)));

  bool get canSubmit =>
      !loading &&
      !submitting &&
      amount != null &&
      amountProblem == null &&
      // Also while the shift check is still running: never send drawer cash
      // before we know there is a shift.
      !(source.touchesDrawer && shiftId == null) &&
      !futureDate &&
      result == null;

  SupplierPaymentState copyWith({
    String? supplierName,
    String? supplierPhone,
    bool? loading,
    Decimal? balance,
    String? amountText,
    PaymentSource? source,
    String? reference,
    String? note,
    Object? paidOn = _keep,
    Object? shiftId = _keep,
    bool? checkingShift,
    bool? openingShift,
    bool? submitting,
    Object? error = _keep,
    Object? errorCode = _keep,
    bool? offline,
    SupplierPaymentResult? result,
  }) {
    return SupplierPaymentState(
      supplierId: supplierId,
      supplierName: supplierName ?? this.supplierName,
      supplierPhone: supplierPhone ?? this.supplierPhone,
      loading: loading ?? this.loading,
      balance: balance ?? this.balance,
      amountText: amountText ?? this.amountText,
      source: source ?? this.source,
      reference: reference ?? this.reference,
      note: note ?? this.note,
      paidOn: identical(paidOn, _keep) ? this.paidOn : paidOn as DateTime?,
      shiftId: identical(shiftId, _keep) ? this.shiftId : shiftId as String?,
      checkingShift: checkingShift ?? this.checkingShift,
      openingShift: openingShift ?? this.openingShift,
      submitting: submitting ?? this.submitting,
      error: identical(error, _keep) ? this.error : error as String?,
      errorCode:
          identical(errorCode, _keep) ? this.errorCode : errorCode as String?,
      offline: offline ?? this.offline,
      result: result ?? this.result,
      balanceKnown: balanceKnown,
      balanceAsOf: balanceAsOf,
    );
  }

  SupplierPaymentState withSupplier(String id) => SupplierPaymentState(
        supplierId: id,
        supplierName: supplierName,
        supplierPhone: supplierPhone,
        loading: loading,
        balance: balance,
        amountText: amountText,
        source: source,
        reference: reference,
        note: note,
        paidOn: paidOn,
        shiftId: shiftId,
        checkingShift: checkingShift,
        openingShift: openingShift,
        submitting: submitting,
        error: error,
        errorCode: errorCode,
        offline: offline,
        result: result,
        balanceKnown: balanceKnown,
        balanceAsOf: balanceAsOf,
      );
}

const Object _keep = Object();
