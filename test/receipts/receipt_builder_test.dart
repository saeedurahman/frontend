import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_samples.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

ReceiptLayout layoutOf(
  ReceiptDesign design, {
  ReceiptLayoutConfig Function(ReceiptLayoutConfig c)? tweak,
  bool pharmacy = true,
}) {
  var config = ReceiptLayoutConfig.defaultsFor(design, pharmacy: pharmacy);
  if (tweak != null) config = tweak(config);
  return ReceiptLayout(
    id: 'layout-1',
    name: design.title,
    design: design,
    paper: design.defaultPaper,
    config: config,
  );
}

ReceiptModel build(
  SaleResponseModel sale,
  ReceiptLayout layout, {
  ReceiptContext? context,
  ReceiptChannel channel = ReceiptChannel.print,
}) =>
    ReceiptModelBuilder.build(
      sale,
      layout,
      channel,
      context: context ?? ReceiptSamples.context(),
      now: DateTime(2026, 11, 17, 10, 30),
    );

String? meta(ReceiptModel m, String key) {
  for (final r in m.meta) {
    if (r.key == key) return r.value;
  }
  return null;
}

void main() {
  final classic = layoutOf(ReceiptDesign.thermalClassic);

  group('receipt number', () {
    test('register source prints the counter number', () {
      final m = build(ReceiptSamples.sale(), classic);
      expect(meta(m, 'number'), 'C1-0042');
    });

    test('official source prints the server number once it exists', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('meta', 'number_source', 'official'),
      );
      expect(meta(build(ReceiptSamples.sale(), l), 'number'), 'INV-0042');
    });

    test('official source falls back to the counter number before sync', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('meta', 'number_source', 'official'),
      );
      final m = build(
        ReceiptSamples.sale(synced: false),
        l,
        context: ReceiptSamples.context(synced: false),
      );
      expect(meta(m, 'number'), 'C1-0042');
    });

    test('exactly one number row is ever printed', () {
      final m = build(ReceiptSamples.sale(), classic);
      expect(m.meta.where((r) => r.key == 'number'), hasLength(1));
    });
  });

  group('no sync noise', () {
    test('an unsynced sale never says pending or sync on any design', () {
      for (final d in ReceiptDesign.values) {
        final m = build(
          ReceiptSamples.sale(synced: false),
          layoutOf(d),
          context: ReceiptSamples.context(synced: false),
        );
        final text = m.allTexts.join('\n').toLowerCase();
        expect(text, isNot(contains('pending')), reason: d.code);
        expect(text, isNot(contains('sync')), reason: d.code);
        expect(text, isNot(contains('offline')), reason: d.code);
      }
    });
  });

  group('item names and quantities', () {
    test('the variation shows only when it is a real one', () {
      final m = build(ReceiptSamples.sale(), classic);
      expect(m.items[0].name, 'Panadol Extra'); // variation "Default"
      expect(m.items[2].name, 'Vitamin C (500 mg)');
      expect(ReceiptRules.itemName('Tea', variationName: ''), 'Tea');
      expect(ReceiptRules.itemName('Tea', variationName: 'default'), 'Tea');
      expect(ReceiptRules.itemName('Tea', variationName: null), 'Tea');
    });

    test('quantities have no decimals unless they need them', () {
      expect(ReceiptRules.formatQty('2.00'), '2');
      expect(ReceiptRules.formatQty('10'), '10');
      expect(ReceiptRules.formatQty('1.500', allowsDecimal: true), '1.5');
      expect(ReceiptRules.formatQty('0.250', allowsDecimal: true), '0.25');
      final m = build(ReceiptSamples.sale(), classic);
      expect(m.items[0].qty, '2');
      expect(m.items[1].qty, '1.5');
    });
  });

  group('NTN', () {
    ReceiptContext withTax(String? taxId) {
      final base = ReceiptSamples.context();
      return base.copyWith(
        business: ReceiptBusiness(
          name: base.business.name,
          address: base.business.address,
          phone: base.business.phone,
          taxId: taxId,
        ),
      );
    }

    test('prints the tax id with the layout label', () {
      final m = build(ReceiptSamples.sale(), classic, context: withTax('1234567-8'));
      expect(m.header.ntnLine, 'NTN: 1234567-8');
    });

    test('the layout label is used', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('header', 'ntn_label', 'STRN'),
      );
      final m = build(ReceiptSamples.sale(), l, context: withTax('1234567-8'));
      expect(m.header.ntnLine, 'STRN: 1234567-8');
    });

    test('a tax label such as "GST 17%" is never printed as the NTN', () {
      for (final bad in ['GST 17%', 'gst', 'Sales Tax 18 %', 'VAT']) {
        final m = build(ReceiptSamples.sale(), classic, context: withTax(bad));
        expect(m.header.ntnLine, isNull, reason: bad);
        expect(m.allTexts.join('\n'), isNot(contains('NTN')), reason: bad);
      }
      expect(ReceiptRules.looksLikeTaxText('GST 17%'), isTrue);
      expect(ReceiptRules.looksLikeTaxText('1234567-8'), isFalse);
      expect(ReceiptRules.ntnOrNull('GST 17%'), isNull);
      expect(ReceiptRules.ntnOrNull(' 7654321-0 '), '7654321-0');
    });

    test('empty tax id prints no NTN line', () {
      final m = build(ReceiptSamples.sale(), classic, context: withTax(' '));
      expect(m.header.ntnLine, isNull);
    });

    test('the switch hides the NTN', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('header', 'show_ntn', false),
      );
      final m = build(ReceiptSamples.sale(), l, context: withTax('1234567-8'));
      expect(m.header.ntnLine, isNull);
    });
  });

  group('tax, rounding and price mode come from the sale snapshot', () {
    String? total(ReceiptModel m, String key) {
      for (final r in m.totals) {
        if (r.key == key) return r.value;
      }
      return null;
    }

    test('exclusive sale lists the tax and the snapshot total', () {
      final m = build(ReceiptSamples.sale(), classic);
      expect(total(m, 'total'), contains('772.20'));
      expect(m.totals.any((r) => r.key.startsWith('tax')), isTrue);
      expect(m.taxNote, isNull);
    });

    test('inclusive sale says prices include tax', () {
      final inclusive = ReceiptSamples.sale().copyWith(taxInclusive: true);
      final m = build(inclusive, classic);
      expect(m.taxNote, isNotNull);
      expect(m.taxNote!.toLowerCase(), contains('include'));
    });

    test('rounding shows only when the sale has it', () {
      final none = build(ReceiptSamples.sale(), classic);
      expect(total(none, 'rounding'), isNull);
      final rounded = ReceiptSamples.sale().copyWith(roundingAmount: '-0.20');
      final m = build(rounded, classic);
      expect(total(m, 'rounding'), contains('0.20'));
    });

    test('changing the shop tax setting later never touches an old receipt', () {
      // The builder reads only the sale: same sale, same totals.
      final a = build(ReceiptSamples.sale(), classic);
      final b = build(ReceiptSamples.sale(), classic);
      expect([for (final r in a.totals) '${r.key}:${r.value}'],
          [for (final r in b.totals) '${r.key}:${r.value}']);
    });
  });

  group('who and where', () {
    test('walk-in label prints only when it is not empty', () {
      final sale = ReceiptSamples.sale().copyWith(customer: null, customerId: null);
      final withLabel = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('meta', 'walkin_label', 'Walk-in'),
      );
      expect(meta(build(sale, withLabel), 'customer'), 'Walk-in');

      final emptyLabel = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('meta', 'walkin_label', ''),
      );
      expect(meta(build(sale, emptyLabel), 'customer'), isNull);
    });

    test('cashier, branch, register and customer follow their switches', () {
      final all = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c
            .withValue('meta', 'show_cashier', true)
            .withValue('meta', 'show_branch', true)
            .withValue('meta', 'show_register', true)
            .withValue('meta', 'show_customer', true),
      );
      final on = build(ReceiptSamples.sale(), all);
      expect(meta(on, 'cashier'), 'Bilal');
      expect(meta(on, 'branch'), 'Main branch');
      expect(meta(on, 'register'), 'Counter 1');
      expect(meta(on, 'customer'), isNotNull);

      final none = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c
            .withValue('meta', 'show_cashier', false)
            .withValue('meta', 'show_branch', false)
            .withValue('meta', 'show_register', false)
            .withValue('meta', 'show_customer', false),
      );
      final off = build(ReceiptSamples.sale(), none);
      expect(meta(off, 'cashier'), isNull);
      expect(meta(off, 'branch'), isNull);
      expect(meta(off, 'register'), isNull);
      expect(meta(off, 'customer'), isNull);
    });

    test('the public link never shows people', () {
      final all = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('meta', 'show_cashier', true),
      );
      final m = build(ReceiptSamples.sale(), all, channel: ReceiptChannel.link);
      expect(meta(m, 'cashier'), isNull);
      expect(meta(m, 'customer'), isNull);
    });
  });

  group('labels', () {
    test('a bilingual caption prints "English / اردو"', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withLabel('total', en: 'Total', ur: 'کل'),
      );
      final m = build(ReceiptSamples.sale(), l);
      final row = m.totals.firstWhere((r) => r.key == 'total');
      expect(row.label, 'Total / کل');
    });

    test('an English-only caption prints just English', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withLabel('total', en: 'Grand total', ur: ''),
      );
      final m = build(ReceiptSamples.sale(), l);
      expect(m.totals.firstWhere((r) => r.key == 'total').label, 'Grand total');
    });

    test('footer prints both languages when both are filled in', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c
            .withValue('footer', 'text_en', 'Thank you!')
            .withValue('footer', 'text_ur', 'شکریہ'),
      );
      final m = build(ReceiptSamples.sale(), l);
      expect(m.footerLines, ['Thank you!', 'شکریہ']);
    });
  });

  group('QR and powered by', () {
    ReceiptLayout withQr(bool on) => layoutOf(
          ReceiptDesign.thermalClassic,
          tweak: (c) => c.withValue('footer', 'show_qr', on),
        );

    test('QR carries the public link when synced and a link exists', () {
      final m = build(ReceiptSamples.sale(), withQr(true));
      expect(m.qrContent, 'https://pakpos.example/r/sample0042');
    });

    test('no QR when the sale is not synced', () {
      final m = build(
        ReceiptSamples.sale(synced: false),
        withQr(true),
        context: ReceiptSamples.context(synced: false).copyWith(
          publicLink: 'https://pakpos.example/r/x',
        ),
      );
      expect(m.qrContent, isNull);
    });

    test('no QR without a link, with the switch off, or on the link channel', () {
      final noLink = ReceiptSamples.context().copyWith(publicLink: '');
      expect(build(ReceiptSamples.sale(), withQr(true), context: noLink).qrContent, isNull);
      expect(build(ReceiptSamples.sale(), withQr(false)).qrContent, isNull);
      expect(
        build(ReceiptSamples.sale(), withQr(true), channel: ReceiptChannel.link).qrContent,
        isNull,
      );
    });

    test('powered by follows its switch', () {
      final on = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('footer', 'show_powered_by', true),
      );
      final off = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c.withValue('footer', 'show_powered_by', false),
      );
      expect(build(ReceiptSamples.sale(), on).poweredBy, isNotNull);
      expect(build(ReceiptSamples.sale(), off).poweredBy, isNull);
    });
  });

  group('batch and expiry', () {
    test('batch and expiry print when their switches are on', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c
            .withValue('items', 'show_batch', true)
            .withValue('items', 'show_expiry', true),
      );
      final b = build(ReceiptSamples.sale(), l).items.first.batches;
      expect(b, hasLength(1));
      expect(b.first.batchNo, 'B2407');
      expect(b.first.expiry, '05/2027');
    });

    test('batch and expiry are hidden when the switches are off', () {
      final l = layoutOf(
        ReceiptDesign.thermalClassic,
        tweak: (c) => c
            .withValue('items', 'show_batch', false)
            .withValue('items', 'show_expiry', false),
      );
      final item = build(ReceiptSamples.sale(), l).items.first;
      expect(
        item.batches.every((x) => x.batchNo == null && x.expiry == null),
        isTrue,
      );
    });
  });

  group('every design builds', () {
    test('each design builds with items, totals and a title', () {
      for (final d in ReceiptDesign.values) {
        final m = build(ReceiptSamples.sale(), layoutOf(d));
        expect(m.items, hasLength(3), reason: d.code);
        expect(m.totals, isNotEmpty, reason: d.code);
        expect(m.title, isNotEmpty, reason: d.code);
      }
    });

    test('A4 tax invoice has columns, a tax summary and a signature line', () {
      final m = build(ReceiptSamples.sale(), layoutOf(ReceiptDesign.a4TaxInvoice));
      expect(m.columns, isNotEmpty);
      expect(m.taxSummary, isNotEmpty);
      expect(m.signatureLabel, isNotNull);
    });

    test('A4 elegant uses the business accent colour', () {
      final m = build(
        ReceiptSamples.sale(),
        layoutOf(ReceiptDesign.a4Elegant),
        context: ReceiptSamples.context().copyWith(accentColor: 0xFF123456),
      );
      expect(m.accentColor, 0xFF123456);
    });
  });
}
