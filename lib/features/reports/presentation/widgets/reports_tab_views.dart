import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';
import 'package:frantend/features/reports/presentation/widgets/report_widgets.dart';
import 'package:go_router/go_router.dart';

class ReportsSalesTab extends StatelessWidget {
  const ReportsSalesTab({super.key, required this.state});

  final ReportsLoaded state;

  @override
  Widget build(BuildContext context) {
    final data = state.salesTab;
    if (data == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (data.summary != null) _SalesSummarySection(summary: data.summary!),
          if (data.todayVsYesterday != null)
            _TodayVsYesterdaySection(data: data.todayVsYesterday!),
          ReportSectionCard(
            title: 'Sales Trend',
            child: _SalesTrendChart(points: data.salesTrend),
          ),
          ReportSectionCard(
            title: 'Payment Method Breakdown',
            child: _PaymentDonut(items: data.paymentBreakdown),
          ),
          ReportSectionCard(
            title: 'Cashier Performance',
            child: ReportDataTable(
              columns: const [
                'Cashier',
                'Transactions',
                'Revenue',
                'Avg Sale',
                'Returns',
              ],
              rows: data.cashierPerformance
                  .map(
                    (c) => [
                      c.userName,
                      '${c.totalSales}',
                      money(c.totalRevenue),
                      money(c.avgOrderValue),
                      '${c.totalReturns}',
                    ],
                  )
                  .toList(),
            ),
          ),
          if (data.branchComparison.length > 1)
            ReportSectionCard(
              title: 'Branch Comparison',
              child: _BranchBarChart(items: data.branchComparison),
            ),
          ModuleLinkCard(
            title: 'Detailed Sales Records',
            description:
                'View individual invoices, filters, and line-level detail in Sales.',
            routeLabel: 'View in Sales →',
            onTap: () => context.go(RouteNames.sales),
          ),
        ],
      ),
    );
  }
}

class ReportsProductsTab extends StatelessWidget {
  const ReportsProductsTab({super.key, required this.state});

  final ReportsLoaded state;

  @override
  Widget build(BuildContext context) {
    final data = state.productsTab;
    if (data == null) return const Center(child: CircularProgressIndicator());

    final stockTotal = data.stockValuation.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.totalValue) ?? 0),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          if (data.inventoryInsights != null)
            ReportSectionCard(
              title: 'Inventory Overview',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ReportKpiTile(
                    label: 'Total Products',
                    value: '${data.inventoryInsights!.totalProducts}',
                  ),
                  ReportKpiTile(
                    label: 'Stock Value',
                    value: money(data.inventoryInsights!.totalStockValue),
                  ),
                  ReportKpiTile(
                    label: 'Low Stock',
                    value: '${data.inventoryInsights!.lowStockCount}',
                  ),
                  ReportKpiTile(
                    label: 'Out of Stock',
                    value: '${data.inventoryInsights!.outOfStockCount}',
                  ),
                ],
              ),
            ),
          ReportSectionCard(
            title: 'Top Products',
            child: ReportDataTable(
              columns: const ['#', 'Product', 'Units', 'Revenue', 'Profit'],
              rows: data.topProducts
                  .map(
                    (p) => [
                      '${p.rank}',
                      p.variationName != null
                          ? '${p.productName} (${p.variationName})'
                          : p.productName,
                      p.totalQtySold,
                      money(p.totalRevenue),
                      money(p.grossProfit),
                    ],
                  )
                  .toList(),
            ),
          ),
          ReportSectionCard(
            title: 'Category Performance',
            child: ReportDataTable(
              columns: const ['Category', 'Revenue', 'Transactions', '% of Total'],
              rows: data.categoryPerformance
                  .map(
                    (c) => [
                      c.categoryName,
                      money(c.totalRevenue),
                      '${c.totalTransactions}',
                      pct(c.percentageOfTotal),
                    ],
                  )
                  .toList(),
            ),
          ),
          ReportSectionCard(
            title: 'Product Movement',
            child: ReportDataTable(
              columns: const ['Product', 'Category', 'Qty Sold', 'Revenue'],
              rows: data.productMovement
                  .map(
                    (p) => [
                      p.variationName != null
                          ? '${p.productName} (${p.variationName})'
                          : p.productName,
                      _movementBadgeLabel(p.movementCategory),
                      p.totalQtySold,
                      money(p.totalRevenue),
                    ],
                  )
                  .toList(),
            ),
          ),
          ReportSectionCard(
            title: 'Dead Stock',
            child: ReportDataTable(
              columns: const [
                'Product',
                'Branch',
                'Qty',
                'Days Idle',
                'Stock Value',
              ],
              rows: data.deadStock
                  .map(
                    (d) => [
                      d.productName,
                      d.branchName,
                      d.currentQty,
                      '${d.daysSinceLastSale}',
                      money(d.stockValue),
                    ],
                  )
                  .toList(),
            ),
          ),
          ReportSectionCard(
            title: 'Stock Valuation',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total inventory value: ${formatPKR(stockTotal)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                ReportDataTable(
                  columns: const ['Product', 'Branch', 'Qty', 'Avg Cost', 'Value'],
                  rows: data.stockValuation
                      .take(20)
                      .map(
                        (s) => [
                          s.productName,
                          s.branchName,
                          s.currentQty,
                          money(s.avgCost),
                          money(s.totalValue),
                        ],
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          ModuleLinkCard(
            title: 'Per-Product Stock Levels',
            description:
                'Operational stock balances and adjustments live in Inventory.',
            routeLabel: 'View in Inventory →',
            onTap: () => context.go(RouteNames.inventory),
          ),
        ],
      ),
    );
  }
}

class ReportsFinancialTab extends StatelessWidget {
  const ReportsFinancialTab({super.key, required this.state});

  final ReportsLoaded state;

  @override
  Widget build(BuildContext context) {
    final data = state.financialTab;
    if (data == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      child: Column(
        children: [
          if (data.profitLoss != null)
            ReportSectionCard(
              title: 'Profit & Loss Statement',
              child: _ProfitLossStatement(pl: data.profitLoss!),
            ),
          ReportSectionCard(
            title: 'Top Customers',
            child: ReportDataTable(
              columns: const [
                'Customer',
                'Purchases',
                'Total Spent',
                'Outstanding',
                'Avg Order',
              ],
              rows: data.customerInsights
                  .take(15)
                  .map(
                    (c) => [
                      c.customerName,
                      '${c.totalPurchases}',
                      money(c.totalSpent),
                      money(c.outstandingBalance),
                      money(c.avgOrderValue),
                    ],
                  )
                  .toList(),
            ),
          ),
          ReportSectionCard(
            title: 'Expense Summary',
            child: ReportDataTable(
              columns: const ['Category', 'Amount', 'Count', '% of Total'],
              rows: data.expenseSummary
                  .map(
                    (e) => [
                      e.categoryName,
                      money(e.totalAmount),
                      '${e.transactionCount}',
                      pct(e.percentageOfTotal),
                    ],
                  )
                  .toList(),
            ),
          ),
          if (data.taxSummary != null)
            ReportSectionCard(
              title: 'Tax Summary',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReportKpiTile(
                    label: 'Tax Collected (Sales)',
                    value: money(data.taxSummary!.totalTaxCollected),
                  ),
                  const SizedBox(height: 8),
                  ReportKpiTile(
                    label: 'Tax Paid (Purchases)',
                    value: money(data.taxSummary!.totalTaxPaid),
                  ),
                  const SizedBox(height: 12),
                  ReportDataTable(
                    columns: const ['Rate %', 'Taxable Sales', 'Tax Amount', 'Count'],
                    rows: data.taxSummary!.taxByRate
                        .map(
                          (t) => [
                            pct(t.taxRate),
                            money(t.totalSalesAmount),
                            money(t.totalTaxAmount),
                            '${t.transactionCount}',
                          ],
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ModuleLinkCard(
            title: 'Cash in Drawer',
            description:
                'Live shift float, expected cash, and close-shift workflow are in Cash Register.',
            routeLabel: 'View in Cash Register →',
            onTap: () => context.go(RouteNames.cashRegister),
          ),
          ModuleLinkCard(
            title: 'Customer Balances',
            description: 'Ledger entries and payments are managed in Customers.',
            routeLabel: 'View in Customers →',
            onTap: () => context.go(RouteNames.customers),
          ),
        ],
      ),
    );
  }
}

class ReportsTimeTab extends StatelessWidget {
  const ReportsTimeTab({super.key, required this.state});

  final ReportsLoaded state;

  @override
  Widget build(BuildContext context) {
    final data = state.timeTab;
    if (data == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      child: Column(
        children: [
          ReportSectionCard(
            title: 'Peak Hours',
            child: SizedBox(
              height: 260,
              child: _BarChartSimple(
                labels: data.peakHours.map((e) => e.hourLabel).toList(),
                values: data.peakHours
                    .map((e) => double.tryParse(e.totalRevenue) ?? 0)
                    .toList(),
              ),
            ),
          ),
          ReportSectionCard(
            title: 'Peak Days',
            child: SizedBox(
              height: 260,
              child: _BarChartSimple(
                labels: data.peakDays.map((e) => e.dayName).toList(),
                values: data.peakDays
                    .map((e) => double.tryParse(e.totalRevenue) ?? 0)
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportsSecurityTab extends StatelessWidget {
  const ReportsSecurityTab({super.key, required this.state});

  final ReportsLoaded state;

  @override
  Widget build(BuildContext context) {
    final data = state.securityTab;
    if (data == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      child: ReportSectionCard(
        title: 'Fraud Alerts',
        child: data.fraudAlerts.isEmpty
            ? const Text('No fraud alerts for the selected period.')
            : ReportDataTable(
                columns: const [
                  'Severity',
                  'Type',
                  'User',
                  'Count',
                  'Amount',
                  'Description',
                ],
                rows: data.fraudAlerts
                    .map(
                      (a) => [
                        a.severity.toUpperCase(),
                        a.alertType,
                        a.userName,
                        '${a.count}',
                        money(a.totalAmount),
                        a.description,
                      ],
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _SalesSummarySection extends StatelessWidget {
  const _SalesSummarySection({required this.summary});
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: 'Sales Summary',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ReportKpiTile(label: 'Net Revenue', value: money(summary.netRevenue)),
          ReportKpiTile(
            label: 'Transactions',
            value: '${summary.totalTransactions}',
          ),
          ReportKpiTile(
            label: 'Avg Order Value',
            value: money(summary.avgOrderValue),
          ),
          ReportKpiTile(
            label: 'Tax Collected',
            value: money(summary.totalTax),
          ),
        ],
      ),
    );
  }
}

class _TodayVsYesterdaySection extends StatelessWidget {
  const _TodayVsYesterdaySection({required this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: 'Today vs Yesterday',
      child: Row(
        children: [
          Expanded(
            child: ReportKpiTile(
              label: 'Today Revenue',
              value: money(data.todayRevenue),
              subtitle: '${pct(data.revenueChangePct)} vs yesterday',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportKpiTile(
              label: 'Yesterday Revenue',
              value: money(data.yesterdayRevenue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportKpiTile(
              label: 'Today Profit',
              value: money(data.todayProfit),
              subtitle: '${pct(data.profitChangePct)} vs yesterday',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfitLossStatement extends StatelessWidget {
  const _ProfitLossStatement({required this.pl});
  final dynamic pl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _plRow('Revenue', money(pl.totalRevenue), bold: true),
        _plRow('Cost of Goods Sold', money(pl.totalCogs)),
        const Divider(),
        _plRow('Gross Profit', money(pl.grossProfit), bold: true),
        _plRow('Gross Margin', pct(pl.grossMarginPct)),
        const Divider(),
        _plRow('Operating Expenses', money(pl.totalExpenses)),
        if (pl.expenseBreakdown.isNotEmpty)
          ...pl.expenseBreakdown.map<Widget>(
            (e) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _plRow('  ${e.categoryName}', money(e.totalAmount)),
            ),
          ),
        const Divider(thickness: 2),
        _plRow('Net Profit', money(pl.netProfit), bold: true, large: true),
        _plRow('Net Margin', pct(pl.netMarginPct)),
      ],
    );
  }

  Widget _plRow(String label, String value, {bool bold = false, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
                fontSize: large ? 16 : 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              fontSize: large ? 20 : 14,
              color: large ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesTrendChart extends StatelessWidget {
  const _SalesTrendChart({required this.points});
  final List<dynamic> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No trend data')));
    }
    final maxY = points
            .map((e) => double.tryParse(e.revenue) ?? 0)
            .fold<double>(0, (a, b) => b > a ? b : a) *
        1.2;

    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY <= 0 ? 10 : maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFE5E7EB)),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: points.length > 10 ? 2 : 1,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= points.length) return const SizedBox.shrink();
                  return Text(points[i].period, style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, _) => Text(
                  formatCompact(value),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points
                  .asMap()
                  .entries
                  .map(
                    (e) => FlSpot(
                      e.key.toDouble(),
                      double.tryParse(e.value.revenue) ?? 0,
                    ),
                  )
                  .toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentDonut extends StatelessWidget {
  const _PaymentDonut({required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No payment data')));
    }
    final total = items.fold<double>(
      0,
      (sum, e) => sum + (double.tryParse(e.totalAmount) ?? 0),
    );
    final colors = [AppColors.primary, const Color(0xFF3B82F6), AppColors.accent, AppColors.error];

    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 48,
                sections: items.asMap().entries.map((entry) {
                  final amount = double.tryParse(entry.value.totalAmount) ?? 0;
                  final ratio = total == 0 ? 0.0 : amount / total;
                  return PieChartSectionData(
                    color: colors[entry.key % colors.length],
                    value: ratio * 100,
                    radius: 36,
                    title: '',
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (e) => Text(
                      '${e.paymentMethod}: ${money(e.totalAmount)} (${pct(e.percentage)})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchBarChart extends StatelessWidget {
  const _BranchBarChart({required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: _BarChartSimple(
        labels: items.map((e) => e.branchName as String).toList(),
        values: items
            .map((e) => double.tryParse(e.totalRevenue) ?? 0)
            .toList(),
      ),
    );
  }
}

class _BarChartSimple extends StatelessWidget {
  const _BarChartSimple({required this.labels, required this.values});

  final List<String> labels;
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(child: Text('No data'));
    }
    final maxY = values.fold<double>(0, (a, b) => b > a ? b : a) * 1.2;

    return BarChart(
      BarChartData(
        maxY: maxY <= 0 ? 10 : maxY,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i], style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) =>
                  Text(formatCompact(value), style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
        barGroups: values
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value,
                    color: AppColors.primary,
                    width: 16,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

String _movementBadgeLabel(String category) {
  return switch (category.toLowerCase()) {
    'fast' => 'Fast',
    'slow' => 'Slow',
    'dead' => 'Dead',
    _ => category,
  };
}

String formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
