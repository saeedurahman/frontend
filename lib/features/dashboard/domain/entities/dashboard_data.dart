import 'package:frantend/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:frantend/features/dashboard/data/models/sales_trend_model.dart';

class DashboardData {
  const DashboardData({
    required this.summary,
    required this.salesTrend,
    required this.paymentBreakdown,
    required this.topProducts,
    required this.recentTransactions,
    required this.inventoryInsights,
  });

  final DashboardSummaryModel summary;
  final List<SalesTrendPointModel> salesTrend;
  final List<PaymentBreakdownModel> paymentBreakdown;
  final List<TopProductModel> topProducts;
  final List<RecentTransactionModel> recentTransactions;
  final InventoryInsightsModel inventoryInsights;
}
