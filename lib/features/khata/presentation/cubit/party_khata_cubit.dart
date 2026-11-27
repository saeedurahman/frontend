import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

class PartyKhataState {
  const PartyKhataState({
    this.bills,
    this.billsError,
    this.followups = const [],
    this.loadingBills = true,
    this.loadingFollowups = true,
  });

  /// The unpaid bills; null while loading or when none could be read.
  final KhataData<OpenItems>? bills;
  final String? billsError;

  /// Newest first.
  final List<Followup> followups;
  final bool loadingBills;
  final bool loadingFollowups;

  /// The latest promise to pay.
  Followup? get promise {
    for (final f in followups) {
      if (f.kind == FollowupKind.promise) return f;
    }
    return null;
  }

  PartyKhataState copyWith({
    KhataData<OpenItems>? bills,
    String? billsError,
    bool clearBillsError = false,
    List<Followup>? followups,
    bool? loadingBills,
    bool? loadingFollowups,
  }) =>
      PartyKhataState(
        bills: bills ?? this.bills,
        billsError: clearBillsError ? null : (billsError ?? this.billsError),
        followups: followups ?? this.followups,
        loadingBills: loadingBills ?? this.loadingBills,
        loadingFollowups: loadingFollowups ?? this.loadingFollowups,
      );
}

/// Pending bills, promises, reminders and notes of one party.
class PartyKhataCubit extends Cubit<PartyKhataState>
    with AutoRefresh<PartyKhataState> {
  PartyKhataCubit(
    this._repository, {
    required this.partyType,
    required this.partyId,
    String? branchId,
    ConnectivityProbe? probe,
    DataChangeBus? bus,
  })  : _branchId = branchId,
        super(const PartyKhataState()) {
    watchData(
      {
        DataTopic.followups,
        partyType.isCustomer
            ? DataTopic.customerLedger
            : DataTopic.supplierLedger,
      },
      load,
      bus: bus,
    );
    _connectivity = probe?.status.listen((status) {
      if (status != ReachabilityStatus.offline) load();
    });
  }

  final KhataRepository _repository;
  final PartyType partyType;
  final String partyId;
  String? _branchId;
  StreamSubscription<ReachabilityStatus>? _connectivity;

  KhataRepository get repository => _repository;
  String? get branchId => _branchId;

  /// Reads both again. What is on screen stays while it runs.
  Future<void> load() async {
    final read = beginRead();
    // The device's reminders and notes are quick: they never wait for bills.
    final followups = _repository
        .followups(partyType, partyId, branchId: _branchId)
        .then((list) {
      if (!isStale(read)) {
        emit(state.copyWith(followups: list, loadingFollowups: false));
      }
    });
    final bills = _repository
        .openItems(partyType, partyId, branchId: _branchId)
        .then((result) {
      if (isStale(read)) return;
      result.fold(
        (failure) => emit(
          state.copyWith(
            loadingBills: false,
            billsError: state.bills == null ? failure.message : null,
          ),
        ),
        (data) => emit(
          state.copyWith(
            bills: data,
            loadingBills: false,
            clearBillsError: true,
          ),
        ),
      );
    });
    await Future.wait([followups, bills]);
  }

  Future<void> onBranchChanged(String? branchId) {
    if (branchId == _branchId) return Future.value();
    _branchId = branchId;
    // Another branch's bills must not linger.
    emit(const PartyKhataState());
    return load();
  }

  @override
  Future<void> close() {
    unawaited(_connectivity?.cancel() ?? Future<void>.value());
    return super.close();
  }
}
