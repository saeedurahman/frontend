import 'package:frantend/features/receipts/domain/receipt_model.dart';

/// Plain-text receipt for WhatsApp messages and "copy" (no images, no fonts).
///
/// One language per receipt, like every other renderer: an English receipt
/// has no Urdu captions, an Urdu receipt starts every line with a
/// right-to-left mark so WhatsApp lays it out right-to-left, and a
/// both-language receipt adds the Urdu caption on a second line under the
/// English one.
abstract final class ReceiptPlainText {
  static const _rule = '--------------------------------';

  /// Right-to-left mark: makes a whole line read right-to-left.
  static const rlm = '‏';

  static String render(ReceiptModel m) {
    final out = StringBuffer();
    final rtl = m.rtl;
    void line(String text) => out.writeln(rtl && text.isNotEmpty ? '$rlm$text' : text);
    // The Urdu caption under an English one (both-language receipts).
    void alt(String? text) {
      if (text != null && text.isNotEmpty) out.writeln('$rlm   $text');
    }

    if (m.header.businessName != null) line('*${m.header.businessName}*');
    for (final l in [
      if (m.header.address != null) m.header.address!,
      if (m.header.phone != null) m.header.phone!,
      if (m.header.ntnLine != null) m.header.ntnLine!,
      ...m.header.extraLines,
    ]) {
      line(l);
    }
    if (m.isVoid) {
      line('*${m.voidLabel}*');
      alt(m.voidAlt);
    }

    if (m.meta.isNotEmpty) {
      line(_rule);
      for (final r in m.meta) {
        line('${r.label}: ${r.value}');
        alt(r.labelAlt);
      }
    }

    line(_rule);
    for (final i in m.items) {
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
      line(i.name.isEmpty
          ? detail
          : (detail.isEmpty ? i.name : '${i.name}: $detail'));
      for (final extra in i.extraLines) {
        line('   $extra');
      }
      for (final b in i.batches) {
        final bits = [
          if (b.batchNo != null) '${m.word('batch')} ${b.batchNo}',
          if (b.expiry != null) '${m.word('expiry')} ${b.expiry}',
        ];
        if (bits.isNotEmpty) line('   ${bits.join(' · ')}');
      }
    }

    line(_rule);
    for (final t in m.totals) {
      line(t.strong ? '*${t.label}: ${t.value}*' : '${t.label}: ${t.value}');
      alt(t.labelAlt);
    }
    if (m.taxNote != null) {
      line(m.taxNote!);
      alt(m.taxNoteAlt);
    }
    for (final p in m.payments) {
      line('${p.label}: ${p.value}');
      alt(p.labelAlt);
    }

    if (m.footerLines.isNotEmpty) {
      line(_rule);
      m.footerLines.forEach(line);
    }
    if (m.qrContent != null) out.writeln(m.qrContent!);
    if (m.poweredBy != null) line(m.poweredBy!);
    return out.toString().trim();
  }
}
