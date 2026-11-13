import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';

const _notAvailable = NotFoundFailure('Not available on this device yet');

/// Read-only products repository over the local database (POS side).
/// Anything that changes the catalog is not offline work and is refused.
class LocalProductsRepository implements ProductsRepository {
  LocalProductsRepository(this._catalog);
  final LocalCatalog _catalog;

  @override
  Future<Either<Failure, PaginatedProductsModel>> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      return Right(await _catalog.products(
        search: search,
        categoryId: categoryId,
        activeOnly: isActive ?? true,
        skip: skip,
        limit: limit,
      ));
    } catch (e) {
      return Left(CacheFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    try {
      final p = await _catalog.product(id);
      return p == null ? const Left(_notAvailable) : Right(p);
    } catch (e) {
      return Left(CacheFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductByBarcode(String barcode) async {
    final p = await _catalog.productByBarcode(barcode);
    return p == null ? const Left(NotFoundFailure('Barcode not found')) : Right(p);
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories({String? parentId}) async =>
      Right(await _catalog.categories(parentId: parentId));

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Catalog changes are not available offline');
}

class LocalInventoryRepository implements InventoryRepository {
  LocalInventoryRepository(this._catalog);
  final LocalCatalog _catalog;

  @override
  Future<Either<Failure, StockBalanceModel>> getStockBalance({
    required String branchId,
    required String productId,
    String? variationId,
  }) async {
    try {
      final qty = await _catalog.availableStock(branchId, productId, variationId: variationId);
      if (qty == null) return const Left(_notAvailable);
      return Right(StockBalanceModel(
        productId: productId,
        variationId: variationId,
        branchId: branchId,
        currentQty: qty.toString(),
      ));
    } catch (e) {
      // A repository answers with a Failure; callers refresh in the
      // background and must not get an unhandled error.
      return Left(CacheFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, List<StockBalanceModel>>> getStockBalances({
    required String branchId,
    List<String>? productIds,
  }) async {
    try {
      return Right(await _catalog.stockBalances(branchId, productIds: productIds));
    } catch (e) {
      return Left(CacheFailure('$e'));
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Stock changes are not available offline');
}

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._catalog, this._store);
  final LocalCatalog _catalog;
  final SyncStore _store;

  static const cacheKey = 'settings_cache';

  @override
  Future<Either<Failure, List<TaxRateModel>>> getTaxRates() async =>
      Right(await _catalog.taxRates());

  /// Last copy of `GET /settings`, refreshed after each online sync.
  @override
  Future<Either<Failure, List<AppSettingModel>>> getSettings({String? branchId}) async {
    final raw = await _store.meta(cacheKey);
    if (raw == null) return const Right([]);
    try {
      return Right([
        for (final s in jsonDecode(raw) as List)
          AppSettingModel.fromJson(Map<String, dynamic>.from(s as Map)),
      ]);
    } catch (_) {
      return const Right([]);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Settings changes are not available offline');
}

class LocalCustomersRepository implements CustomersRepository {
  LocalCustomersRepository(this._catalog);
  final LocalCatalog _catalog;

  @override
  Future<Either<Failure, List<CustomerModel>>> getCustomers({String? search}) async =>
      Right(await _catalog.customers(search: search));

  @override
  Future<Either<Failure, CustomerModel>> getCustomer(String id) async {
    final c = await _catalog.customer(id);
    return c == null ? const Left(_notAvailable) : Right(c);
  }

  @override
  Future<Either<Failure, CustomerBalanceModel>> getCustomerBalance(String id) async =>
      Right(CustomerBalanceModel(
        customerId: id,
        balance: (await _catalog.customerBalance(id)).toString(),
      ));

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Not available offline');
}
