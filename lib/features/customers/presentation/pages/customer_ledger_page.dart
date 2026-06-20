import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/customers/presentation/widgets/record_payment_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class CustomerLedgerPage extends StatelessWidget {
  const CustomerLedgerPage({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomerLedgerCubit>()..load(customerId),
      child: const _CustomerLedgerView(),
    );
  }
}

class _CustomerLedgerView extends StatelessWidget {
  const _CustomerLedgerView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerLedgerCubit, CustomerLedgerState>(
      listener: (context, state) {
        if (state is CustomerLedgerError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          CustomerLedgerInitial() || CustomerLedgerLoading() =>
            const Center(child: CircularProgressIndicator()),
          CustomerLedgerError(:final message) => Center(
              child: Text(message, style: AppTextStyles.bodyMedium),
            ),
          CustomerLedgerLoaded loaded => _LoadedView(state: loaded),
        };
      },
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});

  final CustomerLedgerLoaded state;

  String _formatEntryDate(String? value) {
    if (value == null || value.isEmpty) return '—';
    try {
      return DateFormatter.formatDateTime(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = state.customer;
    final balanceParsed = CustomerBalanceUtils.parseBalance(state.balance);
    final balanceDisplay =
        CustomerBalanceUtils.formatBalanceDisplay(state.balance);
    final cubit = context.read<CustomerLedgerCubit>();
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
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name, style: AppTextStyles.headlineMedium),
                  if (customer.phone != null)
                    Text(customer.phone!, style: AppTextStyles.bodySmall),
                  if (customer.email != null)
                    Text(customer.email!, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Customer',
              onPressed: () => context.push(
                '${RouteNames.customers}/${customer.id}/edit',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            color: balanceDisplay.isOwed
                ? AppColors.error.withValues(alpha: 0.08)
                : AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: balanceDisplay.isOwed ? AppColors.error : AppColors.primary,
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
        const SizedBox(height: AppDimensions.spacingMd),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Date', style: AppTextStyles.labelLarge),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Type', style: AppTextStyles.labelLarge),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Amount', style: AppTextStyles.labelLarge),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Running Balance',
                          style: AppTextStyles.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.entries.isEmpty
                      ? Center(
                          child: Text(
                            'No ledger entries yet',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification &&
                                notification.metrics.extentAfter < 200 &&
                                state.hasMore &&
                                !state.isLoadingMore) {
                              cubit.loadMore();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            itemCount: state.entries.length +
                                (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.entries.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final row = state.entries[index];
                              final entry = row.entry;
                              final amount =
                                  CustomerBalanceUtils.parseBalance(
                                entry.amount,
                              );
                              final running =
                                  CustomerBalanceUtils.parseBalance(
                                row.runningBalance,
                              );
                              final amountIsNegative = amount < Decimal.zero;

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.border),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _formatEntryDate(entry.entryAt),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        CustomerBalanceUtils
                                            .ledgerEntryTypeLabel(
                                          entry.entryType,
                                        ),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DecimalUtils.format(amount),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: amountIsNegative
                                              ? AppColors.error
                                              : AppColors.success,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        CustomerBalanceUtils
                                            .formatBalanceDisplay(
                                          row.runningBalance,
                                        )
                                            .text,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: running < Decimal.zero
                                              ? AppColors.error
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
