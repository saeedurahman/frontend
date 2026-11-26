// "Export account" against a REAL backend (its TEST database): the app's real
// supplier account screen, its real button and dialog, the real download.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/export_live_test.dart
//
// Two suppliers have their own rows. The file for one of them must hold that
// supplier's rows and nothing of the other.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Only the test reads the .xlsx; the package comes with the PDF libraries.
// ignore: depend_on_referenced_packages
import 'package:archive/archive.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/supplier_ledger_page.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:intl/intl.dart';

import '../helpers/khata_fakes.dart';
import '../phase5/export_service_test.dart' show FakeFileSaverService;
import '../refresh/refresh_fixtures.dart';
import 'live_backend.dart';

class _NoProducts extends Fake implements GetProductByIdUseCase {}

const _alpha = 'Alpha Traders Live';
const _beta = 'Beta Foods Live';

void main() {
  if (liveSkip != false) {
    test('live export test', () {}, skip: liveSkip);
    return;
  }

  TestWidgetsFlutterBinding.ensureInitialized();
  // The screen listens for a branch switch; none happens here.
  useActiveBranch();

  late LiveTenant tenant;
  late String alphaId;

  setUpAll(() async {
    // The test binding answers every request with 400 unless this is cleared.
    HttpOverrides.global = null;
    tenant = await LiveTenant.register(liveApiBase()!, label: 'Export Live');
    final suppliers = SuppliersRepositoryImpl(
      remoteDataSource: SuppliersRemoteDataSourceImpl(tenant.client),
      errorHandler: const ErrorHandler(),
    );
    final purchases = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(tenant.client),
      errorHandler: const ErrorHandler(),
      lineEnricher: PurchaseOrderLineEnricher(_NoProducts()),
    );
    final productId = (await tenant.post('/products', {
      'name': 'Rice ${DateTime.now().millisecondsSinceEpoch}',
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': 'none',
    }))['id'] as String;

    /// A supplier with goods received on credit and one bank payment.
    Future<String> supplier(
      String name,
      String phone, {
      required int cost,
      required String paid,
      required String reference,
    }) async {
      final id = (await tenant.post('/suppliers', {
        'name': name,
        'phone': phone,
      }))['id'] as String;
      final receipt = await CreatePurchaseReceiptUseCase(purchases)(
        CreatePurchaseReceiptParams(
          branchId: tenant.branchId,
          supplierId: id,
          receivedAt: DateTime.now(),
          lines: [
            CreatePurchaseReceiptLineParams(
              productId: productId,
              qtyReceived: Decimal.fromInt(10),
              costPerUnit: Decimal.fromInt(cost),
            ),
          ],
        ),
      );
      receipt.fold((f) => fail('receipt failed: ${f.message}'), (_) {});
      final payment = await PaySupplierUseCase(suppliers)({
        'supplier_id': id,
        'amount': paid,
        'payment_source': 'bank',
        'reference_no': reference,
        'branch_id': tenant.branchId,
      });
      payment.fold((f) => fail('payment failed: ${f.message}'), (_) {});
      return id;
    }

    alphaId = await supplier(
      _alpha,
      '3015550001',
      cost: 137,
      paid: '111.00',
      reference: 'ALPHA-TX',
    );
    await supplier(
      _beta,
      '3015550002',
      cost: 291,
      paid: '222.00',
      reference: 'BETA-TX',
    );
  });

  for (final (choice, format) in const [
    ('CSV Document (.csv)', 'csv'),
    ('Excel Spreadsheet (.xlsx)', 'xlsx'),
    ('PDF Document (.pdf)', 'pdf'),
  ]) {
    testWidgets('"Export account" ($format) holds that supplier only',
        (tester) async {
      final previous = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.exceptionAsString().contains('overflowed')) return;
        previous?.call(d);
      };
      addTearDown(() => FlutterError.onError = previous);
      tester.view.physicalSize = const Size(2000, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // A client of its own, so its sockets belong to this test.
      final dio = Dio(BaseOptions(
        baseUrl: tenant.base,
        headers: {'Authorization': 'Bearer ${tenant.token}'},
      ));
      final requests = <Uri>[];
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options.uri);
          handler.next(options);
        },
      ));
      final files = FakeFileSaverService();
      final suppliers = SuppliersRepositoryImpl(
        remoteDataSource: SuppliersRemoteDataSourceImpl(LiveDio(dio)),
        errorHandler: const ErrorHandler(),
      );
      sl.registerSingleton<DioClient>(LiveDio(dio));
      sl.registerSingleton<FileSaverService>(files);
      sl.registerFactory(
        () => SupplierLedgerCubit(
          GetSupplierUseCase(suppliers),
          GetSupplierLedgerUseCase(suppliers),
          ReverseSupplierPaymentUseCase(suppliers),
          FakeBranchResolver(tenant.branchId),
          KhataEvents(),
        ),
      );
      addTearDown(() {
        sl.unregister<DioClient>();
        sl.unregister<FileSaverService>();
        sl.unregister<SupplierLedgerCubit>();
      });

      /// Lets the real network answer, then draws what came of it.
      Future<void> waitFor(bool Function() done) async {
        for (var i = 0; i < 300 && !done(); i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 30)),
          );
          await tester.pump(const Duration(milliseconds: 20));
        }
        expect(done(), isTrue, reason: 'no answer from the server');
        await tester.pump(const Duration(milliseconds: 400));
      }

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SupplierLedgerPage(supplierId: alphaId))),
      );
      await waitFor(() => find.text('Goods received').evaluate().isNotEmpty);
      expect(find.text(_alpha), findsOneWidget);
      expect(find.text('Payment made'), findsOneWidget);
      expect(find.textContaining('1,259'), findsWidgets);

      await tester.tap(find.byKey(const ValueKey('export_supplier_ledger')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text(choice));
      await tester.pump();
      await tester.tap(find.text('Export Now'));
      await waitFor(() => files.lastSavedBytes != null);

      final request = requests.singleWhere((u) => u.path.contains('/export/'));
      expect(request.path, endsWith('/export/supplier_ledger'));
      expect(request.queryParameters, {
        'format': format,
        'supplier_id': alphaId,
        'branch_id': tenant.branchId,
        'date_from': '2000-01-01',
      });
      expect(
        files.lastSavedName,
        '$_alpha ledger ${DateFormat('yyyy-MM-dd').format(DateTime.now())}.$format',
      );

      final bytes = files.lastSavedBytes!;
      switch (format) {
        case 'csv':
          final csv = utf8.decode(bytes, allowMalformed: true);
          // ignore: avoid_print
          print('\n----- ${files.lastSavedName} -----\n$csv-----');
          _expectOnlyAlpha(csv);
          final rows = const LineSplitter().convert(csv);
          expect(rows.where((r) => r.contains('Goods received')), hasLength(1));
          expect(rows.where((r) => r.contains('ALPHA-TX')), hasLength(1));
          expect(csv, contains('1370.00'));
          expect(csv, contains('111.00'));
          expect(csv, contains('1259.00'));
          // Beta's goods, payment and balance.
          for (final amount in ['2910.00', '222.00', '2688.00']) {
            expect(csv, isNot(contains(amount)));
          }
        case 'xlsx':
          expect(bytes.sublist(0, 2), utf8.encode('PK'));
          _expectOnlyAlpha(_sheetText(bytes));
        case 'pdf':
          expect(bytes.sublist(0, 4), utf8.encode('%PDF'));
      }

      // Let the snack bar and the idle connection finish.
      await tester.pumpWidget(const SizedBox());
      dio.close(force: true);
      await tester.pump(const Duration(seconds: 20));
    });
  }
}

void _expectOnlyAlpha(String text) {
  expect(text, contains(_alpha));
  expect(text, contains('ALPHA-TX'));
  for (final other in [_beta, 'BETA-TX']) {
    expect(text, isNot(contains(other)), reason: 'a row of the other supplier');
  }
}

/// Every piece of text and every number inside an .xlsx workbook.
String _sheetText(Uint8List bytes) {
  final book = ZipDecoder().decodeBytes(bytes);
  return [
    for (final file in book.files)
      if (file.name.startsWith('xl/worksheets/') ||
          file.name == 'xl/sharedStrings.xml')
        utf8.decode(file.content as List<int>, allowMalformed: true),
  ].join('\n');
}
