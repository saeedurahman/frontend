import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';

class ExpenseStatusChip extends StatelessWidget {
  const ExpenseStatusChip({super.key, required this.status});

  final String status;

  Color get _color {
    return switch (status) {
      ExpenseStatus.paid => AppColors.primary,
      ExpenseStatus.partiallyPaid => AppColors.accent,
      ExpenseStatus.pending => Colors.orange.shade700,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        expenseStatusLabel(status),
        style: AppTextStyles.bodySmall.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ExpenseCategoryChip extends StatelessWidget {
  const ExpenseCategoryChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class CashShiftWarningBanner extends StatelessWidget {
  const CashShiftWarningBanner({
    super.key,
    required this.isChecking,
    required this.hasActiveShift,
  });

  final bool isChecking;
  final bool hasActiveShift;

  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: LinearProgressIndicator(minHeight: 2),
      );
    }
    if (hasActiveShift) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade800, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No open cash register shift found. The expense will still be '
              'recorded, but it will not appear in cash drawer reconciliation '
              'until a shift is open on this branch.',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
