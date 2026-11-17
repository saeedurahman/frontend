import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_plain_text.dart';
import 'package:frantend/features/receipts/domain/receipt_samples.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_renderer.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_support.dart';
import 'package:pdf/pdf.dart';

ReceiptLayout layoutOf(ReceiptDesign d, {ReceiptPaper? paper}) => ReceiptLayout(
      id: 'l-${d.code}',
      name: d.title,
      design: d,
      paper: paper ?? d.defaultPaper,
      config: ReceiptLayoutConfig.defaultsFor(d, pharmacy: true),
    );

ReceiptModel modelOf(ReceiptLayout l, {int extraLines = 0}) =>
    ReceiptModelBuilder.build(
      ReceiptSamples.sale(extraLines: extraLines),
      l,
      ReceiptChannel.print,
      context: ReceiptSamples.context(),
      now: DateTime(2026, 11, 17, 10, 30),
    );

String ascii(List<int> bytes, int n) =>
    String.fromCharCodes(bytes.take(n).toList());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('thermal PDF', () {
    for (final design in [ReceiptDesign.thermalClassic, ReceiptDesign.thermalCompact]) {
      for (final paper in [ReceiptPaper.roll80, ReceiptPaper.roll58]) {
        for (final extra in [0, 7, 97]) {
          // 3 sample lines + extra = 3 / 10 / 100 items; odd extras are Urdu.
          test('${design.code} on ${paper.code} with ${3 + extra} items', () async {
            final model = modelOf(layoutOf(design, paper: paper), extraLines: extra);
            final doc = await ReceiptPdfRenderer.build(model);
            final bytes = await doc.save();

            expect(ascii(bytes, 5), '%PDF-');
            final pages = doc.document.pdfPageList.pages;
            // A roll receipt is ONE page, as tall as its content. Only a
            // receipt longer than the 1,000 mm cap continues on a second
            // page of that same height.
            final tooLong = extra == 97;
            if (!tooLong) expect(pages, hasLength(1));
            expect(pages.length, lessThanOrEqualTo(3));
            for (final page in pages) {
              final f = page.pageFormat;
              expect(f.width / PdfPageFormat.mm, closeTo(paper.widthMm, 0.5));
              expect(f.height, greaterThan(100));
              expect(f.height, lessThanOrEqualTo(ReceiptPdfSupport.maxThermalPageHeight + 1));
            }
            if (pages.length > 1) {
              expect(pages.first.pageFormat.height,
                  closeTo(ReceiptPdfSupport.maxThermalPageHeight, 1));
            }
          });
        }
      }
    }

    test('the page grows with the number of items (exact height, no blank tail)', () async {
      final l = layoutOf(ReceiptDesign.thermalClassic);
      Future<double> heightFor(int extra) async {
        final doc = await ReceiptPdfRenderer.build(modelOf(l, extraLines: extra));
        await doc.save();
        return doc.document.pdfPageList.pages.first.pageFormat.height;
      }

      final h3 = await heightFor(0);
      final h10 = await heightFor(7);
      final h100 = await heightFor(97);
      expect(h10, greaterThan(h3));
      expect(h100, greaterThan(h10));
    });
  });

  group('A4 PDF', () {
    for (final design in [ReceiptDesign.a4TaxInvoice, ReceiptDesign.a4Elegant]) {
      for (final extra in [0, 7, 97]) {
        test('${design.code} with ${3 + extra} items', () async {
          final model = modelOf(layoutOf(design), extraLines: extra);
          final doc = await ReceiptPdfRenderer.build(model);
          final bytes = await doc.save();

          expect(ascii(bytes, 5), '%PDF-');
          final pages = doc.document.pdfPageList.pages;
          expect(pages, isNotEmpty);
          for (final p in pages) {
            expect(p.pageFormat.width / PdfPageFormat.mm, closeTo(210, 1));
            expect(p.pageFormat.height / PdfPageFormat.mm, closeTo(297, 1));
          }
          if (extra == 0) expect(pages, hasLength(1));
          if (extra == 97) expect(pages.length, greaterThan(1));
        });
      }
    }
  });

  group('plain text', () {
    test('has the business, number, items and total for every design', () {
      for (final d in ReceiptDesign.values) {
        final text = ReceiptPlainText.render(modelOf(layoutOf(d)));
        expect(text, contains('C1-0042'), reason: d.code);
        expect(text, contains('Panadol Extra'), reason: d.code);
        expect(text, contains('772.20'), reason: d.code);
        expect(text.toLowerCase(), isNot(contains('pending')), reason: d.code);
      }
    });

    test('keeps Urdu text as is and has no markup noise', () {
      final text = ReceiptPlainText.render(
        modelOf(layoutOf(ReceiptDesign.thermalClassic), extraLines: 2),
      );
      expect(text, contains('نمونہ آئٹم 2'));
      expect(text, isNot(contains('<')));
    });
  });
}
