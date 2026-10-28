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
    /// Real failure message from the last `openShift` attempt.
    String? openShiftError,
    /// Set when the shift summary could not be loaded (retry offered).
    String? shiftSummaryError,
  }) = _PosShiftState;
}
