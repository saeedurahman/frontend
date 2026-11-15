import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
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

    test('buildTestPdf generates document for 80mm and 58mm without infinite height assertion failure', () async {
      final doc80 = await SaleReceiptService.buildTestPdf(paperSize: '80mm');
      final bytes80 = await doc80.save();
      expect(bytes80.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));

      final doc58 = await SaleReceiptService.buildTestPdf(paperSize: '58mm');
      final bytes58 = await doc58.save();
      expect(bytes58.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));
    });

    test('buildPdf generates multi-page document for long receipt (100 items) on roll80 and roll57 without truncating', () async {
      final lines = <SaleLineModel>[];
      for (var i = 1; i <= 100; i++) {
        lines.add(SaleLineModel(
          id: 'l-$i',
          productId: 'p-$i',
          productName: i % 2 == 0 ? 'چائے پتی نمبر $i' : 'English Product Item $i',
          qty: '$i',
          unitPrice: '150.00',
        ));
      }

      final sale = SaleResponseModel(
        id: 'sale-long',
        branchId: 'br-1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'REC-LONG-001',
        totalAmount: '75000.00',
        offline: false,
        lines: lines,
      );

      // Test roll80
      final doc80 = await SaleReceiptService.buildPdf(
        sale,
        thermal: true,
      );
      final bytes80 = await doc80.save();
      expect(bytes80.isNotEmpty, true);
      expect(bytes80.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));

      // Test roll57
      final doc58 = await SaleReceiptService.buildPdf(
        sale,
        thermal: true,
        displaySettings: const ReceiptDisplaySettings(
          paperSize: '58mm',
          footerText: 'Thank you',
        ),
      );
      final bytes58 = await doc58.save();
      expect(bytes58.isNotEmpty, true);
      expect(bytes58.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));
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
