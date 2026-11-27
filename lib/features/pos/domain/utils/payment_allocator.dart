import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';

/// One payment line as typed by the cashier (before any capping).
class PaymentInput {
  const PaymentInput({
    required this.method,
    required this.entered,
    this.referenceNo,
    this.walletLabel,
  });

  final String method;
  final Decimal entered;
  final String? referenceNo;
  final String? walletLabel;
}

/// Customer data needed to validate credit (udhaar) sales.
class CreditContext {
  const CreditContext({
    required this.hasCustomer,
    this.creditLimit,
    this.balance,
    this.serverChecksLimit = false,
  });

  final bool hasCustomer;

  /// The cashier may not see balances (no `customers.balance.view`): the app
  /// cannot pre-check the limit, so the server's answer decides. The server
  /// always checks the limit, whoever the caller is.
  final bool serverChecksLimit;

  /// Customer `credit_limit`; null or <= 0 means "no limit" (backend rule).
  final Decimal? creditLimit;

  /// Ledger balance; negative means the customer already owes that amount.
  final Decimal? balance;

  Decimal get alreadyOwed {
    final b = balance;
    if (b == null || b >= Decimal.zero) return Decimal.zero;
    return -b;
  }

  /// Remaining credit, or null when the customer has no limit.
  Decimal? get available {
    final limit = creditLimit;
    if (limit == null || limit <= Decimal.zero) return null;
    final left = limit - alreadyOwed;
    return left < Decimal.zero ? Decimal.zero : left;
  }

  /// The numbers to show when [creditAmount] more would pass the limit; null
  /// when there is no limit or the balance is unknown.
  CreditNumbers? numbersAfter(Decimal creditAmount) {
    final limit = creditLimit;
    final now = balance;
    if (limit == null || limit <= Decimal.zero || now == null) return null;
    return CreditNumbers(
      limit: limit,
      balance: now,
      wouldBe: now - creditAmount,
    );
  }

  static const none = CreditContext(hasCustomer: false);
}

/// Result of applying typed payment lines to an amount due.
class PaymentAllocation {
  const PaymentAllocation({
    required this.total,
    required this.lines,
    required this.applied,
    required this.remaining,
    required this.change,
    required this.creditAmount,
    required this.cappedInputIndexes,
    this.error,
    this.overLimit = false,
  });

  final Decimal total;

  /// Lines to send to the API: amounts already capped, zero lines dropped.
  final List<PaymentLineModel> lines;

  /// Sum of [lines] (cash + card + wallet + bank + credit).
  final Decimal applied;

  /// Still unpaid after every line.
  final Decimal remaining;

  /// Cash handed back (cash tendered above the amount due).
  final Decimal change;

  /// Amount that goes on the customer's account.
  final Decimal creditAmount;

  /// Input indexes whose typed amount was reduced to fit the amount due.
  final Set<int> cappedInputIndexes;

  /// Blocking problem (credit without customer, over credit limit).
  final String? error;

  /// [error] is the credit limit, which a person with
  /// `customers.credit.override` may pass.
  final bool overLimit;

  bool get hasChange => change > Decimal.zero;

  bool get _covers =>
      total > Decimal.zero &&
      lines.isNotEmpty &&
      applied == total &&
      remaining == Decimal.zero;

  /// The sale can be completed only when the lines add up to the total.
  bool get canComplete => error == null && _covers;

  /// The sale can be completed with `credit_override` ("Allow anyway").
  bool get canOverride => overLimit && _covers;
}

/// Pure payment rules for the POS payment modal.
///
/// * Non-cash lines (card, wallet, bank...) are applied first and capped at
///   the amount still due: they can never overpay.
/// * Cash is applied next and capped at what is still due; the excess
///   tendered is [PaymentAllocation.change].
/// * Credit (udhaar) covers exactly the remainder, needs a customer and must
///   fit the customer's credit limit.
abstract final class PaymentAllocator {
  static PaymentAllocation allocate({
    required Decimal total,
    required List<PaymentInput> inputs,
    CreditContext credit = CreditContext.none,
  }) {
    var remaining = total > Decimal.zero ? total : Decimal.zero;
    final appliedByIndex = List<Decimal>.filled(inputs.length, Decimal.zero);
    final capped = <int>{};
    var change = Decimal.zero;

    bool isCash(PaymentInput i) => i.method == PaymentMethods.cash;
    bool isCredit(PaymentInput i) => i.method == PaymentMethods.credit;

    Decimal positive(Decimal v) => v > Decimal.zero ? v : Decimal.zero;

    // 1) non-cash, non-credit
    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      if (isCash(input) || isCredit(input)) continue;
      final entered = positive(input.entered);
      final apply = entered < remaining ? entered : remaining;
      if (apply < entered) capped.add(i);
      appliedByIndex[i] = apply;
      remaining -= apply;
    }

    // 2) cash, with change
    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      if (!isCash(input)) continue;
      final tendered = positive(input.entered);
      final apply = tendered < remaining ? tendered : remaining;
      appliedByIndex[i] = apply;
      remaining -= apply;
      change += tendered - apply;
    }

    // 3) credit takes the remainder
    var creditAmount = Decimal.zero;
    String? error;
    var overLimit = false;
    final creditIndexes = [
      for (var i = 0; i < inputs.length; i++)
        if (isCredit(inputs[i])) i,
    ];
    if (creditIndexes.isNotEmpty && remaining > Decimal.zero) {
      creditAmount = remaining;
      appliedByIndex[creditIndexes.first] = creditAmount;
      remaining = Decimal.zero;

      if (!credit.hasCustomer) {
        error = 'Select a customer to sell on credit';
      } else if (credit.serverChecksLimit) {
        // Nothing to pre-check; a refusal comes back with a clear message.
      } else if (credit.creditLimit != null &&
          credit.creditLimit! > Decimal.zero &&
          credit.balance == null) {
        // A limit exists but the customer's balance is unknown: never guess.
        error = 'Customer balance could not be loaded. Retry before selling '
            'on credit.';
      } else {
        final available = credit.available;
        if (available != null && creditAmount > available) {
          overLimit = true;
          error = 'Credit limit exceeded. Available credit: '
              '${available.toStringAsFixed(2)}';
        }
      }
    }

    final lines = <PaymentLineModel>[];
    var applied = Decimal.zero;
    for (var i = 0; i < inputs.length; i++) {
      final amount = appliedByIndex[i];
      if (amount <= Decimal.zero) continue;
      applied += amount;
      lines.add(PaymentLineModel(
        paymentMethod: inputs[i].method,
        amount: amount,
        referenceNo: _clean(inputs[i].referenceNo),
        walletLabel: inputs[i].walletLabel,
        tendered: isCash(inputs[i]) ? positive(inputs[i].entered) : null,
      ));
    }

    return PaymentAllocation(
      total: total,
      lines: lines,
      applied: applied,
      remaining: remaining,
      change: change,
      creditAmount: creditAmount,
      cappedInputIndexes: capped,
      error: error,
      overLimit: overLimit,
    );
  }

  static String? _clean(String? v) {
    final t = v?.trim();
    return t == null || t.isEmpty ? null : t;
  }
}
