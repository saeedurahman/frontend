import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:frantend/features/dashboard/data/models/sales_trend_model.dart';
import 'package:frantend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final branchId = sl<BranchSelectorCubit>().state.selectedBranchId;
    return BlocListener<BranchSelectorCubit, BranchSelectorState>(
      bloc: sl<BranchSelectorCubit>(),
      listenWhen: (previous, current) =>
          previous.selectedBranchId != current.selectedBranchId &&
          current.isInitialized,
      listener: (context, branchState) {
        context.read<DashboardCubit>().loadDashboard(
              branchId: branchState.selectedBranchId,
            );
      },
      child: BlocProvider(
        create: (_) => sl<DashboardCubit>()
          ..loadDashboard(branchId: branchId),
        child: const _DashboardView(),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const _DashboardLoading();
        }
        if (state is DashboardError) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load dashboard',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<DashboardCubit>().loadDashboard(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final loaded = state as DashboardLoaded;
        final data = loaded.data;
        final summary = data.summary;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _KpiSection(summary: summary),
              const SizedBox(height: 28),
              _ChartsSection(
                salesTrend: data.salesTrend,
                paymentBreakdown: data.paymentBreakdown,
                trendDays: loaded.trendDays,
              ),
              const SizedBox(height: 28),
              _ThreeColumnSection(data: data),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF3F4F6),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                7,
                (_) => Container(
                  width: 180,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index == 2 ? 0 : 12),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiSection extends StatelessWidget {
  const _KpiSection({required this.summary});

  final DashboardSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final margin = summary.todayRevenue == 0
        ? 0
        : (summary.todayProfit / summary.todayRevenue) * 100;

    return Wrap(
      spacing: 26,
      runSpacing: 26,
      children: [
        _StatCard(
          title: 'Today Revenue',
          icon: Icons.payments,
          value: formatPKR(summary.todayRevenue),
          subtitle:
              '${summary.revenueVsYesterdayPct.toStringAsFixed(1)}% vs yesterday',
          subtitleColor: summary.revenueVsYesterdayPct >= 0
              ? AppColors.success
              : AppColors.error,
          borderColor: AppColors.primary,
        ),
        _StatCard(
          title: 'Today Profit',
          icon: Icons.trending_up,
          value: formatPKR(summary.todayProfit),
          subtitle: 'Margin: ${margin.toStringAsFixed(1)}%',
          borderColor: const Color(0xFF10B981),
        ),
        _StatCard(
          title: 'Transactions',
          icon: Icons.receipt,
          value: '${summary.todayTransactions}',
          subtitle: 'Avg: ${formatPKR(summary.todayAvgOrder)}',
          borderColor: const Color(0xFF3B82F6),
        ),
        _StatCard(
          title: 'Today Expenses',
          icon: Icons.money_off,
          value: formatPKR(summary.todayExpenses),
          subtitle: 'Today',
          borderColor: const Color(0xFFF59E0B),
        ),
        _StatCard(
          title: 'Receivables',
          icon: Icons.people,
          value: formatPKR(summary.pendingCustomerReceivables),
          subtitle: 'Customer dues',
          borderColor: const Color(0xFF8B5CF6),
        ),
        _StatCard(
          title: 'Payables',
          icon: Icons.local_shipping,
          value: formatPKR(summary.pendingSupplierPayables),
          subtitle: 'Supplier dues',
          borderColor: const Color(0xFFEF4444),
        ),
        _StatCard(
          title: 'Cash in Drawer',
          icon: Icons.account_balance_wallet,
          value: formatPKR(summary.cashInDrawer),
          subtitle: summary.openShifts > 0 ? 'Shift open' : 'No active shift',
          borderColor: const Color(0xFF0EA5E9),
        ),
      ],
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({
    required this.salesTrend,
    required this.paymentBreakdown,
    required this.trendDays,
  });

  final List<SalesTrendPointModel> salesTrend;
  final List<PaymentBreakdownModel> paymentBreakdown;
  final int trendDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _SalesTrendCard(
            salesTrend: salesTrend,
            selectedDays: trendDays,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _PaymentMethodsCard(paymentBreakdown: paymentBreakdown),
        ),
      ],
    );
  }
}

class _SalesTrendCard extends StatelessWidget {
  const _SalesTrendCard({
    required this.salesTrend,
    required this.selectedDays,
  });

  final List<SalesTrendPointModel> salesTrend;
  final int selectedDays;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    final maxY = salesTrend
            .map((e) => e.revenue > e.profit ? e.revenue : e.profit)
            .fold<double>(0, (acc, e) => e > acc ? e : acc) *
        1.2;

    return _CardContainer(
      title: 'Sales Trend', 
      trailing: Wrap(
        spacing: 8,
        children: [
          _RangeButton(
            label: 'Today',
            selected: selectedDays == 1,
            onTap: () => cubit.loadDashboard(trendDays: 1),
          ),
          _RangeButton(
            label: '7 Days',
            selected: selectedDays == 7,
            onTap: () => cubit.loadDashboard(trendDays: 7),
          ),
          _RangeButton(
            label: '30 Days',
            selected: selectedDays == 30,
            onTap: () => cubit.loadDashboard(trendDays: 30),
          ),
        ],
      ),
      child: SizedBox(
        height: 260,
        child: salesTrend.isEmpty
            ? const Center(child: Text('No trend data'))
            : LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY <= 0 ? 10 : maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: Color(0xFFE5E7EB),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, _) => Text(
                          formatCompact(value),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: salesTrend.length > 8 ? 2 : 1,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < 0 || index >= salesTrend.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              salesTrend[index].label,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) {
                        return spots
                            .map(
                              (spot) => LineTooltipItem(
                                'Rs. ${formatCompact(spot.y)}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                            .toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: salesTrend
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.revenue))
                          .toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: salesTrend
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.profit))
                          .toList(),
                      isCurved: true,
                      color: AppColors.accent,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  const _PaymentMethodsCard({required this.paymentBreakdown});

  final List<PaymentBreakdownModel> paymentBreakdown;

  @override
  Widget build(BuildContext context) {
    final total = paymentBreakdown.fold<double>(0, (acc, e) => acc + e.amount);
    final colors = <String, Color>{
      'cash': AppColors.primary,
      'card': const Color(0xFF3B82F6),
      'easypaisa': const Color(0xFFF59E0B),
      'credit': const Color(0xFFEF4444),
    };

    return _CardContainer(
      title: 'Payment Methods',
      child: SizedBox(
        height: 260,
        child: paymentBreakdown.isEmpty
            ? const Center(child: Text('No payment data'))
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            centerSpaceRadius: 56,
                            sectionsSpace: 2,
                            sections: paymentBreakdown.map((item) {
                              final ratio = total == 0 ? 0 : (item.amount / total);
                              return PieChartSectionData(
                                color: colors[item.method.toLowerCase()] ??
                                    const Color(0xFF64748B),
                                value: ratio * 100,
                                title: '',
                                radius: 38,
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          'Total\n${formatPKR(total)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: paymentBreakdown.map((item) {
                      final color = colors[item.method.toLowerCase()] ??
                          const Color(0xFF64748B);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.method} (${formatPKR(item.amount)})',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ThreeColumnSection extends StatelessWidget {
  const _ThreeColumnSection({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TopProductsCard(
            products: data.topProducts,
            summary: data.summary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _RecentSalesCard(transactions: data.recentTransactions)),
        const SizedBox(width: 12),
        Expanded(
          child: _AlertsCard(
            summary: data.summary,
            inventoryInsights: data.inventoryInsights,
          ),
        ),
      ],
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  const _TopProductsCard({
    required this.products,
    required this.summary,
  });

  final List<TopProductModel> products;
  final DashboardSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final maxUnits = products.fold<int>(1, (acc, e) => e.unitsSold > acc ? e.unitsSold : acc);

    return _CardContainer(
      title: 'Top Products',
      trailing: const Text('View All →', style: TextStyle(color: AppColors.primary)),
      onTrailingTap: () => context.go(RouteNames.analytics),
      child: SizedBox(
        height: 300,
        child: products.isEmpty
            ? const Center(child: Text('No products data'))
            : ListView.separated(
                itemCount: products.length > 5 ? 5 : products.length,
                separatorBuilder: (_, __) => const Divider(height: 14),
                itemBuilder: (context, index) {
                  final item = products[index];
                  final rankColor = switch (index) {
                    0 => const Color(0xFFF59E0B),
                    1 => const Color(0xFF94A3B8),
                    2 => const Color(0xFFB45309),
                    _ => const Color(0xFFCBD5E1),
                  };
                  final progress = item.unitsSold / maxUnits;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: rankColor,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('${item.unitsSold} units', style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          Text(
                            formatPKR(item.revenue),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        backgroundColor: const Color(0xFFE2E8F0),
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                        minHeight: 6,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _RecentSalesCard extends StatelessWidget {
  const _RecentSalesCard({required this.transactions});

  final List<RecentTransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      title: 'Recent Sales',
      trailing: const Text('View All →', style: TextStyle(color: AppColors.primary)),
      onTrailingTap: () => context.go(RouteNames.sales),
      child: SizedBox(
        height: 300,
        child: transactions.isEmpty
            ? const Center(child: Text('No transactions'))
            : ListView.separated(
                itemCount: transactions.length > 5 ? 5 : transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 14),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.invoiceNo,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              tx.customerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _timeAgo(tx.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            formatPKR(tx.totalAmount),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(status: tx.status),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard({
    required this.summary,
    required this.inventoryInsights,
  });

  final DashboardSummaryModel summary;
  final InventoryInsightsModel inventoryInsights;

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      title: 'Alerts',
      child: SizedBox(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AlertRow(
              icon: Icons.warning_amber_rounded,
              color: const Color(0xFFF59E0B),
              text: '${inventoryInsights.lowStockCount} items low stock',
              count: inventoryInsights.lowStockCount,
            ),
            const SizedBox(height: 10),
            _AlertRow(
              icon: Icons.error_outline,
              color: const Color(0xFFEF4444),
              text: '${inventoryInsights.outOfStockCount} items out of stock',
              count: inventoryInsights.outOfStockCount,
            ),
            const SizedBox(height: 10),
            _AlertRow(
              icon: Icons.storefront,
              color: AppColors.primary,
              text: summary.openShifts > 0 ? 'Shift open' : 'Shift closed',
              count: summary.openShifts,
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Low Stock Alerts: ${summary.lowStockAlerts}\n'
                'Out of Stock: ${summary.outOfStockCount}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.borderColor,
    required this.icon,
    this.subtitleColor = AppColors.textSecondary,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color borderColor;
  final Color subtitleColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(width: 4, color: borderColor)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: borderColor, size: 32),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: subtitleColor),
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  const _CardContainer({
    required this.title,
    required this.child,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null)
                GestureDetector(
                  onTap: onTrailingTap,
                  behavior: HitTestBehavior.opaque,
                  child: trailing!,
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final isPartial = normalized == 'partially_paid';
    final color = isPartial ? const Color(0xFFF59E0B) : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        normalized.replaceAll('_', ' '),
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({
    required this.icon,
    required this.color,
    required this.text,
    required this.count,
  });

  final IconData icon;
  final Color color;
  final String text;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 16),
          ),
        ),
      ],
    );
  }
}

String _timeAgo(DateTime? date) {
  if (date == null) return '-';
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
