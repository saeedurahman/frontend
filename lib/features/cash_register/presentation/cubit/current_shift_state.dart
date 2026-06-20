import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';

part 'current_shift_state.freezed.dart';

@freezed
class OpenShiftEntry with _$OpenShiftEntry {
  const factory OpenShiftEntry({
    required RegisterShiftModel shift,
    required CashRegisterModel register,
    ShiftSummaryModel? summary,
  }) = _OpenShiftEntry;
}

@freezed
class CurrentShiftState with _$CurrentShiftState {
  const factory CurrentShiftState({
    @Default([]) List<CashRegisterModel> registers,
    @Default([]) List<OpenShiftEntry> openShifts,
    OpenShiftEntry? selectedShift,
    String? cashierName,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? error,
  }) = _CurrentShiftState;
}
