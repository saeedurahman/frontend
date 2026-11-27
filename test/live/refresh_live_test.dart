// The two refresh bugs against a REAL backend (its TEST database), wired like
// the app: offline-first repositories, a device store with its outbox, the real
// sync engine and the app's real cubits.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/refresh_live_test.dart
//
// 1. "New Customer": the open customers list shows the customer at once, before
//    anything was sent to the server, and exactly once after sync.
// 2. Credit sale, then "Record Payment" 50 in cash inside an open shift: the
//    open ledger shows the new row and 50 less owed at once, and still one row
//    after sync.
//
// Nothing here navigates, reloads a cubit by hand or waits for a timer.
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/data_change_interceptor.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/core/sync/http_sync_api.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/pending_ledger.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_form_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/shift_guard.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart'
    show CreateRegisterUseCase, GetRegistersUseCase, OpenShiftUseCase;
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';

import '../helpers/khata_fakes.dart';
import '../helpers/refresh_contract.dart';
import 'live_backend.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';

const _errors = ErrorHandler();

class _NoPriceLists extends Fake implements ProductsRepository {
  @override
  Future<Either<Failure, List<PriceListModel>>> getPriceLists() async =>
      const Right([]);
}

class _NoProducts extends Fake implements GetProductByIdUseCase {}

T _ok<T>(Either<Failure, T> r, [String what = 'call']) => r.fold(
      (f) => fail('$what failed: ${f.message}'),
      (v) => v,
    );

/// This computer: its database, outbox and sync engine, talking to the real
/// server. The engine is never started, so nothing is sent until [sync].
class _Device {
  _Device(this.tenant, this.userId) {
    final deviceId = _ids.newId();
    // What the app's own client adds to every request.
    tenant.dio.interceptors
      ..add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Device-ID'] = deviceId;
          options.headers['X-App-Version'] = '1.0.0';
          handler.next(options);
        },
      ))
      ..add(DataChangeInterceptor());

    store = SyncStore(db);
    writer = OfflineWriter(
      store: store,
      ids: _ids,
      deviceId: () async => deviceId,
      actingUser: () async => ActingUser(
        id: userId,
        name: 'Live Owner',
        businessId: tenant.businessId,
        branchId: tenant.branchId,
      ),
    );
    catalog = LocalCatalog(store, businessId: () async => tenant.businessId);
    final api = HttpSyncApi(
      dio: tenant.dio,
      deviceId: () async => deviceId,
      deviceName: () async => 'Live test PC',
      appVersion: '1.0.0',
    );
    const config = SyncConfig();
    engine = SyncEngine(
      store: store,
      push: PushService(store: store, api: api, ids: _ids, config: config),
      pull: PullService(
        store: store,
        api: api,
        config: config,
        currentUserId: () async => userId,
      ),
      probe: FixedConnectivityProbe(),
      config: config,
    );
  }

  final LiveTenant tenant;
  final String userId;
  final IdGenerator _ids = UuidIdGenerator();
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  late final SyncStore store;
  late final OfflineWriter writer;
  late final LocalCatalog catalog;
  late final SyncEngine engine;

  /// One push-then-pull; everything queued must be accepted.
  Future<void> sync() async {
    await engine.syncNow(manual: true);
    expect(engine.state.lastError, isNull, reason: 'sync failed');
    final counts = await store.counts();
    expect(counts.unfinished, 0, reason: 'something was not accepted: $counts');
  }

  Future<void> dispose() async {
    engine.dispose();
    store.dispose();
    await db.close();
  }
}

List<String>? _customerRows(CustomersListState s) => s is CustomersListLoaded
    ? [for (final r in s.filteredItems) r.customer.id]
    : null;

LedgerView? _ledgerView(CustomerLedgerState s) => s is CustomerLedgerLoaded
    ? (
        rows: [for (final r in s.entries) r.entry.id],
        balance: Decimal.parse(s.balance),
      )
    : null;

void main() {
  if (liveSkip != false) {
    test('live refresh test', () {}, skip: liveSkip);
    return;
  }

  final timings = <String, int>{};
  Future<T> timed<T>(String label, Future<T> Function() body) async {
    final sw = Stopwatch()..start();
    final out = await body();
    timings[label] = sw.elapsedMilliseconds;
    return out;
  }

  late LiveTenant tenant;
  late _Device device;
  late String productId;
  late OfflineCustomersRepository customers;
  late OfflineCashRegisterRepository cashRegister;
  late ShiftGuard shifts;

  setUpAll(() async {
    tenant = await LiveTenant.register(liveApiBase()!, label: 'Refresh Live');
    final me = await tenant.get('/auth/me');
    final userId = '${me['id'] ?? (me['user'] as Map)['id']}';
    device = _Device(tenant, userId);

    // Stock to sell and a counter to open the shift on.
    final supplierId = (await tenant.post('/suppliers', {
      'name': 'Live Supplier',
      'phone': '3001234567',
    }))['id'] as String;
    productId = (await tenant.post('/products', {
      'name': 'Panadol ${DateTime.now().millisecondsSinceEpoch}',
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': 'none',
    }))['id'] as String;
    final purchases = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
      lineEnricher: PurchaseOrderLineEnricher(_NoProducts()),
    );
    _ok(
      await CreatePurchaseReceiptUseCase(purchases)(
        CreatePurchaseReceiptParams(
          branchId: tenant.branchId,
          supplierId: supplierId,
          receivedAt: DateTime.now(),
          lines: [
            CreatePurchaseReceiptLineParams(
              productId: productId,
              qtyReceived: Decimal.fromInt(20),
              costPerUnit: Decimal.fromInt(50),
            ),
          ],
        ),
      ),
      'goods receipt',
    );
    await tenant.post('/registers', {
      'name': 'Front Counter',
      'branch_id': tenant.branchId,
    });

    customers = OfflineCustomersRepository(
      remoteDataSource: CustomersRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
      writer: device.writer,
      catalog: device.catalog,
      isReachable: () => true,
    );
    cashRegister = OfflineCashRegisterRepository(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
      writer: device.writer,
      catalog: device.catalog,
      store: device.store,
      userId: () async => userId,
      isReachable: () => true,
    );
    final pos = OfflinePosRepository(
      catalog: device.catalog,
      writer: device.writer,
      store: device.store,
      remote: PosRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
      userId: () async => userId,
    );
    shifts = ShiftGuard(
      GetMyActiveShiftUseCase(cashRegister),
      GetRegistersUseCase(pos),
      CreateRegisterUseCase(pos),
      OpenShiftUseCase(pos),
      FakeBranchResolver(tenant.branchId),
    );

    await device.sync(); // the first download, as after signing in
  });

  tearDownAll(() async {
    await device.dispose();
  });

  test('new customer and recorded payment show at once, without navigation',
      () async {
    // ── BUG 1: "New Customer" ────────────────────────────────────────────
    await tenant.post('/customers', {'name': 'Zubair Existing'});
    final list = CustomersListCubit(
      getCustomersUseCase: GetCustomersUseCase(customers),
      getCustomerBalanceUseCase: GetCustomerBalanceUseCase(customers),
      updateCustomerUseCase: UpdateCustomerUseCase(customers),
    );
    final customerId = await timed(
      'create customer -> in the open list',
      () => expectCreatedShowsInList<CustomersListState>(
        list: list,
        open: list.load,
        create: () async {
          final form = CustomerFormCubit(
            getCustomerUseCase: GetCustomerUseCase(customers),
            createCustomerUseCase: CreateCustomerUseCase(customers),
            updateCustomerUseCase: UpdateCustomerUseCase(customers),
            productsRepository: _NoPriceLists(),
          )
            ..initCreate()
            ..updateName('Ahmed Khan Live')
            ..updatePhone('03001112222')
            ..updateCreditLimit('5000');
          expect(await form.submit(), isNull);
          await form.close();
          final mine = await device.catalog.unsyncedCustomers();
          return mine.single.id;
        },
        rows: _customerRows,
      ),
    );

    Future<List<String>> serverCustomerIds() async => [
          for (final row in await tenant.getList('/customers'))
            '${(row as Map)['id']}',
        ];
    expect(await serverCustomerIds(), isNot(contains(customerId)),
        reason: 'the row was shown before the server had it');

    await timed('sync the new customer', device.sync);
    await settle(list);
    expect(await serverCustomerIds(), contains(customerId));
    expect(_customerRows(list.state)!.where((id) => id == customerId),
        hasLength(1));

    // A customer saved through the online repository (another screen of this
    // app) reaches the open list as well.
    final online = CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
    );
    await expectCreatedShowsInList<CustomersListState>(
      list: list,
      open: () async {},
      create: () async => _ok(
        await CreateCustomerUseCase(online)({'name': 'Bilal Online Live'}),
        'online create',
      ).id,
      rows: _customerRows,
    );
    await list.close();

    // ── BUG 2: credit sale, then a cash payment in an open shift ─────────
    final shiftId = _ok(await shifts.openNow(), 'open shift');
    final sale = await device.writer.saveSale({
      'branch_id': tenant.branchId,
      'sale_type': 'pos',
      'register_shift_id': shiftId,
      'customer_id': customerId,
      'lines': [
        {
          'product_id': productId,
          'qty': '2',
          'unit_price': '100.00',
          'discount_pct': '0',
          'discount_amount': '0',
          'tax_rate': '0',
        },
      ],
      'payments': [
        {'payment_method': PaymentMethods.credit, 'amount': '200.00'},
      ],
    });
    await timed('sync the shift and credit sale', device.sync);

    Future<List<Map<dynamic, dynamic>>> serverLedger() async =>
        (await tenant.getList('/customers/$customerId/ledger'))
            .cast<Map<dynamic, dynamic>>();
    Future<Decimal> serverBalance() async => Decimal.parse(
        '${(await tenant.get('/customers/$customerId/balance'))['balance']}');
    expect(await serverBalance(), Decimal.parse('-200'),
        reason: 'sale ${sale['id']} put 200 on the account');

    final ledger = CustomerLedgerCubit(
      getCustomerUseCase: GetCustomerUseCase(customers),
      getCustomerBalanceUseCase: GetCustomerBalanceUseCase(customers),
      getCustomerLedgerUseCase: GetCustomerLedgerUseCase(customers),
      recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(customers),
      reverseCustomerPaymentUseCase: ReverseCustomerPaymentUseCase(customers),
      shiftGuard: shifts,
      branchResolver: FakeBranchResolver(tenant.branchId),
      khataEvents: KhataEvents(),
    );
    late String paymentId;
    final after = await timed(
      'record cash 50 -> row and balance on screen',
      () => expectPaymentShowsAtOnce<CustomerLedgerState>(
        ledger: ledger,
        open: () => ledger.load(customerId, branchId: tenant.branchId),
        pay: () async {
          final paid = await ledger.recordPayment(
            amount: Decimal.fromInt(50),
            source: PaymentSource.drawer,
          );
          expect(paid, isNotNull,
              reason: '${(ledger.state as CustomerLedgerLoaded).paymentError}');
          paymentId = paid!.ledgerEntryId;
        },
        read: _ledgerView,
        balanceAfter: Decimal.parse('-150'), // owed dropped from 200 to 150
      ),
    );
    expect(after.rows.first, paymentId, reason: 'newest line on top');
    expect(await serverBalance(), Decimal.parse('-200'),
        reason: 'the row was shown before the server had it');

    await timed('sync the payment', device.sync);
    await settle(ledger);
    final synced = _ledgerView(ledger.state)!;
    expect(synced.balance, Decimal.parse('-150'));
    expect(synced.rows, hasLength(after.rows.length),
        reason: 'the device line was replaced, not doubled');
    expect(
      (ledger.state as CustomerLedgerLoaded)
          .entries
          .where((r) => r.entry.isOnDeviceOnly),
      isEmpty,
    );
    expect(await serverBalance(), Decimal.parse('-150'));
    final payments = [
      for (final row in await serverLedger())
        if (row['entry_type'] == 'payment') row,
    ];
    expect(payments, hasLength(1));
    expect(payments.single['branch_id'], tenant.branchId);
    final summary =
        await tenant.get('/shifts/$shiftId/summary');
    expect(Decimal.parse('${summary['expected_cash']}'), Decimal.parse('50'),
        reason: 'the 50 is in the drawer of that shift: $summary');
    await ledger.close();

    // ignore: avoid_print
    print('\nLIVE REFRESH TIMINGS (ms): $timings');
  }, timeout: const Timeout(Duration(minutes: 3)));
}
