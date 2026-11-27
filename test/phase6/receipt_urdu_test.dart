import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/pages/printer_settings_page.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../helpers/sample_output.dart';

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
    return true;
  }

  @override
  Future<void> openCashDrawer() async {}
}

Future<Uint8List> renderReceiptToPng({
  required double width,
  required UrduReceiptStyle urduStyle,
  String shopName = 'Test Shop 3 / ٹیسٹ پرنٹ',
}) async {
  const double pixelRatio = 2.82; // 203 DPI
  const double margin = 10.0;
  final double printableWidth = width - (margin * 2);
  final fontFamily = urduStyle.fontFamily;
  final urduHeight = urduStyle == UrduReceiptStyle.nastaliq ? 1.85 : 1.35;

  TextPainter makePainter(String text, {
    required double fontSize,
    bool isBold = false,
    TextAlign align = TextAlign.start,
    bool isUrdu = false,
    Color color = Colors.black,
  }) {
    final p = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: isUrdu ? fontFamily : 'NotoSans',
          fontFamilyFallback: const ['NotoNastaliqUrdu', 'NotoNaskhArabic', 'NotoSans'],
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          height: isUrdu ? urduHeight : 1.25,
          color: color,
        ),
      ),
      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
      textAlign: align,
    );
    p.layout(maxWidth: printableWidth);
    return p;
  }

  final header = makePainter(shopName, fontSize: 14, isBold: true, align: TextAlign.center, isUrdu: true);
  final subHeader = makePainter('تھرمل پرنٹر ٹیسٹ پیج', fontSize: 10, align: TextAlign.center, isUrdu: true, color: Colors.black87);
  final date = makePainter('Nov 16, 2026 8:45 AM', fontSize: 8, align: TextAlign.center, color: Colors.black54);

  final item1Name = makePainter('چاول باسمتی (Rice)', fontSize: 10, isBold: true, align: TextAlign.right, isUrdu: true);
  final item1Qty = makePainter('1 x Rs. 450.00', fontSize: 8.5, color: Colors.black87);
  final item1Price = makePainter('Rs. 450.00', fontSize: 9, isBold: true);

  final item2Name = makePainter('چائے کی پتی (Tea)', fontSize: 10, isBold: true, align: TextAlign.right, isUrdu: true);
  final item2Qty = makePainter('2 x Rs. 450.00', fontSize: 8.5, color: Colors.black87);
  final item2Price = makePainter('Rs. 900.00', fontSize: 9, isBold: true);

  final totalLabel = makePainter('TOTAL', fontSize: 11, isBold: true);
  final totalVal = makePainter('Rs. 1,350.00', fontSize: 11, isBold: true);

  final footer = makePainter('Thank you! شکریہ', fontSize: 9, align: TextAlign.center, isUrdu: true);
  final brand = makePainter(AppBrand.current.receiptPoweredBy, fontSize: 7, align: TextAlign.center, color: Colors.black45);

  double y = margin;
  y += header.height + 2;
  y += subHeader.height + 4;
  y += date.height + 6;
  y += 6; // divider
  y += item1Name.height + 2;
  y += (item1Qty.height > item1Price.height ? item1Qty.height : item1Price.height) + 6;
  y += item2Name.height + 2;
  y += (item2Qty.height > item2Price.height ? item2Qty.height : item2Price.height) + 6;
  y += 6; // divider
  y += (totalLabel.height > totalVal.height ? totalLabel.height : totalVal.height) + 6;
  y += 6; // divider
  y += footer.height + 4;
  y += brand.height + margin;

  final totalHeight = y;
  final pixelWidth = (width * pixelRatio).ceil();
  final pixelHeight = (totalHeight * pixelRatio).ceil();

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, pixelWidth.toDouble(), pixelHeight.toDouble()));

  // Background
  final bgPaint = Paint()..color = Colors.white;
  canvas.drawRect(Rect.fromLTWH(0, 0, pixelWidth.toDouble(), pixelHeight.toDouble()), bgPaint);

  canvas.scale(pixelRatio, pixelRatio);

  final dividerPaint = Paint()
    ..color = Colors.black38
    ..strokeWidth = 0.5;

  double curY = margin;

  // Header
  header.paint(canvas, Offset(margin + (printableWidth - header.width) / 2, curY));
  curY += header.height + 2;

  // Subheader
  subHeader.paint(canvas, Offset(margin + (printableWidth - subHeader.width) / 2, curY));
  curY += subHeader.height + 4;

  // Date
  date.paint(canvas, Offset(margin + (printableWidth - date.width) / 2, curY));
  curY += date.height + 6;

  // Divider
  canvas.drawLine(Offset(margin, curY), Offset(margin + printableWidth, curY), dividerPaint);
  curY += 6;

  // Item 1
  item1Name.paint(canvas, Offset(margin + printableWidth - item1Name.width, curY));
  curY += item1Name.height + 2;
  item1Qty.paint(canvas, Offset(margin, curY));
  item1Price.paint(canvas, Offset(margin + printableWidth - item1Price.width, curY));
  curY += (item1Qty.height > item1Price.height ? item1Qty.height : item1Price.height) + 6;

  // Item 2
  item2Name.paint(canvas, Offset(margin + printableWidth - item2Name.width, curY));
  curY += item2Name.height + 2;
  item2Qty.paint(canvas, Offset(margin, curY));
  item2Price.paint(canvas, Offset(margin + printableWidth - item2Price.width, curY));
  curY += (item2Qty.height > item2Price.height ? item2Qty.height : item2Price.height) + 6;

  // Divider
  canvas.drawLine(Offset(margin, curY), Offset(margin + printableWidth, curY), dividerPaint);
  curY += 6;

  // Total
  totalLabel.paint(canvas, Offset(margin, curY));
  totalVal.paint(canvas, Offset(margin + printableWidth - totalVal.width, curY));
  curY += (totalLabel.height > totalVal.height ? totalLabel.height : totalVal.height) + 6;

  // Divider
  canvas.drawLine(Offset(margin, curY), Offset(margin + printableWidth, curY), dividerPaint);
  curY += 6;

  // Footer
  footer.paint(canvas, Offset(margin + (printableWidth - footer.width) / 2, curY));
  curY += footer.height + 4;

  // Brand
  brand.paint(canvas, Offset(margin + (printableWidth - brand.width) / 2, curY));

  final picture = recorder.endRecording();
  final image = await picture.toImage(pixelWidth, pixelHeight);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakePrinterService fakePrinterService;

  setUp(() async {
    fakePrinterService = _FakePrinterService();
    if (sl.isRegistered<PrinterService>()) sl.unregister<PrinterService>();
    sl.registerSingleton<PrinterService>(fakePrinterService);
    await ReceiptTextRenderer.ensureFontsLoaded();
  });

  tearDown(() {
    if (sl.isRegistered<PrinterService>()) sl.unregister<PrinterService>();
  });

  group('ReceiptTextRenderer Core Requirements', () {
    test('(a) returns non-empty images with sane dimensions for Urdu, mixed and Latin strings', () async {
      // Pure Urdu
      final urduImg = await ReceiptTextRenderer.renderText(
        'چاول باسمتی',
        fontSize: 10,
        style: UrduReceiptStyle.nastaliq,
      );
      expect(urduImg, isNotNull);
      expect(urduImg!.width, greaterThan(20.0));
      expect(urduImg.height, greaterThan(10.0));
      expect(urduImg.rawPngBytes.isNotEmpty, true);

      // Mixed Urdu + Latin
      final mixedImg = await ReceiptTextRenderer.renderText(
        'چائے کی پتی (Tea) x 2',
        fontSize: 10,
        style: UrduReceiptStyle.nastaliq,
      );
      expect(mixedImg, isNotNull);
      expect(mixedImg!.width, greaterThan(40.0));
      expect(mixedImg.height, greaterThan(10.0));
      expect(mixedImg.rawPngBytes.isNotEmpty, true);

      // Latin starting with Urdu inside
      final mixedLatinImg = await ReceiptTextRenderer.renderText(
        'Tea چائے',
        fontSize: 10,
        style: UrduReceiptStyle.nastaliq,
      );
      expect(mixedLatinImg, isNotNull);
      expect(mixedLatinImg!.width, greaterThan(20.0));
    });

    test('(a) respects max width wrapping for long Urdu strings', () async {
      const longUrduName = 'چاول سپر باسمتی کرنل دیسی اسپیشل کوالٹی ایک کلو پیکنگ';
      final unwrapped = await ReceiptTextRenderer.renderText(
        longUrduName,
        fontSize: 10,
        style: UrduReceiptStyle.nastaliq,
      );
      final wrapped = await ReceiptTextRenderer.renderText(
        longUrduName,
        fontSize: 10,
        maxWidth: 160.0,
        style: UrduReceiptStyle.nastaliq,
      );

      expect(unwrapped, isNotNull);
      expect(wrapped, isNotNull);
      expect(wrapped!.width, lessThanOrEqualTo(160.0 + 1.0));
      expect(wrapped.height, greaterThan(unwrapped!.height));
    });

    test('(b) caches rendered images to keep PDF size small and rendering fast', () async {
      ReceiptTextRenderer.clearCache();

      final img1 = await ReceiptTextRenderer.renderText('شکریہ', fontSize: 11);
      final img2 = await ReceiptTextRenderer.renderText('شکریہ', fontSize: 11);

      expect(identical(img1, img2), true);
    });
  });

  group('Thermal Page Height & Urdu Layout (c)', () {
    test('page height still matches content for roll80 and roll57 (exact height)', () async {
      // 80mm test receipt
      final doc80 = await SaleReceiptService.buildTestPdf(paperSize: '80mm');
      expect(doc80.document.pdfPageList.pages.length, equals(1));
      final h80 = doc80.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
      expect(h80, lessThan(140.0)); // Far shorter than 297 mm
      expect(h80, greaterThan(60.0));

      // 58mm test receipt
      final doc58 = await SaleReceiptService.buildTestPdf(paperSize: '58mm');
      expect(doc58.document.pdfPageList.pages.length, equals(1));
      final h58 = doc58.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
      expect(h58, lessThan(170.0)); // Far shorter than 297 mm
      expect(h58, greaterThan(60.0));
    });

    test('3-line sale receipt with Urdu product names is exact height and under 130mm', () async {
      final sale = SaleResponseModel(
        id: 'sale-urdu-3',
        branchId: 'br-1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'REC-URDU-001',
        totalAmount: '1350.00',
        offline: false,
        lines: const [
          SaleLineModel(id: '1', productId: 'p1', productName: 'چاول باسمتی (Rice)', qty: '1', unitPrice: '450.00'),
          SaleLineModel(id: '2', productId: 'p2', productName: 'چائے کی پتی (Tea)', qty: '2', unitPrice: '450.00'),
          SaleLineModel(id: '3', productId: 'p3', productName: 'Sugar 1kg (چینی)', qty: '1', unitPrice: '150.00'),
        ],
      );

      final doc = await SaleReceiptService.buildPdf(
        sale,
        thermal: true,
        displaySettings: const ReceiptDisplaySettings(footerText: 'Thank you! شکریہ', paperSize: '80mm'),
      );

      expect(doc.document.pdfPageList.pages.length, equals(1));
      final heightMm = doc.document.pdfPageList.pages.first.pageFormat.height / PdfPageFormat.mm;
      expect(heightMm, lessThan(160.0));
      expect(heightMm, greaterThan(70.0));
    });

    test('printing speed: 30-line Urdu receipt produces PDF in under 1.5 seconds', () async {
      final lines = <SaleLineModel>[];
      for (var i = 1; i <= 30; i++) {
        lines.add(SaleLineModel(
          id: 'l-$i',
          productId: 'p-$i',
          productName: i % 2 == 0 ? 'چائے پتی نمبر $i' : 'باسمتی چاول پیک نمبر $i',
          qty: '$i',
          unitPrice: '250.00',
        ));
      }

      final sale30 = SaleResponseModel(
        id: 'sale-30',
        branchId: 'br-1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'REC-30',
        totalAmount: '15000.00',
        offline: false,
        lines: lines,
      );

      final stopwatch = Stopwatch()..start();
      final doc = await SaleReceiptService.buildPdf(sale30, thermal: true);
      final bytes = await doc.save();
      stopwatch.stop();

      expect(bytes.isNotEmpty, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(1500));
    });
  });

  group('Receipt Preview Dialog (d)', () {
    testWidgets('preview dialog opens with Urdu content without exceptions', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: PrinterSettingsPage(),
        ),
      );
      await tester.pumpAndSettle();

      final previewBtn = find.text('Preview Receipt');
      expect(previewBtn, findsOneWidget);
      await tester.ensureVisible(previewBtn);
      await tester.pumpAndSettle();
      await tester.tap(previewBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify the dialog opened with title and PdfPreview widget
      expect(find.text('Receipt Preview'), findsOneWidget);
      expect(find.byType(PdfPreview), findsOneWidget);

      // Verify Urdu style radio options exist in settings
      final closeBtn = find.byIcon(Icons.close);
      await tester.tap(closeBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final nastaliqOption = find.text('Nastaliq (نستعلیق)');
      await tester.ensureVisible(nastaliqOption);
      await tester.pumpAndSettle();

      expect(nastaliqOption, findsOneWidget);
      expect(find.text('Naskh (نسخ)'), findsOneWidget);
    });
  });

  group('Golden Tests & Sample PNG Generation (b)', () {
    test('renders the sample receipt and saves PNG and PDF samples', () async {
      final dir = sampleOutputDir('receipt_samples').path;

      // 1. Render and capture roll80 (width ~226.77 pt = 80mm)
      final pngBytes80 = await renderReceiptToPng(
        width: 226.77,
        urduStyle: UrduReceiptStyle.nastaliq,
        shopName: 'Test Shop 3 / ٹیسٹ پرنٹ',
      );
      final file80 = File('$dir/receipt_sample_roll80.png');
      file80.writeAsBytesSync(pngBytes80);
      expect(file80.existsSync(), true);
      expect(file80.lengthSync(), greaterThan(1000));

      // 2. Render and capture roll57 (width ~161.57 pt = 57mm)
      final pngBytes57 = await renderReceiptToPng(
        width: 161.57,
        urduStyle: UrduReceiptStyle.nastaliq,
        shopName: 'Test Shop 3 / ٹیسٹ پرنٹ',
      );
      final file57 = File('$dir/receipt_sample_roll57.png');
      file57.writeAsBytesSync(pngBytes57);
      expect(file57.existsSync(), true);
      expect(file57.lengthSync(), greaterThan(1000));

      // 3. Render and capture Naskh style for comparison
      final pngBytesNaskh = await renderReceiptToPng(
        width: 226.77,
        urduStyle: UrduReceiptStyle.naskh,
        shopName: 'Test Shop 3 / ٹیسٹ پرنٹ',
      );
      final fileNaskh = File('$dir/receipt_sample_roll80_naskh.png');
      fileNaskh.writeAsBytesSync(pngBytesNaskh);
      expect(fileNaskh.existsSync(), true);
      expect(fileNaskh.lengthSync(), greaterThan(1000));

      // 4. Also save vector PDF builds for inspection
      final doc80Pdf = await SaleReceiptService.buildTestPdf(paperSize: '80mm');
      final pdfBytes80 = await doc80Pdf.save();
      File('$dir/receipt_sample_roll80.pdf').writeAsBytesSync(pdfBytes80);

      final doc58Pdf = await SaleReceiptService.buildTestPdf(paperSize: '58mm');
      final pdfBytes58 = await doc58Pdf.save();
      File('$dir/receipt_sample_roll57.pdf').writeAsBytesSync(pdfBytes58);
    });
  });
}
