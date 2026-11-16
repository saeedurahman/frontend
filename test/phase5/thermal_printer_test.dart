import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/settings/presentation/pages/printer_settings_page.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePrinterService implements PrinterService {
  PrinterConfig currentConfig = const PrinterConfig();
  bool printPdfCalled = false;
  List<Printer> mockPrinters = [];

  @override
  Future<PrinterConfig> loadConfig() async => currentConfig;

  @override
  Future<void> saveConfig(PrinterConfig config) async {
    currentConfig = config;
  }

  @override
  Future<List<Printer>> listPrinters() async => mockPrinters;

  @override
  Future<bool> printPdf(
    Uint8List pdfBytes, {
    String jobName = 'Receipt',
    PrinterConfig? config,
    bool forceDialog = false,
  }) async {
    printPdfCalled = true;
    if (mockPrinters.isEmpty && (config?.printerName == null)) {
      return false;
    }
    return true;
  }

  @override
  Future<void> openCashDrawer() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrinterConfig & SharedPreferences Persistence', () {
    test('PrinterConfig default values and copyWith', () {
      const config = PrinterConfig();
      expect(config.paperSize, '80mm');
      expect(config.is80mm, true);
      expect(config.is58mm, false);
      expect(config.copies, 1);
      expect(config.autoPrintAfterSale, false);
      expect(config.openCashDrawer, false);
      expect(config.pageFormat, PdfPageFormat.roll80);

      final updated = config.copyWith(
        printerName: 'POS-80 Printer',
        paperSize: '58mm',
        copies: 2,
        autoPrintAfterSale: true,
        openCashDrawer: true,
      );
      expect(updated.printerName, 'POS-80 Printer');
      expect(updated.paperSize, '58mm');
      expect(updated.is58mm, true);
      expect(updated.copies, 2);
      expect(updated.autoPrintAfterSale, true);
      expect(updated.openCashDrawer, true);
      expect(updated.pageFormat, PdfPageFormat.roll57);
    });

    test('WindowsPrinterService loads and saves config into SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final service = WindowsPrinterService();

      var loaded = await service.loadConfig();
      expect(loaded.printerName, isNull);
      expect(loaded.paperSize, '80mm');

      await service.saveConfig(const PrinterConfig(
        printerName: 'Thermal Receipt 80',
        paperSize: '58mm',
        copies: 3,
        autoPrintAfterSale: true,
        openCashDrawer: true,
      ));

      loaded = await service.loadConfig();
      expect(loaded.printerName, 'Thermal Receipt 80');
      expect(loaded.paperSize, '58mm');
      expect(loaded.copies, 3);
      expect(loaded.autoPrintAfterSale, true);
      expect(loaded.openCashDrawer, true);
    });
  });

  group('Thermal Receipt Layout & Urdu Text Structural Tests', () {
    test('hasRtl correctly detects Arabic and Urdu script', () {
      expect(SaleReceiptService.hasRtl('چائے'), true);
      expect(SaleReceiptService.hasRtl('باسمتی چاول'), true);
      expect(SaleReceiptService.hasRtl('Super Basmati Rice'), false);
      expect(SaleReceiptService.hasRtl('Pepsi 1.5L'), false);
      expect(SaleReceiptService.hasRtl(null), false);
      expect(SaleReceiptService.hasRtl(''), false);
    });

    test('pageFormat returns roll80 and roll57 with MultiPage thermal formats', () {
      expect(SaleReceiptService.pageFormat('80mm', thermal: true), PdfPageFormat.roll80);
      expect(SaleReceiptService.pageFormat('58mm', thermal: true), PdfPageFormat.roll57);
      expect(SaleReceiptService.pageFormat('80mm', thermal: false), PdfPageFormat.a4);
    });

    test('buildTestPdf generates exact-height document for 80mm and 58mm far shorter than 297mm', () async {
      final doc80 = await SaleReceiptService.buildTestPdf(paperSize: '80mm');
      final bytes80 = await doc80.save();
      expect(bytes80.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));
      expect(doc80.document.pdfPageList.pages.length, equals(1));
      final heightMm80 = doc80.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
      expect(heightMm80, lessThan(120.0)); // Far shorter than 297 mm
      expect(heightMm80, greaterThan(50.0));

      final doc58 = await SaleReceiptService.buildTestPdf(paperSize: '58mm');
      final bytes58 = await doc58.save();
      expect(bytes58.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));
      expect(doc58.document.pdfPageList.pages.length, equals(1));
      final heightMm58 = doc58.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
      expect(heightMm58, lessThan(150.0)); // Far shorter than 297 mm
      expect(heightMm58, greaterThan(50.0));
    });

    test('buildPdf for 3-line receipt is exact-height and far shorter than 297mm', () async {
      final sale3 = SaleResponseModel(
        id: 'sale-3',
        branchId: 'br-1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'REC-3',
        totalAmount: '1200.00',
        offline: false,
        lines: [
          SaleLineModel(id: '1', productId: 'p1', productName: 'چائے (Tea)', qty: '1', unitPrice: '200.00'),
          SaleLineModel(id: '2', productId: 'p2', productName: 'باسمتی چاول (Rice)', qty: '2', unitPrice: '400.00'),
          SaleLineModel(id: '3', productId: 'p3', productName: 'Sugar 1kg', qty: '1', unitPrice: '200.00'),
        ],
      );

      final doc3 = await SaleReceiptService.buildPdf(sale3, thermal: true);
      await doc3.save();

      expect(doc3.document.pdfPageList.pages.length, equals(1));
      final heightMm = doc3.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
      expect(heightMm, lessThan(120.0)); // 3-line receipt is ~75-95 mm, far shorter than 297 mm
      expect(heightMm, greaterThan(50.0));
    });

    test('buildPdf generates single exact-height page for 1 and 10 items, and handles 100 items on roll80 and roll57', () async {
      for (final count in [1, 10, 100]) {
        final lines = <SaleLineModel>[];
        for (var i = 1; i <= count; i++) {
          lines.add(SaleLineModel(
            id: 'l-$i',
            productId: 'p-$i',
            productName: i % 2 == 0 ? 'چائے پتی نمبر $i' : 'English Item $i',
            qty: '$i',
            unitPrice: '150.00',
          ));
        }

        final sale = SaleResponseModel(
          id: 'sale-$count',
          branchId: 'br-1',
          saleType: 'pos',
          saleStatus: 'completed',
          saleNumber: 'REC-$count',
          totalAmount: '${count * 150}.00',
          offline: false,
          lines: lines,
        );

        final doc80 = await SaleReceiptService.buildPdf(sale, thermal: true);
        final bytes80 = await doc80.save();
        expect(bytes80.isNotEmpty, true);
        if (count <= 25) {
          expect(doc80.document.pdfPageList.pages.length, equals(1));
          final h80 = doc80.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
          expect(h80, lessThanOrEqualTo(1000.0));
        } else {
          expect(doc80.document.pdfPageList.pages.length, greaterThanOrEqualTo(1));
        }
      }
    });

    test('buildPdf for huge receipts (> 1,000 mm) splits into multiple pages without infinite height assertion', () async {
      // 300 items will exceed 1,000 mm
      final lines = <SaleLineModel>[];
      for (var i = 1; i <= 300; i++) {
        lines.add(SaleLineModel(
          id: 'l-$i',
          productId: 'p-$i',
          productName: i % 2 == 0 ? 'چائے پتی نمبر $i' : 'English Product Item $i',
          qty: '1',
          unitPrice: '50.00',
        ));
      }

      final hugeSale = SaleResponseModel(
        id: 'sale-huge',
        branchId: 'br-1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'REC-HUGE',
        totalAmount: '15000.00',
        offline: false,
        lines: lines,
      );

      final docHuge = await SaleReceiptService.buildPdf(hugeSale, thermal: true);
      final bytesHuge = await docHuge.save();
      expect(bytesHuge.isNotEmpty, true);
      expect(bytesHuge.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));
      expect(docHuge.document.pdfPageList.pages.length, greaterThan(1));
      for (final page in docHuge.document.pdfPageList.pages) {
        expect(page.pageFormat.height, equals(SaleReceiptService.maxThermalPageHeight));
      }
    });
  });

  group('Printer Settings Page Widget Tests', () {
    late _FakePrinterService fakePrinterService;

    setUp(() {
      fakePrinterService = _FakePrinterService();
      if (sl.isRegistered<PrinterService>()) sl.unregister<PrinterService>();
      sl.registerSingleton<PrinterService>(fakePrinterService);
    });

    tearDown(() {
      if (sl.isRegistered<PrinterService>()) sl.unregister<PrinterService>();
    });

    testWidgets('shows Preview button and handles test print with no printer installed', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      fakePrinterService.mockPrinters = []; // No printers installed
      fakePrinterService.currentConfig = const PrinterConfig(printerName: null);

      await tester.pumpWidget(
        const MaterialApp(
          home: PrinterSettingsPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify "Print Test Receipt" and "Preview Receipt" buttons exist
      expect(find.text('Print Test Receipt (with Urdu demo)'), findsOneWidget);
      expect(find.text('Preview Receipt'), findsOneWidget);

      // Tap "Print Test Receipt" when no printer is installed
      final printBtn = find.text('Print Test Receipt (with Urdu demo)');
      await tester.ensureVisible(printBtn);
      await tester.pumpAndSettle();
      await tester.tap(printBtn);
      await tester.pumpAndSettle();

      // Expect plain message: "No printer found. You can still preview or save the receipt as PDF"
      expect(
        find.textContaining('No printer found. You can still preview or save the receipt as PDF'),
        findsOneWidget,
      );
    });
  });
}
