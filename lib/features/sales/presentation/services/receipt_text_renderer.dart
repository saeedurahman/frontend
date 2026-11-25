import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

enum UrduReceiptStyle {
  nastaliq('NotoNastaliqUrdu', 'assets/fonts/NotoNastaliqUrdu-Regular.ttf'),
  naskh('NotoNaskhArabic', 'assets/fonts/NotoNaskhArabic-Regular.ttf');

  const UrduReceiptStyle(this.fontFamily, this.assetPath);
  final String fontFamily;
  final String assetPath;

  static UrduReceiptStyle fromString(String? val) {
    if (val?.toLowerCase() == 'naskh') return UrduReceiptStyle.naskh;
    return UrduReceiptStyle.nastaliq;
  }
}

class RenderedReceiptImage {
  final pw.MemoryImage image;
  final double width; // in PDF points
  final double height; // in PDF points
  final Uint8List rawPngBytes;

  const RenderedReceiptImage({
    required this.image,
    required this.width,
    required this.height,
    required this.rawPngBytes,
  });

  pw.Widget toWidget({pw.Alignment alignment = pw.Alignment.centerRight}) {
    return pw.Align(
      alignment: alignment,
      child: pw.Image(image, width: width, height: height),
    );
  }
}

class _CacheKey {
  final String text;
  final double fontSize;
  final double? maxWidth;
  final bool isBold;
  final UrduReceiptStyle style;
  final TextAlign textAlign;
  final int colorValue;

  const _CacheKey({
    required this.text,
    required this.fontSize,
    this.maxWidth,
    required this.isBold,
    required this.style,
    required this.textAlign,
    this.colorValue = 0xFF000000,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CacheKey &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          fontSize == other.fontSize &&
          maxWidth == other.maxWidth &&
          isBold == other.isBold &&
          style == other.style &&
          textAlign == other.textAlign &&
          colorValue == other.colorValue;

  @override
  int get hashCode =>
      Object.hash(text, fontSize, maxWidth, isBold, style, textAlign, colorValue);
}

abstract final class ReceiptTextRenderer {
  static final RegExp _arabicScriptRegExp = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  static final Map<_CacheKey, RenderedReceiptImage> _cache = {};
  static bool _fontsLoaded = false;

  /// Equivalent to 203 DPI when base PDF resolution is 72 pt/inch (~2.82x - 3.0x).
  static const double pixelRatio = 3.0;

  static void clearCache() => _cache.clear();

  /// Checks if [text] contains any Arabic-script (Urdu/Arabic/Persian) characters.
  static bool hasArabicScript(String? text) {
    if (text == null || text.trim().isEmpty) return false;
    return _arabicScriptRegExp.hasMatch(text);
  }

  /// Determines text direction by the first strong directional character.
  static TextDirection detectTextDirection(String text) {
    for (final char in text.runes) {
      if ((char >= 0x0590 && char <= 0x08FF) ||
          (char >= 0xFB1D && char <= 0xFDFD) ||
          (char >= 0xFE70 && char <= 0xFEFC)) {
        return TextDirection.rtl;
      }
      if ((char >= 0x0041 && char <= 0x005A) ||
          (char >= 0x0061 && char <= 0x007A) ||
          (char >= 0x00C0 && char <= 0x024F)) {
        return TextDirection.ltr;
      }
    }
    return TextDirection.rtl;
  }

  /// Loads bundled TTF fonts into the Flutter engine font registry once.
  static Future<void> ensureFontsLoaded() async {
    if (_fontsLoaded) return;
    try {
      WidgetsFlutterBinding.ensureInitialized();
    } catch (_) {}

    try {
      final nastaliqLoader = FontLoader('NotoNastaliqUrdu');
      nastaliqLoader.addFont(
          _loadAssetBytes('assets/fonts/NotoNastaliqUrdu-Regular.ttf'));
      nastaliqLoader
          .addFont(_loadAssetBytes('assets/fonts/NotoNastaliqUrdu-Bold.ttf'));
      await nastaliqLoader.load();
    } catch (_) {}

    try {
      final naskhLoader = FontLoader('NotoNaskhArabic');
      naskhLoader
          .addFont(_loadAssetBytes('assets/fonts/NotoNaskhArabic-Regular.ttf'));
      await naskhLoader.load();
    } catch (_) {}

    try {
      final sansLoader = FontLoader('NotoSans');
      sansLoader.addFont(_loadAssetBytes('assets/fonts/NotoSans-Regular.ttf'));
      await sansLoader.load();
    } catch (_) {}

    _fontsLoaded = true;
  }

  static Future<ByteData> _loadAssetBytes(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      final file = File(path);
      if (file.existsSync()) {
        final bytes = await file.readAsBytes();
        return ByteData.sublistView(bytes);
      }
      rethrow;
    }
  }

  /// Renders [text] via Flutter's text engine with HarfBuzz shaping to a PNG image.
  /// Returns a [RenderedReceiptImage] with exact PDF point dimensions.
  static Future<RenderedReceiptImage?> renderText(
    String text, {
    required double fontSize,
    double? maxWidth,
    bool isBold = false,
    UrduReceiptStyle style = UrduReceiptStyle.nastaliq,
    TextAlign textAlign = TextAlign.start,
    Color color = const Color(0xFF000000),
  }) async {
    if (text.trim().isEmpty) return null;

    final key = _CacheKey(
      text: text,
      fontSize: fontSize,
      maxWidth: maxWidth,
      isBold: isBold,
      style: style,
      textAlign: textAlign,
      colorValue: color.toARGB32(),
    );

    final cached = _cache[key];
    if (cached != null) return cached;

    await ensureFontsLoaded();

    final direction = detectTextDirection(text);
    final lineHeight = style == UrduReceiptStyle.nastaliq ? 1.85 : 1.35;

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontFamily: style.fontFamily,
        fontFamilyFallback: const [
          'NotoNastaliqUrdu',
          'NotoNaskhArabic',
          'NotoSans',
        ],
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        height: lineHeight,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: direction,
      textAlign: textAlign,
    );

    if (maxWidth != null && maxWidth > 0) {
      textPainter.layout(maxWidth: maxWidth);
    } else {
      textPainter.layout();
    }

    final logicalWidth = textPainter.width;
    final logicalHeight = textPainter.height;

    if (logicalWidth <= 0 || logicalHeight <= 0) return null;

    final pixelWidth = (logicalWidth * pixelRatio).ceil();
    final pixelHeight = (logicalHeight * pixelRatio).ceil();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, pixelWidth.toDouble(), pixelHeight.toDouble()),
    );

    canvas.scale(pixelRatio, pixelRatio);
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(pixelWidth, pixelHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final pngBytes = byteData.buffer.asUint8List();
    final memoryImage = pw.MemoryImage(pngBytes);

    final result = RenderedReceiptImage(
      image: memoryImage,
      width: logicalWidth,
      height: logicalHeight,
      rawPngBytes: pngBytes,
    );

    _cache[key] = result;
    return result;
  }
}
