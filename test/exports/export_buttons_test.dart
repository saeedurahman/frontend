// Every export button in the app: the real screen, the real button, the real
// dialog. What is checked is the request that leaves the app (dataset and query
// string) and the file name offered to the user.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/services/export_service.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/pages/customer_ledger_page.dart';
import 'package:frantend/features/customers/presentation/pages/customers_list_page.dart';
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_cubit.dart';
import 'package:frantend/features/expenses/presentation/pages/expenses_list_page.dart';
import 'package:frantend/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:frantend/features/inventory/data/expiry_report.dart';
import 'package:frantend/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_cubit.dart';
import 'package:frantend/features/inventory/presentation/pages/expiry_report_page.dart';
import 'package:frantend/features/inventory/presentation/pages/inventory_stock_page.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/supplier_ledger_page.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:frantend/features/products/presentation/pages/products_list_page.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/purchases/presentation/pages/purchase_orders_list_page.dart';
import 'package:frantend/features/reports/domain/usecases/reports_usecases.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter_cubit.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_tab_data.dart';
import 'package:frantend/features/reports/presentation/pages/reports_page.dart';
import 'package:frantend/features/reports/presentation/utils/report_export.dart';
import 'package:frantend/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:frantend/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_cubit.dart';
import 'package:frantend/features/sales/presentation/pages/sales_list_page.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/pages/suppliers_list_page.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../helpers/fake_rest.dart';
import '../helpers/khata_fakes.dart';
import '../phase5/export_service_test.dart' show FakeFileSaverService;
import '../helpers/fake_http.dart' show jsonResponse;
import '../refresh/refresh_fixtures.dart';
import '../sync/sync_rig.dart';

const _errors = ErrorHandler();

const _csv = 'CSV Document (.csv)';
const _pdf = 'PDF Document (.pdf)';
const _xlsx = 'Excel Spreadsheet (.xlsx)';

final _day = DateFormat('yyyy-MM-dd');

class _NoUseCases extends Fake implements ReportsUseCases {}

/// The reports screen without the report calls: only the open tab changes.
class _Reports extends ReportsCubit {
  _Reports() : super(_NoUseCases(), OwnerAuth());

  @override
  Future<void> init(ReportsFilter filter) async => emit(
        ReportsLoaded(
          filter: filter,
          activeTab: ReportsTab.sales,
          loadedTabs: const {},
        ),
      );

  @override
  Future<void> selectTab(ReportsTab tab) async {
    final current = state;
    if (current is ReportsLoaded) emit(current.copyWith(activeTab: tab));
  }

  @override
  Future<void> onFilterChanged(ReportsFilter filter) async {}
}

/// An [AccessCubit] that holds exactly [keys].
class _Access extends Fake implements AccessCubit {
  _Access(this.keys);

  final Set<String> keys;

  @override
  AccessState get state => AccessState(
        user: User(
          id: kUser,
          email: 'cashier@example.com',
          name: 'Cashier',
          role: 'cashier',
          businessId: kBusiness,
          permissionKeys: keys.toList(),
        ),
      );

  @override
  Stream<AccessState> get stream => const Stream.empty();
}

void main() {
  useActiveBranch();

  late FakeRest server;
  late FakeFileSaverService files;
  late List<FakeCall> exports;

  void register<T extends Object>(T instance) {
    if (sl.isRegistered<T>()) sl.unregister<T>();
    sl.registerSingleton<T>(instance);
    addTearDown(() => sl.unregister<T>());
  }

  void factory<T extends Object>(T Function() create) {
    if (sl.isRegistered<T>()) sl.unregister<T>();
    sl.registerFactory<T>(create);
    addTearDown(() => sl.unregister<T>());
  }

  setUp(() {
    server = FakeRest();
    files = FakeFileSaverService();
    exports = [];
    for (final path in const [
      '/customers',
      '/suppliers',
      '/purchases/orders',
      '/expenses/categories',
      '/stock/balances',
      '/categories',
      '/brands',
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
    server.on('GET', '/export/{dataset}', (call) {
      exports.add(call);
      return ResponseBody.fromBytes(
        Uint8List.fromList(utf8.encode('Date,Amount\n')),
        200,
      );
    });
  });

  // ── the screens, with real data sources, repositories and use cases ───

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

  CustomersRepositoryImpl customers() => CustomersRepositoryImpl(
        remoteDataSource: CustomersRemoteDataSourceImpl(server.client),
        errorHandler: _errors,
      );

  void common() {
    register<DioClient>(server.client);
    register<FileSaverService>(files);
  }

  void suppliersScreens() {
    final repo = suppliers();
    factory(
      () => SuppliersListCubit(
        getSuppliersUseCase: GetSuppliersUseCase(repo),
        getSupplierBalanceUseCase: GetSupplierBalanceUseCase(repo),
        updateSupplierUseCase: UpdateSupplierUseCase(repo),
        deleteSupplierUseCase: DeleteSupplierUseCase(repo),
        createSupplierUseCase: CreateSupplierUseCase(repo),
      ),
    );
    factory(
      () => SupplierLedgerCubit(
        GetSupplierUseCase(repo),
        GetSupplierLedgerUseCase(repo),
        ReverseSupplierPaymentUseCase(repo),
        FakeBranchResolver(kBranch),
        KhataEvents(),
      ),
    );
  }

  /// Two suppliers, each with one bill.
  void twoSuppliers() {
    Map<String, dynamic> supplier(String id, String name) =>
        {'id': id, 'business_id': kBusiness, 'name': name, 'is_active': true};
    final rows = {
      's1': supplier('s1', 'Test Supplier'),
      's2': supplier('s2', 'Other Traders'),
    };
    server.on('GET', '/suppliers', (_) => rows.values.toList());
    server.on('GET', '/suppliers/{id}', (c) => rows[c.params['id']]);
    server.on(
      'GET',
      '/supplier-ledger/{id}/balance',
      (c) => {'supplier_id': c.params['id'], 'balance': '-600'},
    );
    server.on(
      'GET',
      '/supplier-ledger/{id}',
      (c) => {
        'items': [
          {
            'id': 'e-${c.params['id']}',
            'supplier_id': c.params['id'],
            'entry_type': 'sale',
            'amount': '-600',
            'running_balance': '-600',
            'entry_at': '2026-11-20T10:00:00Z',
            'branch_id': kBranch,
          },
        ],
        'total': 1,
        'skip': 0,
        'limit': 50,
        'balance': '-600',
      },
    );
  }

  /// Several frames; pumpAndSettle would wait for ever on a shimmer.
  Future<void> frames(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  void bigWindow(WidgetTester tester) {
    // The test font is far wider than the real one, so some rows report
    // cosmetic overflows; any other framework error still fails the test.
    final previous = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exceptionAsString().contains('overflowed')) return;
      previous?.call(d);
    };
    addTearDown(() => FlutterError.onError = previous);
    tester.view.physicalSize = const Size(2000, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> open(WidgetTester tester, Widget page) async {
    bigWindow(tester);
    common();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
    await frames(tester);
  }

  /// Taps [button], picks [format] and confirms. Returns the one request sent.
  Future<FakeCall> export(
    WidgetTester tester,
    Finder button, {
    String format = _csv,
  }) async {
    exports.clear();
    expect(button, findsOneWidget);
    await tester.tap(button);
    await frames(tester);
    await tester.tap(find.text(format));
    await tester.pump();
    await tester.tap(find.text('Export Now'));
    await frames(tester);
    expect(exports, hasLength(1), reason: '${server.log}');
    return exports.single;
  }

  void expectRequest(
    FakeCall call,
    String dataset,
    Map<String, dynamic> query,
  ) {
    expect(call.options.path, '/export/$dataset');
    expect(call.query, query);
  }

  String today() => DateFormat('yyyyMMdd').format(DateTime.now());

  // ── supplier account ──────────────────────────────────────────────────

  group('supplier account "Export account"', () {
    const button = ValueKey('export_supplier_ledger');

    /// The routes as the app nests them: the list, and the account under it.
    Future<void> openFromList(WidgetTester tester, String name) async {
      bigWindow(tester);
      common();
      twoSuppliers();
      suppliersScreens();
      final router = GoRouter(
        initialLocation: RouteNames.suppliers,
        routes: [
          ShellRoute(
            builder: (_, __, child) => Scaffold(body: child),
            routes: [
              GoRoute(
                path: RouteNames.suppliers,
                builder: (_, __) => const SuppliersListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => SupplierLedgerPage(
                      supplierId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await frames(tester);
      await tester.tap(find.text(name));
      await frames(tester);
    }

    for (final (label, ext) in const [(_xlsx, 'xlsx'), (_csv, 'csv'), (_pdf, 'pdf')]) {
      testWidgets('opened from the list, as $ext: that supplier only',
          (tester) async {
        await openFromList(tester, 'Other Traders');

        final call = await export(tester, find.byKey(button), format: label);

        expectRequest(call, 'supplier_ledger', {
          'format': ext,
          'supplier_id': 's2',
          'branch_id': kBranch,
        });
        expect(
          files.lastSavedName,
          'Other Traders ledger ${_day.format(DateTime.now())}.$ext',
        );
      });
    }

    testWidgets('the chosen dates are sent and name the file', (tester) async {
      twoSuppliers();
      suppliersScreens();
      await open(tester, const SupplierLedgerPage(supplierId: 's1'));
      tester
          .element(find.byType(SupplierLedgerView))
          .read<SupplierLedgerCubit>()
          .setDates(DateTime(2026, 11, 1), DateTime(2026, 11, 26));
      await frames(tester);

      final call = await export(tester, find.byKey(button));

      expectRequest(call, 'supplier_ledger', {
        'format': 'csv',
        'supplier_id': 's1',
        'branch_id': kBranch,
        'date_from': '2026-11-01',
        'date_to': '2026-11-26',
      });
      expect(files.lastSavedName, 'Test Supplier ledger 2026-11-26.csv');
    });

    for (final (label, ext) in const [(_csv, 'csv'), (_pdf, 'pdf')]) {
      testWidgets('too large for one $ext file (413): a date range is suggested',
          (tester) async {
        twoSuppliers();
        suppliersScreens();
        server.on('GET', '/export/{dataset}', (call) {
          exports.add(call);
          return jsonResponse(
            {'detail': 'Too many rows (61000) for one export'},
            status: 413,
          );
        });
        await open(tester, const SupplierLedgerPage(supplierId: 's1'));

        final call = await export(tester, find.byKey(button), format: label);

        // No dates chosen means the whole account; no made-up start date.
        expect(call.query, isNot(contains('date_from')));
        final message = ExportService.tooLargeMessage(ext);
        expect(message, contains('date range'));
        expect(find.textContaining(message), findsOneWidget);
        expect(find.textContaining('61000'), findsNothing);
        await tester.pump(const Duration(seconds: 15));
      });
    }

    testWidgets('chosen dates ask the server, which gives start and end balance',
        (tester) async {
      twoSuppliers();
      suppliersScreens();
      final asked = <Map<String, dynamic>>[];
      server.on('GET', '/supplier-ledger/{id}', (c) {
        asked.add({...c.query});
        final dated = c.query.containsKey('date_from');
        return {
          'items': [
            {
              'id': 'e1',
              'supplier_id': 's1',
              'entry_type': 'sale',
              'amount': '-250',
              'running_balance': '-850',
              'entry_at': '2026-11-10T10:00:00Z',
              'branch_id': kBranch,
            },
          ],
          'total': 1,
          'skip': 0,
          'limit': 50,
          'balance': '-900',
          if (dated) 'opening_balance': '-600',
          if (dated) 'closing_balance': '-850',
        };
      });
      await open(tester, const SupplierLedgerPage(supplierId: 's1'));
      expect(asked.single, isNot(contains('date_from')));
      expect(
        find.byKey(const ValueKey('ledger_opening_balance')),
        findsNothing,
      );

      tester
          .element(find.byType(SupplierLedgerView))
          .read<SupplierLedgerCubit>()
          .setDates(DateTime(2026, 11, 1), DateTime(2026, 11, 15));
      await frames(tester);

      expect(asked.last['date_from'], '2026-11-01');
      expect(asked.last['date_to'], '2026-11-15');
      String shown(String key) =>
          tester.widget<Text>(find.byKey(ValueKey(key))).data!;
      expect(shown('ledger_opening_balance'), contains('600'));
      expect(shown('ledger_closing_balance'), contains('850'));
      // The row carries the server's running balance, not one added up here.
      expect(find.textContaining('850'), findsWidgets);
    });

    testWidgets('the list button is still the list of suppliers',
        (tester) async {
      suppliersScreens();
      await open(tester, const SuppliersListPage());

      final call = await export(tester, find.text('Export'));

      expectRequest(call, 'suppliers', {'format': 'csv'});
      expect(files.lastSavedName, 'suppliers_${today()}.csv');
    });
  });

  // ── customers ─────────────────────────────────────────────────────────

  testWidgets('customer account "Export Ledger": that customer only',
      (tester) async {
    server.on(
      'GET',
      '/customers/{id}',
      (c) => {
        'id': c.params['id'],
        'business_id': kBusiness,
        'name': 'Ali Khan',
        'is_active': true,
      },
    );
    server.on(
      'GET',
      '/customers/{id}/balance',
      (c) => {'customer_id': c.params['id'], 'balance': '-117'},
    );
    server.on('GET', '/customers/{id}/ledger', (_) => <Object>[]);
    final repo = customers();
    factory(
      () => CustomerLedgerCubit(
        getCustomerUseCase: GetCustomerUseCase(repo),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(repo),
        getCustomerLedgerUseCase: GetCustomerLedgerUseCase(repo),
        recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(repo),
        reverseCustomerPaymentUseCase: ReverseCustomerPaymentUseCase(repo),
        shiftGuard: FakeShiftGuard(shiftId: 'shift-1'),
        branchResolver: FakeBranchResolver(kBranch),
        khataEvents: KhataEvents(),
      ),
    );
    await open(tester, const CustomerLedgerPage(customerId: 'c7'));

    final call = await export(tester, find.text('Export Ledger'));

    expectRequest(call, 'customer_ledger', {
      'format': 'csv',
      'customer_id': 'c7',
      'branch_id': kBranch,
    });
    expect(
      files.lastSavedName,
      'Ali Khan ledger ${_day.format(DateTime.now())}.csv',
    );
  });

  testWidgets('customers list "Export": the customers dataset, no filters',
      (tester) async {
    final repo = customers();
    factory(
      () => CustomersListCubit(
        getCustomersUseCase: GetCustomersUseCase(repo),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(repo),
        updateCustomerUseCase: UpdateCustomerUseCase(repo),
      ),
    );
    await open(tester, const CustomersListPage());

    final call = await export(tester, find.text('Export'));

    expectRequest(call, 'customers', {'format': 'csv'});
  });

  // ── expenses, stock, products, purchases, sales ───────────────────────

  testWidgets('expenses "Export": the branch and dates on screen',
      (tester) async {
    final repo = ExpensesRepositoryImpl(
      remoteDataSource: ExpensesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    factory(
      () => ExpensesListCubit(
        getExpensesUseCase: GetExpensesUseCase(repo),
        getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase(repo),
        getSuppliersUseCase: GetSuppliersUseCase(suppliers()),
        deleteExpenseUseCase: DeleteExpenseUseCase(repo),
        authLocalDataSource: OwnerAuth(),
      ),
    );
    await open(tester, const ExpensesListPage());

    final call = await export(tester, find.text('Export'));

    final now = DateTime.now();
    expectRequest(call, 'expenses', {
      'format': 'csv',
      'branch_id': kBranch,
      'date_from': _day.format(DateTime(now.year, now.month, 1)),
      'date_to': _day.format(DateTime(now.year, now.month + 1, 0)),
    });
  });

  testWidgets('inventory "Export": stock of the branch picked', (tester) async {
    final repo = products();
    factory(
      () => InventoryStockCubit(
        getProductsUseCase: GetProductsUseCase(repo),
        getProductByIdUseCase: GetProductByIdUseCase(repo),
        getStockBalancesUseCase: GetStockBalancesUseCase(
          InventoryRepositoryImpl(
            remoteDataSource: InventoryRemoteDataSourceImpl(server.client),
            errorHandler: _errors,
          ),
        ),
      ),
    );
    factory(
      () => CategoriesCubit(
        getCategoriesUseCase: GetCategoriesUseCase(repo),
        createCategoryUseCase: CreateCategoryUseCase(repo),
      ),
    );
    await open(tester, const InventoryStockPage());

    final call = await export(tester, find.text('Export'));

    expectRequest(call, 'inventory', {'format': 'csv', 'branch_id': kBranch});
  });

  testWidgets('expiry report "Export": the expiry dataset of its branch',
      (tester) async {
    bigWindow(tester);
    common();
    await tester.pumpWidget(
      MaterialApp(
        home: ExpiryReportPage(
          branchId: 'br-2',
          loader: ({int withinDays = 30, String? branchId}) async =>
              ExpiryReport.fromJson(const {}),
        ),
      ),
    );
    await frames(tester);

    final call = await export(tester, find.byKey(const Key('expiry-export')));

    expectRequest(call, 'expiry', {
      'format': 'csv',
      'branch_id': 'br-2',
      'within_days': '30',
    });
  });

  testWidgets('products "Export": the products dataset, no filters',
      (tester) async {
    final repo = products();
    factory(
      () => ProductsListCubit(
        getProductsUseCase: GetProductsUseCase(repo),
        deleteProductUseCase: DeleteProductUseCase(repo),
        updateProductUseCase: UpdateProductUseCase(repo),
        getProductByBarcodeUseCase: GetProductByBarcodeUseCase(repo),
        getProductByIdUseCase: GetProductByIdUseCase(repo),
      ),
    );
    factory(
      () => CategoriesCubit(
        getCategoriesUseCase: GetCategoriesUseCase(repo),
        createCategoryUseCase: CreateCategoryUseCase(repo),
      ),
    );
    factory(
      () => BrandsCubit(
        getBrandsUseCase: GetBrandsUseCase(repo),
        createBrandUseCase: CreateBrandUseCase(repo),
      ),
    );
    await open(tester, const ProductsListPage());

    final call = await export(tester, find.text('Export'));

    expectRequest(call, 'products', {'format': 'csv'});
  });

  testWidgets('purchases "Export": every order, as the list shows',
      (tester) async {
    final repo = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
      lineEnricher: PurchaseOrderLineEnricher(GetProductByIdUseCase(products())),
    );
    factory(
      () => PurchaseOrdersListCubit(
        getPurchaseOrdersUseCase: GetPurchaseOrdersUseCase(repo),
        getSuppliersUseCase: GetSuppliersUseCase(suppliers()),
      ),
    );
    await open(tester, const PurchaseOrdersListPage());

    final call = await export(tester, find.text('Export'));

    expectRequest(call, 'purchases', {
      'format': 'csv',
    });
  });

  testWidgets('sales "Export": the branch and dates on screen', (tester) async {
    final repo = SalesRepositoryImpl(
      remoteDataSource: SalesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    factory(
      () => SalesListCubit(
        getSalesUseCase: GetSalesUseCase(repo),
        getSaleByIdUseCase: GetSaleByIdUseCase(repo),
        getProductByIdUseCase: GetProductByIdUseCase(products()),
        authLocalDataSource: OwnerAuth(),
      ),
    );
    await open(tester, const SalesListPage());

    final call = await export(tester, find.text('Export'));

    final now = DateTime.now();
    expectRequest(call, 'sales', {
      'format': 'csv',
      'branch_id': kBranch,
      'date_from': _day.format(DateTime(now.year, now.month, now.day - 6)),
      'date_to': _day.format(now),
    });
  });

  // ── reports ───────────────────────────────────────────────────────────

  group('reports "Export"', () {
    const button = ValueKey('export_report');

    Future<void> openReports(WidgetTester tester, {AccessCubit? access}) async {
      factory(() => ReportsFilterCubit(OwnerAuth()));
      factory<ReportsCubit>(_Reports.new);
      await open(
        tester,
        access == null
            ? const ReportsPage()
            : BlocProvider<AccessCubit>.value(
                value: access,
                child: const ReportsPage(),
              ),
      );
    }

    Map<String, dynamic> lastSevenDays() {
      final filter = ReportsFilter.last7Days();
      return {
        'format': 'csv',
        'branch_id': kBranch,
        'date_from': _day.format(filter.dateFrom),
        'date_to': _day.format(filter.dateTo),
      };
    }

    for (final (tab, dataset) in const [
      ('Sales', 'sales'),
      ('Products & Inventory', 'top_products'),
      ('Customer & Financial', 'profit_loss'),
      ('Time Analysis', 'sales'),
    ]) {
      testWidgets('on "$tab" downloads $dataset', (tester) async {
        await openReports(tester);
        await tester.tap(find.text(tab));
        await frames(tester);

        final call = await export(tester, find.byKey(button));

        expectRequest(call, dataset, lastSevenDays());
      });
    }

    testWidgets('on "Security" is off, with the reason', (tester) async {
      await openReports(tester);
      await tester.tap(find.text('Security'));
      await frames(tester);

      expect(
        tester.widget<OutlinedButton>(find.byKey(button)).onPressed,
        isNull,
      );
      expect(find.byTooltip(noReportExportTooltip), findsOneWidget);
    });

    testWidgets('on "Customer & Financial" needs the financial permission',
        (tester) async {
      await openReports(tester, access: _Access({Perm.reportsExport}));
      expect(
        tester.widget<OutlinedButton>(find.byKey(button)).onPressed,
        isNotNull,
      );
      await tester.tap(find.text('Customer & Financial'));
      await frames(tester);

      expect(
        tester.widget<OutlinedButton>(find.byKey(button)).onPressed,
        isNull,
      );
      expect(
        find.byTooltip(requiresPermissionTooltip([Perm.reportsFinancial])),
        findsOneWidget,
      );
    });
  });
}
