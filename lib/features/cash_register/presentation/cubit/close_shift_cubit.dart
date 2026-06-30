import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class CloseShiftCubit extends Cubit<CloseShiftState> {
  CloseShiftCubit({
    required CloseRegisterShiftUseCase closeShiftUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _closeShift = closeShiftUseCase,
        _authLocal = authLocalDataSource,
        super(const CloseShiftState());

  final CloseRegisterShiftUseCase _closeShift;
  final AuthLocalDataSource _authLocal;

  Future<void> init({
    required String shiftId,
    required ShiftSummaryModel summary,
    required String registerName,
  }) async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canCloseShift(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const CloseShiftState(accessDenied: true));
      return;
    }

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
    if (state.accessDenied || !state.canSubmit) return null;

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
    this.accessDenied = false,
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
  final bool accessDenied;

  Decimal get expectedCash =>
      summary?.expectedCashDecimal ?? Decimal.zero;

  Decimal get actualCashParsed =>
      Decimal.tryParse(actualCashInput.trim()) ?? Decimal.zero;

  Decimal get variance => actualCashParsed - expectedCash;

  bool get hasVariance => variance != Decimal.zero;

  bool get canSubmit =>
      !accessDenied &&
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
    bool? accessDenied,
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
      accessDenied: accessDenied ?? this.accessDenied,
    );
  }
}
