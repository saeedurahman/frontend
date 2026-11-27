import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/presentation/widgets/payment_source_cards.dart'
    show KhataNotice;
import 'package:frantend/shared/widgets/permission_gate.dart';

/// "Credit limit reached" with the limit, the balance and what it would become.
/// People who hold `customers.credit.override` get "Allow anyway"; everybody
/// else is told to ask for it or take more money now. Nobody passes the limit
/// without tapping it.
class CreditBlockedNotice extends StatelessWidget {
  const CreditBlockedNotice({
    super.key = const ValueKey('credit-blocked'),
    required this.message,
    required this.numbers,
    required this.onAllowAnyway,
    this.describe,
    this.noOverrideText = KhataText.creditBlockedNoOverride,
  });

  final String message;
  final CreditNumbers? numbers;

  /// Null while the sale cannot be sent (busy, no shift).
  final VoidCallback? onAllowAnyway;

  /// Words for the numbers when this is not a sale (an udhaar entry).
  final String Function(CreditNumbers numbers)? describe;
  final String noOverrideText;

  /// Ledger balances in words: negative means the customer owes.
  static String balanceWords(Decimal balance) {
    if (balance < Decimal.zero) {
      return KhataText.balanceTheyOwe(formatPKR(-balance));
    }
    if (balance > Decimal.zero) {
      return KhataText.balanceAdvance(formatPKR(balance));
    }
    return formatPKR(balance);
  }

  @override
  Widget build(BuildContext context) {
    final allowed = holdsPermissionKey(context, Perm.customersCreditOverride);
    // Balances are only for people who may see them or decide on them.
    final n = allowed || hasPermission(context, Perm.customersBalanceView)
        ? numbers
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KhataNotice(
          icon: Icons.credit_score_outlined,
          title: KhataText.creditBlockedTitle,
          body: n == null
              ? message
              : describe?.call(n) ??
                  KhataText.creditBlockedBody(
                  limit: formatPKR(n.limit),
                  balance: balanceWords(n.balance),
                  wouldBe: balanceWords(n.wouldBe),
                ),
          action: allowed
              ? FilledButton(
                  key: const ValueKey('credit-allow-anyway'),
                  onPressed: onAllowAnyway,
                  child: const Text(KhataText.allowAnyway),
                )
              : null,
        ),
        if (!allowed)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              noOverrideText,
              key: const ValueKey('credit-no-override'),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
