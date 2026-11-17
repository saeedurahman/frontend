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
