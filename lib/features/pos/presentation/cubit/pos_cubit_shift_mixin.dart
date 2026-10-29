part of 'pos_cubit.dart';

mixin PosCubitShiftMixin on PosCubitBase {
  Future<void> checkActiveShift() async {
    _safeEmit(state.patch(isCheckingShift: true, registersError: null));
    final branchId = state.branchId;

    if (branchId == null) {
      _safeEmit(state.patch(
        isCheckingShift: false,
        registersError:
            'Branch not configured for your account. Please re-login.',
      ));
      return;
    }

    final registersResult = await _getRegisters(branchId: branchId);
    final shiftResult = await _getMyActiveShift();
    if (isClosed) return;

    await registersResult.fold(
      (Failure failure) async {
        _safeEmit(state.patch(
          isCheckingShift: false,
          registersError: failure.message,
        ));
      },
      (List<CashRegisterModel> registers) async {
        await shiftResult.fold(
          (Failure failure) async {
            _safeEmit(state.patch(
              registers: registers,
              isCheckingShift: false,
              activeShift: null,
              registersError: failure.message,
            ));
          },
          (RegisterShiftModel? shift) async {
            ShiftSummaryModel? summary;
            String? summaryError;
            if (shift != null) {
              final summaryResult = await _getShiftSummary(shift.id);
              if (isClosed) return;
              summaryResult.fold(
                (failure) => summaryError = failure.message,
                (s) => summary = s,
              );
            }

            final selectedRegisterId = shift?.cashRegisterId ??
                state.selectedRegisterId ??
                (registers.isNotEmpty ? registers.first.id : null);

            _safeEmit(state.patch(
              registers: registers,
              selectedRegisterId: selectedRegisterId,
              activeShift: shift,
              shiftSummary: summary,
              shiftSummaryError: summaryError,
              isCheckingShift: false,
              registersError: null,
            ));
          },
        );
      },
    );
  }

  Future<bool> createDefaultRegister({String name = 'Main Counter'}) async {
    final branchId = state.branchId;
    if (branchId == null) return false;

    _safeEmit(state.patch(isCreatingRegister: true, registersError: null));
    final result = await _createRegister({
      'name': name,
      'branch_id': branchId,
    });
    if (isClosed) return false;

    return result.fold(
      (failure) {
        _safeEmit(state.patch(
          isCreatingRegister: false,
          registersError: failure.message,
        ));
        return false;
      },
      (register) {
        _safeEmit(state.patch(
          registers: [register],
          selectedRegisterId: register.id,
          isCreatingRegister: false,
        ));
        return true;
      },
    );
  }

  Future<void> refreshShiftSummary() async {
    final shift = state.activeShift;
    if (shift == null) return;
    final result = await _getShiftSummary(shift.id);
    if (isClosed) return;
    result.fold(
      (failure) => _safeEmit(
        state.patch(shiftSummaryError: failure.message),
      ),
      (summary) => _safeEmit(
        state.patch(shiftSummary: summary, shiftSummaryError: null),
      ),
    );
  }

  /// Retry button for the shift summary banner.
  Future<void> retryShiftSummary() => refreshShiftSummary();

  /// Opens a shift. On failure [PosState.openShiftError] carries the real
  /// reason (server message, missing permission, no register selected).
  Future<bool> openShift(Decimal openingFloat, String? notes) async {
    final blocker = ShiftPolicy.openBlocker(
      canOpenShift: state.canOpenShift,
      registerId: state.selectedRegisterId,
    );
    if (blocker != null) {
      _safeEmit(state.patch(openShiftError: blocker));
      return false;
    }
    final registerId = state.selectedRegisterId!;

    _safeEmit(state.patch(isOpeningShift: true, openShiftError: null));
    final result = await _openShift(ShiftPolicy.openBody(
      registerId: registerId,
      openingFloat: openingFloat,
      notes: notes,
    ));
    if (isClosed) return false;

    return result.fold(
      (failure) {
        _safeEmit(state.patch(
          isOpeningShift: false,
          openShiftError: failure.message,
        ));
        return false;
      },
      (shift) {
        _safeEmit(state.patch(
          activeShift: shift,
          isOpeningShift: false,
          isCheckingShift: false,
          openShiftError: null,
        ));
        refreshShiftSummary();
        return true;
      },
    );
  }

  void selectRegister(String registerId) {
    emit(state.patch(selectedRegisterId: registerId));
  }
}
