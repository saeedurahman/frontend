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
    final sheet = Container(
      width: width,
      color: Colors.white,
      padding: model.design.isA4
          ? const EdgeInsets.all(32)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          height: 1.25,
          // The fonts the app ships, so the preview looks the same on every
          // computer and Urdu never falls back to boxes.
          fontFamily: 'NotoSans',
          fontFamilyFallback: ['NotoNaskhArabic', 'NotoNastaliqUrdu'],
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

class _A4Body extends StatelessWidget {
  const _A4Body(this.m);
  final ReceiptModel m;

  bool get elegant => m.design == ReceiptDesign.a4Elegant;
  Color get accent => Color(m.accentColor);
  Color get tint => accent.withValues(alpha: 0.10);

  Widget _business() {
    final h = m.header;
    final logo = _logo(m, 52);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (logo != null) ...[logo, const SizedBox(width: 10)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (h.businessName != null) Text(h.businessName!, style: _t(m, 18, bold: true)),
              for (final l in [
                if (h.address != null) h.address!,
                if (h.phone != null) h.phone!,
                if (h.ntnLine != null) h.ntnLine!,
                ...h.extraLines,
              ])
                Text(l, style: _t(m, 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _title() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(m.title, style: _t(m, 22, bold: true, color: elegant ? accent : null)),
          if (m.titleAlt != null)
            Text(m.titleAlt!,
                textDirection: TextDirection.rtl,
                style: _t(m, 18, bold: true, color: elegant ? accent : null)),
          if (m.isVoid) Text(m.voidLabel, style: _t(m, 15, bold: true)),
          if (m.voidAlt != null)
            Text(m.voidAlt!, textDirection: TextDirection.rtl, style: _t(m, 13, bold: true)),
        ],
      );

  Widget _header() => Container(
        padding: elegant
            ? const EdgeInsetsDirectional.fromSTEB(14, 12, 12, 12)
            : const EdgeInsets.only(bottom: 8),
        decoration: elegant
            ? BoxDecoration(
                color: tint,
                border: BorderDirectional(start: BorderSide(color: accent, width: 6)),
              )
            : const BoxDecoration(border: Border(bottom: BorderSide(width: 1.2))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _business()),
            Expanded(flex: 2, child: _title()),
          ],
        ),
      );

  Widget _meta() {
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < m.meta.length; i++) {
      final r = m.meta[i];
      (i.isEven ? left : right).add(_Row(r.label, r.value, m, labelAlt: r.labelAlt, size: 10));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: left)),
        const SizedBox(width: 28),
        Expanded(child: Column(children: right)),
      ],
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
                style: _t(m, 10, bold: true)),
            if (c.labelAlt != null)
              Text(c.labelAlt!,
                  textDirection: TextDirection.rtl, style: _t(m, 9, bold: true)),
          ],
        ),
      ));
      if (c.key == 'price' && _hasDiscount) {
        head.add(Expanded(
          flex: 2,
          child: Text(m.word('discount'), textAlign: TextAlign.end, style: _t(m, 10, bold: true)),
        ));
      }
    }
    final rows = <Widget>[
      Container(
        color: elegant ? tint : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Row(children: head),
      ),
    ];
    for (var n = 0; n < m.items.length; n++) {
      final item = m.items[n];
      final cells = <Widget>[];
      for (final c in m.columns) {
        cells.add(cell(c, _cellFor(c, item)));
        if (c.key == 'price' && _hasDiscount) {
          cells.add(Expanded(
            flex: 2,
            child: Text(item.discount ?? '',
                textAlign: TextAlign.end, style: _t(m, 10)),
          ));
        }
      }
      rows.add(Container(
        decoration: BoxDecoration(
          color: elegant && n.isOdd ? tint : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade500,
              width: m.showDividers ? 0.5 : 0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
            if (item.name.isNotEmpty) Text(item.name, style: _t(m, 10.5, bold: true)),
            for (final s in sub) Text(s, style: _t(m, 8.5)),
          ],
        );
      case 'qty':
        return Text('${item.qty ?? ''}${item.unit != null ? ' ${item.unit}' : ''}',
            textAlign: TextAlign.end, style: _t(m, 10.5));
      case 'price':
        return Text(item.unitPrice ?? '', textAlign: TextAlign.end, style: _t(m, 10.5));
      default:
        return Text(item.lineTotal ?? '',
            textAlign: TextAlign.end, style: _t(m, 10.5, bold: true));
    }
  }

  Widget _summary() {
    Widget tax(String a, String b, String c, {bool bold = false}) => Padding(
          padding: const EdgeInsets.all(3),
          child: Row(children: [
            Expanded(child: Text(a, style: _t(m, 9.5, bold: bold))),
            Expanded(child: Text(b, textAlign: TextAlign.end, style: _t(m, 9.5, bold: bold))),
            Expanded(child: Text(c, textAlign: TextAlign.end, style: _t(m, 9.5, bold: bold))),
          ]),
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: m.taxSummary.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(m.word('tax_summary'), style: _t(m, 10.5, bold: true)),
                    const SizedBox(height: 3),
                    Container(
                        color: Colors.grey.shade300,
                        child: tax(m.word('rate'), m.word('taxable'), m.word('tax'), bold: true)),
                    for (final r in m.taxSummary) tax('${r.label} ${r.rate}', r.net, r.tax),
                  ],
                ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            decoration: elegant
                ? BoxDecoration(border: Border(top: BorderSide(color: accent, width: 1.5)))
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final t in m.totals)
                  _Row(t.label, t.value, m,
                      labelAlt: t.labelAlt,
                      size: t.strong ? 13 : 10.5,
                      bold: t.strong,
                      color: t.strong && elegant ? accent : null),
                for (final p in m.payments)
                  _Row(p.label, p.value, m, labelAlt: p.labelAlt, size: 10, bold: p.strong),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 10),
        _meta(),
        const SizedBox(height: 10),
        _table(),
        const SizedBox(height: 10),
        _summary(),
        if (m.taxNote != null) ...[
          const SizedBox(height: 6),
          Text(m.taxNote!, textAlign: TextAlign.end, style: _t(m, 9.5)),
          if (m.taxNoteAlt != null) _Alt(m.taxNoteAlt, m, size: 9.5),
        ],
        if (m.footerLines.isNotEmpty) ...[
          const SizedBox(height: 14),
          for (final l in m.footerLines)
            Text(l, textAlign: TextAlign.center, style: _t(m, 10.5)),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            m.qrContent != null
                ? ReceiptQrView(content: m.qrContent!, size: 78)
                : const SizedBox(width: 78),
            if (m.poweredBy != null)
              Text(m.poweredBy!, textAlign: TextAlign.center, style: _t(m, 8.5))
            else
              const SizedBox.shrink(),
            if (m.signatureLabel != null)
              Column(
                children: [
                  const SizedBox(height: 28),
                  Container(width: 150, height: 0.8, color: Colors.black),
                  const SizedBox(height: 3),
                  Text(m.signatureLabel!, style: _t(m, 9.5)),
                  if (m.signatureAlt != null)
                    Text(m.signatureAlt!,
                        textDirection: TextDirection.rtl, style: _t(m, 9)),
                ],
              )
            else
              const SizedBox(width: 78),
          ],
        ),
      ],
    );
  }
}
