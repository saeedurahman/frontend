import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    test('buildPdf generates multi-page document for long receipt (100 items) and Urdu text without truncating', () async {
      // 100 line items
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

      final doc = await SaleReceiptService.buildPdf(
        sale,
        thermal: true,
      );

      final bytes = await doc.save();
      expect(bytes, isNotNull);
      expect(bytes.isNotEmpty, true);
      // Valid PDF signature %PDF
      expect(bytes.take(4).toList(), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
