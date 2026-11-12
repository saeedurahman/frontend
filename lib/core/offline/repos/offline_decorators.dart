import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/data/repositories/sales_repository_impl.dart';

// Management-screen repositories keep their remote reads; the *writes the
// counter needs* go through the same single path as the POS: local record +
// outbox op in one transaction.

class OfflineCustomersRepository extends CustomersRepositoryImpl {
  OfflineCustomersRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
    required LocalCatalog catalog,
  })  : _writer = writer,
        _catalog = catalog;

  final OfflineWriter _writer;
  final LocalCatalog _catalog;

  @override
  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  ) async {
    try {
      final entity = await _writer.createCustomer(body);
      return Right(CustomerModel.fromJson(entity).copyWith(balance: '0.00'));
    } catch (e) {
      return Left(CacheFailure('$e'));
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
      return Left(CacheFailure('$e'));
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
      return Left(CacheFailure('$e'));
    }
  }
}

class OfflineExpensesRepository extends ExpensesRepositoryImpl {
  OfflineExpensesRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
  }) : _writer = writer;

  final OfflineWriter _writer;

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
      return Left(CacheFailure('$e'));
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
      return Left(CacheFailure('$e'));
    }
  }
}

class OfflineSalesRepository extends SalesRepositoryImpl {
  OfflineSalesRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required OfflineWriter writer,
    required SyncStore store,
  })  : _writer = writer,
        _store = store;

  final OfflineWriter _writer;
  final SyncStore _store;

  /// A sale made on this device is shown from the local record until the
  /// server has it (and again if the server cannot be reached).
  @override
  Future<Either<Failure, SaleResponseModel>> getSaleById(String id) async {
    final local = await _store.sale(id);
    if (local != null && local['sync_state'] != 'synced') {
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
      return Left(CacheFailure('$e'));
    }
  }
}
