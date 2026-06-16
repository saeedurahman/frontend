import 'package:frantend/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:frantend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:frantend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._remoteDataSource);

  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<DashboardData> getDashboardData({
    String? branchId,
    int trendDays = 7,
  }) async {
    final now = DateTime.now();
    final trendFrom = now.subtract(Duration(days: trendDays - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    final results = await Future.wait<dynamic>([
      _remoteDataSource.getSummary(branchId: branchId),
      _remoteDataSource.getSalesTrend(dateFrom: trendFrom, dateTo: now),
      _remoteDataSource.getPaymentBreakdown(dateFrom: trendFrom, dateTo: now),
      _remoteDataSource.getTopProducts(dateFrom: monthStart, dateTo: now),
      _remoteDataSource.getRecentTransactions(limit: 5),
      _remoteDataSource.getInventoryInsights(),
    ]);

    return DashboardData(
      summary: results[0],
      salesTrend: results[1],
      paymentBreakdown: results[2],
      topProducts: results[3],
      recentTransactions: results[4],
      inventoryInsights: results[5],
    );
  }
}
