// Friendly product import against a REAL backend (see live_backend.dart for how
// to start it on the TEST database).
//
// A throw-away business, the real repository + remote datasource + cubit and a
// real (in-memory) local catalog. The exact 24-row file of the bug report (shop
// owner spellings kg / ltr / pkt / pcs, three categories, some 8-digit
// barcodes) is imported as CSV and then as .xlsx; the server is checked after
// each step, undo is exercised, and everything is timed.
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart'; // ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/features/product_import/data/product_import_remote_datasource.dart';
import 'package:frantend/features/product_import/data/product_import_repository_impl.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_cubit.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';
import 'package:frantend/features/quick_add/data/quick_add_remote_datasource.dart';
import 'package:frantend/features/quick_add/data/quick_add_repository_impl.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:decimal/decimal.dart';

import 'live_backend.dart';
import 'products_rig.dart';

class _Probe extends Fake implements ConnectivityProbe {
  @override
  bool get isReachable => true;

  @override
  Stream<ReachabilityStatus> get status => const Stream.empty();
}

/// The file from the bug report: name, unit, category, cost, price, stock.
const bugRows = <(String, String, String, String, String, String)>[
  ('Basmati Rice', 'kg', 'Groceries', '380', '420', '25'),
  ('Sugar', 'kg', 'Groceries', '130', '150', '40'),
  ('Flour (Atta)', 'KG', 'Groceries', '90', '105', '60'),
  ('Cooking Oil', 'ltr', 'Groceries', '520', '560', '30'),
  ('Milk', 'Ltr', 'Beverages', '180', '200', '20'),
  ('Cola 1.5L', 'ltr', 'Beverages', '110', '130', '48'),
  ('Orange Juice', 'ltrs', 'Beverages', '150', '180', '12'),
  ('Tea Packet', 'pkt', 'Groceries', '250', '290', '50'),
  ('Biscuits', 'pkt', 'Groceries', '45', '60', '100'),
  ('Chips', 'Pkt.', 'Groceries', '40', '50', '80'),
  ('Noodles', 'packet', 'Groceries', '35', '45', '70'),
  ('Pen Blue', 'pcs', 'Stationery', '8', '12', '200'),
  ('Pen Black', 'pcs', 'Stationery', '8', '12', '200'),
  ('Notebook', 'pcs', 'Stationery', '60', '80', '50'),
  ('Pencil', 'Pcs', 'Stationery', '5', '8', '300'),
  ('Eraser', 'pc', 'Stationery', '4', '7', '150'),
  ('Marker', 'nos', 'Stationery', '30', '45', '40'),
  ('Glue Stick', 'pieces', 'Stationery', '25', '40', '35'),
  ('Mineral Water', 'Pieces', 'Beverages', '60', '80', '96'),
  ('Soap', 'pcs', 'Groceries', '70', '90', '55'),
  ('Salt', 'kg', 'Groceries', '40', '55', '45'),
  ('Dates', 'kgs', 'Groceries', '600', '700', '15'),
  ('Honey', 'gm', 'Groceries', '900', '1100', '10'),
  ('Spice Mix', 'g', 'Groceries', '20', '30', '90'),
];

const _header = ['name', 'sku', 'barcode', 'category', 'unit', 'cost', 'price', 'opening_stock'];

/// Every third row gets an 8-digit barcode (a "short barcode" warning, never
/// an error), the others none.
List<List<String>> grid(String prefix) => [
      for (var i = 0; i < bugRows.length; i++)
        [
          bugRows[i].$1,
          '$prefix-${(i + 1).toString().padLeft(2, '0')}',
          i % 3 == 0 ? '${12345600 + i}' : '',
          bugRows[i].$3,
          bugRows[i].$2,
          bugRows[i].$4,
          bugRows[i].$5,
          bugRows[i].$6,
        ],
    ];

ImportFile csvOf(List<List<String>> rows, String name) => ImportFile(
      name: name,
      bytes: Uint8List.fromList(utf8.encode([_header, ...rows].map((r) => r.join(',')).join('\n') + '\n')),
      kind: ImportFileKind.csv,
    );

/// A small but real .xlsx (zip of XML parts, text as inline strings).
ImportFile xlsxOf(List<List<String>> rows, String name) {
  String col(int i) => String.fromCharCode(65 + i);
  const numeric = {5, 6, 7};
  final sb = StringBuffer(
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>',
  );
  final all = [_header, ...rows];
  for (var r = 0; r < all.length; r++) {
    sb.write('<row r="${r + 1}">');
    for (var c = 0; c < all[r].length; c++) {
      final v = all[r][c];
      final ref = '${col(c)}${r + 1}';
      if (v.isEmpty) continue;
      if (r > 0 && numeric.contains(c)) {
        sb.write('<c r="$ref"><v>$v</v></c>');
      } else {
        final esc = v.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
        sb.write('<c r="$ref" t="inlineStr"><is><t>$esc</t></is></c>');
      }
    }
    sb.write('</row>');
  }
  sb.write('</sheetData></worksheet>');

  void add(Archive a, String path, String xml) {
    final bytes = utf8.encode(xml);
    a.addFile(ArchiveFile(path, bytes.length, bytes));
  }

  final zip = Archive();
  add(
    zip,
    '[Content_Types].xml',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
        '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
        '</Types>',
  );
  add(
    zip,
    '_rels/.rels',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
        '</Relationships>',
  );
  add(
    zip,
    'xl/workbook.xml',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
        'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
        '<sheets><sheet name="Products" sheetId="1" r:id="rId1"/></sheets></workbook>',
  );
  add(
    zip,
    'xl/_rels/workbook.xml.rels',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
        '</Relationships>',
  );
  add(zip, 'xl/worksheets/sheet1.xml', sb.toString());
  return ImportFile(
    name: name,
    bytes: Uint8List.fromList(ZipEncoder().encode(zip)),
    kind: ImportFileKind.xlsx,
  );
}

void main() {
  if (liveSkip != false) {
    test('live product import tests', () {}, skip: liveSkip);
    return;
  }

  late LiveTenant tenant;
  late ProductsRig products;
  late ProductImportRepositoryImpl repo;
  var syncs = 0;
  final timings = <String, int>{};
  final all = Stopwatch();

  Future<T> timed<T>(String label, Future<T> Function() body) async {
    final sw = Stopwatch()..start();
    final r = await body();
    timings[label] = sw.elapsedMilliseconds;
    return r;
  }

  ProductImportCubit cubit() => ProductImportCubit(repository: repo, canCreateTaxRates: true);

  Future<int> productCount() async => (await tenant.get('/products', query: {'limit': 200}))['total'] as int;

  Future<Set<String>> names(String path) async =>
      (await tenant.getList(path, query: {'limit': 200})).cast<Map>().map((e) => '${e['name']}').toSet();

  Future<double> stockOf(String sku) async {
    final list = await tenant.get('/products', query: {'limit': 200, 'search': sku});
    final p = (list['items'] as List).cast<Map>().firstWhere((e) => e['sku'] == sku);
    final balances = await tenant.getList('/stock/balances', query: {'branch_id': tenant.branchId});
    return balances
        .cast<Map>()
        .where((b) => b['product_id'] == p['id'])
        .fold<double>(0, (s, b) => s + double.parse('${b['current_qty']}'));
  }

  setUpAll(() async {
    all.start();
    tenant = await LiveTenant.register(liveApiBase()!, label: 'Sehat Import');
    products = ProductsRig(tenant);
    repo = ProductImportRepositoryImpl(
      remote: ProductImportRemoteDataSource(tenant.client),
      catalog: products.catalog,
      probe: _Probe(),
      errorHandler: const ErrorHandler(),
      branchId: () => tenant.branchId,
      syncNow: () async => syncs++,
    );
  });

  tearDownAll(() async {
    await products.dispose();
    // ignore: avoid_print
    print('LIVE IMPORT TIMINGS (ms): $timings  total=${all.elapsedMilliseconds}');
  });

  test('the template is built from this business, as CSV and as Excel', () async {
    final csv = await timed('template csv', () async => (await repo.template(ImportFileKind.csv)).getOrElse(() => throw StateError('csv template failed')));
    expect(csv.bytes, isNotEmpty);
    expect(utf8.decode(csv.bytes, allowMalformed: true).split('\n').first.toLowerCase(), contains('name'));
    final xlsx = await timed('template xlsx', () async => (await repo.template(ImportFileKind.xlsx)).getOrElse(() => throw StateError('xlsx template failed')));
    expect(xlsx.bytes.sublist(0, 2), [0x50, 0x4B], reason: 'an .xlsx is a zip');
    expect(xlsx.fileName, endsWith('.xlsx'));
  });

  test('the bug-report file (CSV): zero errors, units and categories created, stock right, undo works', () async {
    final file = csvOf(grid('CSV'), 'owner products.csv');
    final c = cubit();
    addTearDown(c.close);
    await c.start();
    expect(await productCount(), 0);

    // ── check (dry run) ─────────────────────────────────────────────────
    await timed('csv: check', () => c.chooseFile(file));
    final s = c.state;
    expect(s.error, isNull, reason: 'error: ${s.error}');
    expect(s.step, ImportStep.review);
    expect(s.summary.totalRows, 24);
    expect(s.summary.errors, 0, reason: 'groups: ${s.report!.groups.map((g) => '${g.code}:${g.rowsCount}').toList()}');
    expect(s.summary.create, 24);
    expect(s.report!.groups, isEmpty);
    expect(s.summary.warnings, greaterThan(0), reason: '8-digit barcodes warn');
    expect(s.report!.warningGroups, isNotEmpty);
    expect(s.canApply, isTrue);
    expect(s.onError, ImportOnError.abort, reason: 'no problem rows: nothing to skip');
    expect(
      s.setup.categories.map((e) => e.input).toSet(),
      containsAll(['Groceries', 'Beverages', 'Stationery']),
    );
    // Nothing was written by the check.
    expect(await productCount(), 0);
    expect(await names('/categories'), isNot(contains('Groceries')));

    // ── apply ───────────────────────────────────────────────────────────
    await timed('csv: apply', c.apply);
    expect(c.state.error, isNull, reason: 'error: ${c.state.error}');
    expect(c.state.step, ImportStep.done);
    expect(c.state.applied!.summary.applied, 24);
    expect(c.state.applied!.summary.errors, 0);
    expect(c.state.applied!.batchId, isNotNull);
    expect(c.state.appliedBatch, isNotNull, reason: 'Recent imports lists the new batch');
    expect(c.state.appliedBatch!.canUndo, isTrue);
    expect(syncs, greaterThan(0), reason: 'the catalog is pulled after the import');

    expect(await productCount(), 24);
    expect(await names('/categories'), containsAll(['Groceries', 'Beverages', 'Stationery']));
    final units = await names('/units');
    // Shop-owner spellings are mapped to real units; none of the junk spellings became a unit.
    for (final junk in ['pkt', 'ltr', 'pcs', 'Pkt.', 'ltrs', 'kgs']) {
      expect(units, isNot(contains(junk)), reason: '"$junk" must be an alias, not a new unit');
    }

    // Stock and prices of a few rows.
    expect(await stockOf('CSV-01'), 25);
    expect(await stockOf('CSV-12'), 200);
    expect(await stockOf('CSV-24'), 90);
    final balances = await tenant.getList('/stock/balances', query: {'branch_id': tenant.branchId});
    final total = balances.cast<Map>().fold<double>(0, (s, b) => s + double.parse('${b['current_qty']}'));
    expect(total, bugRows.fold<double>(0, (s, r) => s + double.parse(r.$6)));

    // The Products list sees them (and they "need details": no picture yet).
    await products.list.loadProducts();
    expect((products.list.state as ProductsListLoaded).total, 24);

    // The same file again changes nothing.
    final again = cubit();
    addTearDown(again.close);
    await again.start();
    await again.chooseFile(file);
    expect(again.state.summary.create, 0);
    expect(again.state.summary.unchanged + again.state.summary.update, 24);

    // ── Recent imports + undo ───────────────────────────────────────────
    await c.loadBatches();
    expect(c.state.batches.first.status, ImportBatchStatus.active);
    await timed('csv: undo', () => c.undo(c.state.applied!.batchId!));
    expect(c.state.undoMessage, isNotNull);
    expect(c.state.undoResult, isNotNull, reason: 'undo message: ${c.state.undoMessage}');
    expect(c.state.undoResult!.productsRemoved, 24);
    expect(await productCount(), 0);
    expect(c.state.batches.first.status, ImportBatchStatus.undone);
    expect(c.state.batches.first.canUndo, isFalse);

    // A second undo is refused in plain words.
    await c.undo(c.state.applied!.batchId!);
    expect(c.state.undoResult, isNull);
    expect(c.state.undoMessage, contains('already undone'));
  });

  test('the same file as .xlsx imports the same way', () async {
    final file = xlsxOf(grid('XLS'), 'owner products.xlsx');
    final c = cubit();
    addTearDown(c.close);
    await c.start();

    await timed('xlsx: check', () => c.chooseFile(file));
    expect(c.state.error, isNull, reason: 'error: ${c.state.error}');
    expect(c.state.summary.errors, 0, reason: 'groups: ${c.state.report?.groups.map((g) => g.code).toList()}');
    expect(c.state.summary.create, 24);
    expect(c.state.canApply, isTrue);

    await timed('xlsx: apply', c.apply);
    expect(c.state.error, isNull, reason: 'error: ${c.state.error}');
    expect(c.state.applied!.summary.applied, 24);
    expect(await productCount(), 24);
    expect(await stockOf('XLS-01'), 25);
    expect(c.state.appliedBatch?.source, 'xlsx');

    await timed('xlsx: undo', () => c.undo(c.state.applied!.batchId!));
    expect(c.state.undoResult, isNotNull, reason: 'undo message: ${c.state.undoMessage}');
    expect(await productCount(), 0);
  });

  test('rows with problems are grouped; skipping them imports the rest', () async {
    final rows = grid('BAD');
    rows[2][0] = ''; // name missing
    rows[5][0] = '';
    rows[9][6] = 'abc'; // price is not a number
    final file = csvOf(rows, 'with problems.csv');
    final c = cubit();
    addTearDown(c.close);
    await c.start();
    await c.chooseFile(file);

    expect(c.state.summary.errors, 3);
    expect(c.state.report!.groups.length, 2, reason: 'grouped by reason: ${c.state.report!.groups.map((g) => g.code).toList()}');
    expect(c.state.report!.groups.fold<int>(0, (s, g) => s + g.rowsCount), 3);
    expect(c.state.onError, ImportOnError.skip, reason: 'most rows are fine: skipping is preselected');
    expect(c.state.canApply, isTrue);

    c.setOnError(ImportOnError.abort);
    expect(c.state.canApply, isFalse, reason: 'Stop: the button is off');
    c.setOnError(ImportOnError.skip);

    await c.apply();
    expect(c.state.error, isNull, reason: 'error: ${c.state.error}');
    expect(c.state.applied!.summary.applied, 21);
    expect(c.state.applied!.summary.errors, 3);
    expect(await productCount(), 21);

    await c.undo(c.state.applied!.batchId!);
    expect(await productCount(), 0);
  });

  test('a product that was sold cannot be undone, and the answer says why', () async {
    final file = csvOf(grid('SLD').take(3).toList(), 'three.csv');
    final c = cubit();
    addTearDown(c.close);
    await c.start();
    await c.chooseFile(file);
    await c.apply();
    expect(c.state.applied!.summary.applied, 3);

    // A stock movement on one imported product: it has history now.
    final list = await tenant.get('/products', query: {'limit': 50, 'search': 'SLD-02'});
    final p = (list['items'] as List).cast<Map>().firstWhere((e) => e['sku'] == 'SLD-02');
    final adjust = await tenant.dio.post<Object?>('/adjustments', data: {
      'branch_id': tenant.branchId,
      'reason': 'opening_balance',
      'lines': [
        {'product_id': p['id'], 'qty_delta': '5', 'cost_per_unit': '130'},
      ],
    });
    expect(adjust.statusCode, 201);

    await c.undo(c.state.applied!.batchId!);
    expect(c.state.undoResult, isNull, reason: 'refused');
    final msg = c.state.undoMessage!;
    expect(msg, contains('Sugar'), reason: 'names the product that blocks it');
    expect(msg, contains('Nothing was changed'));
    expect(await productCount(), 3, reason: 'a refused undo changes nothing');
    await c.loadBatches();
    expect(c.state.batches.first.status, ImportBatchStatus.active);
  });

  test("Quick Add: a typed unit and category are created by the server while saving (unit_name / category_name)", () async {
    final quick = QuickAddRepositoryImpl(
      remote: QuickAddRemoteDataSource(tenant.client),
      catalog: products.catalog,
      probe: _Probe(),
      errorHandler: const ErrorHandler(),
      branchId: () => tenant.branchId,
      syncNow: () async => syncs++,
    );
    final stamp = DateTime.now().millisecondsSinceEpoch % 100000;
    final row = QuickAddRow(
      id: 'qa-new-$stamp',
      barcode: '6001234${(stamp % 100000).toString().padLeft(5, '0')}0',
      name: 'Panadol Strip',
      unitLabel: 'Strip$stamp',
      newUnitName: 'Strip$stamp',
      categoryLabel: 'Medicine$stamp',
      newCategoryName: 'Medicine$stamp',
      qty: Decimal.parse('4'),
      cost: Decimal.parse('10'),
      salePrice: Decimal.parse('12'),
    );
    final res = await quick.submit(
      QuickAddRequest(mode: QuickAddMode.openingStock, branchId: tenant.branchId, rows: [row]),
      idempotencyKey: 'live-new-names-$stamp',
    );
    final r = res.getOrElse(() => throw StateError('quick add failed: ${res.swap().getOrElse(() => throw StateError(''))}'));
    expect(r.created, 1, reason: 'lines: ${r.lines.map((l) => '${l.outcome}').toList()}');
    expect(await names('/units'), contains('Strip$stamp'));
    expect(await names('/categories'), contains('Medicine$stamp'));
  });
}
