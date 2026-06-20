import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';

abstract final class SalePaymentMethodIcons {
  static String emojiFor(String method) => switch (method) {
        PaymentMethods.cash => '💵',
        PaymentMethods.card => '💳',
        PaymentMethods.wallet => '📱',
        PaymentMethods.bankTransfer => '🏦',
        PaymentMethods.cheque => '📝',
        PaymentMethods.credit => '📝',
        PaymentMethods.upi => '📱',
        PaymentMethods.other => '•••',
        _ => '💰',
      };
}

class SaleListPaymentMethodsCell extends StatelessWidget {
  const SaleListPaymentMethodsCell({super.key, required this.methods});

  final List<String> methods;

  @override
  Widget build(BuildContext context) {
    if (methods.isEmpty) {
      return Text('—', style: AppTextStyles.bodySmall);
    }

    final isSplit = methods.length > 1;

    return Tooltip(
      message: isSplit
          ? 'Split: ${methods.join(', ')}'
          : methods.first,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...methods.map(
            (m) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(
                SalePaymentMethodIcons.emojiFor(m),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (isSplit) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Split',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SaleListTotalCell extends StatelessWidget {
  const SaleListTotalCell({
    super.key,
    required this.totalAmount,
    required this.balanceDue,
    required this.formatAmount,
  });

  final String? totalAmount;
  final String? balanceDue;
  final String Function(String?) formatAmount;

  bool get _hasBalanceDue {
    if (balanceDue == null || balanceDue!.isEmpty) return false;
    try {
      return DecimalUtils.parse(balanceDue!) > Decimal.zero;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatAmount(totalAmount),
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_hasBalanceDue)
          Text(
            '${formatAmount(balanceDue)} due',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.warning,
            ),
          ),
      ],
    );
  }
}
