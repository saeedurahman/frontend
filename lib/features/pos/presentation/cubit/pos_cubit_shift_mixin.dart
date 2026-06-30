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
            if (shift != null) {
              final summaryResult = await _getShiftSummary(shift.id);
              if (isClosed) return;
              summaryResult.fold((_) {}, (s) => summary = s);
            }

            final selectedRegisterId = shift?.cashRegisterId ??
                state.selectedRegisterId ??
                (registers.isNotEmpty ? registers.first.id : null);

            _safeEmit(state.patch(
              registers: registers,
              selectedRegisterId: selectedRegisterId,
              activeShift: shift,
              shiftSummary: summary,
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
    result.fold((_) {}, (summary) {
      _safeEmit(state.patch(shiftSummary: summary));
    });
  }

  Future<bool> openShift(Decimal openingFloat, String? notes) async {
    if (!state.canOpenShift) return false;

    final registerId = state.selectedRegisterId;
    if (registerId == null) return false;

    _safeEmit(state.patch(isOpeningShift: true));
    final result = await _openShift({
      'cash_register_id': registerId,
      'opening_float': DecimalUtils.format(openingFloat),
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    if (isClosed) return false;

    return result.fold(
      (_) {
        _safeEmit(state.patch(isOpeningShift: false));
        return false;
      },
      (shift) {
        _safeEmit(state.patch(
          activeShift: shift,
          isOpeningShift: false,
          isCheckingShift: false,
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
