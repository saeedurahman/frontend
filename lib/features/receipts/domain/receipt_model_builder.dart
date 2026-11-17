import 'package:decimal/decimal.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/utils/receipt_totals.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';
import 'package:intl/intl.dart';

/// Turns a sale + a layout + a channel into the neutral [ReceiptModel].
///
/// This is where every receipt rule lives, once, for every channel:
///  * internal text ("pending sync", badges) never reaches a receipt;
///  * ONE receipt number, chosen by `meta.number_source`;
///  * item name = the product name; the variation only when it says something;
///  * quantities without decimals unless the unit allows them;
///  * NTN = the business tax id with the layout's label (never a tax rate);
///  * tax, rounding and "prices include tax" come from the sale snapshot only;
///  * the QR code only for a synced sale that has a public link.
abstract final class ReceiptModelBuilder {
  static ReceiptModel build(
    SaleResponseModel sale,
    ReceiptLayout layout,
    ReceiptChannel channel, {
    ReceiptContext context = const ReceiptContext(),
    DateTime? now,
  }) {
    final c = layout.config;
    final design = layout.design;
    final isLink = channel == ReceiptChannel.link;
    final lang = _Words(c);
    String label(String key) => lang.label(key);

    final titleKey = context.isReturn
        ? 'return'
        : switch (design) {
            ReceiptDesign.a4TaxInvoice => 'tax_invoice',
            ReceiptDesign.a4Elegant => 'invoice',
            _ => 'receipt',
          };

    final totals = _totals(sale, layout, context, isLink, lang);
    final footer = c.footer;
    final footerLines = footer.linesFor(lang.language);

    final qr = _qrContent(layout, channel, context);
    final inclusiveNote = totals.pricesIncludeTax && c.totals.showIncludesTaxNote;

    return ReceiptModel(
      channel: channel,
      layoutId: layout.id,
      layoutName: layout.name,
      design: design,
      paper: layout.paper,
      fontScale: c.style.fontScale,
      showDividers: c.style.showDividers,
      compactItems: c.style.compactItems || design == ReceiptDesign.thermalCompact,
      language: lang.language,
      words: lang.words,
      title: label(titleKey),
      titleAlt: lang.alt(titleKey),
      isVoid: sale.saleStatus == 'voided',
      voidLabel: label('void'),
      voidAlt: lang.alt('void'),
      header: _header(sale, layout, context, lang),
      meta: _meta(sale, layout, context, isLink, lang, now),
      columns: _columns(layout, lang),
      items: [for (final line in sale.lines) _item(line, sale, layout, context)],
      totals: totals.rows,
      taxSummary: _taxSummary(sale, layout, lang),
      payments: _payments(sale, layout, lang),
      taxNote: inclusiveNote ? label('includes_tax') : null,
      taxNoteAlt: inclusiveNote ? lang.alt('includes_tax') : null,
      footerLines: footerLines,
      poweredBy: footer.showPoweredBy ? AppBrand.current.receiptPoweredBy : null,
      qrContent: qr,
      notes: null,
      accentColor: context.accentColor ?? 0xFF0F6B36,
      signatureLabel: design == ReceiptDesign.a4TaxInvoice ? label('signature') : null,
      signatureAlt: design == ReceiptDesign.a4TaxInvoice ? lang.alt('signature') : null,
    );
  }

  // ── header ────────────────────────────────────────────────────────────

  static ReceiptHeader _header(
    SaleResponseModel sale,
    ReceiptLayout layout,
    ReceiptContext ctx,
    _Words lang,
  ) {
    final h = layout.config.header;
    final b = ctx.business;
    String? clean(String? v) {
      final t = v?.trim();
      return t == null || t.isEmpty ? null : t;
    }

    final ntn = h.showNtn ? ReceiptRules.ntnOrNull(b.taxId, taxLabel: sale.taxLabel) : null;
    final phone = h.showPhone ? clean(b.phone) : null;
    return ReceiptHeader(
      logoUrl: h.showLogo ? clean(b.logoUrl) : null,
      logoBytes: h.showLogo ? b.logoBytes : null,
      businessName: h.showBusinessName ? (clean(b.name) ?? AppBrand.current.appName) : null,
      address: h.showAddress ? clean(b.address) : null,
      // A left-to-right mark keeps "0423-1234567" in one piece after an Urdu
      // caption (otherwise the bidi rules flip its two halves).
      phone: phone == null
          ? null
          : '${lang.label('customer_phone')}: ${layout.config.language.isRtl ? '‎' : ''}$phone',
      ntnLabel: ntn == null ? null : (clean(h.ntnLabel) ?? 'NTN'),
      ntnValue: ntn,
      extraLines: [
        for (final l in h.extraLines)
          if (l.trim().isNotEmpty) l.trim(),
      ],
    );
  }

  // ── meta ──────────────────────────────────────────────────────────────

  static List<ReceiptMetaRow> _meta(
    SaleResponseModel sale,
    ReceiptLayout layout,
    ReceiptContext ctx,
    bool isLink,
    _Words lang,
    DateTime? now,
  ) {
    final m = layout.config.meta;
    ReceiptMetaRow row(String key, String value) =>
        ReceiptMetaRow(key, lang.label(key), value, labelAlt: lang.alt(key));
    final rows = <ReceiptMetaRow>[];
    if (m.showNumber) {
      final number = ReceiptRules.pickNumber(
        source: m.numberSource,
        register: ctx.registerNumber ?? sale.clientReceiptNo,
        official: ctx.officialNumber,
        fallback: sale.saleNumber ?? (sale.id.length > 8 ? sale.id.substring(0, 8) : sale.id),
      );
      rows.add(row('number', number));
    }
    if (m.showDatetime) {
      final raw = sale.soldAt ?? sale.createdAt;
      final parsed = raw == null ? null : DateTime.tryParse(raw);
      final value = parsed != null
          ? DateFormat.yMMMd().add_jm().format(parsed.toLocal())
          : DateFormat.yMMMd().add_jm().format(now ?? DateTime.now());
      rows.add(row('date', value));
    }
    // The public link never shows people or balances.
    if (!isLink && m.showCashier && _has(ctx.cashierName)) {
      rows.add(row('cashier', ctx.cashierName!.trim()));
    }
    if (m.showBranch && _has(ctx.branchName)) {
      rows.add(row('branch', ctx.branchName!.trim()));
    }
    if (m.showRegister && _has(ctx.registerName)) {
      rows.add(row('register', ctx.registerName!.trim()));
    }
    if (!isLink && m.showCustomer) {
      final name = sale.customer?.name.trim() ?? '';
      if (name.isNotEmpty) {
        rows.add(row('customer', name));
      } else if (m.walkinLabel.trim().isNotEmpty) {
        rows.add(row('customer', lang.walkin(m.walkinLabel)));
      }
      final phone = ctx.customerPhone ?? sale.customer?.phone;
      if (m.showCustomerPhone && _has(phone) && name.isNotEmpty) {
        rows.add(row('customer_phone', phone!.trim()));
      }
    }
    return rows;
  }

  static bool _has(String? v) => v != null && v.trim().isNotEmpty;

  // ── items ─────────────────────────────────────────────────────────────

  static List<ReceiptColumn> _columns(ReceiptLayout layout, _Words lang) {
    final i = layout.config.items;
    ReceiptColumn col(String key, int flex, {bool right = false}) =>
        ReceiptColumn(key, lang.label(key), flex: flex, right: right, labelAlt: lang.alt(key));
    return [
      if (i.showName) col('item', 5),
      if (i.showQty) col('qty', 1, right: true),
      if (i.showUnitPrice) col('price', 2, right: true),
      if (i.showLineTotal) col('amount', 2, right: true),
    ];
  }

  static ReceiptItem _item(
    SaleLineModel line,
    SaleResponseModel sale,
    ReceiptLayout layout,
    ReceiptContext ctx,
  ) {
    final i = layout.config.items;
    final info = ctx.products[line.productId];
    // Product names print exactly as they were entered.
    final name = ReceiptRules.itemName(
      line.productName,
      showVariation: i.showVariation,
      variationName: line.variationName,
    );

    final discount = DecimalUtils.parse(line.discountAmount);
    final qty = ReceiptRules.formatQty(line.qty, allowsDecimal: info?.allowsDecimal ?? false);
    final batches = (i.showBatch || i.showExpiry)
        ? [
            for (final b in line.batches)
              ReceiptBatchLine(
                batchNo: i.showBatch && _has(b.batchNo) ? b.batchNo!.trim() : null,
                expiry: i.showExpiry ? ReceiptRules.expiryText(b.expiryDate) : null,
                qty: ReceiptRules.formatQty(b.qty, allowsDecimal: info?.allowsDecimal ?? false),
              ),
          ].where((b) => b.batchNo != null || b.expiry != null).toList()
        : const <ReceiptBatchLine>[];

    return ReceiptItem(
      name: i.showName ? name : '',
      sku: i.showSku && _has(info?.sku) ? info!.sku!.trim() : null,
      barcode: i.showBarcode && _has(info?.barcode) ? info!.barcode!.trim() : null,
      unit: i.showUnit && _has(info?.unitSymbol) ? info!.unitSymbol!.trim() : null,
      qty: i.showQty ? qty : null,
      unitPrice: i.showUnitPrice ? formatPKR(DecimalUtils.parse(line.unitPrice)) : null,
      discount: i.showLineDiscount && discount > Decimal.zero
          ? '-${formatPKR(discount)}'
          : null,
      lineTotal: i.showLineTotal
          ? formatPKR(SaleCalculations.lineTotal(line, inclusive: sale.taxInclusive))
          : null,
      batches: batches,
      extraLines: [
        ...SaleLineDisplay.modifierLabels(line),
        if (_has(SaleLineDisplay.note(line))) SaleLineDisplay.note(line)!.trim(),
      ],
    );
  }

  // ── totals ────────────────────────────────────────────────────────────

  static ({List<ReceiptTotalRow> rows, bool pricesIncludeTax}) _totals(
    SaleResponseModel sale,
    ReceiptLayout layout,
    ReceiptContext ctx,
    bool isLink,
    _Words lang,
  ) {
    final t = layout.config.totals;
    final totals = ReceiptTotals.fromSale(sale, breakdown: t.showTaxBreakdown);
    final rows = <ReceiptTotalRow>[];
    ReceiptTotalRow row(String key, String value, {bool strong = false}) =>
        ReceiptTotalRow(key, lang.label(key), value, strong: strong, labelAlt: lang.alt(key));
    for (final line in totals.lines) {
      switch (line.key) {
        case 'subtotal':
          if (t.showSubtotal) rows.add(row('subtotal', line.value));
        case 'discount':
          if (t.showDiscount) rows.add(row('discount', line.value));
        case 'rounding':
          if (t.showRounding) rows.add(row('rounding', line.value));
        default:
          // Tax rows keep the sale's own wording ("GST 17%"); only the plain
          // words around it follow the receipt language.
          rows.add(ReceiptTotalRow('tax', lang.taxLine(line.label), line.value));
      }
    }
    rows.add(row('total', totals.total, strong: true));
    if (!isLink) {
      if (t.showPreviousBalance && _has(ctx.previousBalance)) {
        rows.add(row('previous_balance', ctx.previousBalance!));
      }
      if (t.showBalanceAfter && _has(ctx.balanceAfter)) {
        rows.add(row('balance_after', ctx.balanceAfter!));
      }
    }
    return (rows: rows, pricesIncludeTax: totals.pricesIncludeTax);
  }

  static List<ReceiptTaxRow> _taxSummary(SaleResponseModel sale, ReceiptLayout layout, _Words lang) {
    if (layout.design != ReceiptDesign.a4TaxInvoice ||
        !layout.config.totals.showTaxBreakdown) {
      return const [];
    }
    if ((Decimal.tryParse(sale.totalTax ?? '') ?? Decimal.zero) <= Decimal.zero) {
      return const [];
    }
    final label = (sale.taxLabel == null || sale.taxLabel!.trim().isEmpty)
        ? lang.label('tax')
        : sale.taxLabel!.trim();
    return [
      for (final g in ReceiptTotals.taxGroups(sale))
        ReceiptTaxRow(
          label: label,
          rate: '${g.rateText}%',
          net: formatPKR(g.net),
          tax: formatPKR(g.tax),
        ),
    ];
  }

  // ── payments ──────────────────────────────────────────────────────────

  static List<ReceiptTotalRow> _payments(
    SaleResponseModel sale,
    ReceiptLayout layout,
    _Words lang,
  ) {
    final t = layout.config.totals;
    if (!t.showPayments) return const [];
    final rows = <ReceiptTotalRow>[];
    var change = Decimal.zero;
    var paid = Decimal.zero;
    for (final p in sale.payments) {
      final amount = Decimal.tryParse(p.amount) ?? Decimal.zero;
      rows.add(ReceiptTotalRow(
        'payment',
        ReceiptRules.paymentLabel(p.paymentMethod, lang.label),
        formatPKR(amount),
        labelAlt: lang.paymentAlt(p.paymentMethod),
      ));
      if (p.paymentMethod != 'credit') paid += amount;
      change += Decimal.tryParse(p.changeGiven ?? '') ?? Decimal.zero;
    }
    final due = SaleCalculations.balanceDue(sale);
    if (layout.design.isA4 && rows.isNotEmpty) {
      rows.add(ReceiptTotalRow('paid', lang.label('paid'), formatPKR(paid),
          strong: true, labelAlt: lang.alt('paid')));
    }
    if (due > Decimal.zero && sale.payments.every((p) => p.paymentMethod != 'credit')) {
      rows.add(ReceiptTotalRow('balance_due', lang.label('balance_due'), formatPKR(due),
          labelAlt: lang.alt('balance_due')));
    }
    if (t.showChange && change > Decimal.zero) {
      rows.add(ReceiptTotalRow('change', lang.label('change'), formatPKR(change),
          labelAlt: lang.alt('change')));
    }
    return rows;
  }

  // ── QR ────────────────────────────────────────────────────────────────

  /// The QR carries the public receipt link, and only when there is one and
  /// the server already has the sale. Never an empty QR, never on the link
  /// channel itself.
  static String? _qrContent(
    ReceiptLayout layout,
    ReceiptChannel channel,
    ReceiptContext ctx,
  ) {
    if (!layout.config.footer.showQr) return null;
    if (channel == ReceiptChannel.link) return null;
    if (!ctx.synced) return null;
    final link = ctx.publicLink?.trim();
    if (link == null || link.isEmpty) return null;
    return link;
  }
}

/// Every caption of one receipt, resolved to the layout's language. For `en`
/// and `ur` there is exactly one text per caption; only `both` has a second
/// (Urdu) line, returned by [alt].
class _Words {
  _Words(this.config) : language = config.language;

  final ReceiptLayoutConfig config;
  final ReceiptLanguage language;

  /// Small captions the renderers print themselves. Not layout labels, so they
  /// are fixed here (en + ur) and follow the receipt language too.
  static const extra = <String, ReceiptLabel>{
    'return': ReceiptLabel('Return', 'واپسی'),
    'signature': ReceiptLabel('Authorised signature', 'دستخط'),
    'walkin': ReceiptLabel('Walk-in', 'عام گاہک'),
    'tax_summary': ReceiptLabel('Tax summary', 'ٹیکس کا خلاصہ'),
    'rate': ReceiptLabel('Rate', 'شرح'),
    'taxable': ReceiptLabel('Taxable', 'قابل ٹیکس'),
    'includes': ReceiptLabel('Includes', 'شامل'),
  };

  ReceiptLabel _pair(String key) => extra[key] ?? config.label(key);

  String label(String key) => _pair(key).primary(language);

  String? alt(String key) => _pair(key).secondary(language);

  String? paymentAlt(String method) {
    const known = {
      'cash', 'card', 'upi', 'bank_transfer', 'wallet', 'credit', 'cheque', 'other',
    };
    final key = method.trim().toLowerCase();
    return known.contains(key) ? alt(key) : null;
  }

  /// The owner's own walk-in wording wins; the built-in "Walk-in" follows the
  /// receipt language.
  String walkin(String configured) {
    final t = configured.trim();
    if (t.isEmpty || t == extra['walkin']!.en) return label('walkin');
    return t;
  }

  /// "Includes GST 17%" / plain "Tax" use words of the receipt language; the
  /// sale's own tax name stays as the business wrote it.
  String taxLine(String saleLabel) {
    var text = saleLabel;
    if (text == 'Tax') return label('tax');
    if (text.startsWith('Includes ')) {
      var rest = text.substring('Includes '.length);
      if (rest == 'Tax') rest = label('tax');
      return '${label('includes')} $rest';
    }
    return text;
  }

  /// What the renderers need for batch / expiry / SKU / discount and the tax
  /// summary headings, in the receipt language (the English text for `both`).
  Map<String, String> get words => {
        for (final k in const ['batch', 'expiry', 'sku', 'discount', 'tax'])
          k: label(k),
        for (final k in const ['tax_summary', 'rate', 'taxable']) k: label(k),
      };
}

/// Small pure rules, kept apart so each is testable on its own.
abstract final class ReceiptRules {
  /// A value that looks like a tax label or rate is not an NTN ("GST 17%").
  static bool looksLikeTaxText(String value, {String? taxLabel}) {
    final v = value.trim();
    if (v.isEmpty) return false;
    if (v.contains('%')) return true;
    if (taxLabel != null && taxLabel.trim().isNotEmpty &&
        v.toLowerCase() == taxLabel.trim().toLowerCase()) {
      return true;
    }
    return RegExp(r'\b(gst|vat|fbr|sales\s*tax|income\s*tax|tax)\b', caseSensitive: false)
            .hasMatch(v) &&
        !RegExp(r'\d{4,}').hasMatch(v);
  }

  /// The NTN to print, or null (never a tax label or rate).
  static String? ntnOrNull(String? taxId, {String? taxLabel}) {
    final v = taxId?.trim();
    if (v == null || v.isEmpty) return null;
    return looksLikeTaxText(v, taxLabel: taxLabel) ? null : v;
  }

  /// Chooses the one receipt number to print. Falls back to the other kind
  /// when the preferred one does not exist (an unsynced sale has no official
  /// number yet).
  static String pickNumber({
    required String source,
    String? register,
    String? official,
    required String fallback,
  }) {
    String? clean(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    final r = clean(register);
    final o = clean(official);
    final picked = source == 'official' ? (o ?? r) : (r ?? o);
    return picked ?? fallback;
  }

  /// The product name; the variation only when it is a real one.
  static String itemName(
    String? productName, {
    bool showVariation = true,
    String? variationName,
  }) {
    final name = (productName?.trim().isNotEmpty ?? false) ? productName!.trim() : 'Item';
    final v = variationName?.trim();
    if (!showVariation || v == null || v.isEmpty || v.toLowerCase() == 'default') {
      return name;
    }
    return '$name ($v)';
  }

  /// "2", never "2.00"; decimals only as far as they matter (max 3).
  static String formatQty(String? raw, {bool allowsDecimal = false}) {
    final d = Decimal.tryParse((raw ?? '').trim());
    if (d == null) return (raw ?? '').trim();
    if (d.isInteger) return d.toBigInt().toString();
    var text = d.toStringAsFixed(allowsDecimal ? 3 : 4);
    text = text.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    return text;
  }

  /// `2027-05-31` -> `05/2027`.
  static String? expiryText(String? iso) {
    if (iso == null || iso.trim().isEmpty) return null;
    final d = DateTime.tryParse(iso.trim());
    if (d == null) return iso.trim();
    return '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  static String paymentLabel(String method, String Function(String) label) {
    const known = {
      'cash', 'card', 'upi', 'bank_transfer', 'wallet', 'credit', 'cheque', 'other',
    };
    final key = method.trim().toLowerCase();
    if (known.contains(key)) return label(key);
    if (key.isEmpty) return label('other');
    return key[0].toUpperCase() + key.substring(1).replaceAll('_', ' ');
  }
}
