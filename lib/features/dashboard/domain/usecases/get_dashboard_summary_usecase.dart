import 'package:frantend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:frantend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardData> call({String? branchId, int trendDays = 7}) {
    return _repository.getDashboardData(branchId: branchId, trendDays: trendDays);
  }
}
