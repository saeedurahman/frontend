import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';

part 'shift_history_state.freezed.dart';

enum ShiftDatePreset { today, last7Days, last30Days, all }

@freezed
class ShiftHistoryState with _$ShiftHistoryState {
  const factory ShiftHistoryState({
    @Default([]) List<RegisterShiftModel> shifts,
    @Default([]) List<CashRegisterModel> registers,
    String? selectedRegisterId,
    @Default(ShiftDatePreset.last30Days) ShiftDatePreset datePreset,
    DateTime? customDateFrom,
    DateTime? customDateTo,
    @Default(0) int skip,
    @Default(50) int limit,
    @Default(false) bool hasMore,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool accessDenied,
    String? error,
  }) = _ShiftHistoryState;
}
