/// The business's money label (setting `business.currency_label`).
abstract final class CurrencyLabelHolder {
  static const fallback = 'Rs.';

  /// The label in force; kept up to date by `CurrencyLabelStore`.
  static String current = fallback;
}

/// What goes in front of money and in "Amount (Rs.)" field names.
String get currencyLabel => CurrencyLabelHolder.current;
