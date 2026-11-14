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
    await catalog.rememberPrice({
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
}
