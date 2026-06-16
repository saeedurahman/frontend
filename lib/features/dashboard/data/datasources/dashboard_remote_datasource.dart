import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:frantend/features/dashboard/data/models/sales_trend_model.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getSummary({String? branchId});

  Future<List<SalesTrendPointModel>> getSalesTrend({
    required DateTime dateFrom,
    required DateTime dateTo,
  });

  Future<List<PaymentBreakdownModel>> getPaymentBreakdown({
    required DateTime dateFrom,
    required DateTime dateTo,
  });

  Future<List<TopProductModel>> getTopProducts({
    required DateTime dateFrom,
    required DateTime dateTo,
    int limit = 5,
  });

  Future<List<RecentTransactionModel>> getRecentTransactions({int limit = 5});

  Future<InventoryInsightsModel> getInventoryInsights();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<DashboardSummaryModel> getSummary({String? branchId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsDashboard,
      queryParameters: branchId == null ? null : {'branch_id': branchId},
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return DashboardSummaryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<SalesTrendPointModel>> getSalesTrend({
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsSalesTrend,
      queryParameters: {
        'period': 'daily',
        'date_from': _asIsoDate(dateFrom),
        'date_to': _asIsoDate(dateTo),
      },
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return _toModelList<SalesTrendPointModel>(
      response.data,
      SalesTrendPointModel.fromJson,
    );
  }

  @override
  Future<List<PaymentBreakdownModel>> getPaymentBreakdown({
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsPaymentBreakdown,
      queryParameters: {
        'date_from': _asIsoDate(dateFrom),
        'date_to': _asIsoDate(dateTo),
      },
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return _toModelList<PaymentBreakdownModel>(
      response.data,
      PaymentBreakdownModel.fromJson,
    );
  }

  @override
  Future<List<TopProductModel>> getTopProducts({
    required DateTime dateFrom,
    required DateTime dateTo,
    int limit = 5,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsTopProducts,
      queryParameters: {
        'date_from': _asIsoDate(dateFrom),
        'date_to': _asIsoDate(dateTo),
        'limit': limit,
      },
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return _toModelList<TopProductModel>(
      response.data,
      TopProductModel.fromJson,
    );
  }

  @override
  Future<List<RecentTransactionModel>> getRecentTransactions({
    int limit = 5,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.analyticsRecentTransactions,
      queryParameters: {'limit': limit},
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return _toModelList<RecentTransactionModel>(
      response.data,
      RecentTransactionModel.fromJson,
    );
  }

  @override
  Future<InventoryInsightsModel> getInventoryInsights() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.analyticsInventoryInsights,
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return InventoryInsightsModel.fromJson(response.data ?? const {});
  }

  List<T> _toModelList<T>(
    dynamic payload,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (payload is List) {
      return payload
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    if (payload is Map<String, dynamic>) {
      final list = payload['items'];
      if (list is List) {
        return list
            .whereType<Map<dynamic, dynamic>>()
            .map((item) => fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    }
    return const [];
  }

  String _asIsoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
