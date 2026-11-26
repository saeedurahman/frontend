import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';

/// Whose account a ledger row belongs to.
enum LedgerParty { customer, supplier }

/// How the amount and balance columns of an account read.
///
/// Both ledgers use one sign: negative = money is owed (we owe the supplier, or
/// the customer owes us). The screens never show that sign: the balance says in
/// words who owes, and an amount says what it was, with "+" when it adds to what
/// is owed and "-" when it takes away.
abstract final class LedgerWording {
  /// More owed.
  static const Color more = AppColors.error;

  /// Less owed, or paid ahead.
  static const Color less = AppColors.success;

  /// "Rs. 600 we owe" / "Rs. 117 they owe" (red), "Rs. 200 advance" (green),
  /// "Settled".
  static ({String text, Color color}) balance(
    Decimal value,
    LedgerParty party,
  ) {
    if (value < Decimal.zero) {
      final amount = formatPKR(-value);
      return (
        text: switch (party) {
          LedgerParty.supplier => KhataText.balanceWeOwe(amount),
          LedgerParty.customer => KhataText.balanceTheyOwe(amount),
        },
        color: more,
      );
    }
    if (value > Decimal.zero) {
      return (text: KhataText.balanceAdvance(formatPKR(value)), color: less);
    }
    return (text: KhataText.balanceSettled, color: AppColors.textPrimary);
  }

  /// "Goods +1,000.00" / "Paid -300.00". [type] is the server's `entry_type`;
  /// [amount] has the ledger sign.
  static ({String text, Color color}) amount({
    required String type,
    required Decimal amount,
    required LedgerParty party,
    bool isExpense = false,
  }) {
    final addsToOwed = amount < Decimal.zero;
    final supplier = party == LedgerParty.supplier;
    final word = switch (type) {
      'sale' || 'purchase' => !supplier
          ? KhataText.amountSale
          : (isExpense ? KhataText.amountExpense : KhataText.amountGoods),
      'payment' => supplier ? KhataText.amountPaid : KhataText.amountReceived,
      'reversal' => KhataText.amountReversed,
      'return' || 'return_' => KhataText.amountReturned,
      // Opening balances and corrections can go either way.
      _ => addsToOwed ? KhataText.amountAdded : KhataText.amountReduced,
    };
    if (amount == Decimal.zero) {
      return (
        text: '$word ${formatMoneyNumber(amount)}',
        color: AppColors.textPrimary,
      );
    }
    final sign = addsToOwed ? '+' : '-';
    return (
      text: '$word $sign${formatMoneyNumber(amount.abs())}',
      color: addsToOwed ? more : less,
    );
  }
}
