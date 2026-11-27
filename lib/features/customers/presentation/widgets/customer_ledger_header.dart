import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/customers/presentation/widgets/record_payment_dialog.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';
import 'package:frantend/shared/widgets/dialogs/export_dialog.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
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
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            TextButton.icon(
              // Opened from a link or the khata, there may be nothing to pop.
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go(RouteNames.customers),
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
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppDimensions.spacingSm,
              runSpacing: AppDimensions.spacingSm,
              children: [
                PartyKhataActions(
                  type: PartyType.customer,
                  partyId: customer.id,
                  name: customer.name,
                  phone: customer.phone,
                  branchId: context.read<CustomerLedgerCubit>().branchId,
                  balanceOwed:
                      balanceParsed < Decimal.zero ? -balanceParsed : null,
                  hasOpening: hasOpeningBalance(
                    state.entries
                        .map((r) => LedgerLine.fromCustomer(r.entry)),
                  ),
                ),
                PermissionGate(
                  permission: Perm.reportsExport,
                  child: OutlinedButton.icon(
                    onPressed: () => ExportDialog.show(
                      context,
                      dataset: 'customer_ledger',
                      title: 'Customer Ledger (${customer.name})',
                      // Only this customer, in the branch on screen, all dates.
                      filters: {'customer_id': customer.id},
                      fileLabel: customer.name,
                      branchId: context.read<CustomerLedgerCubit>().branchId,
                    ),
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Export Ledger'),
                  ),
                ),
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
              PermissionGate(
                permission: Perm.customersUpdate,
                mode: GateMode.disable,
                mutating: true,
                builder: (context, enabled) => ElevatedButton.icon(
                  onPressed: enabled
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
