// Pairs whose writes go straight to the server. Real data sources,
// repositories, use cases and cubits over an in-memory REST server that adds
// new rows at the END of a list, so "on top" is the app's own doing.
//
// "Form" and "list" are always two separate cubits: nothing but the shared
// change announcement connects them.

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/core/tax/tax_settings_store.dart';
import 'package:frantend/features/branches/data/datasources/branches_remote_datasource.dart';
import 'package:frantend/features/branches/data/repositories/branches_repository_impl.dart';
import 'package:frantend/features/branches/domain/usecases/branches_usecases.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_cubit.dart';
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_state.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_state.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_cubit.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_unit_usecase.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_units_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/brands_state.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:frantend/features/products/presentation/cubit/price_lists_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';
import 'package:frantend/features/products/presentation/cubit/units_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/units_state.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_state.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_form_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/roles/data/datasources/roles_remote_datasource.dart';
import 'package:frantend/features/roles/data/repositories/roles_repository_impl.dart';
import 'package:frantend/features/roles/domain/usecases/roles_usecases.dart';
import 'package:frantend/features/roles/presentation/cubit/role_form_cubit.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_cubit.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_state.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:frantend/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_state.dart';
import 'package:frantend/features/settings/presentation/cubit/tax_prices_cubit.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/features/users/data/datasources/users_remote_datasource.dart';
import 'package:frantend/features/users/data/repositories/users_repository_impl.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';
import 'package:frantend/features/users/presentation/cubit/user_form_cubit.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_cubit.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_state.dart';

import '../helpers/fake_rest.dart';
import '../helpers/khata_fakes.dart';
import '../helpers/refresh_contract.dart';
import '../sync/sync_rig.dart';
import 'refresh_fixtures.dart';

const _errors = ErrorHandler();

Map<String, dynamic> _named(String id, String name) => {
      'id': id,
      'business_id': kBusiness,
      'name': name,
    };

/// A supplier account on the fake server: rows newest first, one balance.
class _SupplierAccount {
  _SupplierAccount(this.server) {
    server.on('GET', '/suppliers/{id}', (_) => _named('s1', 'Medi Distributors'));
    server.on(
      'GET',
      '/supplier-ledger/{id}/balance',
      (_) => {'supplier_id': 's1', 'balance': '$balance'},
    );
    server.on('GET', '/supplier-ledger/{id}', (call) {
      final skip = int.tryParse('${call.query['skip'] ?? 0}') ?? 0;
      return {
        'items': entries.skip(skip).toList(),
        'total': entries.length,
        'skip': skip,
        'limit': 50,
        'balance': '$balance',
      };
    });
    server.on('POST', '/suppliers/payments', (call) {
      final amount = Decimal.parse('${call.body['amount']}');
      final before = balance;
      balance += amount;
      final id = server.newId('pay');
      _add(id, 'payment', amount);
      return {
        'id': id,
        'amount': '$amount',
        'payment_source': call.body['payment_source'],
        'balance_before': '$before',
        'balance': '$balance',
        'register_shift_id': call.body['register_shift_id'],
      };
    });
    server.on('POST', '/suppliers/payments/{id}/reverse', (call) {
      final original = entries.firstWhere((e) => e['id'] == call.params['id']);
      final amount = Decimal.parse('${original['amount']}');
      balance -= amount;
      original['reversed_at'] = '2026-11-02T10:00:00Z';
      final id = server.newId('rev');
      _add(id, 'payment_reversal', -amount);
      return {
        'reversal_id': id,
        'original_id': call.params['id'],
        'party_id': 's1',
        'amount': '$amount',
        'reason': call.body['reason'],
        'drawer_reversed': false,
        'balance': '$balance',
      };
    });
  }

  final FakeRest server;
  Decimal balance = Decimal.fromInt(-1000);

  final List<Map<String, dynamic>> entries = [
    {
      'id': 'entry-1',
      'supplier_id': 's1',
      'entry_type': 'purchase',
      'amount': '-1000',
      'entry_at': '2026-11-01T10:00:00Z',
      'branch_id': kBranch,
    },
  ];

  void _add(String id, String type, Decimal amount) => entries.insert(0, {
        'id': id,
        'supplier_id': 's1',
        'entry_type': type,
        'amount': '$amount',
        'entry_at': '2026-11-02T10:00:00Z',
        'branch_id': kBranch,
      });
}

void main() {
  useActiveBranch();

  late FakeRest server;
  setUp(() => server = FakeRest());

  T closing<T extends dynamic>(T cubit) {
    addTearDown(() => cubit.close());
    return cubit;
  }

  SuppliersRepositoryImpl suppliersRepo() => SuppliersRepositoryImpl(
        remoteDataSource: SuppliersRemoteDataSourceImpl(server.client),
        errorHandler: _errors,
      );

  ProductsRepositoryImpl productsRepo() => ProductsRepositoryImpl(
        remoteDataSource: ProductsRemoteDataSourceImpl(server.client),
        localDataSource: NoProductCache(),
        connectivityProbe: FixedConnectivityProbe()
          ..set(ReachabilityStatus.online),
        errorHandler: _errors,
      );

  // ── suppliers ────────────────────────────────────────────────────────

  SuppliersListCubit suppliersList() {
    final repo = suppliersRepo();
    return closing(SuppliersListCubit(
      getSuppliersUseCase: GetSuppliersUseCase(repo),
      getSupplierBalanceUseCase: GetSupplierBalanceUseCase(repo),
      updateSupplierUseCase: UpdateSupplierUseCase(repo),
      deleteSupplierUseCase: DeleteSupplierUseCase(repo),
      createSupplierUseCase: CreateSupplierUseCase(repo),
    ));
  }

  SupplierLedgerCubit supplierLedger() {
    final repo = suppliersRepo();
    return closing(SupplierLedgerCubit(
      GetSupplierUseCase(repo),
      GetSupplierLedgerUseCase(repo),
      ReverseSupplierPaymentUseCase(repo),
      FakeBranchResolver(kBranch),
      KhataEvents(),
    ));
  }

  SupplierPaymentCubit supplierPayment() {
    final repo = suppliersRepo();
    return closing(SupplierPaymentCubit(
      GetSupplierBalanceUseCase(repo),
      GetSupplierUseCase(repo),
      PaySupplierUseCase(repo),
      FakeShiftGuard(shiftId: 'shift-1'),
      FakeBranchResolver(kBranch),
      MemoryPaymentSourceStore(),
      KhataEvents(),
    ));
  }

  LedgerView? supplierView(SupplierLedgerState s) {
    if (s.error != null) printOnFailure('supplier ledger: ${s.error}');
    return s.loading || s.balance == null
          ? null
          : (rows: [for (final e in s.entries) e.id], balance: s.balance!);
  }

  test('suppliers: a supplier saved by the form is on top of the open list',
      () async {
    server.collection(
      '/suppliers',
      seed: [_named('s1', 'Medi Distributors')],
      created: (_) => {'business_id': kBusiness},
    );
    server.on(
      'GET',
      '/supplier-ledger/{id}/balance',
      (call) => {'supplier_id': call.params['id'], 'balance': '0'},
    );
    final repo = suppliersRepo();
    final list = suppliersList();

    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async {
        final form = closing(SupplierFormCubit(
          getSupplierUseCase: GetSupplierUseCase(repo),
          createSupplierUseCase: CreateSupplierUseCase(repo),
          updateSupplierUseCase: UpdateSupplierUseCase(repo),
        ))
          ..initCreate()
          ..updateName('Zam Pharma');
        expect(await form.submit(), isNull);
        return server.log.contains('POST /suppliers') ? 'srv-1' : null;
      },
      rows: (s) => s is SuppliersListLoaded
          ? [for (final r in s.filteredItems) r.supplier.id]
          : null,
    );
  });

  test('supplier payment: ledger row and balance show at once', () async {
    final account = _SupplierAccount(server);
    server.on('GET', '/suppliers', (_) => [_named('s1', 'Medi Distributors')]);
    final list = suppliersList();
    await list.load();
    final ledger = supplierLedger();

    await expectPaymentShowsAtOnce(
      ledger: ledger,
      open: () => ledger.load('s1'),
      pay: () async {
        final pay = supplierPayment();
        await pay.init(supplierId: 's1', supplierName: 'Medi Distributors');
        pay.setAmount('50');
        pay.setSource(PaymentSource.drawer);
        expect(await pay.submit(), isTrue, reason: '${pay.state.error}');
      },
      read: supplierView,
      balanceAfter: Decimal.fromInt(-950),
    );

    await settle(list);
    final row = (list.state as SuppliersListLoaded).filteredItems.single;
    expect(Decimal.parse(row.balance!), account.balance);
  });

  test('supplier payment reversal: its row and the balance show at once',
      () async {
    final account = _SupplierAccount(server);
    account.balance = Decimal.fromInt(-950);
    account._add('pay-0', 'payment', Decimal.fromInt(50));
    final ledger = supplierLedger();
    // A second screen on the same account, which did not do the reversal.
    final other = supplierLedger();
    await other.load('s1');

    final after = await expectPaymentShowsAtOnce(
      ledger: ledger,
      open: () => ledger.load('s1'),
      pay: () async {
        expect(await ledger.reversePayment('pay-0', 'Wrong amount'), isNull);
      },
      read: supplierView,
      balanceAfter: Decimal.fromInt(-1000),
    );

    await settle(other);
    expect(supplierView(other.state)!.rows, after.rows);
    expect(supplierView(other.state)!.balance, after.balance);
  });

  test('cash movements: money paid from the drawer updates the shift screen',
      () async {
    _SupplierAccount(server);
    var cashOut = Decimal.zero;
    server.on(
      'POST',
      '/suppliers/payments',
      (call) {
        cashOut += Decimal.parse('${call.body['amount']}');
        return {
          'id': 'pay-1',
          'amount': '${call.body['amount']}',
          'payment_source': 'drawer',
          'balance_before': '-1000',
          'balance': '-950',
          'register_shift_id': 'shift-1',
        };
      },
    );
    server.on(
      'GET',
      '/registers',
      (_) => [
        {'id': 'reg-1', 'branch_id': kBranch, 'name': 'Front'},
      ],
    );
    server.on(
      'GET',
      '/registers/{id}/active-shift',
      (_) => {
        'id': 'shift-1',
        'cash_register_id': 'reg-1',
        'status': 'open',
      },
    );
    server.on(
      'GET',
      '/shifts/{id}/summary',
      (_) => {
        'shift_id': 'shift-1',
        'total_cash_out': '$cashOut',
        'expected_cash': '${Decimal.fromInt(500) - cashOut}',
      },
    );
    final registers = CashRegisterRepositoryImpl(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final shift = closing(CurrentShiftCubit(
      getRegistersUseCase: GetCashRegistersUseCase(registers),
      getActiveShiftUseCase: GetActiveRegisterShiftUseCase(registers),
      getShiftSummaryUseCase: GetRegisterShiftSummaryUseCase(registers),
      authLocalDataSource: OwnerAuth(),
    ));
    await shift.load();
    await settle(shift);
    expect(shift.state.openShifts.single.summary!.expectedCash, '500');

    final pay = supplierPayment();
    await pay.init(supplierId: 's1', supplierName: 'Medi Distributors');
    pay.setAmount('50');
    pay.setSource(PaymentSource.drawer);
    expect(await pay.submit(), isTrue, reason: '${pay.state.error}');
    await settle(shift);

    expect(shift.state.openShifts.single.summary!.expectedCash, '450');
  });

  // ── expenses ─────────────────────────────────────────────────────────

  ExpensesRepositoryImpl expensesRepo() => ExpensesRepositoryImpl(
        remoteDataSource: ExpensesRemoteDataSourceImpl(server.client),
        errorHandler: _errors,
      );

  test('expense payment: its row and the amount left show at once', () async {
    final payments = <Map<String, dynamic>>[];
    server.on(
      'GET',
      '/expenses/{id}',
      (_) => {
        'id': 'e1',
        'branch_id': kBranch,
        'expense_category_id': 'cat-e',
        'expense_number': 'EXP-1',
        'expense_date': '2026-11-01',
        'amount': '500',
        'payments': payments,
      },
    );
    server.on('GET', '/expenses/categories', (_) => <Object>[]);
    server.on('POST', '/expenses/{id}/payments', (call) {
      payments.add({
        'id': 'ep-1',
        'expense_id': 'e1',
        'payment_method': call.body['payment_method'],
        'amount': call.body['amount'],
      });
      return {
        'id': 'ep-1',
        'expense_id': 'e1',
        'amount': call.body['amount'],
        'payment_method': call.body['payment_method'],
        'total_paid': '200',
        'remaining_balance': '300',
      };
    });

    ExpenseDetailCubit detail() {
      final repo = expensesRepo();
      return closing(ExpenseDetailCubit(
        getExpenseByIdUseCase: GetExpenseByIdUseCase(repo),
        getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase(repo),
        getSupplierUseCase: GetSupplierUseCase(suppliersRepo()),
        deleteExpenseUseCase: DeleteExpenseUseCase(repo),
        addExpensePaymentUseCase: AddExpensePaymentUseCase(repo),
        getMyActiveShiftUseCase: GetMyActiveShiftUseCase(
          CashRegisterRepositoryImpl(
            remoteDataSource: CashRegisterRemoteDataSourceImpl(server.client),
            errorHandler: _errors,
          ),
        ),
      ));
    }

    LedgerView? view(ExpenseDetailState s) => s is ExpenseDetailLoaded
        ? (
            rows: [for (final p in s.expense.payments) p.id],
            balance: s.expense.payments.fold(
              Decimal.parse(s.expense.amount),
              (left, p) => left - Decimal.parse(p.amount),
            ),
          )
        : null;

    final other = detail();
    await other.load('e1');
    final screen = detail();

    await expectPaymentShowsAtOnce(
      ledger: screen,
      open: () => screen.load('e1'),
      pay: () async {
        expect(
          await screen.recordPayment(
            amount: Decimal.fromInt(200),
            paymentMethod: 'bank_transfer',
            referenceNo: 'TRX-1',
          ),
          isTrue,
        );
      },
      read: view,
      balanceAfter: Decimal.fromInt(300),
    );

    await settle(other);
    expect(view(other.state)!.balance, Decimal.fromInt(300));
  });

  test('expense categories: a new category is on top of the open list',
      () async {
    server.collection('/expenses/categories', seed: [
      {'id': 'cat-1', 'name': 'Rent'},
    ]);
    ExpenseCategoriesCubit cubit() {
      final repo = expensesRepo();
      return closing(ExpenseCategoriesCubit(
        getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase(repo),
        createExpenseCategoryUseCase: CreateExpenseCategoryUseCase(repo),
      ));
    }

    final list = cubit();
    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async {
        await cubit().create('Electricity');
        return 'srv-1';
      },
      rows: (s) => s is ExpenseCategoriesLoaded
          ? [for (final c in s.categories) c.id]
          : null,
    );
  });

  // ── products and their reference data ────────────────────────────────

  test('brands: a new brand is on top of the open list', () async {
    server.collection('/brands', seed: [_named('b1', 'Abbott')]);
    BrandsCubit cubit() {
      final repo = productsRepo();
      return closing(BrandsCubit(
        getBrandsUseCase: GetBrandsUseCase(repo),
        createBrandUseCase: CreateBrandUseCase(repo),
      ));
    }

    final list = cubit();
    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async => (await cubit().create('Getz'))?.id,
      rows: (s) =>
          s is BrandsLoaded ? [for (final b in s.brands) b.id] : null,
    );
  });

  test('categories: a new category is on top of the open list', () async {
    server.collection('/categories', seed: [_named('c1', 'Tablets')]);
    CategoriesCubit cubit() {
      final repo = productsRepo();
      return closing(CategoriesCubit(
        getCategoriesUseCase: GetCategoriesUseCase(repo),
        createCategoryUseCase: CreateCategoryUseCase(repo),
      ));
    }

    final list = cubit();
    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async => (await cubit().create('Syrups'))?.id,
      rows: (s) => s is CategoriesLoaded
          ? [for (final c in s.categories) c.id]
          : null,
    );
  });

  test('units: a new unit is on top of the open list', () async {
    server.collection('/units', seed: [
      {'id': 'u1', 'name': 'Piece', 'symbol': 'pc'},
    ]);
    UnitsCubit cubit() {
      final repo = productsRepo();
      return closing(UnitsCubit(
        getUnitsUseCase: GetUnitsUseCase(repo),
        createUnitUseCase: CreateUnitUseCase(repo),
      ));
    }

    final list = cubit();
    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async =>
          (await cubit().create(name: 'Strip', symbol: 'st'))?.id,
      rows: (s) => s is UnitsLoaded ? [for (final u in s.units) u.id] : null,
    );
  });

  test('price lists: a new price list shows in the open screen', () async {
    server.collection(
      '/prices/lists',
      seed: [
        {..._named('pl1', 'Retail'), 'list_type': 'retail', 'is_default': true},
      ],
      created: (_) => {'business_id': kBusiness},
    );
    server.on(
      'GET',
      '/prices/lists/{id}/items',
      (_) => {'items': <Object>[], 'total': 0, 'skip': 0, 'limit': 50},
    );
    PriceListsCubit cubit() => closing(PriceListsCubit(
          productsRepository: productsRepo(),
          connectivityProbe: FixedConnectivityProbe()
            ..set(ReachabilityStatus.online),
        ));

    final list = cubit();
    await expectCreatedShowsInList(
      list: list,
      open: list.loadPriceLists,
      create: () async {
        final form = cubit();
        expect(
          await form.createPriceList(name: 'Wholesale', listType: 'wholesale'),
          isTrue,
        );
        await settle(form);
        return 'srv-1';
      },
      rows: (s) => s.isLoadingLists
          ? null
          : [for (final l in s.priceLists) l.id],
      onTop: false,
    );
  });

  test('products: a product saved by the form is on top, even past page one',
      () async {
    server.collection(
      '/products',
      paged: true,
      // More products than one page: the new one is not on the first page.
      seed: [
        for (var i = 0; i < 230; i++)
          {
            ..._named('p$i', 'Product ${i.toString().padLeft(3, '0')}'),
            'product_type': 'standard',
            'tracking_type': 'none',
          },
      ],
      created: (_) => {'business_id': kBusiness},
    );
    server.on('GET', '/prices/lists', (_) => <Object>[]);
    final repo = productsRepo();
    final list = closing(ProductsListCubit(
      getProductsUseCase: GetProductsUseCase(repo),
      deleteProductUseCase: DeleteProductUseCase(repo),
      updateProductUseCase: UpdateProductUseCase(repo),
      getProductByBarcodeUseCase: GetProductByBarcodeUseCase(repo),
      getProductByIdUseCase: GetProductByIdUseCase(repo),
    ));

    await expectCreatedShowsInList(
      list: list,
      open: list.loadProducts,
      create: () async {
        final form = closing(ProductFormCubit(
          getProductByIdUseCase: GetProductByIdUseCase(repo),
          createProductUseCase: CreateProductUseCase(repo),
          updateProductUseCase: UpdateProductUseCase(repo),
          addVariationUseCase: AddVariationUseCase(repo),
          addBarcodeUseCase: AddBarcodeUseCase(repo),
          getPriceListsUseCase: GetPriceListsUseCase(repo),
          getProductPriceUseCase: GetProductPriceUseCase(repo),
          setProductPriceUseCase: SetProductPriceUseCase(repo),
          imageUploadService: ImageUploadService(dio: server.dio),
          authLocalDataSource: OwnerAuth(),
        ))
          ..initCreate()
          ..updateName('Zinc Syrup')
          ..updateBaseUnitId('u1');
        return form.submit();
      },
      rows: (s) => s is ProductsListLoaded
          ? [for (final p in s.items) p.id]
          : null,
    );
  });

  // ── purchases ────────────────────────────────────────────────────────

  test('purchases: a new order, then its receipt, show at once', () async {
    final orders = <Map<String, dynamic>>[
      {
        ..._order('po-old', 'received', received: '5'),
      },
    ];
    server.on('GET', '/purchases/orders', (_) => orders);
    server.on(
      'GET',
      '/purchases/orders/{id}',
      (call) => orders.firstWhere((o) => o['id'] == call.params['id']),
    );
    server.on('POST', '/purchases/orders', (call) {
      final order = _order('po-new', 'draft', received: '0');
      orders.add(order);
      return order;
    });
    server.on('PUT', '/purchases/orders/{id}/status', (call) {
      final order = orders.firstWhere((o) => o['id'] == call.params['id']);
      order['status'] = call.body['status'];
      return order;
    });
    server.on('POST', '/purchases/receipts', (call) {
      final index = orders.indexWhere((o) => o['id'] == 'po-new');
      orders[index] = _order('po-new', 'received', received: '5');
      return {
        'id': 'rc-1',
        'branch_id': kBranch,
        'supplier_id': 's1',
        'receipt_number': 'GRN-1',
        'received_at': '2026-11-02T10:00:00Z',
      };
    });
    server.on('GET', '/suppliers', (_) => [_named('s1', 'Medi Distributors')]);
    final product = {
      ..._named('p1', 'Panadol'),
      'product_type': 'standard',
      'tracking_type': 'none',
    };
    server.collection('/products', paged: true, seed: [product]);

    final products = productsRepo();
    final repo = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
      lineEnricher:
          PurchaseOrderLineEnricher(GetProductByIdUseCase(products)),
    );
    PurchaseOrdersListCubit ordersList() => closing(PurchaseOrdersListCubit(
          getPurchaseOrdersUseCase: GetPurchaseOrdersUseCase(repo),
          getSuppliersUseCase: GetSuppliersUseCase(suppliersRepo()),
        ));

    final list = ordersList();
    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async {
        final form = closing(PurchaseOrderFormCubit(
          authLocalDataSource: OwnerAuth(),
          getSuppliersUseCase: GetSuppliersUseCase(suppliersRepo()),
          getProductsUseCase: GetProductsUseCase(products),
          getProductByIdUseCase: GetProductByIdUseCase(products),
          createPurchaseOrderUseCase: CreatePurchaseOrderUseCase(repo),
          updatePurchaseOrderStatusUseCase:
              UpdatePurchaseOrderStatusUseCase(repo),
        ));
        await form.init();
        form.updateSupplierId('s1');
        await form.selectProduct(0, 'p1');
        form.updateLine(
          0,
          form.state.lines.first.copyWith(orderedQty: '5', costPerUnit: '10'),
        );
        expect(await form.submitAndOrder(), isNull,
            reason: '${form.state.errors}');
        return 'po-new';
      },
      rows: (s) => s is PurchaseOrdersListLoaded
          ? [for (final o in s.filteredOrders) o.id]
          : null,
    );

    final detail = closing(PurchaseOrderDetailCubit(
      getPurchaseOrderUseCase: GetPurchaseOrderUseCase(repo),
      updatePurchaseOrderStatusUseCase: UpdatePurchaseOrderStatusUseCase(repo),
    ));
    await detail.load('po-new');

    final receipt = closing(GoodsReceiptCubit(
      authLocalDataSource: OwnerAuth(),
      getPurchaseOrderUseCase: GetPurchaseOrderUseCase(repo),
      createPurchaseReceiptUseCase: CreatePurchaseReceiptUseCase(repo),
      getProductByIdUseCase: GetProductByIdUseCase(products),
    ));
    await receipt.load('po-new');
    expect(await receipt.confirmReceipt(), isNull,
        reason: '${receipt.state.errors}');
    await settle(detail);
    await settle(list);

    expect(
      (detail.state as PurchaseOrderDetailLoaded).order.status,
      'received',
    );
    final row = (list.state as PurchaseOrdersListLoaded)
        .filteredOrders
        .firstWhere((o) => o.id == 'po-new');
    expect(row.status, 'received');
  });

  // ── people, tax and receipts ─────────────────────────────────────────

  test('users: a new user is on top of the open list', () async {
    server.collection('/users', seed: [
      {'id': 'user-old', 'full_name': 'Asim'},
    ]);
    server.on('GET', '/roles', (_) => [_named('r1', 'Cashier')]);
    server.on('GET', '/branches', (_) => <Object>[]);
    final users = UsersRepositoryImpl(
      remoteDataSource: UsersRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final roles = RolesRepositoryImpl(
      remoteDataSource: RolesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final list = closing(UsersListCubit(
      getUsersUseCase: GetUsersUseCase(users),
      deleteUserUseCase: DeleteUserUseCase(users),
      authLocalDataSource: OwnerAuth(),
    ));

    await expectCreatedShowsInList(
      list: list,
      open: list.init,
      create: () async {
        final form = closing(UserFormCubit(
          getUserUseCase: GetUserUseCase(users),
          createUserUseCase: CreateUserUseCase(users),
          updateUserUseCase: UpdateUserUseCase(users),
          replaceUserRolesUseCase: ReplaceUserRolesUseCase(users),
          deleteUserUseCase: DeleteUserUseCase(users),
          resetUserPinUseCase: ResetUserPinUseCase(users),
          resetUserPasswordUseCase: ResetUserPasswordUseCase(users),
          getRolesUseCase: GetRolesUseCase(roles),
          branchesUseCases: BranchesUseCases(BranchesRepositoryImpl(
            remoteDataSource: BranchesRemoteDataSource(server.client),
            errorHandler: _errors,
          )),
          authLocalDataSource: OwnerAuth(),
        ));
        await form.initCreate();
        form
          ..updateFullName('Zara')
          ..updatePhone('03007654321')
          ..updatePassword('secret12')
          ..toggleRole('r1', true);
        expect(await form.submit(), isTrue, reason: '${form.state.errors}');
        return 'srv-1';
      },
      rows: (s) =>
          s is UsersListLoaded ? [for (final u in s.users) u.id] : null,
    );
  });

  test('roles: a new role is on top of the open list', () async {
    server.collection(
      '/roles',
      seed: [_named('r1', 'Cashier')],
      created: (_) => {'business_id': kBusiness},
    );
    server.on('GET', '/permissions', (_) => {'modules': <Object>[]});
    server.on(
      'PUT',
      '/roles/{id}/permissions',
      (call) => _named(call.params['id']!, 'Pharmacist'),
    );
    final repo = RolesRepositoryImpl(
      remoteDataSource: RolesRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    final list = closing(RolesListCubit(
      getRolesUseCase: GetRolesUseCase(repo),
      deleteRoleUseCase: DeleteRoleUseCase(repo),
      authLocalDataSource: OwnerAuth(),
    ));

    await expectCreatedShowsInList(
      list: list,
      open: list.init,
      create: () async {
        final form = closing(RoleFormCubit(
          getPermissionsCatalogUseCase: GetPermissionsCatalogUseCase(repo),
          getRoleUseCase: GetRoleUseCase(repo),
          createRoleUseCase: CreateRoleUseCase(repo),
          updateRoleUseCase: UpdateRoleUseCase(repo),
          assignRolePermissionsUseCase: AssignRolePermissionsUseCase(repo),
          deleteRoleUseCase: DeleteRoleUseCase(repo),
          authLocalDataSource: OwnerAuth(),
        ));
        await form.initCreate();
        form
          ..updateName('Pharmacist')
          ..togglePermission('sales.create');
        expect(await form.submit(), isNull, reason: '${form.state.errors}');
        return 'srv-1';
      },
      rows: (s) =>
          s is RolesListLoaded ? [for (final r in s.roles) r.id] : null,
    );
  });

  test('tax rates: a new rate shows on the settings and tax screens', () async {
    server.collection(
      '/tax-rates',
      seed: [
        {..._named('t1', 'GST'), 'rate': '17'},
      ],
      created: (_) => {'business_id': kBusiness, 'is_active': true},
    );
    server.on('GET', '/business/me', (_) => {'id': kBusiness, 'name': 'Demo'});
    server.on('GET', '/settings', (_) => <Object>[]);
    final repo = SettingsRepositoryImpl(
      remoteDataSource: SettingsRemoteDataSourceImpl(server.client),
      errorHandler: _errors,
    );
    SettingsCubit settings() => closing(SettingsCubit(
          getBusinessProfileUseCase: GetBusinessProfileUseCase(repo),
          updateBusinessProfileUseCase: UpdateBusinessProfileUseCase(repo),
          getSettingsUseCase: GetSettingsUseCase(repo),
          bulkUpdateSettingsUseCase: BulkUpdateSettingsUseCase(repo),
          deleteSettingUseCase: DeleteSettingUseCase(repo),
          getTaxRatesUseCase: GetTaxRatesUseCase(repo),
          createTaxRateUseCase: CreateTaxRateUseCase(repo),
          updateTaxRateUseCase: UpdateTaxRateUseCase(repo),
          imageUploadService: ImageUploadService(dio: server.dio),
        ));
    final rig = SyncRig();
    addTearDown(rig.dispose);
    final taxScreen = closing(TaxPricesCubit(
      getTaxRates: GetTaxRatesUseCase(repo),
      bulkUpdate: BulkUpdateSettingsUseCase(repo),
      store: TaxSettingsStore(rig.catalog),
      previewFetcher: ({
        required bool inclusive,
        required Decimal price,
        required Decimal qty,
        required Decimal rate,
      }) async =>
          null,
    ));
    final openSettings = settings();
    await openSettings.loadAll();

    await expectCreatedShowsInList(
      list: taxScreen,
      open: taxScreen.load,
      create: () async {
        final form = settings();
        await form.loadAll();
        expect(await form.createTaxRate(name: 'SST', rate: '13'), isTrue);
        return 'srv-1';
      },
      rows: (s) => s.loading ? null : [for (final r in s.rates) r.id],
      // A drop-down of rates, not a table: the order is the server's.
      onTop: false,
    );

    await settle(openSettings);
    final loaded = openSettings.state as SettingsLoaded;
    expect([for (final r in loaded.taxRates) r.id], ['srv-1', 't1']);
  });

  test('receipt layouts: a new layout shows in the open list', () async {
    Map<String, dynamic> layout(String id, String name) => {
          'id': id,
          'name': name,
          'design': ReceiptDesign.values.first.code,
          'paper': ReceiptDesign.values.first.defaultPaper.code,
          'config': ReceiptLayoutConfig.defaultsFor(ReceiptDesign.values.first)
              .toJson(),
          'is_active': true,
        };
    server.collection(
      '/receipt-layouts',
      seed: [layout('lay-0', 'Counter')],
      created: (_) => {'is_active': true},
    );
    server.on('GET', '/receipt-layouts/assignments', (_) => <Object>[]);
    final rig = SyncRig();
    addTearDown(rig.dispose);
    ReceiptLayoutsCubit cubit() => closing(ReceiptLayoutsCubit(
          store: ReceiptLayoutStore(rig.store),
          api: ReceiptLayoutApi(server.dio),
          isOnline: () => true,
        ));

    final list = cubit();
    await expectCreatedShowsInList(
      list: list,
      open: list.load,
      create: () async => (await cubit().create(
        design: ReceiptDesign.values.first,
        name: 'Back office',
      ))
          ?.id,
      rows: (s) => s.loading ? null : [for (final l in s.layouts) l.id],
      onTop: false,
    );
  });
}

Map<String, dynamic> _order(String id, String status, {required String received}) =>
    {
      'id': id,
      'business_id': kBusiness,
      'branch_id': kBranch,
      'supplier_id': 's1',
      'po_number': id.toUpperCase(),
      'status': status,
      'lines': [
        {
          'id': '$id-line',
          'business_id': kBusiness,
          'purchase_order_id': id,
          'product_id': 'p1',
          'product_name': 'Panadol',
          'ordered_qty': '5',
          'received_qty': received,
          'qty_remaining': received == '0' ? '5' : '0',
          'cost_per_unit': '10',
        },
      ],
    };
