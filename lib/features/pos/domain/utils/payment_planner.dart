import 'package:decimal/decimal.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';

/// Payment-dialog rules, kept out of the widget: what credit the customer has
/// left, how the typed lines are allocated, and what each new line should be
/// pre-filled with.
abstract final class PaymentPlanner {
  /// [canSeeBalance] false = the user has no `customers.balance.view`, so the
  /// limit cannot be pre-checked here and the server decides.
  static CreditContext creditContext(
    CustomerModel? customer, {
    bool canSeeBalance = true,
  }) {
    if (customer == null) return CreditContext.none;
    return CreditContext(
      hasCustomer: true,
      creditLimit: Decimal.tryParse(customer.creditLimit),
      balance: Decimal.tryParse(customer.balance ?? ''),
      serverChecksLimit: !canSeeBalance,
    );
  }

  static PaymentAllocation allocate({
    required Decimal total,
    required Iterable<PaymentInput> inputs,
    required CustomerModel? customer,
    bool canSeeBalance = true,
  }) =>
      PaymentAllocator.allocate(
        total: total,
        inputs: inputs.toList(),
        credit: creditContext(customer, canSeeBalance: canSeeBalance),
      );

  /// What is still unpaid by every line except the one being edited
  /// ([others] must already leave that line out). Credit lines never reduce
  /// the cash due.
  static Decimal dueExcluding({
    required Decimal total,
    required Iterable<PaymentInput> others,
  }) {
    var due = total;
    for (final line in others) {
      if (line.method == PaymentMethods.credit) continue;
      due -= line.entered;
    }
    return due > Decimal.zero ? due : Decimal.zero;
  }

  /// Amount to pre-fill into a newly added non-credit line.
  static Decimal prefill(PaymentAllocation current) =>
      current.remaining > Decimal.zero ? current.remaining : Decimal.zero;

  /// A credit (udhaar) line needs a customer and may appear only once.
  static bool canAddMethod({
    required String method,
    required bool hasCustomer,
    required Iterable<String> existingMethods,
  }) {
    if (method != PaymentMethods.credit) return true;
    if (!hasCustomer) return false;
    return !existingMethods.contains(PaymentMethods.credit);
  }
}
