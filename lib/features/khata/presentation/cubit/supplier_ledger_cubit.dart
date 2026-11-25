import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    this.total = 0,
    this.loadingMore = false,
    this.dateFrom,
    this.dateTo,
    this.error,
    this.offline = false,
  });

  final bool loading;
  final SupplierModel? supplier;

  /// Newest first, as the server sends them.
  final List<SupplierLedgerEntry> entries;

  /// Whole-ledger balance (negative = you owe the supplier).
  final Decimal? balance;
  final int total;
  final bool loadingMore;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? error;

  /// The list could not be fetched because there is no internet.
  final bool offline;

  bool get hasMore => entries.length < total;
  bool get hasDateFilter => dateFrom != null || dateTo != null;
  Decimal get owed => (balance ?? Decimal.zero) < Decimal.zero
      ? -(balance ?? Decimal.zero)
      : Decimal.zero;
  Decimal get advance => (balance ?? Decimal.zero) > Decimal.zero
      ? balance!
      : Decimal.zero;

  /// The rows inside the chosen dates (the balance column stays the real one).
  List<SupplierLedgerEntry> get visible {
    if (!hasDateFilter) return entries;
    return entries.where((e) {
      final at = e.entryAt;
      if (at == null) return true;
      final day = DateTime(at.year, at.month, at.day);
      if (dateFrom != null && day.isBefore(_dayOf(dateFrom!))) return false;
      if (dateTo != null && day.isAfter(_dayOf(dateTo!))) return false;
      return true;
    }).toList();
  }

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  SupplierLedgerState copyWith({
    bool? loading,
    SupplierModel? supplier,
    List<SupplierLedgerEntry>? entries,
    Decimal? balance,
    int? total,
    bool? loadingMore,
    Object? dateFrom = _keep,
    Object? dateTo = _keep,
    Object? error = _keep,
    bool? offline,
  }) =>
      SupplierLedgerState(
        loading: loading ?? this.loading,
        supplier: supplier ?? this.supplier,
        entries: entries ?? this.entries,
        balance: balance ?? this.balance,
        total: total ?? this.total,
        loadingMore: loadingMore ?? this.loadingMore,
        dateFrom: identical(dateFrom, _keep) ? this.dateFrom : dateFrom as DateTime?,
        dateTo: identical(dateTo, _keep) ? this.dateTo : dateTo as DateTime?,
        error: identical(error, _keep) ? this.error : error as String?,
        offline: offline ?? this.offline,
      );
}

const Object _keep = Object();

/// The supplier account: balance, rows with running balance, a date filter and
/// "Reverse payment".
@injectable
class SupplierLedgerCubit extends Cubit<SupplierLedgerState> {
  SupplierLedgerCubit(
    this._getSupplier,
    this._getLedger,
    this._reverse,
    this._branch,
    this._events,
  ) : super(const SupplierLedgerState()) {
    _sub = _events.changes.listen((_) => refresh());
  }

  static const pageSize = 50;
  static const _maxRows = 2000;

  final GetSupplierUseCase _getSupplier;
  final GetSupplierLedgerUseCase _getLedger;
  final ReverseSupplierPaymentUseCase _reverse;
  final ActiveBranchResolver _branch;
  final KhataEvents _events;

  StreamSubscription<void>? _sub;
  String? _supplierId;
  String? _branchId;
  String? _reverseKey;
  String? _reverseFingerprint;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<void> load(String supplierId) async {
    _supplierId = supplierId;
    emit(const SupplierLedgerState());
    await refresh();
  }

  Future<void> refresh() async {
    final id = _supplierId;
    if (id == null) return;
    _branchId = await _branch.resolve();
    final supplier = await _getSupplier(id);
    if (isClosed) return;
    final page = await _getLedger(id, branchId: _branchId, limit: pageSize);
    if (isClosed) return;

    SupplierModel? model;
    supplier.fold((_) {}, (s) => model = s);
    page.fold(
      (failure) => emit(
        state.copyWith(
          loading: false,
          supplier: model,
          error: failure is NetworkFailure ? KhataText.offlineLedger : failure.message,
          offline: failure is NetworkFailure,
        ),
      ),
      (data) {
        emit(
          state.copyWith(
            loading: false,
            supplier: model,
            entries: data.items,
            balance: data.balance,
            total: data.total,
            error: null,
            offline: false,
          ),
        );
        if (state.hasDateFilter) unawaited(_loadAll());
      },
    );
  }

  Future<void> loadMore() async {
    final id = _supplierId;
    if (id == null || state.loadingMore || !state.hasMore) return;
    emit(state.copyWith(loadingMore: true));
    final page = await _getLedger(
      id,
      branchId: _branchId,
      skip: state.entries.length,
      limit: pageSize,
    );
    if (isClosed) return;
    page.fold(
      (failure) => emit(state.copyWith(loadingMore: false, error: failure.message)),
      (data) => emit(
        state.copyWith(
          loadingMore: false,
          entries: [...state.entries, ...data.items],
          balance: data.balance,
          total: data.total,
        ),
      ),
    );
  }

  Future<void> _loadAll() async {
    while (state.hasMore && state.entries.length < _maxRows && !isClosed) {
      final before = state.entries.length;
      await loadMore();
      if (state.entries.length == before) break;
    }
  }

  Future<void> setDates(DateTime? from, DateTime? to) async {
    emit(state.copyWith(dateFrom: from, dateTo: to));
    if (from != null || to != null) await _loadAll();
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
        final code = switch (failure) {
          ConflictFailure(:final code) => code,
          ServerFailure(:final code) => code,
          _ => null,
        };
        if (failure is! NetworkFailure && (code != null || failure is! ServerFailure)) {
          _reverseKey = null;
          _reverseFingerprint = null;
        }
        if (failure is NetworkFailure) return KhataText.offlineBody;
        return KhataText.forCode(code, failure.message) ?? failure.message;
      },
      (_) {
        _reverseKey = null;
        _reverseFingerprint = null;
        _events.drawerPayments.remove(paymentId);
        _events.notifyChanged();
        return null;
      },
    );
  }
}
