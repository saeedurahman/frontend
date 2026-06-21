import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:frantend/features/reports/data/models/analytics_report_models.dart';
import 'package:frantend/features/reports/domain/repositories/reports_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl({
    required ReportsRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final ReportsRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  Future<Either<Failure, T>> _wrap<T>(Future<T> call) async {
    try {
      return Right(await call);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SalesSummaryModel>> getSalesSummary(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getSalesSummary(query));

  @override
  Future<Either<Failure, TodayVsYesterdayModel>> getTodayVsYesterday({
    String? branchId,
  }) =>
      _wrap(_remote.getTodayVsYesterday(branchId: branchId));

  @override
  Future<Either<Failure, List<AnalyticsSalesTrendItemModel>>> getSalesTrend(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getSalesTrend(query));

  @override
  Future<Either<Failure, List<AnalyticsPaymentBreakdownModel>>>
      getPaymentBreakdown(DateRangeQuery query) =>
          _wrap(_remote.getPaymentBreakdown(query));

  @override
  Future<Either<Failure, List<CashierPerformanceModel>>> getCashierPerformance(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getCashierPerformance(query));

  @override
  Future<Either<Failure, List<BranchComparisonModel>>> getBranchComparison(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getBranchComparison(query));

  @override
  Future<Either<Failure, List<AnalyticsTopProductModel>>> getTopProducts(
    DateRangeQuery query, {
    int limit = 20,
  }) =>
      _wrap(_remote.getTopProducts(query, limit: limit));

  @override
  Future<Either<Failure, List<CategoryPerformanceModel>>>
      getCategoryPerformance(DateRangeQuery query) =>
          _wrap(_remote.getCategoryPerformance(query));

  @override
  Future<Either<Failure, List<ProductMovementModel>>> getProductMovement(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getProductMovement(query));

  @override
  Future<Either<Failure, List<DeadStockModel>>> getDeadStock({
    String? branchId,
  }) =>
      _wrap(_remote.getDeadStock(branchId: branchId));

  @override
  Future<Either<Failure, List<StockValuationModel>>> getStockValuation({
    String? branchId,
  }) =>
      _wrap(_remote.getStockValuation(branchId: branchId));

  @override
  Future<Either<Failure, InventoryInsightsReportModel>> getInventoryInsights({
    String? branchId,
  }) =>
      _wrap(_remote.getInventoryInsights(branchId: branchId));

  @override
  Future<Either<Failure, List<CustomerInsightModel>>> getCustomerInsights() =>
      _wrap(_remote.getCustomerInsights());

  @override
  Future<Either<Failure, ProfitLossModel>> getProfitLoss(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getProfitLoss(query));

  @override
  Future<Either<Failure, List<ExpenseSummaryModel>>> getExpenseSummary(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getExpenseSummary(query));

  @override
  Future<Either<Failure, TaxSummaryModel>> getTaxSummary(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getTaxSummary(query));

  @override
  Future<Either<Failure, List<PeakHourModel>>> getPeakHours(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getPeakHours(query));

  @override
  Future<Either<Failure, List<PeakDayModel>>> getPeakDays(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getPeakDays(query));

  @override
  Future<Either<Failure, List<FraudAlertModel>>> getFraudAlerts(
    DateRangeQuery query,
  ) =>
      _wrap(_remote.getFraudAlerts(query));
}
