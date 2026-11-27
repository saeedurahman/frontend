/// Narrowing and ordering a customer or supplier list by its balances.
///
/// Ledger sign: negative = still owed (the customer owes the shop, or the shop
/// owes the supplier); positive = paid in advance.
library;

import 'package:decimal/decimal.dart';

enum BalanceFilter {
  all,

  /// "Owes me" on customers, "I owe" on suppliers.
  owing,

  /// Money held in advance.
  advance;

  /// An unknown balance (still loading) matches nothing but "all".
  bool matches(Decimal? balance) => switch (this) {
        BalanceFilter.all => true,
        BalanceFilter.owing => balance != null && balance < Decimal.zero,
        BalanceFilter.advance => balance != null && balance > Decimal.zero,
      };
}

enum BalanceSort {
  /// The list's own order.
  none,
  highest,
  lowest;

  /// [items] by the size of what is owed (or, when [filter] shows advances,
  /// the size of the advance). Unknown balances go last; ties keep the list's
  /// order.
  List<T> apply<T>(
    List<T> items,
    Decimal? Function(T item) balanceOf,
    BalanceFilter filter,
  ) {
    if (this == BalanceSort.none) return items;
    Decimal? key(T item) {
      final b = balanceOf(item);
      if (b == null) return null;
      return filter == BalanceFilter.advance ? b : -b;
    }

    final indexed = [
      for (var i = 0; i < items.length; i++) (i, items[i], key(items[i])),
    ];
    indexed.sort((a, b) {
      final x = a.$3;
      final y = b.$3;
      if (x == null || y == null) {
        if (x == null && y == null) return a.$1.compareTo(b.$1);
        return x == null ? 1 : -1;
      }
      final order =
          this == BalanceSort.highest ? y.compareTo(x) : x.compareTo(y);
      return order != 0 ? order : a.$1.compareTo(b.$1);
    });
    return [for (final e in indexed) e.$2];
  }
}

/// A balance as the lists hold it (text, or "—" when unknown).
Decimal? listBalance(String? text) =>
    text == null ? null : Decimal.tryParse(text.trim());
