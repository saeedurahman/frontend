import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';

/// Thrown when a sale is attempted without an open register shift.
class ShiftRequiredException implements Exception {
  const ShiftRequiredException();

  static const message = 'Open a shift first: sales need an open register '
      'shift.';

  @override
  String toString() => message;
}

/// Thrown when the payment lines do not add up to the amount due.
class PaymentMismatchException implements Exception {
  const PaymentMismatchException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The server refused the sale because the customer's credit limit would be
/// passed. The payment screen explains it with the customer's numbers and,
/// for someone who may override, offers "Allow anyway".
class CreditLimitExceededException implements Exception {
  const CreditLimitExceededException([
    this.message = KhataText.creditBlockedNoNumbers,
  ]);

  final String message;

  @override
  String toString() => message;
}

/// Expired stock cannot be sold (the business blocks it).
class ExpiredStockBlockedException implements Exception {
  const ExpiredStockBlockedException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The cart takes expired stock and the business wants the cashier to
/// confirm first. Retry the sale with `confirmExpired: true` once they agree.
class ExpiredStockWarningException implements Exception {
  const ExpiredStockWarningException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Turns the server's plain-string sale errors into plain words.
///
/// Backend contract (README "Under-paid sales"): `400 payment is less than
/// total` (no customer), `400 Credit limit exceeded ...`, and
/// `400 customer_id is required for credit payments`.
abstract final class SaleFailureMapper {
  static String _text(Failure f) => f.message.toLowerCase();

  static bool isCreditLimit(Failure f) {
    final code = f is ServerFailure ? f.code : null;
    return code == 'credit_limit_exceeded' ||
        _text(f).contains('credit limit exceeded');
  }

  static bool isUnderpaid(Failure f) =>
      _text(f).contains('payment is less than total');

  static bool isCreditNeedsCustomer(Failure f) =>
      _text(f).contains('customer_id is required for credit');

  /// The exception to throw for a refused sale, or null when [failure] is not
  /// one of the credit / under-paid rules (the caller keeps its own text).
  static Exception? map(Failure failure, {required bool hasCustomer}) {
    if (isCreditLimit(failure)) return const CreditLimitExceededException();
    if (isUnderpaid(failure)) {
      return PaymentMismatchException(
        hasCustomer
            ? KhataText.underpaidWithCustomer
            : KhataText.underpaidNoCustomer,
      );
    }
    if (isCreditNeedsCustomer(failure)) {
      return const PaymentMismatchException(KhataText.underpaidNeedsCustomer);
    }
    return null;
  }
}
