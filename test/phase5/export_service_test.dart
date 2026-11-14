import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/services/export_service.dart';

import '../helpers/fake_http.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class FakeFileSaverService implements FileSaverService {
  String? lastSavedName;
  Uint8List? lastSavedBytes;
  List<String>? lastExtensions;
  String? openedFolder;

  @override
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  }) async {
    lastSavedName = suggestedName;
    lastSavedBytes = bytes;
    lastExtensions = extensions;
    return 'C:\\Users\\User\\Downloads\\$suggestedName';
  }

  @override
  Future<String> saveBytes(String fileName, Uint8List bytes) async {
    lastSavedName = fileName;
    lastSavedBytes = bytes;
    return 'C:\\Users\\User\\Downloads\\$fileName';
  }

  @override
  Future<String?> pickFile({List<String> extensions = const [], String? label}) async => null;

  @override
  File readFile(String path) => File(path);

  @override
  Future<void> openFolder(String filePath) async {
    openedFolder = filePath;
  }
}

void main() {
  late Dio dio;
  late FakeAdapter adapter;
  late FakeFileSaverService fileSaver;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    fileSaver = FakeFileSaverService();

    if (sl.isRegistered<DioClient>()) sl.unregister<DioClient>();
    sl.registerSingleton<DioClient>(_Dio(dio));

    if (sl.isRegistered<FileSaverService>()) sl.unregister<FileSaverService>();
    sl.registerSingleton<FileSaverService>(fileSaver);
  });

  tearDown(() {
    if (sl.isRegistered<DioClient>()) sl.unregister<DioClient>();
    if (sl.isRegistered<FileSaverService>()) sl.unregister<FileSaverService>();
  });

  testWidgets('Export saves bytes through FileSaverService and sets 60s timeout', (tester) async {
    final sampleBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
    RequestOptions? capturedOptions;

    adapter = FakeAdapter((options) {
      capturedOptions = options;
      if (options.path == ApiConstants.exportDataset('sales')) {
        return ResponseBody.fromBytes(
          sampleBytes,
          200,
          headers: {
            Headers.contentTypeHeader: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
          },
        );
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => ExportService.runExport(
                context: context,
                dataset: 'sales',
                format: 'xlsx',
                dateFrom: DateTime(2026, 6, 1),
                dateTo: DateTime(2026, 6, 30),
              ),
              child: const Text('Export Sales'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Export Sales'));
    await tester.pump(); // show loading dialog
    await tester.pumpAndSettle(); // finish async operation

    expect(capturedOptions, isNotNull);
    expect(capturedOptions!.path, '/export/sales');
    expect(capturedOptions!.queryParameters['format'], 'xlsx');
    expect(capturedOptions!.queryParameters['date_from'], '2026-06-01');
    expect(capturedOptions!.queryParameters['date_to'], '2026-06-30');
    expect(capturedOptions!.receiveTimeout, const Duration(seconds: 60));
    expect(capturedOptions!.responseType, ResponseType.bytes);

    expect(fileSaver.lastSavedBytes, equals(sampleBytes));
    expect(fileSaver.lastSavedName, contains('sales_20260630.xlsx'));
    expect(find.textContaining('Export saved:'), findsOneWidget);
  });

  testWidgets('Export 413 displays plain language error message', (tester) async {
    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.exportDataset('inventory')) {
        return jsonResponse(
          {'detail': 'Export too large: more than 50000 rows. Narrow the date range or pick a branch and try again.'},
          status: 413,
        );
      }
      return jsonResponse({}, status: 404);
    });
    dio.httpClientAdapter = adapter;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => ExportService.runExport(
                context: context,
                dataset: 'inventory',
                format: 'csv',
              ),
              child: const Text('Export Inventory'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Export Inventory'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Export too large: more than 50,000 rows'), findsOneWidget);
    expect(fileSaver.lastSavedBytes, isNull);
  });
}
