import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShiftDetailCubit extends Cubit<ShiftDetailState>
    with AutoRefresh<ShiftDetailState> {
  ShiftDetailCubit({
    required GetRegisterShiftByIdUseCase getShiftByIdUseCase,
    required GetRegisterShiftSummaryUseCase getShiftSummaryUseCase,
    required GetCashRegistersUseCase getRegistersUseCase,
  })  : _getShift = getShiftByIdUseCase,
        _getSummary = getShiftSummaryUseCase,
        _getRegisters = getRegistersUseCase,
        super(const ShiftDetailState()) {
    watchData(const {DataTopic.shifts, DataTopic.cashMovements}, _reload);
  }

  String? _shiftId;
  String? _branchId;

  final GetRegisterShiftByIdUseCase _getShift;
  final GetRegisterShiftSummaryUseCase _getSummary;
  final GetCashRegistersUseCase _getRegisters;

  Future<void> load(String shiftId, {String? branchId}) {
    _shiftId = shiftId;
    _branchId = branchId;
    return _read(quiet: false);
  }

  Future<void> _reload() async {
    if (_shiftId == null) return;
    await _read(quiet: state.shift != null);
  }

  /// [quiet]: no spinner, and the shift on screen stays when it fails.
  Future<void> _read({required bool quiet}) async {
    final shiftId = _shiftId!;
    final branchId = _branchId;
    final read = beginRead();
    if (!quiet) emit(const ShiftDetailState(isLoading: true));

    final shiftResult = await _getShift(shiftId);
    if (isStale(read)) return;
    await shiftResult.fold(
      (failure) async {
        if (!quiet) {
          emit(ShiftDetailState(isLoading: false, error: failure.message));
        }
      },
      (shift) async {
        final summaryResult = await _getSummary(shiftId);
        final summary = summaryResult.fold(
          (_) => quiet ? state.summary : null,
          (s) => s,
        );

        CashRegisterModel? register;
        if (branchId != null) {
          final registersResult = await _getRegisters(branchId: branchId);
          registersResult.fold((_) {}, (registers) {
            for (final r in registers) {
              if (r.id == shift.cashRegisterId) {
                register = r;
                break;
              }
            }
          });
        }

        if (isStale(read)) return;
        emit(
          ShiftDetailState(
            isLoading: false,
            shift: shift,
            summary: summary,
            register: register,
          ),
        );
      },
    );
  }
}
