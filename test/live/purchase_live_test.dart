// Group 3 against a REAL backend: supplier + products through the API, a
// purchase order built in the real form cubit, submitted, listed, received with
// batch/expiry, and the effect on stock and the supplier ledger checked through
// the API. See live_backend.dart for how to start the backend.
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';

import 'live_backend.dart';
import 'products_rig.dart';
import 'purchases_rig.dart';

void main() {
  if (liveSkip != false) {
    test('live purchase tests', () {}, skip: liveSkip);
    return;
  }

  late LiveTenant tenant;
  late ProductsRig products;
  late PurchasesRig rig;
  late String supplierId;
  late String plainId; // two variations, no expiry tracking
  late String expiryId; // tracks expiry, has a category (=> slim CategoryBrief in responses)
  late String categoryId;

  Future<String> makeProduct(String name, {bool expiry = false, bool withVariations = false}) async {
    final body = <String, dynamic>{
      'name': name,
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': expiry ? 'expiry' : 'none',
      'track_expiry': expiry,
      if (expiry) 'shelf_life_days': 730,
      'category_id': categoryId,
      if (withVariations)
        'variations': [
          {'name': 'Strip', 'is_default': true},
          {'name': 'Box'},
        ],
    };
    return (await tenant.post('/products', body))['id'] as String;
  }

  setUpAll(() async {
    tenant = await LiveTenant.register(liveApiBase()!, label: 'Sehat Purchases');
    categoryId = (await tenant.post('/categories', {'name': 'Antibiotics'}))['id'] as String;
    supplierId = (await tenant.post('/suppliers', {
      'name': 'Al Shifa Distributors',
      'phone': '3001234567',
      'payment_terms_days': 15,
    }))['id'] as String;
    plainId = await makeProduct('Plain ${DateTime.now().millisecondsSinceEpoch}', withVariations: true);
    expiryId = await makeProduct('Amoxil ${DateTime.now().millisecondsSinceEpoch}', expiry: true);
  });

  setUp(() {
    products = ProductsRig(tenant);
    rig = PurchasesRig(tenant, products);
  });
  tearDown(() async {
    await rig.dispose();
    await products.dispose();
  });

  Future<String> buildOrder({required bool submit}) async {
    final f = rig.form;
    await f.init();
    expect(f.state.errors, isEmpty, reason: '${f.state.errors}');
    expect(f.state.suppliers.map((s) => s.id), contains(supplierId));
    f.updateSupplierId(supplierId);

    // Line 1: pick the product (this fetches the full product: slim category),
    // then type quantity, cost and tax.
    await f.selectProduct(0, plainId);
    expect(f.state.errors, isEmpty, reason: 'selecting a product failed: ${f.state.errors}');
    expect(f.state.lines[0].productId, plainId);
    expect(f.state.lines[0].variations.map((v) => v.name), containsAll(['Strip', 'Box']));
    f.updateLine(0, f.state.lines[0].copyWith(orderedQty: '10', costPerUnit: '25.50', taxRate: '0'));

    // Line 2: the product that tracks expiry.
    f.addLine();
    await f.selectProduct(1, expiryId);
    expect(f.state.errors, isEmpty, reason: '${f.state.errors}');
    f.updateLine(1, f.state.lines[1].copyWith(orderedQty: '4', costPerUnit: '100', taxRate: '10'));

    expect(f.validate(), isTrue, reason: '${f.state.errors}');
    final err = submit ? await f.submitAndOrder() : await f.submitDraft();
    expect(err, isNull, reason: 'save failed: $err');
    final orders = await tenant.getList('/purchases/orders', query: {'supplier_id': supplierId});
    return (orders.first as Map)['id'] as String;
  }

  test('new PO: adding a product with a quantity works, Save & Submit finds the product',
      () async {
    final id = await buildOrder(submit: true);
    final server = await tenant.get('/purchases/orders/$id');
    expect(server['status'], 'ordered');
    final lines = (server['lines'] as List).cast<Map>();
    expect(lines, hasLength(2));
    expect(lines.map((l) => l['product_id']), containsAll([plainId, expiryId]));
    expect(lines.firstWhere((l) => l['product_id'] == plainId)['ordered_qty'].toString(),
        anyOf('10', '10.0000'));
  });

  test('the PO list cubit shows the new order and its status at once, and after receiving',
      () async {
    await rig.list.load();
    final before = (rig.list.state as PurchaseOrdersListLoaded).allOrders.length;

    final id = await buildOrder(submit: true);
    await rig.list.refresh(); // what the page does when the form pops with true
    var loaded = rig.list.state as PurchaseOrdersListLoaded;
    expect(loaded.allOrders.length, before + 1);
    expect(loaded.allOrders.firstWhere((o) => o.id == id).status, 'ordered');

    // Detail: lines carry product names (enriched from the products).
    await rig.detail.load(id);
    final order = (rig.detail.state as dynamic).order as PurchaseOrderModel;
    expect(order.lines.every((l) => (l.productName ?? '').isNotEmpty), isTrue);
    expect(order.supplier?.name, 'Al Shifa Distributors');

    // Receive: the expiry product needs batch + expiry.
    await rig.receipt.load(id);
    expect(rig.receipt.state.errors, isEmpty, reason: '${rig.receipt.state.errors}');
    final lines = rig.receipt.state.lines;
    expect(lines, hasLength(2));
    final iExpiry = lines.indexWhere((l) => l.line.productId == expiryId);
    expect(lines[iExpiry].trackExpiry, isTrue, reason: 'track_expiry product not detected');
    expect(lines.firstWhere((l) => l.line.productId == plainId).trackExpiry, isFalse);

    final err1 = await rig.receipt.confirmReceipt();
    expect(err1, isNotNull, reason: 'batch/expiry must be required for a track_expiry item');
    expect(rig.receipt.state.errors['line_$iExpiry'], contains('Batch number'));

    final expiry = DateTime.now().add(const Duration(days: 400));
    rig.receipt.updateLine(
      iExpiry,
      rig.receipt.state.lines[iExpiry].copyWith(batchNumber: 'B-2026-01', expiryDate: expiry),
    );
    final err2 = await rig.receipt.confirmReceipt();
    expect(err2, isNull, reason: 'receipt failed: $err2');

    // The server: PO received, stock up, supplier owed.
    final after = await tenant.get('/purchases/orders/$id');
    expect(after['status'], 'received');
    final balances = await tenant.getList('/stock/balances',
        query: {'branch_id': tenant.branchId, 'product_ids': expiryId});
    final stock = balances
        .cast<Map>()
        .where((b) => b['product_id'] == expiryId)
        .fold<double>(0, (sum, b) => sum + double.parse('${b['current_qty']}'));
    expect(stock, 4.0, reason: 'received stock missing: $balances');
    final ledger = await tenant.get('/supplier-ledger/$supplierId/balance');
    // Payable to the supplier (negative = we owe): 10 x 25.50 + 4 x 100 as received.
    expect(double.parse('${ledger['balance']}'), -655.0);

    // And the list cubit shows the status change after a refresh.
    await rig.list.refresh();
    loaded = rig.list.state as PurchaseOrdersListLoaded;
    expect(loaded.allOrders.firstWhere((o) => o.id == id).status, 'received');
  });

  test('draft -> submit -> cancel through the detail cubit', () async {
    final id = await buildOrder(submit: false);
    await rig.detail.load(id);
    expect(await rig.detail.updateStatus(PurchaseOrderStatus.ordered), isNull);
    expect((await tenant.get('/purchases/orders/$id'))['status'], 'ordered');
    expect(await rig.detail.updateStatus(PurchaseOrderStatus.cancelled), isNull);
    expect((await tenant.get('/purchases/orders/$id'))['status'], 'cancelled');
  });
}
