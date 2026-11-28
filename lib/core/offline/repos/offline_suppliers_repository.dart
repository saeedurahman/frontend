import 'dart:io' show SocketException;

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/local_suppliers.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/supplier_text.dart';

/// Suppliers with an offline side, following the other offline repositories:
///
/// - the suppliers themselves are read from the device once it has pulled them
///   (new and edited ones included), from the server before that;
/// - balances and accounts are server-first and fall back to the device's copy
///   ("as of"); answers from the server get this device's unsent payments on
///   top;
/// - a new supplier, an edit or a payment made while the server can't be
///   reached is saved here and sent through the outbox;
/// - activating, deactivating, deleting and reversing need the internet.
class OfflineSuppliersRepository extends SuppliersRepositoryImpl {
  OfflineSuppliersRepository({
    required SuppliersRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
    required OfflineWriter writer,
    required LocalSupplierBook book,
    bool Function()? isReachable,
  })  : _source = remoteDataSource,
        _errors = errorHandler,
        _writer = writer,
        _book = book,
        _isReachable = isReachable,
        super(
          remoteDataSource: remoteDataSource,
          errorHandler: errorHandler,
        );

  final SuppliersRemoteDataSource _source;
  final ErrorHandler _errors;
  final OfflineWriter _writer;
  final LocalSupplierBook _book;
  final bool Function()? _isReachable;

  /// Keys of online payments nobody knows the outcome of: the server may have
  /// them, so they are never queued as well.
  final _unconfirmed = <String>{};

  bool get _reachable => _isReachable?.call() ?? true;

  static const _offline = NetworkFailure(UserErrorMessage.offline);

  static bool _isNetwork(Either<Failure, Object?> result) =>
      result.fold((f) => f is NetworkFailure, (_) => false);

  /// Keeping a copy must never spoil an answer the server gave.
  Future<void> _keep(Future<void> Function() write) async {
    try {
      await write();
    } catch (e) {
      AppLogger.warning('Local supplier write failed (${e.runtimeType})');
    }
  }

  // ── suppliers ──────────────────────────────────────────────────────────

  /// The device's suppliers, once it has pulled them. Before that the server
  /// is asked, with the ones added here on top of its answer.
  @override
  Future<Either<Failure, List<SupplierModel>>> getSuppliers() async {
    final local = await _book.suppliers();
    final pulled = await _book.asOf() != null;
    if (pulled && local.isNotEmpty) return Right(local);
    if (_reachable) {
      final remote = await super.getSuppliers();
      if (remote.isRight()) {
        final unsynced = await _book.unsyncedIds();
        return remote.map(
          (list) => [
            for (final s in local)
              if (unsynced.contains(s.id)) s,
            for (final s in list)
              if (!unsynced.contains(s.id)) s,
          ],
        );
      }
      if (!_isNetwork(remote)) return remote;
    }
    return local.isEmpty && !pulled ? const Left(_offline) : Right(local);
  }

  @override
  Future<Either<Failure, SupplierModel>> getSupplier(String id) async {
    final local = await _book.supplier(id);
    if (local != null &&
        (await _book.asOf() != null ||
            (await _book.unsyncedIds()).contains(id))) {
      return Right(local);
    }
    if (_reachable) {
      final remote = await super.getSupplier(id);
      if (remote.isRight() || !_isNetwork(remote)) return remote;
    }
    return local == null ? const Left(_offline) : Right(local);
  }

  /// Online, the server takes the new supplier. When it certainly never got
  /// the request, the supplier is saved here and queued.
  @override
  Future<Either<Failure, SupplierModel>> createSupplier(
    Map<String, dynamic> body,
  ) async {
    if (!_reachable) return _createHere(body);
    try {
      final created = await _source.createSupplier(body);
      await _keep(() => _book.saveFromServer(created));
      return Right(created);
    } catch (e) {
      if (neverSent(e)) return _createHere(body);
      return Left(_errors.mapExceptionToFailure(e));
    }
  }

  /// Activating and deactivating need the server. Other edits are queued while
  /// it can't be reached, and behind anything of this supplier still waiting,
  /// so that edits arrive in the order they were made.
  @override
  Future<Either<Failure, SupplierModel>> updateSupplier(
    String id,
    Map<String, dynamic> body,
  ) async {
    final waiting = (await _book.unsyncedIds()).contains(id);
    if (body.containsKey('is_active')) {
      if (waiting) return _refused(SupplierText.notSyncedYet);
      if (!_reachable) return _refused(SupplierText.statusNeedsInternet);
      final result = await _saved(await super.updateSupplier(id, body));
      return result.leftMap(
        (f) => f is NetworkFailure
            ? const NetworkFailure(SupplierText.statusNeedsInternet)
            : f,
      );
    }
    if (waiting || !_reachable) return _updateHere(id, body);
    try {
      final updated = await _source.updateSupplier(id, body);
      return await _saved(Right(updated));
    } catch (e) {
      if (neverSent(e)) return _updateHere(id, body);
      return Left(_errors.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(String id) async {
    if (await _book.isNewHere(id)) {
      return const Left(ValidationFailure(SupplierText.notSyncedYet));
    }
    if (!_reachable) {
      return const Left(NetworkFailure(SupplierText.deleteNeedsInternet));
    }
    final result = await super.deleteSupplier(id);
    if (result.isRight()) await _keep(() => _book.removeDeleted(id));
    return result.leftMap(
      (f) => f is NetworkFailure
          ? const NetworkFailure(SupplierText.deleteNeedsInternet)
          : f,
    );
  }

  static Either<Failure, SupplierModel> _refused(String message) =>
      Left(NetworkFailure(message));

  Future<Either<Failure, SupplierModel>> _saved(
    Either<Failure, SupplierModel> result,
  ) async {
    await result.fold(
      (_) async {},
      (supplier) => _keep(() => _book.saveFromServer(supplier)),
    );
    return result;
  }

  Future<Either<Failure, SupplierModel>> _createHere(
    Map<String, dynamic> body,
  ) =>
      _onDevice(() => _writer.createSupplier(body));

  Future<Either<Failure, SupplierModel>> _updateHere(
    String id,
    Map<String, dynamic> body,
  ) =>
      _onDevice(() => _writer.updateSupplier(id, body));

  Future<Either<Failure, SupplierModel>> _onDevice(
    Future<Map<String, dynamic>> Function() write,
  ) async {
    try {
      final row = await write();
      return Right((await _book.supplier('${row['id']}'))!);
    } on DuplicateSupplierException catch (e) {
      return Left(
        ValidationFailure(
          e.message,
          {e.field: e.message},
          SupplierText.duplicateCode,
        ),
      );
    } on SupplierInputException catch (e) {
      return Left(ValidationFailure(e.problems.values.first, e.problems));
    } on SupplierNotOnDeviceException {
      return const Left(NetworkFailure(SupplierText.notOnDevice));
    } catch (e) {
      AppLogger.warning('Supplier not saved (${e.runtimeType})');
      return const Left(CacheFailure(SupplierText.notSaved));
    }
  }

  // ── balance and account ────────────────────────────────────────────────

  @override
  Future<Either<Failure, SupplierBalanceModel>> getSupplierBalance(
    String supplierId, {
    String? branchId,
  }) async {
    if (_reachable && !await _book.isNewHere(supplierId)) {
      // Read before asking the server: a payment sent in between is then in
      // its answer.
      final unsent = await _book.pendingPaid(
        supplierId,
        branchId: branchId,
        unsentOnly: true,
      );
      final remote =
          await super.getSupplierBalance(supplierId, branchId: branchId);
      if (remote.isRight() || !_isNetwork(remote)) {
        return remote.map((b) => _adjusted(b, unsent));
      }
    }
    final balance = await _book.balance(supplierId);
    if (balance == null) return const Left(_offline);
    return Right(
      SupplierBalanceModel(
        supplierId: supplierId,
        balance: DecimalUtils.format(balance),
        balanceOwed: DecimalUtils.format(-balance),
        isAdvance: balance > Decimal.zero,
        asOf: await _book.asOf(),
      ),
    );
  }

  static SupplierBalanceModel _adjusted(
    SupplierBalanceModel b,
    Decimal paid,
  ) {
    if (paid == Decimal.zero) return b;
    final balance = (Decimal.tryParse(b.balance) ?? Decimal.zero) + paid;
    return b.copyWith(
      balance: DecimalUtils.format(balance),
      balanceOwed:
          b.balanceOwed == null ? null : DecimalUtils.format(-balance),
      isAdvance: balance > Decimal.zero,
    );
  }

  /// Offline the whole account is answered (every branch): the device only
  /// holds the balance over all of them.
  @override
  Future<Either<Failure, SupplierLedgerPage>> getLedger(
    String supplierId, {
    String? branchId,
    int skip = 0,
    int limit = 50,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    if (_reachable && !await _book.isNewHere(supplierId)) {
      final waiting = await _book.pendingEntries(
        supplierId,
        branchId: branchId,
        unsentOnly: true,
      );
      DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
      bool inDates(SupplierLedgerEntry e) {
        final at = e.entryAt;
        if (dateFrom == null && dateTo == null) return true;
        return at != null &&
            (dateFrom == null || !day(at).isBefore(day(dateFrom))) &&
            (dateTo == null || !day(at).isAfter(day(dateTo)));
      }

      final shown = waiting.where(inDates).length;
      // The waiting lines sit on top of the first page: later pages start
      // that many server rows earlier.
      final serverSkip = skip > shown ? skip - shown : 0;
      final remote = await super.getLedger(
        supplierId,
        branchId: branchId,
        skip: serverSkip,
        limit: limit,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      if (remote.isRight() || !_isNetwork(remote)) {
        return remote.map(
          (page) => _withWaiting(
            page,
            waiting,
            inDates,
            skip: skip,
            throughEnd: dateTo == null,
          ),
        );
      }
    }
    final local = await _book.ledger(
      supplierId,
      skip: skip,
      limit: limit,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    return local == null ? const Left(_offline) : Right(local);
  }

  /// The server's page with [waiting] (oldest first, not on the server yet) on
  /// top, each with its running balance.
  static SupplierLedgerPage _withWaiting(
    SupplierLedgerPage page,
    List<SupplierLedgerEntry> waiting,
    bool Function(SupplierLedgerEntry) inDates, {
    required int skip,
    required bool throughEnd,
  }) {
    final have = {for (final e in page.items) e.id};
    var running = page.balance;
    var inPeriod = Decimal.zero;
    final lines = <SupplierLedgerEntry>[];
    for (final e in waiting) {
      if (have.contains(e.id)) continue;
      running += e.amount;
      if (!inDates(e)) continue;
      inPeriod += e.amount;
      lines.add(
        e.onDevice(needsAttention: e.needsAttention, runningBalance: running),
      );
    }
    if (running == page.balance) return page;
    final closing = page.closingBalance;
    return SupplierLedgerPage(
      items: [if (skip == 0) ...lines.reversed, ...page.items],
      total: page.total + lines.length,
      skip: skip,
      limit: page.limit,
      balance: running,
      openingBalance: page.openingBalance,
      closingBalance: closing == null
          ? null
          : closing + (throughEnd ? running - page.balance : inPeriod),
    );
  }

  // ── money ──────────────────────────────────────────────────────────────

  /// Online, the server takes the payment. When it certainly never got the
  /// request (offline, or no connection could be made), the payment is saved
  /// here and queued. When it may have got it, it is not queued: the same
  /// key is offered to the server again instead, so it can't be paid twice.
  @override
  Future<Either<Failure, SupplierPaymentResult>> paySupplier(
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    final mayHaveArrived =
        idempotencyKey != null && _unconfirmed.contains(idempotencyKey);
    // The server does not have this supplier yet: the payment follows it.
    if (await _book.isNewHere('${body['supplier_id']}')) {
      return _queue(body, idempotencyKey);
    }
    if (!_reachable) {
      if (mayHaveArrived) return const Left(UnconfirmedPaymentFailure());
      return _queue(body, idempotencyKey);
    }
    try {
      final result = await _source.paySupplier(
        body,
        idempotencyKey: idempotencyKey,
      );
      _unconfirmed.remove(idempotencyKey);
      return Right(result);
    } catch (e) {
      final failure = _errors.mapExceptionToFailure(e);
      if (failure is NetworkFailure) {
        if (!mayHaveArrived && neverSent(e)) return _queue(body, idempotencyKey);
        if (idempotencyKey != null) _unconfirmed.add(idempotencyKey);
        return const Left(UnconfirmedPaymentFailure());
      }
      // A clear "no": nothing was paid under this key.
      if (failure is! ServerFailure || failure.code != null) {
        _unconfirmed.remove(idempotencyKey);
      }
      return Left(failure);
    }
  }

  /// True only when the connection was never made, so the server cannot have
  /// the request.
  static bool neverSent(Object error) {
    if (error is! DioException) return false;
    if (error.type == DioExceptionType.connectionTimeout) return true;
    final cause = error.error;
    if (cause is! SocketException) return false;
    final code = cause.osError?.errorCode;
    final text =
        '${cause.message} ${cause.osError?.message ?? ''}'.toLowerCase();
    // Refused, no route to it, or its name cannot be looked up (Windows and
    // POSIX error numbers).
    return const {10061, 1225, 10051, 10065, 11001, 111, 101, 113}
            .contains(code) ||
        text.contains('connection refused') ||
        text.contains('failed host lookup') ||
        text.contains('network is unreachable');
  }

  Future<Either<Failure, SupplierPaymentResult>> _queue(
    Map<String, dynamic> body,
    String? idempotencyKey,
  ) async {
    try {
      final supplierId = '${body['supplier_id']}';
      final before = await _book.balance(supplierId);
      final payload = await _writer.recordSupplierPayment(
        body,
        // The same try again is the same payment.
        id: idempotencyKey != null && isUuidV4(idempotencyKey)
            ? idempotencyKey
            : null,
      );
      final amount = khataDecimal(payload['amount']);
      final after = await _book.balance(supplierId);
      return Right(
        SupplierPaymentResult(
          id: '${payload['id']}',
          supplierId: supplierId,
          amount: amount,
          paymentSource:
              PaymentSource.fromApi('${payload['payment_source']}') ??
                  PaymentSource.drawer,
          reference: payload['reference'] as String?,
          note: payload['note'] as String?,
          entryAt: DateTime.tryParse('${payload['paid_at']}')?.toLocal(),
          registerShiftId: payload['register_shift_id'] as String?,
          balanceBefore: before ?? Decimal.zero,
          balance: after ?? Decimal.zero,
          isAdvance: (after ?? Decimal.zero) > Decimal.zero,
          balanceKnown: before != null && after != null,
          queued: true,
        ),
      );
    } on NoOpenShiftException {
      return const Left(
        ValidationFailure(
          KhataText.needsShiftBody,
          {},
          KhataText.noOpenShiftCode,
        ),
      );
    } catch (e) {
      AppLogger.warning('Supplier payment not saved (${e.runtimeType})');
      return const Left(CacheFailure('Could not be saved on this device.'));
    }
  }

  /// A reversal undoes money the server booked: only the server can do it.
  @override
  Future<Either<Failure, PaymentReversalResult>> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    if (!_reachable) {
      return const Left(NetworkFailure(KhataText.offlineReverse));
    }
    return super.reversePayment(
      paymentId,
      body,
      idempotencyKey: idempotencyKey,
    );
  }
}
