import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

class SupplierLedgerState {
  const SupplierLedgerState({
    this.loading = true,
    this.supplier,
    this.entries = const [],
    this.balance,
    this.openingBalance,
    this.closingBalance,
    this.total = 0,
    this.loadingMore = false,
    this.dateFrom,
    this.dateTo,
    this.error,
    this.offline = false,
    this.asOf,
    this.olderNeedsInternet = false,
  });

  final bool loading;
  final SupplierModel? supplier;

  /// Newest first, as the server sends them (only the chosen dates).
  final List<SupplierLedgerEntry> entries;

  /// Before the first and after the last chosen day (ledger sign).
  final Decimal? openingBalance;
  final Decimal? closingBalance;

  /// Whole-ledger balance (negative = you owe the supplier).
  final Decimal? balance;
  final int total;
  final bool loadingMore;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? error;

  /// No internet, and this account is not saved on this device.
  final bool offline;

  /// Set when the account on screen is the device's copy: when that was last
  /// updated.
  final DateTime? asOf;

  /// The account goes further back than the device's copy on screen.
  final bool olderNeedsInternet;

  bool get hasMore => entries.length < total;
  bool get hasDateFilter => dateFrom != null || dateTo != null;

  /// Offline, with older entries missing, the start of a period can't be known.
  bool get openingNeedsInternet =>
      asOf != null && hasDateFilter && openingBalance == null;
  Decimal get owed => (balance ?? Decimal.zero) < Decimal.zero
      ? -(balance ?? Decimal.zero)
      : Decimal.zero;
  Decimal get advance => (balance ?? Decimal.zero) > Decimal.zero
      ? balance!
      : Decimal.zero;

  SupplierLedgerState copyWith({
    bool? loading,
    SupplierModel? supplier,
    List<SupplierLedgerEntry>? entries,
    Decimal? balance,
    Object? openingBalance = _keep,
    Object? closingBalance = _keep,
    int? total,
    bool? loadingMore,
    Object? dateFrom = _keep,
    Object? dateTo = _keep,
    Object? error = _keep,
    bool? offline,
    Object? asOf = _keep,
    bool? olderNeedsInternet,
  }) =>
      SupplierLedgerState(
        loading: loading ?? this.loading,
        supplier: supplier ?? this.supplier,
        entries: entries ?? this.entries,
        balance: balance ?? this.balance,
        openingBalance: identical(openingBalance, _keep)
            ? this.openingBalance
            : openingBalance as Decimal?,
        closingBalance: identical(closingBalance, _keep)
            ? this.closingBalance
            : closingBalance as Decimal?,
        total: total ?? this.total,
        loadingMore: loadingMore ?? this.loadingMore,
        dateFrom: identical(dateFrom, _keep) ? this.dateFrom : dateFrom as DateTime?,
        dateTo: identical(dateTo, _keep) ? this.dateTo : dateTo as DateTime?,
        error: identical(error, _keep) ? this.error : error as String?,
        offline: offline ?? this.offline,
        asOf: identical(asOf, _keep) ? this.asOf : asOf as DateTime?,
        olderNeedsInternet: olderNeedsInternet ?? this.olderNeedsInternet,
      );
}

const Object _keep = Object();

/// The supplier account: balance, rows with running balance, a date filter and
/// "Reverse payment".
@injectable
class SupplierLedgerCubit extends Cubit<SupplierLedgerState>
    with AutoRefresh<SupplierLedgerState> {
  SupplierLedgerCubit(
    this._getSupplier,
    this._getLedger,
    this._reverse,
    this._branch,
    this._events,
  ) : super(const SupplierLedgerState()) {
    watchData(
      const {DataTopic.supplierLedger, DataTopic.suppliers},
      () => _read(quiet: true),
    );
  }

  static const pageSize = 50;

  final GetSupplierUseCase _getSupplier;
  final GetSupplierLedgerUseCase _getLedger;
  final ReverseSupplierPaymentUseCase _reverse;
  final ActiveBranchResolver _branch;
  final KhataEvents _events;

  String? _supplierId;
  String? _branchId;

  /// The branch whose rows and balance are on screen.
  String? get branchId => _branchId;
  String? _reverseKey;
  String? _reverseFingerprint;
  StreamSubscription<ReachabilityStatus>? _connectivity;

  /// Reads again when the server comes back, so the device's copy is replaced.
  void watchConnectivity(ConnectivityProbe probe) {
    _connectivity?.cancel();
    _connectivity = probe.status.listen((status) {
      if (status != ReachabilityStatus.offline) _read(quiet: true);
    });
  }

  @override
  Future<void> close() {
    unawaited(_connectivity?.cancel() ?? Future<void>.value());
    return super.close();
  }

  Future<void> load(String supplierId) async {
    _supplierId = supplierId;
    emit(const SupplierLedgerState());
    await refresh();
  }

  /// Reads the account again. The rows on screen stay while it runs, and as
  /// many of them are read as were showing.
  Future<void> refresh() => _read(quiet: false);

  /// [quiet]: after a change elsewhere, a failure leaves the screen as it is.
  Future<void> _read({required bool quiet}) async {
    final id = _supplierId;
    if (id == null) return;
    final read = beginRead();
    final wanted = state.entries.length;
    _branchId = await _branch.resolve();
    final supplier = await _getSupplier(id);
    if (isStale(read)) return;
    final from = state.dateFrom;
    final to = state.dateTo;
    final page = await _getLedger(
      id,
      branchId: _branchId,
      limit: pageSize,
      dateFrom: from,
      dateTo: to,
    );
    if (isStale(read)) return;

    SupplierModel? model;
    supplier.fold((_) {}, (s) => model = s);
    await page.fold(
      (failure) async {
        if (quiet && state.balance != null) {
          emit(state.copyWith(loading: false, supplier: model));
          return;
        }
        emit(
          state.copyWith(
            loading: false,
            loadingMore: false,
            supplier: model,
            error: failure is NetworkFailure
                ? KhataText.offlineLedger
                : failure.message,
            offline: failure is NetworkFailure,
            // Nothing from the device is shown as the answer to this read.
            asOf: null,
            olderNeedsInternet: false,
          ),
        );
      },
      (data) async {
        // Rows and balance are replaced together, in one state.
        final entries = [...data.items];
        while (entries.length < wanted && entries.length < data.total) {
          final more = await _getLedger(
            id,
            branchId: _branchId,
            skip: entries.length,
            limit: pageSize,
            dateFrom: from,
            dateTo: to,
          );
          if (isStale(read)) return;
          final items = more.fold(
            (_) => const <SupplierLedgerEntry>[],
            (p) => p.items,
          );
          if (items.isEmpty) break;
          entries.addAll(items);
        }
        emit(
          state.copyWith(
            loading: false,
            loadingMore: false,
            supplier: model,
            entries: entries,
            balance: data.balance,
            openingBalance: data.openingBalance,
            closingBalance: data.closingBalance,
            total: data.total,
            error: null,
            offline: false,
            asOf: data.asOf,
            olderNeedsInternet: data.olderNeedsInternet,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final id = _supplierId;
    if (id == null || state.loadingMore || !state.hasMore) return;
    emit(state.copyWith(loadingMore: true));
    final from = state.dateFrom;
    final to = state.dateTo;
    final page = await _getLedger(
      id,
      branchId: _branchId,
      skip: state.entries.length,
      limit: pageSize,
      dateFrom: from,
      dateTo: to,
    );
    // The dates changed meanwhile: these rows belong to the old ones.
    if (isClosed || state.dateFrom != from || state.dateTo != to) return;
    page.fold(
      (failure) => emit(state.copyWith(loadingMore: false, error: failure.message)),
      (data) => emit(
        state.copyWith(
          loadingMore: false,
          // A line added meanwhile shifts the pages: no row twice.
          entries: [
            ...state.entries,
            for (final e in data.items)
              if (!state.entries.any((have) => have.id == e.id)) e,
          ],
          balance: data.balance,
          openingBalance: data.openingBalance,
          closingBalance: data.closingBalance,
          total: data.total,
          olderNeedsInternet: data.olderNeedsInternet,
        ),
      ),
    );
  }

  /// Reads the account for these days (both included). The old rows go at
  /// once: they are never shown under the new dates.
  Future<void> setDates(DateTime? from, DateTime? to) async {
    emit(
      state.copyWith(
        dateFrom: from,
        dateTo: to,
        entries: const [],
        total: 0,
        openingBalance: null,
        closingBalance: null,
        error: null,
        loadingMore: true,
        olderNeedsInternet: false,
      ),
    );
    await refresh();
  }

  Future<void> clearDates() => setDates(null, null);

  /// Reverses a payment. Returns null on success, else plain words for the
  /// dialog. Always sends the active branch.
  Future<String?> reversePayment(String paymentId, String reason) async {
    final branch = _branchId ?? await _branch.resolve();
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
        final code = failure.code;
        if (failure is! NetworkFailure && (code != null || failure is! ServerFailure)) {
          _reverseKey = null;
          _reverseFingerprint = null;
        }
        if (failure is NetworkFailure) return KhataText.offlineReverse;
        return KhataText.forCode(code) ?? failure.message;
      },
      (_) {
        _reverseKey = null;
        _reverseFingerprint = null;
        _events.notifyChanged();
        return null;
      },
    );
  }
}
