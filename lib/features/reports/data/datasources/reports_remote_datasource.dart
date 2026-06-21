import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/reports/data/models/analytics_report_models.dart';
import 'package:injectable/injectable.dart';

typedef DateRangeQuery = ({
  DateTime dateFrom,
  DateTime dateTo,
  String? branchId,
});

@lazySingleton
class ReportsRemoteDataSource {
  ReportsRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  Future<SalesSummaryModel> getSalesSummary(DateRangeQuery q) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsSalesSummary,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return SalesSummaryModel.fromJson(response.data ?? const {});
  }

  Future<TodayVsYesterdayModel> getTodayVsYesterday({String? branchId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsTodayVsYesterday,
      queryParameters: _branchOnly(branchId),
      options: _opts,
    );
    return TodayVsYesterdayModel.fromJson(response.data ?? const {});
  }

  Future<List<AnalyticsSalesTrendItemModel>> getSalesTrend(
    DateRangeQuery q, {
    String period = 'daily',
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsSalesTrend,
      queryParameters: {
        ..._dateParams(q),
        'period': period,
      },
      options: _opts,
    );
    return _list(response.data, AnalyticsSalesTrendItemModel.fromJson);
  }

  Future<List<AnalyticsPaymentBreakdownModel>> getPaymentBreakdown(
    DateRangeQuery q,
  ) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsPaymentBreakdown,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, AnalyticsPaymentBreakdownModel.fromJson);
  }

  Future<List<CashierPerformanceModel>> getCashierPerformance(
    DateRangeQuery q,
  ) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsCashierPerformance,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, CashierPerformanceModel.fromJson);
  }

  Future<List<BranchComparisonModel>> getBranchComparison(
    DateRangeQuery q,
  ) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsBranchComparison,
      queryParameters: {
        'date_from': _isoDate(q.dateFrom),
        'date_to': _isoDate(q.dateTo),
      },
      options: _opts,
    );
    return _list(response.data, BranchComparisonModel.fromJson);
  }

  Future<List<AnalyticsTopProductModel>> getTopProducts(
    DateRangeQuery q, {
    int limit = 20,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsTopProducts,
      queryParameters: {
        ..._dateParams(q),
        'limit': limit,
      },
      options: _opts,
    );
    return _list(response.data, AnalyticsTopProductModel.fromJson);
  }

  Future<List<CategoryPerformanceModel>> getCategoryPerformance(
    DateRangeQuery q,
  ) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsCategoryPerformance,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, CategoryPerformanceModel.fromJson);
  }

  Future<List<ProductMovementModel>> getProductMovement(
    DateRangeQuery q, {
    int deadStockDays = 30,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsProductMovement,
      queryParameters: {
        ..._dateParams(q),
        'dead_stock_days': deadStockDays,
      },
      options: _opts,
    );
    return _list(response.data, ProductMovementModel.fromJson);
  }

  Future<List<DeadStockModel>> getDeadStock({
    String? branchId,
    int deadStockDays = 30,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsDeadStock,
      queryParameters: {
        'dead_stock_days': deadStockDays,
        if (branchId != null) 'branch_id': branchId,
      },
      options: _opts,
    );
    return _list(response.data, DeadStockModel.fromJson);
  }

  Future<List<StockValuationModel>> getStockValuation({String? branchId}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsStockValuation,
      queryParameters: _branchOnly(branchId),
      options: _opts,
    );
    return _list(response.data, StockValuationModel.fromJson);
  }

  Future<InventoryInsightsReportModel> getInventoryInsights({
    String? branchId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsInventoryInsights,
      queryParameters: _branchOnly(branchId),
      options: _opts,
    );
    return InventoryInsightsReportModel.fromJson(response.data ?? const {});
  }

  Future<List<CustomerInsightModel>> getCustomerInsights({
    int limit = 50,
    String sortBy = 'total_spent',
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsCustomerInsights,
      queryParameters: {'limit': limit, 'sort_by': sortBy},
      options: _opts,
    );
    return _list(response.data, CustomerInsightModel.fromJson);
  }

  Future<ProfitLossModel> getProfitLoss(DateRangeQuery q) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsProfitLoss,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return ProfitLossModel.fromJson(response.data ?? const {});
  }

  Future<List<ExpenseSummaryModel>> getExpenseSummary(DateRangeQuery q) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsExpenseSummary,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, ExpenseSummaryModel.fromJson);
  }

  Future<TaxSummaryModel> getTaxSummary(DateRangeQuery q) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsTaxSummary,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return TaxSummaryModel.fromJson(response.data ?? const {});
  }

  Future<List<PeakHourModel>> getPeakHours(DateRangeQuery q) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsPeakHours,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, PeakHourModel.fromJson);
  }

  Future<List<PeakDayModel>> getPeakDays(DateRangeQuery q) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsPeakDays,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, PeakDayModel.fromJson);
  }

  Future<List<FraudAlertModel>> getFraudAlerts(DateRangeQuery q) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsFraudAlerts,
      queryParameters: _dateParams(q),
      options: _opts,
    );
    return _list(response.data, FraudAlertModel.fromJson);
  }

  static final _opts = Options(extra: {'skip_offline_queue': true});

  Map<String, String> _dateParams(DateRangeQuery q) => {
        'date_from': _isoDate(q.dateFrom),
        'date_to': _isoDate(q.dateTo),
        if (q.branchId != null) 'branch_id': q.branchId!,
      };

  Map<String, String>? _branchOnly(String? branchId) =>
      branchId == null ? null : {'branch_id': branchId};

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
