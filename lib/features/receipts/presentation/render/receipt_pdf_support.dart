import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr/qr.dart';

/// PDF helpers every receipt channel shares (fonts, measuring, QR).
abstract final class ReceiptPdfSupport {
  /// Safe maximum single page height for thermal roll printers (1,000 mm).
  /// Taller content splits into several pages via [pw.MultiPage].
  static const double maxThermalPageHeight = 1000 * PdfPageFormat.mm;

  /// Detects whether text contains Arabic/Urdu unicode characters.
  static bool hasRtl(String? text) {
    if (text == null || text.isEmpty) return false;
    return RegExp(
      r'[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]',
    ).hasMatch(text);
  }

  /// Bundled Unicode fonts (Noto Sans, with Noto Naskh Arabic as the Urdu
  /// fallback for any text that is not drawn as an image).
  static Future<pw.ThemeData> loadFonts() async {
    try {
      final sansBytes = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final arabicBytes =
          await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
      final sansFont = pw.Font.ttf(sansBytes);
      final arabicFont = pw.Font.ttf(arabicBytes);
      return pw.ThemeData.withFont(
        base: sansFont,
        bold: sansFont,
        italic: sansFont,
        boldItalic: sansFont,
        fontFallback: [arabicFont],
      );
    } catch (_) {
      return pw.ThemeData.base();
    }
  }

  static pw.ThemeData? _a4Theme;

  /// Inter (regular and a real bold) for the A4 invoices, with Noto Naskh as
  /// the Urdu fallback. The thermal rolls keep Noto Sans.
  static Future<pw.ThemeData> loadA4Fonts() async {
    final cached = _a4Theme;
    if (cached != null) return cached;
    try {
      final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter-400.ttf'));
      final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter-700.ttf'));
      final arabic = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf'));
      return _a4Theme = pw.ThemeData.withFont(
        base: regular,
        bold: bold,
        italic: regular,
        boldItalic: bold,
        fontFallback: [arabic],
      );
    } catch (_) {
      return loadFonts();
    }
  }

  /// Layout height of [widgets] at a fixed [maxWidth] (exact thermal pages).
  static double measureWidgetsHeight({
    required List<pw.Widget> widgets,
    required double maxWidth,
    required pw.ThemeData theme,
  }) {
    final pdfDoc = PdfDocument();
    final pdfPage = PdfPage(pdfDoc, pageFormat: PdfPageFormat(maxWidth + 50, 100000));
    final canvas = pdfPage.getGraphics();
    final context = pw.Context(
      document: pdfDoc,
      page: pdfPage,
      canvas: canvas,
    ).inheritFromAll([
      theme,
      pw.InheritedDirectionality(pw.TextDirection.ltr),
    ]);

    final root = pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: widgets,
    );

    root.layout(context, pw.BoxConstraints(maxWidth: maxWidth));
    return root.box?.height ?? 0.0;
  }

  /// QR modules of [content] (true = dark).
  static List<List<bool>> qrMatrix(String content) {
    final code = QrCode.fromData(
      data: content,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final image = QrImage(code);
    return [
      for (var r = 0; r < image.moduleCount; r++)
        [for (var c = 0; c < image.moduleCount; c++) image.isDark(r, c)],
    ];
  }

  /// A square QR code of [side] points drawn as vector squares.
  static pw.Widget qr(String content, double side) {
    final matrix = qrMatrix(content);
    final n = matrix.length;
    final quiet = 2; // modules of white border
    final unit = side / (n + quiet * 2);
    return pw.SizedBox(
      width: side,
      height: side,
      child: pw.CustomPaint(
        size: PdfPoint(side, side),
        painter: (canvas, size) {
          canvas
            ..setFillColor(PdfColors.white)
            ..drawRect(0, 0, side, side)
            ..fillPath()
            ..setFillColor(PdfColors.black);
          for (var r = 0; r < n; r++) {
            for (var c = 0; c < n; c++) {
              if (!matrix[r][c]) continue;
              canvas.drawRect(
                (c + quiet) * unit,
                side - (r + quiet + 1) * unit,
                unit + 0.15,
                unit + 0.15,
              );
            }
          }
          canvas.fillPath();
        },
      ),
    );
  }
}
