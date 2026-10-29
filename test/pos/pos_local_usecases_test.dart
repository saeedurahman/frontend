import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/data/repositories/pos_repository_impl.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';
import 'package:frantend/features/pos/domain/utils/payment_planner.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

// ── fixtures ──────────────────────────────────────────────────────────────

class _Auth extends Fake implements AuthLocalDataSource {
  _Auth(this.user);
  final UserModel? user;
  @override
  Future<UserModel?> getCachedUser() async => user;
}

class _Counter extends IdGenerator {
  int n = 0;
  @override
  String newId() => 'id-${n++}';
}

class _Repo implements HeldOrdersRepository {
  final rows = <String, (HeldOrderModel, HeldOrderScope)>{};

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
  Future<void> save(HeldOrderModel order, HeldOrderScope scope) async =>
      rows[order.id] = (order, scope);

  @override
  Future<void> delete(String id) async => rows.remove(id);
}

class _Prices extends Fake implements GetProductPriceUseCase {
  final prices = <String, Decimal?>{};
  bool fail = false;

  @override
  Future<Either<Failure, Decimal?>> call(String p, String? v) async =>
      fail ? const Left(ServerFailure('x')) : Right(prices[p]);
}

ProductModel _product(String id, {List<String> barcodes = const []}) =>
    ProductModel(
      id: id,
      businessId: 't1',
      name: 'Product $id',
      productType: 'simple',
      trackingType: 'none',
      barcodes: [
        for (final b in barcodes)
          BarcodeModel(id: 'b-$b', productId: id, barcode: b),
      ],
    );

CartItemModel _item(
  String id, {
  String price = '100',
  String qty = '1',
  bool manual = false,
  String? taxId,
  String? tax,
}) =>
    CartItemModel(
      productId: id,
      productName: 'Item $id',
      unitPrice: Decimal.parse(price),
      qty: Decimal.parse(qty),
      priceManual: manual,
      taxRateId: taxId,
      taxRate: tax == null ? null : Decimal.parse(tax),
    );

const _scope = HeldOrderScope(tenantId: 't1', branchId: 'b1', userId: 'u1');

void main() {
  group('ResolvePosSessionUseCase', () {
    test('cashier with sales.create + shifts.open', () async {
      final session = await ResolvePosSessionUseCase(
        _Auth(const UserModel(
          id: 'u',
          name: 'C',
          role: 'cashier',
          permissionKeys: ['sales.create', 'shifts.open'],
        )),
        FixedConnectivityProbe(),
      )();
      expect(session.canCreateSales, isTrue);
      expect(session.canOpenShift, isTrue);
      expect(session.canCloseShift, isFalse);
      expect(session.isOffline, isFalse);
      expect(session.user?.name, 'C');
    });

    test('a user without sales.create is denied', () async {
      final session = await ResolvePosSessionUseCase(
        _Auth(const UserModel(
          id: 'u',
          name: 'V',
          role: 'viewer',
          permissionKeys: ['reports.view'],
        )),
        FixedConnectivityProbe(),
      )();
      expect(session.canCreateSales, isFalse);
    });

    test('no cached user means no capabilities', () async {
      final session = await ResolvePosSessionUseCase(
        _Auth(null),
        FixedConnectivityProbe(),
      )();
      expect(session.user, isNull);
      expect(session.canCreateSales, isFalse);
    });

    test('reports offline from the reachability probe', () async {
      final session = await ResolvePosSessionUseCase(
        _Auth(null),
        FixedConnectivityProbe(ReachabilityStatus.offline),
      )();
      expect(session.isOffline, isTrue);
    });
  });

  group('ShiftPolicy', () {
    test('permission is checked before the register', () {
      expect(
        ShiftPolicy.openBlocker(canOpenShift: false, registerId: null),
        ShiftPolicy.noPermission,
      );
      expect(
        ShiftPolicy.openBlocker(canOpenShift: true, registerId: null),
        ShiftPolicy.noRegister,
      );
      expect(
        ShiftPolicy.openBlocker(canOpenShift: true, registerId: 'r1'),
        isNull,
      );
    });

    test('open body carries float and only non-empty notes', () {
      expect(
        ShiftPolicy.openBody(
          registerId: 'r1',
          openingFloat: Decimal.parse('500'),
        ),
        {'cash_register_id': 'r1', 'opening_float': '500.00'},
      );
      expect(
        ShiftPolicy.openBody(
          registerId: 'r1',
          openingFloat: Decimal.zero,
          notes: 'morning',
        )['notes'],
        'morning',
      );
    });
  });

  group('LowStockPolicy', () {
    String? warn(String? available, String requested, {String? min}) =>
        LowStockPolicy.warning(
          productName: 'Tea',
          minStockLevel: min,
          available: available == null ? null : Decimal.parse(available),
          requested: Decimal.parse(requested),
        );

    test('unknown stock never warns', () => expect(warn(null, '1'), isNull));
    test('plenty of stock is silent', () => expect(warn('50', '1'), isNull));
    test('warns at the default threshold of 5', () {
      expect(warn('6', '1'), 'Low stock: Tea - 5 left after this sale');
    });
    test('uses the product minimum when set', () {
      expect(warn('20', '1', min: '30'), contains('19 left'));
      expect(warn('20', '1', min: '10'), isNull);
    });
    test('never reports a negative remainder', () {
      expect(warn('1', '3'), contains('0 left'));
    });
  });

  group('PaymentCoverage', () {
    PaymentLineModel cash(String v) =>
        PaymentLineModel(paymentMethod: PaymentMethods.cash, amount: Decimal.parse(v));

    test('exact payment passes', () {
      PaymentCoverage.assertCovers(
        payments: [cash('60'), cash('40')],
        due: Decimal.parse('100'),
      );
    });

    test('under- and over-payment are refused with both figures', () {
      for (final paid in ['99', '101']) {
        expect(
          () => PaymentCoverage.assertCovers(
            payments: [cash(paid)],
            due: Decimal.parse('100'),
          ),
          throwsA(
            isA<PaymentMismatchException>()
                .having((e) => e.message, 'message', contains('100')),
          ),
        );
      }
    });
  });

  group('SaleAttemptTracker', () {
    final body = {
      'branch_id': 'b1',
      'payments': [
        {'payment_method': 'cash', 'amount': '100'},
      ],
    };

    test('a retry of the same sale reuses sale and payment ids', () {
      final t = SaleAttemptTracker(_Counter());
      final first = t.stamp(body);
      final second = t.stamp(body);
      expect(second['id'], first['id']);
      expect((second['payments'] as List).first['id'],
          (first['payments'] as List).first['id']);
    });

    test('a changed cart is a new sale with new ids', () {
      final t = SaleAttemptTracker(_Counter());
      final first = t.stamp(body);
      final second = t.stamp({...body, 'notes': 'edited'});
      expect(second['id'], isNot(first['id']));
    });

    test('after completion the next sale gets a fresh id', () {
      final t = SaleAttemptTracker(_Counter());
      final first = t.stamp(body);
      t.completed();
      expect(t.stamp(body)['id'], isNot(first['id']));
    });

    test('the input body is not mutated', () {
      SaleAttemptTracker(_Counter()).stamp(body);
      expect(body.containsKey('id'), isFalse);
    });
  });

  group('HeldOrderLabels', () {
    final now = DateTime(2026, 1, 1, 14, 5, 9);
    test('default is the time of day', () {
      expect(HeldOrderLabels.unique(null, now, const []), 'Order 14:05:09');
    });
    test('custom labels are trimmed and de-duplicated case-insensitively', () {
      expect(HeldOrderLabels.unique('  Table 4 ', now, const []), 'Table 4');
      expect(
        HeldOrderLabels.unique('table 4', now, const ['Table 4', 'Table 4 (2)']),
        'table 4 (3)',
      );
    });
  });

  group('HeldOrdersUseCases', () {
    late _Repo repo;
    late _Prices prices;
    late HeldOrdersUseCases uc;

    setUp(() {
      repo = _Repo();
      prices = _Prices();
      uc = HeldOrdersUseCases(
        repo,
        prices,
        _Counter(),
        clock: () => DateTime(2026, 1, 1, 9),
      );
    });

    Future<HeldOrderModel> hold(List<CartItemModel> items, {String? label}) =>
        uc.hold(
          scope: _scope,
          items: items,
          existingLabels: const [],
          total: Decimal.parse('250'),
          customLabel: label,
          customerId: 'c1',
          customerName: 'Sana',
          discountType: 'percent',
          discountValue: Decimal.parse('10'),
        );

    test('hold stores the cart under the scope with a generated id', () async {
      final order = await hold([_item('p1'), _item('p2')], label: 'Lunch');
      expect(order.id, 'id-0');
      expect(order.label, 'Lunch');
      expect(order.itemCount, 2);
      expect(order.customerName, 'Sana');
      expect(order.cartDiscountValue, Decimal.parse('10'));
      expect(await uc.list(_scope), hasLength(1));
    });

    test('a zero discount is not stored', () async {
      final order = await uc.hold(
        scope: _scope,
        items: [_item('p1')],
        existingLabels: const [],
        total: Decimal.one,
        discountValue: Decimal.zero,
      );
      expect(order.cartDiscountValue, isNull);
    });

    test('another cashier / branch / tenant cannot see or resume it', () async {
      final order = await hold([_item('p1')]);
      for (final other in const [
        HeldOrderScope(tenantId: 't1', branchId: 'b1', userId: 'u2'),
        HeldOrderScope(tenantId: 't1', branchId: 'b2', userId: 'u1'),
        HeldOrderScope(tenantId: 't2', branchId: 'b1', userId: 'u1'),
      ]) {
        expect(await uc.list(other), isEmpty);
        expect(
          await uc.resume(
            id: order.id,
            scope: other,
            taxRates: const [],
            defaultTaxRate: null,
          ),
          isNull,
        );
        await uc.discard(order.id, other);
      }
      expect(await uc.list(_scope), hasLength(1),
          reason: 'a foreign discard must not delete it');
    });

    test('resume re-prices against today and reports each change', () async {
      final order = await hold([_item('p1', price: '100')]);
      prices.prices['p1'] = Decimal.parse('120');

      final resumed = await uc.resume(
        id: order.id,
        scope: _scope,
        taxRates: const [],
        defaultTaxRate: null,
      );

      expect(resumed!.items.single.unitPrice, Decimal.parse('120'));
      expect(resumed.changes.single, contains('100'));
      expect(resumed.changes.single, contains('120'));
      expect(await uc.list(_scope), hasLength(1),
          reason: 'resume itself does not delete');
    });

    test('a manually typed price is kept', () async {
      final order = await hold([_item('p1', price: '100', manual: true)]);
      prices.prices['p1'] = Decimal.parse('999');
      final resumed = await uc.resume(
        id: order.id,
        scope: _scope,
        taxRates: const [],
        defaultTaxRate: null,
      );
      expect(resumed!.items.single.unitPrice, Decimal.parse('100'));
      expect(resumed.changes, isEmpty);
    });

    test('a failed price lookup keeps held prices and warns', () async {
      final order = await hold([_item('p1')]);
      prices.fail = true;
      final resumed = await uc.resume(
        id: order.id,
        scope: _scope,
        taxRates: const [],
        defaultTaxRate: null,
      );
      expect(resumed!.items.single.unitPrice, Decimal.parse('100'));
      expect(resumed.changes.single, contains('could not be refreshed'));
    });

    test('tax always follows the current tax table', () async {
      final order = await hold([_item('p1', taxId: 'tx', tax: '5')]);
      final resumed = await uc.resume(
        id: order.id,
        scope: _scope,
        taxRates: const [
          TaxRateModel(id: 'tx', businessId: 't1', name: 'GST', rate: '17'),
        ],
        defaultTaxRate: null,
      );
      expect(resumed!.items.single.taxRate, Decimal.parse('17'));
      expect(resumed.changes.single, contains('5.00% -> 17.00%'));
    });

    test('a deleted tax rate falls back to the default, else is removed',
        () async {
      final order = await hold([_item('p1', taxId: 'gone', tax: '5')]);
      final removed = await uc.resume(
        id: order.id,
        scope: _scope,
        taxRates: const [],
        defaultTaxRate: null,
      );
      expect(removed!.items.single.taxRateId, isNull);
      expect(removed.changes.single, contains('tax removed'));

      final fallback = await uc.resume(
        id: order.id,
        scope: _scope,
        taxRates: const [],
        defaultTaxRate: const TaxRateModel(
          id: 'def',
          businessId: 't1',
          name: 'Std',
          rate: '10',
        ),
      );
      expect(fallback!.items.single.taxRateId, 'def');
    });

    test('discard removes only the scoped order', () async {
      final order = await hold([_item('p1')]);
      await uc.discard(order.id, _scope);
      expect(await uc.list(_scope), isEmpty);
    });
  });

  group('ResolveBarcodeUseCase', () {
    late _MemCache cache;
    late _Lookup lookup;
    late _ById byId;
    late ResolveBarcodeUseCase uc;

    setUp(() {
      cache = _MemCache();
      lookup = _Lookup();
      byId = _ById();
      uc = ResolveBarcodeUseCase(cache, lookup, byId);
    });

    test('blank input resolves to nothing without any lookup', () async {
      final r = await uc(barcode: '  ', tenantKey: 't', memory: const []);
      expect(r.product, isNull);
      expect(lookup.calls, 0);
    });

    test('in-memory details win (no cache, no network)', () async {
      final p = _product('p1', barcodes: ['111']);
      final r = await uc(barcode: '111', tenantKey: 't', memory: [p]);
      expect(r.product, p);
      expect(r.fromCache, isTrue);
      expect(lookup.calls, 0);
    });

    test('then the local cache', () async {
      final p = _product('p2');
      cache.store['t|222'] = p;
      final r = await uc(barcode: '222', tenantKey: 't', memory: const []);
      expect(r.product, p);
      expect(r.fromCache, isTrue);
      expect(lookup.calls, 0);
    });

    test('then the server, and the hit is remembered', () async {
      final p = _product('p3');
      lookup.result = Right(p);
      final r = await uc(barcode: ' 333 ', tenantKey: 't', memory: const []);
      expect(r.product, p);
      expect(r.fromCache, isFalse);
      expect(lookup.last, '333');
      expect(cache.store['t|333'], p);
    });

    test('a miss is null, never a made-up product', () async {
      lookup.result = const Left(NotFoundFailure());
      final r = await uc(barcode: '404', tenantKey: 't', memory: const []);
      expect(r.product, isNull);
      expect(cache.store, isEmpty);
    });

    test('the cache is per business', () async {
      cache.store['other|222'] = _product('p2');
      lookup.result = const Left(NotFoundFailure());
      final r = await uc(barcode: '222', tenantKey: 't', memory: const []);
      expect(r.product, isNull);
    });

    test('refresh updates the cache entry, null on failure', () async {
      final fresh = _product('p1');
      byId.result = Right(fresh);
      expect(
        await uc.refresh(barcode: '111', tenantKey: 't', productId: 'p1'),
        fresh,
      );
      expect(cache.store['t|111'], fresh);

      byId.result = const Left(ServerFailure('x'));
      expect(
        await uc.refresh(barcode: '111', tenantKey: 't', productId: 'p1'),
        isNull,
      );
    });
  });

  group('PaymentPlanner', () {
    test('no customer means no credit', () {
      expect(PaymentPlanner.creditContext(null).hasCustomer, isFalse);
    });

    test('credit line needs a customer and can appear only once', () {
      expect(
        PaymentPlanner.canAddMethod(
          method: PaymentMethods.credit,
          hasCustomer: false,
          existingMethods: const [],
        ),
        isFalse,
      );
      expect(
        PaymentPlanner.canAddMethod(
          method: PaymentMethods.credit,
          hasCustomer: true,
          existingMethods: const [PaymentMethods.cash],
        ),
        isTrue,
      );
      expect(
        PaymentPlanner.canAddMethod(
          method: PaymentMethods.credit,
          hasCustomer: true,
          existingMethods: const [PaymentMethods.credit],
        ),
        isFalse,
      );
      expect(
        PaymentPlanner.canAddMethod(
          method: PaymentMethods.cash,
          hasCustomer: false,
          existingMethods: const [PaymentMethods.cash],
        ),
        isTrue,
      );
    });

    test('due excludes the edited line and ignores credit lines', () {
      final due = PaymentPlanner.dueExcluding(
        total: Decimal.parse('100'),
        others: [
          PaymentInput(method: PaymentMethods.cash, entered: Decimal.parse('30')),
          PaymentInput(method: PaymentMethods.credit, entered: Decimal.parse('50')),
        ],
      );
      expect(due, Decimal.parse('70'));
    });

    test('due never goes negative', () {
      expect(
        PaymentPlanner.dueExcluding(
          total: Decimal.parse('10'),
          others: [
            PaymentInput(method: PaymentMethods.cash, entered: Decimal.parse('30')),
          ],
        ),
        Decimal.zero,
      );
    });

    test('allocation of a single exact cash line can complete the sale', () {
      final allocation = PaymentPlanner.allocate(
        total: Decimal.parse('100'),
        inputs: [
          PaymentInput(method: PaymentMethods.cash, entered: Decimal.parse('100')),
        ],
        customer: null,
      );
      expect(allocation.canComplete, isTrue);
      expect(PaymentPlanner.prefill(allocation), Decimal.zero);
    });

    test('prefill suggests what is still unpaid', () {
      final allocation = PaymentPlanner.allocate(
        total: Decimal.parse('100'),
        inputs: [
          PaymentInput(method: PaymentMethods.cash, entered: Decimal.parse('40')),
        ],
        customer: null,
      );
      expect(PaymentPlanner.prefill(allocation), Decimal.parse('60'));
    });

    test('credit context reads limit and balance from the customer', () {
      final ctx = PaymentPlanner.creditContext(CustomerModel(
        id: 'c',
        businessId: 'b',
        name: 'Sana',
        creditLimit: '5000',
        balance: '1200',
      ));
      expect(ctx.hasCustomer, isTrue);
      expect(ctx.creditLimit, Decimal.parse('5000'));
      expect(ctx.balance, Decimal.parse('1200'));
    });
  });

  group('PosRepositoryImpl.createSale never fakes success', () {
    _Remote remote0() => _Remote();

    PosRepositoryImpl build(_Remote remote, ConnectivityProbe probe) =>
        PosRepositoryImpl(
          remoteDataSource: remote,
          connectivityProbe: probe,
          errorHandler: const ErrorHandler(),
          ids: _Counter(),
        );

    test('success returns the server sale and sends a client id', () async {
      final remote = remote0();
      final result = await build(remote, FixedConnectivityProbe())
          .createSale({'branch_id': 'b1'});
      expect(result.isRight(), isTrue);
      expect(remote.bodies.single['id'], 'id-0');
    });

    test('an existing sale id is preserved (idempotent retry)', () async {
      final remote = remote0();
      await build(remote, FixedConnectivityProbe()).createSale({'id': 'keep'});
      expect(remote.bodies.single['id'], 'keep');
    });

    for (final type in [
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      test('$type fails loudly: Left, never a draft/OFFLINE sale', () async {
        final remote = remote0()..error = DioException(
              requestOptions: RequestOptions(path: '/sales'),
              type: type,
            );
        final result = await build(
          remote,
          FixedConnectivityProbe(ReachabilityStatus.offline),
        ).createSale({'branch_id': 'b1'});

        final failure = result.fold((f) => f, (_) => null);
        expect(failure, isA<NetworkFailure>());
        expect(failure!.message, contains('NOT saved'));
        expect(failure.message, contains('offline'));
      });
    }

    test('a server rejection is passed through unchanged', () async {
      final remote = remote0()..error = DioException(
            requestOptions: RequestOptions(path: '/sales'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/sales'),
              statusCode: 422,
              data: {'detail': 'Out of stock'},
            ),
          );
      final result = await build(remote, FixedConnectivityProbe())
          .createSale({'branch_id': 'b1'});
      expect(result.fold((f) => f, (_) => null), isA<ValidationFailure>());
    });
  });
}

// ── fakes used by the last groups ────────────────────────────────────────

class _MemCache implements BarcodeCacheRepository {
  final store = <String, ProductModel>{};

  @override
  Future<ProductModel?> find(String t, String b) async => store['$t|$b'];

  @override
  Future<void> remember(String t, String b, ProductModel p) async =>
      store['$t|$b'] = p;
}

class _Lookup extends Fake implements LookupBarcodeUseCase {
  int calls = 0;
  String? last;
  Either<Failure, ProductModel> result = const Left(NotFoundFailure());

  @override
  Future<Either<Failure, ProductModel>> call(String barcode) async {
    calls++;
    last = barcode;
    return result;
  }
}

class _ById extends Fake implements GetProductByIdUseCase {
  Either<Failure, ProductModel> result = const Left(NotFoundFailure());

  @override
  Future<Either<Failure, ProductModel>> call(String id) async => result;
}

class _Remote extends Fake implements PosRemoteDataSource {
  final bodies = <Map<String, dynamic>>[];
  Object? error;

  @override
  Future<SaleResponseModel> createSale(Map<String, dynamic> body) async {
    bodies.add(body);
    if (error != null) throw error!;
    return SaleResponseModel(
      id: body['id'] as String,
      branchId: 'b1',
      saleType: 'pos',
      saleStatus: 'completed',
    );
  }
}
