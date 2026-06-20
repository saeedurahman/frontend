import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';

part 'customer_ledger_state.freezed.dart';

@freezed
class LedgerDisplayRow with _$LedgerDisplayRow {
  const factory LedgerDisplayRow({
    required CustomerLedgerEntryModel entry,
    required String runningBalance,
  }) = _LedgerDisplayRow;
}

@Freezed()
sealed class CustomerLedgerState with _$CustomerLedgerState {
  const factory CustomerLedgerState.initial() = CustomerLedgerInitial;

  const factory CustomerLedgerState.loading() = CustomerLedgerLoading;

  const factory CustomerLedgerState.loaded({
    required CustomerModel customer,
    required String balance,
    required List<LedgerDisplayRow> entries,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(false) bool isRecordingPayment,
    String? paymentError,
    @Default(false) bool isCheckingPaymentShift,
    String? activePaymentShiftId,
  }) = CustomerLedgerLoaded;

  const factory CustomerLedgerState.error(String message) = CustomerLedgerError;
}
