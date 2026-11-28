import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/last_payment_source_store.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/domain/shift_guard.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_state.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

/// Pays a supplier: picks the money source, checks the shift for drawer cash,
/// shows what is owed before and after, and sends the payment once.
@injectable
class SupplierPaymentCubit extends Cubit<SupplierPaymentState> {
  SupplierPaymentCubit(
    this._getBalance,
    this._getSupplier,
    this._pay,
    this._shifts,
    this._branch,
    this._lastSource,
    this._events,
  ) : super(SupplierPaymentState());

  final GetSupplierBalanceUseCase _getBalance;
  final GetSupplierUseCase _getSupplier;
  final PaySupplierUseCase _pay;
  final ShiftGuard _shifts;
  final ActiveBranchResolver _branch;
  final LastPaymentSourceStore _lastSource;
  final KhataEvents _events;

  // One key per logical payment: a retry of the same draft reuses it, so a lost
  // answer can never pay twice. A changed draft is a new payment.
  String? _attemptKey;
  String? _attemptFingerprint;

  /// The key the next [submit] of the current draft would send (for tests).
  String? get attemptKey => _attemptKey;

  /// Loads the supplier, what is owed and the shift, then picks the default
  /// source: the cash drawer while a shift is open, else the last one used.
  Future<void> init({
    required String supplierId,
    String? supplierName,
    String? supplierPhone,
  }) async {
    emit(
      SupplierPaymentState(
        supplierId: supplierId,
        supplierName: supplierName ?? '',
        supplierPhone: supplierPhone,
        checkingShift: true,
      ),
    );

    final branchId = await _branch.resolve();
    final balanceResult = await _getBalance(supplierId, branchId: branchId);
    final shiftId = await _shifts.currentShiftId();

    var balance = Decimal.zero;
    String? error;
    var balanceKnown = false;
    DateTime? balanceAsOf;
    balanceResult.fold(
      (failure) {
        // Offline with no figures on the device: paying still works.
        if (failure is! NetworkFailure) error = failure.message;
      },
      (b) {
        balance = Decimal.tryParse(b.balance) ?? Decimal.zero;
        balanceKnown = true;
        balanceAsOf = b.asOf;
      },
    );

    var name = supplierName ?? '';
    var phone = supplierPhone;
    if (supplierName == null) {
      final supplier = await _getSupplier(supplierId);
      supplier.fold((_) {}, (s) {
        name = s.name;
        phone = s.phone;
      });
    }

    final remembered = _lastSource.read();
    final source = shiftId != null
        ? PaymentSource.drawer
        : (remembered ?? PaymentSource.ownerPocket);

    emit(
      SupplierPaymentState(
        supplierId: supplierId,
        supplierName: name,
        supplierPhone: phone,
        loading: false,
        balance: balance,
        source: source,
        shiftId: shiftId,
        error: error,
        balanceKnown: balanceKnown,
        balanceAsOf: balanceAsOf,
      ),
    );
  }

  void setAmount(String text) {
    emit(state.copyWith(amountText: text, error: null, errorCode: null));
  }

  void payFull() {
    if (state.owed <= Decimal.zero) return;
    setAmount(state.owed.toStringAsFixed(2));
  }

  void payHalf() {
    if (state.owed <= Decimal.zero) return;
    final half = (state.owed / Decimal.fromInt(2))
        .toDecimal(scaleOnInfinitePrecision: 4)
        .round(scale: 2);
    setAmount(half.toStringAsFixed(2));
  }

  void setSource(PaymentSource source) {
    emit(state.copyWith(source: source, error: null, errorCode: null));
    if (source.touchesDrawer && state.shiftId == null) {
      refreshShift();
    }
  }

  void setReference(String text) => emit(state.copyWith(reference: text));

  void setNote(String text) => emit(state.copyWith(note: text));

  void setDate(DateTime? date) {
    emit(state.copyWith(paidOn: date, error: null, errorCode: null));
  }

  Future<void> refreshShift() async {
    emit(state.copyWith(checkingShift: true));
    final id = await _shifts.currentShiftId();
    emit(state.copyWith(checkingShift: false, shiftId: id));
  }

  /// One-tap "Open shift" from the friendly notice.
  Future<bool> openShift() async {
    emit(state.copyWith(openingShift: true, error: null, errorCode: null));
    final result = await _shifts.openNow();
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            openingShift: false,
            error: UserErrorMessage.from(failure),
          ),
        );
        return false;
      },
      (id) {
        emit(state.copyWith(openingShift: false, shiftId: id));
        return true;
      },
    );
  }

  /// The request body. Always carries the active `branch_id`.
  Map<String, dynamic> buildBody(String branchId) {
    final paidOn = state.paidOn;
    return {
      'supplier_id': state.supplierId,
      'amount': state.amount!.toStringAsFixed(2),
      'payment_source': state.source.apiValue,
      if (state.reference.trim().isNotEmpty) 'reference': state.reference.trim(),
      if (state.note.trim().isNotEmpty) 'note': state.note.trim(),
      if (paidOn != null && !_isToday(paidOn))
        'paid_at': DateTime(paidOn.year, paidOn.month, paidOn.day, 12)
            .toUtc()
            .toIso8601String(),
      'branch_id': branchId,
    };
  }

  static bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  /// Sends the payment. Returns true when it was recorded: accepted by the
  /// server, or saved on this device to be sent later.
  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    final branchId = await _branch.resolve();
    if (branchId == null) {
      emit(state.copyWith(error: 'Your branch is not set. Please sign in again.'));
      return false;
    }

    final body = buildBody(branchId);
    final fingerprint = jsonEncode(body);
    if (fingerprint != _attemptFingerprint || _attemptKey == null) {
      _attemptFingerprint = fingerprint;
      _attemptKey = UuidUtils.v4();
    }

    emit(
      state.copyWith(
        submitting: true,
        error: null,
        errorCode: null,
        offline: false,
      ),
    );
    final result = await _pay(body, idempotencyKey: _attemptKey);
    return result.fold(
      (failure) {
        final code = failure.code;
        // Sent, but no answer: its own message says what to check.
        final offline = failure is NetworkFailure &&
            failure is! UnconfirmedPaymentFailure;
        // A clear "no" from the server means nothing was paid: the next tap is
        // a fresh attempt. Network trouble / 5xx are unclear: keep the key.
        final definite = failure is! NetworkFailure &&
            (code != null || failure is! ServerFailure);
        if (definite) {
          _attemptKey = null;
          _attemptFingerprint = null;
        }
        emit(
          state.copyWith(
            submitting: false,
            offline: offline,
            error: offline
                ? null
                : KhataText.forCode(code) ?? UserErrorMessage.from(failure),
            errorCode: code,
            shiftId: KhataText.needsOwnShift(code) ? null : state.shiftId,
          ),
        );
        return false;
      },
      (payment) {
        _attemptKey = null;
        _attemptFingerprint = null;
        _lastSource.write(state.source);
        emit(state.copyWith(submitting: false, result: payment));
        _events.notifyChanged();
        return true;
      },
    );
  }
}
