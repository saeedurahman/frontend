import 'package:frantend/features/receipts/domain/receipt_layout.dart';

/// The neutral receipt: every renderer (thermal PDF, A4 PDF, plain text, the
/// on-screen preview) draws exactly this and decides nothing itself. All
/// texts are final (money formatted, switches applied), so two renderers can
/// never disagree about what a receipt says.
class ReceiptModel {
  const ReceiptModel({
    required this.channel,
    required this.layoutId,
    required this.layoutName,
    required this.design,
    required this.paper,
    required this.fontScale,
    required this.showDividers,
    required this.compactItems,
    required this.title,
    required this.header,
    required this.meta,
    required this.columns,
    required this.items,
    required this.totals,
    required this.taxSummary,
    required this.payments,
    required this.footerLines,
    this.language = ReceiptLanguage.en,
    this.words = const {},
    this.isVoid = false,
    this.voidLabel = '',
    this.poweredBy,
    this.taxNote,
    this.qrContent,
    this.notes,
    this.accentColor = 0xFF0F6B36,
    this.signatureLabel,
    this.titleAlt,
    this.voidAlt,
    this.taxNoteAlt,
    this.signatureAlt,
  });

  final ReceiptChannel channel;
  final String layoutId;
  final String layoutName;
  final ReceiptDesign design;
  final ReceiptPaper paper;
  final double fontScale;
  final bool showDividers;
  final bool compactItems;

  /// The one language every caption is written in. `both` adds a second
  /// (Urdu) line under each caption: see the `*Alt` fields and `labelAlt`.
  final ReceiptLanguage language;

  /// Small captions the renderers print themselves (batch, expiry, SKU,
  /// discount, tax summary headings...), already in [language].
  final Map<String, String> words;

  /// "Receipt", "Tax Invoice" ...
  final String title;
  final String? titleAlt;
  final String? voidAlt;
  final String? taxNoteAlt;
  final String? signatureAlt;
  final bool isVoid;
  final String voidLabel;
  final ReceiptHeader header;
  final List<ReceiptMetaRow> meta;

  /// Column captions of the item table (A4 designs).
  final List<ReceiptColumn> columns;
  final List<ReceiptItem> items;
  final List<ReceiptTotalRow> totals;

  /// Tax by rate (A4 tax invoice summary).
  final List<ReceiptTaxRow> taxSummary;
  final List<ReceiptTotalRow> payments;
  final List<String> footerLines;
  final String? poweredBy;

  /// "Prices include tax" (bilingual), when the sale's prices include tax.
  final String? taxNote;

  /// Public receipt link to draw as a QR code; null = no QR at all.
  final String? qrContent;
  final String? notes;

  /// ARGB colour of the A4 elegant banner.
  final int accentColor;

  /// Caption above the signature line (A4 tax invoice only).
  final String? signatureLabel;

  bool get isThermal => design.isThermal;

  /// Urdu-only receipts are laid out right-to-left (labels and values
  /// mirrored); English and both-language receipts stay left-to-right.
  bool get rtl => language.isRtl;

  bool get isBoth => language.isBoth;

  String word(String key) => words[key] ?? key;

  /// Every visible text in reading order (used by tests and plain text).
  Iterable<String> get allTexts sync* {
    yield title;
    if (titleAlt != null) yield titleAlt!;
    yield* header.lines;
    for (final m in meta) {
      yield '${m.label}: ${m.value}';
      if (m.labelAlt != null) yield m.labelAlt!;
    }
    for (final i in items) {
      yield i.name;
    }
    for (final t in totals) {
      yield '${t.label}: ${t.value}';
      if (t.labelAlt != null) yield t.labelAlt!;
    }
    for (final p in payments) {
      yield '${p.label}: ${p.value}';
      if (p.labelAlt != null) yield p.labelAlt!;
    }
    if (taxNote != null) yield taxNote!;
    if (taxNoteAlt != null) yield taxNoteAlt!;
    yield* footerLines;
    if (poweredBy != null) yield poweredBy!;
  }
}

class ReceiptHeader {
  const ReceiptHeader({
    this.logoUrl,
    this.logoBytes,
    this.businessName,
    this.address,
    this.phone,
    this.ntnLabel,
    this.ntnValue,
    this.extraLines = const [],
  });

  final String? logoUrl;
  final List<int>? logoBytes;
  final String? businessName;
  final String? address;

  /// "Tel: 0300..." style text is built by the builder.
  final String? phone;
  final String? ntnLabel;
  final String? ntnValue;
  final List<String> extraLines;

  String? get ntnLine => ntnValue == null ? null : '$ntnLabel: $ntnValue';

  Iterable<String> get lines => [
        if (businessName != null) businessName!,
        if (address != null) address!,
        if (phone != null) phone!,
        if (ntnLine != null) ntnLine!,
        ...extraLines,
      ];
}

class ReceiptMetaRow {
  const ReceiptMetaRow(this.key, this.label, this.value, {this.labelAlt});
  final String key;
  final String label;
  final String value;

  /// Urdu caption under [label] (`both` receipts only).
  final String? labelAlt;
}

class ReceiptColumn {
  const ReceiptColumn(this.key, this.label, {this.flex = 1, this.right = false, this.labelAlt});
  final String key;
  final String label;
  final String? labelAlt;
  final int flex;
  final bool right;
}

class ReceiptBatchLine {
  const ReceiptBatchLine({this.batchNo, this.expiry, this.qty});
  final String? batchNo;

  /// `MM/YYYY`.
  final String? expiry;
  final String? qty;
}

class ReceiptItem {
  const ReceiptItem({
    required this.name,
    this.sku,
    this.barcode,
    this.unit,
    this.qty,
    this.unitPrice,
    this.discount,
    this.lineTotal,
    this.batches = const [],
    this.extraLines = const [],
  });

  final String name;
  final String? sku;
  final String? barcode;
  final String? unit;

  /// Already formatted; null when the layout hides it.
  final String? qty;
  final String? unitPrice;
  final String? discount;
  final String? lineTotal;
  final List<ReceiptBatchLine> batches;

  /// Modifiers and the kitchen note.
  final List<String> extraLines;
}

class ReceiptTotalRow {
  const ReceiptTotalRow(this.key, this.label, this.value, {this.strong = false, this.labelAlt});
  final String key;
  final String label;
  final String? labelAlt;
  final String value;
  final bool strong;
}

class ReceiptTaxRow {
  const ReceiptTaxRow({
    required this.label,
    required this.rate,
    required this.net,
    required this.tax,
  });
  final String label;
  final String rate;
  final String net;
  final String tax;
}
