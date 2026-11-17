// Group 2 against a REAL backend: create a product with two variations and
// barcodes through the real form cubit, see it in the list and in the local
// catalog at once, edit it, delete it, and the same for categories, brands and
// units. See live_backend.dart for how to start the backend.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';

import 'live_backend.dart';
import 'products_rig.dart';

void main() {
  // Every test below needs LIVE_API_BASE (see live_backend.dart).
  if (liveSkip != false) {
    test('live product tests', () {}, skip: liveSkip);
    return;
  }
  late LiveTenant tenant;
  late ProductsRig rig;
  late String categoryId;
  late String brandId;

  setUpAll(() async {
    final base = liveApiBase();
    if (base == null) return;
    tenant = await LiveTenant.register(base, label: 'Sehat Products');
    categoryId = (await tenant.post('/categories', {'name': 'Painkillers'}))['id'] as String;
    brandId = (await tenant.post('/brands', {'name': 'GSK'}))['id'] as String;
  });

  setUp(() {
    if (liveApiBase() == null) return;
    rig = ProductsRig(tenant);
  });
  tearDown(() async {
    if (liveApiBase() != null) await rig.dispose();
  });

  var seq = 0;
  String code() => '62${DateTime.now().microsecondsSinceEpoch}${seq++}';

  Future<String> createWithVariationsAndBarcodes(String name) async {
    final f = rig.form;
    f.initCreate();
    f.updateName(name);
    f.updateBaseUnitId(tenant.unitId);
    f.updateProductType('standard');
    f.updateCategoryId(categoryId);
    f.updateBrandId(brandId);
    f.addVariationRow();
    f.addVariationRow();
    f.updateVariationRow(
      0,
      f.state.variations[0].copyWith(name: 'Strip of 10', sku: '$name-S10', weightGrams: '12.5'),
    );
    f.updateVariationRow(
      1,
      f.state.variations[1].copyWith(name: 'Box of 100', sku: '$name-B100'),
    );
    f.addBarcodeRow();
    f.addBarcodeRow();
    f.addBarcodeRow();
    f.updateBarcodeRow(0, BarcodeFormItem(barcode: code(), variationId: 'local:0'));
    f.updateBarcodeRow(1, BarcodeFormItem(barcode: code(), variationId: 'local:1'));
    f.updateBarcodeRow(2, BarcodeFormItem(barcode: code())); // product level
    final id = await f.submit();
    expect(id, isNotNull, reason: 'submit failed: ${f.state.errors}');
    return id!;
  }

  test('create with variations + barcodes: no exception, barcodes land where they were put, '
      'list and local catalog have it at once', () async {
    final name = 'Panadol ${DateTime.now().millisecondsSinceEpoch}';
    await rig.list.loadProducts();
    expect(rig.list.state, isA<ProductsListLoaded>());
    final before = (rig.list.state as ProductsListLoaded).total;

    final id = await createWithVariationsAndBarcodes(name);
    expect(rig.form.state.errors, isEmpty);
    expect(rig.afterWrites, greaterThan(0), reason: 'a pull must be requested after a write');

    // The server has the barcodes on the right variations.
    final server = await tenant.get('/products/$id');
    final vars = (server['variations'] as List).cast<Map>();
    expect(vars.map((v) => v['name']), containsAll(['Strip of 10', 'Box of 100']));
    expect((vars.firstWhere((v) => v['name'] == 'Strip of 10')['barcodes'] as List), hasLength(1));
    expect((vars.firstWhere((v) => v['name'] == 'Box of 100')['barcodes'] as List), hasLength(1));
    expect(server['category'], isA<Map>());
    expect((server['category'] as Map).containsKey('business_id'), isFalse,
        reason: 'the embedded category is the slim CategoryBrief');

    // What the page does after "Save": pop(true) -> refresh.
    await rig.list.refresh();
    final loaded = rig.list.state as ProductsListLoaded;
    expect(loaded.total, before + 1);
    expect(loaded.items.map((p) => p.id), contains(id));

    // The local copy (POS grid, pickers) has it with variations and barcodes.
    final local = await rig.catalog.product(id);
    expect(local, isNotNull, reason: 'product not written into the local catalog');
    expect(local!.variations.map((v) => v.name), containsAll(['Strip of 10', 'Box of 100']));
    expect(local.category?.id, categoryId);
    final page = await rig.catalog.products(search: name);
    expect(page.items.map((p) => p.id), contains(id));
    final byBarcode = await rig.catalog.productByBarcode(
        ((vars.first['barcodes'] as List).first as Map)['barcode'] as String);
    expect(byBarcode?.id, id);
  });

  test('a store event is emitted when the product is saved (open screens re-read)', () async {
    var events = 0;
    final sub = rig.catalog.changes.listen((_) => events++);
    await createWithVariationsAndBarcodes('Event ${DateTime.now().millisecondsSinceEpoch}');
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(events, greaterThan(0));
  });

  test('edit: rename, add a variation with its barcode, change category; list + local follow',
      () async {
    final id = await createWithVariationsAndBarcodes('Edit ${DateTime.now().millisecondsSinceEpoch}');
    final f = rig.form;
    await f.loadForEdit(id);
    expect(f.state.errors, isEmpty, reason: '${f.state.errors}');
    expect(f.state.selectedCategoryId, categoryId);
    expect(f.state.variations, hasLength(2));

    final newName = 'Edited ${DateTime.now().millisecondsSinceEpoch}';
    f.updateName(newName);
    f.addVariationRow();
    f.updateVariationRow(2, f.state.variations[2].copyWith(name: 'Pack of 3'));
    f.addBarcodeRow();
    final extra = code();
    f.updateBarcodeRow(
        f.state.barcodes.length - 1, BarcodeFormItem(barcode: extra, variationId: 'local:2'));
    final saved = await f.submit();
    expect(saved, id, reason: 'update failed: ${f.state.errors}');

    final server = await tenant.get('/products/$id');
    expect(server['name'], newName);
    final pack = (server['variations'] as List).cast<Map>().firstWhere((v) => v['name'] == 'Pack of 3');
    expect((pack['barcodes'] as List).map((b) => (b as Map)['barcode']), [extra]);

    await rig.list.refresh();
    final item = (rig.list.state as ProductsListLoaded).items.firstWhere((p) => p.id == id);
    expect(item.name, newName);

    final local = await rig.catalog.product(id);
    expect(local!.name, newName);
    expect(local.variations.map((v) => v.name), contains('Pack of 3'));
    expect((await rig.catalog.productByBarcode(extra))?.id, id);
  });

  test('toggle active and delete: list, server and local copy agree', () async {
    final id = await createWithVariationsAndBarcodes('Del ${DateTime.now().millisecondsSinceEpoch}');
    await rig.list.loadProducts();
    final loaded = rig.list.state as ProductsListLoaded;
    expect(loaded.items.map((p) => p.id), contains(id));
    final before = loaded.total;

    expect(await rig.list.toggleActive(id, false), isTrue);
    expect((await tenant.get('/products/$id'))['is_active'], false);
    expect((await rig.catalog.product(id))?.isActive, false);

    expect(await rig.list.deleteProduct(id), isTrue);
    final after = rig.list.state as ProductsListLoaded;
    expect(after.items.map((p) => p.id), isNot(contains(id)));
    expect(after.total, before - 1);
    expect(await rig.catalog.product(id), isNull, reason: 'deleted product still in local copy');
    final gone = await tenant.dio.get<Object?>(
      '/products/$id',
      options: Options(validateStatus: (_) => true),
    );
    expect(gone.statusCode, 404, reason: 'the server still serves a deleted product');
  });

  test('categories, brands, units created through the repository reach the local catalog',
      () async {
    final cat = await rig.repo.createCategory({'name': 'Vitamins ${DateTime.now().millisecondsSinceEpoch}'});
    final catModel = cat.getOrElse(() => throw StateError('category create failed: $cat'));
    expect((await rig.catalog.categories()).map((c) => c.id), contains(catModel.id));
    await rig.repo.deleteCategory(catModel.id);
    expect((await rig.catalog.categories()).map((c) => c.id), isNot(contains(catModel.id)));

    final brand = await rig.repo.createBrand({'name': 'Brand ${DateTime.now().millisecondsSinceEpoch}'});
    final b = brand.getOrElse(() => throw StateError('brand create failed: $brand'));
    expect(await rig.store.entity('brand', b.id), isNotNull);
    await rig.repo.deleteBrand(b.id);
    expect(await rig.store.entity('brand', b.id), isNull);

    final unit = await rig.repo.createUnit({
      'name': 'Carton ${DateTime.now().millisecondsSinceEpoch}',
      'symbol': 'ct',
      'allows_decimal': false,
    });
    final u = unit.getOrElse(() => throw StateError('unit create failed: $unit'));
    expect(await rig.store.entity('unit', u.id), isNotNull);
  });
}
