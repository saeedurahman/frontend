import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';

class JournalBalanceFooter extends StatelessWidget {
  const JournalBalanceFooter({
    super.key,
    required this.summary,
    this.showPostHint = true,
  });

  final JournalBalanceSummary summary;
  final bool showPostHint;

  @override
  Widget build(BuildContext context) {
    final balanced = summary.isBalanced;
    final differenceColor = balanced ? AppColors.success : AppColors.error;

    return Material(
      elevation: 8,
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: balanced
                  ? AppColors.success.withValues(alpha: 0.4)
                  : AppColors.error.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _TotalTile(
                    label: 'Total debits',
                    value: formatPKR(
                      double.tryParse(
                            DecimalUtils.format(summary.totalDebit),
                          ) ??
                          0,
                    ),
                  ),
                ),
                Expanded(
                  child: _TotalTile(
                    label: 'Total credits',
                    value: formatPKR(
                      double.tryParse(
                            DecimalUtils.format(summary.totalCredit),
                          ) ??
                          0,
                    ),
                  ),
                ),
                Expanded(
                  child: _TotalTile(
                    label: 'Difference',
                    value: formatPKR(
                      double.tryParse(
                            DecimalUtils.format(summary.difference),
                          ) ??
                          0,
                    ),
                    valueColor: differenceColor,
                    emphasized: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Lines: ${summary.lineCount} (${summary.linesWithAmount} with amounts)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (showPostHint) ...[
              const SizedBox(height: 4),
              Text(
                balanced && summary.meetsMinLinesForPost
                    ? 'Ready to post when saved'
                    : 'Posting requires at least 2 lines and balanced debits/credits',
                style: AppTextStyles.bodySmall.copyWith(
                  color: balanced ? AppColors.success : AppColors.textSecondary,
                  fontWeight: balanced ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: (emphasized ? AppTextStyles.titleMedium : AppTextStyles.bodyLarge).copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
