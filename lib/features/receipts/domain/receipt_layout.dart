import 'dart:convert';

/// The four built-in designs (backend `DESIGNS`).
enum ReceiptDesign {
  thermalClassic('thermal_classic', 'Classic receipt',
      'Centered header, one line per item with quantity x price, simple totals.'),
  thermalCompact('thermal_compact', 'Compact receipt',
      'Tight spacing for small rolls: fewer lines per item.'),
  a4TaxInvoice('a4_tax_invoice', 'A4 tax invoice',
      'Full page with an item table, tax summary and a signature line.'),
  a4Elegant('a4_elegant', 'A4 elegant invoice',
      'Full page with a coloured banner header and clean typography.');

  const ReceiptDesign(this.code, this.title, this.description);
  final String code;
  final String title;
  final String description;

  bool get isA4 => this == a4TaxInvoice || this == a4Elegant;
  bool get isThermal => !isA4;

  ReceiptPaper get defaultPaper => switch (this) {
        thermalClassic => ReceiptPaper.roll80,
        thermalCompact => ReceiptPaper.roll58,
        _ => ReceiptPaper.a4,
      };

  List<ReceiptPaper> get papers => switch (this) {
        thermalClassic => const [ReceiptPaper.roll80, ReceiptPaper.roll58],
        thermalCompact => const [ReceiptPaper.roll58, ReceiptPaper.roll80],
        _ => const [ReceiptPaper.a4],
      };

  static ReceiptDesign fromCode(String? code) => values.firstWhere(
        (d) => d.code == code,
        orElse: () => thermalClassic,
      );
}

enum ReceiptPaper {
  roll58('roll58', '58 mm roll'),
  roll80('roll80', '80 mm roll'),
  a4('a4', 'A4 page');

  const ReceiptPaper(this.code, this.title);
  final String code;
  final String title;

  bool get isA4 => this == a4;

  /// Roll width in PDF points. 58 mm rolls keep the 57 mm page the printer
  /// settings have always used (`PdfPageFormat.roll57`).
  double get widthMm => switch (this) {
        roll58 => 57,
        roll80 => 80,
        a4 => 210,
      };

  static ReceiptPaper fromCode(String? code, {ReceiptPaper? fallback}) =>
      values.firstWhere(
        (p) => p.code == code,
        orElse: () => fallback ?? roll80,
      );
}

enum ReceiptChannel {
  print('print', 'Printed receipt'),
  whatsapp('whatsapp', 'WhatsApp message'),
  link('link', 'Public link');

  const ReceiptChannel(this.code, this.title);
  final String code;
  final String title;

  static ReceiptChannel fromCode(String? code) => values.firstWhere(
        (c) => c.code == code,
        orElse: () => print,
      );
}

/// The ONE language a receipt is written in (`style.language`). `both` prints
/// every caption on two lines: English, then Urdu under it.
enum ReceiptLanguage {
  en('en', 'English'),
  ur('ur', 'اردو'),
  both('both', 'Both');

  const ReceiptLanguage(this.code, this.title);
  final String code;
  final String title;

  bool get isRtl => this == ur;
  bool get isBoth => this == both;

  static ReceiptLanguage fromCode(String? code) => values.firstWhere(
        (l) => l.code == code,
        orElse: () => en,
      );
}

/// One printed caption in both languages.
class ReceiptLabel {
  const ReceiptLabel(this.en, this.ur);
  final String en;
  final String ur;

  /// The caption in exactly [language]. For `both` this is the English text;
  /// the Urdu one is [secondary].
  String primary(ReceiptLanguage language) {
    final text = language == ReceiptLanguage.ur ? ur : en;
    final fallback = language == ReceiptLanguage.ur ? en : ur;
    return text.trim().isNotEmpty ? text.trim() : fallback.trim();
  }

  /// The second line of a `both` caption; null for one-language receipts.
  String? secondary(ReceiptLanguage language) {
    if (language != ReceiptLanguage.both) return null;
    final u = ur.trim();
    return u.isEmpty || u == en.trim() ? null : u;
  }

  Map<String, String> toJson() => {'en': en, 'ur': ur};

  @override
  bool operator ==(Object other) =>
      other is ReceiptLabel && other.en == en && other.ur == ur;

  @override
  int get hashCode => Object.hash(en, ur);
}

/// Every printed caption with its built-in English and Urdu text
/// (mirrors the backend's `LABEL_DEFAULTS`).
abstract final class ReceiptLabelDefaults {
  static const all = <String, ReceiptLabel>{
    'receipt': ReceiptLabel('Receipt', 'رسید'),
    'tax_invoice': ReceiptLabel('Tax Invoice', 'ٹیکس انوائس'),
    'invoice': ReceiptLabel('Invoice', 'انوائس'),
    'number': ReceiptLabel('Receipt #', 'رسید نمبر'),
    'date': ReceiptLabel('Date', 'تاریخ'),
    'cashier': ReceiptLabel('Cashier', 'کیشیئر'),
    'customer': ReceiptLabel('Customer', 'گاہک'),
    'customer_phone': ReceiptLabel('Phone', 'فون'),
    'branch': ReceiptLabel('Branch', 'برانچ'),
    'register': ReceiptLabel('Register', 'کاؤنٹر'),
    'item': ReceiptLabel('Item', 'آئٹم'),
    'qty': ReceiptLabel('Qty', 'تعداد'),
    'price': ReceiptLabel('Price', 'قیمت'),
    'amount': ReceiptLabel('Amount', 'رقم'),
    'sku': ReceiptLabel('SKU', 'کوڈ'),
    'barcode': ReceiptLabel('Barcode', 'بار کوڈ'),
    'batch': ReceiptLabel('Batch', 'بیچ'),
    'expiry': ReceiptLabel('Exp', 'ایکسپائری'),
    'subtotal': ReceiptLabel('Subtotal', 'ذیلی کل'),
    'discount': ReceiptLabel('Discount', 'رعایت'),
    'net_amount': ReceiptLabel('Net amount', 'خالص رقم'),
    'tax': ReceiptLabel('Tax', 'ٹیکس'),
    'rounding': ReceiptLabel('Rounding', 'راؤنڈنگ'),
    'total': ReceiptLabel('Total', 'کل'),
    'paid': ReceiptLabel('Paid', 'ادا شدہ'),
    'balance_due': ReceiptLabel('Balance due', 'بقایا'),
    'change': ReceiptLabel('Change', 'واپسی'),
    'cash': ReceiptLabel('Cash', 'نقد'),
    'card': ReceiptLabel('Card', 'کارڈ'),
    'upi': ReceiptLabel('UPI', 'یو پی آئی'),
    'bank_transfer': ReceiptLabel('Bank transfer', 'بینک ٹرانسفر'),
    'wallet': ReceiptLabel('Mobile wallet', 'موبائل والیٹ'),
    'credit': ReceiptLabel('Credit', 'ادھار'),
    'cheque': ReceiptLabel('Cheque', 'چیک'),
    'other': ReceiptLabel('Other', 'دیگر'),
    'previous_balance': ReceiptLabel('Previous balance', 'پچھلا بقایا'),
    'balance_after': ReceiptLabel('Balance now', 'موجودہ بقایا'),
    'includes_tax': ReceiptLabel('Prices include tax', 'قیمتوں میں ٹیکس شامل ہے'),
    'thank_you':
        ReceiptLabel('Thank you for shopping with us!', 'خریداری کا شکریہ!'),
    'void': ReceiptLabel('VOID', 'منسوخ'),
    'powered_by': ReceiptLabel('Powered by PakPOS', 'PakPOS کے ذریعے'),
  };

  /// Plain-language names for the editor.
  static const friendlyNames = <String, String>{
    'receipt': 'Title of a normal receipt',
    'tax_invoice': 'Title of a tax invoice',
    'number': 'Receipt number',
    'date': 'Date and time',
    'cashier': 'Cashier',
    'customer': 'Customer',
    'customer_phone': 'Customer phone',
    'branch': 'Branch',
    'register': 'Counter / register',
    'item': 'Item column',
    'qty': 'Quantity column',
    'price': 'Price column',
    'amount': 'Amount column',
    'batch': 'Batch number',
    'expiry': 'Expiry date',
    'subtotal': 'Subtotal',
    'discount': 'Discount',
    'tax': 'Tax',
    'rounding': 'Rounding',
    'total': 'Total',
    'paid': 'Paid',
    'balance_due': 'Balance due',
    'change': 'Change',
    'previous_balance': 'Previous balance',
    'balance_after': 'Balance now',
    'includes_tax': 'Prices include tax note',
    'void': 'Cancelled stamp',
  };
}

/// The validated, versioned JSON a layout is made of.
///
/// Sections are exactly the backend's: header, meta, items, totals, footer,
/// labels, style. Unknown keys are dropped and missing ones filled with the
/// defaults, so a layout pulled from an older or newer server still renders.
class ReceiptLayoutConfig {
  const ReceiptLayoutConfig._(this._sections, this._labels);

  final Map<String, Map<String, Object?>> _sections;
  final Map<String, ReceiptLabel> _labels;

  static const version = 1;

  static const _base = <String, Map<String, Object?>>{
    'header': {
      'show_logo': true,
      'show_business_name': true,
      'show_address': true,
      'show_phone': true,
      'show_ntn': true,
      'ntn_label': 'NTN',
      'extra_lines': <String>[],
    },
    'meta': {
      'show_number': true,
      'number_source': 'register',
      'show_datetime': true,
      'show_cashier': true,
      'show_branch': false,
      'show_register': false,
      'show_customer': true,
      'show_customer_phone': false,
      'walkin_label': 'Walk-in',
    },
    'items': {
      'show_name': true,
      'show_variation': true,
      'show_sku': false,
      'show_barcode': false,
      'show_unit': false,
      'show_qty': true,
      'show_unit_price': true,
      'show_line_discount': true,
      'show_line_total': true,
      'show_batch': false,
      'show_expiry': false,
    },
    'totals': {
      'show_subtotal': true,
      'show_discount': true,
      'show_tax_breakdown': true,
      'show_rounding': true,
      'show_includes_tax_note': true,
      'show_payments': true,
      'show_change': true,
      'show_previous_balance': false,
      'show_balance_after': false,
    },
    'footer': {
      'text_en': '',
      'text_ur': '',
      'show_powered_by': false,
      'show_qr': true,
    },
    'style': {
      'language': 'en',
      'font_scale': 1.0,
      'show_dividers': true,
      'compact_items': false,
    },
  };

  static Map<String, Map<String, Object?>> _copyBase() => {
        for (final e in _base.entries)
          e.key: {
            for (final f in e.value.entries)
              f.key: f.value is List ? <String>[] : f.value,
          },
      };

  /// Starting config of a [design] (backend `default_config`). [pharmacy]
  /// turns the batch and expiry columns on.
  factory ReceiptLayoutConfig.defaultsFor(
    ReceiptDesign design, {
    bool pharmacy = false,
  }) {
    final raw = <String, Object?>{};
    switch (design) {
      case ReceiptDesign.thermalCompact:
        raw['style'] = {'compact_items': true, 'font_scale': 0.9};
        raw['meta'] = {'show_cashier': false, 'show_customer': false};
        raw['footer'] = {'show_qr': false};
      case ReceiptDesign.a4TaxInvoice:
        raw['meta'] = {'show_branch': true, 'show_customer_phone': true};
        raw['items'] = {'show_sku': true, 'show_unit': true};
        raw['totals'] = {
          'show_previous_balance': true,
          'show_balance_after': true,
        };
      case ReceiptDesign.a4Elegant:
        raw['meta'] = {'show_branch': true, 'show_customer_phone': true};
        raw['items'] = {'show_unit': true};
        raw['style'] = {'show_dividers': false};
      case ReceiptDesign.thermalClassic:
        break;
    }
    if (pharmacy) {
      final items = Map<String, Object?>.from((raw['items'] as Map?) ?? {});
      items['show_batch'] = true;
      items['show_expiry'] = true;
      raw['items'] = items;
    }
    return ReceiptLayoutConfig.fromJson(raw);
  }

  /// Tolerant parse: wrong-typed or unknown values are ignored.
  factory ReceiptLayoutConfig.fromJson(Object? json) {
    final src = json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    final sections = _copyBase();
    for (final section in sections.entries) {
      final given = src[section.key];
      if (given is! Map) continue;
      for (final key in section.value.keys.toList()) {
        final value = given[key];
        final def = section.value[key];
        if (value == null) continue;
        if (def is bool && value is bool) {
          section.value[key] = value;
        } else if (def is String && value is String) {
          section.value[key] = value;
        } else if (def is double && value is num) {
          section.value[key] = value.toDouble();
        } else if (def is List && value is List) {
          section.value[key] = [for (final v in value) '$v'];
        }
      }
    }
    final labels = <String, ReceiptLabel>{};
    final given = src['labels'];
    for (final entry in ReceiptLabelDefaults.all.entries) {
      final g = given is Map ? given[entry.key] : null;
      final en = g is Map ? '${g['en'] ?? ''}' : '';
      final ur = g is Map ? '${g['ur'] ?? ''}' : '';
      labels[entry.key] = ReceiptLabel(
        en.isNotEmpty ? en : entry.value.en,
        ur.isNotEmpty ? ur : entry.value.ur,
      );
    }
    final styleGiven = src['style'];
    final hasLanguage = styleGiven is Map &&
        ReceiptLanguage.values.any((l) => l.code == styleGiven['language']);
    if (!hasLanguage) {
      sections['style']!['language'] = _legacyLanguage(src, labels).code;
    }
    return ReceiptLayoutConfig._(sections, labels);
  }

  /// Layouts saved before `style.language` existed printed English and Urdu
  /// on every caption. They become `both` only when the owner had written
  /// Urdu text of their own (an edited caption or an Urdu footer); otherwise
  /// they were just showing the built-in Urdu and become `en`.
  static ReceiptLanguage _legacyLanguage(
    Map<String, dynamic> src,
    Map<String, ReceiptLabel> labels,
  ) {
    final given = src['labels'];
    if (given is Map) {
      for (final entry in ReceiptLabelDefaults.all.entries) {
        final g = given[entry.key];
        final ur = g is Map ? '${g['ur'] ?? ''}'.trim() : '';
        if (ur.isNotEmpty && ur != entry.value.ur) return ReceiptLanguage.both;
      }
    }
    final footer = src['footer'];
    if (footer is Map && '${footer['text_ur'] ?? ''}'.trim().isNotEmpty) {
      return ReceiptLanguage.both;
    }
    return ReceiptLanguage.en;
  }

  ReceiptHeaderConfig get header => ReceiptHeaderConfig._(_sections['header']!);
  ReceiptMetaConfig get meta => ReceiptMetaConfig._(_sections['meta']!);
  ReceiptItemsConfig get items => ReceiptItemsConfig._(_sections['items']!);
  ReceiptTotalsConfig get totals => ReceiptTotalsConfig._(_sections['totals']!);
  ReceiptFooterConfig get footer => ReceiptFooterConfig._(_sections['footer']!);
  ReceiptStyleConfig get style => ReceiptStyleConfig._(_sections['style']!);

  /// Caption [key]; falls back to the built-in text.
  ReceiptLabel label(String key) =>
      _labels[key] ?? ReceiptLabelDefaults.all[key] ?? ReceiptLabel(key, '');

  Map<String, ReceiptLabel> get labels => Map.unmodifiable(_labels);

  ReceiptLanguage get language => style.language;

  ReceiptLayoutConfig withLanguage(ReceiptLanguage language) =>
      withValue('style', 'language', language.code);

  /// A copy with one value changed. [section] is `header`, `meta`, `items`,
  /// `totals`, `footer` or `style`.
  ReceiptLayoutConfig withValue(String section, String key, Object? value) {
    final sections = {
      for (final e in _sections.entries)
        e.key: Map<String, Object?>.from(e.value),
    };
    sections[section]![key] = value;
    return ReceiptLayoutConfig._(sections, _labels);
  }

  ReceiptLayoutConfig withLabel(String key, {String? en, String? ur}) {
    final current = label(key);
    final labels = {..._labels};
    labels[key] = ReceiptLabel(en ?? current.en, ur ?? current.ur);
    return ReceiptLayoutConfig._(_sections, labels);
  }

  /// Wire shape (full config, every label).
  Map<String, Object?> toJson() => {
        'v': version,
        for (final e in _sections.entries)
          e.key: {
            for (final f in e.value.entries)
              f.key: f.value is List ? List<String>.from(f.value as List) : f.value,
          },
        'labels': {for (final e in _labels.entries) e.key: e.value.toJson()},
      };

  @override
  bool operator ==(Object other) =>
      other is ReceiptLayoutConfig && jsonEncode(other.toJson()) == jsonEncode(toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;
}

class _Section {
  const _Section(this._m);
  final Map<String, Object?> _m;
  bool _b(String k) => _m[k] == true;
  String _s(String k) => '${_m[k] ?? ''}';
}

class ReceiptHeaderConfig extends _Section {
  const ReceiptHeaderConfig._(super.m);
  bool get showLogo => _b('show_logo');
  bool get showBusinessName => _b('show_business_name');
  bool get showAddress => _b('show_address');
  bool get showPhone => _b('show_phone');
  bool get showNtn => _b('show_ntn');
  String get ntnLabel => _s('ntn_label');
  List<String> get extraLines =>
      [for (final l in (_m['extra_lines'] as List? ?? const [])) '$l'];
}

class ReceiptMetaConfig extends _Section {
  const ReceiptMetaConfig._(super.m);
  bool get showNumber => _b('show_number');
  String get numberSource => _s('number_source');
  bool get showDatetime => _b('show_datetime');
  bool get showCashier => _b('show_cashier');
  bool get showBranch => _b('show_branch');
  bool get showRegister => _b('show_register');
  bool get showCustomer => _b('show_customer');
  bool get showCustomerPhone => _b('show_customer_phone');
  String get walkinLabel => _s('walkin_label');
}

class ReceiptItemsConfig extends _Section {
  const ReceiptItemsConfig._(super.m);
  bool get showName => _b('show_name');
  bool get showVariation => _b('show_variation');
  bool get showSku => _b('show_sku');
  bool get showBarcode => _b('show_barcode');
  bool get showUnit => _b('show_unit');
  bool get showQty => _b('show_qty');
  bool get showUnitPrice => _b('show_unit_price');
  bool get showLineDiscount => _b('show_line_discount');
  bool get showLineTotal => _b('show_line_total');
  bool get showBatch => _b('show_batch');
  bool get showExpiry => _b('show_expiry');
}

class ReceiptTotalsConfig extends _Section {
  const ReceiptTotalsConfig._(super.m);
  bool get showSubtotal => _b('show_subtotal');
  bool get showDiscount => _b('show_discount');
  bool get showTaxBreakdown => _b('show_tax_breakdown');
  bool get showRounding => _b('show_rounding');
  bool get showIncludesTaxNote => _b('show_includes_tax_note');
  bool get showPayments => _b('show_payments');
  bool get showChange => _b('show_change');
  bool get showPreviousBalance => _b('show_previous_balance');
  bool get showBalanceAfter => _b('show_balance_after');
}

class ReceiptFooterConfig extends _Section {
  const ReceiptFooterConfig._(super.m);
  String get textEn => _s('text_en');
  String get textUr => _s('text_ur');
  bool get showPoweredBy => _b('show_powered_by');
  bool get showQr => _b('show_qr');

  /// The thank-you lines for [language]: one line for `en`/`ur`, English then
  /// Urdu for `both`. A language without its own text prints nothing (the
  /// other language's text is never borrowed).
  List<String> linesFor(ReceiptLanguage language) {
    final en = textEn.trim();
    final ur = textUr.trim();
    return switch (language) {
      ReceiptLanguage.en => [if (en.isNotEmpty) en],
      ReceiptLanguage.ur => [if (ur.isNotEmpty) ur],
      ReceiptLanguage.both => [if (en.isNotEmpty) en, if (ur.isNotEmpty) ur],
    };
  }
}

class ReceiptStyleConfig extends _Section {
  const ReceiptStyleConfig._(super.m);
  ReceiptLanguage get language => ReceiptLanguage.fromCode(_s('language'));

  double get fontScale {
    final v = _m['font_scale'];
    final d = v is num ? v.toDouble() : 1.0;
    return d.clamp(0.8, 1.4);
  }

  bool get showDividers => _b('show_dividers');
  bool get compactItems => _b('compact_items');
}

/// A layout: business data (backend `receipt_layouts`).
class ReceiptLayout {
  const ReceiptLayout({
    required this.id,
    required this.name,
    required this.design,
    required this.paper,
    required this.config,
    this.isActive = true,
    this.isBuiltIn = false,
    this.updatedAt,
  });

  final String id;
  final String name;
  final ReceiptDesign design;
  final ReceiptPaper paper;
  final ReceiptLayoutConfig config;
  final bool isActive;

  /// The app's own fallback (never pulled, never saved to the server).
  final bool isBuiltIn;
  final String? updatedAt;

  factory ReceiptLayout.fromJson(Map<String, dynamic> json) {
    final design = ReceiptDesign.fromCode(json['design']?.toString());
    return ReceiptLayout(
      id: '${json['id']}',
      name: '${json['name'] ?? design.title}',
      design: design,
      paper: ReceiptPaper.fromCode(
        json['paper']?.toString(),
        fallback: design.defaultPaper,
      ),
      config: ReceiptLayoutConfig.fromJson(json['config']),
      isActive: json['is_active'] != false,
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'design': design.code,
        'paper': paper.code,
        'config': config.toJson(),
        'is_active': isActive,
      };

  ReceiptLayout copyWith({
    String? name,
    ReceiptPaper? paper,
    ReceiptLayoutConfig? config,
    bool? isActive,
  }) =>
      ReceiptLayout(
        id: id,
        name: name ?? this.name,
        design: design,
        paper: paper ?? this.paper,
        config: config ?? this.config,
        isActive: isActive ?? this.isActive,
        isBuiltIn: isBuiltIn,
        updatedAt: updatedAt,
      );

  static const builtInId = 'builtin-thermal-classic';

  /// What the app prints when no layout has been pulled yet: today's receipt
  /// (English captions, "Powered by" line, the business footer text).
  factory ReceiptLayout.builtIn({
    String footerText = 'Thank you for shopping with us!',
    ReceiptPaper paper = ReceiptPaper.roll80,
  }) {
    final config = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic)
        .withValue('meta', 'show_cashier', false)
        .withValue('footer', 'text_en', footerText)
        .withValue('footer', 'show_powered_by', true)
        .withValue('footer', 'show_qr', false)
        .withLanguage(ReceiptLanguage.en);
    return ReceiptLayout(
      id: builtInId,
      name: 'Classic receipt',
      design: ReceiptDesign.thermalClassic,
      paper: paper,
      config: config,
      isBuiltIn: true,
    );
  }
}

/// Which layout a channel uses; [branchId] null = the business default.
class ReceiptLayoutAssignment {
  const ReceiptLayoutAssignment({
    required this.id,
    required this.channel,
    required this.layoutId,
    this.branchId,
  });

  final String id;
  final ReceiptChannel channel;
  final String? layoutId;
  final String? branchId;

  factory ReceiptLayoutAssignment.fromJson(Map<String, dynamic> json) =>
      ReceiptLayoutAssignment(
        id: '${json['id']}',
        channel: ReceiptChannel.fromCode(json['channel']?.toString()),
        layoutId: json['layout_id']?.toString(),
        branchId: json['branch_id']?.toString(),
      );
}
