// After the server accepts a product change it is written into the local
// catalog (POS grid, pickers, offline reads), a store event is emitted, and a
// pull is requested. Runs without a backend (the live version is in
// test/live/product_live_test.dart).
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';

import '../helpers/fake_http.dart';
import 'product_save_regression_test.dart' show productResponse;

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Local extends Fake implements ProductsLocalDataSource {
  @override
  Future<void> cacheProducts(List<dynamic> products) async {}
}

class _Probe extends Fake implements ConnectivityProbe {
  @override
  bool get isReachable => true;
}

void main() {
  late AppDatabase db;
  late SyncStore store;
  late LocalCatalog catalog;
  late OfflineProductsRepository repo;
  var pulls = 0;
  var deleted = false;

  setUp(() {
    pulls = 0;
    deleted = false;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = SyncStore(db);
    catalog = LocalCatalog(store, businessId: () async => 'b1');
    final adapter = FakeAdapter((o) {
      if (o.method == 'POST' && o.path.endsWith('/products')) {
        return jsonResponse(productResponse(), status: 201);
      }
      if (o.method == 'PUT' && o.path.endsWith('/products/p1')) {
        return jsonResponse({...productResponse(), 'name': 'Panadol Extra'});
      }
      if (o.method == 'DELETE') {
        deleted = true;
        return jsonResponse({'message': 'ok'});
      }
      return jsonResponse(<String, dynamic>{});
    });
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
    repo = OfflineProductsRepository(
      remoteDataSource: ProductsRemoteDataSourceImpl(_Dio(dio)),
      localDataSource: _Local(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
      catalog: catalog,
      isReachable: () => true,
      afterWrite: () => pulls++,
    );
  });
  tearDown(() async {
    store.dispose();
    await db.close();
  });

  test('create: product, variations, barcodes, category are local at once; event + pull',
      () async {
    var events = 0;
    final sub = catalog.changes.listen((_) => events++);

    final result = await repo.createProduct({'name': 'Panadol'});
    expect(result.isRight(), isTrue, reason: '$result');
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(events, greaterThan(0));
    expect(pulls, 1);
    final p = await catalog.product('p1');
    expect(p, isNotNull);
    expect(p!.name, 'Panadol');
    expect(p.category?.name, 'Painkillers');
    expect(p.baseUnit?.symbol, 'pc');
    expect(p.variations.single.name, 'Strip of 10');
    expect(p.variations.single.barcodes.single.barcode, '6281001');
    expect(p.barcodes.single.barcode, '6281002');
    expect((await catalog.productByBarcode('6281001'))?.id, 'p1');
    expect((await catalog.products(search: 'pana', activeOnly: false)).items, hasLength(1));
  });

  test('update replaces the local copy; delete removes product, variations and barcodes',
      () async {
    await repo.createProduct({'name': 'Panadol'});
    await repo.updateProduct('p1', {'name': 'Panadol Extra'});
    expect((await catalog.product('p1'))!.name, 'Panadol Extra');
    expect(pulls, 2);

    await repo.deleteProduct('p1');
    expect(deleted, isTrue);
    expect(await catalog.product('p1'), isNull);
    expect(await catalog.productByBarcode('6281001'), isNull);
    expect(await store.entities('product_variation'), isEmpty);
    expect(await store.entities('barcode'), isEmpty);
    expect(pulls, 3);
  });

  test('a failed server write changes nothing locally and requests no pull', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = FakeAdapter((o) => jsonResponse({'detail': 'nope'}, status: 400));
    final failing = OfflineProductsRepository(
      remoteDataSource: ProductsRemoteDataSourceImpl(_Dio(dio)),
      localDataSource: _Local(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
      catalog: catalog,
      isReachable: () => true,
      afterWrite: () => pulls++,
    );
    final r = await failing.createProduct({'name': 'x'});
    expect(r.isLeft(), isTrue);
    expect(pulls, 0);
    expect(await store.entities('product'), isEmpty);
  });
}
