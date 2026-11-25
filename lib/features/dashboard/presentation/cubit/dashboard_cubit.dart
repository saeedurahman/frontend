import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboardSummaryUseCase, this._khataEvents)
      : super(const DashboardInitial()) {
    // A payment or reversal changes receivable/payable: refresh quietly.
    _sub = _khataEvents.changes.listen((_) {
      if (state is DashboardLoaded) {
        loadDashboard(
          keepBranch: true,
          trendDays: (state as DashboardLoaded).trendDays,
        );
      }
    });
  }

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  final KhataEvents _khataEvents;
  StreamSubscription<void>? _sub;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  // The branch picked in the top bar. Remembered so "Retry" and the trend
  // buttons reload the same branch instead of silently showing all branches.
  String? _branchId;

  String? get branchId => _branchId;

  Future<void> loadDashboard({
    String? branchId,
    int trendDays = 7,
    bool keepBranch = false,
  }) async {
    if (!keepBranch) _branchId = branchId;
    emit(const DashboardLoading());
    try {
      final data = await _getDashboardSummaryUseCase(
        branchId: _branchId,
        trendDays: trendDays,
      );
      emit(DashboardLoaded(data, trendDays: trendDays));
    } catch (e) {
      emit(DashboardError(UserErrorMessage.from(e)));
    }
  }
}
