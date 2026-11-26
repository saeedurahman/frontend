import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentShiftCubit extends Cubit<CurrentShiftState>
    with AutoRefresh<CurrentShiftState> {
  CurrentShiftCubit({
    required GetCashRegistersUseCase getRegistersUseCase,
    required GetActiveRegisterShiftUseCase getActiveShiftUseCase,
    required GetRegisterShiftSummaryUseCase getShiftSummaryUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getRegisters = getRegistersUseCase,
        _getActiveShift = getActiveShiftUseCase,
        _getShiftSummary = getShiftSummaryUseCase,
        _authLocal = authLocalDataSource,
        super(const CurrentShiftState()) {
    watchData(const {DataTopic.shifts, DataTopic.cashMovements}, _reload);
  }

  bool _started = false;

  final GetCashRegistersUseCase _getRegisters;
  final GetActiveRegisterShiftUseCase _getActiveShift;
  final GetRegisterShiftSummaryUseCase _getShiftSummary;
  final AuthLocalDataSource _authLocal;

  String? _branchId;

  Future<void> load() async {
    _started = true;
    final read = beginRead();
    emit(state.copyWith(isLoading: true, error: null, accessDenied: false));
    final user = await _authLocal.getCachedUser();
    final permissionKeys = user?.permissionKeys ?? const [];
    final canView = UserRoleUtils.canViewShifts(
      role: user?.role,
      permissionKeys: permissionKeys,
    );
    final canClose = UserRoleUtils.canCloseShift(
      role: user?.role,
      permissionKeys: permissionKeys,
    );

    if (!canView) {
      emit(
        state.copyWith(
          isLoading: false,
          accessDenied: true,
          canCloseShift: canClose,
        ),
      );
      return;
    }

    _branchId = user?.branchId;

    if (_branchId == null) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Branch not configured. Please re-login.',
          canCloseShift: canClose,
        ),
      );
      return;
    }

    final registersResult = await _getRegisters(branchId: _branchId);
    if (isStale(read)) return;
    await registersResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            canCloseShift: canClose,
          ),
        );
      },
      (registers) async {
        final openShifts = await _loadOpenShifts(registers);
        if (isStale(read)) return;
        emit(
          state.copyWith(
            isLoading: false,
            registers: registers,
            openShifts: openShifts,
            selectedShift: _pickDefaultShift(openShifts),
            cashierName: user?.name,
            error: null,
            canCloseShift: canClose,
          ),
        );
      },
    );
  }

  Future<void> refresh() => _read(quiet: false);

  /// After a shift is opened or closed, or money moves in the drawer.
  Future<void> _reload() async {
    if (!_started) return;
    await _read(quiet: true);
  }

  /// [quiet]: no busy indicator, and what is on screen stays when it fails.
  Future<void> _read({required bool quiet}) async {
    if (state.accessDenied) return;

    if (_branchId == null || state.isLoading) {
      await load();
      return;
    }

    final read = beginRead();
    if (!quiet) emit(state.copyWith(isRefreshing: true, error: null));
    final registersResult = await _getRegisters(branchId: _branchId);
    if (isStale(read)) return;
    await registersResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isRefreshing: false,
            error: quiet ? state.error : failure.message,
          ),
        );
      },
      (registers) async {
        final openShifts = await _loadOpenShifts(registers);
        if (isStale(read)) return;
        final selectedId = state.selectedShift?.shift.id;
        OpenShiftEntry? selected;
        if (selectedId != null) {
          for (final entry in openShifts) {
            if (entry.shift.id == selectedId) {
              selected = entry;
              break;
            }
          }
        }
        emit(
          state.copyWith(
            isRefreshing: false,
            error: null,
            registers: registers,
            openShifts: openShifts,
            selectedShift: selected ?? _pickDefaultShift(openShifts),
          ),
        );
      },
    );
  }

  void selectShift(String shiftId) {
    for (final entry in state.openShifts) {
      if (entry.shift.id == shiftId) {
        emit(state.copyWith(selectedShift: entry));
        return;
      }
    }
  }

  Future<List<OpenShiftEntry>> _loadOpenShifts(
    List<CashRegisterModel> registers,
  ) async {
    final entries = <OpenShiftEntry>[];
    for (final register in registers) {
      final shiftResult = await _getActiveShift(register.id);
      // A read that fails says nothing about the shift: keep what was shown.
      if (shiftResult.isLeft()) {
        entries.addAll(
          state.openShifts.where((e) => e.register.id == register.id),
        );
        continue;
      }
      final shift = shiftResult.fold((_) => null, (s) => s);
      if (shift == null) continue;

      ShiftSummaryModel? summary;
      final summaryResult = await _getShiftSummary(shift.id);
      summaryResult.fold(
        (_) {
          for (final e in state.openShifts) {
            if (e.shift.id == shift.id) summary = e.summary;
          }
        },
        (s) => summary = s,
      );

      entries.add(
        OpenShiftEntry(
          shift: shift,
          register: register,
          summary: summary,
        ),
      );
    }
    return entries;
  }

  OpenShiftEntry? _pickDefaultShift(List<OpenShiftEntry> entries) {
    if (entries.isEmpty) return null;
    return entries.first;
  }
}
