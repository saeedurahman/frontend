import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';

/// A sale cannot go through without the signed-in user's own open shift:
/// stopped here before sending, or refused by the server (`no_open_shift`,
/// `shift_not_yours`). The payment screen answers with "Open shift first".
class ShiftRequiredException implements Exception {
  const ShiftRequiredException([this.message = needsShift]);

  static const needsShift = 'Open shift first. Sales need an open register '
      'shift.';
  static const notYours = 'That shift belongs to someone else. Complete the '
      'sale again in your own shift.';

  final String message;

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
    this.numbers,
  ]);

  final String message;

  /// Limit, balance and what the balance would become, when the server sent
  /// them.
  final CreditNumbers? numbers;

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

/// Turns the server's sale refusals into plain words.
///
/// Backend contract (README "Error codes"): everything is decided by the code,
/// except two refusals the server sends as plain text with no code:
/// `payment is less than total` and
/// `customer_id is required for credit payments`.
abstract final class SaleFailureMapper {
  static String _text(Failure f) => f.message.toLowerCase();

  static bool isCreditLimit(Failure f) => f.code == KhataText.creditLimitCode;

  static bool isUnderpaid(Failure f) =>
      _text(f).contains('payment is less than total');

  static bool isCreditNeedsCustomer(Failure f) =>
      _text(f).contains('customer_id is required for credit');

  /// The exception to throw for a refused sale, or null when [failure] is not
  /// one of the shift / credit / under-paid rules (the caller keeps its own
  /// text).
  static Exception? map(Failure failure, {required bool hasCustomer}) {
    if (KhataText.needsOwnShift(failure.code)) {
      return ShiftRequiredException(
        failure.code == KhataText.shiftNotYoursCode
            ? ShiftRequiredException.notYours
            : ShiftRequiredException.needsShift,
      );
    }
    if (isCreditLimit(failure)) {
      return CreditLimitExceededException(
        KhataText.creditBlockedNoNumbers,
        failure is ServerFailure ? failure.credit : null,
      );
    }
    if (failure.code == 'credit_override_forbidden') {
      return const PaymentMismatchException(KhataText.creditOverrideForbidden);
    }
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
