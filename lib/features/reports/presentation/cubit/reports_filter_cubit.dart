import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReportsFilterCubit extends Cubit<ReportsFilterState> {
  ReportsFilterCubit(this._authLocal)
      : super(ReportsFilterState(filter: ReportsFilter.last7Days()));

  final AuthLocalDataSource _authLocal;

  Future<void> init() async {
    final selector = sl<BranchSelectorCubit>().state;
    if (selector.isInitialized && selector.selectedBranchId != null) {
      emit(ReportsFilterState.initial(branchId: selector.selectedBranchId));
      return;
    }
    final user = await _authLocal.getCachedUser();
    emit(ReportsFilterState.initial(branchId: user?.branchId));
  }

  void applyRange({
    required DateTime from,
    required DateTime to,
    required String presetLabel,
  }) {
    emit(
      ReportsFilterState(
        filter: state.filter.copyWith(
          dateFrom: DateTime(from.year, from.month, from.day),
          dateTo: DateTime(to.year, to.month, to.day),
          presetLabel: presetLabel,
        ),
      ),
    );
  }

  void setBranch(String? branchId) {
    emit(
      ReportsFilterState(
        filter: state.filter.copyWith(
          branchId: branchId,
          clearBranch: branchId == null,
        ),
      ),
    );
  }
}
