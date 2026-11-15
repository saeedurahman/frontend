import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/offline_world.dart';

void main() {
  late OfflineWorld world;

  setUp(() {
    world = OfflineWorld();
  });

  tearDown(() => world.dispose());

  test('Customer price list resolution, quantity tiers, validity window, and default list fallback', () async {
    final catalog = world.rig.catalog;
    final store = world.rig.store;

    final now = DateTime(2026, 6, 15, 12, 0);

    // 1. Create Default Retail Price List
    await store.putEntity('price_list', 'pl-default', {
      'id': 'pl-default',
      'name': 'Retail Default',
      'list_type': 'retail',
      'is_default': true,
      'is_active': true,
    });

    // 2. Create Wholesale Price List (currently valid)
    await store.putEntity('price_list', 'pl-wholesale', {
      'id': 'pl-wholesale',
      'name': 'Wholesale List',
      'list_type': 'wholesale',
      'is_default': false,
      'is_active': true,
      'valid_from': '2026-01-01T00:00:00',
      'valid_to': '2026-12-31T23:59:59',
    });

    // 3. Create Expired Price List
    await store.putEntity('price_list', 'pl-expired', {
      'id': 'pl-expired',
      'name': 'Expired Promo',
      'list_type': 'custom',
      'is_default': false,
      'is_active': true,
      'valid_from': '2025-01-01T00:00:00',
      'valid_to': '2025-12-31T23:59:59',
    });

    // 4. Create Inactive Price List
    await store.putEntity('price_list', 'pl-inactive', {
      'id': 'pl-inactive',
      'name': 'Inactive VIP',
      'list_type': 'custom',
      'is_default': false,
      'is_active': false,
    });

    // Seed a product
    await store.putEntity('product', 'prod-1', {
      'id': 'prod-1',
      'name': 'Super Basmati Rice 5kg',
      'sku': 'RICE-5',
    });

    // Seed prices:
    // Default list price: Rs 1000
    await store.putEntity('price_list_item', 'pli-def', {
      'id': 'pli-def',
      'price_list_id': 'pl-default',
      'parent_id': 'prod-1',
      'product_id': 'prod-1',
      'unit_price': '1000.00',
      'min_qty': '1',
    });

    // Wholesale list: base price Rs 900 (min_qty=1), tier price Rs 850 (min_qty=10)
    await store.putEntity('price_list_item', 'pli-ws-base', {
      'id': 'pli-ws-base',
      'price_list_id': 'pl-wholesale',
      'parent_id': 'prod-1',
      'product_id': 'prod-1',
      'unit_price': '900.00',
      'min_qty': '1',
    });
    await store.putEntity('price_list_item', 'pli-ws-tier', {
      'id': 'pli-ws-tier',
      'price_list_id': 'pl-wholesale',
      'parent_id': 'prod-1',
      'product_id': 'prod-1',
      'unit_price': '850.00',
      'min_qty': '10',
    });

    // Expired list price: Rs 700
    await store.putEntity('price_list_item', 'pli-exp', {
      'id': 'pli-exp',
      'price_list_id': 'pl-expired',
      'parent_id': 'prod-1',
      'product_id': 'prod-1',
      'unit_price': '700.00',
      'min_qty': '1',
    });

    // Seed customers
    await store.putEntity('customer', 'cust-walkin', {
      'id': 'cust-walkin',
      'name': 'Walk-in Customer',
      'price_list_id': null,
    });
    await store.putEntity('customer', 'cust-wholesale', {
      'id': 'cust-wholesale',
      'name': 'Ahmed Traders',
      'price_list_id': 'pl-wholesale',
    });
    await store.putEntity('customer', 'cust-expired', {
      'id': 'cust-expired',
      'name': 'Old Partner',
      'price_list_id': 'pl-expired',
    });
    await store.putEntity('customer', 'cust-inactive', {
      'id': 'cust-inactive',
      'name': 'Blocked VIP',
      'price_list_id': 'pl-inactive',
    });

    // Test 1: Walk-in customer (no customer or no price list) -> default list (1000.00)
    final p1 = await catalog.price('prod-1', now: now);
    expect(p1, Decimal.parse('1000.00'));

    final pWalkin = await catalog.price('prod-1', customerId: 'cust-walkin', now: now);
    expect(pWalkin, Decimal.parse('1000.00'));

    // Test 2: Wholesale customer buying 1 unit -> wholesale base price (900.00)
    final pWs1 = await catalog.price(
      'prod-1',
      customerId: 'cust-wholesale',
      qty: Decimal.one,
      now: now,
    );
    expect(pWs1, Decimal.parse('900.00'));

    // Test 3: Wholesale customer buying 10 units -> wholesale tier price (850.00)
    final pWs10 = await catalog.price(
      'prod-1',
      customerId: 'cust-wholesale',
      qty: Decimal.parse('10'),
      now: now,
    );
    expect(pWs10, Decimal.parse('850.00'));

    // Test 4: Expired price list -> falls back to default list (1000.00)
    final pExp = await catalog.price(
      'prod-1',
      customerId: 'cust-expired',
      now: now,
    );
    expect(pExp, Decimal.parse('1000.00'));

    // Test 5: Inactive price list -> falls back to default list (1000.00)
    final pInact = await catalog.price(
      'prod-1',
      customerId: 'cust-inactive',
      now: now,
    );
    expect(pInact, Decimal.parse('1000.00'));

    // Test 6: Product not in customer's list -> falls back to default list
    await store.putEntity('product', 'prod-2', {
      'id': 'prod-2',
      'name': 'Cooking Oil 1L',
    });
    await store.putEntity('price_list_item', 'pli-def-oil', {
      'id': 'pli-def-oil',
      'price_list_id': 'pl-default',
      'parent_id': 'prod-2',
      'product_id': 'prod-2',
      'unit_price': '520.00',
      'min_qty': '1',
    });

    final pOil = await catalog.price(
      'prod-2',
      customerId: 'cust-wholesale',
      now: now,
    );
    expect(pOil, Decimal.parse('520.00'));

    // Test 7: rememberPrice updates local catalog immediately
    await catalog.rememberPriceItem({
      'id': 'pli-ws-oil',
      'price_list_id': 'pl-wholesale',
      'product_id': 'prod-2',
      'unit_price': '490.00',
      'min_qty': '1',
    });

    final pOilUpdated = await catalog.price(
      'prod-2',
      customerId: 'cust-wholesale',
      now: now,
    );
    expect(pOilUpdated, Decimal.parse('490.00'));
  });

  test('BUG 4: Seeds duplicate rows with different prices and proves POS resolves the newest one', () async {
    final catalog = world.rig.catalog;
    final store = world.rig.store;

    await store.putEntity('price_list', 'pl-wholesale', {
      'id': 'pl-wholesale',
      'name': 'Wholesale',
      'list_type': 'wholesale',
      'is_default': false,
      'is_active': true,
    });

    await store.putEntity('product', 'p-dup', {
      'id': 'p-dup',
      'name': 'Test Duplicate Product',
    });

    await store.putEntity('customer', 'c-ws', {
      'id': 'c-ws',
      'name': 'Wholesale Customer',
      'price_list_id': 'pl-wholesale',
    });

    // Seed duplicate rows directly using custom SQL to simulate legacy stale rows:
    // Row 1: Oldest placeholder row (price: 250.00)
    await store.db.customStatement(
      "INSERT INTO entities (entity, id, parent_id, data, active, is_deleted, seq) "
      "VALUES ('price_list_item', 'pl-wholesale_p-dup_base_1', 'p-dup', "
      "'{\"id\":\"pl-wholesale_p-dup_base_1\",\"price_list_id\":\"pl-wholesale\",\"product_id\":\"p-dup\",\"unit_price\":\"250.00\",\"min_qty\":1,\"created_at\":\"2026-01-01T00:00:00\"}', 1, 0, 1)",
    );

    // Row 2: Intermediate stale row (price: 200.00)
    await store.db.customStatement(
      "INSERT INTO entities (entity, id, parent_id, data, active, is_deleted, seq) "
      "VALUES ('price_list_item', 'row-middle-uuid', 'p-dup', "
      "'{\"id\":\"row-middle-uuid\",\"price_list_id\":\"pl-wholesale\",\"product_id\":\"p-dup\",\"unit_price\":\"200.00\",\"min_qty\":1,\"created_at\":\"2026-02-01T00:00:00\"}', 1, 0, 5)",
    );

    // Row 3: Newest row (price: 300.00)
    await store.db.customStatement(
      "INSERT INTO entities (entity, id, parent_id, data, active, is_deleted, seq) "
      "VALUES ('price_list_item', 'row-newest-uuid', 'p-dup', "
      "'{\"id\":\"row-newest-uuid\",\"price_list_id\":\"pl-wholesale\",\"product_id\":\"p-dup\",\"unit_price\":\"300.00\",\"min_qty\":1,\"created_at\":\"2026-03-01T00:00:00\",\"updated_at\":\"2026-03-01T00:00:00\"}', 1, 0, 10)",
    );

    // 1. Prove POS resolves the newest row (300.00), not the older rows (250.00 or 200.00)
    final resolvedPrice = await catalog.price(
      'p-dup',
      customerId: 'c-ws',
    );
    expect(resolvedPrice, Decimal.parse('300.00'));

    // 2. Run one-time cleanup/migration: should delete the 2 older duplicate rows and placeholder row
    final removedCount = await store.cleanupDuplicatePriceListItems(force: true);
    expect(removedCount, 2);

    // Verify only the newest row remains in the database
    final remainingRows = await store.entities(
      'price_list_item',
      where: 'parent_id = ?',
      args: ['p-dup'],
    );
    expect(remainingRows.length, 1);
    expect(remainingRows.first['id'], 'row-newest-uuid');
    expect(remainingRows.first['unit_price'], '300.00');

    // POS still resolves 300.00
    final priceAfterCleanup = await catalog.price('p-dup', customerId: 'c-ws');
    expect(priceAfterCleanup, Decimal.parse('300.00'));
  });

  test('BUG 4: Changes a wholesale price twice in a row and POS shows the latest each time', () async {
    final catalog = world.rig.catalog;
    final store = world.rig.store;

    await store.putEntity('price_list', 'pl-ws2', {
      'id': 'pl-ws2',
      'name': 'Wholesale 2',
      'list_type': 'wholesale',
      'is_default': false,
      'is_active': true,
    });

    await store.putEntity('product', 'p-dyn', {
      'id': 'p-dyn',
      'name': 'Dynamic Price Product',
    });

    await store.putEntity('customer', 'c-ws2', {
      'id': 'c-ws2',
      'name': 'Customer 2',
      'price_list_id': 'pl-ws2',
    });

    // Initial price: 200.00
    await catalog.rememberPrice(
      listId: 'pl-ws2',
      productId: 'p-dyn',
      price: '200.00',
    );
    var p = await catalog.price('p-dyn', customerId: 'c-ws2');
    expect(p, Decimal.parse('200.00'));

    // First change: updates price to 250.00
    await catalog.rememberPrice(
      listId: 'pl-ws2',
      productId: 'p-dyn',
      price: '250.00',
    );
    p = await catalog.price('p-dyn', customerId: 'c-ws2');
    expect(p, Decimal.parse('250.00'));

    // Second change: updates price to 300.00
    await catalog.rememberPrice(
      listId: 'pl-ws2',
      productId: 'p-dyn',
      price: '300.00',
    );
    p = await catalog.price('p-dyn', customerId: 'c-ws2');
    expect(p, Decimal.parse('300.00'));

    // Verify there are no duplicate twin rows
    final items = await store.entities(
      'price_list_item',
      where: 'parent_id = ?',
      args: ['p-dyn'],
    );
    expect(items.length, 1);
    expect(items.first['unit_price'], '300.00');
  });
}
