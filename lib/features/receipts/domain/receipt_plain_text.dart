import 'package:frantend/features/receipts/domain/receipt_model.dart';

/// Plain-text receipt for WhatsApp messages and "copy" (no images, no fonts).
abstract final class ReceiptPlainText {
  static const _rule = '--------------------------------';

  static String render(ReceiptModel m) {
    final out = StringBuffer();
    void line(String text) => out.writeln(text);

    if (m.header.businessName != null) line('*${m.header.businessName}*');
    for (final l in [
      if (m.header.address != null) m.header.address!,
      if (m.header.phone != null) m.header.phone!,
      if (m.header.ntnLine != null) m.header.ntnLine!,
      ...m.header.extraLines,
    ]) {
      line(l);
    }
    if (m.isVoid) line('*${m.voidLabel}*');

    if (m.meta.isNotEmpty) {
      line(_rule);
      for (final r in m.meta) {
        line('${r.label}: ${r.value}');
      }
    }

    line(_rule);
    for (final i in m.items) {
      final name = [
        if (i.name.isNotEmpty) i.name,
        if (i.nameSecondary != null) i.nameSecondary!,
      ].join(' / ');
      final parts = <String>[
        if (i.qty != null && i.unitPrice != null) '${i.qty} x ${i.unitPrice}'
        else if (i.qty != null) 'x ${i.qty}'
        else if (i.unitPrice != null) i.unitPrice!,
        if (i.discount != null) i.discount!,
      ];
      final amount = i.lineTotal;
      final detail = [
        if (parts.isNotEmpty) parts.join('  '),
        if (amount != null) '= $amount',
      ].join(' ');
      line(name.isEmpty ? detail : (detail.isEmpty ? name : '$name: $detail'));
      for (final extra in i.extraLines) {
        line('   $extra');
      }
      for (final b in i.batches) {
        final bits = [
          if (b.batchNo != null) 'Batch ${b.batchNo}',
          if (b.expiry != null) 'Exp ${b.expiry}',
        ];
        if (bits.isNotEmpty) line('   ${bits.join(' · ')}');
      }
    }

    line(_rule);
    for (final t in m.totals) {
      line(t.strong ? '*${t.label}: ${t.value}*' : '${t.label}: ${t.value}');
    }
    if (m.taxNote != null) line(m.taxNote!);
    for (final p in m.payments) {
      line('${p.label}: ${p.value}');
    }

    if (m.footerLines.isNotEmpty) {
      line(_rule);
      m.footerLines.forEach(line);
    }
    if (m.qrContent != null) line(m.qrContent!);
    if (m.poweredBy != null) line(m.poweredBy!);
    return out.toString().trim();
  }
}
