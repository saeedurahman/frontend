part of 'pos_state.dart';

@freezed
class PosShiftState with _$PosShiftState {
  const factory PosShiftState({
    RegisterShiftModel? activeShift,
    ShiftSummaryModel? shiftSummary,
    @Default([]) List<CashRegisterModel> registers,
    String? selectedRegisterId,
    @Default(true) bool isCheckingShift,
    @Default(false) bool isOpeningShift,
    @Default(false) bool isCreatingRegister,
    String? registersError,
  }) = _PosShiftState;
}
