import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboardSummaryUseCase)
      : super(const DashboardInitial());

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;

  Future<void> loadDashboard({String? branchId, int trendDays = 7}) async {
    emit(const DashboardLoading());
    try {
      final data = await _getDashboardSummaryUseCase(
        branchId: branchId,
        trendDays: trendDays,
      );
      emit(DashboardLoaded(data, trendDays: trendDays));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
