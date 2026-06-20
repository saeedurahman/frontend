import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';

abstract final class ShiftFormatUtils {
  static String formatDuration(String? openedAt, {String? closedAt}) {
    if (openedAt == null) return '—';
    try {
      final start = DateTime.parse(openedAt);
      final end = closedAt == null ? DateTime.now() : DateTime.parse(closedAt);
      final diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      if (hours > 0) return '${hours}h ${minutes}m';
      return '${minutes}m';
    } catch (_) {
      return '—';
    }
  }

  static String formatDateTime(String? value) {
    if (value == null || value.isEmpty) return '—';
    try {
      return DateFormatter.formatDateTime(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  static String formatMoney(String? value) {
    final parsed = Decimal.tryParse(value ?? '') ?? Decimal.zero;
    return formatPKR(parsed.toDouble());
  }

  static String formatMoneyDecimal(Decimal value) =>
      formatPKR(value.toDouble());

  static Color varianceColor(Decimal variance) {
    if (variance == Decimal.zero) return AppColors.success;
    if (variance > Decimal.zero) return AppColors.info;
    return AppColors.error;
  }

  static String varianceLabel(Decimal variance) {
    if (variance == Decimal.zero) return 'Exact match';
    if (variance > Decimal.zero) {
      return '${formatMoneyDecimal(variance)} OVER';
    }
    return '${formatMoneyDecimal(variance.abs())} SHORT';
  }
}

class VarianceDisplay extends StatelessWidget {
  const VarianceDisplay({
    super.key,
    required this.variance,
    this.large = false,
  });

  final Decimal variance;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final color = ShiftFormatUtils.varianceColor(variance);
    final label = variance == Decimal.zero
        ? '✓ Matches exactly'
        : ShiftFormatUtils.varianceLabel(variance);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(large ? 20 : 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: large ? 2 : 1),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: large ? 22 : 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ShiftSummaryBreakdown extends StatelessWidget {
  const ShiftSummaryBreakdown({
    super.key,
    required this.summary,
    this.showExpectedBreakdown = true,
  });

  final ShiftSummaryModel summary;
  final bool showExpectedBreakdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _KpiCard(
              title: 'Cash Sales',
              value: ShiftFormatUtils.formatMoney(summary.totalCashSales),
            ),
            _KpiCard(
              title: 'Card Sales',
              value: ShiftFormatUtils.formatMoney(summary.totalCardSales),
            ),
            _KpiCard(
              title: 'Wallet Sales',
              value: ShiftFormatUtils.formatMoney(summary.totalWalletSales),
            ),
            _KpiCard(
              title: 'Other Sales',
              value: ShiftFormatUtils.formatMoney(summary.totalOtherSales),
            ),
            _KpiCard(
              title: 'Returns',
              value: ShiftFormatUtils.formatMoney(summary.totalReturns),
            ),
            _KpiCard(
              title: 'Cash In',
              value: ShiftFormatUtils.formatMoney(summary.totalCashIn),
            ),
            _KpiCard(
              title: 'Cash Out',
              value: ShiftFormatUtils.formatMoney(summary.totalCashOut),
            ),
            _KpiCard(
              title: 'Expenses',
              value: ShiftFormatUtils.formatMoney(summary.totalExpenses),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expected Cash in Drawer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                ShiftFormatUtils.formatMoney(summary.expectedCash),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (showExpectedBreakdown) ...[
                const SizedBox(height: 12),
                Text(
                  'Opening Float (${ShiftFormatUtils.formatMoney(summary.openingFloat)}) '
                  '+ Cash Sales (${ShiftFormatUtils.formatMoney(summary.totalCashSales)}) '
                  '+ Cash In (${ShiftFormatUtils.formatMoney(summary.totalCashIn)}) '
                  '− Cash Out (${ShiftFormatUtils.formatMoney(summary.totalCashOut)}) '
                  '− Cash Expenses (${ShiftFormatUtils.formatMoney(summary.totalExpenses)}) '
                  '− cash refund payouts',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (summary.actualCash != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Counted Cash',
                  value: ShiftFormatUtils.formatMoney(summary.actualCash),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  label: 'Variance',
                  value: summary.cashDifference == null
                      ? '—'
                      : ShiftFormatUtils.varianceLabel(
                          DecimalUtils.parse(summary.cashDifference!),
                        ),
                  valueColor: summary.cashDifference == null
                      ? null
                      : ShiftFormatUtils.varianceColor(
                          DecimalUtils.parse(summary.cashDifference!),
                        ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
