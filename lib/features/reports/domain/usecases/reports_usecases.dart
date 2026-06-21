import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:frantend/features/reports/data/models/analytics_report_models.dart';
import 'package:frantend/features/reports/domain/repositories/reports_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReportsUseCases {
  ReportsUseCases(this._repository);

  final ReportsRepository _repository;

  Future<Either<Failure, SalesSummaryModel>> salesSummary(DateRangeQuery q) =>
      _repository.getSalesSummary(q);

  Future<Either<Failure, TodayVsYesterdayModel>> todayVsYesterday({
    String? branchId,
  }) =>
      _repository.getTodayVsYesterday(branchId: branchId);

  Future<Either<Failure, List<AnalyticsSalesTrendItemModel>>> salesTrend(
    DateRangeQuery q,
  ) =>
      _repository.getSalesTrend(q);

  Future<Either<Failure, List<AnalyticsPaymentBreakdownModel>>>
      paymentBreakdown(DateRangeQuery q) =>
          _repository.getPaymentBreakdown(q);

  Future<Either<Failure, List<CashierPerformanceModel>>> cashierPerformance(
    DateRangeQuery q,
  ) =>
      _repository.getCashierPerformance(q);

  Future<Either<Failure, List<BranchComparisonModel>>> branchComparison(
    DateRangeQuery q,
  ) =>
      _repository.getBranchComparison(q);

  Future<Either<Failure, List<AnalyticsTopProductModel>>> topProducts(
    DateRangeQuery q, {
    int limit = 20,
  }) =>
      _repository.getTopProducts(q, limit: limit);

  Future<Either<Failure, List<CategoryPerformanceModel>>> categoryPerformance(
    DateRangeQuery q,
  ) =>
      _repository.getCategoryPerformance(q);

  Future<Either<Failure, List<ProductMovementModel>>> productMovement(
    DateRangeQuery q,
  ) =>
      _repository.getProductMovement(q);

  Future<Either<Failure, List<DeadStockModel>>> deadStock({
    String? branchId,
  }) =>
      _repository.getDeadStock(branchId: branchId);

  Future<Either<Failure, List<StockValuationModel>>> stockValuation({
    String? branchId,
  }) =>
      _repository.getStockValuation(branchId: branchId);

  Future<Either<Failure, InventoryInsightsReportModel>> inventoryInsights({
    String? branchId,
  }) =>
      _repository.getInventoryInsights(branchId: branchId);

  Future<Either<Failure, List<CustomerInsightModel>>> customerInsights() =>
      _repository.getCustomerInsights();

  Future<Either<Failure, ProfitLossModel>> profitLoss(DateRangeQuery q) =>
      _repository.getProfitLoss(q);

  Future<Either<Failure, List<ExpenseSummaryModel>>> expenseSummary(
    DateRangeQuery q,
  ) =>
      _repository.getExpenseSummary(q);

  Future<Either<Failure, TaxSummaryModel>> taxSummary(DateRangeQuery q) =>
      _repository.getTaxSummary(q);

  Future<Either<Failure, List<PeakHourModel>>> peakHours(DateRangeQuery q) =>
      _repository.getPeakHours(q);

  Future<Either<Failure, List<PeakDayModel>>> peakDays(DateRangeQuery q) =>
      _repository.getPeakDays(q);

  Future<Either<Failure, List<FraudAlertModel>>> fraudAlerts(
    DateRangeQuery q,
  ) =>
      _repository.getFraudAlerts(q);
}
