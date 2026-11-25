// The import repository over a fake HTTP adapter: multipart fields, timeouts,
// template, failure mapping.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/product_import/data/product_import_remote_datasource.dart';
import 'package:frantend/features/product_import/data/product_import_repository_impl.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';

import '../helpers/fake_http.dart';
import 'import_fakes.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Probe extends Fake implements ConnectivityProbe {
  _Probe(this.reachable);
  bool reachable;
  @override
  bool get isReachable => reachable;
  @override
  Stream<ReachabilityStatus> get status => const Stream.empty();
}

void main() {
  late AppDatabase db;
  late SyncStore store;
  late _Probe probe;
  late FakeAdapter adapter;
  late ProductImportRepositoryImpl repo;
  var syncs = 0;
  FakeHandler handler = (o) => jsonResponse(<String, dynamic>{});

  setUp(() {
    syncs = 0;
    handler = (o) => jsonResponse(<String, dynamic>{});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = SyncStore(db);
    probe = _Probe(true);
    adapter = FakeAdapter((o) => handler(o));
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
    repo = ProductImportRepositoryImpl(
      remote: ProductImportRemoteDataSource(_Dio(dio)),
      catalog: LocalCatalog(store, businessId: () async => 'b1'),
      probe: probe,
      errorHandler: const ErrorHandler(),
      branchId: () => 'branch-1',
      syncNow: () async => syncs++,
    );
  });

  tearDown(() async {
    store.dispose();
    await db.close();
  });

  ResponseBody detail(int status, Map<String, dynamic> d) => jsonResponse({'detail': d}, status: status);

  test('the upload is multipart with every option as a field', () async {
    handler = (o) => jsonResponse({
          'dry_run': true,
          'summary': {'total_rows': 1, 'create': 1},
        });
    final r = await repo.run(
      csvFile('name,price\nA,1\n', name: 'shop.csv'),
      const ImportOptions(
        onError: ImportOnError.skip,
        unitMap: {'pkt': 'u1'},
        categoryMap: {'Food': 'c1'},
        branchId: 'branch-1',
      ),
      dryRun: true,
    );
    expect(r.isRight(), isTrue);
    final req = adapter.requests.single;
    expect(req.path, '/products/import/upload');
    expect(req.method, 'POST');
    final form = req.data as FormData;
    final fields = {for (final f in form.fields) f.key: f.value};
    expect(fields['dry_run'], 'true');
    expect(fields['on_error'], 'skip');
    expect(fields['create_missing_units'], 'true');
    expect(fields['create_missing_categories'], 'true');
    expect(jsonDecode(fields['unit_map']!), {'pkt': 'u1'});
    expect(jsonDecode(fields['category_map']!), {'Food': 'c1'});
    expect(fields['branch_id'], 'branch-1');
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.filename, 'shop.csv');
    expect(req.sendTimeout, const Duration(seconds: 180));
    expect(req.extra['no_retry'], true);
  });

  test('an Excel file is sent with the Excel content type', () async {
    handler = (o) => jsonResponse({'summary': {}});
    await repo.run(
      ImportFile(name: 'a.xlsx', bytes: Uint8List.fromList([1, 2, 3]), kind: ImportFileKind.xlsx),
      const ImportOptions(),
      dryRun: false,
    );
    final form = adapter.requests.single.data as FormData;
    expect(form.files.single.value.contentType.toString(), contains('spreadsheetml'));
    expect({for (final f in form.fields) f.key: f.value}['dry_run'], 'false');
  });

  test('422 import_has_errors carries the report', () async {
    handler = (o) => detail(422, {
          'code': 'import_has_errors',
          'message': 'Some rows have problems.',
          'report': {
            'summary': {'errors': 2},
            'groups': [
              {'code': 'price_missing', 'message': 'Price is missing', 'rows_count': 2},
            ],
          },
        });
    final r = await repo.run(csvFile('x'), const ImportOptions(), dryRun: false);
    final f = r.swap().getOrElse(() => throw StateError('expected failure')) as ImportBlockedFailure;
    expect(f.report!.summary.errors, 2);
    expect(f.report!.groups.single.message, 'Price is missing');
  });

  test('413 and 415 are explained in plain words', () async {
    handler = (o) => jsonResponse({'detail': 'too big'}, status: 413);
    var f = (await repo.run(csvFile('x'), const ImportOptions(), dryRun: true)).swap().getOrElse(() => throw StateError(''));
    expect(f, isA<ImportFileFailure>());
    expect(f.message, contains('too big'));

    handler = (o) => jsonResponse({'detail': 'unsupported'}, status: 415);
    f = (await repo.run(csvFile('x'), const ImportOptions(), dryRun: true)).swap().getOrElse(() => throw StateError(''));
    expect(f.message, contains('.xls'));
    expect(f.message, contains('Save As'));
  });

  test('undo 409 codes become UndoRefusedFailure with the blocking products', () async {
    handler = (o) => detail(409, {
          'code': 'undo_blocked',
          'message': 'Some products were used',
          'products': [
            {'name': 'Rice', 'reasons': ['sale']},
          ],
        });
    final f = (await repo.undo('b1')).swap().getOrElse(() => throw StateError('')) as UndoRefusedFailure;
    expect(f.code, 'undo_blocked');
    expect(f.blocked.single.name, 'Rice');
    expect(adapter.requests.single.path, '/products/import/b1/undo');
    expect(adapter.requests.single.extra['no_retry'], true);
  });

  test('undo success reads the counts', () async {
    handler = (o) => jsonResponse({'products_removed': 24, 'products_restored': 1});
    final r = (await repo.undo('b1')).getOrElse(() => const UndoResult());
    expect(r.productsRemoved, 24);
    expect(r.productsRestored, 1);
  });

  test('batches are listed', () async {
    handler = (o) => jsonResponse([
          {'id': 'b1', 'filename': 'a.csv', 'status': 'active', 'created_count': 3, 'can_undo': true},
          {'id': 'b2', 'filename': 'b.xlsx', 'status': 'undone', 'created_count': 1, 'can_undo': false},
        ]);
    final list = (await repo.batches()).getOrElse(() => const []);
    expect(list.map((b) => b.id), ['b1', 'b2']);
    expect(list.last.status, ImportBatchStatus.undone);
  });

  test('the template asks for the chosen format and reads the file name', () async {
    handler = (o) => ResponseBody.fromBytes(
          utf8.encode('name,price\n'),
          200,
          headers: {
            'content-disposition': ['attachment; filename="my_shop_template.csv"'],
            Headers.contentTypeHeader: ['text/csv'],
          },
        );
    final t = (await repo.template(ImportFileKind.csv)).getOrElse(() => throw StateError(''));
    expect(adapter.requests.single.queryParameters['format'], 'csv');
    expect(t.fileName, 'my_shop_template.csv');
    expect(t.bytes, isNotEmpty);
  });

  test('refreshCatalog pulls from the server and never throws', () async {
    await repo.refreshCatalog();
    expect(syncs, 1);
  });

  test('offline is reported', () async {
    probe.reachable = false;
    expect(repo.isOnline, isFalse);
    expect(repo.branchId, 'branch-1');
  });
}
