import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';

part 'shift_detail_state.freezed.dart';

@freezed
class ShiftDetailState with _$ShiftDetailState {
  const factory ShiftDetailState({
    RegisterShiftModel? shift,
    ShiftSummaryModel? summary,
    CashRegisterModel? register,
    @Default(false) bool isLoading,
    String? error,
  }) = _ShiftDetailState;
}
