// "Refresh" on a list that was never loaded loads it. Only the re-read that a
// change elsewhere triggers leaves such a list alone.

import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_state.dart';
import 'package:frantend/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:frantend/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_cubit.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_state.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';
import 'package:frantend/features/returns/data/datasources/returns_remote_datasource.dart';
import 'package:frantend/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_cubit.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_state.dart';
import 'package:frantend/features/roles/data/datasources/roles_remote_datasource.dart';
import 'package:frantend/features/roles/data/repositories/roles_repository_impl.dart';
import 'package:frantend/features/roles/domain/usecases/roles_usecases.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_cubit.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_state.dart';
import 'package:frantend/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:frantend/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_cubit.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_state.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/features/users/data/datasources/users_remote_datasource.dart';
import 'package:frantend/features/users/data/repositories/users_repository_impl.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_cubit.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_state.dart';

import '../helpers/fake_http.dart';
import '../helpers/fake_rest.dart';
import 'refresh_fixtures.dart';

const _errors = ErrorHandler();

void main() {
  useActiveBranch();

  late FakeRest server;
  setUp(() {
    server = FakeRest();
    for (final path in const [
      '/customers',
      '/suppliers',
      '/roles',
      '/users',
      '/purchases/orders',
      '/returns',
      '/expenses/categories',
      '/stock/balances',
    ]) {
      server.on('GET', path, (_) => <Object>[]);
    }
    for (final path in const ['/products', '/sales', '/expenses']) {
      server.on(
        'GET',
        path,
        (_) => {'items': <Object>[], 'total': 0, 'skip': 0, 'limit': 10},
      );
    }
  });

  /// [refresh] on a fresh [cubit] ends in a state of type [L].
  Future<void> loads<L>(dynamic cubit, Future<void> Function() refresh) async {
    addTearDown(() async => cubit.close());
    await refresh();
    expect(cubit.state, isA<L>(), reason: '${server.log}');
  }

  ProductsRepositoryImpl products() => ProductsRepositoryImpl(
        remoteDataSource: ProductsRemoteDataSourceImpl(server.client),
        localDataSource: NoProductCache(),
        connectivityProbe: FixedConnectivityProbe()
          ..set(ReachabilityStatus.online),
        errorHandler: _errors,
      );

  SuppliersRepositoryImpl suppliers() => SuppliersRepositoryImpl(
        remoteDataSource: SuppliersRemoteDataSourceImpl(server.client),
        errorHandler: _errors,
      );

  test('customers', () async {
    final repo = CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final cubit = CustomersListCubit(
      getCustomersUseCase: GetCustomersUseCase(repo),
      getCustomerBalanceUseCase: GetCustomerBalanceUseCase(repo),
      updateCustomerUseCase: UpdateCustomerUseCase(repo),
    );
    await loads<CustomersListLoaded>(cubit, cubit.refresh);
  });

  test('suppliers', () async {
    final repo = suppliers();
    final cubit = SuppliersListCubit(
      getSuppliersUseCase: GetSuppliersUseCase(repo),
      getSupplierBalanceUseCase: GetSupplierBalanceUseCase(repo),
      updateSupplierUseCase: UpdateSupplierUseCase(repo),
      deleteSupplierUseCase: DeleteSupplierUseCase(repo),
      createSupplierUseCase: CreateSupplierUseCase(repo),
    );
    await loads<SuppliersListLoaded>(cubit, cubit.refresh);
  });

  test('products', () async {
    final repo = products();
    final cubit = ProductsListCubit(
      getProductsUseCase: GetProductsUseCase(repo),
      deleteProductUseCase: DeleteProductUseCase(repo),
      updateProductUseCase: UpdateProductUseCase(repo),
      getProductByBarcodeUseCase: GetProductByBarcodeUseCase(repo),
      getProductByIdUseCase: GetProductByIdUseCase(repo),
    );
    await loads<ProductsListLoaded>(cubit, cubit.refresh);
  });

  test('purchase orders', () async {
    final repo = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
      lineEnricher:
          PurchaseOrderLineEnricher(GetProductByIdUseCase(products())),
    );
    final cubit = PurchaseOrdersListCubit(
      getPurchaseOrdersUseCase: GetPurchaseOrdersUseCase(repo),
      getSuppliersUseCase: GetSuppliersUseCase(suppliers()),
    );
    await loads<PurchaseOrdersListLoaded>(cubit, cubit.refresh);
  });

  test('inventory stock', () async {
    final repo = products();
    final cubit = InventoryStockCubit(
      getProductsUseCase: GetProductsUseCase(repo),
      getProductByIdUseCase: GetProductByIdUseCase(repo),
      getStockBalancesUseCase: GetStockBalancesUseCase(InventoryRepositoryImpl(
        remoteDataSource: InventoryRemoteDataSourceImpl(server.client),
        errorHandler: _errors,
      )),
    );
    await loads<InventoryStockLoaded>(cubit, cubit.refresh);
  });

  test('roles', () async {
    final repo = RolesRepositoryImpl(
      remoteDataSource: RolesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final cubit = RolesListCubit(
      getRolesUseCase: GetRolesUseCase(repo),
      deleteRoleUseCase: DeleteRoleUseCase(repo),
      authLocalDataSource: OwnerAuth(),
    );
    await loads<RolesListLoaded>(cubit, cubit.refresh);
  });

  test('users', () async {
    final repo = UsersRepositoryImpl(
      remoteDataSource: UsersRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final cubit = UsersListCubit(
      getUsersUseCase: GetUsersUseCase(repo),
      deleteUserUseCase: DeleteUserUseCase(repo),
      authLocalDataSource: OwnerAuth(),
    );
    await loads<UsersListLoaded>(cubit, cubit.refresh);
  });

  test('returns', () async {
    final cubit = ReturnsListCubit(
      getReturnsUseCase: GetReturnsUseCase(ReturnsRepositoryImpl(
        remoteDataSource: ReturnsRemoteDataSourceImpl(server.client),
        errorHandler: _errors,
      )),
      authLocalDataSource: OwnerAuth(),
    );
    await loads<ReturnsListLoaded>(cubit, cubit.refresh);
  });

  // Sales and expenses pick their dates when the screen opens, so their
  // unloaded case is a first load that failed.
  Future<void> failsThenLoads<L>(
    String path,
    dynamic cubit,
    Future<void> Function() open,
    Future<void> Function() refresh,
  ) async {
    server.on(
      'GET',
      path,
      (_) => jsonResponse({'detail': 'Down'}, status: 500),
    );
    await open();
    expect(cubit.state, isNot(isA<L>()));
    server.on(
      'GET',
      path,
      (_) => {'items': <Object>[], 'total': 0, 'skip': 0, 'limit': 10},
    );
    await loads<L>(cubit, refresh);
  }

  test('sales', () async {
    final repo = SalesRepositoryImpl(
      remoteDataSource: SalesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final cubit = SalesListCubit(
      getSalesUseCase: GetSalesUseCase(repo),
      getSaleByIdUseCase: GetSaleByIdUseCase(repo),
      getProductByIdUseCase: GetProductByIdUseCase(products()),
      authLocalDataSource: OwnerAuth(),
    );
    await failsThenLoads<SalesListLoaded>(
        '/sales', cubit, cubit.init, cubit.refresh);
  });

  test('expenses', () async {
    final repo = ExpensesRepositoryImpl(
      remoteDataSource: ExpensesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final cubit = ExpensesListCubit(
      getExpensesUseCase: GetExpensesUseCase(repo),
      getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase(repo),
      getSuppliersUseCase: GetSuppliersUseCase(suppliers()),
      deleteExpenseUseCase: DeleteExpenseUseCase(repo),
      authLocalDataSource: OwnerAuth(),
    );
    await failsThenLoads<ExpensesListLoaded>(
        '/expenses', cubit, cubit.init, cubit.refresh);
  });
}
