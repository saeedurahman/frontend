import 'dart:typed_data';

import 'package:flutter/material.dart' show TextAlign;
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

  static Future<pw.Document> build(
    ReceiptModel model, {
    UrduReceiptStyle urduStyle = UrduReceiptStyle.nastaliq,
    pw.ThemeData? theme,
  }) async {
    final resolved = theme ?? await ReceiptPdfSupport.loadFonts();
    final doc = pw.Document(theme: resolved);
    if (model.design.isA4) {
      final ink = _Ink(urduStyle, PdfPageFormat.a4.width - 64, model.fontScale);
      final widgets = await _A4(model, ink).build();
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (_) => widgets,
        ),
      );
      return doc;
    }

    final rollWidth = model.paper.widthMm * PdfPageFormat.mm;
    final printable = rollWidth - _rollMargin.horizontal;
    final ink = _Ink(urduStyle, printable, model.fontScale);
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
  _Ink(this.style, this.width, this.scale);

  final UrduReceiptStyle style;
  final double width;
  final double scale;

  double sz(double base) => base * scale;

  Future<pw.Widget> text(
    String value, {
    double size = 9,
    bool bold = false,
    TextAlign align = TextAlign.left,
    double? maxWidth,
    PdfColor? color,
  }) async {
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

  /// Label on the left (wraps inside [labelWidth]), value on the right.
  Future<pw.Widget> row(
    String label,
    String value, {
    double size = 8.5,
    bool bold = false,
    double? labelWidth,
    PdfColor? color,
  }) async {
    final l = await text(label,
        size: size, bold: bold, maxWidth: labelWidth ?? width * 0.62, color: color);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Flexible(child: l),
        pw.SizedBox(width: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: sz(size),
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
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

  Future<List<pw.Widget>> build() async {
    final out = <pw.Widget>[];
    final h = m.header;

    if (m.isVoid) {
      out.add(await ink.text(m.voidLabel,
          size: 16, bold: true, align: TextAlign.center));
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
          child: await ink.row(r.label, r.value, size: 8),
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
        size: t.strong ? 11 : 8.5,
        bold: t.strong,
      ));
    }
    if (m.taxNote != null) {
      out.add(pw.SizedBox(height: 1));
      out.add(await ink.text(m.taxNote!, size: 7.5, align: TextAlign.center));
    }
    if (m.payments.isNotEmpty) {
      out.add(pw.SizedBox(height: 4));
      for (final p in m.payments) {
        out.add(await ink.row(p.label, p.value, size: 8));
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
          align: ReceiptTextRenderer.hasArabicScript(item.name)
              ? TextAlign.right
              : TextAlign.left,
          maxWidth: compact && item.lineTotal != null ? printable * 0.68 : printable,
        ),
      if (item.nameSecondary != null)
        await ink.text(item.nameSecondary!,
            size: 9, align: TextAlign.right, maxWidth: printable),
    ];

    final oneLine = compact &&
        item.lineTotal != null &&
        (item.qty == null || item.qty == '1') &&
        item.discount == null;
    if (oneLine) {
      children.add(pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Flexible(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: nameBlock)),
          pw.SizedBox(width: 4),
          pw.Text(item.lineTotal!,
              style: pw.TextStyle(fontSize: ink.sz(9), fontWeight: pw.FontWeight.bold)),
        ],
      ));
    } else {
      children.addAll(nameBlock);
    }
    for (final extra in item.extraLines) {
      children.add(pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, top: 0.5),
        child: await ink.text(extra, size: 8),
      ));
    }
    for (final b in item.batches) {
      final text = [
        if (b.batchNo != null) 'Batch ${b.batchNo}',
        if (b.expiry != null) 'Exp ${b.expiry}',
      ].join('  ');
      if (text.isNotEmpty) {
        children.add(pw.Padding(
          padding: const pw.EdgeInsets.only(left: 6, top: 0.5),
          child: await ink.text(text, size: 7.5),
        ));
      }
    }
    if (item.sku != null || item.barcode != null) {
      children.add(pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, top: 0.5),
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
        children: [
          pw.Text(detail, style: pw.TextStyle(fontSize: ink.sz(8.5))),
          if (item.lineTotal != null)
            pw.Text(item.lineTotal!,
                style: pw.TextStyle(fontSize: ink.sz(9), fontWeight: pw.FontWeight.bold)),
        ],
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

class _A4 {
  _A4(this.m, this.ink);

  final ReceiptModel m;
  final _Ink ink;

  bool get elegant => m.design == ReceiptDesign.a4Elegant;
  PdfColor get accent => PdfColor.fromInt(m.accentColor);
  PdfColor get tint => PdfColor(accent.red, accent.green, accent.blue, 0.1);
  PdfColor get tintSolid => PdfColor(
        1 - (1 - accent.red) * 0.12,
        1 - (1 - accent.green) * 0.12,
        1 - (1 - accent.blue) * 0.12,
      );

  Future<List<pw.Widget>> build() async {
    final out = <pw.Widget>[];
    out.add(elegant ? await _elegantHeader() : await _taxHeader());
    out.add(pw.SizedBox(height: 10));
    out.add(await _metaBlock());
    out.add(pw.SizedBox(height: 10));
    out.addAll(await _table());
    out.add(pw.SizedBox(height: 10));
    out.add(await _summary());
    if (m.taxNote != null) {
      out
        ..add(pw.SizedBox(height: 6))
        ..add(await ink.text(m.taxNote!, size: 8.5, align: TextAlign.right));
    }
    if (m.footerLines.isNotEmpty) {
      out.add(pw.SizedBox(height: 14));
      for (final l in m.footerLines) {
        out.add(await ink.text(l, size: 9.5, align: TextAlign.center));
      }
    }
    out.add(pw.SizedBox(height: 16));
    out.add(await _bottom());
    return out;
  }

  Future<pw.Widget> _businessBlock({PdfColor? color}) async {
    final h = m.header;
    final lines = <pw.Widget>[
      if (h.businessName != null)
        await ink.text(h.businessName!, size: 17, bold: true, maxWidth: 300, color: color),
      for (final l in [
        if (h.address != null) h.address!,
        if (h.phone != null) h.phone!,
        if (h.ntnLine != null) h.ntnLine!,
        ...h.extraLines,
      ])
        await ink.text(l, size: 9, maxWidth: 300),
    ];
    final logo = _logo(m, 48);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (logo != null) ...[logo, pw.SizedBox(width: 10)],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: lines,
          ),
        ),
      ],
    );
  }

  Future<pw.Widget> _titleBlock({PdfColor? color}) async {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        await ink.text(m.title,
            size: 20, bold: true, align: TextAlign.right, maxWidth: 220, color: color),
        if (m.isVoid)
          await ink.text(m.voidLabel, size: 14, bold: true, align: TextAlign.right, maxWidth: 220),
      ],
    );
  }

  Future<pw.Widget> _taxHeader() async => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 8),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(width: 1.2)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(flex: 3, child: await _businessBlock()),
            pw.Expanded(flex: 2, child: await _titleBlock()),
          ],
        ),
      );

  Future<pw.Widget> _elegantHeader() async => pw.Container(
        decoration: pw.BoxDecoration(
          color: tintSolid,
          border: pw.Border(left: pw.BorderSide(color: accent, width: 6)),
        ),
        padding: const pw.EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(flex: 3, child: await _businessBlock()),
            pw.Expanded(flex: 2, child: await _titleBlock(color: accent)),
          ],
        ),
      );

  Future<pw.Widget> _metaBlock() async {
    final left = <pw.Widget>[];
    final right = <pw.Widget>[];
    for (var i = 0; i < m.meta.length; i++) {
      final r = m.meta[i];
      final w = pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
        child: await ink.row(r.label, r.value, size: 9, labelWidth: 130),
      );
      (i.isEven ? left : right).add(w);
    }
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(child: pw.Column(children: left)),
        pw.SizedBox(width: 28),
        pw.Expanded(child: pw.Column(children: right)),
      ],
    );
  }

  List<ReceiptColumn> get _cols => m.columns;
  bool get _hasDiscount => m.items.any((i) => i.discount != null);

  Future<List<pw.Widget>> _table() async {
    final rows = <pw.Widget>[];
    final cols = _cols;
    final head = <pw.Widget>[];
    for (final c in cols) {
      head.add(pw.Expanded(
        flex: c.flex,
        child: await ink.text(
          c.label,
          size: 9,
          bold: true,
          align: c.right ? TextAlign.right : TextAlign.left,
          maxWidth: c.flex * 62.0,
        ),
      ));
      if (c.key == 'price' && _hasDiscount) {
        head.add(pw.Expanded(
          flex: 2,
          child: await ink.text('Discount', size: 9, bold: true, align: TextAlign.right, maxWidth: 100),
        ));
      }
    }
    rows.add(pw.Container(
      decoration: pw.BoxDecoration(
        color: elegant ? tintSolid : PdfColors.grey200,
        border: elegant
            ? pw.Border(bottom: pw.BorderSide(color: accent, width: 1.2))
            : null,
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Row(children: head),
    ));

    for (var n = 0; n < m.items.length; n++) {
      final item = m.items[n];
      final cells = <pw.Widget>[];
      for (final c in cols) {
        cells.add(pw.Expanded(
          flex: c.flex,
          child: await _cell(c, item),
        ));
        if (c.key == 'price' && _hasDiscount) {
          cells.add(pw.Expanded(
            flex: 2,
            child: item.discount == null
                ? pw.SizedBox()
                : pw.Text(item.discount!,
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontSize: ink.sz(9))),
          ));
        }
      }
      rows.add(pw.Container(
        decoration: pw.BoxDecoration(
          color: elegant && n.isOdd ? tint : null,
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColors.grey400,
              width: m.showDividers ? 0.5 : 0,
            ),
          ),
        ),
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: cells,
        ),
      ));
    }
    return rows;
  }

  Future<pw.Widget> _cell(ReceiptColumn c, ReceiptItem item) async {
    switch (c.key) {
      case 'item':
        final sub = <String>[
          if (item.sku != null) 'SKU ${item.sku}',
          if (item.barcode != null) item.barcode!,
          for (final b in item.batches)
            [
              if (b.batchNo != null) 'Batch ${b.batchNo}',
              if (b.expiry != null) 'Exp ${b.expiry}',
            ].join('  '),
          ...item.extraLines,
        ].where((s) => s.isNotEmpty).toList();
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            if (item.name.isNotEmpty)
              await ink.text(item.name, size: 9.5, bold: true, maxWidth: 270),
            if (item.nameSecondary != null)
              await ink.text(item.nameSecondary!, size: 9, maxWidth: 270),
            for (final s in sub) await ink.text(s, size: 7.5, maxWidth: 270),
          ],
        );
      case 'qty':
        return pw.Text(
          '${item.qty ?? ''}${item.unit != null ? ' ${item.unit}' : ''}',
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(fontSize: ink.sz(9.5)),
        );
      case 'price':
        return pw.Text(item.unitPrice ?? '',
            textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: ink.sz(9.5)));
      default:
        return pw.Text(item.lineTotal ?? '',
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(fontSize: ink.sz(9.5), fontWeight: pw.FontWeight.bold));
    }
  }

  Future<pw.Widget> _summary() async {
    final totals = <pw.Widget>[];
    for (final t in m.totals) {
      totals.add(pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: await ink.row(
          t.label,
          t.value,
          size: t.strong ? 12 : 9.5,
          bold: t.strong,
          labelWidth: 150,
          color: t.strong && elegant ? accent : null,
        ),
      ));
    }
    for (final p in m.payments) {
      totals.add(pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
        child: await ink.row(p.label, p.value, size: 9, bold: p.strong, labelWidth: 150),
      ));
    }

    final left = <pw.Widget>[];
    if (m.taxSummary.isNotEmpty) {
      left.add(await ink.text('Tax summary', size: 9.5, bold: true));
      left.add(pw.SizedBox(height: 3));
      pw.Widget cell(String t, {bool bold = false}) => pw.Expanded(
            child: pw.Text(t,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: ink.sz(8.5),
                  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                )),
          );
      left.add(pw.Container(
        color: PdfColors.grey200,
        padding: const pw.EdgeInsets.all(3),
        child: pw.Row(children: [
          pw.Expanded(
              child: pw.Text('Rate', style: pw.TextStyle(fontSize: ink.sz(8.5), fontWeight: pw.FontWeight.bold))),
          cell('Taxable', bold: true),
          cell('Tax', bold: true),
        ]),
      ));
      for (final r in m.taxSummary) {
        left.add(pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Row(children: [
            pw.Expanded(
                child: pw.Text('${r.label} ${r.rate}', style: pw.TextStyle(fontSize: ink.sz(8.5)))),
            cell(r.net),
            cell(r.tax),
          ]),
        ));
      }
    }

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(flex: 5, child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: left)),
        pw.SizedBox(width: 24),
        pw.Expanded(
          flex: 4,
          child: pw.Container(
            decoration: elegant
                ? pw.BoxDecoration(
                    border: pw.Border(top: pw.BorderSide(color: accent, width: 1.5)),
                  )
                : null,
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: totals),
          ),
        ),
      ],
    );
  }

  Future<pw.Widget> _bottom() async {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        if (m.qrContent != null)
          ReceiptPdfSupport.qr(m.qrContent!, 78)
        else
          pw.SizedBox(width: 78),
        if (m.poweredBy != null)
          await ink.text(m.poweredBy!, size: 7.5, align: TextAlign.center, maxWidth: 200)
        else
          pw.SizedBox(),
        if (m.signatureLabel != null)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 28),
              pw.Container(width: 150, height: 0.8, color: PdfColors.black),
              pw.SizedBox(height: 3),
              pw.Text(m.signatureLabel!, style: pw.TextStyle(fontSize: ink.sz(8.5))),
            ],
          )
        else
          pw.SizedBox(width: 78),
      ],
    );
  }
}
