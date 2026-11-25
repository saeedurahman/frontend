import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/pos/domain/utils/payment_planner.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// "Owes Rs 500 · Limit Rs 2,000 · Available Rs 1,500" for the customer at the
/// till. Shown only to people who hold `customers.balance.view` (cashiers do).
class CustomerCreditStrip extends StatelessWidget {
  const CustomerCreditStrip({super.key, required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return PermissionGate(
      permission: Perm.customersBalanceView,
      child: _Strip(customer: customer),
    );
  }
}

class _Strip extends StatelessWidget {
  const _Strip({required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    // No balance yet (still loading): say nothing rather than a wrong number.
    if (customer.balance == null) return const SizedBox.shrink();
    final credit = PaymentPlanner.creditContext(customer);
    final limit = credit.creditLimit;
    final hasLimit = limit != null && limit > Decimal.zero;
    final available = credit.available;
    final exhausted =
        hasLimit && available != null && available == Decimal.zero;
    return Container(
      key: const ValueKey('customer-credit-strip'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: [
          _item(
            KhataText.balanceOwes,
            formatPKR(credit.alreadyOwed),
            key: 'credit-owes',
            color: credit.alreadyOwed > Decimal.zero ? AppColors.warning : null,
          ),
          _item(
            KhataText.creditLimitLabel,
            hasLimit ? formatPKR(limit) : KhataText.noLimit,
            key: 'credit-limit',
          ),
          if (hasLimit && available != null)
            _item(
              KhataText.creditLeftLabel,
              formatPKR(available),
              key: 'credit-available',
              color: exhausted ? AppColors.error : AppColors.success,
            ),
        ],
      ),
    );
  }

  Widget _item(String label, String value, {required String key, Color? color}) {
    return Row(
      key: ValueKey(key),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
