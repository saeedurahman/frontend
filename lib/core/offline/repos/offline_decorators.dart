import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/local_history.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/logger.dart';
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
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/sales/data/models/paginated_sales_model.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
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
    String customerId, {
    String? branchId,
  }) async {
    final known = await _catalog.customer(customerId) != null;
    final localOnly =
        known && (await _catalog.unsyncedCustomerIds()).contains(customerId);
    if (_reachable && !localOnly) {
      final remote = await super.getCustomerBalance(customerId, branchId: branchId);
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
    String? branchId,
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
    bool Function()? isReachable,
  })  : _writer = writer,
        _catalog = catalog,
        _store = store,
        _userId = userId,
        _isReachable = isReachable;

  final OfflineWriter _writer;
  final LocalCatalog _catalog;
  final SyncStore _store;
  final Future<String?> Function() _userId;
  final bool Function()? _isReachable;

  static const _notOnDevice =
      'This shift is not saved on this device. Connect to the internet to open it.';

  /// Shift history: the server's list when reachable (plus shifts only this
  /// device has), otherwise pulled + local shifts.
  @override
  Future<Either<Failure, List<RegisterShiftModel>>> getShifts({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  }) async {
    Future<Either<Failure, List<RegisterShiftModel>>> local() async => Right(
          await _catalog.shifts(
            branchId: branchId,
            registerId: registerId,
            status: status,
            skip: skip,
            limit: limit,
          ),
        );
    if (_isReachable?.call() == false) return local();
    final remote = await super.getShifts(
      branchId: branchId,
      registerId: registerId,
      status: status,
      skip: skip,
      limit: limit,
    );
    return remote.fold(
      (failure) => failure is NetworkFailure || failure is ServerFailure
          ? local()
          : Left(failure),
      (list) async {
        if (skip != 0) return Right(list);
        final known = {for (final s in list) s.id};
        final mine = <RegisterShiftModel>[];
        for (final row in await _store.shifts()) {
          if (row['sync_state'] == 'synced' || known.contains('${row['id']}')) continue;
          final s = await _catalog.shiftModelWithTotals(row);
          if ((branchId == null || s.branchId == branchId) &&
              (registerId == null || s.cashRegisterId == registerId) &&
              (status == null || s.status == status)) {
            mine.add(s);
          }
        }
        return Right([...mine, ...list]);
      },
    );
  }

  @override
  Future<Either<Failure, RegisterShiftModel>> getShiftById(String shiftId) async {
    final row = await _store.shift(shiftId);
    final offline = _isReachable?.call() == false;
    if (row != null && (row['sync_state'] != 'synced' || offline)) {
      return Right(await _catalog.shiftModelWithTotals(row));
    }
    if (!offline) {
      final remote = await super.getShiftById(shiftId);
      if (remote.isRight()) return remote;
    }
    final pulled = await _catalog.shiftById(shiftId);
    if (pulled != null) return Right(pulled);
    return const Left(NetworkFailure(_notOnDevice));
  }

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
    final local = await _store.shift(shiftId);
    final offline = _isReachable?.call() == false;
    if (local != null && (local['sync_state'] != 'synced' || offline)) {
      return Right(await _catalog.shiftSummary(shiftId));
    }
    if (!offline) {
      final remote = await super.getShiftSummary(shiftId);
      if (remote.isRight()) return remote;
    }
    if (local != null) return Right(await _catalog.shiftSummary(shiftId));
    final pulled = await _catalog.pulledShiftSummary(shiftId);
    if (pulled != null) return Right(pulled);
    return const Left(NetworkFailure(_notOnDevice));
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
        _history = LocalHistory(store),
        _isReachable = isReachable;

  final LocalHistory _history;

  /// Online: the server's page plus this device's unsent sales (so a sale
  /// never vanishes between "saved" and "synced"). Offline (or the server
  /// not answering): pulled recent sales merged with the local ones.
  @override
  Future<Either<Failure, PaginatedSalesModel>> getSales({
    String? branchId,
    String? customerId,
    String? status,
    String? saleType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    Future<Either<Failure, PaginatedSalesModel>> local() async => Right(
          await _history.sales(
            branchId: branchId,
            customerId: customerId,
            status: status,
            saleType: saleType,
            dateFrom: dateFrom,
            dateTo: dateTo,
            search: search,
            skip: skip,
            limit: limit,
          ),
        );
    if (_isReachable?.call() == false) return local();
    final remote = await super.getSales(
      branchId: branchId,
      customerId: customerId,
      status: status,
      saleType: saleType,
      dateFrom: dateFrom,
      dateTo: dateTo,
      search: search,
      skip: skip,
      limit: limit,
    );
    return remote.fold(
      (failure) => failure is NetworkFailure || failure is ServerFailure
          ? local()
          : Left(failure),
      (page) async {
        final remoteIds = {for (final i in page.items) i.id};
        for (final i in page.items) {
          SaleSyncBadges.set(i.id, SaleSyncBadge.none);
        }
        if (skip != 0 || status != null || (search ?? '').isNotEmpty) {
          return Right(page);
        }
        final pending = [
          for (final p in await _history.pendingOnly(
            branchId: branchId,
            customerId: customerId,
          ))
            if (!remoteIds.contains(p.id)) p,
        ];
        if (pending.isEmpty) return Right(page);
        return Right(page.copyWith(
          total: page.total + pending.length,
          items: [...pending, ...page.items],
        ));
      },
    );
  }

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
    // Not made here: a pulled summary answers while the server is out of
    // reach (no lines; the screen says full details need internet).
    if (local == null && _isReachable?.call() == false) {
      final summary = await _store.entity('sale_summary', id);
      if (summary != null) return Right(LocalSaleMapper.fromSummary(summary));
    }
    final remote = await super.getSaleById(id);
    if (remote.isRight()) return remote;
    if (local != null) return Right(LocalSaleMapper.toResponse(local));
    final summary = await _store.entity('sale_summary', id);
    if (summary != null) return Right(LocalSaleMapper.fromSummary(summary));
    return remote;
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

/// Products: **reading** works offline (list, detail, categories come from
/// the pulled catalog); editing stays online-only and says so plainly.
///
/// Every change the server accepts is written into the local catalog at once
/// (the POS grid, pickers and offline reads use that copy) and a pull is
/// requested to confirm it, so no screen has to wait for the next scheduled
/// pull to see what was just saved.
class OfflineProductsRepository extends ProductsRepositoryImpl {
  OfflineProductsRepository({
    required super.remoteDataSource,
    required super.localDataSource,
    required super.connectivityProbe,
    required super.errorHandler,
    required LocalCatalog catalog,
    bool Function()? isReachable,
    void Function()? afterWrite,
  })  : _catalog = catalog,
        _isReachable = isReachable,
        _afterWrite = afterWrite;

  final LocalCatalog _catalog;
  final bool Function()? _isReachable;

  /// Asks the sync engine for a pull (the server stays the source of truth).
  final void Function()? _afterWrite;

  bool get _offline => _isReachable?.call() == false;

  static bool _network(Failure f) => f is NetworkFailure || f is ServerFailure;

  /// Runs [write] after a successful server change. A failure here must never
  /// turn the server's success into an error on screen, so it is only logged.
  Future<void> _remember(Future<void> Function() write) async {
    try {
      await write();
    } catch (e) {
      AppLogger.warning('Local catalog write failed (${e.runtimeType})');
    }
    try {
      _afterWrite?.call();
    } catch (_) {}
  }

  Future<Either<Failure, T>> _after<T>(
    Either<Failure, T> result,
    Future<void> Function(T value) write,
  ) async {
    await result.fold((_) async {}, (value) => _remember(() => write(value)));
    return result;
  }

  @override
  Future<Either<Failure, PaginatedProductsModel>> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    bool? needsAttention,
    int skip = 0,
    int limit = 50,
  }) async {
    Future<Either<Failure, PaginatedProductsModel>> local() async => Right(
          await _catalog.products(
            needsAttention: needsAttention == true,
            search: search,
            categoryId: categoryId,
            activeOnly: isActive ?? false,
            skip: skip,
            limit: limit,
          ),
        );
    if (_offline) return local();
    final remote = await super.getProducts(
      categoryId: categoryId,
      brandId: brandId,
      isActive: isActive,
      search: search,
      needsAttention: needsAttention,
      skip: skip,
      limit: limit,
    );
    return remote.fold((f) => _network(f) ? local() : Left(f), (_) => remote);
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    Future<Either<Failure, ProductModel>> local(Failure original) async {
      final p = await _catalog.product(id);
      return p == null
          ? const Left(NetworkFailure(UserErrorMessage.offline))
          : Right(p);
    }

    if (_offline) return local(const NetworkFailure());
    final remote = await super.getProductById(id);
    return remote.fold((f) => _network(f) ? local(f) : Left(f), (_) => remote);
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories({String? parentId}) async {
    Future<Either<Failure, List<CategoryModel>>> local() async =>
        Right(await _catalog.categories(parentId: parentId));
    if (_offline) return local();
    final remote = await super.getCategories(parentId: parentId);
    return remote.fold((f) => _network(f) ? local() : Left(f), (_) => remote);
  }

  /// Nothing is queued: say so, so nobody thinks the product was saved.
  @override
  Future<Either<Failure, ProductModel>> createProduct(Map<String, dynamic> body) async {
    if (_offline) return const Left(NetworkFailure(OfflineMessages.editingNeedsInternet));
    final result = await super.createProduct(body);
    return _after(
      result.fold(
        (f) => f is NetworkFailure
            ? const Left<Failure, ProductModel>(
                NetworkFailure(OfflineMessages.editingNeedsInternet))
            : Left<Failure, ProductModel>(f),
        (_) => result,
      ),
      _catalog.rememberProduct,
    );
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    Map<String, dynamic> body,
  ) async =>
      _after(await super.updateProduct(id, body), _catalog.rememberProduct);

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async =>
      _after(await super.deleteProduct(id), (_) => _catalog.forgetProduct(id));

  @override
  Future<Either<Failure, VariationModel>> addVariation(
    String productId,
    Map<String, dynamic> body,
  ) async =>
      _after(
        await super.addVariation(productId, body),
        (v) => _catalog.rememberVariation(v, productId),
      );

  @override
  Future<Either<Failure, VariationModel>> updateVariation(
    String productId,
    String variationId,
    Map<String, dynamic> body,
  ) async =>
      _after(
        await super.updateVariation(productId, variationId, body),
        (v) => _catalog.rememberVariation(v, productId),
      );

  @override
  Future<Either<Failure, BarcodeModel>> addBarcode(
    String productId,
    Map<String, dynamic> body,
  ) async =>
      _after(await super.addBarcode(productId, body), _catalog.rememberBarcode);

  @override
  Future<Either<Failure, CategoryModel>> createCategory(Map<String, dynamic> body) async =>
      _after(await super.createCategory(body), _catalog.rememberCategory);

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async =>
      _after(await super.deleteCategory(id), (_) => _catalog.forgetCategory(id));

  @override
  Future<Either<Failure, BrandModel>> createBrand(Map<String, dynamic> body) async =>
      _after(await super.createBrand(body), _catalog.rememberBrand);

  @override
  Future<Either<Failure, void>> deleteBrand(String id) async =>
      _after(await super.deleteBrand(id), (_) => _catalog.forgetBrand(id));

  @override
  Future<Either<Failure, UnitModel>> createUnit(Map<String, dynamic> body) async =>
      _after(await super.createUnit(body), _catalog.rememberUnit);
}

/// Inventory: stock levels read from the pulled stock offline; adjustments
/// and movement history need the server.
class OfflineInventoryRepository extends InventoryRepositoryImpl {
  OfflineInventoryRepository({
    required super.remoteDataSource,
    required super.errorHandler,
    required LocalCatalog catalog,
    bool Function()? isReachable,
  })  : _catalog = catalog,
        _isReachable = isReachable;

  final LocalCatalog _catalog;
  final bool Function()? _isReachable;

  bool get _offline => _isReachable?.call() == false;

  static bool _network(Failure f) => f is NetworkFailure || f is ServerFailure;

  @override
  Future<Either<Failure, StockBalanceModel>> getStockBalance({
    required String branchId,
    required String productId,
    String? variationId,
  }) async {
    Future<Either<Failure, StockBalanceModel>> local() async {
      final qty = await _catalog.availableStock(branchId, productId, variationId: variationId);
      if (qty == null) return const Left(NetworkFailure(UserErrorMessage.offline));
      return Right(StockBalanceModel(
        productId: productId,
        variationId: variationId,
        branchId: branchId,
        currentQty: qty.toString(),
      ));
    }

    if (_offline) return local();
    final remote = await super.getStockBalance(
      branchId: branchId,
      productId: productId,
      variationId: variationId,
    );
    return remote.fold((f) => _network(f) ? local() : Left(f), (_) => remote);
  }

  @override
  Future<Either<Failure, List<StockBalanceModel>>> getStockBalances({
    required String branchId,
    List<String>? productIds,
  }) async {
    Future<Either<Failure, List<StockBalanceModel>>> local() async =>
        Right(await _catalog.stockBalances(branchId, productIds: productIds));
    if (_offline) return local();
    final remote = await super.getStockBalances(branchId: branchId, productIds: productIds);
    return remote.fold((f) => _network(f) ? local() : Left(f), (_) => remote);
  }
}
