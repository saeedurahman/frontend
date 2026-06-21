import 'package:frantend/features/reports/data/models/analytics_report_models.dart';

class SalesTabData {
  const SalesTabData({
    this.summary,
    this.todayVsYesterday,
    this.salesTrend = const [],
    this.paymentBreakdown = const [],
    this.cashierPerformance = const [],
    this.branchComparison = const [],
  });

  final SalesSummaryModel? summary;
  final TodayVsYesterdayModel? todayVsYesterday;
  final List<AnalyticsSalesTrendItemModel> salesTrend;
  final List<AnalyticsPaymentBreakdownModel> paymentBreakdown;
  final List<CashierPerformanceModel> cashierPerformance;
  final List<BranchComparisonModel> branchComparison;
}

class ProductsTabData {
  const ProductsTabData({
    this.topProducts = const [],
    this.categoryPerformance = const [],
    this.productMovement = const [],
    this.deadStock = const [],
    this.stockValuation = const [],
    this.inventoryInsights,
  });

  final List<AnalyticsTopProductModel> topProducts;
  final List<CategoryPerformanceModel> categoryPerformance;
  final List<ProductMovementModel> productMovement;
  final List<DeadStockModel> deadStock;
  final List<StockValuationModel> stockValuation;
  final InventoryInsightsReportModel? inventoryInsights;
}

class FinancialTabData {
  const FinancialTabData({
    this.customerInsights = const [],
    this.profitLoss,
    this.expenseSummary = const [],
    this.taxSummary,
  });

  final List<CustomerInsightModel> customerInsights;
  final ProfitLossModel? profitLoss;
  final List<ExpenseSummaryModel> expenseSummary;
  final TaxSummaryModel? taxSummary;
}

class TimeTabData {
  const TimeTabData({
    this.peakHours = const [],
    this.peakDays = const [],
  });

  final List<PeakHourModel> peakHours;
  final List<PeakDayModel> peakDays;
}

class SecurityTabData {
  const SecurityTabData({this.fraudAlerts = const []});

  final List<FraudAlertModel> fraudAlerts;
}

enum ReportsTab {
  sales,
  products,
  financial,
  time,
  security,
}
