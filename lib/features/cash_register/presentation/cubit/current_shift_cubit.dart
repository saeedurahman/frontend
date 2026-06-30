import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentShiftCubit extends Cubit<CurrentShiftState> {
  CurrentShiftCubit({
    required GetCashRegistersUseCase getRegistersUseCase,
    required GetActiveRegisterShiftUseCase getActiveShiftUseCase,
    required GetRegisterShiftSummaryUseCase getShiftSummaryUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getRegisters = getRegistersUseCase,
        _getActiveShift = getActiveShiftUseCase,
        _getShiftSummary = getShiftSummaryUseCase,
        _authLocal = authLocalDataSource,
        super(const CurrentShiftState());

  final GetCashRegistersUseCase _getRegisters;
  final GetActiveRegisterShiftUseCase _getActiveShift;
  final GetRegisterShiftSummaryUseCase _getShiftSummary;
  final AuthLocalDataSource _authLocal;

  String? _branchId;

  Future<void> load() async {
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

  Future<void> refresh() async {
    if (state.accessDenied) return;

    if (_branchId == null) {
      await load();
      return;
    }

    emit(state.copyWith(isRefreshing: true, error: null));
    final registersResult = await _getRegisters(branchId: _branchId);
    await registersResult.fold(
      (failure) async {
        emit(state.copyWith(isRefreshing: false, error: failure.message));
      },
      (registers) async {
        final openShifts = await _loadOpenShifts(registers);
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
      final shift = shiftResult.fold((_) => null, (s) => s);
      if (shift == null) continue;

      ShiftSummaryModel? summary;
      final summaryResult = await _getShiftSummary(shift.id);
      summaryResult.fold((_) {}, (s) => summary = s);

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
