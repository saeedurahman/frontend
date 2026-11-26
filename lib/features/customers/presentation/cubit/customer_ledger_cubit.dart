import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/domain/pending_ledger.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/shift_guard.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/shared/widgets/tables/client_table_pagination.dart';
import 'package:injectable/injectable.dart';

/// What the last re-read of the ledger found.
enum _Reread { fresh, offline, failed }

@injectable
class CustomerLedgerCubit extends Cubit<CustomerLedgerState>
    with AutoRefresh<CustomerLedgerState> {
  CustomerLedgerCubit({
    required GetCustomerUseCase getCustomerUseCase,
    required GetCustomerBalanceUseCase getCustomerBalanceUseCase,
    required GetCustomerLedgerUseCase getCustomerLedgerUseCase,
    required RecordCustomerPaymentUseCase recordCustomerPaymentUseCase,
    required ReverseCustomerPaymentUseCase reverseCustomerPaymentUseCase,
    required ShiftGuard shiftGuard,
    required ActiveBranchResolver branchResolver,
    required KhataEvents khataEvents,
  })  : _getCustomer = getCustomerUseCase,
        _getBalance = getCustomerBalanceUseCase,
        _getLedger = getCustomerLedgerUseCase,
        _recordPayment = recordCustomerPaymentUseCase,
        _reverse = reverseCustomerPaymentUseCase,
        _shifts = shiftGuard,
        _branchResolver = branchResolver,
        _events = khataEvents,
        super(const CustomerLedgerState.initial()) {
    watchData(
      const {DataTopic.customerLedger, DataTopic.customers},
      _onDataChanged,
    );
  }

  static const _defaultPageSize = 10;
  static const _fetchSize = 50;

  int _pageSize = _defaultPageSize;

  final GetCustomerUseCase _getCustomer;
  final GetCustomerBalanceUseCase _getBalance;
  final GetCustomerLedgerUseCase _getLedger;
  final RecordCustomerPaymentUseCase _recordPayment;
  final ReverseCustomerPaymentUseCase _reverse;
  final ShiftGuard _shifts;
  final ActiveBranchResolver _branchResolver;
  final KhataEvents _events;

  // One key per wrong payment + reason: a retry after a lost answer reuses it
  // so the payment can never be reversed twice.
  String? _reverseKey;
  String? _reverseFingerprint;

  String? _customerId;
  String? _branchId;

  /// The branch whose rows and balance are on screen (null: all branches).
  String? get branchId => _branchId;
  List<CustomerLedgerEntryModel> _allEntries = [];

  /// The ledger lines live on the server only. True while they could not be
  /// fetched because it is unreachable: the page then shows the customer and
  /// the balance from this device, and payments can still be taken.
  bool ledgerNeedsConnection = false;

  /// The last payment was saved on this device and waits for the next sync.
  bool lastPaymentSavedOffline = false;

  int paginationTotal(CustomerLedgerLoaded state) {
    if (state.hasMore) {
      return state.entries.length + state.pageSize;
    }
    return state.entries.length;
  }

  int totalPages(CustomerLedgerLoaded state) {
    return ClientTablePagination.totalPages(
      paginationTotal(state),
      state.pageSize,
    );
  }

  Future<void> setPageSize(int size) async {
    if (size < 1) return;
    final current = state;
    if (current is! CustomerLedgerLoaded || current.pageSize == size) return;
    _pageSize = size;
    emit(current.copyWith(pageSize: size, currentPage: 1));
  }

  Future<void> goToPage(int page) async {
    final current = state;
    if (current is! CustomerLedgerLoaded) return;

    final target = page.clamp(1, totalPages(current));
    if (target == current.currentPage) return;

    final needed = target * _pageSize;
    while (_allEntries.length < needed) {
      final latest = state;
      if (latest is! CustomerLedgerLoaded ||
          !latest.hasMore ||
          latest.isLoadingMore) {
        break;
      }
      await _fetchMore();
    }

    final updated = state;
    if (updated is CustomerLedgerLoaded) {
      emit(updated.copyWith(currentPage: target));
    }
  }

  void clearPaymentError() {
    final current = state;
    if (current is CustomerLedgerLoaded) {
      emit(current.copyWith(paymentError: null));
    }
  }

  Future<void> checkPaymentShift() async {
    final current = state;
    if (current is! CustomerLedgerLoaded) return;

    emit(
      current.copyWith(
        isCheckingPaymentShift: true,
        activePaymentShiftId: null,
      ),
    );

    final shiftId = await _resolveActiveShiftId();

    final updated = state;
    if (updated is CustomerLedgerLoaded) {
      emit(
        updated.copyWith(
          isCheckingPaymentShift: false,
          activePaymentShiftId: shiftId,
        ),
      );
    }
  }

  Future<String?> _resolveActiveShiftId() => _shifts.currentShiftId();

  /// One-tap "Open shift" from the "Open shift first" notice. Returns true when
  /// a shift is now open.
  Future<bool> openShiftForPayment() async {
    final current = state;
    if (current is! CustomerLedgerLoaded) return false;
    emit(current.copyWith(isOpeningPaymentShift: true, paymentError: null));
    final result = await _shifts.openNow();
    final updated = state;
    if (updated is! CustomerLedgerLoaded) return false;
    return result.fold(
      (failure) {
        emit(
          updated.copyWith(
            isOpeningPaymentShift: false,
            paymentError: failure.message,
          ),
        );
        return false;
      },
      (id) {
        emit(
          updated.copyWith(
            isOpeningPaymentShift: false,
            activePaymentShiftId: id,
            paymentError: null,
          ),
        );
        return true;
      },
    );
  }

  /// The branch every payment is recorded in: the one the ledger is showing,
  /// else the user's active branch. A payment with no branch would be
  /// business-wide on the server, so none is ever sent without one.
  Future<String?> _paymentBranch() async =>
      _branchId ?? await _branchResolver.resolve();

  Future<void> load(String customerId, {String? branchId}) async {
    _customerId = customerId;
    if (branchId != null) {
      _branchId = branchId;
    } else if (sl.isRegistered<BranchSelectorCubit>()) {
      _branchId = sl<BranchSelectorCubit>().state.selectedBranchId;
    }
    _allEntries = [];
    _pageSize = _defaultPageSize;
    ledgerNeedsConnection = false;
    final read = beginRead();
    emit(const CustomerLedgerState.loading());

    final customerResult = await _getCustomer(customerId);
    if (isStale(read)) return;
    await customerResult.fold(
      (failure) async => emit(CustomerLedgerState.error(failure.message)),
      (customer) async {
        final balanceResult = await _getBalance(customerId, branchId: _branchId);
        final ledgerResult =
            await _getLedger(customerId, branchId: _branchId, skip: 0, limit: _fetchSize);
        final waiting = ledgerResult.isLeft()
            ? await _getLedger.pending(customerId, branchId: _branchId)
            : const <CustomerLedgerEntryModel>[];
        if (isStale(read)) return;

        balanceResult.fold(
          (failure) => emit(CustomerLedgerState.error(failure.message)),
          (balance) {
            ledgerResult.fold(
              (failure) {
                if (failure is! NetworkFailure) {
                  emit(CustomerLedgerState.error(failure.message));
                  return;
                }
                // Offline: the customer, the balance and the lines still
                // waiting to be sent are known on this device.
                ledgerNeedsConnection = true;
                _allEntries = _runningUpTo(waiting, balance.balance);
                emit(
                  CustomerLedgerState.loaded(
                    customer: customer,
                    balance: balance.balance,
                    entries: _computeDisplayRows(_allEntries),
                    hasMore: false,
                    currentPage: 1,
                    pageSize: _pageSize,
                  ),
                );
              },
              (page) {
                ledgerNeedsConnection = false;
                _allEntries = page;
                emit(
                  CustomerLedgerState.loaded(
                    customer: customer,
                    // The card shows what the newest line says, so the two
                    // can never disagree.
                    balance: _newestBalance(page) ?? balance.balance,
                    entries: _computeDisplayRows(_allEntries),
                    hasMore: _serverLines(page) >= _fetchSize,
                    currentPage: 1,
                    pageSize: _pageSize,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onDataChanged() async {
    final id = _customerId;
    if (id == null) return;
    switch (state) {
      case CustomerLedgerLoaded():
        await _reload();
      case CustomerLedgerLoading() || CustomerLedgerError():
        await load(id, branchId: _branchId);
      case CustomerLedgerInitial():
        break;
    }
  }

  /// Re-reads the customer, the lines and the balance together, without a
  /// spinner. The lines already on screen stay when the server cannot be read.
  ///
  /// The balance is the newest line's; [knownBalance] (the answer to a write
  /// just made) is next, then the balance read, then [backupBalance].
  Future<_Reread> _reload({String? knownBalance, String? backupBalance}) async {
    final id = _customerId;
    if (id == null || state is! CustomerLedgerLoaded) return _Reread.failed;
    final read = beginRead();
    final wanted = _serverLines(_allEntries);

    final rows = <CustomerLedgerEntryModel>[];
    var hasMore = false;
    Failure? failure;
    do {
      final result = await _getLedger(
        id,
        branchId: _branchId,
        skip: _serverLines(rows),
        limit: _fetchSize,
      );
      result.fold(
        (f) => failure = f,
        (page) {
          rows.addAll(page);
          hasMore = _serverLines(page) >= _fetchSize;
        },
      );
    } while (failure == null && hasMore && _serverLines(rows) < wanted);

    if (failure != null) {
      if (failure is! NetworkFailure) return _Reread.failed;
      await _showDeviceLines(id, read, fallback: knownBalance);
      return _Reread.offline;
    }

    var balance = _newestBalance(rows) ?? knownBalance;
    if (balance == null) {
      final fetched = await _getBalance(id, branchId: _branchId);
      balance = fetched.fold((_) => backupBalance, (b) => b.balance);
    }
    final customer = await _getCustomer(id);
    final latest = state;
    if (isStale(read) || latest is! CustomerLedgerLoaded) return _Reread.fresh;

    ledgerNeedsConnection = false;
    _allEntries = rows;
    _emitLines(
      latest.copyWith(
        customer: customer.fold((_) => latest.customer, (c) => c),
        balance: balance ?? latest.balance,
        hasMore: hasMore,
        isLoadingMore: false,
      ),
    );
    return _Reread.fresh;
  }

  /// The server cannot be read: keep its lines already loaded and put what
  /// this device has not sent yet on top of them.
  Future<void> _showDeviceLines(
    String id,
    int read, {
    String? fallback,
  }) async {
    ledgerNeedsConnection = true;
    final waiting = await _getLedger.pending(id, branchId: _branchId);
    final server = [
      for (final e in _allEntries)
        if (!e.isOnDeviceOnly) e,
    ];
    String? balance;
    final base = _newestBalance(
      _computeDisplayRows(server).map((r) => r.entry).toList(),
    );
    if (base != null) {
      var total = CustomerBalanceUtils.parseBalance(base);
      for (final e in waiting) {
        total += CustomerBalanceUtils.parseBalance(e.amount);
      }
      balance = DecimalUtils.format(total);
    } else {
      final fetched = await _getBalance(id, branchId: _branchId);
      balance = fetched.fold((_) => fallback, (b) => b.balance);
    }
    final latest = state;
    if (isStale(read) || latest is! CustomerLedgerLoaded) return;
    final shown = balance ?? latest.balance;
    _allEntries = [...server, ..._runningUpTo(waiting, shown)];
    _emitLines(latest.copyWith(balance: shown, isLoadingMore: false));
  }

  /// Emits [next] with the lines in [_allEntries]. A new line at the top
  /// brings the table back to its first page.
  void _emitLines(CustomerLedgerLoaded next) {
    final rows = _computeDisplayRows(_allEntries);
    final newTop = rows.isNotEmpty &&
        !next.entries.any((r) => r.entry.id == rows.first.entry.id);
    final shown = next.copyWith(entries: rows);
    emit(
      shown.copyWith(
        currentPage:
            newTop ? 1 : shown.currentPage.clamp(1, totalPages(shown)),
      ),
    );
  }

  static int _serverLines(List<CustomerLedgerEntryModel> rows) =>
      rows.where((e) => !e.isOnDeviceOnly).length;

  /// The balance after the newest line (lines arrive newest first).
  static String? _newestBalance(List<CustomerLedgerEntryModel> rows) {
    final value = rows.isEmpty ? null : rows.first.runningBalance;
    return value == null || value.isEmpty ? null : value;
  }

  /// [lines] (oldest first) with running balances that end at [balance].
  static List<CustomerLedgerEntryModel> _runningUpTo(
    List<CustomerLedgerEntryModel> lines,
    String balance,
  ) {
    var running = CustomerBalanceUtils.parseBalance(balance);
    final result = <CustomerLedgerEntryModel>[];
    for (final line in lines.reversed) {
      result.add(line.copyWith(runningBalance: DecimalUtils.format(running)));
      running -= CustomerBalanceUtils.parseBalance(line.amount);
    }
    return result;
  }

  Future<void> onBranchChanged(String? branchId) async {
    if (_customerId == null || branchId == _branchId) return;
    await load(_customerId!, branchId: branchId);
  }

  Future<CustomerPaymentResponseModel?> recordPayment({
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
  }) async {
    final current = state;
    if (current is! CustomerLedgerLoaded || _customerId == null) return null;

    emit(
      current.copyWith(
        isRecordingPayment: true,
        paymentError: null,
      ),
    );

    final branchId = await _paymentBranch();
    if (branchId == null) {
      emit(
        current.copyWith(
          isRecordingPayment: false,
          paymentError: KhataText.branchMissing,
        ),
      );
      return null;
    }

    String? registerShiftId;
    if (paymentMethod == PaymentMethods.cash) {
      // Cash goes into the drawer, so it needs an open shift. Never record it
      // silently without one: the till would not balance.
      registerShiftId = await _resolveActiveShiftId();
      if (registerShiftId == null) {
        emit(
          current.copyWith(
            isRecordingPayment: false,
            activePaymentShiftId: null,
            paymentError: KhataText.customerCashNeedsShiftTitle,
          ),
        );
        return null;
      }
    }

    final result = await _recordPayment(
      _customerId!,
      amount: amount,
      paymentMethod: paymentMethod,
      referenceNo: referenceNo,
      notes: notes,
      registerShiftId: registerShiftId,
      branchId: branchId,
    );

    return await result.fold(
      (failure) async {
        emit(
          current.copyWith(
            isRecordingPayment: false,
            paymentError: failure.message,
          ),
        );
        return null;
      },
      (response) async {
        _events.notifyChanged();
        // Saved: the new line and balance show at once, before any server
        // read.
        await _showSavedPayment(response);
        // The payment is saved. Re-reading the ledger is a courtesy: when
        // the server cannot be reached the lines on screen stay and no error
        // is shown for a payment that succeeded.
        final outcome = await _reload(
          knownBalance: response.newBalance,
        );
        lastPaymentSavedOffline = outcome == _Reread.offline;
        final latest = state;
        if (latest is! CustomerLedgerLoaded) return response;
        emit(
          latest.copyWith(
            isRecordingPayment: false,
            paymentError: null,
            activePaymentShiftId: registerShiftId,
          ),
        );
        return response.copyWith(newBalance: latest.balance);
      },
    );
  }

  /// Puts a payment just saved on this device on top of the ledger, with the
  /// balance it leads to. Does nothing when the line is already there (or the
  /// payment went straight to the server).
  Future<void> _showSavedPayment(CustomerPaymentResponseModel response) async {
    final waiting =
        await _getLedger.pending(_customerId!, branchId: _branchId);
    final latest = state;
    if (latest is! CustomerLedgerLoaded) return;
    final id = response.ledgerEntryId;
    if (_allEntries.any((e) => e.id == id)) return;
    for (final line in waiting) {
      if (line.id != id) continue;
      final balance = DecimalUtils.format(
        CustomerBalanceUtils.parseBalance(latest.balance) +
            CustomerBalanceUtils.parseBalance(line.amount),
      );
      _allEntries = [..._allEntries, line.copyWith(runningBalance: balance)];
      _emitLines(latest.copyWith(balance: balance));
      return;
    }
  }

  /// Reverses a customer payment. Returns null on success, else plain words for
  /// the dialog. The branch always travels with it; the server also checks it
  /// against the payment itself.
  Future<String?> reversePayment(String paymentId, String reason) async {
    final branch = await _paymentBranch();
    final body = <String, dynamic>{
      'reason': reason,
      if (branch != null) 'branch_id': branch,
    };
    final fingerprint = '$paymentId|$reason';
    if (fingerprint != _reverseFingerprint || _reverseKey == null) {
      _reverseFingerprint = fingerprint;
      _reverseKey = UuidUtils.v4();
    }
    final result = await _reverse(paymentId, body, idempotencyKey: _reverseKey);
    return result.fold(
      (failure) {
        final code = switch (failure) {
          ConflictFailure(:final code) => code,
          ServerFailure(:final code) => code,
          _ => null,
        };
        // A clear "no" means nothing changed: the next tap is a fresh try.
        if (failure is! NetworkFailure &&
            (code != null || failure is! ServerFailure)) {
          _reverseKey = null;
          _reverseFingerprint = null;
        }
        if (failure is NetworkFailure) return KhataText.offlineReverse;
        return KhataText.forCode(code) ?? failure.message;
      },
      (done) {
        _reverseKey = null;
        _reverseFingerprint = null;
        _events.notifyChanged();
        // The reversal row and the new balance appear in place.
        unawaited(_reload(backupBalance: done.balance.toString()));
        return null;
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! CustomerLedgerLoaded ||
        !current.hasMore ||
        current.isLoadingMore ||
        _customerId == null) {
      return;
    }
    await _fetchMore();
  }

  Future<void> _fetchMore() async {
    final current = state;
    if (current is! CustomerLedgerLoaded ||
        !current.hasMore ||
        current.isLoadingMore ||
        _customerId == null) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final result = await _getLedger(
      _customerId!,
      branchId: _branchId,
      skip: _serverLines(_allEntries),
      limit: _fetchSize,
    );

    result.fold(
      (failure) {
        emit(current.copyWith(isLoadingMore: false));
        emit(CustomerLedgerState.error(failure.message));
      },
      (page) {
        final known = {for (final e in _allEntries) e.id};
        _allEntries = [
          ..._allEntries,
          for (final e in page)
            if (!known.contains(e.id)) e,
        ];
        final latest = state;
        if (latest is! CustomerLedgerLoaded) return;
        emit(
          latest.copyWith(
            entries: _computeDisplayRows(_allEntries),
            isLoadingMore: false,
            hasMore: page.length >= _fetchSize,
          ),
        );
      },
    );
  }

  List<LedgerDisplayRow> _computeDisplayRows(
    List<CustomerLedgerEntryModel> entries,
  ) {
    final sorted = [...entries];
    sorted.sort((a, b) {
      // Lines not on the server yet come on top of everything it has.
      if (a.isOnDeviceOnly != b.isOnDeviceOnly) {
        return a.isOnDeviceOnly ? 1 : -1;
      }
      final aAt = a.entryAt ?? a.createdAt ?? '';
      final bAt = b.entryAt ?? b.createdAt ?? '';
      return aAt.compareTo(bAt);
    });

    // The server's running balance is the real one for the whole account. Only
    // when it is missing is it worked out here, from the rows loaded so far.
    var running = Decimal.zero;
    final withRunning = <({CustomerLedgerEntryModel entry, String running})>[];
    for (final entry in sorted) {
      running = running + CustomerBalanceUtils.parseBalance(entry.amount);
      final server = entry.runningBalance;
      withRunning.add((
        entry: entry,
        running: (server != null && server.isNotEmpty)
            ? server
            : DecimalUtils.format(running),
      ));
    }

    return withRunning.reversed
        .map(
          (row) => LedgerDisplayRow(
            entry: row.entry,
            runningBalance: row.running,
          ),
        )
        .toList();
  }
}
