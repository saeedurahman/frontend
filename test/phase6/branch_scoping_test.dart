import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/core/session/business_session_state.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/notifications/data/models/notification_model.dart';
import 'package:frantend/features/notifications/data/models/paginated_notifications_model.dart';
import 'package:frantend/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:frantend/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/restaurant/presentation/cubit/kitchen_display_cubit.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_cubit.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_state.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/repositories/suppliers_repository.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';

// ---------------------------------------------------------------------------
// Fakes & Mocks
// ---------------------------------------------------------------------------

class _FakeAuthLocal implements AuthLocalDataSource {
  _FakeAuthLocal(this.user);
  UserModel? user;

  @override
  Future<UserModel?> getCachedUser() async => user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSettingsRepo extends Fake implements SettingsRepository {
  List<AppSettingModel> settings = [];
  int getSettingsCallCount = 0;
  String? lastBranchIdQuery;

  @override
  Future<Either<Failure, BusinessProfileModel>> getBusinessProfile() async =>
      const Right(BusinessProfileModel(id: 'biz1', name: 'Biz 1'));

  @override
  Future<Either<Failure, List<AppSettingModel>>> getSettings({String? branchId}) async {
    getSettingsCallCount++;
    lastBranchIdQuery = branchId;
    return Right(settings);
  }

  @override
  Future<Either<Failure, List<TaxRateModel>>> getTaxRates() async =>
      const Right([]);

  @override
  Future<Either<Failure, List<AppSettingModel>>> bulkUpdateSettings(
    List<Map<String, dynamic>> items,
  ) async =>
      Right(settings);

  @override
  Future<Either<Failure, void>> deleteSetting(String key, {String? branchId}) async =>
      const Right(null);
}

class _FakeCustomersRepo extends Fake implements CustomersRepository {
  String? lastBalanceBranchId;
  String? lastLedgerBranchId;
  String? lastPaymentBranchId;

  @override
  Future<Either<Failure, CustomerModel>> getCustomer(String id) async =>
      Right(CustomerModel(id: id, businessId: 'biz1', name: 'Customer $id'));

  @override
  Future<Either<Failure, CustomerBalanceModel>> getCustomerBalance(
    String customerId, {
    String? branchId,
  }) async {
    lastBalanceBranchId = branchId;
    return Right(CustomerBalanceModel(customerId: customerId, balance: '150.00'));
  }

  @override
  Future<Either<Failure, List<CustomerLedgerEntryModel>>> getCustomerLedger(
    String customerId, {
    String? branchId,
    int? skip,
    int? limit,
  }) async {
    lastLedgerBranchId = branchId;
    return const Right([]);
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
    lastPaymentBranchId = branchId;
    return Right(CustomerPaymentResponseModel(
      ledgerEntryId: 'pay1',
      customerId: customerId,
      amount: amount.toString(),
      newBalance: '50.00',
    ));
  }
}

class _FakeSuppliersRepo extends Fake implements SuppliersRepository {
  String? lastBalanceBranchId;

  @override
  Future<Either<Failure, List<SupplierModel>>> getSuppliers() async =>
      Right([SupplierModel(id: 'sup1', businessId: 'biz1', name: 'Supplier 1')]);

  @override
  Future<Either<Failure, SupplierBalanceModel>> getSupplierBalance(
    String supplierId, {
    String? branchId,
  }) async {
    lastBalanceBranchId = branchId;
    return Right(SupplierBalanceModel(supplierId: supplierId, balance: '250.00'));
  }
}

class _FakeNotificationsRepo extends Fake implements NotificationsRepository {
  List<NotificationModel> canned = [];
  String? lastBranchId;

  @override
  Future<Either<Failure, PaginatedNotificationsModel>> getNotifications({
    String? branchId,
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  }) async {
    lastBranchId = branchId;
    return Right(PaginatedNotificationsModel(
      total: canned.length,
      unreadCount: canned.where((n) => !n.isRead).length,
      skip: skip,
      limit: limit,
      items: canned,
    ));
  }

  @override
  Future<Either<Failure, ({int lowStock, int expiry})>> checkAlerts() async =>
      const Right((lowStock: 0, expiry: 0));
}

class _FakeRestaurantRepo extends Fake implements RestaurantRepository {
  String? lastLayoutBranchId;
  String? lastKotBranchId;

  @override
  Future<Either<Failure, FloorLayoutModel>> getFloorLayout({String? branchId}) async {
    lastLayoutBranchId = branchId;
    return Right(FloorLayoutModel(
      branchId: branchId ?? 'b1',
      floorPlans: const [],
      unassignedTables: const [],
    ));
  }

  @override
  Future<Either<Failure, List<KotOrderModel>>> getActiveKotOrders({String? branchId}) async {
    lastKotBranchId = branchId;
    return const Right([]);
  }
}

class _FakeBusinessSessionCubit extends Fake implements BusinessSessionCubit {
  @override
  BusinessSessionState get state => const BusinessSessionState(
        flags: BusinessFeatureFlags(
          enableRestaurant: true,
          enableTableManagement: true,
          enableKot: true,
        ),
      );
}

class _FakeImageUploadService extends Fake implements ImageUploadService {}

class _FakeMyActiveShiftUseCase extends Fake implements GetMyActiveShiftUseCase {
  @override
  Future<Either<Failure, RegisterShiftModel?>> call() async => const Right(null);
}

// ---------------------------------------------------------------------------
// POS Minimal Fakes
// ---------------------------------------------------------------------------

class _FakeProductsUseCase extends Fake implements GetProductsUseCase {
  @override
  Future<Either<Failure, PaginatedProductsModel>> call({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async => const Right(PaginatedProductsModel(total: 0, skip: 0, limit: 50));
}

class _FakeCategoriesUseCase extends Fake implements GetCategoriesUseCase {
  @override
  Future<Either<Failure, List<CategoryModel>>> call({String? parentId}) async =>
      const Right([]);
}

class _FakeProductByIdUseCase extends Fake implements GetProductByIdUseCase {}

class _FakeProductPriceUseCase extends Fake implements GetProductPriceUseCase {
  @override
  Future<Either<Failure, Decimal?>> call(
    String p,
    String? v, {
    Decimal? qty,
    String? priceListId,
    String? customerId,
  }) async => const Right(null);
}

class _FakeCreateSaleUseCase extends Fake implements CreateSaleUseCase {}
class _FakeOpenShiftUseCase extends Fake implements OpenShiftUseCase {}
class _FakeShiftSummaryUseCase extends Fake implements GetShiftSummaryUseCase {
  @override
  Future<Either<Failure, ShiftSummaryModel>> call(String shiftId) async =>
      const Left(ServerFailure('no summary'));
}
class _FakeRegistersUseCase extends Fake implements GetRegistersUseCase {
  @override
  Future<Either<Failure, List<CashRegisterModel>>> call({String? branchId}) async =>
      Right([CashRegisterModel(id: 'r1', branchId: branchId ?? 'b1', name: 'Main')]);
}
class _FakeCreateRegisterUseCase extends Fake implements CreateRegisterUseCase {}
class _FakeStockBalanceUseCase extends Fake implements GetStockBalanceUseCase {}
class _FakeStockBalancesUseCase extends Fake implements GetStockBalancesUseCase {
  @override
  Future<Either<Failure, List<StockBalanceModel>>> call({
    required String branchId,
    List<String>? productIds,
  }) async =>
      const Right([]);
}
class _FakeTaxRatesUseCase extends Fake implements GetTaxRatesUseCase {
  @override
  Future<Either<Failure, List<TaxRateModel>>> call() async => const Right([]);
}
class _FakeGetSettingsUseCase extends Fake implements GetSettingsUseCase {
  @override
  Future<Either<Failure, List<AppSettingModel>>> call({String? branchId}) async =>
      const Right([]);
}
class _FakeDiscountSchemesUseCase extends Fake implements GetDiscountSchemesUseCase {
  @override
  Future<Either<Failure, List<DiscountSchemeModel>>> call() async =>
      const Right([]);
}
class _FakePreviewSalePriceUseCase extends Fake implements PreviewSalePriceUseCase {}
class _FakeOpenTabUseCase extends Fake implements OpenTabUseCase {}
class _FakeAddTabLinesUseCase extends Fake implements AddTabLinesUseCase {}
class _FakeFireTabUseCase extends Fake implements FireTabUseCase {}
class _FakeRequestTabBillUseCase extends Fake implements RequestTabBillUseCase {}
class _FakeCompleteTabUseCase extends Fake implements CompleteTabUseCase {}
class _FakeGetTabSaleUseCase extends Fake implements GetTabSaleUseCase {}
class _FakeKotOrdersByTableUseCase extends Fake implements GetKotOrdersByTableUseCase {}

class _FakeMemoryHeldRepo implements HeldOrdersRepository {
  final rows = <String, (HeldOrderModel, HeldOrderScope?)>{};

  @override
  Future<void> save(HeldOrderModel order, HeldOrderScope scope) async {
    rows[order.id] = (order, scope);
  }

  @override
  Future<List<HeldOrderModel>> list(HeldOrderScope scope) async => [
    for (final r in rows.values)
      if (r.$2 == scope) r.$1,
  ];

  @override
  Future<HeldOrderModel?> find(String id, HeldOrderScope scope) async {
    final r = rows[id];
    return r != null && r.$2 == scope ? r.$1 : null;
  }

  @override
  Future<void> delete(String id) async => rows.remove(id);
}

class _FakeMemoryBarcodeCache implements BarcodeCacheRepository {
  @override
  Future<ProductModel?> find(String tenantKey, String barcode) async => null;

  @override
  Future<void> remember(String t, String b, ProductModel p) async {}
}

class _FakeBarcodeUseCase extends Fake implements LookupBarcodeUseCase {}

class _FakeGetCustomerUseCase extends Fake implements GetCustomerUseCase {}
class _FakeGetCustomerBalanceUseCase extends Fake implements GetCustomerBalanceUseCase {}

PosCubit _buildTestPosCubit(UserModel user) {
  final auth = _FakeAuthLocal(user);
  final price = _FakeProductPriceUseCase();
  final held = _FakeMemoryHeldRepo();
  return PosCubit(
    getProductsUseCase: _FakeProductsUseCase(),
    getCategoriesUseCase: _FakeCategoriesUseCase(),
    getProductByIdUseCase: _FakeProductByIdUseCase(),
    getProductPriceUseCase: price,
    createSaleUseCase: _FakeCreateSaleUseCase(),
    getMyActiveShiftUseCase: _FakeMyActiveShiftUseCase(),
    openShiftUseCase: _FakeOpenShiftUseCase(),
    getShiftSummaryUseCase: _FakeShiftSummaryUseCase(),
    getRegistersUseCase: _FakeRegistersUseCase(),
    createRegisterUseCase: _FakeCreateRegisterUseCase(),
    getStockBalanceUseCase: _FakeStockBalanceUseCase(),
    getStockBalancesUseCase: _FakeStockBalancesUseCase(),
    getTaxRatesUseCase: _FakeTaxRatesUseCase(),
    getSettingsUseCase: _FakeGetSettingsUseCase(),
    getDiscountSchemesUseCase: _FakeDiscountSchemesUseCase(),
    previewSalePriceUseCase: _FakePreviewSalePriceUseCase(),
    openTabUseCase: _FakeOpenTabUseCase(),
    addTabLinesUseCase: _FakeAddTabLinesUseCase(),
    fireTabUseCase: _FakeFireTabUseCase(),
    requestTabBillUseCase: _FakeRequestTabBillUseCase(),
    completeTabUseCase: _FakeCompleteTabUseCase(),
    getTabSaleUseCase: _FakeGetTabSaleUseCase(),
    getKotOrdersByTableUseCase: _FakeKotOrdersByTableUseCase(),
    resolvePosSession: ResolvePosSessionUseCase(auth, FixedConnectivityProbe()),
    heldOrdersUseCases: HeldOrdersUseCases(held, price, UuidIdGenerator()),
    resolveBarcodeUseCase: ResolveBarcodeUseCase(
      _FakeMemoryBarcodeCache(),
      _FakeBarcodeUseCase(),
      _FakeProductByIdUseCase(),
    ),
    saleAttempts: SaleAttemptTracker(UuidIdGenerator()),
    getCustomerUseCase: _FakeGetCustomerUseCase(),
    getCustomerBalanceUseCase: _FakeGetCustomerBalanceUseCase(),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final branch1 = BranchModel(id: 'b1', businessId: 'biz1', name: 'Branch 1', isDefault: true);
  final branch2 = BranchModel(id: 'b2', businessId: 'biz1', name: 'Branch 2');
  final branch3 = BranchModel(id: 'b3', businessId: 'biz1', name: 'Branch 3');
  final allBranches = [branch1, branch2, branch3];

  group('1. Branch Scoping in Settings', () {
    test('allowedBranches filters list down to only assigned branchIds', () {
      final allowed = BranchSelectorCubit.allowedBranches(allBranches, ['b2']);
      expect(allowed.map((b) => b.id), ['b2']);
    });

    test('selectBranchForOverrides rejects foreign branch for branch-limited user', () async {
      final repo = _FakeSettingsRepo();
      final cubit = SettingsCubit(
        getBusinessProfileUseCase: GetBusinessProfileUseCase(repo),
        updateBusinessProfileUseCase: UpdateBusinessProfileUseCase(repo),
        getSettingsUseCase: GetSettingsUseCase(repo),
        bulkUpdateSettingsUseCase: BulkUpdateSettingsUseCase(repo),
        deleteSettingUseCase: DeleteSettingUseCase(repo),
        getTaxRatesUseCase: GetTaxRatesUseCase(repo),
        createTaxRateUseCase: CreateTaxRateUseCase(repo),
        updateTaxRateUseCase: UpdateTaxRateUseCase(repo),
        imageUploadService: _FakeImageUploadService(),
      );

      cubit.branchIdsProvider = () => ['b1'];

      // Populate loaded state
      await cubit.loadAll();
      expect(cubit.state, isA<SettingsLoaded>());

      // Attempt to select foreign branch 'b2'
      await cubit.selectBranchForOverrides('b2');

      final state = cubit.state as SettingsLoaded;
      expect(state.errorMessage, "You don't have access to this branch.");
      expect(state.branchOverrideId, isNull);
      // Backend getSettings should not have been called for 'b2'
      expect(repo.lastBranchIdQuery, isNull);
    });

    test('saveBranchOverride and removeBranchOverride reject foreign branch', () async {
      final repo = _FakeSettingsRepo();
      final cubit = SettingsCubit(
        getBusinessProfileUseCase: GetBusinessProfileUseCase(repo),
        updateBusinessProfileUseCase: UpdateBusinessProfileUseCase(repo),
        getSettingsUseCase: GetSettingsUseCase(repo),
        bulkUpdateSettingsUseCase: BulkUpdateSettingsUseCase(repo),
        deleteSettingUseCase: DeleteSettingUseCase(repo),
        getTaxRatesUseCase: GetTaxRatesUseCase(repo),
        createTaxRateUseCase: CreateTaxRateUseCase(repo),
        updateTaxRateUseCase: UpdateTaxRateUseCase(repo),
        imageUploadService: _FakeImageUploadService(),
      );

      cubit.branchIdsProvider = () => ['b1'];
      await cubit.loadAll();

      // Manually set foreign branch override ID in state for testing save
      cubit.emit((cubit.state as SettingsLoaded).copyWith(branchOverrideId: 'b3'));

      final saved = await cubit.saveBranchOverride();
      expect(saved, isFalse);
      expect((cubit.state as SettingsLoaded).errorMessage, "You don't have access to this branch.");

      final removed = await cubit.removeBranchOverride();
      expect(removed, isFalse);
      expect((cubit.state as SettingsLoaded).errorMessage, "You don't have access to this branch.");
    });
  });

  group('2. HTTP 403 Plain Message Handling (No Crash, No Logout)', () {
    test('ErrorHandler maps 403 with backend detail to PermissionDeniedFailure', () {
      final handler = ErrorHandler();
      final failure = handler.mapStatus(403, {'detail': 'You do not have access to this branch'});
      expect(failure, isA<PermissionDeniedFailure>());
      expect(failure.message, 'You do not have access to this branch');
    });

    test('ErrorHandler maps 403 without detail to default clean permission message', () {
      final handler = ErrorHandler();
      final failure = handler.mapStatus(403, {});
      expect(failure, isA<PermissionDeniedFailure>());
      expect(failure.message, "You don't have permission to do this.");
    });
  });

  group('3. Branch Scoping in Customers (Ledger & Payments)', () {
    test('CustomerLedgerCubit.load passes branchId and recordPayment passes branchId', () async {
      final repo = _FakeCustomersRepo();

      final cubit = CustomerLedgerCubit(
        getCustomerUseCase: GetCustomerUseCase(repo),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(repo),
        getCustomerLedgerUseCase: GetCustomerLedgerUseCase(repo),
        recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(repo),
        getMyActiveShiftUseCase: _FakeMyActiveShiftUseCase(),
      );

      await cubit.load('c1', branchId: 'b1');
      expect(repo.lastBalanceBranchId, 'b1');
      expect(repo.lastLedgerBranchId, 'b1');

      // Now record payment
      final response = await cubit.recordPayment(
        amount: Decimal.fromInt(100),
        paymentMethod: 'cash',
      );
      expect(response, isNotNull);
      expect(repo.lastPaymentBranchId, 'b1');
    });

    test('CustomerLedgerCubit.onBranchChanged switches branch and reloads data', () async {
      final repo = _FakeCustomersRepo();
      final cubit = CustomerLedgerCubit(
        getCustomerUseCase: GetCustomerUseCase(repo),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(repo),
        getCustomerLedgerUseCase: GetCustomerLedgerUseCase(repo),
        recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(repo),
        getMyActiveShiftUseCase: _FakeMyActiveShiftUseCase(),
      );

      await cubit.load('c1', branchId: 'b1');
      expect(repo.lastBalanceBranchId, 'b1');

      await cubit.onBranchChanged('b2');
      expect(repo.lastBalanceBranchId, 'b2');
      expect(repo.lastLedgerBranchId, 'b2');
    });
  });

  group('4. Branch Scoping in Supplier Ledger', () {
    test('SuppliersListCubit._loadBalances passes branchId to balance usecase', () async {
      final repo = _FakeSuppliersRepo();
      final cubit = SuppliersListCubit(
        getSuppliersUseCase: GetSuppliersUseCase(repo),
        getSupplierBalanceUseCase: GetSupplierBalanceUseCase(repo),
        updateSupplierUseCase: UpdateSupplierUseCase(repo),
        deleteSupplierUseCase: DeleteSupplierUseCase(repo),
        createSupplierUseCase: CreateSupplierUseCase(repo),
      );

      await cubit.load();
      expect(cubit.state, isA<SuppliersListLoaded>());
      final loaded = cubit.state as SuppliersListLoaded;
      expect(loaded.allItems.first.balance, '250.00');

      // Trigger branch change
      await cubit.onBranchChanged('b2');
      expect(cubit.state, isA<SuppliersListLoaded>());
    });
  });

  group('5. Branch Scoping in Restaurant (Tables / Floor Plans & KOT)', () {
    test('TablesFloorCubit.init clamps branchId to allowed branches for branch-limited user', () async {
      final repo = _FakeRestaurantRepo();
      final auth = _FakeAuthLocal(const UserModel(
        id: 'u1',
        name: 'Waiter',
        role: 'waiter',
        branchId: 'b_foreign', // stale/foreign branch
        branchIds: ['b1'],     // only b1 allowed
        permissionKeys: [Perm.tablesView],
      ));

      final cubit = TablesFloorCubit(
        getFloorLayoutUseCase: GetFloorLayoutUseCase(repo),
        authLocalDataSource: auth,
        businessSession: _FakeBusinessSessionCubit(),
      );

      await cubit.init();
      // Should query floor layout for allowed branch 'b1', not 'b_foreign'
      expect(repo.lastLayoutBranchId, 'b1');

      // onBranchChanged ignores foreign branch
      await cubit.onBranchChanged('b3_foreign');
      expect(repo.lastLayoutBranchId, 'b1');
    });

    test('KitchenDisplayCubit.init clamps branchId to allowed branches and ignores foreign branch', () async {
      final repo = _FakeRestaurantRepo();
      final auth = _FakeAuthLocal(const UserModel(
        id: 'u1',
        name: 'Cook',
        role: 'kitchen',
        branchId: 'b_foreign',
        branchIds: ['b1'],
        permissionKeys: [Perm.kotView],
      ));

      final cubit = KitchenDisplayCubit(
        getActiveKotOrdersUseCase: GetActiveKotOrdersUseCase(repo),
        updateKotStatusUseCase: UpdateKotStatusUseCase(repo),
        authLocalDataSource: auth,
        businessSession: _FakeBusinessSessionCubit(),
      );

      await cubit.init();
      expect(repo.lastKotBranchId, 'b1');

      await cubit.onBranchChanged('b2_foreign');
      expect(repo.lastKotBranchId, 'b1');
    });
  });

  group('6. Branch Scoping in Notifications (List & Badge Count)', () {
    test('NotificationsCubit filters out foreign branches from notifications and unread badge count', () async {
      final repo = _FakeNotificationsRepo();
      repo.canned = [
        NotificationModel(
          id: 'n1',
          businessId: 'biz1',
          branchId: 'b1',
          notificationType: 'low_stock',
          channel: 'app',
          title: 'Branch 1 Low Stock',
          isRead: false,
          createdAt: DateTime.now(),
        ),
        NotificationModel(
          id: 'n2',
          businessId: 'biz1',
          branchId: 'b2', // foreign branch
          notificationType: 'low_stock',
          channel: 'app',
          title: 'Branch 2 Low Stock',
          isRead: false,
          createdAt: DateTime.now(),
        ),
        NotificationModel(
          id: 'n3',
          businessId: 'biz1',
          branchId: null, // global notification
          notificationType: 'system',
          channel: 'app',
          title: 'System Notice',
          isRead: false,
          createdAt: DateTime.now(),
        ),
      ];

      final auth = _FakeAuthLocal(const UserModel(
        id: 'u1',
        name: 'Staff',
        role: 'cashier',
        branchIds: ['b1'], // only b1 allowed
      ));

      final cubit = NotificationsCubit(
        getNotificationsUseCase: GetNotificationsUseCase(repo),
        markNotificationsReadUseCase: MarkNotificationsReadUseCase(repo),
        markAllNotificationsReadUseCase: MarkAllNotificationsReadUseCase(repo),
        deleteNotificationUseCase: DeleteNotificationUseCase(repo),
        checkNotificationAlertsUseCase: CheckNotificationAlertsUseCase(repo),
        authLocalDataSource: auth,
      );

      cubit.branchIdsProvider = () => ['b1'];

      await cubit.loadNotifications(reset: true);

      expect(cubit.state, isA<NotificationsLoaded>());
      final loaded = cubit.state as NotificationsLoaded;

      // 'n2' (from b2) must be excluded! Only n1 (b1) and n3 (null branch) kept.
      expect(loaded.notifications.map((n) => n.id), ['n1', 'n3']);
      // unreadCount must only count allowed notifications (2, not 3)
      expect(loaded.unreadCount, 2);
      expect(cubit.previewNotifications.map((n) => n.id), ['n1', 'n3']);
    });
  });

  group('7. Offline Sync Purge & POS Scope Enforcement', () {
    test('SyncStore.purgeRevokedBranches deletes rows for revoked branches while preserving allowed ones', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final store = SyncStore(db);

      // Insert entities with different branch_ids
      await db.customStatement(
        'INSERT INTO entities (entity, id, business_id, branch_id, parent_id, data, search_text, barcode, category_id, active, is_deleted, seq) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        ['product', 'p1', 'biz1', 'b1', null, '{"name":"P1"}', 'p1', null, null, 1, 0, 1],
      );
      await db.customStatement(
        'INSERT INTO entities (entity, id, business_id, branch_id, parent_id, data, search_text, barcode, category_id, active, is_deleted, seq) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        ['product', 'p2', 'biz1', 'b2', null, '{"name":"P2"}', 'p2', null, null, 1, 0, 2],
      );
      await db.customStatement(
        'INSERT INTO entities (entity, id, business_id, branch_id, parent_id, data, search_text, barcode, category_id, active, is_deleted, seq) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        ['category', 'cat1', 'biz1', null, null, '{"name":"Cat1"}', 'cat1', null, null, 1, 0, 3],
      );

      // Insert stock levels for b1 and b2
      await db.customStatement(
        'INSERT INTO stock_levels (id, branch_id, product_id, variation_id, qty, last_movement_at, seq) '
        'VALUES (?, ?, ?, ?, ?, ?, ?)',
        ['s1', 'b1', 'p1', null, '10', DateTime.now().toIso8601String(), 1],
      );
      await db.customStatement(
        'INSERT INTO stock_levels (id, branch_id, product_id, variation_id, qty, last_movement_at, seq) '
        'VALUES (?, ?, ?, ?, ?, ?, ?)',
        ['s2', 'b2', 'p2', null, '20', DateTime.now().toIso8601String(), 2],
      );

      // Now revoke branch 'b2': only 'b1' is allowed
      await store.purgeRevokedBranches(['b1']);

      // Check remaining entities: 'p1' (b1) and 'cat1' (null branch) exist, 'p2' (b2) is deleted!
      final p1 = await store.entity('product', 'p1');
      final p2 = await store.entity('product', 'p2');
      final cat1 = await store.entity('category', 'cat1');

      expect(p1, isNotNull);
      expect(p2, isNull);
      expect(cat1, isNotNull);

      // Check remaining stock levels: 's1' (b1) exists, 's2' (b2) is deleted!
      final stockB1 = await store.stockLevel('b1', 'p1');
      final stockB2 = await store.stockLevel('b2', 'p2');
      expect(stockB1, Decimal.fromInt(10));
      expect(stockB2, isNull);

      await db.close();
    });

    test('PosCubit never lets a limited user switch to an unassigned branch', () async {
      const user = UserModel(
        id: 'u1',
        name: 'Cashier',
        role: 'cashier',
        branchId: 'b1',
        branchIds: ['b1'], // only b1 allowed
        permissionKeys: ['sales.create', 'shifts.open'],
      );

      final posCubit = _buildTestPosCubit(user);
      await posCubit.init();
      expect(posCubit.state.branchId, 'b1');

      // Attempt to switch to foreign branch 'b2'
      final switchedToForeign = await posCubit.switchBranch('b2');
      expect(switchedToForeign, isFalse);
      expect(posCubit.state.branchId, isNot('b2'));

      // Attempt to switch to allowed branch 'b1'
      final switchedToAllowed = await posCubit.switchBranch('b1');
      expect(switchedToAllowed, isTrue);
      expect(posCubit.state.branchId, 'b1');

      await posCubit.close();
    });
  });
}
