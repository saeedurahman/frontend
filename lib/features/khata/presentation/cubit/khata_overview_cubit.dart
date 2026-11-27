import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';

class KhataOverviewState {
  const KhataOverviewState({this.data, this.loading = true, this.error});

  final KhataData<KhataOverview>? data;
  final bool loading;

  /// Why there are no figures.
  final String? error;
}

/// The two totals on the dashboard, for the branch picked at the top.
class KhataOverviewCubit extends Cubit<KhataOverviewState>
    with AutoRefresh<KhataOverviewState> {
  KhataOverviewCubit(
    this._repository, {
    String? branchId,
    ConnectivityProbe? probe,
    DataChangeBus? bus,
  })  : _branchId = branchId,
        super(const KhataOverviewState()) {
    watchData(
      const {DataTopic.customerLedger, DataTopic.supplierLedger},
      load,
      bus: bus,
    );
    _connectivity = probe?.status.listen((status) {
      if (status != ReachabilityStatus.offline) load();
    });
  }

  final KhataRepository _repository;
  String? _branchId;
  StreamSubscription<ReachabilityStatus>? _connectivity;

  Future<void> load() async {
    final read = beginRead();
    final result = await _repository.overview(branchId: _branchId);
    if (isStale(read)) return;
    result.fold(
      // Figures already on screen stay when a re-read fails.
      (failure) => emit(
        KhataOverviewState(
          data: state.data,
          loading: false,
          error: state.data == null ? failure.message : null,
        ),
      ),
      (data) => emit(KhataOverviewState(data: data, loading: false)),
    );
  }

  Future<void> onBranchChanged(String? branchId) {
    if (branchId == _branchId) return Future.value();
    _branchId = branchId;
    // Another branch's figures must not linger.
    emit(const KhataOverviewState());
    return load();
  }

  @override
  Future<void> close() {
    unawaited(_connectivity?.cancel() ?? Future<void>.value());
    return super.close();
  }
}
