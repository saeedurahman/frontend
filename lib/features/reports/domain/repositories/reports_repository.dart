import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/reports/data/models/analytics_report_models.dart';
import 'package:frantend/features/reports/data/datasources/reports_remote_datasource.dart';

abstract class ReportsRepository {
  Future<Either<Failure, SalesSummaryModel>> getSalesSummary(
    DateRangeQuery query,
  );

  Future<Either<Failure, TodayVsYesterdayModel>> getTodayVsYesterday({
    String? branchId,
  });

  Future<Either<Failure, List<AnalyticsSalesTrendItemModel>>> getSalesTrend(
    DateRangeQuery query,
  );

  Future<Either<Failure, List<AnalyticsPaymentBreakdownModel>>>
      getPaymentBreakdown(DateRangeQuery query);

  Future<Either<Failure, List<CashierPerformanceModel>>> getCashierPerformance(
    DateRangeQuery query,
  );

  Future<Either<Failure, List<BranchComparisonModel>>> getBranchComparison(
    DateRangeQuery query,
  );

  Future<Either<Failure, List<AnalyticsTopProductModel>>> getTopProducts(
    DateRangeQuery query, {
    int limit,
  });

  Future<Either<Failure, List<CategoryPerformanceModel>>> getCategoryPerformance(
    DateRangeQuery query,
  );

  Future<Either<Failure, List<ProductMovementModel>>> getProductMovement(
    DateRangeQuery query,
  );

  Future<Either<Failure, List<DeadStockModel>>> getDeadStock({
    String? branchId,
  });

  Future<Either<Failure, List<StockValuationModel>>> getStockValuation({
    String? branchId,
  });

  Future<Either<Failure, InventoryInsightsReportModel>> getInventoryInsights({
    String? branchId,
  });

  Future<Either<Failure, List<CustomerInsightModel>>> getCustomerInsights();

  Future<Either<Failure, ProfitLossModel>> getProfitLoss(DateRangeQuery query);

  Future<Either<Failure, List<ExpenseSummaryModel>>> getExpenseSummary(
    DateRangeQuery query,
  );

  Future<Either<Failure, TaxSummaryModel>> getTaxSummary(DateRangeQuery query);

  Future<Either<Failure, List<PeakHourModel>>> getPeakHours(
    DateRangeQuery query,
  );

  Future<Either<Failure, List<PeakDayModel>>> getPeakDays(DateRangeQuery query);

  Future<Either<Failure, List<FraudAlertModel>>> getFraudAlerts(
    DateRangeQuery query,
  );
}
