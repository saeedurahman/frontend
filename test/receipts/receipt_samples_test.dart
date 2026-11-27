// Draws every receipt design (thermal roll 80 / roll 58, A4) with the sample
// sale and saves PNG + PDF files for people to look at: in
// build/test_samples/receipt_samples/, or in docs/receipt_samples/ when run with
// UPDATE_SAMPLES=1. Fails if a design stops producing a picture or a valid PDF.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_samples.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_renderer.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_view.dart';

import '../helpers/sample_output.dart';

class _Sample {
  const _Sample(this.design, this.paper, this.width, [this.language = ReceiptLanguage.en]);
  final ReceiptDesign design;
  final ReceiptPaper paper;
  final double width; // logical pixels for the picture
  final ReceiptLanguage language;

  String get name => 'receipt_${design.code}_${paper.code}_${language.code}';
}

/// Every design in English, plus the Urdu (right-to-left) and bilingual
/// versions of the 80 mm roll and both A4 designs.
final _samples = [
  for (final lang in ReceiptLanguage.values) ...[
    _Sample(ReceiptDesign.thermalClassic, ReceiptPaper.roll80, 302, lang),
    _Sample(ReceiptDesign.a4TaxInvoice, ReceiptPaper.a4, 794, lang),
    _Sample(ReceiptDesign.a4Elegant, ReceiptPaper.a4, 794, lang),
  ],
  const _Sample(ReceiptDesign.thermalClassic, ReceiptPaper.roll58, 215),
  const _Sample(ReceiptDesign.thermalCompact, ReceiptPaper.roll80, 302),
  const _Sample(ReceiptDesign.thermalCompact, ReceiptPaper.roll58, 215),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final dir = sampleOutputDir('receipt_samples');

  setUpAll(() async {
    // Load the shop's own fonts up front so the first picture is not drawn
    // with the test placeholder font.
    for (final f in const {
      'NotoSans': 'assets/fonts/NotoSans-Regular.ttf',
      'NotoNaskhArabic': 'assets/fonts/NotoNaskhArabic-Regular.ttf',
      'NotoNastaliqUrdu': 'assets/fonts/NotoNastaliqUrdu-Regular.ttf',
    }.entries) {
      final loader = FontLoader(f.key)..addFont(rootBundle.load(f.value));
      await loader.load();
    }
    // Inter with its real bold (the A4 invoices).
    final inter = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter-400.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-700.ttf'));
    await inter.load();
  });

  for (final s in _samples) {
    final layout = ReceiptLayout(
      id: s.name,
      name: s.design.title,
      design: s.design,
      paper: s.paper,
      config: ReceiptLayoutConfig.defaultsFor(s.design, pharmacy: true)
          .withValue('footer', 'text_en', 'Thank you for shopping with us.')
          .withValue('footer', 'text_ur', 'ہماری دکان پر آنے کا شکریہ')
          .withLanguage(s.language),
    );
    final model = ReceiptModelBuilder.build(
      ReceiptSamples.sale(),
      layout,
      ReceiptChannel.print,
      context: ReceiptSamples.context(),
      now: DateTime(2026, 11, 17, 10, 30),
    );

    testWidgets('${s.name}: picture', (t) async {
      final key = GlobalKey();
      t.view.physicalSize = Size(s.width + 40, 2400);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: RepaintBoundary(
                  key: key,
                  child: ColoredBox(
                    color: Colors.white,
                    child: ReceiptView(model: model, maxWidth: s.width),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();

      final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final bytes = await t.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        return data!.buffer.asUint8List();
      });
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(5000), reason: 'the receipt drew something');
      File('${dir.path}/${s.name}.png').writeAsBytesSync(bytes);
    });

    test('${s.name}: pdf', () async {
      final doc = await ReceiptPdfRenderer.build(model);
      final bytes = await doc.save();
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(doc.document.pdfPageList.pages, isNotEmpty);
      File('${dir.path}/${s.name}.pdf').writeAsBytesSync(bytes);
    });
  }
}
