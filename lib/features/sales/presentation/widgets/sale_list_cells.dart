import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';

abstract final class SalePaymentMethodLabels {
  static String labelFor(String method) => switch (method) {
        PaymentMethods.cash => 'Cash',
        PaymentMethods.card => 'Card',
        PaymentMethods.wallet => 'Wallet',
        PaymentMethods.bankTransfer => 'Bank Transfer',
        PaymentMethods.cheque => 'Cheque',
        PaymentMethods.credit => 'Credit',
        PaymentMethods.upi => 'UPI',
        PaymentMethods.other => 'Other',
        _ => _titleCase(method),
      };

  static String _titleCase(String raw) {
    return raw
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

class SaleListPaymentMethodsCell extends StatelessWidget {
  const SaleListPaymentMethodsCell({super.key, required this.methods});

  final List<String> methods;

  @override
  Widget build(BuildContext context) {
    if (methods.isEmpty) {
      return Text('—', style: AppTextStyles.bodySmall);
    }

    final uniqueMethods = <String>[];
    for (final method in methods) {
      if (!uniqueMethods.contains(method)) {
        uniqueMethods.add(method);
      }
    }

    final isSplit = uniqueMethods.length > 1;
    final labels =
        uniqueMethods.map(SalePaymentMethodLabels.labelFor).toList();
    final tooltip =
        isSplit ? 'Split: ${labels.join(', ')}' : labels.first;

    if (isSplit) {
      return Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Split · ${uniqueMethods.length}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: tooltip,
      child: Text(
        labels.first,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
        ),
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
