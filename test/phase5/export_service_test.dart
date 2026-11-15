import 'dart:async';
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
import 'package:frantend/shared/widgets/dialogs/export_dialog.dart';

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
  String? lastSavedPath;
  String? openedFolder;
  String? openedFile;
  bool cancelSavePath = false;

  @override
  Future<String?> chooseSavePath(
    String suggestedName, {
    List<String> extensions = const [],
  }) async {
    lastSavedName = suggestedName;
    lastExtensions = extensions;
    if (cancelSavePath) return null;
    lastSavedPath = 'C:\\Users\\User\\Downloads\\$suggestedName';
    return lastSavedPath;
  }

  @override
  Future<String> saveBytesToPath(String path, Uint8List bytes) async {
    lastSavedPath = path;
    lastSavedBytes = bytes;
    return path;
  }

  @override
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  }) async {
    final path = await chooseSavePath(suggestedName, extensions: extensions);
    if (path == null) return null;
    return saveBytesToPath(path, bytes);
  }

  @override
  Future<String> saveBytes(String fileName, Uint8List bytes) async {
    lastSavedName = fileName;
    lastSavedBytes = bytes;
    lastSavedPath = 'C:\\Users\\User\\Downloads\\$fileName';
    return lastSavedPath!;
  }

  @override
  Future<String?> pickFile({List<String> extensions = const [], String? label}) async => null;

  @override
  File readFile(String path) => File(path);

  @override
  Future<void> openFile(String filePath) async {
    openedFile = filePath;
  }

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
    await tester.pump();
    await tester.pumpAndSettle();

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
    expect(find.text('Open file'), findsOneWidget);
    expect(find.text('Open folder'), findsOneWidget);

    await tester.tap(find.text('Open file'));
    expect(fileSaver.openedFile, isNotNull);
    await tester.tap(find.text('Open folder'));
    expect(fileSaver.openedFolder, isNotNull);
  });

  testWidgets('Export PDF format uses GET /export/{dataset}?format=pdf', (tester) async {
    final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]); // %PDF
    RequestOptions? capturedOptions;

    adapter = FakeAdapter((options) {
      capturedOptions = options;
      if (options.path == ApiConstants.exportDataset('customers')) {
        return ResponseBody.fromBytes(
          pdfBytes,
          200,
          headers: {
            Headers.contentTypeHeader: ['application/pdf'],
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
                dataset: 'customers',
                format: 'pdf',
              ),
              child: const Text('Export Customers PDF'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Export Customers PDF'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(capturedOptions, isNotNull);
    expect(capturedOptions!.path, '/export/customers');
    expect(capturedOptions!.queryParameters['format'], 'pdf');
    expect(fileSaver.lastSavedBytes, equals(pdfBytes));
    expect(fileSaver.lastSavedName, contains('.pdf'));
  });

  testWidgets('Export can be cancelled mid-way via Cancel button', (tester) async {
    final completer = Completer<ResponseBody>();
    adapter = FakeAdapter((options) async {
      return completer.future;
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
              ),
              child: const Text('Export Hanging Sales'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Export Hanging Sales'));
    await tester.pump();

    // Verify progress dialog is shown with Cancel button
    expect(find.text('Exporting SALES (xlsx)'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify dialog dismissed and "Export cancelled" snackbar shown
    expect(find.text('Exporting SALES (xlsx)'), findsNothing);
    expect(find.text('Export cancelled'), findsOneWidget);
    expect(fileSaver.lastSavedBytes, isNull);
  });

  testWidgets('Export 413 displays plain language error message with PDF guidance', (tester) async {
    adapter = FakeAdapter((options) {
      if (options.path == ApiConstants.exportDataset('sales')) {
        return jsonResponse(
          {'detail': 'PDF export is limited to 2,000 rows. Please choose Excel / CSV format.'},
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
                dataset: 'sales',
                format: 'pdf',
              ),
              child: const Text('Export Sales PDF'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Export Sales PDF'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('PDF export is limited to 2,000 rows'), findsOneWidget);
    expect(fileSaver.lastSavedBytes, isNull);
  });

  testWidgets('ExportDialog displays all 3 formats (Excel, CSV, PDF) and triggers export', (tester) async {
    adapter = FakeAdapter((options) {
      return ResponseBody.fromBytes(Uint8List.fromList([1, 2, 3]), 200);
    });
    dio.httpClientAdapter = adapter;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => ExportDialog.show(
                context,
                dataset: 'inventory',
                title: 'Inventory Stock',
              ),
              child: const Text('Open Export Dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Export Dialog'));
    await tester.pumpAndSettle();

    // Verify all 3 options exist
    expect(find.text('Excel Spreadsheet (.xlsx)'), findsOneWidget);
    expect(find.text('CSV Document (.csv)'), findsOneWidget);
    expect(find.text('PDF Document (.pdf)'), findsOneWidget);

    // Select PDF option
    await tester.tap(find.text('PDF Document (.pdf)'));
    await tester.pumpAndSettle();

    // Click Export Now
    await tester.tap(find.text('Export Now'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(fileSaver.lastSavedName, contains('inventory_'));
    expect(fileSaver.lastSavedName, endsWith('.pdf'));
  });
}
