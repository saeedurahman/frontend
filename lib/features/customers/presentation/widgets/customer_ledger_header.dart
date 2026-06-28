import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/customers/presentation/widgets/record_payment_dialog.dart';
import 'package:go_router/go_router.dart';

class CustomerLedgerHeader extends StatelessWidget {
  const CustomerLedgerHeader({super.key, required this.state});

  final CustomerLedgerLoaded state;

  @override
  Widget build(BuildContext context) {
    final customer = state.customer;
    final balanceParsed = CustomerBalanceUtils.parseBalance(state.balance);
    final balanceDisplay =
        CustomerBalanceUtils.formatBalanceDisplay(state.balance);
    final balanceLabel = balanceParsed < Decimal.zero
        ? 'Outstanding Balance'
        : balanceParsed > Decimal.zero
            ? 'Available Credit'
            : 'Settled';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text(
                'Back to Customers',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => context.push(
                '${RouteNames.customers}/${customer.id}/edit',
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Customer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(customer.name, style: AppTextStyles.headlineMedium),
        if (customer.phone != null)
          Text(customer.phone!, style: AppTextStyles.bodySmall),
        if (customer.email != null)
          Text(customer.email!, style: AppTextStyles.bodySmall),
        const SizedBox(height: AppDimensions.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            color: balanceDisplay.isOwed
                ? AppColors.error.withValues(alpha: 0.08)
                : AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  balanceDisplay.isOwed ? AppColors.error : AppColors.primary,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    balanceDisplay.isOwed
                        ? Icons.account_balance_wallet_outlined
                        : Icons.check_circle_outline,
                    color: balanceDisplay.isOwed
                        ? AppColors.error
                        : AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          balanceLabel,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          balanceDisplay.text,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: balanceDisplay.isOwed
                                ? AppColors.error
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (customer.creditLimit.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Credit Limit',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          CustomerBalanceUtils.formatCreditLimit(
                            customer.creditLimit,
                          ),
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FutureBuilder(
                future: sl<AuthLocalDataSource>().getCachedUser(),
                builder: (context, snapshot) {
                  final role = snapshot.data?.role.toLowerCase() ?? '';
                  final canRecord = role.isEmpty ||
                      role == 'owner' ||
                      role == 'manager';

                  return Tooltip(
                    message: canRecord
                        ? 'Record customer payment'
                        : 'Manager approval required',
                    child: ElevatedButton.icon(
                      onPressed: canRecord
                          ? () => RecordPaymentDialog.show(
                                context,
                                customerName: customer.name,
                                currentBalance: state.balance,
                              )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.payments_outlined, size: 18),
                      label: const Text('Record Payment'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
