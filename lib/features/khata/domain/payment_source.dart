/// Where the money for a supplier payment came from.
///
/// [apiValue] is what the backend expects in `payment_source`.
enum PaymentSource {
  drawer('drawer', 'Cash drawer', 'Cash from the till'),
  ownerPocket('owner_pocket', "Owner's pocket", 'Your own money, not the till'),
  bank('bank', 'Bank', 'Bank transfer'),
  easypaisa('easypaisa', 'Easypaisa', 'Mobile wallet'),
  jazzcash('jazzcash', 'JazzCash', 'Mobile wallet'),
  cheque('cheque', 'Cheque', 'Written cheque');

  const PaymentSource(this.apiValue, this.label, this.hint);

  final String apiValue;
  final String label;
  final String hint;

  /// Bank, wallets and cheques have a slip / transaction / cheque number.
  bool get needsReference =>
      this == bank || this == easypaisa || this == jazzcash || this == cheque;

  /// Only the cash drawer changes the cash in the till.
  bool get touchesDrawer => this == drawer;

  String get referenceLabel => switch (this) {
        cheque => 'Cheque number',
        bank => 'Transfer or slip number',
        easypaisa || jazzcash => 'Transaction number',
        _ => 'Reference',
      };

  static PaymentSource? fromApi(String? value) {
    if (value == null) return null;
    for (final s in values) {
      if (s.apiValue == value) return s;
    }
    return null;
  }

  /// Short words for a ledger row's source. Also reads customer payment
  /// methods (cash, card, ...).
  static String describe(String? value) {
    final known = fromApi(value);
    if (known != null) {
      return switch (known) {
        drawer => 'Drawer',
        ownerPocket => 'Owner pocket',
        _ => known.label,
      };
    }
    return switch (value) {
      null || '' => '',
      'cash' => 'Cash',
      'card' => 'Card',
      'wallet' => 'Wallet',
      'bank_transfer' => 'Bank',
      'other' => 'Other',
      final other => other.replaceAll('_', ' '),
    };
  }
}
