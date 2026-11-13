import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/data/repositories/sales_repository_impl.dart';

// Management-screen repositories keep their remote reads; the *writes the
// counter needs* go through the same single path as the POS: local record +
// outbox op in one transaction.
//
// Reads that have a copy on the device fall back to it when the server
// cannot be reached (and skip the attempt while the probe says "offline"),
// so a screen never shows a connection error for data it already has.

/// A local write failed. Only a database problem can land here; whatever it
/// is, the text shown must not be transport-library output.
Failure _localWriteFailure(Object error) => CacheFailure(
      UserErrorMessage.clean(
        '$error',
        fallback: 'Could not be saved on this device.',
      ),
    );

class OfflineCustomersRepository extends CustomersRepositoryImpl {
  OfflineCustomersRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
    required LocalCatalog catalog,
    bool Function()? isReachable,
  })  : _writer = writer,
        _catalog = catalog,
        _isReachable = isReachable;

  final OfflineWriter _writer;
  final LocalCatalog _catalog;
  final bool Function()? _isReachable;

  bool get _reachable => _isReachable?.call() ?? true;

  /// Server list when reachable, else the customers on this device (which
  /// include the ones created here and not synced yet).
  @override
  Future<Either<Failure, List<CustomerModel>>> getCustomers({
    String? search,
  }) async {
    if (_reachable) {
      final remote = await super.getCustomers(search: search);
      if (remote.isRight() || !_isNetwork(remote)) return remote;
    }
    return Right(await _catalog.customers(search: search));
  }

  @override
  Future<Either<Failure, CustomerModel>> getCustomer(String id) async {
    final local = await _catalog.customer(id);
    // Not on the server yet: only the device knows this customer.
    final localOnly =
        local != null && (await _catalog.unsyncedCustomerIds()).contains(id);
    if (_reachable && !localOnly) {
      final remote = await super.getCustomer(id);
      if (remote.isRight() || !_isNetwork(remote) || local == null) {
        return remote;
      }
    }
    return local == null
        ? const Left(NetworkFailure(UserErrorMessage.offline))
        : Right(local);
  }

  @override
  Future<Either<Failure, CustomerBalanceModel>> getCustomerBalance(
    String customerId,
  ) async {
    final known = await _catalog.customer(customerId) != null;
    final localOnly =
        known && (await _catalog.unsyncedCustomerIds()).contains(customerId);
    if (_reachable && !localOnly) {
      final remote = await super.getCustomerBalance(customerId);
      if (remote.isRight() || !_isNetwork(remote) || !known) return remote;
    }
    if (!known) return const Left(NetworkFailure(UserErrorMessage.offline));
    return Right(CustomerBalanceModel(
      customerId: customerId,
      balance: DecimalUtils.format(await _catalog.customerBalance(customerId)),
    ));
  }

  static bool _isNetwork(Either<Failure, Object?> result) =>
      result.fold((f) => f is NetworkFailure, (_) => false);

  @override
  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  ) async {
    try {
      final entity = await _writer.createCustomer(body);
      return Right(CustomerModel.fromJson(entity).copyWith(balance: '0.00'));
    } catch (e) {
      return Left(_localWriteFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerPaymentResponseModel>> recordPayment(
    String customerId, {
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
    String? registerShiftId,
  }) async {
    try {
      final ledgerId = await _writer.recordCustomerPayment(
        customerId: customerId,
        amount: amount,
        paymentMethod: paymentMethod,
        registerShiftId: registerShiftId,
        referenceNo: referenceNo,
        notes: notes,
      );
      return Right(CustomerPaymentResponseModel(
        ledgerEntryId: ledgerId,
        customerId: customerId,
        amount: DecimalUtils.format(amount),
        newBalance: DecimalUtils.format(await _catalog.customerBalance(customerId)),
      ));
    } catch (e) {
      return Left(_localWriteFailure(e));
    }
  }
}

class OfflineCashRegisterRepository extends CashRegisterRepositoryImpl {
  OfflineCashRegisterRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
    required LocalCatalog catalog,
    required SyncStore store,
    required Future<String?> Function() userId,
  })  : _writer = writer,
        _catalog = catalog,
        _store = store,
        _userId = userId;

  final OfflineWriter _writer;
  final LocalCatalog _catalog;
  final SyncStore _store;
  final Future<String?> Function() _userId;

  @override
  Future<Either<Failure, List<CashRegisterModel>>> getRegisters({String? branchId}) async =>
      Right(await _catalog.registers(branchId: branchId));

  @override
  Future<Either<Failure, RegisterShiftModel?>> getMyActiveShift() async {
    final user = await _userId();
    if (user == null) return const Right(null);
    final row = await _store.openShiftFor(user);
    return Right(row == null ? null : _catalog.shiftModel(row));
  }

  @override
  Future<Either<Failure, RegisterShiftModel>> openShift(
    Map<String, dynamic> body,
  ) async {
    final user = await _userId();
    if (user != null && await _store.openShiftFor(user) != null) {
      return const Left(ConflictFailure('You already have an open shift'));
    }
    final registerId = '${body['cash_register_id']}';
    CashRegisterModel? register;
    for (final r in await _catalog.registers()) {
      if (r.id == registerId) register = r;
    }
    final row = await _writer.openShift(
      registerId: registerId,
      registerName: register?.name,
      branchId: register?.branchId,
      openingFloat: Decimal.tryParse('${body['opening_float'] ?? 0}') ?? Decimal.zero,
      notes: body['notes'] as String?,
    );
    return Right(_catalog.shiftModel(row, register: register));
  }

  @override
  Future<Either<Failure, ShiftSummaryModel>> getShiftSummary(String shiftId) async {
    if (await _store.shift(shiftId) != null) {
      return Right(await _catalog.shiftSummary(shiftId));
    }
    return super.getShiftSummary(shiftId);
  }

  @override
  Future<Either<Failure, ShiftSummaryModel>> closeShift(
    String shiftId, {
    required String actualCash,
    String? notes,
  }) async {
    try {
      await _writer.closeShift(
        shiftId: shiftId,
        actualCash: Decimal.parse(actualCash),
        notes: notes,
      );
      return Right(await _catalog.shiftSummary(shiftId));
    } catch (e) {
      return Left(_localWriteFailure(e));
    }
  }
}

class OfflineExpensesRepository extends ExpensesRepositoryImpl {
  OfflineExpensesRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
    SyncStore? store,
  })  : _writer = writer,
        _store = store;

  final OfflineWriter _writer;
  final SyncStore? _store;

  static const categoriesKey = 'expense_categories_cache';

  /// The expense form needs the categories to save anything. The last list
  /// the server sent is kept on the device and used when it cannot be
  /// reached, so an expense can be recorded offline.
  @override
  Future<Either<Failure, List<ExpenseCategoryModel>>> getCategories() async {
    final remote = await super.getCategories();
    final store = _store;
    if (store == null) return remote;
    return remote.fold((failure) async {
      if (failure is! NetworkFailure) return Left(failure);
      final raw = await store.meta(categoriesKey);
      if (raw == null) return Left(failure);
      try {
        return Right([
          for (final c in jsonDecode(raw) as List)
            ExpenseCategoryModel.fromJson(Map<String, dynamic>.from(c as Map)),
        ]);
      } catch (_) {
        return Left(failure);
      }
    }, (categories) async {
      await store.setMeta(
        categoriesKey,
        jsonEncode([for (final c in categories) c.toJson()]),
      );
      return Right(categories);
    });
  }

  @override
  Future<Either<Failure, ExpenseModel>> createExpense(Map<String, dynamic> body) async {
    try {
      await _writer.createExpense(body);
      return Right(ExpenseModel(
        id: 'pending',
        branchId: '${body['branch_id']}',
        expenseCategoryId: '${body['expense_category_id']}',
        supplierId: body['supplier_id'] as String?,
        expenseNumber: 'Pending sync',
        description: body['description'] as String?,
        expenseDate: '${body['expense_date']}',
        amount: '${body['amount']}',
        taxAmount: '${body['tax_amount'] ?? '0'}',
      ));
    } catch (e) {
      return Left(_localWriteFailure(e));
    }
  }
}

class OfflineReturnsRepository extends ReturnsRepositoryImpl {
  OfflineReturnsRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
  }) : _writer = writer;

  final OfflineWriter _writer;

  @override
  Future<Either<Failure, SaleReturnResponseModel>> createReturn(
    Map<String, dynamic> body,
  ) async {
    try {
      final id = await _writer.createReturn(body);
      return Right(SaleReturnResponseModel(
        id: id,
        businessId: '',
        branchId: '${body['branch_id']}',
        saleId: body['sale_id'] as String?,
        customerId: body['customer_id'] as String?,
        returnNumber: 'Pending sync',
        reason: body['reason'] as String?,
      ));
    } catch (e) {
      return Left(_localWriteFailure(e));
    }
  }
}

class OfflineSalesRepository extends SalesRepositoryImpl {
  OfflineSalesRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
    required SyncStore store,
    bool Function()? isReachable,
  })  : _writer = writer,
        _store = store,
        _isReachable = isReachable;

  final OfflineWriter _writer;
  final SyncStore _store;
  final bool Function()? _isReachable;

  /// A sale made on this device is shown from the local record until the
  /// server has it (and again if the server cannot be reached; while the
  /// probe says "offline" the server is not even asked, so a reprint opens
  /// at once).
  @override
  Future<Either<Failure, SaleResponseModel>> getSaleById(String id) async {
    final local = await _store.sale(id);
    if (local != null &&
        (local['sync_state'] != 'synced' || _isReachable?.call() == false)) {
      return Right(LocalSaleMapper.toResponse(local));
    }
    final remote = await super.getSaleById(id);
    if (remote.isRight() || local == null) return remote;
    return Right(LocalSaleMapper.toResponse(local));
  }

  /// Void is only for sales the server already has; it is queued and applied
  /// on the next sync (the sale's shift must still be open, per the server).
  @override
  Future<Either<Failure, SaleResponseModel>> voidSale(String id) async {
    if (!await _writer.canVoid(id)) {
      return const Left(ValidationFailure(
        "This sale hasn't reached the server yet, so it can't be voided. "
        'Wait for it to sync, then void it.',
      ));
    }
    try {
      await _writer.voidSale(id);
      final current = await getSaleById(id);
      return current.map((s) => s.copyWith(saleStatus: 'voided'));
    } catch (e) {
      return Left(_localWriteFailure(e));
    }
  }
}
