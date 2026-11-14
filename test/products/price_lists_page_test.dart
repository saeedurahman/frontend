import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/presentation/cubit/price_lists_cubit.dart';
import 'package:frantend/features/products/presentation/pages/price_lists_page.dart';

import '../helpers/fake_http.dart';

/// Widget tests that pump the REAL [PriceListsPage] against a fake server and
/// tap real widgets. (Cubit-only tests missed a layout crash that made the
/// whole screen unresponsive.)

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Local extends Fake implements ProductsLocalDataSource {}

class _Files extends Fake implements FileSaverService {
  _Files(this.path);
  final String path;
  @override
  Future<String?> pickFile(
          {List<String> extensions = const [], String? label}) async =>
      path;
  @override
  File readFile(String p) => File(p);
  @override
  Future<String?> saveFileWithDialog(String suggestedName, Uint8List bytes,
          {List<String> extensions = const []}) async =>
      null;
}

class _Probe extends Fake implements ConnectivityProbe {
  _Probe(this.verdict);
  ReachabilityStatus verdict;
  @override
  Future<ReachabilityStatus> check() async => verdict;
  @override
  ReachabilityStatus get current => verdict;
  @override
  bool get isReachable => verdict != ReachabilityStatus.offline;
}

Map<String, dynamic> _list(String id, String name,
        {bool def = false, int items = 2}) =>
    {
      'id': id,
      'business_id': 'b1',
      'name': name,
      'list_type': 'retail',
      'is_default': def,
      'is_active': true,
      'valid_from': null,
      'valid_to': null,
      'items': [],
      'item_count': items,
      'customer_count': 1,
    };

void main() {
  late FakeAdapter adapter;
  late List<Map<String, dynamic>> lists;

  ProductsRepositoryImpl buildRepo(FakeAdapter a, ReachabilityStatus status) {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = a;
    return ProductsRepositoryImpl(
      remoteDataSource: ProductsRemoteDataSourceImpl(_Dio(dio)),
      localDataSource: _Local(),
      connectivityProbe: _Probe(status),
      errorHandler: const ErrorHandler(),
    );
  }

  ResponseBody serve(RequestOptions o) {
    final p = o.path;
    final m = o.method;
    if (p == '/prices/lists' && m == 'GET') return jsonResponse(lists);
    if (p == '/prices/lists' && m == 'POST') {
      final b = o.data as Map;
      final created = _list('new1', b['name'] as String, items: 0);
      lists = [...lists, created];
      return jsonResponse(created, status: 201);
    }
    if (RegExp(r'^/prices/lists/[^/]+/items$').hasMatch(p) && m == 'GET') {
      return jsonResponse({
        'total': 1,
        'skip': 0,
        'limit': 50,
        'items': [
          {
            'id': 'i1',
            'price_list_id': 'l1',
            'product_id': 'p1',
            'variation_id': null,
            'product_name': 'Widget',
            'variation_name': null,
            'sku': 'W-1',
            'unit_price': '10.00',
            'min_qty': '1',
          }
        ],
      });
    }
    if (RegExp(r'^/prices/lists/[^/]+$').hasMatch(p) && m == 'PUT') {
      final id = p.split('/').last;
      final b = (o.data as Map).cast<String, dynamic>();
      final cur = lists.firstWhere((l) => l['id'] == id);
      final upd = {...cur, ...b};
      lists = [
        for (final l in lists)
          if (l['id'] == id)
            upd
          else if (b['is_default'] == true)
            {...l, 'is_default': false}
          else
            l
      ];
      return jsonResponse(upd);
    }
    if (p.endsWith('/copy') && m == 'POST') {
      final b = o.data as Map;
      final c = _list('copy1', b['name'] as String);
      lists = [...lists, c];
      return jsonResponse(c, status: 201);
    }
    if (p.endsWith('/adjust') && m == 'POST') {
      return jsonResponse({
        'dry_run': (o.data as Map)['dry_run'],
        'updated': 3,
        'unchanged': 1,
        'sample': [
          {
            'item_id': 'abcdefgh12345',
            'product_id': 'p1',
            'old_price': '10.00',
            'new_price': '11.00'
          }
        ],
      });
    }
    if (p.endsWith('/import') && m == 'POST') {
      return jsonResponse({
        'dry_run': (o.data as Map)['dry_run'],
        'summary': {'total': 2, 'valid': 2, 'errors': 0},
        'rows': [],
      });
    }
    if (p == '/categories') return jsonResponse([]);
    if (p.endsWith('/items/bulk') && m == 'POST') {
      return jsonResponse(
          {'created': 0, 'updated': 1, 'unchanged': 0, 'total': 1});
    }
    return jsonResponse({'detail': 'unexpected $m $p'}, status: 500);
  }

  void register(ProductsRepositoryImpl repo, ReachabilityStatus status) {
    if (sl.isRegistered<ProductsRepository>()) {
      sl.unregister<ProductsRepository>();
    }
    sl.registerSingleton<ProductsRepository>(repo);
    if (sl.isRegistered<PriceListsCubit>()) sl.unregister<PriceListsCubit>();
    sl.registerFactory<PriceListsCubit>(() => PriceListsCubit(
          productsRepository: repo,
          connectivityProbe: _Probe(status),
        ));
  }

  Future<void> pumpPage(WidgetTester tester,
      {ReachabilityStatus status = ReachabilityStatus.online,
      FakeHandler? handler}) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // The test font (Ahem) is much wider than the real one: ignore purely
    // cosmetic overflows, fail on anything else (e.g. layout crashes).
    final prev = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exceptionAsString().contains('overflowed')) return;
      prev?.call(d);
    };
    addTearDown(() => FlutterError.onError = prev);

    adapter = FakeAdapter(handler ?? serve);
    register(buildRepo(adapter, status), status);
    await tester.pumpWidget(const MaterialApp(home: PriceListsPage()));
    await tester.pumpAndSettle();
  }

  setUp(() => lists = [_list('l1', 'Retail (default)', def: true)]);
  tearDown(() {
    if (sl.isRegistered<PriceListsCubit>()) sl.unregister<PriceListsCubit>();
    if (sl.isRegistered<ProductsRepository>()) {
      sl.unregister<ProductsRepository>();
    }
    if (sl.isRegistered<FileSaverService>()) sl.unregister<FileSaverService>();
  });

  bool hit(String method, bool Function(String) pathTest) => adapter.requests
      .any((r) => r.method == method && pathTest(r.path));

  testWidgets('renders card and auto-opens the default list items',
      (tester) async {
    await pumpPage(tester);
    expect(find.text('Retail (default)'), findsWidgets);
    expect(find.text('Widget'), findsOneWidget);
    expect(hit('GET', (p) => p == '/prices/lists/l1/items'), true);
  });

  testWidgets('tapping a card opens its items grid', (tester) async {
    lists = [
      _list('l1', 'Retail (default)', def: true),
      _list('l2', 'Wholesale'),
    ];
    await pumpPage(tester);
    adapter.requests.clear();
    await tester.tap(find.text('Wholesale'));
    await tester.pumpAndSettle();
    expect(hit('GET', (p) => p == '/prices/lists/l2/items'), true);
  });

  testWidgets('New button opens the create dialog and creates a list',
      (tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('New'));
    await tester.pumpAndSettle();
    expect(find.text('Create Price List'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Wholesale');
    await tester.tap(find.text('Create List'));
    await tester.pumpAndSettle();
    expect(hit('POST', (p) => p == '/prices/lists'), true);
    expect(find.text('Create Price List'), findsNothing);
  });

  testWidgets('inline price edit saves through items/bulk', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.byTooltip('Edit Price'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, '10.00'), '12.50');
    await tester.tap(find.text('Save Price'));
    await tester.pumpAndSettle();
    final req =
        adapter.requests.lastWhere((r) => r.path.endsWith('/items/bulk'));
    expect(((req.data as Map)['items'] as List).first['price'], '12.50');
    expect(find.text('Save Price'), findsNothing);
  });

  testWidgets('edit list details sends PUT', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Details'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Price List'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Retail (default)'), 'Retail 2');
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    expect(hit('PUT', (p) => p == '/prices/lists/l1'), true);
  });

  testWidgets('copy list posts to /copy', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy List'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'New List Name *'), 'Copy of Retail');
    await tester.tap(find.text('Copy Price List'));
    await tester.pumpAndSettle();
    expect(hit('POST', (p) => p == '/prices/lists/l1/copy'), true);
  });

  testWidgets('set as default sends PUT with is_default', (tester) async {
    lists = [
      _list('l1', 'Retail (default)', def: true),
      _list('l2', 'Wholesale'),
    ];
    await pumpPage(tester);
    await tester.tap(find.byType(PopupMenuButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Set as Default'));
    await tester.pumpAndSettle();
    final req = adapter.requests.lastWhere((r) => r.method == 'PUT');
    expect(req.path, '/prices/lists/l2');
    expect((req.data as Map)['is_default'], true);
  });

  testWidgets('bulk adjust previews (dry run) then shows the summary',
      (tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('Bulk % Adjust'));
    await tester.pumpAndSettle();
    expect(find.text('Bulk Price Adjustment'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Percentage (%) *'), '10');
    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();
    final req = adapter.requests.lastWhere((r) => r.path.endsWith('/adjust'));
    expect((req.data as Map)['dry_run'], true);
    expect(find.textContaining('3 items to update'), findsOneWidget);
  });

  testWidgets('CSV import opens and validates (dry run)', (tester) async {
    final dir = Directory.systemTemp.createTempSync('pl_csv');
    addTearDown(() {
      try {
        dir.deleteSync(recursive: true);
      } catch (_) {}
    });
    final f = File('${dir.path}/prices.csv')
      ..writeAsStringSync('sku,price,min_qty\nA,1,1\n');
    if (sl.isRegistered<FileSaverService>()) sl.unregister<FileSaverService>();
    sl.registerSingleton<FileSaverService>(_Files(f.path));
    await pumpPage(tester);
    await tester.tap(find.text('Import CSV'));
    await tester.pumpAndSettle();
    expect(find.text('Import Prices from CSV'), findsOneWidget);
    await tester.tap(find.text('Select CSV File'));
    // Real file IO does not complete inside the fake-async zone.
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
    final req = adapter.requests.lastWhere((r) => r.path.endsWith('/import'));
    expect((req.data as Map)['dry_run'], true);
  });

  testWidgets('list load failure shows an error with Retry', (tester) async {
    await pumpPage(tester,
        handler: (o) => jsonResponse({'detail': 'boom'}, status: 500));
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('offline: banner shown and New is disabled', (tester) async {
    await pumpPage(tester, status: ReachabilityStatus.offline);
    expect(find.textContaining('Offline mode'), findsOneWidget);
    final btn = tester.widget<ElevatedButton>(find.ancestor(
        of: find.text('New'), matching: find.byType(ElevatedButton)));
    expect(btn.onPressed, isNull);
  });
}
