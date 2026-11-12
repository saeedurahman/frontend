import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/offline_policy.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';
import 'package:frantend/features/pos/domain/utils/payment_planner.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_request_builder.dart';

import 'sync_rig.dart';

class _NoRemote extends Fake implements PosRemoteDataSource {}

OfflinePosRepository _repo(SyncRig rig) => OfflinePosRepository(
      catalog: rig.catalog,
      writer: rig.writer,
      store: rig.store,
      remote: _NoRemote(),
      errorHandler: const ErrorHandler(),
      userId: () async => kUser,
    );

void main() {
  late SyncRig rig;

  setUp(() async {
    rig = SyncRig();
    rig.seedServer();
    await rig.sync();
  });

  tearDown(() => rig.dispose());

  group('local catalog', () {
    test('search by name, sku and barcode; category filter; paging', () async {
      rig.product('p2', 'Basmati Rice', 'BR1', barcode: '8964000222222', category: 'cat-2');
      rig.product('p3', 'Sugar 1kg', 'SG1');
      await rig.sync();

      Future<List<String>> names(String q, {String? cat}) async =>
          (await rig.catalog.products(search: q, categoryId: cat)).items.map((p) => p.name).toList();

      expect(await names('rice'), unorderedEquals(['Rice 5kg', 'Basmati Rice']));
      expect(await names('SG1'), ['Sugar 1kg']);
      expect(await names('8964000222'), ['Basmati Rice']);
      expect(await names('', cat: 'cat-2'), ['Basmati Rice']);

      final page = await rig.catalog.products(limit: 2);
      expect(page.total, 3);
      expect(page.items, hasLength(2));
      expect((await rig.catalog.products(skip: 2, limit: 2)).items, hasLength(1));
    });

    test('inactive products are hidden from the POS grid', () async {
      rig.server.put('product', 'p1', {
        'id': 'p1', 'name': 'Rice 5kg', 'sku': 'R5', 'category_id': 'cat-1',
        'is_active': false, 'is_sellable': true, 'product_type': 'standard',
        'tracking_type': 'none',
      });
      await rig.sync();
      expect((await rig.catalog.products()).total, 0);
    });

    test('barcode lookup returns the full product with its barcodes', () async {
      final p = await rig.catalog.productByBarcode('8964000111111');
      expect(p!.name, 'Rice 5kg');
      expect(p.barcodes.single.barcode, '8964000111111');
      expect(p.category?.name, 'Grocery');
      expect(await rig.catalog.productByBarcode('000'), isNull);
    });

    test('price comes from the default price list; tiers and variations win',
        () async {
      expect(await rig.catalog.price('p1'), Decimal.parse('100.00'));
      rig.server.put('price_list_item', 'pli-tier', {
        'id': 'pli-tier', 'price_list_id': 'pl-1', 'product_id': 'p1',
        'variation_id': null, 'unit_price': '90.00', 'min_qty': '10',
      });
      rig.server.put('product_variation', 'v1', {
        'id': 'v1', 'product_id': 'p1', 'name': 'Large', 'is_active': true, 'is_default': false,
      });
      rig.server.put('price_list_item', 'pli-v1', {
        'id': 'pli-v1', 'price_list_id': 'pl-1', 'product_id': 'p1',
        'variation_id': 'v1', 'unit_price': '120.00', 'min_qty': '1',
      });
      await rig.sync();
      expect(await rig.catalog.price('p1', qty: Decimal.fromInt(5)), Decimal.parse('100.00'));
      expect(await rig.catalog.price('p1', qty: Decimal.fromInt(12)), Decimal.parse('90.00'));
      expect(await rig.catalog.price('p1', variationId: 'v1'), Decimal.parse('120.00'));
      expect(await rig.catalog.price('nope'), isNull);
    });

    test('tax rates and the product tree come from pulled data', () async {
      final taxes = await rig.catalog.taxRates();
      expect(taxes.single.rate, '5.00');
      expect((await rig.catalog.categories()).single.name, 'Grocery');
    });

    test('registers are limited to the branch', () async {
      expect((await rig.catalog.registers(branchId: kBranch)).single.name, 'Front');
      expect(await rig.catalog.registers(branchId: 'other'), isEmpty);
    });
  });

  group('OfflinePosRepository: one path, no network', () {
    test('a sale never fails because of the network', () async {
      rig.server.offline = true;
      final result = await _repo(rig).createSale({
        ...rig.cartBody(),
        'id': 'sale-1',
      });
      final sale = result.getOrElse(() => throw 'sale failed');
      expect(sale.id, 'sale-1');
      expect(sale.saleNumber, 'DA1B2-0001', reason: 'device receipt number');
      expect(sale.offline, isTrue, reason: 'not confirmed by the server yet');
      expect(sale.lines.single.productName, 'Rice 5kg');
      expect(sale.totalAmount, '210.00');
      expect(sale.payments.single.amount, '210.00');
      expect((await rig.store.counts()).pending, 1);
    });

    test('the receipt shows both numbers after sync', () async {
      final repo = _repo(rig);
      final sale =
          (await repo.createSale({...rig.cartBody(), 'id': 's1'})).getOrElse(() => throw 'x');
      expect(
        LocalSaleMapper.numbersLine((await rig.store.sale('s1'))!),
        contains('pending sync'),
      );
      expect(sale.saleNumber, 'DA1B2-0001');

      await rig.sync();
      final row = (await rig.store.sale('s1'))!;
      final reprint = LocalSaleMapper.toResponse(row);
      expect(reprint.saleNumber, 'INV-20261029-0001', reason: 'official number wins');
      expect(reprint.offline, isFalse);
      expect(
        LocalSaleMapper.numbersLine(row),
        'Receipt DA1B2-0001  |  Official INV-20261029-0001',
      );
    });

    test('shift gate: open, conflict while open, active lookup, close', () async {
      final repo = _repo(rig);
      expect((await repo.getActiveShift('reg-1')).getOrElse(() => null), isNull);

      final opened = (await repo.openShift({
        'cash_register_id': 'reg-1',
        'opening_float': '500.00',
      }))
          .getOrElse(() => throw 'open failed');
      expect(opened.status, 'open');
      expect(opened.register?.name, 'Front');
      expect((await repo.getActiveShift('reg-1')).getOrElse(() => null)!.id, opened.id);

      final again = await repo.openShift({'cash_register_id': 'reg-1'});
      expect(again.fold((f) => f, (_) => null), isA<ConflictFailure>());
    });

    test('shift summary is computed from the device\'s own sales', () async {
      final repo = _repo(rig);
      final shift = (await repo.openShift({
        'cash_register_id': 'reg-1',
        'opening_float': '500.00',
      }))
          .getOrElse(() => throw 'x');
      await repo.createSale({
        ...rig.cartBody(shiftId: shift.id),
        'id': 's1',
      });
      await repo.createSale({
        ...rig.cartBody(
          shiftId: shift.id,
          payments: [
            {'payment_method': 'card', 'amount': '210.00'},
          ],
        ),
        'id': 's2',
      });
      final summary = (await repo.getShiftSummary(shift.id)).getOrElse(() => throw 'x');
      expect(summary.totalCashSales, '210.00');
      expect(summary.totalCardSales, '210.00');
      expect(summary.expectedCash, '710.00');
    });

    test('quick-created customer is usable straight away and queued', () async {
      final repo = _repo(rig);
      final created = (await repo.createCustomer({'name': 'Walk In', 'phone': '0345'}))
          .getOrElse(() => throw 'x');
      expect(created.balance, '0.00');
      final found = (await repo.searchCustomers('walk')).getOrElse(() => []);
      expect(found.single.id, created.id);
      expect((await rig.store.ops()).single.type, 'customer.create');
    });

    test('local price preview applies a discount scheme with PricingEngine',
        () async {
      rig.server.put('discount_scheme', 'ds1', {
        'id': 'ds1', 'name': '10% off', 'discount_type': 'percentage',
        'discount_value': '10', 'is_active': true,
      });
      await rig.sync();
      final preview = (await _repo(rig).previewSalePrice({
        'discount_scheme_id': 'ds1',
        'lines': [
          {'product_id': 'p1', 'qty': '2', 'unit_price': '100.00', 'tax_rate': '5'},
        ],
      }))
          .getOrElse(() => throw 'x');
      expect(preview.subtotal, '200.00');
      expect(preview.totalDiscount, '20.00');
      expect(preview.totalTax, '9.00');
      expect(preview.totalAmount, '189.00');
    });

    test('sale body carries tendered amount and change (README contract)', () {
      final json = PosSaleRequestBuilder.paymentsJson([
        PaymentLineModel(
          paymentMethod: PaymentMethods.cash,
          amount: Decimal.parse('210'),
          tendered: Decimal.parse('300'),
        ),
      ]);
      expect(json.single['tendered_amount'], '300.00');
      expect(json.single['change_given'], '90.00');
    });
  });

  group('writer', () {
    test('receipt numbers are sequential per device', () async {
      final a = await rig.sell();
      final b = await rig.sell();
      expect(a['receipt_no'], 'DA1B2-0001');
      expect(b['receipt_no'], 'DA1B2-0002');
    });

    test('local-only names never leave the device', () async {
      await rig.sell();
      final payload = (await rig.store.ops()).single.payload;
      expect(jsonEncode(payload), isNot(contains('Rice 5kg')));
      final local = jsonDecode((await rig.store.sales()).single['lines'] as String) as List;
      expect((local.single as Map)['product_name'], 'Rice 5kg');
    });

    test('totals are computed on the device with the shared PricingEngine',
        () async {
      final row = await rig.sell();
      expect(row['subtotal'], '200.00');
      expect(row['total_tax'], '10.00');
      expect(row['total_amount'], '210.00');
    });

    test('occurred_at is the device time of the action', () async {
      rig.now = DateTime.utc(2026, 10, 29, 7, 58);
      await rig.sell();
      expect((await rig.store.ops()).single.occurredAt, '2026-10-29T07:58:00.000Z');
    });

    test('ids are UUID-style values from the IdGenerator', () async {
      final customer = await rig.writer.createCustomer({'name': 'X'});
      expect(customer['id'], startsWith('id-'));
      final shift = await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.zero);
      expect(shift['id'], startsWith('id-'));
    });
  });

  group('credit sale limit check', () {
    CustomerModel customer(String balance) => CustomerModel(
          id: 'c1',
          businessId: kBusiness,
          name: 'Ali',
          creditLimit: '5000',
          balance: balance,
        );

    test('uses cached balance + pending credit sales', () async {
      rig.server.offline = true;
      await rig.sell(
        customerId: 'c1',
        payments: [
          {'payment_method': 'credit', 'amount': '3500.00'},
        ],
      );
      final c = (await rig.catalog.customer('c1'))!;
      expect(c.balance, '-4500.00');

      // 1000 more would reach 5500 > limit 5000: the allocator refuses credit.
      final over = PaymentPlanner.allocate(
        total: Decimal.parse('1000'),
        inputs: [
          PaymentInput(method: PaymentMethods.credit, entered: Decimal.parse('1000')),
        ],
        customer: c,
      );
      expect(over.canComplete, isFalse);

      final ok = PaymentPlanner.allocate(
        total: Decimal.parse('400'),
        inputs: [
          PaymentInput(method: PaymentMethods.credit, entered: Decimal.parse('400')),
        ],
        customer: c,
      );
      expect(ok.canComplete, isTrue);
    });

    test('a payment taken offline lowers the balance immediately', () async {
      await rig.writer.recordCustomerPayment(
        customerId: 'c1',
        amount: Decimal.parse('300'),
        paymentMethod: 'cash',
      );
      expect((await rig.catalog.customer('c1'))!.balance, '-700.00');
      expect(customer('0').creditLimit, '5000');
    });
  });

  group('decorated repositories', () {
    test('customer payment via the repository is queued, balance returned',
        () async {
      final repo = OfflineCustomersRepository(
        remoteDataSource: _FakeCustomersRemote(),
        errorHandler: const ErrorHandler(),
        writer: rig.writer,
        catalog: rig.catalog,
      );
      final r = (await repo.recordPayment(
        'c1',
        amount: Decimal.parse('250'),
        paymentMethod: 'cash',
      ))
          .getOrElse(() => throw 'x');
      expect(r.newBalance, '-750.00');
      expect((await rig.store.ops()).single.type, 'customer.payment');
    });

    test('local readers refuse catalog writes instead of pretending',
        () async {
      final repo = LocalProductsRepository(rig.catalog);
      expect(() => (repo as dynamic).createProduct(<String, dynamic>{}),
          throwsUnsupportedError);
    });

    test('local stock reader reports pulled minus pending', () async {
      rig.server.offline = true;
      await rig.sell(qty: '4');
      final r = await LocalInventoryRepository(rig.catalog)
          .getStockBalance(branchId: kBranch, productId: 'p1');
      expect(r.getOrElse(() => throw 'x').currentQty, '6');
      final unknown = await LocalInventoryRepository(rig.catalog)
          .getStockBalance(branchId: kBranch, productId: 'zzz');
      expect(unknown.isLeft(), isTrue);
    });
  });

  group('OfflinePolicy (below-stock)', () {
    test('owner switch beats the server setting; default is allow', () async {
      final prefs = _FakePrefs();
      final policy = OfflinePolicy(prefs, rig.catalog);
      expect(await policy.allowSellBelowStock(), isTrue); // server: true

      rig.server.put('settings', 'biz', {'business_name': 'Demo', 'allow_negative_stock': false});
      await rig.sync();
      expect(await policy.allowSellBelowStock(), isFalse);

      prefs.value = true;
      expect(await policy.allowSellBelowStock(), isTrue);
    });
  });
}

class _FakePrefs extends Fake implements PreferencesStorage {
  bool? value;
  @override
  bool? getAllowBelowStock() => value;
  @override
  bool getShowSyncDetails() => false;
}

class _FakeCustomersRemote extends Fake implements CustomersRemoteDataSource {}
