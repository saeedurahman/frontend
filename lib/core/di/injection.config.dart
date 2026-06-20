// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/pin_login_usecase.dart' as _i564;
import '../../features/auth/domain/usecases/register_business_usecase.dart'
    as _i642;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/cash_register/data/datasources/cash_register_remote_datasource.dart'
    as _i493;
import '../../features/cash_register/data/repositories/cash_register_repository_impl.dart'
    as _i168;
import '../../features/cash_register/domain/repositories/cash_register_repository.dart'
    as _i950;
import '../../features/cash_register/domain/usecases/cash_register_usecases.dart'
    as _i820;
import '../../features/cash_register/presentation/cubit/close_shift_cubit.dart'
    as _i890;
import '../../features/cash_register/presentation/cubit/current_shift_cubit.dart'
    as _i937;
import '../../features/cash_register/presentation/cubit/shift_detail_cubit.dart'
    as _i981;
import '../../features/cash_register/presentation/cubit/shift_history_cubit.dart'
    as _i220;
import '../../features/customers/data/datasources/customers_remote_datasource.dart'
    as _i969;
import '../../features/customers/data/repositories/customers_repository_impl.dart'
    as _i948;
import '../../features/customers/domain/repositories/customers_repository.dart'
    as _i875;
import '../../features/customers/domain/usecases/customer_usecases.dart'
    as _i449;
import '../../features/customers/domain/usecases/record_customer_payment_usecase.dart'
    as _i640;
import '../../features/customers/presentation/cubit/customer_form_cubit.dart'
    as _i304;
import '../../features/customers/presentation/cubit/customer_ledger_cubit.dart'
    as _i1045;
import '../../features/customers/presentation/cubit/customers_list_cubit.dart'
    as _i997;
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i817;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart'
    as _i1062;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
import '../../features/expenses/data/datasources/expenses_remote_datasource.dart'
    as _i447;
import '../../features/expenses/data/repositories/expenses_repository_impl.dart'
    as _i961;
import '../../features/expenses/domain/repositories/expenses_repository.dart'
    as _i321;
import '../../features/expenses/domain/usecases/expenses_usecases.dart' as _i9;
import '../../features/expenses/presentation/cubit/expense_categories_cubit.dart'
    as _i642;
import '../../features/expenses/presentation/cubit/expense_detail_cubit.dart'
    as _i1066;
import '../../features/expenses/presentation/cubit/expense_form_cubit.dart'
    as _i626;
import '../../features/expenses/presentation/cubit/expenses_list_cubit.dart'
    as _i489;
import '../../features/inventory/data/datasources/inventory_remote_datasource.dart'
    as _i103;
import '../../features/inventory/data/repositories/inventory_repository_impl.dart'
    as _i572;
import '../../features/inventory/domain/repositories/inventory_repository.dart'
    as _i422;
import '../../features/inventory/domain/usecases/inventory_usecases.dart'
    as _i380;
import '../../features/inventory/presentation/cubit/inventory_stock_cubit.dart'
    as _i296;
import '../../features/inventory/presentation/cubit/stock_movements_cubit.dart'
    as _i981;
import '../../features/pos/data/datasources/pos_remote_datasource.dart'
    as _i449;
import '../../features/pos/data/repositories/pos_repository_impl.dart' as _i84;
import '../../features/pos/domain/repositories/pos_repository.dart' as _i511;
import '../../features/pos/domain/usecases/pos_usecases.dart' as _i698;
import '../../features/pos/presentation/cubit/customer_picker_cubit.dart'
    as _i993;
import '../../features/pos/presentation/cubit/pos_cubit.dart' as _i312;
import '../../features/products/data/datasources/products_local_datasource.dart'
    as _i994;
import '../../features/products/data/datasources/products_remote_datasource.dart'
    as _i255;
import '../../features/products/data/repositories/products_repository_impl.dart'
    as _i1045;
import '../../features/products/domain/repositories/products_repository.dart'
    as _i27;
import '../../features/products/domain/usecases/add_barcode_usecase.dart'
    as _i347;
import '../../features/products/domain/usecases/add_variation_usecase.dart'
    as _i1053;
import '../../features/products/domain/usecases/create_brand_usecase.dart'
    as _i673;
import '../../features/products/domain/usecases/create_category_usecase.dart'
    as _i282;
import '../../features/products/domain/usecases/create_product_usecase.dart'
    as _i460;
import '../../features/products/domain/usecases/create_unit_usecase.dart'
    as _i679;
import '../../features/products/domain/usecases/delete_product_usecase.dart'
    as _i913;
import '../../features/products/domain/usecases/get_brands_usecase.dart'
    as _i546;
import '../../features/products/domain/usecases/get_categories_usecase.dart'
    as _i583;
import '../../features/products/domain/usecases/get_product_by_barcode_usecase.dart'
    as _i59;
import '../../features/products/domain/usecases/get_product_by_id_usecase.dart'
    as _i341;
import '../../features/products/domain/usecases/get_products_usecase.dart'
    as _i15;
import '../../features/products/domain/usecases/get_units_usecase.dart'
    as _i835;
import '../../features/products/domain/usecases/update_product_usecase.dart'
    as _i73;
import '../../features/products/presentation/cubit/brands_cubit.dart' as _i804;
import '../../features/products/presentation/cubit/categories_cubit.dart'
    as _i369;
import '../../features/products/presentation/cubit/product_form_cubit.dart'
    as _i146;
import '../../features/products/presentation/cubit/products_list_cubit.dart'
    as _i238;
import '../../features/products/presentation/cubit/units_cubit.dart' as _i700;
import '../../features/purchases/data/datasources/purchases_remote_datasource.dart'
    as _i212;
import '../../features/purchases/data/repositories/purchases_repository_impl.dart'
    as _i652;
import '../../features/purchases/domain/repositories/purchases_repository.dart'
    as _i363;
import '../../features/purchases/domain/usecases/purchase_usecases.dart'
    as _i838;
import '../../features/purchases/presentation/cubit/goods_receipt_cubit.dart'
    as _i698;
import '../../features/purchases/presentation/cubit/purchase_order_detail_cubit.dart'
    as _i909;
import '../../features/purchases/presentation/cubit/purchase_order_form_cubit.dart'
    as _i242;
import '../../features/purchases/presentation/cubit/purchase_orders_list_cubit.dart'
    as _i483;
import '../../features/register/data/repositories/register_repository_impl.dart'
    as _i68;
import '../../features/register/domain/repositories/register_repository.dart'
    as _i994;
import '../../features/register/presentation/cubit/register_cubit.dart'
    as _i266;
import '../../features/returns/data/datasources/returns_remote_datasource.dart'
    as _i745;
import '../../features/returns/data/repositories/returns_repository_impl.dart'
    as _i253;
import '../../features/returns/domain/repositories/returns_repository.dart'
    as _i899;
import '../../features/returns/domain/usecases/returns_usecases.dart' as _i956;
import '../../features/returns/presentation/cubit/process_return_cubit.dart'
    as _i125;
import '../../features/sales/data/datasources/sales_remote_datasource.dart'
    as _i1019;
import '../../features/sales/data/repositories/sales_repository_impl.dart'
    as _i779;
import '../../features/sales/domain/repositories/sales_repository.dart'
    as _i434;
import '../../features/sales/domain/usecases/sales_usecases.dart' as _i873;
import '../../features/sales/presentation/cubit/sale_detail_cubit.dart'
    as _i830;
import '../../features/sales/presentation/cubit/sales_list_cubit.dart' as _i495;
import '../../features/settings/data/datasources/settings_remote_datasource.dart'
    as _i140;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/settings_usecases.dart'
    as _i279;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/suppliers/data/datasources/suppliers_remote_datasource.dart'
    as _i816;
import '../../features/suppliers/data/repositories/suppliers_repository_impl.dart'
    as _i202;
import '../../features/suppliers/domain/repositories/suppliers_repository.dart'
    as _i686;
import '../../features/suppliers/domain/usecases/supplier_usecases.dart'
    as _i877;
import '../../features/suppliers/presentation/cubit/supplier_form_cubit.dart'
    as _i591;
import '../../features/suppliers/presentation/cubit/suppliers_list_cubit.dart'
    as _i507;
import '../database/app_database.dart' as _i982;
import '../database/daos/master_data_cache_dao.dart' as _i15;
import '../database/daos/pending_sales_dao.dart' as _i842;
import '../database/daos/products_dao.dart' as _i839;
import '../database/daos/sales_dao.dart' as _i340;
import '../database/daos/sync_queue_dao.dart' as _i428;
import '../error/error_handler.dart' as _i308;
import '../localization/locale_cubit.dart' as _i960;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../router/route_guards.dart' as _i525;
import '../storage/preferences_storage.dart' as _i574;
import '../storage/secure_storage.dart' as _i619;
import '../sync/conflict_resolver.dart' as _i50;
import '../sync/sync_manager.dart' as _i417;
import '../sync/sync_queue.dart' as _i554;
import '../sync/sync_worker.dart' as _i987;
import 'database_module.dart' as _i384;
import 'dio_module.dart' as _i1045;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final preferencesModule = _$PreferencesModule();
    final connectivityModule = _$ConnectivityModule();
    final databaseModule = _$DatabaseModule();
    final dioModule = _$DioModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => preferencesModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i982.AppDatabase>(() => _i982.AppDatabase());
    gh.lazySingleton<_i308.ErrorHandler>(() => const _i308.ErrorHandler());
    gh.lazySingleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.lazySingleton<_i619.SecureStorage>(() => _i619.SecureStorage());
    gh.lazySingleton<_i50.ConflictResolver>(() => _i50.ConflictResolver());
    gh.lazySingleton<_i574.PreferencesStorage>(
      () => _i574.PreferencesStorage(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i428.SyncQueueDao>(
      () => databaseModule.syncQueueDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i839.ProductsDao>(
      () => databaseModule.productsDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i15.MasterDataCacheDao>(
      () => databaseModule.masterDataCacheDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i340.SalesDao>(
      () => databaseModule.salesDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i842.PendingSalesDao>(
      () => databaseModule.pendingSalesDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(
        gh<_i619.SecureStorage>(),
        gh<_i982.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i525.AuthGuard>(
      () => _i525.AuthGuard(gh<_i619.SecureStorage>()),
    );
    gh.lazySingleton<_i994.ProductsLocalDataSource>(
      () => _i994.ProductsLocalDataSourceImpl(gh<_i15.MasterDataCacheDao>()),
    );
    gh.lazySingleton<_i554.SyncQueue>(
      () => _i554.SyncQueue(gh<_i428.SyncQueueDao>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        secureStorage: gh<_i619.SecureStorage>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        syncQueue: gh<_i554.SyncQueue>(),
      ),
    );
    gh.lazySingleton<_i745.ReturnsRemoteDataSource>(
      () => _i745.ReturnsRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i816.SuppliersRemoteDataSource>(
      () => _i816.SuppliersRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i969.CustomersRemoteDataSource>(
      () => _i969.CustomersRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.factory<_i960.LocaleCubit>(
      () => _i960.LocaleCubit(gh<_i574.PreferencesStorage>()),
    );
    gh.lazySingleton<_i875.CustomersRepository>(
      () => _i948.CustomersRepositoryImpl(
        remoteDataSource: gh<_i969.CustomersRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.factory<_i449.GetCustomersUseCase>(
      () => _i449.GetCustomersUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.factory<_i449.GetCustomerUseCase>(
      () => _i449.GetCustomerUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.factory<_i449.CreateCustomerUseCase>(
      () => _i449.CreateCustomerUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.factory<_i449.UpdateCustomerUseCase>(
      () => _i449.UpdateCustomerUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.factory<_i449.GetCustomerBalanceUseCase>(
      () => _i449.GetCustomerBalanceUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.factory<_i449.GetCustomerLedgerUseCase>(
      () => _i449.GetCustomerLedgerUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.factory<_i640.RecordCustomerPaymentUseCase>(
      () => _i640.RecordCustomerPaymentUseCase(gh<_i875.CustomersRepository>()),
    );
    gh.lazySingleton<_i899.ReturnsRepository>(
      () => _i253.ReturnsRepositoryImpl(
        remoteDataSource: gh<_i745.ReturnsRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.factory<_i956.CreateSaleReturnUseCase>(
      () => _i956.CreateSaleReturnUseCase(gh<_i899.ReturnsRepository>()),
    );
    gh.factory<_i956.GetReturnsUseCase>(
      () => _i956.GetReturnsUseCase(gh<_i899.ReturnsRepository>()),
    );
    gh.factory<_i956.GetReturnByIdUseCase>(
      () => _i956.GetReturnByIdUseCase(gh<_i899.ReturnsRepository>()),
    );
    gh.lazySingleton<_i447.ExpensesRemoteDataSource>(
      () => _i447.ExpensesRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i817.DashboardRemoteDataSource>(
      () => _i817.DashboardRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i686.SuppliersRepository>(
      () => _i202.SuppliersRepositoryImpl(
        remoteDataSource: gh<_i816.SuppliersRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i103.InventoryRemoteDataSource>(
      () => _i103.InventoryRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i255.ProductsRemoteDataSource>(
      () => _i255.ProductsRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i140.SettingsRemoteDataSource>(
      () => _i140.SettingsRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i321.ExpensesRepository>(
      () => _i961.ExpensesRepositoryImpl(
        remoteDataSource: gh<_i447.ExpensesRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i27.ProductsRepository>(
      () => _i1045.ProductsRepositoryImpl(
        remoteDataSource: gh<_i255.ProductsRemoteDataSource>(),
        localDataSource: gh<_i994.ProductsLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i1019.SalesRemoteDataSource>(
      () => _i1019.SalesRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio(gh<_i667.DioClient>()));
    gh.lazySingleton<_i422.InventoryRepository>(
      () => _i572.InventoryRepositoryImpl(
        remoteDataSource: gh<_i103.InventoryRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(
        remoteDataSource: gh<_i140.SettingsRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i493.CashRegisterRemoteDataSource>(
      () => _i493.CashRegisterRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.factory<_i997.CustomersListCubit>(
      () => _i997.CustomersListCubit(
        getCustomersUseCase: gh<_i449.GetCustomersUseCase>(),
        getCustomerBalanceUseCase: gh<_i449.GetCustomerBalanceUseCase>(),
        updateCustomerUseCase: gh<_i449.UpdateCustomerUseCase>(),
      ),
    );
    gh.lazySingleton<_i434.SalesRepository>(
      () => _i779.SalesRepositoryImpl(
        remoteDataSource: gh<_i1019.SalesRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i212.PurchasesRemoteDataSource>(
      () => _i212.PurchasesRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i417.SyncManager>(
      () => _i417.SyncManager(
        dioClient: gh<_i667.DioClient>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        syncQueue: gh<_i554.SyncQueue>(),
        syncQueueDao: gh<_i428.SyncQueueDao>(),
        conflictResolver: gh<_i50.ConflictResolver>(),
        preferencesStorage: gh<_i574.PreferencesStorage>(),
      ),
    );
    gh.lazySingleton<_i449.PosRemoteDataSource>(
      () => _i449.PosRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.factory<_i877.GetSuppliersUseCase>(
      () => _i877.GetSuppliersUseCase(gh<_i686.SuppliersRepository>()),
    );
    gh.factory<_i877.GetSupplierUseCase>(
      () => _i877.GetSupplierUseCase(gh<_i686.SuppliersRepository>()),
    );
    gh.factory<_i877.CreateSupplierUseCase>(
      () => _i877.CreateSupplierUseCase(gh<_i686.SuppliersRepository>()),
    );
    gh.factory<_i877.UpdateSupplierUseCase>(
      () => _i877.UpdateSupplierUseCase(gh<_i686.SuppliersRepository>()),
    );
    gh.factory<_i877.DeleteSupplierUseCase>(
      () => _i877.DeleteSupplierUseCase(gh<_i686.SuppliersRepository>()),
    );
    gh.factory<_i877.GetSupplierBalanceUseCase>(
      () => _i877.GetSupplierBalanceUseCase(gh<_i686.SuppliersRepository>()),
    );
    gh.factory<_i873.GetSalesUseCase>(
      () => _i873.GetSalesUseCase(gh<_i434.SalesRepository>()),
    );
    gh.factory<_i873.GetSaleByIdUseCase>(
      () => _i873.GetSaleByIdUseCase(gh<_i434.SalesRepository>()),
    );
    gh.factory<_i873.CancelSaleUseCase>(
      () => _i873.CancelSaleUseCase(gh<_i434.SalesRepository>()),
    );
    gh.factory<_i15.GetProductsUseCase>(
      () => _i15.GetProductsUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i347.AddBarcodeUseCase>(
      () => _i347.AddBarcodeUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i1053.AddVariationUseCase>(
      () => _i1053.AddVariationUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i673.CreateBrandUseCase>(
      () => _i673.CreateBrandUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i282.CreateCategoryUseCase>(
      () => _i282.CreateCategoryUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i460.CreateProductUseCase>(
      () => _i460.CreateProductUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i679.CreateUnitUseCase>(
      () => _i679.CreateUnitUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i913.DeleteProductUseCase>(
      () => _i913.DeleteProductUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i546.GetBrandsUseCase>(
      () => _i546.GetBrandsUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i583.GetCategoriesUseCase>(
      () => _i583.GetCategoriesUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i59.GetProductByBarcodeUseCase>(
      () => _i59.GetProductByBarcodeUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i341.GetProductByIdUseCase>(
      () => _i341.GetProductByIdUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i835.GetUnitsUseCase>(
      () => _i835.GetUnitsUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i73.UpdateProductUseCase>(
      () => _i73.UpdateProductUseCase(gh<_i27.ProductsRepository>()),
    );
    gh.factory<_i238.ProductsListCubit>(
      () => _i238.ProductsListCubit(
        getProductsUseCase: gh<_i15.GetProductsUseCase>(),
        deleteProductUseCase: gh<_i913.DeleteProductUseCase>(),
        updateProductUseCase: gh<_i73.UpdateProductUseCase>(),
        getProductByBarcodeUseCase: gh<_i59.GetProductByBarcodeUseCase>(),
      ),
    );
    gh.factory<_i304.CustomerFormCubit>(
      () => _i304.CustomerFormCubit(
        getCustomerUseCase: gh<_i449.GetCustomerUseCase>(),
        createCustomerUseCase: gh<_i449.CreateCustomerUseCase>(),
        updateCustomerUseCase: gh<_i449.UpdateCustomerUseCase>(),
      ),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i380.GetStockBalanceUseCase>(
      () => _i380.GetStockBalanceUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.factory<_i380.GetStockBalancesUseCase>(
      () => _i380.GetStockBalancesUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.factory<_i380.GetStockMovementsUseCase>(
      () => _i380.GetStockMovementsUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.factory<_i380.CreateStockAdjustmentUseCase>(
      () => _i380.CreateStockAdjustmentUseCase(gh<_i422.InventoryRepository>()),
    );
    gh.factory<_i279.GetBusinessProfileUseCase>(
      () => _i279.GetBusinessProfileUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.UpdateBusinessProfileUseCase>(
      () => _i279.UpdateBusinessProfileUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.GetSettingsUseCase>(
      () => _i279.GetSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.BulkUpdateSettingsUseCase>(
      () => _i279.BulkUpdateSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.DeleteSettingUseCase>(
      () => _i279.DeleteSettingUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.GetTaxRatesUseCase>(
      () => _i279.GetTaxRatesUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.CreateTaxRateUseCase>(
      () => _i279.CreateTaxRateUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.UpdateTaxRateUseCase>(
      () => _i279.UpdateTaxRateUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.GetReceiptDisplaySettingsUseCase>(
      () => _i279.GetReceiptDisplaySettingsUseCase(
        gh<_i674.SettingsRepository>(),
      ),
    );
    gh.factory<_i495.SalesListCubit>(
      () => _i495.SalesListCubit(
        getSalesUseCase: gh<_i873.GetSalesUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i950.CashRegisterRepository>(
      () => _i168.CashRegisterRepositoryImpl(
        remoteDataSource: gh<_i493.CashRegisterRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.factory<_i591.SupplierFormCubit>(
      () => _i591.SupplierFormCubit(
        getSupplierUseCase: gh<_i877.GetSupplierUseCase>(),
        createSupplierUseCase: gh<_i877.CreateSupplierUseCase>(),
        updateSupplierUseCase: gh<_i877.UpdateSupplierUseCase>(),
      ),
    );
    gh.factory<_i981.StockMovementsCubit>(
      () => _i981.StockMovementsCubit(
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
        getStockMovementsUseCase: gh<_i380.GetStockMovementsUseCase>(),
      ),
    );
    gh.lazySingleton<_i511.PosRepository>(
      () => _i84.PosRepositoryImpl(
        remoteDataSource: gh<_i449.PosRemoteDataSource>(),
        pendingSalesDao: gh<_i842.PendingSalesDao>(),
        productsDao: gh<_i839.ProductsDao>(),
        syncQueue: gh<_i554.SyncQueue>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i987.SyncWorker>(
      () => _i987.SyncWorker(gh<_i417.SyncManager>()),
    );
    gh.lazySingleton<_i665.DashboardRepository>(
      () =>
          _i509.DashboardRepositoryImpl(gh<_i817.DashboardRemoteDataSource>()),
    );
    gh.factory<_i830.SaleDetailCubit>(
      () => _i830.SaleDetailCubit(
        getSaleByIdUseCase: gh<_i873.GetSaleByIdUseCase>(),
        cancelSaleUseCase: gh<_i873.CancelSaleUseCase>(),
        getCustomerUseCase: gh<_i449.GetCustomerUseCase>(),
      ),
    );
    gh.factory<_i146.ProductFormCubit>(
      () => _i146.ProductFormCubit(
        getProductByIdUseCase: gh<_i341.GetProductByIdUseCase>(),
        createProductUseCase: gh<_i460.CreateProductUseCase>(),
        updateProductUseCase: gh<_i73.UpdateProductUseCase>(),
        addVariationUseCase: gh<_i1053.AddVariationUseCase>(),
        addBarcodeUseCase: gh<_i347.AddBarcodeUseCase>(),
      ),
    );
    gh.factory<_i9.GetExpenseCategoriesUseCase>(
      () => _i9.GetExpenseCategoriesUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.CreateExpenseCategoryUseCase>(
      () => _i9.CreateExpenseCategoryUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.DeleteExpenseCategoryUseCase>(
      () => _i9.DeleteExpenseCategoryUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.GetExpensesUseCase>(
      () => _i9.GetExpensesUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.GetExpenseByIdUseCase>(
      () => _i9.GetExpenseByIdUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.CreateExpenseUseCase>(
      () => _i9.CreateExpenseUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.UpdateExpenseUseCase>(
      () => _i9.UpdateExpenseUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.DeleteExpenseUseCase>(
      () => _i9.DeleteExpenseUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i9.AddExpensePaymentUseCase>(
      () => _i9.AddExpensePaymentUseCase(gh<_i321.ExpensesRepository>()),
    );
    gh.factory<_i369.CategoriesCubit>(
      () => _i369.CategoriesCubit(
        getCategoriesUseCase: gh<_i583.GetCategoriesUseCase>(),
        createCategoryUseCase: gh<_i282.CreateCategoryUseCase>(),
      ),
    );
    gh.factory<_i700.UnitsCubit>(
      () => _i700.UnitsCubit(
        getUnitsUseCase: gh<_i835.GetUnitsUseCase>(),
        createUnitUseCase: gh<_i679.CreateUnitUseCase>(),
      ),
    );
    gh.factory<_i820.GetCashRegistersUseCase>(
      () => _i820.GetCashRegistersUseCase(gh<_i950.CashRegisterRepository>()),
    );
    gh.factory<_i820.GetActiveRegisterShiftUseCase>(
      () => _i820.GetActiveRegisterShiftUseCase(
        gh<_i950.CashRegisterRepository>(),
      ),
    );
    gh.factory<_i820.GetRegisterShiftSummaryUseCase>(
      () => _i820.GetRegisterShiftSummaryUseCase(
        gh<_i950.CashRegisterRepository>(),
      ),
    );
    gh.factory<_i820.CloseRegisterShiftUseCase>(
      () => _i820.CloseRegisterShiftUseCase(gh<_i950.CashRegisterRepository>()),
    );
    gh.factory<_i820.GetRegisterShiftsUseCase>(
      () => _i820.GetRegisterShiftsUseCase(gh<_i950.CashRegisterRepository>()),
    );
    gh.factory<_i820.GetRegisterShiftByIdUseCase>(
      () =>
          _i820.GetRegisterShiftByIdUseCase(gh<_i950.CashRegisterRepository>()),
    );
    gh.factory<_i296.InventoryStockCubit>(
      () => _i296.InventoryStockCubit(
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
        getProductsUseCase: gh<_i15.GetProductsUseCase>(),
        getProductByIdUseCase: gh<_i341.GetProductByIdUseCase>(),
        getStockBalancesUseCase: gh<_i380.GetStockBalancesUseCase>(),
      ),
    );
    gh.factory<_i981.ShiftDetailCubit>(
      () => _i981.ShiftDetailCubit(
        getShiftByIdUseCase: gh<_i820.GetRegisterShiftByIdUseCase>(),
        getShiftSummaryUseCase: gh<_i820.GetRegisterShiftSummaryUseCase>(),
        getRegistersUseCase: gh<_i820.GetCashRegistersUseCase>(),
      ),
    );
    gh.factory<_i792.SettingsCubit>(
      () => _i792.SettingsCubit(
        getBusinessProfileUseCase: gh<_i279.GetBusinessProfileUseCase>(),
        updateBusinessProfileUseCase: gh<_i279.UpdateBusinessProfileUseCase>(),
        getSettingsUseCase: gh<_i279.GetSettingsUseCase>(),
        bulkUpdateSettingsUseCase: gh<_i279.BulkUpdateSettingsUseCase>(),
        deleteSettingUseCase: gh<_i279.DeleteSettingUseCase>(),
        getTaxRatesUseCase: gh<_i279.GetTaxRatesUseCase>(),
        createTaxRateUseCase: gh<_i279.CreateTaxRateUseCase>(),
        updateTaxRateUseCase: gh<_i279.UpdateTaxRateUseCase>(),
      ),
    );
    gh.lazySingleton<_i363.PurchasesRepository>(
      () => _i652.PurchasesRepositoryImpl(
        remoteDataSource: gh<_i212.PurchasesRemoteDataSource>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.factory<_i804.BrandsCubit>(
      () => _i804.BrandsCubit(
        getBrandsUseCase: gh<_i546.GetBrandsUseCase>(),
        createBrandUseCase: gh<_i673.CreateBrandUseCase>(),
      ),
    );
    gh.factory<_i937.CurrentShiftCubit>(
      () => _i937.CurrentShiftCubit(
        getRegistersUseCase: gh<_i820.GetCashRegistersUseCase>(),
        getActiveShiftUseCase: gh<_i820.GetActiveRegisterShiftUseCase>(),
        getShiftSummaryUseCase: gh<_i820.GetRegisterShiftSummaryUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i507.SuppliersListCubit>(
      () => _i507.SuppliersListCubit(
        getSuppliersUseCase: gh<_i877.GetSuppliersUseCase>(),
        getSupplierBalanceUseCase: gh<_i877.GetSupplierBalanceUseCase>(),
        updateSupplierUseCase: gh<_i877.UpdateSupplierUseCase>(),
        deleteSupplierUseCase: gh<_i877.DeleteSupplierUseCase>(),
        createSupplierUseCase: gh<_i877.CreateSupplierUseCase>(),
      ),
    );
    gh.factory<_i698.CreateSaleUseCase>(
      () => _i698.CreateSaleUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.SearchCustomersUseCase>(
      () => _i698.SearchCustomersUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.CreateCustomerUseCase>(
      () => _i698.CreateCustomerUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.GetActiveShiftUseCase>(
      () => _i698.GetActiveShiftUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.OpenShiftUseCase>(
      () => _i698.OpenShiftUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.GetShiftSummaryUseCase>(
      () => _i698.GetShiftSummaryUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.LookupBarcodeUseCase>(
      () => _i698.LookupBarcodeUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.GetProductPriceUseCase>(
      () => _i698.GetProductPriceUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.GetRegistersUseCase>(
      () => _i698.GetRegistersUseCase(gh<_i511.PosRepository>()),
    );
    gh.factory<_i698.CreateRegisterUseCase>(
      () => _i698.CreateRegisterUseCase(gh<_i511.PosRepository>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
        localDataSource: gh<_i992.AuthLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.factory<_i890.CloseShiftCubit>(
      () => _i890.CloseShiftCubit(
        closeShiftUseCase: gh<_i820.CloseRegisterShiftUseCase>(),
      ),
    );
    gh.factory<_i312.PosCubit>(
      () => _i312.PosCubit(
        getProductsUseCase: gh<_i15.GetProductsUseCase>(),
        getCategoriesUseCase: gh<_i583.GetCategoriesUseCase>(),
        getProductByIdUseCase: gh<_i341.GetProductByIdUseCase>(),
        lookupBarcodeUseCase: gh<_i698.LookupBarcodeUseCase>(),
        getProductPriceUseCase: gh<_i698.GetProductPriceUseCase>(),
        createSaleUseCase: gh<_i698.CreateSaleUseCase>(),
        getActiveShiftUseCase: gh<_i698.GetActiveShiftUseCase>(),
        openShiftUseCase: gh<_i698.OpenShiftUseCase>(),
        getShiftSummaryUseCase: gh<_i698.GetShiftSummaryUseCase>(),
        getRegistersUseCase: gh<_i698.GetRegistersUseCase>(),
        createRegisterUseCase: gh<_i698.CreateRegisterUseCase>(),
        getStockBalanceUseCase: gh<_i380.GetStockBalanceUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
      ),
    );
    gh.factory<_i838.GetPurchaseOrdersUseCase>(
      () => _i838.GetPurchaseOrdersUseCase(gh<_i363.PurchasesRepository>()),
    );
    gh.factory<_i838.GetPurchaseOrderUseCase>(
      () => _i838.GetPurchaseOrderUseCase(gh<_i363.PurchasesRepository>()),
    );
    gh.factory<_i838.CreatePurchaseOrderUseCase>(
      () => _i838.CreatePurchaseOrderUseCase(gh<_i363.PurchasesRepository>()),
    );
    gh.factory<_i838.UpdatePurchaseOrderStatusUseCase>(
      () => _i838.UpdatePurchaseOrderStatusUseCase(
        gh<_i363.PurchasesRepository>(),
      ),
    );
    gh.factory<_i838.CreatePurchaseReceiptUseCase>(
      () => _i838.CreatePurchaseReceiptUseCase(gh<_i363.PurchasesRepository>()),
    );
    gh.factory<_i838.GetPurchaseReceiptUseCase>(
      () => _i838.GetPurchaseReceiptUseCase(gh<_i363.PurchasesRepository>()),
    );
    gh.factory<_i1062.GetDashboardSummaryUseCase>(
      () => _i1062.GetDashboardSummaryUseCase(gh<_i665.DashboardRepository>()),
    );
    gh.factory<_i642.ExpenseCategoriesCubit>(
      () => _i642.ExpenseCategoriesCubit(
        getExpenseCategoriesUseCase: gh<_i9.GetExpenseCategoriesUseCase>(),
        createExpenseCategoryUseCase: gh<_i9.CreateExpenseCategoryUseCase>(),
      ),
    );
    gh.factory<_i489.ExpensesListCubit>(
      () => _i489.ExpensesListCubit(
        getExpensesUseCase: gh<_i9.GetExpensesUseCase>(),
        getExpenseCategoriesUseCase: gh<_i9.GetExpenseCategoriesUseCase>(),
        getSuppliersUseCase: gh<_i877.GetSuppliersUseCase>(),
        deleteExpenseUseCase: gh<_i9.DeleteExpenseUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i994.RegisterRepository>(
      () => _i68.RegisterRepositoryImpl(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i220.ShiftHistoryCubit>(
      () => _i220.ShiftHistoryCubit(
        getShiftsUseCase: gh<_i820.GetRegisterShiftsUseCase>(),
        getRegistersUseCase: gh<_i820.GetCashRegistersUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i564.PinLoginUseCase>(
      () => _i564.PinLoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i642.RegisterBusinessUseCase>(
      () => _i642.RegisterBusinessUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i1066.ExpenseDetailCubit>(
      () => _i1066.ExpenseDetailCubit(
        getExpenseByIdUseCase: gh<_i9.GetExpenseByIdUseCase>(),
        getExpenseCategoriesUseCase: gh<_i9.GetExpenseCategoriesUseCase>(),
        getSupplierUseCase: gh<_i877.GetSupplierUseCase>(),
        deleteExpenseUseCase: gh<_i9.DeleteExpenseUseCase>(),
        addExpensePaymentUseCase: gh<_i9.AddExpensePaymentUseCase>(),
        getActiveShiftUseCase: gh<_i698.GetActiveShiftUseCase>(),
        getRegistersUseCase: gh<_i698.GetRegistersUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i626.ExpenseFormCubit>(
      () => _i626.ExpenseFormCubit(
        getExpenseCategoriesUseCase: gh<_i9.GetExpenseCategoriesUseCase>(),
        getSuppliersUseCase: gh<_i877.GetSuppliersUseCase>(),
        getExpenseByIdUseCase: gh<_i9.GetExpenseByIdUseCase>(),
        createExpenseUseCase: gh<_i9.CreateExpenseUseCase>(),
        updateExpenseUseCase: gh<_i9.UpdateExpenseUseCase>(),
        getActiveShiftUseCase: gh<_i698.GetActiveShiftUseCase>(),
        getRegistersUseCase: gh<_i698.GetRegistersUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i909.PurchaseOrderDetailCubit>(
      () => _i909.PurchaseOrderDetailCubit(
        getPurchaseOrderUseCase: gh<_i838.GetPurchaseOrderUseCase>(),
        updatePurchaseOrderStatusUseCase:
            gh<_i838.UpdatePurchaseOrderStatusUseCase>(),
      ),
    );
    gh.factory<_i125.ProcessReturnCubit>(
      () => _i125.ProcessReturnCubit(
        getSaleByIdUseCase: gh<_i873.GetSaleByIdUseCase>(),
        getCustomerUseCase: gh<_i449.GetCustomerUseCase>(),
        createSaleReturnUseCase: gh<_i956.CreateSaleReturnUseCase>(),
        getActiveShiftUseCase: gh<_i698.GetActiveShiftUseCase>(),
        getRegistersUseCase: gh<_i698.GetRegistersUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i1045.CustomerLedgerCubit>(
      () => _i1045.CustomerLedgerCubit(
        getCustomerUseCase: gh<_i449.GetCustomerUseCase>(),
        getCustomerBalanceUseCase: gh<_i449.GetCustomerBalanceUseCase>(),
        getCustomerLedgerUseCase: gh<_i449.GetCustomerLedgerUseCase>(),
        recordCustomerPaymentUseCase: gh<_i640.RecordCustomerPaymentUseCase>(),
        getActiveShiftUseCase: gh<_i698.GetActiveShiftUseCase>(),
        getRegistersUseCase: gh<_i698.GetRegistersUseCase>(),
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i483.PurchaseOrdersListCubit>(
      () => _i483.PurchaseOrdersListCubit(
        getPurchaseOrdersUseCase: gh<_i838.GetPurchaseOrdersUseCase>(),
        getSuppliersUseCase: gh<_i877.GetSuppliersUseCase>(),
      ),
    );
    gh.factory<_i993.CustomerPickerCubit>(
      () => _i993.CustomerPickerCubit(
        searchCustomersUseCase: gh<_i698.SearchCustomersUseCase>(),
        createCustomerUseCase: gh<_i698.CreateCustomerUseCase>(),
      ),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        loginUseCase: gh<_i188.LoginUseCase>(),
        pinLoginUseCase: gh<_i564.PinLoginUseCase>(),
        registerBusinessUseCase: gh<_i642.RegisterBusinessUseCase>(),
        logoutUseCase: gh<_i48.LogoutUseCase>(),
        authRepository: gh<_i787.AuthRepository>(),
        authGuard: gh<_i525.AuthGuard>(),
      ),
    );
    gh.factory<_i266.RegisterCubit>(
      () => _i266.RegisterCubit(gh<_i994.RegisterRepository>()),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(gh<_i1062.GetDashboardSummaryUseCase>()),
    );
    gh.factory<_i242.PurchaseOrderFormCubit>(
      () => _i242.PurchaseOrderFormCubit(
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
        getSuppliersUseCase: gh<_i877.GetSuppliersUseCase>(),
        getProductsUseCase: gh<_i15.GetProductsUseCase>(),
        getProductByIdUseCase: gh<_i341.GetProductByIdUseCase>(),
        createPurchaseOrderUseCase: gh<_i838.CreatePurchaseOrderUseCase>(),
        updatePurchaseOrderStatusUseCase:
            gh<_i838.UpdatePurchaseOrderStatusUseCase>(),
      ),
    );
    gh.factory<_i698.GoodsReceiptCubit>(
      () => _i698.GoodsReceiptCubit(
        authLocalDataSource: gh<_i992.AuthLocalDataSource>(),
        getPurchaseOrderUseCase: gh<_i838.GetPurchaseOrderUseCase>(),
        createPurchaseReceiptUseCase: gh<_i838.CreatePurchaseReceiptUseCase>(),
      ),
    );
    return this;
  }
}

class _$PreferencesModule extends _i574.PreferencesModule {}

class _$ConnectivityModule extends _i932.ConnectivityModule {}

class _$DatabaseModule extends _i384.DatabaseModule {}

class _$DioModule extends _i1045.DioModule {}
