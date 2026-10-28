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
