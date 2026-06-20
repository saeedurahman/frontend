import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';
import 'package:frantend/features/expenses/presentation/widgets/expense_status_chip.dart';
import 'package:frantend/features/expenses/presentation/widgets/record_expense_payment_dialog.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class ExpenseDetailPage extends StatelessWidget {
  const ExpenseDetailPage({super.key, required this.expenseId});

  final String expenseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseDetailCubit>()..load(expenseId),
      child: _ExpenseDetailView(expenseId: expenseId),
    );
  }
}

class _ExpenseDetailView extends StatelessWidget {
  const _ExpenseDetailView({required this.expenseId});

  final String expenseId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseDetailCubit, ExpenseDetailState>(
      listener: (context, state) {
        if (state is ExpenseDetailError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          ExpenseDetailInitial() || ExpenseDetailLoading() =>
            const Center(child: CircularProgressIndicator()),
          ExpenseDetailError(:final message) => Center(
              child: Text(message, style: AppTextStyles.bodyMedium),
            ),
          ExpenseDetailLoaded loaded => _LoadedView(
              state: loaded,
              expenseId: expenseId,
            ),
        };
      },
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state, required this.expenseId});

  final ExpenseDetailLoaded state;
  final String expenseId;

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.year}';
    } catch (_) {
      return date;
    }
  }

  String _formatDateTime(String? value) {
    if (value == null || value.isEmpty) return '—';
    try {
      final parsed = DateTime.parse(value);
      return '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.year} '
          '${parsed.hour.toString().padLeft(2, '0')}:'
          '${parsed.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return value;
    }
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete expense?',
      message: 'This will remove ${state.expense.expenseNumber} from records.',
    );
    if (ok != true || !context.mounted) return;
    final success = await context.read<ExpenseDetailCubit>().deleteExpense();
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Expense deleted');
      context.go(RouteNames.expenses);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expense = state.expense;
    final status = ExpenseCalculations.deriveStatus(expense);
    final total = ExpenseCalculations.expenseTotal(expense);
    final paid = ExpenseCalculations.paidTotal(expense);
    final remaining = ExpenseCalculations.remainingBalance(expense);
    final canRecordPayment = remaining > Decimal.zero;
    final categoryName = categoryNameForId(
          state.categories,
          expense.expenseCategoryId,
        ) ??
        '—';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              Text('Expense Detail', style: AppTextStyles.headlineMedium),
              const Spacer(),
              if (canEditExpense(expense))
                OutlinedButton.icon(
                  onPressed: () async {
                    final saved = await context.push<bool>(
                      RouteNames.expenseEditPath(expenseId),
                    );
                    if (saved == true && context.mounted) {
                      await context.read<ExpenseDetailCubit>().load(expenseId);
                    }
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: state.isDeleting ? null : () => _delete(context),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ExpenseCategoryChip(label: categoryName),
                    const SizedBox(width: 12),
                    ExpenseStatusChip(status: status),
                    const Spacer(),
                    Text(
                      formatPKR(total.toDouble()),
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  expense.description?.isNotEmpty == true
                      ? expense.description!
                      : expense.expenseNumber,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _MetaItem(
                      label: 'Expense #',
                      value: expense.expenseNumber,
                    ),
                    _MetaItem(
                      label: 'Date',
                      value: _formatDate(expense.expenseDate),
                    ),
                    if (state.supplier != null)
                      _MetaItem(
                        label: 'Supplier',
                        value: state.supplier!.name,
                        onTap: () => context.push(
                          '${RouteNames.suppliers}/${state.supplier!.id}',
                        ),
                      ),
                    if (expense.taxAmount != '0' && expense.taxAmount.isNotEmpty)
                      _MetaItem(
                        label: 'Tax',
                        value: formatPKR(
                          double.tryParse(expense.taxAmount) ?? 0,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Payments', style: AppTextStyles.titleMedium),
                    const Spacer(),
                    if (canRecordPayment)
                      ElevatedButton.icon(
                        onPressed: state.isRecordingPayment
                            ? null
                            : () => RecordExpensePaymentDialog.show(
                                  context,
                                  expenseDescription:
                                      expense.description?.isNotEmpty == true
                                          ? expense.description!
                                          : expense.expenseNumber,
                                  remainingBalance: remaining.toString(),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Record Payment'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Paid: ${formatPKR(paid.toDouble())} / '
                  '${formatPKR(total.toDouble())}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                if (expense.payments.isEmpty)
                  Text(
                    'No payments recorded yet.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...expense.payments.map(
                    (p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              paymentMethodLabel(p.paymentMethod),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _formatDateTime(p.paidAt ?? p.createdAt),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              p.referenceNo ?? '—',
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                          Text(
                            formatPKR(double.tryParse(p.amount) ?? 0),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (status == ExpenseStatus.paid) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Fully Paid',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: onTap != null ? AppColors.primary : null,
            decoration: onTap != null ? TextDecoration.underline : null,
          ),
        ),
      ],
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, child: child);
    }
    return child;
  }
}
