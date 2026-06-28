import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';
import 'package:frantend/features/reports/presentation/widgets/report_summary_cards.dart';
import 'package:frantend/features/reports/presentation/widgets/reports_data_tables.dart';
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
          if (data.summary != null)
            SalesSummarySection(
              summary: data.summary!,
              comparison: data.todayVsYesterday,
            ),
          if (data.todayVsYesterday != null)
            TodayVsYesterdaySection(data: data.todayVsYesterday!),
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
            child: CashierPerformanceTable(items: data.cashierPerformance),
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
            InventoryOverviewSection(insights: data.inventoryInsights!),
          ReportSectionCard(
            title: 'Top Products',
            child: TopProductsTable(items: data.topProducts),
          ),
          ReportSectionCard(
            title: 'Category Performance',
            child: CategoryPerformanceTable(items: data.categoryPerformance),
          ),
          ReportSectionCard(
            title: 'Product Movement',
            child: ProductMovementTable(items: data.productMovement),
          ),
          ReportSectionCard(
            title: 'Dead Stock',
            child: DeadStockTable(items: data.deadStock),
          ),
          StockValuationSection(
            items: data.stockValuation,
            stockTotal: stockTotal,
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
              child: ProfitLossStatementSection(pl: data.profitLoss!),
            ),
          ReportSectionCard(
            title: 'Top Customers',
            child: TopCustomersTable(items: data.customerInsights),
          ),
          ReportSectionCard(
            title: 'Expense Summary',
            child: ExpenseSummaryTable(items: data.expenseSummary),
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
                  TaxByRateTable(items: data.taxSummary!.taxByRate),
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
            : FraudAlertsTable(items: data.fraudAlerts),
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

String formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
