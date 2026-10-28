/// Outcome of resuming a held order.
class HeldResumeResult {
  const HeldResumeResult({required this.resumed, this.changes = const []});

  /// The order was loaded into the cart.
  final bool resumed;

  /// Human-readable price/tax changes found while refreshing the order, shown
  /// to the cashier as a warning before they continue.
  final List<String> changes;

  bool get hasChanges => changes.isNotEmpty;

  static const notResumed = HeldResumeResult(resumed: false);
}
