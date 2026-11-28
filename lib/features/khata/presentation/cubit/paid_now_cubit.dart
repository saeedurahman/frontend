import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/last_payment_source_store.dart';
import 'package:frantend/features/khata/domain/paid_now_hook.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/domain/shift_guard.dart';
import 'package:frantend/features/khata/presentation/utils/money_input.dart';
import 'package:injectable/injectable.dart';

/// How much of the bill is paid right now.
enum PaidChip { none, half, full, custom }

/// The "Paid now" part of receiving goods (GRN, Quick Add purchase).
///
/// The bill total changes while the owner works, so Full and Half are kept as
/// a choice and worked out against the live total, never copied once.
class PaidNowState {
  const PaidNowState({
    this.chip = PaidChip.none,
    this.amountText = '',
    this.source = PaymentSource.ownerPocket,
    this.reference = '',
    this.note = '',
    this.shiftId,
    this.checkingShift = false,
    this.openingShift = false,
    this.error,
  });

  final PaidChip chip;

  /// What was typed (only used when [chip] is [PaidChip.custom]).
  final String amountText;
  final PaymentSource source;
  final String reference;
  final String note;
  final String? shiftId;
  final bool checkingShift;
  final bool openingShift;
  final String? error;

  /// The amount paid now against [total]; zero while on credit.
  Decimal amountFor(Decimal total) {
    switch (chip) {
      case PaidChip.none:
        return Decimal.zero;
      case PaidChip.full:
        return _money(total);
      case PaidChip.half:
        return _money(
          (total / Decimal.fromInt(2)).toDecimal(scaleOnInfinitePrecision: 4),
        );
      case PaidChip.custom:
        final text = MoneyInput.resolve(amountText);
        return text == null ? Decimal.zero : (Decimal.tryParse(text) ?? Decimal.zero);
    }
  }

  static Decimal _money(Decimal v) =>
      v < Decimal.zero ? Decimal.zero : v.round(scale: 2);

  /// What stays on credit: the part of [total] not paid now.
  Decimal onCredit(Decimal total) {
    final left = total - amountFor(total);
    return left < Decimal.zero ? Decimal.zero : left;
  }

  /// A plain sentence when the paid amount cannot be sent, else null.
  String? problem(Decimal total) {
    if (chip != PaidChip.custom) return null;
    final text = amountText.trim();
    if (text.isEmpty) return null;
    final resolved = MoneyInput.resolve(text);
    if (resolved == null) return KhataText.enterAmount;
    final dot = resolved.indexOf('.');
    if (dot >= 0 && resolved.length - dot - 1 > 2) return KhataText.tooManyDecimals;
    final amount = Decimal.tryParse(resolved) ?? Decimal.zero;
    if (amount > total) return KhataText.paidMoreThanTotal;
    return null;
  }

  /// Paying from the drawer needs the user's own open shift.
  ///
  /// While the shift is still being checked it counts as "not open": saving
  /// must wait for the answer, never guess.
  bool needsShift(Decimal total) =>
      amountFor(total) > Decimal.zero && source.touchesDrawer && shiftId == null;

  /// Show the "Open your shift first" notice (not while still checking).
  bool showShiftNotice(Decimal total) => needsShift(total) && !checkingShift;

  PaidNowState copyWith({
    PaidChip? chip,
    String? amountText,
    PaymentSource? source,
    String? reference,
    String? note,
    Object? shiftId = _keep,
    bool? checkingShift,
    bool? openingShift,
    Object? error = _keep,
  }) =>
      PaidNowState(
        chip: chip ?? this.chip,
        amountText: amountText ?? this.amountText,
        source: source ?? this.source,
        reference: reference ?? this.reference,
        note: note ?? this.note,
        shiftId: identical(shiftId, _keep) ? this.shiftId : shiftId as String?,
        checkingShift: checkingShift ?? this.checkingShift,
        openingShift: openingShift ?? this.openingShift,
        error: identical(error, _keep) ? this.error : error as String?,
      );
}

const Object _keep = Object();

/// The sentence shown after a receipt is saved, with or without a payment.
String receivedMessage(ReceiptPaymentResult? result, Decimal total) {
  if (result == null) return KhataText.goodsReceived;
  final billTotal = result.totalAmount ?? total;
  final paid = result.payment.amount;
  final credit = billTotal - paid;
  if (credit <= Decimal.zero) {
    return KhataText.goodsReceivedPaidFull(formatPKR(paid));
  }
  return KhataText.goodsReceivedPaid(formatPKR(paid), formatPKR(credit));
}

/// Holds the "Paid now" choices for one receiving screen. Defaults to None
/// (everything on credit), so nothing is paid unless the owner says so.
@injectable
class PaidNowCubit extends Cubit<PaidNowState> implements PaidNowHook {
  PaidNowCubit(this._shifts, this._lastSource, this._events)
      : super(const PaidNowState());

  final ShiftGuard _shifts;
  final LastPaymentSourceStore _lastSource;
  final KhataEvents _events;

  /// Looks at the shift and picks the default source: the cash drawer while a
  /// shift is open, else the one used last time.
  Future<void> init() async {
    emit(state.copyWith(checkingShift: true));
    final shiftId = await _shifts.currentShiftId();
    if (isClosed) return;
    emit(
      state.copyWith(
        checkingShift: false,
        shiftId: shiftId,
        source: shiftId != null
            ? PaymentSource.drawer
            : (_lastSource.read() ?? PaymentSource.ownerPocket),
      ),
    );
  }

  void setChip(PaidChip chip) {
    emit(
      state.copyWith(
        chip: chip,
        amountText: chip == PaidChip.custom ? state.amountText : '',
        error: null,
      ),
    );
  }

  void setAmount(String text) {
    emit(
      state.copyWith(
        chip: text.trim().isEmpty ? PaidChip.none : PaidChip.custom,
        amountText: text,
        error: null,
      ),
    );
  }

  void setSource(PaymentSource source) {
    emit(state.copyWith(source: source, error: null));
    if (source.touchesDrawer && state.shiftId == null) refreshShift();
  }

  void setReference(String text) => emit(state.copyWith(reference: text));

  void setNote(String text) => emit(state.copyWith(note: text));

  Future<void> refreshShift() async {
    emit(state.copyWith(checkingShift: true));
    final id = await _shifts.currentShiftId();
    if (isClosed) return;
    emit(state.copyWith(checkingShift: false, shiftId: id));
  }

  /// One-tap "Open shift" from the notice.
  Future<bool> openShift() async {
    emit(state.copyWith(openingShift: true, error: null));
    final result = await _shifts.openNow();
    if (isClosed) return false;
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

  /// What goes into the request for a bill of [total], or null to leave
  /// everything on credit.
  @override
  ReceiptPaymentInput? inputFor(Decimal total) {
    final amount = state.amountFor(total);
    if (amount <= Decimal.zero) return null;
    return ReceiptPaymentInput(
      amount: amount,
      source: state.source,
      reference: state.reference,
      note: state.note,
    );
  }

  /// Why the bill cannot be saved with this payment yet, in plain words.
  @override
  String? blockingProblem(Decimal total) {
    final problem = state.problem(total);
    if (problem != null) return problem;
    if (state.needsShift(total)) return KhataText.needsShiftBody;
    return null;
  }

  /// Turns a server code into plain words and shows it under the section.
  @override
  String? explain(String? code, String fallback) {
    final text = KhataText.forCode(code) ?? fallback;
    emit(state.copyWith(error: text));
    if (KhataText.needsOwnShift(code)) {
      emit(state.copyWith(shiftId: null));
    }
    return text;
  }

  /// The bill was saved: remember the source, tell the open screens, start
  /// again from "everything on credit".
  @override
  Future<void> saved({required bool paid, ReceiptPaymentResult? result}) async {
    if (paid) {
      await _lastSource.write(state.source);
      _events.notifyChanged();
    }
    if (isClosed) return;
    emit(
      PaidNowState(
        source: state.source,
        shiftId: state.shiftId,
      ),
    );
  }
}
