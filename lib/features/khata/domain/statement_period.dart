/// The periods a statement can cover.
enum StatementPeriod {
  thisMonth,
  lastMonth,
  last3Months,
  thisYear,
  custom,
  all;

  /// The dates to ask the server for. A null start means "from the beginning";
  /// a null end means "up to today" (the server's own today, so a statement
  /// made around midnight is never cut short by this device's clock).
  ({DateTime? from, DateTime? to}) range(
    DateTime now, {
    DateTime? customFrom,
    DateTime? customTo,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    switch (this) {
      case StatementPeriod.thisMonth:
        return (from: DateTime(now.year, now.month), to: null);
      case StatementPeriod.lastMonth:
        return (
          from: DateTime(now.year, now.month - 1),
          to: DateTime(now.year, now.month, 0),
        );
      case StatementPeriod.last3Months:
        // This month and the two before it.
        return (from: DateTime(now.year, now.month - 2), to: null);
      case StatementPeriod.thisYear:
        return (from: DateTime(now.year), to: null);
      case StatementPeriod.custom:
        final end = customTo == null || !customTo.isBefore(today)
            ? null
            : DateTime(customTo.year, customTo.month, customTo.day);
        return (from: customFrom, to: end);
      case StatementPeriod.all:
        return (from: null, to: null);
    }
  }
}

/// With line items, or one line per bill.
enum StatementDetail {
  summary,
  detailed;

  static StatementDetail parse(Object? value) =>
      value == 'detailed' ? detailed : summary;
}
