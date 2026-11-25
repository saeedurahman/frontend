import 'dart:typed_data';

import 'package:flutter/material.dart' show Color, TextAlign;
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_support.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Draws a [ReceiptModel] as a PDF: exact-height rolls for the thermal
/// designs, A4 pages for the invoice designs. Urdu text goes through the
/// existing image renderer ([ReceiptTextRenderer]) so it shapes correctly on
/// every printer.
abstract final class ReceiptPdfRenderer {
  static const _rollMargin = pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  static const _a4Margin = pw.EdgeInsets.fromLTRB(36, 34, 36, 28);

  static Future<pw.Document> build(
    ReceiptModel model, {
    UrduReceiptStyle urduStyle = UrduReceiptStyle.nastaliq,
    pw.ThemeData? theme,
  }) async {
    if (model.design.isA4) {
      // The A4 invoices always use Inter (it has a real bold).
      final doc = pw.Document(theme: await ReceiptPdfSupport.loadA4Fonts());
      final ink = _Ink(urduStyle, PdfPageFormat.a4.width - _a4Margin.horizontal,
          model.fontScale, rtl: model.rtl);
      final a4 = _A4(model, ink);
      final widgets = await a4.build();
      final footer = await a4.footer();
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: _a4Margin,
          footer: footer,
          build: (_) => widgets,
        ),
      );
      return doc;
    }
    final resolved = theme ?? await ReceiptPdfSupport.loadFonts();
    final doc = pw.Document(theme: resolved);

    final rollWidth = model.paper.widthMm * PdfPageFormat.mm;
    final printable = rollWidth - _rollMargin.horizontal;
    final ink = _Ink(urduStyle, printable, model.fontScale, rtl: model.rtl);
    final widgets = await _Thermal(model, ink, printable).build();
    final content = ReceiptPdfSupport.measureWidgetsHeight(
      widgets: widgets,
      maxWidth: printable,
      theme: resolved,
    );
    // Measured content + margins + a 4 mm cutter allowance: short receipts
    // do not feed blank paper, long ones stay on one page up to 1,000 mm.
    final exact = content + _rollMargin.vertical + (4 * PdfPageFormat.mm);
    if (exact <= ReceiptPdfSupport.maxThermalPageHeight) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(rollWidth, exact),
          margin: _rollMargin,
          build: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: widgets,
          ),
        ),
      );
    } else {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat(rollWidth, ReceiptPdfSupport.maxThermalPageHeight),
          margin: _rollMargin,
          build: (_) => widgets,
        ),
      );
    }
    return doc;
  }
}

/// Text maker: Arabic-script text becomes an image, the rest stays text.
class _Ink {
  _Ink(this.style, this.width, this.scale, {this.rtl = false});

  final UrduReceiptStyle style;
  final double width;
  final double scale;

  /// Urdu receipt: everything is mirrored (labels on the right, values on the
  /// left, columns in reverse order).
  final bool rtl;

  double sz(double base) => base * scale;

  /// [items] in reading order for the receipt direction.
  List<T> dir<T>(List<T> items) => rtl ? items.reversed.toList() : items;

  TextAlign _resolve(TextAlign a) => switch (a) {
        TextAlign.start => rtl ? TextAlign.right : TextAlign.left,
        TextAlign.end => rtl ? TextAlign.left : TextAlign.right,
        _ => a,
      };

  Future<pw.Widget> text(
    String value, {
    double size = 9,
    bool bold = false,
    TextAlign align = TextAlign.start,
    double? maxWidth,
    PdfColor? color,
  }) async {
    align = _resolve(align);
    final fontSize = sz(size);
    final pwAlign = switch (align) {
      TextAlign.center => pw.TextAlign.center,
      TextAlign.right => pw.TextAlign.right,
      _ => pw.TextAlign.left,
    };
    if (ReceiptTextRenderer.hasArabicScript(value)) {
      final rendered = await ReceiptTextRenderer.renderText(
        value,
        fontSize: fontSize,
        isBold: bold,
        maxWidth: maxWidth ?? width,
        style: style,
        textAlign: align,
        color: color == null ? const Color(0xFF000000) : Color(color.toInt()),
      );
      if (rendered != null) {
        return pw.Align(
          alignment: switch (align) {
            TextAlign.center => pw.Alignment.center,
            TextAlign.right => pw.Alignment.centerRight,
            _ => pw.Alignment.centerLeft,
          },
          child: pw.Image(rendered.image, width: rendered.width, height: rendered.height),
        );
      }
    }
    return pw.Text(
      value,
      textAlign: pwAlign,
      style: pw.TextStyle(
        fontSize: fontSize,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: color,
      ),
    );
  }

  /// The Urdu caption under an English one (both-language receipts).
  Future<pw.Widget> alt(
    String text_, {
    double size = 8.5,
    bool bold = false,
    double? maxWidth,
    PdfColor? color,
    double scale = 0.92,
    TextAlign align = TextAlign.right,
  }) =>
      text(text_,
          size: size * scale, bold: bold, align: align, maxWidth: maxWidth, color: color);

  /// Label at the start (wraps inside [labelWidth]), value at the end; the
  /// Urdu caption of a both-language receipt goes on a second line.
  Future<pw.Widget> row(
    String label,
    String value, {
    String? labelAlt,
    double size = 8.5,
    bool bold = false,
    double? labelWidth,
    PdfColor? color,
    double altScale = 0.92,
    PdfColor? altColor,
    TextAlign altAlign = TextAlign.right,
    bool altInline = false,
  }) async {
    final l = await text(label,
        size: size, bold: bold, maxWidth: labelWidth ?? width * 0.62, color: color);
    final valueText = pw.Text(
      value,
      style: pw.TextStyle(
        fontSize: sz(size),
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: color,
      ),
    );
    final line = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: dir([
        pw.Flexible(child: l),
        pw.SizedBox(width: 4),
        valueText,
      ]),
    );
    if (labelAlt == null || labelAlt.isEmpty) return line;
    if (altInline) {
      // English caption and its Urdu caption side by side, value at the end.
      final caption = await alt(labelAlt,
          size: size,
          bold: bold,
          scale: altScale,
          align: TextAlign.start,
          maxWidth: (labelWidth ?? width * 0.62) * 0.55,
          color: altColor ?? color);
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: dir([
          pw.Flexible(
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: dir([l, pw.SizedBox(width: 6), caption]),
            ),
          ),
          pw.SizedBox(width: 4),
          valueText,
        ]),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        line,
        await alt(labelAlt,
            size: size,
            bold: bold,
            scale: altScale,
            align: altAlign,
            maxWidth: labelWidth ?? width * 0.62,
            color: altColor ?? color),
      ],
    );
  }
}

pw.Widget? _logo(ReceiptModel m, double height) {
  final bytes = m.header.logoBytes;
  if (bytes == null || bytes.isEmpty) return null;
  try {
    return pw.Image(
      pw.MemoryImage(Uint8List.fromList(bytes)),
      height: height,
      fit: pw.BoxFit.contain,
    );
  } catch (_) {
    return null;
  }
}

// ── thermal ────────────────────────────────────────────────────────────

class _Thermal {
  _Thermal(this.m, this.ink, this.printable);

  final ReceiptModel m;
  final _Ink ink;
  final double printable;

  pw.Widget get _divider => m.showDividers
      ? pw.Divider(thickness: 0.5, height: m.compactItems ? 6 : 10)
      : pw.SizedBox(height: m.compactItems ? 3 : 6);

  /// Small indent under an item name, on the side the receipt reads from.
  pw.EdgeInsets get _indent => ink.rtl
      ? const pw.EdgeInsets.only(right: 6, top: 0.5)
      : const pw.EdgeInsets.only(left: 6, top: 0.5);

  Future<List<pw.Widget>> build() async {
    final out = <pw.Widget>[];
    final h = m.header;

    if (m.isVoid) {
      out.add(await ink.text(m.voidLabel,
          size: 16, bold: true, align: TextAlign.center));
      if (m.voidAlt != null) {
        out.add(await ink.alt(m.voidAlt!, size: 16, bold: true, align: TextAlign.center));
      }
    }
    final logo = _logo(m, 36);
    if (logo != null) {
      out
        ..add(pw.Center(child: logo))
        ..add(pw.SizedBox(height: 3));
    }
    if (h.businessName != null) {
      out.add(await ink.text(h.businessName!,
          size: 14, bold: true, align: TextAlign.center));
    }
    for (final line in [
      if (h.address != null) h.address!,
      if (h.phone != null) h.phone!,
      if (h.ntnLine != null) h.ntnLine!,
      ...h.extraLines,
    ]) {
      out.add(await ink.text(line, size: 8, align: TextAlign.center));
    }

    if (m.meta.isNotEmpty) {
      out.add(_divider);
      for (final r in m.meta) {
        out.add(pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 0.5),
          child: await ink.row(r.label, r.value, labelAlt: r.labelAlt, size: 8),
        ));
      }
    }

    out.add(_divider);
    for (final item in m.items) {
      out.add(await _item(item));
    }
    out.add(_divider);

    for (final t in m.totals) {
      out.add(await ink.row(
        t.label,
        t.value,
        labelAlt: t.labelAlt,
        size: t.strong ? 11 : 8.5,
        bold: t.strong,
      ));
    }
    if (m.taxNote != null) {
      out.add(pw.SizedBox(height: 1));
      out.add(await ink.text(m.taxNote!, size: 7.5, align: TextAlign.center));
      if (m.taxNoteAlt != null) {
        out.add(await ink.alt(m.taxNoteAlt!, size: 7.5, align: TextAlign.center));
      }
    }
    if (m.payments.isNotEmpty) {
      out.add(pw.SizedBox(height: 4));
      for (final p in m.payments) {
        out.add(await ink.row(p.label, p.value, labelAlt: p.labelAlt, size: 8));
      }
    }

    if (m.footerLines.isNotEmpty) {
      out.add(_divider);
      for (final l in m.footerLines) {
        out.add(await ink.text(l, size: 8.5, align: TextAlign.center));
      }
    }
    if (m.qrContent != null) {
      final side = (printable * 0.5).clamp(60.0, 110.0).toDouble();
      out
        ..add(pw.SizedBox(height: 6))
        ..add(pw.Center(child: ReceiptPdfSupport.qr(m.qrContent!, side)));
    }
    if (m.poweredBy != null) {
      out
        ..add(pw.SizedBox(height: 4))
        ..add(await ink.text(m.poweredBy!, size: 7, align: TextAlign.center));
    }
    return out;
  }

  Future<pw.Widget> _item(ReceiptItem item) async {
    final compact = m.compactItems;
    final detail = [
      if (item.qty != null && item.unitPrice != null)
        '${item.qty}${item.unit != null ? ' ${item.unit}' : ''} x ${item.unitPrice}'
      else if (item.qty != null)
        'x ${item.qty}${item.unit != null ? ' ${item.unit}' : ''}'
      else if (item.unitPrice != null)
        item.unitPrice!,
      if (item.discount != null) item.discount!,
    ].join('   ');

    final children = <pw.Widget>[];
    final nameBlock = <pw.Widget>[
      if (item.name.isNotEmpty)
        await ink.text(
          item.name,
          size: 9.5,
          bold: true,
          align: ink.rtl || ReceiptTextRenderer.hasArabicScript(item.name)
              ? TextAlign.right
              : TextAlign.left,
          maxWidth: compact && item.lineTotal != null ? printable * 0.68 : printable,
        ),
    ];

    final oneLine = compact &&
        item.lineTotal != null &&
        (item.qty == null || item.qty == '1') &&
        item.discount == null;
    if (oneLine) {
      children.add(pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: ink.dir([
          pw.Flexible(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: nameBlock)),
          pw.SizedBox(width: 4),
          pw.Text(item.lineTotal!,
              style: pw.TextStyle(fontSize: ink.sz(9), fontWeight: pw.FontWeight.bold)),
        ]),
      ));
    } else {
      children.addAll(nameBlock);
    }
    for (final extra in item.extraLines) {
      children.add(pw.Padding(
        padding: _indent,
        child: await ink.text(extra, size: 8),
      ));
    }
    for (final b in item.batches) {
      final text = [
        if (b.batchNo != null) '${m.word('batch')} ${b.batchNo}',
        if (b.expiry != null) '${m.word('expiry')} ${b.expiry}',
      ].join('  ');
      if (text.isNotEmpty) {
        children.add(pw.Padding(
          padding: _indent,
          child: await ink.text(text, size: 7.5),
        ));
      }
    }
    if (item.sku != null || item.barcode != null) {
      children.add(pw.Padding(
        padding: _indent,
        child: await ink.text(
          [if (item.sku != null) item.sku!, if (item.barcode != null) item.barcode!].join('  '),
          size: 7.5,
        ),
      ));
    }
    if (!oneLine && (detail.isNotEmpty || item.lineTotal != null)) {
      children.add(pw.SizedBox(height: compact ? 0.5 : 1.5));
      children.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: ink.dir([
          pw.Text(detail, style: pw.TextStyle(fontSize: ink.sz(8.5))),
          if (item.lineTotal != null)
            pw.Text(item.lineTotal!,
                style: pw.TextStyle(fontSize: ink.sz(9), fontWeight: pw.FontWeight.bold)),
        ]),
      ));
    }
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: compact ? 1 : 2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

// ── A4 ─────────────────────────────────────────────────────────────────

/// The two A4 invoice designs. Both share one structure: a header (banner or
/// ruled), a details card, a striped item table, a tax / totals area with a
/// highlighted Total, a thank-you bar and a footer (signature, page number).
/// The elegant design takes the shop's accent colour; the tax invoice stays
/// dark slate so it prints well in black and white.
class _A4 {
  _A4(this.m, this.ink);

  final ReceiptModel m;
  final _Ink ink;

  static const _text = PdfColor.fromInt(0xFF111827);
  static const _muted = PdfColor.fromInt(0xFF6B7280);
  static const _line = PdfColor.fromInt(0xFFD9DDE3);
  static const _slate = PdfColor.fromInt(0xFF1F2937);
  static const _soft = PdfColor.fromInt(0xFFF3F4F6);
  static const _onDark = PdfColors.white;
  static const _onDarkMuted = PdfColor.fromInt(0xFFE5E7EB);
  static const _alt = 0.8;

  bool get elegant => m.design == ReceiptDesign.a4Elegant;
  PdfColor get accent => elegant ? PdfColor.fromInt(m.accentColor) : _slate;

  /// A very light version of [accent] for stripes and cards. Solid on purpose:
  /// PDF viewers draw a translucent fill as a flat dark one.
  PdfColor get tint => elegant
      ? PdfColor(
          1 - (1 - accent.red) * 0.1,
          1 - (1 - accent.green) * 0.1,
          1 - (1 - accent.blue) * 0.1,
        )
      : _soft;

  pw.CrossAxisAlignment get _start =>
      ink.rtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start;
  pw.CrossAxisAlignment get _end =>
      ink.rtl ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.end;

  Future<List<pw.Widget>> build() async {
    final out = <pw.Widget>[];
    out.add(await _header());
    out.add(pw.SizedBox(height: 12));
    if (m.meta.isNotEmpty) {
      out.add(await _details());
      out.add(pw.SizedBox(height: 12));
    }
    out.addAll(await _table());
    out.add(pw.SizedBox(height: 14));
    out.add(await _summary());
    if (m.taxNote != null) {
      out
        ..add(pw.SizedBox(height: 6))
        ..add(await ink.text(m.taxNote!,
            size: 8, align: TextAlign.end, color: _muted));
      if (m.taxNoteAlt != null) {
        out.add(await ink.alt(m.taxNoteAlt!,
            size: 8, scale: _alt, color: _muted, align: TextAlign.end));
      }
    }
    if (m.footerLines.isNotEmpty) {
      out
        ..add(pw.SizedBox(height: 14))
        ..add(await _thanks());
    }
    return out;
  }

  // ── header ──

  Future<pw.Widget> _businessBlock({
    required PdfColor nameColor,
    required PdfColor detailColor,
  }) async {
    final h = m.header;
    final lines = <pw.Widget>[
      if (h.businessName != null)
        await ink.text(h.businessName!,
            size: 18, bold: true, maxWidth: 290, color: nameColor),
      for (final l in [
        if (h.address != null) h.address!,
        if (h.phone != null) h.phone!,
        if (h.ntnLine != null) h.ntnLine!,
        ...h.extraLines,
      ])
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 1.5),
          child: await ink.text(l, size: 8.5, maxWidth: 290, color: detailColor),
        ),
    ];
    final logo = _logo(m, 46);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: ink.dir([
        if (logo != null)
          pw.Container(
            margin: pw.EdgeInsets.only(
              right: ink.rtl ? 0 : 12,
              left: ink.rtl ? 12 : 0,
            ),
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(8),
              border: elegant ? null : pw.Border.all(color: _line, width: 0.8),
            ),
            child: logo,
          ),
        pw.Expanded(
          child: pw.Column(crossAxisAlignment: _start, children: lines),
        ),
      ]),
    );
  }

  Future<pw.Widget> _titleBlock({required PdfColor color}) async {
    return pw.Column(
      crossAxisAlignment: _end,
      children: [
        await ink.text(m.title.toUpperCase(),
            size: 18, bold: true, align: TextAlign.end, maxWidth: 200, color: color),
        if (m.titleAlt != null)
          await ink.alt(m.titleAlt!,
              size: 18, bold: true, maxWidth: 200, color: color, scale: 0.85),
        if (m.isVoid) ...[
          pw.SizedBox(height: 4),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: await ink.text(m.voidLabel,
                size: 11, bold: true, color: PdfColors.red800, maxWidth: 160),
          ),
          if (m.voidAlt != null)
            await ink.alt(m.voidAlt!,
                size: 11, bold: true, maxWidth: 160, color: color, scale: _alt),
        ],
      ],
    );
  }

  Future<pw.Widget> _header() async {
    if (elegant) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: pw.BoxDecoration(
          color: accent,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: ink.dir([
            pw.Expanded(
              flex: 3,
              child: await _businessBlock(nameColor: _onDark, detailColor: _onDarkMuted),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(flex: 2, child: await _titleBlock(color: _onDark)),
          ]),
        ),
      );
    }
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: accent, width: 2.2)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: ink.dir([
          pw.Expanded(
            flex: 3,
            child: await _businessBlock(nameColor: _text, detailColor: _muted),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            flex: 2,
            child: pw.Align(
              alignment: ink.rtl ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: pw.BoxDecoration(
                  color: accent,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: await _titleBlock(color: _onDark),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ── details card ──

  Future<pw.Widget> _metaCell(ReceiptMetaRow r, double width) async {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        await ink.text(r.label, size: 7.5, maxWidth: width, color: _muted),
        if (r.labelAlt != null)
          await ink.alt(r.labelAlt!,
              size: 7.5, scale: _alt, maxWidth: width, color: _muted, align: TextAlign.start),
        pw.SizedBox(height: 1.5),
        await ink.text(r.value, size: 10, bold: true, maxWidth: width, color: _text),
      ],
    );
  }

  /// [rows] laid out [perRow] cells to a line.
  Future<pw.Widget> _metaGrid(List<ReceiptMetaRow> rows, int perRow, double width) async {
    final lines = <pw.Widget>[];
    for (var i = 0; i < rows.length; i += perRow) {
      final cells = <pw.Widget>[];
      for (var j = i; j < i + perRow; j++) {
        cells.add(pw.Expanded(
          child: j < rows.length
              ? await _metaCell(rows[j], width / perRow - 8)
              : pw.SizedBox(),
        ));
      }
      lines.add(pw.Padding(
        padding: pw.EdgeInsets.only(top: i == 0 ? 0 : 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: ink.dir(cells),
        ),
      ));
    }
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: lines);
  }

  Future<pw.Widget> _details() async {
    bool isParty(ReceiptMetaRow r) => r.key == 'customer' || r.key == 'customer_phone';
    final party = m.meta.where(isParty).toList();
    final doc = m.meta.where((r) => !isParty(r)).toList();
    final inner = ink.width - 24;
    final pw.Widget body;
    if (party.isEmpty || doc.isEmpty) {
      body = await _metaGrid(party.isEmpty ? doc : party, 3, inner);
    } else {
      body = pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: ink.dir([
          pw.Expanded(flex: 3, child: await _metaGrid(doc, 2, inner * 0.6)),
          pw.Container(
            width: 0.8,
            height: 60,
            margin: const pw.EdgeInsets.symmetric(horizontal: 14),
            color: _line,
          ),
          pw.Expanded(flex: 2, child: await _metaGrid(party, 1, inner * 0.4)),
        ]),
      );
    }
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _line, width: 0.8),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: body,
    );
  }

  // ── item table ──

  List<ReceiptColumn> get _cols => m.columns;

  /// "End" of a cell: right for English, left for a right-to-left receipt.
  pw.TextAlign get _cellEnd => ink.rtl ? pw.TextAlign.left : pw.TextAlign.right;
  bool get _hasDiscount => m.items.any((i) => i.discount != null);

  Future<List<pw.Widget>> _table() async {
    final rows = <pw.Widget>[];
    final cols = _cols;
    final head = <pw.Widget>[];
    for (final c in cols) {
      head.add(pw.Expanded(
        flex: c.flex,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            await ink.text(
              c.label,
              size: 8.5,
              bold: true,
              align: c.right ? TextAlign.end : TextAlign.start,
              maxWidth: c.flex * 62.0,
              color: _onDark,
            ),
            if (c.labelAlt != null)
              await ink.alt(c.labelAlt!,
                  size: 8.5,
                  bold: true,
                  scale: _alt,
                  maxWidth: c.flex * 62.0,
                  color: _onDark,
                  align: c.right ? TextAlign.right : TextAlign.left),
          ],
        ),
      ));
      if (c.key == 'price' && _hasDiscount) {
        head.add(pw.Expanded(
          flex: 2,
          child: await ink.text(m.word('discount'),
              size: 8.5, bold: true, align: TextAlign.end, maxWidth: 100, color: _onDark),
        ));
      }
    }
    rows.add(pw.Container(
      decoration: pw.BoxDecoration(
        color: accent,
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(7),
          topRight: pw.Radius.circular(7),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: ink.dir(head),
      ),
    ));

    for (var n = 0; n < m.items.length; n++) {
      final item = m.items[n];
      final cells = <pw.Widget>[];
      for (final c in cols) {
        cells.add(pw.Expanded(flex: c.flex, child: await _cell(c, item)));
        if (c.key == 'price' && _hasDiscount) {
          cells.add(pw.Expanded(
            flex: 2,
            child: item.discount == null
                ? pw.SizedBox()
                : pw.Text(item.discount!,
                    textAlign: _cellEnd,
                    style: pw.TextStyle(fontSize: ink.sz(9), color: _muted)),
          ));
        }
      }
      rows.add(pw.Container(
        decoration: pw.BoxDecoration(
          color: n.isOdd ? tint : PdfColors.white,
          border: pw.Border(
            bottom: pw.BorderSide(
              color: n == m.items.length - 1 ? accent : _line,
              width: n == m.items.length - 1 ? 1.2 : (m.showDividers ? 0.5 : 0),
            ),
          ),
        ),
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: ink.dir(cells),
        ),
      ));
    }
    return rows;
  }

  Future<pw.Widget> _cell(ReceiptColumn c, ReceiptItem item) async {
    switch (c.key) {
      case 'item':
        final sub = <String>[
          if (item.sku != null) '${m.word('sku')} ${item.sku}',
          if (item.barcode != null) item.barcode!,
          for (final b in item.batches)
            [
              if (b.batchNo != null) '${m.word('batch')} ${b.batchNo}',
              if (b.expiry != null) '${m.word('expiry')} ${b.expiry}',
            ].join('  '),
          ...item.extraLines,
        ].where((s) => s.isNotEmpty).toList();
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            if (item.name.isNotEmpty)
              await ink.text(item.name, size: 9.5, bold: true, maxWidth: 260, color: _text),
            for (final s in sub)
              await ink.text(s, size: 7.5, maxWidth: 260, color: _muted),
          ],
        );
      case 'qty':
        return pw.Text(
          '${item.qty ?? ''}${item.unit != null ? ' ${item.unit}' : ''}',
          textAlign: _cellEnd,
          style: pw.TextStyle(fontSize: ink.sz(9.5), color: _text),
        );
      case 'price':
        return pw.Text(item.unitPrice ?? '',
            textAlign: _cellEnd,
            style: pw.TextStyle(fontSize: ink.sz(9.5), color: _text));
      default:
        return pw.Text(item.lineTotal ?? '',
            textAlign: _cellEnd,
            style: pw.TextStyle(
                fontSize: ink.sz(9.5), fontWeight: pw.FontWeight.bold, color: _text));
    }
  }

  // ── tax summary + totals ──

  Future<pw.Widget> _taxCard() async {
    Future<pw.Widget> cell(String t, {bool bold = false, TextAlign align = TextAlign.end}) async =>
        pw.Expanded(
          child: await ink.text(t, size: 8.5, bold: bold, align: align, maxWidth: 90, color: _text),
        );
    final rows = <pw.Widget>[
      pw.Container(
        decoration: pw.BoxDecoration(
          color: tint,
          borderRadius: const pw.BorderRadius.only(
            topLeft: pw.Radius.circular(7),
            topRight: pw.Radius.circular(7),
          ),
        ),
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: ink.dir([
            await cell(m.word('rate'), bold: true, align: TextAlign.start),
            await cell(m.word('taxable'), bold: true),
            await cell(m.word('tax'), bold: true),
          ]),
        ),
      ),
      for (final r in m.taxSummary)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: pw.Row(
            children: ink.dir([
              await cell('${r.label} ${r.rate}', align: TextAlign.start),
              await cell(r.net),
              await cell(r.tax),
            ]),
          ),
        ),
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: await ink.text(m.word('tax_summary'),
              size: 9, bold: true, color: _text, maxWidth: 200),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _line, width: 0.8),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: rows),
        ),
      ],
    );
  }

  Future<pw.Widget> _totalsCard() async {
    final children = <pw.Widget>[];
    for (final t in m.totals) {
      if (t.strong) {
        children.add(pw.Container(
          margin: const pw.EdgeInsets.symmetric(vertical: 4),
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: pw.BoxDecoration(
            color: accent,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: await ink.row(t.label, t.value,
              labelAlt: t.labelAlt,
              size: 12,
              bold: true,
              labelWidth: 150,
              color: _onDark,
              altScale: _alt,
              altInline: true),
        ));
      } else {
        children.add(pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
          child: await ink.row(t.label, t.value,
              labelAlt: t.labelAlt,
              size: 9.5,
              labelWidth: 150,
              color: _text,
              altScale: _alt,
              altInline: true,
              altColor: _muted),
        ));
      }
    }
    if (m.payments.isNotEmpty) {
      children.add(pw.Divider(color: _line, thickness: 0.8, height: 12));
      for (final p in m.payments) {
        children.add(pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: await ink.row(p.label, p.value,
              labelAlt: p.labelAlt,
              size: 9,
              bold: p.strong,
              labelWidth: 150,
              color: _text,
              altScale: _alt,
              altInline: true,
              altColor: _muted),
        ));
      }
    }
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: tint,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: children),
    );
  }

  Future<pw.Widget> _summary() async {
    final left = <pw.Widget>[];
    if (m.taxSummary.isNotEmpty) left.add(await _taxCard());
    if (m.qrContent != null) {
      if (left.isNotEmpty) left.add(pw.SizedBox(height: 12));
      left.add(pw.Align(
        alignment: ink.rtl ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(3),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _line, width: 0.8),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: ReceiptPdfSupport.qr(m.qrContent!, 74),
        ),
      ));
    }
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: ink.dir([
        pw.Expanded(
          flex: 5,
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: left),
        ),
        pw.SizedBox(width: 24),
        pw.Expanded(flex: 4, child: await _totalsCard()),
      ]),
    );
  }

  // ── thank-you bar and page footer ──

  Future<pw.Widget> _thanks() async {
    final onAccent = elegant;
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: pw.BoxDecoration(
        color: onAccent ? accent : tint,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          for (final l in m.footerLines)
            await ink.text(l,
                size: 9.5,
                bold: onAccent,
                align: TextAlign.center,
                color: onAccent ? _onDark : _text),
        ],
      ),
    );
  }

  /// Built once, drawn at the bottom of every page: page number and
  /// "powered by" on one side, the signature line on the other.
  Future<pw.Widget Function(pw.Context)> footer() async {
    final powered = m.poweredBy == null
        ? null
        : await ink.text(m.poweredBy!, size: 7.5, color: _muted, maxWidth: 220);
    final signature = m.signatureLabel == null
        ? null
        : pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(width: 150, height: 0.8, color: _text),
              pw.SizedBox(height: 3),
              await ink.text(m.signatureLabel!,
                  size: 8, align: TextAlign.center, maxWidth: 150, color: _muted),
              if (m.signatureAlt != null)
                await ink.alt(m.signatureAlt!,
                    size: 8, scale: _alt, align: TextAlign.center, maxWidth: 150, color: _muted),
            ],
          );
    return (ctx) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 12),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: ink.dir([
              pw.Column(
                crossAxisAlignment: _start,
                children: [
                  if (powered != null) ...[powered, pw.SizedBox(height: 2)],
                  pw.Text(
                    ctx.pagesCount > 1 ? '${ctx.pageNumber} / ${ctx.pagesCount}' : '',
                    style: pw.TextStyle(fontSize: 7.5, color: _muted),
                  ),
                ],
              ),
              signature ?? pw.SizedBox(),
            ]),
          ),
        );
  }
}
