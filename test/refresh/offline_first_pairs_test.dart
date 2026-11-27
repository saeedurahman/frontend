// Pairs whose writes are saved on this computer first and sent later:
// customers, customer payments, expenses, returns, shifts and sale voids.
//
// The server in these tests is reachable but never receives the queued write,
// which is exactly the moment right after "Save": the list has to show the
// record from the device.

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/khata/domain/balance_filter.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/close_shift_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_state.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_state.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_form_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_form_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_state.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/returns/data/datasources/returns_remote_datasource.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/process_return_cubit.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_cubit.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_state.dart';
import 'package:frantend/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_cubit.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_state.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import '../helpers/fake_http.dart';
import '../helpers/fake_rest.dart';
import '../helpers/khata_fakes.dart';
import '../helpers/refresh_contract.dart';
import '../sync/sync_rig.dart';
import 'refresh_fixtures.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';

const _errors = ErrorHandler();

class _NoPriceLists extends Fake implements ProductsRepository {
  @override
  Future<Either<Failure, List<PriceListModel>>> getPriceLists() async =>
      const Right([]);
}

/// The device (sync rig) plus a server that is online but behind.
class _World {
  _World() : rig = SyncRig(start: DateTime.now().toUtc());

  final SyncRig rig;
  final FakeRest server = FakeRest();

  Future<void> seed() async {
    rig.seedServer();
    await rig.sync();
  }

  bool _reachable() => rig.probe.isReachable;

  late final customers = OfflineCustomersRepository(
    remoteDataSource: CustomersRemoteDataSourceImpl(server.client),
    errorHandler: _errors,
    writer: rig.writer,
    catalog: rig.catalog,
    isReachable: _reachable,
  );

  late final cashRegister = OfflineCashRegisterRepository(
    remoteDataSource: CashRegisterRemoteDataSourceImpl(server.client),
    errorHandler: _errors,
    writer: rig.writer,
    catalog: rig.catalog,
    store: rig.store,
    userId: () async => kUser,
    isReachable: _reachable,
  );

  late final expenses = OfflineExpensesRepository(
    remoteDataSource: ExpensesRemoteDataSourceImpl(server.client),
    errorHandler: _errors,
    writer: rig.writer,
    store: rig.store,
  );

  late final returns = OfflineReturnsRepository(
    remoteDataSource: ReturnsRemoteDataSourceImpl(server.client),
    errorHandler: _errors,
    writer: rig.writer,
    store: rig.store,
  );

  late final sales = OfflineSalesRepository(
    remoteDataSource: SalesRemoteDataSourceImpl(server.client),
    errorHandler: _errors,
    writer: rig.writer,
    store: rig.store,
    isReachable: _reachable,
  );

  late final pos = OfflinePosRepository(
    catalog: rig.catalog,
    writer: rig.writer,
    store: rig.store,
    remote: PosRemoteDataSourceImpl(server.client),
    errorHandler: _errors,
    userId: () async => kUser,
  );

  // ── cubits, built as the app builds them ─────────────────────────────

  CustomersListCubit customersList() => CustomersListCubit(
        getCustomersUseCase: GetCustomersUseCase(customers),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(customers),
        updateCustomerUseCase: UpdateCustomerUseCase(customers),
      );

  CustomerFormCubit customerForm() => CustomerFormCubit(
        getCustomerUseCase: GetCustomerUseCase(customers),
        createCustomerUseCase: CreateCustomerUseCase(customers),
        updateCustomerUseCase: UpdateCustomerUseCase(customers),
        productsRepository: _NoPriceLists(),
      );

  CustomerLedgerCubit ledger() => CustomerLedgerCubit(
        getCustomerUseCase: GetCustomerUseCase(customers),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(customers),
        getCustomerLedgerUseCase: GetCustomerLedgerUseCase(customers),
        recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(customers),
        reverseCustomerPaymentUseCase: ReverseCustomerPaymentUseCase(customers),
        shiftGuard: FakeShiftGuard(shiftId: 'shift-1'),
        branchResolver: FakeBranchResolver(kBranch),
        khataEvents: KhataEvents(),
      );

  Future<void> dispose() async {
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await rig.dispose();
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

Map<String, dynamic> _customer(String id, String name) => {
      'id': id,
      'business_id': kBusiness,
      'name': name,
      'is_active': true,
    };

void main() {
  useActiveBranch();

  late _World world;

  setUp(() async {
    world = _World();
    await world.seed();
  });

  tearDown(() => world.dispose());

  T closing<T extends dynamic>(T cubit) {
    addTearDown(() => cubit.close());
    return cubit;
  }

  group('BUG 1: customers', () {
    setUp(() {
      world.server.collection('/customers', seed: [
        _customer('c1', 'Ali Traders'),
        _customer('c2', 'Bilal Store'),
      ]);
      world.server.on(
        'GET',
        '/customers/{id}/balance',
        (call) => {'customer_id': call.params['id'], 'balance': '-1000.00'},
      );
    });

    Future<String?> createThroughForm(String name) async {
      final form = closing(world.customerForm())..initCreate();
      form.updateName(name);
      form.updatePhone('03001234567');
      expect(await form.submit(), isNull);
      return (await world.rig.catalog.unsyncedCustomers()).single.id;
    }

    test('a customer saved by the New Customer form is in the open list at once',
        () async {
      final list = closing(world.customersList());
      await expectCreatedShowsInList(
        list: list,
        open: list.load,
        create: () => createThroughForm('Zubair Medicos'),
        rows: _customerRows,
      );
      // The server never heard of it: it came from this device.
      expect(world.server.log, isNot(contains('POST /customers')));
    });

    test('filters set earlier do not hide the new customer', () async {
      final list = closing(world.customersList());
      await expectCreatedShowsInList(
        list: list,
        open: () async {
          await list.load();
          await settle(list);
          list.setBalanceFilter(BalanceFilter.owing);
          list.setActiveFilter(CustomerActiveFilter.active);
        },
        create: () => createThroughForm('Zubair Medicos'),
        rows: _customerRows,
      );
    });

    test('it stays listed when the screen reloads before the sync', () async {
      final id = await createThroughForm('Zubair Medicos');
      final list = closing(world.customersList());
      await list.load();
      await settle(list);
      expect(_customerRows(list.state), contains(id));
    });
  });

  group('BUG 2: customer payments', () {
    setUp(() {
      world.server.on(
        'GET',
        '/customers/{id}',
        (_) => _customer('c1', 'Ali Traders'),
      );
      world.server.on(
        'GET',
        '/customers/{id}/balance',
        (_) => {'customer_id': 'c1', 'balance': '-1000.00'},
      );
      world.server.on(
        'GET',
        '/customers/{id}/ledger',
        (call) => (call.query['skip'] ?? 0) != 0
            ? <Object>[]
            : [
                {
                  'id': 'entry-1',
                  'business_id': kBusiness,
                  'customer_id': 'c1',
                  'entry_type': 'sale',
                  'amount': '-1000.00',
                  'entry_at': '2026-10-01T10:00:00Z',
                  'branch_id': kBranch,
                },
              ],
      );
    });

    for (final method in ['cash', 'bank_transfer']) {
      test('a $method payment shows its row and the new balance at once',
          () async {
        final ledger = closing(world.ledger());
        final after = await expectPaymentShowsAtOnce(
          ledger: ledger,
          open: () => ledger.load('c1'),
          pay: () async {
            final result = await ledger.recordPayment(
              amount: Decimal.fromInt(50),
              source: method == 'cash' ? PaymentSource.drawer : PaymentSource.bank,
              referenceNo: method == 'cash' ? null : 'TRX-1',
            );
            expect(result, isNotNull, reason: '${ledger.state}');
          },
          read: _ledgerView,
          balanceAfter: Decimal.parse('-950'),
        );
        expect(after.rows.first, isNot('entry-1'), reason: 'newest on top');
      });
    }

    test('reversing a payment shows its row and the new balance at once',
        () async {
      var balance = '-950.00';
      Map<String, dynamic> line(
        String id,
        String type,
        String amount,
        String running,
      ) =>
          {
            'id': id,
            'business_id': kBusiness,
            'customer_id': 'c1',
            'entry_type': type,
            'amount': amount,
            'running_balance': running,
            'entry_at': '2026-10-02T10:00:00Z',
            'branch_id': kBranch,
          };
      final lines = [
        line('pay-1', 'payment', '50.00', '-950.00'),
        line('entry-1', 'sale', '-1000.00', '-1000.00'),
      ];
      world.server.on(
        'GET',
        '/customers/{id}/balance',
        (_) => {'customer_id': 'c1', 'balance': balance},
      );
      world.server.on(
        'GET',
        '/customers/{id}/ledger',
        (call) => (call.query['skip'] ?? 0) != 0 ? <Object>[] : lines,
      );
      world.server.on('POST', '/customers/payments/{id}/reverse', (call) {
        balance = '-1000.00';
        lines.insert(0, line('rev-1', 'adjustment', '-50.00', balance));
        return {
          'reversal_id': 'rev-1',
          'original_id': 'pay-1',
          'party_id': 'c1',
          'amount': '50.00',
          'reason': call.body['reason'],
          'drawer_reversed': false,
          'balance': balance,
        };
      });
      final ledger = closing(world.ledger());

      await expectPaymentShowsAtOnce(
        ledger: ledger,
        open: () => ledger.load('c1'),
        pay: () async {
          expect(await ledger.reversePayment('pay-1', 'Wrong amount'), isNull);
        },
        read: _ledgerView,
        balanceAfter: Decimal.parse('-1000'),
      );
    });

    test('a payment saved elsewhere updates the open ledger and the list',
        () async {
      world.server.collection('/customers', seed: [
        _customer('c1', 'Ali Traders'),
      ]);
      final list = closing(world.customersList());
      await list.load();
      final ledger = closing(world.ledger());

      await expectPaymentShowsAtOnce(
        ledger: ledger,
        open: () => ledger.load('c1'),
        pay: () async {
          final paid = await RecordCustomerPaymentUseCase(world.customers)(
            'c1',
            amount: Decimal.fromInt(50),
            paymentSource: 'cash',
            registerShiftId: 'shift-1',
            branchId: kBranch,
          );
          expect(paid.isRight(), isTrue);
        },
        read: _ledgerView,
        balanceAfter: Decimal.parse('-950'),
      );

      await settle(list);
      final row = (list.state as CustomersListLoaded).filteredItems.single;
      expect(Decimal.parse(row.balance!), Decimal.parse('-950'));
    });
  });

  test('expenses: a saved expense is on top of the open list at once', () async {
    world.server.collection('/expenses/categories', seed: [
      {'id': 'cat-e', 'name': 'Rent'},
    ]);
    world.server.on('GET', '/suppliers', (_) => <Object>[]);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    world.server.on(
      'GET',
      '/expenses',
      (_) => {
        'items': [
          {
            'id': 'exp-1',
            'branch_id': kBranch,
            'expense_category_id': 'cat-e',
            'expense_number': 'EXP-1',
            'expense_date': today,
            'amount': '10.00',
          },
        ],
        'total': 1,
        'skip': 0,
        'limit': 50,
      },
    );

    final getSuppliers = GetSuppliersUseCase(SuppliersRepositoryImpl(
      remoteDataSource: SuppliersRemoteDataSourceImpl(world.server.client),
      errorHandler: _errors,
    ));
    final list = closing(ExpensesListCubit(
      getExpensesUseCase: GetExpensesUseCase(world.expenses),
      getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase(world.expenses),
      getSuppliersUseCase: getSuppliers,
      deleteExpenseUseCase: DeleteExpenseUseCase(world.expenses),
      authLocalDataSource: OwnerAuth(),
    ));
    final form = closing(ExpenseFormCubit(
      getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase(world.expenses),
      getSuppliersUseCase: getSuppliers,
      getExpenseByIdUseCase: GetExpenseByIdUseCase(world.expenses),
      createExpenseUseCase: CreateExpenseUseCase(world.expenses),
      updateExpenseUseCase: UpdateExpenseUseCase(world.expenses),
      getMyActiveShiftUseCase: GetMyActiveShiftUseCase(world.cashRegister),
      authLocalDataSource: OwnerAuth(),
    ));

    await expectCreatedShowsInList(
      list: list,
      open: list.init,
      create: () async {
        await form.init();
        form.setCategoryId('cat-e');
        form.setAmount('250');
        form.setDescription('Shop rent');
        return (await form.save())?.id;
      },
      rows: (s) => s is ExpensesListLoaded
          ? [for (final e in s.items) e.id]
          : null,
    );
  });

  test('returns: a processed return is on top of the open list at once',
      () async {
    world.server.on(
      'GET',
      '/returns',
      (_) => [
        {
          'id': 'ret-1',
          'business_id': kBusiness,
          'branch_id': kBranch,
          'return_number': 'R-1',
        },
      ],
    );
    world.server.on(
      'GET',
      '/sales/{id}',
      (_) => {
        'id': 'sale-1',
        'branch_id': kBranch,
        'sale_type': 'pos',
        'sale_status': 'completed',
        'total_amount': '100.00',
        'lines': [
          {
            'id': 'line-1',
            'product_id': 'p1',
            'qty': '1',
            'unit_price': '100.00',
            'tax_amount': '0',
          },
        ],
      },
    );

    final list = closing(ReturnsListCubit(
      getReturnsUseCase: GetReturnsUseCase(world.returns),
      authLocalDataSource: OwnerAuth(),
    ));
    final form = closing(ProcessReturnCubit(
      getSaleByIdUseCase: GetSaleByIdUseCase(world.sales),
      getCustomerUseCase: GetCustomerUseCase(world.customers),
      createSaleReturnUseCase: CreateSaleReturnUseCase(world.returns),
      getMyActiveShiftUseCase: GetMyActiveShiftUseCase(world.cashRegister),
      authLocalDataSource: OwnerAuth(),
      shiftGuard: FakeShiftGuard(),
    ));

    await expectCreatedShowsInList(
      list: list,
      open: list.loadReturns,
      create: () async {
        await form.load('sale-1');
        form.returnAll(0);
        form.setReason('Damaged');
        form.addRefundLine(method: 'card', label: 'Card');
        expect(await form.submitReturn(), isNotNull,
            reason: '${form.state.error} ${form.state.submitError}');
        return (await world.returns.pendingReturns()).single.id;
      },
      rows: (s) => s is ReturnsListLoaded
          ? [for (final r in s.items) r.id]
          : null,
    );
  });

  test('shifts: opening and closing update the shift screens at once', () async {
    world.server.on(
      'GET',
      '/registers/{id}/active-shift',
      (_) => jsonResponse({'detail': 'No open shift'}, status: 404),
    );
    world.server.on(
      'GET',
      '/shifts',
      (_) => [
        {
          'id': 'old-shift',
          'cash_register_id': 'reg-1',
          'branch_id': kBranch,
          'status': 'closed',
          'opened_at': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        },
      ],
    );

    final current = closing(CurrentShiftCubit(
      getRegistersUseCase: GetCashRegistersUseCase(world.cashRegister),
      getActiveShiftUseCase: GetActiveRegisterShiftUseCase(world.cashRegister),
      getShiftSummaryUseCase:
          GetRegisterShiftSummaryUseCase(world.cashRegister),
      authLocalDataSource: OwnerAuth(),
    ));
    final history = closing(ShiftHistoryCubit(
      getShiftsUseCase: GetRegisterShiftsUseCase(world.cashRegister),
      getRegistersUseCase: GetCashRegistersUseCase(world.cashRegister),
      authLocalDataSource: OwnerAuth(),
    ));
    await history.init();

    List<String>? openRows(CurrentShiftState s) =>
        s.isLoading || s.error != null
            ? null
            : [for (final e in s.openShifts) e.shift.id];

    final shiftId = await expectCreatedShowsInList(
      list: current,
      open: current.load,
      create: () async {
        final opened = await world.pos.openShift({
          'cash_register_id': 'reg-1',
          'opening_float': '100',
        });
        return opened.fold((f) => null, (s) => s.id);
      },
      rows: openRows,
    );

    List<String>? closedRows(ShiftHistoryState s) =>
        s.isLoading || s.error != null
            ? null
            : [for (final shift in s.shifts) shift.id];

    await expectCreatedShowsInList(
      list: history,
      open: () async {},
      create: () async {
        final close = closing(CloseShiftCubit(
          closeShiftUseCase: CloseRegisterShiftUseCase(world.cashRegister),
          authLocalDataSource: OwnerAuth(),
        ));
        await close.init(
          shiftId: shiftId,
          summary: current.state.openShifts.single.summary!,
          registerName: 'Front',
        );
        close.setActualCash('100');
        close.confirmVariance();
        expect(await close.submit(), isNotNull,
            reason: '${close.state.submitError}');
        return shiftId;
      },
      rows: closedRows,
    );

    await settle(current);
    expect(openRows(current.state), isEmpty);
  });

  test('sales: a voided sale reads "voided" in the open list at once', () async {
    final sale = {
      'id': 'sale-1',
      'business_id': kBusiness,
      'branch_id': kBranch,
      'sale_number': 'S-1',
      'sale_type': 'pos',
      'status': 'completed',
      'sold_at': DateTime.now().toIso8601String(),
      'product_names': ['Rice 5kg'],
    };
    world.server.on(
      'GET',
      '/sales',
      (_) => {
        'items': [sale],
        'total': 1,
        'skip': 0,
        'limit': 10,
      },
    );
    world.server.on('GET', '/sales/{id}', (_) => {...sale, 'lines': <Object>[]});

    final list = closing(SalesListCubit(
      getSalesUseCase: GetSalesUseCase(world.sales),
      getSaleByIdUseCase: GetSaleByIdUseCase(world.sales),
      getProductByIdUseCase:
          GetProductByIdUseCase(LocalProductsRepository(world.rig.catalog)),
      authLocalDataSource: OwnerAuth(),
    ));
    await list.init();
    expect((list.state as SalesListLoaded).items.single.status, 'completed');

    expect((await world.sales.voidSale('sale-1')).isRight(), isTrue);
    await settle(list);

    expect((list.state as SalesListLoaded).items.single.status, 'voided');
  });
}
