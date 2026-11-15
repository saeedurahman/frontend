// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:frantend/core/platform/file_saver_service.dart';

void main() {
  test('Live Backend Export Test for Sales (CSV, XLSX, PDF) and other datasets', () async {
    final authFile = File('D:/flutter/sas/backend/test_export_auth.json');
    if (!authFile.existsSync()) {
      fail('test_export_auth.json does not exist. Run setup_test_business.py first.');
    }
    final authData = jsonDecode(authFile.readAsStringSync()) as Map<String, dynamic>;
    final baseUrl = authData['base_url'] as String;
    final token = authData['token'] as String;
    final branchId = authData['branch_id'] as String;
    final saleNumbers = List<String>.from(authData['sale_numbers'] as List);

    expect(saleNumbers.length, equals(6));

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final fileSaver = const WindowsFileSaverService();
    final tempDir = await Directory.systemTemp.createTemp('export_live_test_');

    const formats = ['csv', 'xlsx', 'pdf'];
    final timings = <String, int>{};

    for (final fmt in formats) {
      final sw = Stopwatch()..start();
      final res = await dio.get<List<int>>(
        '/export/sales',
        queryParameters: {
          'format': fmt,
          'branch_id': branchId,
        },
        options: Options(responseType: ResponseType.bytes),
      );
      sw.stop();
      timings['sales_$fmt'] = sw.elapsedMilliseconds;

      expect(res.statusCode, equals(200));
      final bytes = Uint8List.fromList(res.data!);
      expect(bytes.isNotEmpty, isTrue);

      final contentType = res.headers.value('content-type') ?? '';
      if (fmt == 'csv') {
        expect(contentType, contains('csv'));
      } else if (fmt == 'xlsx') {
        expect(contentType, anyOf(contains('openxmlformats'), contains('spreadsheetml')));
      } else if (fmt == 'pdf') {
        expect(contentType, contains('pdf'));
      }

      final targetPath = p.join(tempDir.path, 'sales_export_test.$fmt');
      final savedPath = await fileSaver.saveBytesToPath(targetPath, bytes);

      final savedFile = File(savedPath);
      expect(savedFile.existsSync(), isTrue);
      expect(savedFile.lengthSync(), equals(bytes.length));
      expect(savedFile.lengthSync(), greaterThan(0));

      if (fmt == 'csv') {
        final csvContent = utf8.decode(bytes);
        for (final saleNum in saleNumbers) {
          expect(csvContent, contains(saleNum));
        }
      } else if (fmt == 'xlsx') {
        // ZIP/OpenXML magic number 'PK' (0x50, 0x4B)
        expect(bytes[0], equals(0x50));
        expect(bytes[1], equals(0x4B));
      } else if (fmt == 'pdf') {
        // PDF magic number '%PDF' (0x25, 0x50, 0x44, 0x46)
        expect(bytes[0], equals(0x25));
        expect(bytes[1], equals(0x50));
        expect(bytes[2], equals(0x44));
        expect(bytes[3], equals(0x46));
      }
    }

    // Also confirm at least 3 other datasets: customers, expenses, inventory
    const otherDatasets = ['customers', 'expenses', 'inventory'];
    for (final dataset in otherDatasets) {
      for (final fmt in formats) {
        final sw = Stopwatch()..start();
        final res = await dio.get<List<int>>(
          '/export/$dataset',
          queryParameters: {
            'format': fmt,
            'branch_id': branchId,
          },
          options: Options(responseType: ResponseType.bytes),
        );
        sw.stop();
        timings['${dataset}_$fmt'] = sw.elapsedMilliseconds;

        expect(res.statusCode, equals(200));
        final bytes = Uint8List.fromList(res.data!);
        expect(bytes.isNotEmpty, isTrue);

        final targetPath = p.join(tempDir.path, '${dataset}_export_test.$fmt');
        final savedPath = await fileSaver.saveBytesToPath(targetPath, bytes);

        final savedFile = File(savedPath);
        expect(savedFile.existsSync(), isTrue);
        expect(savedFile.lengthSync(), greaterThan(0));

        if (fmt == 'csv') {
          final text = utf8.decode(bytes);
          expect(text.isNotEmpty, isTrue);
        } else if (fmt == 'xlsx') {
          expect(bytes[0], equals(0x50));
          expect(bytes[1], equals(0x4B));
        } else if (fmt == 'pdf') {
          expect(bytes[0], equals(0x25));
          expect(bytes[1], equals(0x50));
          expect(bytes[2], equals(0x44));
          expect(bytes[3], equals(0x46));
        }
      }
    }

    print('\n================ EXPORT TIMINGS REPORT ================');
    print('Sales 6 rows:');
    print('  - CSV:   ${timings['sales_csv']} ms');
    print('  - XLSX:  ${timings['sales_xlsx']} ms');
    print('  - PDF:   ${timings['sales_pdf']} ms');
    print('Other datasets (CSV / XLSX / PDF):');
    for (final dataset in otherDatasets) {
      print('  - $dataset: CSV=${timings['${dataset}_csv']} ms, XLSX=${timings['${dataset}_xlsx']} ms, PDF=${timings['${dataset}_pdf']} ms');
    }
    print('=======================================================\n');

    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });
}
