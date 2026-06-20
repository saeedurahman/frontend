import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class CloseShiftCubit extends Cubit<CloseShiftState> {
  CloseShiftCubit({
    required CloseRegisterShiftUseCase closeShiftUseCase,
  })  : _closeShift = closeShiftUseCase,
        super(const CloseShiftState());

  final CloseRegisterShiftUseCase _closeShift;

  void init({
    required String shiftId,
    required ShiftSummaryModel summary,
    required String registerName,
  }) {
    emit(
      CloseShiftState(
        shiftId: shiftId,
        summary: summary,
        registerName: registerName,
      ),
    );
  }

  void setActualCash(String value) {
    emit(state.copyWith(actualCashInput: value, submitError: null));
  }

  void setNotes(String? value) {
    emit(state.copyWith(notes: value));
  }

  void clearSubmitError() {
    emit(state.copyWith(submitError: null));
  }

  void confirmVariance() {
    emit(state.copyWith(confirmedVariance: true));
  }

  Future<ShiftSummaryModel?> submit() async {
    if (!state.canSubmit) return null;

    emit(state.copyWith(isSubmitting: true, submitError: null));

    final result = await _closeShift(
      state.shiftId!,
      actualCash: state.actualCashInput.trim(),
      notes: state.notes?.trim().isEmpty ?? true ? null : state.notes?.trim(),
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitError: failure.message,
          ),
        );
        return null;
      },
      (response) {
        emit(
          state.copyWith(
            isSubmitting: false,
            closedSummary: response,
          ),
        );
        return response;
      },
    );
  }
}

class CloseShiftState {
  const CloseShiftState({
    this.shiftId,
    this.summary,
    this.registerName,
    this.actualCashInput = '',
    this.notes,
    this.isSubmitting = false,
    this.submitError,
    this.closedSummary,
    this.confirmedVariance = false,
  });

  final String? shiftId;
  final ShiftSummaryModel? summary;
  final String? registerName;
  final String actualCashInput;
  final String? notes;
  final bool isSubmitting;
  final String? submitError;
  final ShiftSummaryModel? closedSummary;
  final bool confirmedVariance;

  Decimal get expectedCash =>
      summary?.expectedCashDecimal ?? Decimal.zero;

  Decimal get actualCashParsed =>
      Decimal.tryParse(actualCashInput.trim()) ?? Decimal.zero;

  Decimal get variance => actualCashParsed - expectedCash;

  bool get hasVariance => variance != Decimal.zero;

  bool get canSubmit =>
      shiftId != null &&
      summary != null &&
      actualCashParsed >= Decimal.zero &&
      actualCashInput.trim().isNotEmpty &&
      !isSubmitting &&
      (!hasVariance || confirmedVariance);

  CloseShiftState copyWith({
    String? shiftId,
    ShiftSummaryModel? summary,
    String? registerName,
    String? actualCashInput,
    String? notes,
    bool? isSubmitting,
    String? submitError,
    ShiftSummaryModel? closedSummary,
    bool? confirmedVariance,
  }) {
    return CloseShiftState(
      shiftId: shiftId ?? this.shiftId,
      summary: summary ?? this.summary,
      registerName: registerName ?? this.registerName,
      actualCashInput: actualCashInput ?? this.actualCashInput,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError,
      closedSummary: closedSummary ?? this.closedSummary,
      confirmedVariance: confirmedVariance ?? this.confirmedVariance,
    );
  }
}
