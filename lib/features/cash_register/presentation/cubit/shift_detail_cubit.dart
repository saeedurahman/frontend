import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShiftDetailCubit extends Cubit<ShiftDetailState> {
  ShiftDetailCubit({
    required GetRegisterShiftByIdUseCase getShiftByIdUseCase,
    required GetRegisterShiftSummaryUseCase getShiftSummaryUseCase,
    required GetCashRegistersUseCase getRegistersUseCase,
  })  : _getShift = getShiftByIdUseCase,
        _getSummary = getShiftSummaryUseCase,
        _getRegisters = getRegistersUseCase,
        super(const ShiftDetailState());

  final GetRegisterShiftByIdUseCase _getShift;
  final GetRegisterShiftSummaryUseCase _getSummary;
  final GetCashRegistersUseCase _getRegisters;

  Future<void> load(String shiftId, {String? branchId}) async {
    emit(const ShiftDetailState(isLoading: true));

    final shiftResult = await _getShift(shiftId);
    await shiftResult.fold(
      (failure) async {
        emit(ShiftDetailState(isLoading: false, error: failure.message));
      },
      (shift) async {
        final summaryResult = await _getSummary(shiftId);
        final summary = summaryResult.fold((_) => null, (s) => s);

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
