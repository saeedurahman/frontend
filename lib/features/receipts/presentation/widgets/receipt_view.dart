import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_support.dart';

/// Draws a [ReceiptModel] on screen as a sheet of paper. It reads exactly the
/// model the PDF and text renderers read, so what the cashier sees is what
/// prints. Used by "Sale completed", the reprint preview and the live preview
/// in the layout editor.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.model, this.maxWidth});

  final ReceiptModel model;

  /// The sheet scales down to fit when narrower than the paper.
  final double? maxWidth;

  /// Paper width in logical pixels (80 mm ~ 302, 58 mm ~ 215, A4 = 595).
  static double paperWidth(ReceiptModel m) {
    if (m.design.isA4) return 595;
    return m.paper == ReceiptPaper.roll58 ? 215 : 302;
  }

  @override
  Widget build(BuildContext context) {
    final width = paperWidth(model);
    final a4 = model.design.isA4;
    final sheet = Container(
      width: width,
      color: Colors.white,
      padding: model.design.isA4
          ? const EdgeInsets.all(32)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          height: 1.25,
          // The fonts the app ships, so the preview looks the same on every
          // computer and Urdu never falls back to boxes.
          // The A4 invoices use Inter, like the A4 PDF.
          fontFamily: a4 ? 'Inter' : 'NotoSans',
          fontFamilyFallback: const ['NotoSans', 'NotoNaskhArabic', 'NotoNastaliqUrdu'],
        ),
        // Urdu receipts read right-to-left: rows, columns and headers mirror.
        child: Directionality(
          textDirection: model.rtl ? TextDirection.rtl : TextDirection.ltr,
          child: model.design.isA4 ? _A4Body(model) : _ThermalBody(model),
        ),
      ),
    );
    final limit = maxWidth;
    final shadowed = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: sheet,
    );
    if (limit != null && limit < width) {
      return SizedBox(
        width: limit,
        child: FittedBox(fit: BoxFit.fitWidth, alignment: Alignment.topCenter, child: shadowed),
      );
    }
    return shadowed;
  }
}

/// The QR code, drawn from the same modules as the PDF.
class ReceiptQrView extends StatelessWidget {
  const ReceiptQrView({super.key, required this.content, this.size = 96});

  final String content;
  final double size;

  @override
  Widget build(BuildContext context) {
    final matrix = ReceiptPdfSupport.qrMatrix(content);
    return Container(
      key: const ValueKey('receipt-qr'),
      width: size,
      height: size,
      color: Colors.white,
      child: CustomPaint(painter: _QrPainter(matrix)),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.matrix);
  final List<List<bool>> matrix;

  @override
  void paint(Canvas canvas, Size size) {
    const quiet = 2;
    final n = matrix.length;
    final unit = size.width / (n + quiet * 2);
    final paint = Paint()..color = Colors.black;
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (!matrix[r][c]) continue;
        canvas.drawRect(
          Rect.fromLTWH((c + quiet) * unit, (r + quiet) * unit, unit + 0.3, unit + 0.3),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.matrix != matrix;
}

Widget? _logo(ReceiptModel m, double height) {
  final bytes = m.header.logoBytes;
  if (bytes == null || bytes.isEmpty) return null;
  return Image.memory(
    Uint8List.fromList(bytes),
    height: height,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
  );
}

TextStyle _t(ReceiptModel m, double size, {bool bold = false, Color? color}) => TextStyle(
      fontSize: size * m.fontScale,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: color ?? Colors.black,
      height: 1.25,
    );

/// The Urdu caption under an English one (both-language receipts only).
class _Alt extends StatelessWidget {
  const _Alt(this.text, this.m, {this.size = 10, this.bold = false, this.color, this.center = false});
  final String? text;
  final ReceiptModel m;
  final double size;
  final bool bold;
  final Color? color;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final t = text;
    if (t == null || t.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: Text(
        t,
        textDirection: TextDirection.rtl,
        textAlign: center ? TextAlign.center : TextAlign.right,
        style: _t(m, size * 0.92, bold: bold, color: color),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, this.m,
      {this.labelAlt, this.size = 12, this.bold = false, this.color});
  final String label;
  final String? labelAlt;
  final String value;
  final ReceiptModel m;
  final double size;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        // A long value (a date, a customer name) may wrap on a narrow roll
        // instead of pushing past the edge of the paper.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, c) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(label, style: _t(m, size, bold: bold, color: color))),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: c.maxWidth * 0.62),
                    // The value sits at the far end: right for English, left
                    // for a right-to-left receipt.
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: _t(m, size, bold: bold, color: color),
                    ),
                  ),
                ],
              ),
            ),
            _Alt(labelAlt, m, size: size, bold: bold, color: color),
          ],
        ),
      );
}

// ── thermal ──────────────────────────────────────────────────────────────

class _ThermalBody extends StatelessWidget {
  const _ThermalBody(this.m);
  final ReceiptModel m;

  Widget get _divider => m.showDividers
      ? Divider(height: m.compactItems ? 8 : 14, thickness: 0.6, color: Colors.black54)
      : SizedBox(height: m.compactItems ? 4 : 8);

  Widget _center(String text, double size, {bool bold = false}) => SizedBox(
        width: double.infinity,
        child: Text(text, textAlign: TextAlign.center, style: _t(m, size, bold: bold)),
      );

  @override
  Widget build(BuildContext context) {
    final h = m.header;
    final logo = _logo(m, 40);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (m.isVoid) ...[
          _center(m.voidLabel, 18, bold: true),
          if (m.voidAlt != null) _Alt(m.voidAlt, m, size: 18, bold: true, center: true),
        ],
        if (logo != null) Center(child: logo),
        if (h.businessName != null) _center(h.businessName!, 16, bold: true),
        for (final l in [
          if (h.address != null) h.address!,
          if (h.phone != null) h.phone!,
          if (h.ntnLine != null) h.ntnLine!,
          ...h.extraLines,
        ])
          _center(l, 10),
        if (m.meta.isNotEmpty) ...[
          _divider,
          for (final r in m.meta) _Row(r.label, r.value, m, labelAlt: r.labelAlt, size: 10),
        ],
        _divider,
        for (final item in m.items) _Item(item, m),
        _divider,
        for (final t in m.totals)
          _Row(t.label, t.value, m,
              labelAlt: t.labelAlt, size: t.strong ? 14 : 11, bold: t.strong),
        if (m.taxNote != null) ...[
          const SizedBox(height: 2),
          _center(m.taxNote!, 9),
          if (m.taxNoteAlt != null) _Alt(m.taxNoteAlt, m, size: 9, center: true),
        ],
        if (m.payments.isNotEmpty) ...[
          const SizedBox(height: 5),
          for (final p in m.payments) _Row(p.label, p.value, m, labelAlt: p.labelAlt, size: 10),
        ],
        if (m.footerLines.isNotEmpty) ...[
          _divider,
          for (final l in m.footerLines) _center(l, 11),
        ],
        if (m.qrContent != null) ...[
          const SizedBox(height: 8),
          Center(child: ReceiptQrView(content: m.qrContent!, size: 110)),
        ],
        if (m.poweredBy != null) ...[
          const SizedBox(height: 6),
          _center(m.poweredBy!, 9),
        ],
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.item, this.m);
  final ReceiptItem item;
  final ReceiptModel m;

  @override
  Widget build(BuildContext context) {
    final unit = item.unit != null ? ' ${item.unit}' : '';
    final detail = [
      if (item.qty != null && item.unitPrice != null)
        '${item.qty}$unit x ${item.unitPrice}'
      else if (item.qty != null)
        'x ${item.qty}$unit'
      else if (item.unitPrice != null)
        item.unitPrice!,
      if (item.discount != null) item.discount!,
    ].join('   ');
    final oneLine = m.compactItems &&
        item.lineTotal != null &&
        (item.qty == null || item.qty == '1') &&
        item.discount == null;

    final names = <Widget>[
      if (item.name.isNotEmpty) Text(item.name, style: _t(m, 12, bold: true)),
    ];
    Widget small(String text) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, top: 1),
          child: Text(text, style: _t(m, 9.5)),
        );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: m.compactItems ? 1.5 : 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (oneLine)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: names)),
                const SizedBox(width: 6),
                Text(item.lineTotal!, style: _t(m, 12, bold: true)),
              ],
            )
          else
            ...names,
          for (final e in item.extraLines) small(e),
          for (final b in item.batches)
            if (b.batchNo != null || b.expiry != null)
              small([
                if (b.batchNo != null) '${m.word('batch')} ${b.batchNo}',
                if (b.expiry != null) '${m.word('expiry')} ${b.expiry}',
              ].join('  ')),
          if (item.sku != null || item.barcode != null)
            small([if (item.sku != null) item.sku!, if (item.barcode != null) item.barcode!].join('  ')),
          if (!oneLine && (detail.isNotEmpty || item.lineTotal != null))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(detail, style: _t(m, 11))),
                  if (item.lineTotal != null)
                    Text(item.lineTotal!, style: _t(m, 12, bold: true)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── A4 ───────────────────────────────────────────────────────────────────

/// Same design as the A4 PDF: banner (elegant) or ruled (tax invoice) header,
/// a details card, a striped item table, tax summary and a totals card with a
/// highlighted Total, a thank-you bar and the signature line.
class _A4Body extends StatelessWidget {
  const _A4Body(this.m);
  final ReceiptModel m;

  static const _text = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFD9DDE3);
  static const _slate = Color(0xFF1F2937);
  static const _soft = Color(0xFFF3F4F6);
  static const _onDarkMuted = Color(0xFFE5E7EB);

  bool get elegant => m.design == ReceiptDesign.a4Elegant;
  Color get accent => elegant ? Color(m.accentColor) : _slate;
  Color get tint => elegant ? Color.lerp(Colors.white, accent, 0.1)! : _soft;

  TextStyle _s(double size, {bool bold = false, Color color = _text}) =>
      _t(m, size, bold: bold, color: color);

  /// The Urdu caption of a both-language receipt: small, under its English
  /// caption, on the reading side of the sheet.
  Widget _caption(String? text, double size, {Color color = _muted, bool bold = false}) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(text, textDirection: TextDirection.rtl, style: _s(size * 0.85, color: color, bold: bold)),
    );
  }

  Widget _business({required Color nameColor, required Color detailColor}) {
    final h = m.header;
    final logo = _logo(m, 46);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo != null)
          Container(
            margin: const EdgeInsetsDirectional.only(end: 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: elegant ? null : Border.all(color: _line, width: 0.8),
            ),
            child: logo,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (h.businessName != null) Text(h.businessName!, style: _s(18, bold: true, color: nameColor)),
              for (final l in [
                if (h.address != null) h.address!,
                if (h.phone != null) h.phone!,
                if (h.ntnLine != null) h.ntnLine!,
                ...h.extraLines,
              ])
                Padding(
                  padding: const EdgeInsets.only(top: 1.5),
                  child: Text(l, style: _s(9, color: detailColor)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _title(Color color) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(m.title.toUpperCase(), style: _s(18, bold: true, color: color)),
          if (m.titleAlt != null)
            Text(m.titleAlt!, textDirection: TextDirection.rtl, style: _s(16, bold: true, color: color)),
          if (m.isVoid) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Text(m.voidLabel, style: _s(11, bold: true, color: Colors.red.shade800)),
            ),
            if (m.voidAlt != null)
              Text(m.voidAlt!, textDirection: TextDirection.rtl, style: _s(11, bold: true, color: color)),
          ],
        ],
      );

  Widget _header() {
    if (elegant) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: _business(nameColor: Colors.white, detailColor: _onDarkMuted),
            ),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: _title(Colors.white)),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: accent, width: 2.2))),
      child: Row(
        children: [
          Expanded(flex: 3, child: _business(nameColor: _text, detailColor: _muted)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(6)),
                child: _title(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaCell(ReceiptMetaRow r) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(r.label, style: _s(8.5, color: _muted)),
          _caption(r.labelAlt, 8.5),
          const SizedBox(height: 1.5),
          Text(r.value, style: _s(10.5, bold: true)),
        ],
      );

  Widget _metaGrid(List<ReceiptMetaRow> rows, int perRow) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rows.length; i += perRow)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var j = i; j < i + perRow; j++)
                    Expanded(child: j < rows.length ? _metaCell(rows[j]) : const SizedBox.shrink()),
                ],
              ),
            ),
        ],
      );

  Widget _details() {
    bool isParty(ReceiptMetaRow r) => r.key == 'customer' || r.key == 'customer_phone';
    final party = m.meta.where(isParty).toList();
    final doc = m.meta.where((r) => !isParty(r)).toList();
    final Widget body;
    if (party.isEmpty || doc.isEmpty) {
      body = _metaGrid(party.isEmpty ? doc : party, 3);
    } else {
      body = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: _metaGrid(doc, 2)),
            Container(
              width: 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              color: _line,
            ),
            Expanded(flex: 2, child: _metaGrid(party, 1)),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: _line, width: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: body,
    );
  }

  bool get _hasDiscount => m.items.any((i) => i.discount != null);

  Widget _table() {
    Widget cell(ReceiptColumn c, Widget child) => Expanded(flex: c.flex, child: child);
    final head = <Widget>[];
    for (final c in m.columns) {
      head.add(cell(
        c,
        Column(
          crossAxisAlignment: c.right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(c.label,
                textAlign: c.right ? TextAlign.end : TextAlign.start,
                style: _s(9.5, bold: true, color: Colors.white)),
            if (c.labelAlt != null)
              Text(c.labelAlt!,
                  textDirection: TextDirection.rtl, style: _s(8.5, bold: true, color: Colors.white)),
          ],
        ),
      ));
      if (c.key == 'price' && _hasDiscount) {
        head.add(Expanded(
          flex: 2,
          child: Text(m.word('discount'),
              textAlign: TextAlign.end, style: _s(9.5, bold: true, color: Colors.white)),
        ));
      }
    }
    final rows = <Widget>[
      Container(
        decoration: BoxDecoration(
          color: accent,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: head),
      ),
    ];
    for (var n = 0; n < m.items.length; n++) {
      final item = m.items[n];
      final last = n == m.items.length - 1;
      final cells = <Widget>[];
      for (final c in m.columns) {
        cells.add(cell(c, _cellFor(c, item)));
        if (c.key == 'price' && _hasDiscount) {
          cells.add(Expanded(
            flex: 2,
            child: Text(item.discount ?? '',
                textAlign: TextAlign.end, style: _s(10, color: _muted)),
          ));
        }
      }
      rows.add(Container(
        decoration: BoxDecoration(
          color: n.isOdd ? tint : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: last ? accent : _line,
              width: last ? 1.2 : (m.showDividers ? 0.5 : 0),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
      ));
    }
    return Column(children: rows);
  }

  Widget _cellFor(ReceiptColumn c, ReceiptItem item) {
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
        ].where((s) => s.isNotEmpty);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.name.isNotEmpty) Text(item.name, style: _s(10.5, bold: true)),
            for (final s in sub) Text(s, style: _s(8.5, color: _muted)),
          ],
        );
      case 'qty':
        return Text('${item.qty ?? ''}${item.unit != null ? ' ${item.unit}' : ''}',
            textAlign: TextAlign.end, style: _s(10.5));
      case 'price':
        return Text(item.unitPrice ?? '', textAlign: TextAlign.end, style: _s(10.5));
      default:
        return Text(item.lineTotal ?? '', textAlign: TextAlign.end, style: _s(10.5, bold: true));
    }
  }

  Widget _taxCard() {
    Widget row(String a, String b, String c, {bool bold = false, Color? fill}) => Container(
          color: fill,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(children: [
            Expanded(child: Text(a, style: _s(9.5, bold: bold))),
            Expanded(child: Text(b, textAlign: TextAlign.end, style: _s(9.5, bold: bold))),
            Expanded(child: Text(c, textAlign: TextAlign.end, style: _s(9.5, bold: bold))),
          ]),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(m.word('tax_summary'), style: _s(10, bold: true)),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: _line, width: 0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              row(m.word('rate'), m.word('taxable'), m.word('tax'), bold: true, fill: tint),
              for (final r in m.taxSummary) row('${r.label} ${r.rate}', r.net, r.tax),
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalsCard() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final t in m.totals)
              if (t.strong)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(6)),
                  child: _Row(t.label, t.value, m,
                      labelAlt: t.labelAlt, size: 13, bold: true, color: Colors.white),
                )
              else
                _Row(t.label, t.value, m, labelAlt: t.labelAlt, size: 10.5),
            if (m.payments.isNotEmpty) ...[
              const Divider(color: _line, thickness: 0.8, height: 12),
              for (final p in m.payments)
                _Row(p.label, p.value, m, labelAlt: p.labelAlt, size: 10, bold: p.strong),
            ],
          ],
        ),
      );

  Widget _summary() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (m.taxSummary.isNotEmpty) _taxCard(),
                if (m.taxSummary.isNotEmpty && m.qrContent != null) const SizedBox(height: 12),
                if (m.qrContent != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: _line, width: 0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ReceiptQrView(content: m.qrContent!, size: 74),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(flex: 4, child: _totalsCard()),
        ],
      );

  Widget _thanks() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: elegant ? accent : tint,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            for (final l in m.footerLines)
              Text(l,
                  textAlign: TextAlign.center,
                  style: _s(10.5, bold: elegant, color: elegant ? Colors.white : _text)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 12),
        if (m.meta.isNotEmpty) ...[
          _details(),
          const SizedBox(height: 12),
        ],
        _table(),
        const SizedBox(height: 14),
        _summary(),
        if (m.taxNote != null) ...[
          const SizedBox(height: 6),
          Text(m.taxNote!, textAlign: TextAlign.end, style: _s(9, color: _muted)),
          if (m.taxNoteAlt != null) _Alt(m.taxNoteAlt, m, size: 9, color: _muted),
        ],
        if (m.footerLines.isNotEmpty) ...[
          const SizedBox(height: 14),
          _thanks(),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (m.poweredBy != null)
              Text(m.poweredBy!, style: _s(8.5, color: _muted))
            else
              const SizedBox.shrink(),
            if (m.signatureLabel != null)
              Column(
                children: [
                  const SizedBox(height: 22),
                  Container(width: 150, height: 0.8, color: _text),
                  const SizedBox(height: 3),
                  Text(m.signatureLabel!, style: _s(9, color: _muted)),
                  if (m.signatureAlt != null)
                    Text(m.signatureAlt!,
                        textDirection: TextDirection.rtl, style: _s(8.5, color: _muted)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
