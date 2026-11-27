/// Where money paid to a supplier came from, or how money from a customer came
/// in. One vocabulary for both.
///
/// [apiValue] is what the backend expects in `payment_source`.
enum PaymentSource {
  drawer('drawer', 'Cash drawer', 'Cash from the till'),
  ownerPocket('owner_pocket', "Owner's pocket", 'Your own money, not the till'),
  bank('bank', 'Bank', 'Bank transfer'),
  easypaisa('easypaisa', 'Easypaisa', 'Mobile wallet'),
  jazzcash('jazzcash', 'JazzCash', 'Mobile wallet'),
  cheque('cheque', 'Cheque', 'Written cheque'),
  card('card', 'Card', 'Card machine'),
  wallet('wallet', 'Wallet', 'Mobile wallet'),
  other('other', 'Other', 'Any other way');

  const PaymentSource(this.apiValue, this.label, this.hint);

  final String apiValue;
  final String label;
  final String hint;

  /// The choices when paying a supplier.
  static const supplierSources = [
    drawer, ownerPocket, bank, easypaisa, jazzcash, cheque, //
  ];

  /// The choices when a customer pays.
  static const customerSources = [
    drawer, bank, easypaisa, jazzcash, cheque, card, //
  ];

  /// Everything but cash has a slip / transaction / cheque number.
  bool get needsReference => this != drawer && this != ownerPocket;

  /// The hint when the money is coming in instead of going out.
  String get incomingHint => this == drawer ? 'Cash into the till' : hint;

  /// Only the cash drawer changes the cash in the till.
  bool get touchesDrawer => this == drawer;

  String get referenceLabel => switch (this) {
        cheque => 'Cheque number',
        bank => 'Transfer or slip number',
        easypaisa || jazzcash || wallet => 'Transaction number',
        card => 'Card slip number',
        _ => 'Reference',
      };

  static PaymentSource? fromApi(String? value) {
    if (value == null) return null;
    for (final s in values) {
      if (s.apiValue == value) return s;
    }
    return null;
  }

  /// The words for a stored source, the same [label] as everywhere else. Also
  /// reads older payment methods (cash, bank_transfer, upi). "cash" is money
  /// that reached no drawer.
  static String describe(String? value) {
    final known = fromApi(value);
    if (known != null) return known.label;
    return switch (value) {
      null || '' => '',
      'cash' => 'Cash',
      'bank_transfer' => 'Bank',
      'upi' => 'UPI',
      final other => other.replaceAll('_', ' '),
    };
  }
}
