import 'package:frantend/features/dashboard/domain/entities/dashboard_data.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData({String? branchId, int trendDays = 7});
}
