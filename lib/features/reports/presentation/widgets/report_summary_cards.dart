import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/reports/data/models/analytics_report_models.dart';
import 'package:frantend/features/reports/presentation/widgets/report_widgets.dart';
import 'package:frantend/features/reports/presentation/widgets/reports_data_tables.dart';
import 'package:intl/intl.dart';

final _reportMoneyFormatter = NumberFormat('#,##0.00', 'en_US');

String reportDisplayMoney(String? raw) {
  final value = double.tryParse(raw ?? '') ?? 0;
  return 'Rs. ${_reportMoneyFormatter.format(value)}';
}

class SalesSummarySection extends StatelessWidget {
  const SalesSummarySection({
    super.key,
    required this.summary,
    this.comparison,
  });

  final SalesSummaryModel summary;
  final TodayVsYesterdayModel? comparison;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: 'Sales Summary',
      child: Row(
        children: [
          Expanded(
            child: ReportMetricCard(
              label: 'Net Revenue',
              value: reportDisplayMoney(summary.netRevenue),
              icon: Icons.attach_money_rounded,
              changePct: comparison?.revenueChangePct,
              valueIsCurrency: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Transactions',
              value: '${summary.totalTransactions}',
              icon: Icons.shopping_cart_outlined,
              changePct: comparison?.transactionChangePct,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Avg Order Value',
              value: reportDisplayMoney(summary.avgOrderValue),
              icon: Icons.bar_chart_rounded,
              changePct: _avgOrderChangePct(comparison),
              valueIsCurrency: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Tax Collected',
              value: reportDisplayMoney(summary.totalTax),
              icon: Icons.receipt_long_outlined,
              valueIsCurrency: true,
            ),
          ),
        ],
      ),
    );
  }

  static String? _avgOrderChangePct(TodayVsYesterdayModel? data) {
    if (data == null) return null;
    final today = double.tryParse(data.todayAvgOrder) ?? 0;
    final yesterday = double.tryParse(data.yesterdayAvgOrder) ?? 0;
    if (yesterday == 0) {
      if (today == 0) return '0';
      return '100';
    }
    return (((today - yesterday) / yesterday) * 100).toStringAsFixed(1);
  }
}

class InventoryOverviewSection extends StatelessWidget {
  const InventoryOverviewSection({super.key, required this.insights});

  final InventoryInsightsReportModel insights;

  @override
  Widget build(BuildContext context) {
    final hasLowStock = insights.lowStockCount > 0;
    final hasOutOfStock = insights.outOfStockCount > 0;

    return ReportSectionCard(
      title: 'Inventory Overview',
      child: Row(
        children: [
          Expanded(
            child: ReportMetricCard(
              label: 'Total Products',
              value: '${insights.totalProducts}',
              icon: Icons.inventory_2_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Stock Value',
              value: reportDisplayMoney(insights.totalStockValue),
              icon: Icons.account_balance_wallet_outlined,
              valueIsCurrency: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Low Stock',
              value: '${insights.lowStockCount}',
              icon: Icons.warning_amber_rounded,
              backgroundColor: hasLowStock
                  ? AppColors.warning.withValues(alpha: 0.08)
                  : AppColors.background,
              iconBackgroundColor: hasLowStock
                  ? AppColors.warning.withValues(alpha: 0.18)
                  : AppColors.brandingPanel,
              iconColor: hasLowStock ? AppColors.warning : Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Out of Stock',
              value: '${insights.outOfStockCount}',
              icon: Icons.remove_shopping_cart_outlined,
              backgroundColor: hasOutOfStock
                  ? AppColors.error.withValues(alpha: 0.06)
                  : AppColors.background,
              iconBackgroundColor: hasOutOfStock
                  ? AppColors.error.withValues(alpha: 0.15)
                  : AppColors.brandingPanel,
              iconColor: hasOutOfStock ? AppColors.error : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class StockValuationSection extends StatelessWidget {
  const StockValuationSection({
    super.key,
    required this.items,
    required this.stockTotal,
  });

  final List<StockValuationModel> items;
  final double stockTotal;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: 'Stock Valuation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportMetricCard(
            label: 'Total Inventory Value',
            value: reportDisplayMoney(stockTotal.toString()),
            icon: Icons.assessment_outlined,
            valueIsCurrency: true,
            backgroundColor: AppColors.background,
          ),
          const SizedBox(height: 12),
          StockValuationTable(items: items),
        ],
      ),
    );
  }
}

class TodayVsYesterdaySection extends StatelessWidget {
  const TodayVsYesterdaySection({super.key, required this.data});

  final TodayVsYesterdayModel data;

  @override
  Widget build(BuildContext context) {
    final revenueChange = double.tryParse(data.revenueChangePct) ?? 0;
    final profitChange = double.tryParse(data.profitChangePct) ?? 0;
    final revenueTrendNegative = revenueChange < 0;
    final profitTrendNegative = profitChange < 0;

    return ReportSectionCard(
      title: 'Today vs Yesterday',
      child: Row(
        children: [
          Expanded(
            child: ReportMetricCard(
              label: 'Today Revenue',
              value: reportDisplayMoney(data.todayRevenue),
              icon: Icons.account_balance_wallet_outlined,
              changePct: data.revenueChangePct,
              valueIsCurrency: true,
              backgroundColor: revenueTrendNegative
                  ? AppColors.error.withValues(alpha: 0.06)
                  : AppColors.background,
              iconBackgroundColor: revenueTrendNegative
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.brandingPanel,
              iconColor: revenueTrendNegative
                  ? AppColors.primary
                  : Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Yesterday Revenue',
              value: reportDisplayMoney(data.yesterdayRevenue),
              icon: Icons.account_balance_wallet_outlined,
              changePct: _invertChangePct(data.revenueChangePct),
              valueIsCurrency: true,
              backgroundColor: AppColors.background,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportMetricCard(
              label: 'Today Profit',
              value: reportDisplayMoney(data.todayProfit),
              icon: Icons.trending_up_rounded,
              changePct: data.profitChangePct,
              valueIsCurrency: true,
              backgroundColor: profitTrendNegative
                  ? AppColors.error.withValues(alpha: 0.06)
                  : AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  static String _invertChangePct(String raw) {
    final value = double.tryParse(raw) ?? 0;
    return (-value).toStringAsFixed(1);
  }
}

class ReportMetricCard extends StatelessWidget {
  const ReportMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.changePct,
    this.valueIsCurrency = false,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? changePct;
  final bool valueIsCurrency;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? AppColors.brandingPanel,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: valueIsCurrency && !_isZeroValue(value)
                        ? AppColors.brandingPanel
                        : AppColors.textPrimary,
                  ),
                ),
                if (changePct != null) ...[
                  const SizedBox(height: 6),
                  ReportTrendLabel(changePct: changePct!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool _isZeroValue(String displayValue) {
  final cleaned = displayValue.replaceAll(RegExp(r'[^0-9.]'), '');
  return (double.tryParse(cleaned) ?? 0) == 0;
}

class ReportTrendPill extends StatelessWidget {
  const ReportTrendPill({super.key, required this.changePct});

  final String changePct;

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(changePct) ?? 0;
    final isPositive = value >= 0;
    final arrow = isPositive ? '↑' : '↓';
    final color = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$arrow ${value.abs().toStringAsFixed(1)}%',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class ProfitLossStatementSection extends StatelessWidget {
  const ProfitLossStatementSection({super.key, required this.pl});

  final ProfitLossModel pl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfitLossRow(
          title: 'Revenue',
          subtitle: 'Total sales revenue',
          value: reportDisplayMoney(pl.totalRevenue),
          icon: Icons.attach_money_rounded,
        ),
        const Divider(height: 1, color: AppColors.border),
        _ProfitLossRow(
          title: 'Gross Profit',
          subtitle: 'Revenue minus cost of goods sold',
          value: reportDisplayMoney(pl.grossProfit),
          icon: Icons.bar_chart_rounded,
          changePct: pl.grossMarginPct,
        ),
        const Divider(height: 1, color: AppColors.border),
        _ProfitLossRow(
          title: 'Operating Expense',
          subtitle: 'Total operating expenses',
          value: reportDisplayMoney(pl.totalExpenses),
          icon: Icons.credit_card_outlined,
        ),
        _ProfitLossRow(
          title: 'Net Profit',
          subtitle: 'Profit after all expenses',
          value: reportDisplayMoney(pl.netProfit),
          icon: Icons.show_chart_rounded,
          changePct: pl.netMarginPct,
          highlighted: true,
          emphasizeValue: true,
        ),
      ],
    );
  }
}

class _ProfitLossRow extends StatelessWidget {
  const _ProfitLossRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    this.changePct,
    this.highlighted = false,
    this.emphasizeValue = false,
  });

  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final String? changePct;
  final bool highlighted;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: highlighted
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.brandingPanel,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: highlighted ? AppColors.brandingPanel : Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasizeValue ? 20 : 16,
              fontWeight: FontWeight.w700,
              color: emphasizeValue
                  ? AppColors.brandingPanel
                  : AppColors.textPrimary,
            ),
          ),
          if (changePct != null) ...[
            const SizedBox(width: 8),
            ReportTrendPill(changePct: changePct!),
          ],
        ],
      ),
    );

    if (!highlighted) return content;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );
  }
}

class ReportTrendLabel extends StatelessWidget {
  const ReportTrendLabel({super.key, required this.changePct});

  final String changePct;

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(changePct) ?? 0;
    final isPositive = value >= 0;
    final arrow = isPositive ? '↑' : '↓';
    final color = isPositive ? AppColors.success : AppColors.error;
    final formatted = '${value.abs().toStringAsFixed(1)}%';

    return Row(
      children: [
        Text(
          '$arrow $formatted',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'vs yesterday',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
