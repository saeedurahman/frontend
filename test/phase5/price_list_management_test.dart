import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';

import '../helpers/fake_http.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Local extends Fake implements ProductsLocalDataSource {}
class _Probe extends Fake implements ConnectivityProbe {
  @override
  Future<ReachabilityStatus> check() async => ReachabilityStatus.online;
  @override
  ReachabilityStatus get current => ReachabilityStatus.online;
  @override
  bool get isReachable => true;
}

void main() {
  late Dio dio;
  late FakeAdapter adapter;
  late ProductsRemoteDataSource remote;
  late ProductsRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    remote = ProductsRemoteDataSourceImpl(_Dio(dio));
    repo = ProductsRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: _Local(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
    );
  });

  test('Price list CRUD: lists, get, create, update, delete', () async {
    final listsData = [
      {
        'id': 'l1',
        'business_id': 'b1',
        'name': 'Retail Default',
        'list_type': 'retail',
        'is_default': true,
        'is_active': true,
        'item_count': 15,
        'customer_count': 50,
      },
      {
        'id': 'l2',
        'business_id': 'b1',
        'name': 'Wholesale Gold',
        'list_type': 'wholesale',
        'is_default': false,
        'is_active': true,
        'item_count': 20,
        'customer_count': 5,
      },
    ];

    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.priceLists && options.method == 'GET') {
        return jsonResponse(listsData);
      }
      if (options.path == ApiConstants.priceListById('l1') && options.method == 'GET') {
        return jsonResponse(listsData[0]);
      }
      if (options.path == ApiConstants.priceLists && options.method == 'POST') {
        final body = options.data as Map;
        return jsonResponse({
          'id': 'l3',
          'business_id': 'b1',
          'name': body['name'],
          'list_type': body['list_type'],
          'is_default': false,
          'is_active': true,
          'item_count': 0,
          'customer_count': 0,
        }, status: 201);
      }
      if (options.path == ApiConstants.priceListById('l2') && options.method == 'PUT') {
        final body = options.data as Map;
        return jsonResponse({
          ...listsData[1],
          'name': body['name'] ?? listsData[1]['name'],
          'is_default': body['is_default'] ?? listsData[1]['is_default'],
        });
      }
      if (options.path == ApiConstants.priceListById('l2') && options.method == 'DELETE') {
        return jsonResponse({'deleted': true, 'customers_unassigned': 5});
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    // 1. List
    final listsResult = await repo.getPriceLists();
    expect(listsResult.isRight(), true);
    final lists = listsResult.getOrElse(() => []);
    expect(lists.length, 2);
    expect(lists[0].name, 'Retail Default');
    expect(lists[0].itemCount, 15);
    expect(lists[0].customerCount, 50);

    // 2. Get single list
    final singleResult = await repo.getPriceList('l1');
    expect(singleResult.isRight(), true);
    expect(singleResult.getOrElse(() => throw '').id, 'l1');

    // 3. Create
    final createResult = await repo.createPriceList({'name': 'Festive Sale', 'list_type': 'custom'});
    expect(createResult.isRight(), true);
    final created = createResult.getOrElse(() => throw '');
    expect(created.id, 'l3');
    expect(created.name, 'Festive Sale');

    // 4. Update
    final updateResult = await repo.updatePriceList('l2', {'name': 'Wholesale Platinum'});
    expect(updateResult.isRight(), true);
    expect(updateResult.getOrElse(() => throw '').name, 'Wholesale Platinum');

    // 5. Delete (returns customers_unassigned)
    final delResult = await repo.deletePriceList('l2');
    expect(delResult.isRight(), true);
    final delData = delResult.getOrElse(() => {});
    expect(delData['deleted'], true);
    expect(delData['customers_unassigned'], 5);
  });

  test('Bulk upsert price items via POST /prices/lists/{id}/items/bulk', () async {
    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.priceListItemsBulk('l1') && options.method == 'POST') {
        final body = options.data as Map;
        final items = body['items'] as List;
        return jsonResponse({
          'created': 1,
          'updated': 1,
          'unchanged': 0,
          'total': items.length,
        });
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    final result = await repo.bulkUpsertPriceItems('l1', [
      {'product_id': 'p1', 'variation_id': null, 'price': '150.00', 'min_qty': '1'},
      {'product_id': 'p1', 'variation_id': null, 'price': '135.00', 'min_qty': '10'},
    ]);

    expect(result.isRight(), true);
    final bulk = result.getOrElse(() => throw '');
    expect(bulk.created, 1);
    expect(bulk.updated, 1);
    expect(bulk.total, 2);
  });

  test('Adjust prices preview dry_run and apply', () async {
    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.priceListAdjust('l1') && options.method == 'POST') {
        final body = options.data as Map;
        final isDryRun = body['dry_run'] == true;
        return jsonResponse({
          'dry_run': isDryRun,
          'updated': 12,
          'unchanged': 3,
          'sample': [
            {
              'item_id': 'item-101',
              'product_id': 'prod-1',
              'old_price': '100.00',
              'new_price': '110.00',
            },
          ],
        });
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    // Dry-run preview
    final previewResult = await repo.adjustPriceList('l1', {
      'percent': '10',
      'dry_run': true,
    });
    expect(previewResult.isRight(), true);
    final preview = previewResult.getOrElse(() => throw '');
    expect(preview.dryRun, true);
    expect(preview.updated, 12);
    expect(preview.sample.length, 1);
    expect(preview.sample[0].oldPrice, '100.00');
    expect(preview.sample[0].newPrice, '110.00');

    // Apply
    final applyResult = await repo.adjustPriceList('l1', {
      'percent': '10',
      'dry_run': false,
    });
    expect(applyResult.isRight(), true);
    expect(applyResult.getOrElse(() => throw '').dryRun, false);
  });

  test('Copy price list POST /prices/lists/{id}/copy', () async {
    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.priceListCopy('l1') && options.method == 'POST') {
        final body = options.data as Map;
        return jsonResponse({
          'id': 'l-copied',
          'business_id': 'b1',
          'name': body['name'],
          'list_type': 'retail',
          'is_default': false,
          'is_active': true,
          'item_count': 15,
          'customer_count': 0,
        }, status: 201);
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    final copyResult = await repo.copyPriceList('l1', {
      'name': 'Retail VIP',
      'percent': '-5',
    });
    expect(copyResult.isRight(), true);
    expect(copyResult.getOrElse(() => throw '').name, 'Retail VIP');
  });

  test('CSV import dry-run preview and apply with row error reporting', () async {
    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.priceListImport('l1') && options.method == 'POST') {
        final body = options.data as Map;
        final dryRun = body['dry_run'] == true;
        return jsonResponse({
          'dry_run': dryRun,
          'summary': {
            'total_rows': 3,
            'create': 2,
            'update': 0,
            'unchanged': 0,
            'errors': 1,
            'applied': !dryRun,
          },
          'unknown_columns': [],
          'rows': [
            {'row_index': 1, 'status': 'create', 'sku': 'SKU-1'},
            {'row_index': 2, 'status': 'create', 'sku': 'SKU-2'},
            {'row_index': 3, 'status': 'error', 'sku': 'UNKNOWN', 'errors': 'SKU not found'},
          ],
        });
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    final importResult = await repo.importPriceListCsv('l1', {
      'csv': 'sku,price,min_qty\nSKU-1,100,1\nSKU-2,200,1\nUNKNOWN,300,1',
      'dry_run': true,
      'on_error': 'skip',
    });

    expect(importResult.isRight(), true);
    final report = importResult.getOrElse(() => {});
    expect(report['summary']['errors'], 1);
    expect(report['rows'].length, 3);
  });
}
