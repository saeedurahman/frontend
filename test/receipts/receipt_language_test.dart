// One language per receipt: English, Urdu or both, on every design and paper
// (thermal 80 mm, thermal 58 mm, A4), in the model, the plain text sent on
// WhatsApp, the on-screen preview and the PDF.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/receipts/data/receipt_context_loader.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_plain_text.dart';
import 'package:frantend/features/receipts/domain/receipt_samples.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_renderer.dart';
import 'package:frantend/features/receipts/presentation/services/receipt_service.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_view.dart';

class _Store extends Fake implements ReceiptLayoutStore {
  _Store(this.chosen);
  final ReceiptLayout chosen;
  @override
  Future<ReceiptLayout> resolve(
    ReceiptChannel channel, {
    String? branchId,
    ReceiptLayout? fallback,
  }) async =>
      chosen;
}

class _NoContexts extends Fake implements ReceiptContextLoader {}

final _urdu = RegExp(r'[؀-ۿ]');

bool _hasUrdu(String s) => _urdu.hasMatch(s);

class _Setup {
  const _Setup(this.design, this.paper);
  final ReceiptDesign design;
  final ReceiptPaper paper;
  @override
  String toString() => '${design.code}/${paper.code}';
}

const _setups = [
  _Setup(ReceiptDesign.thermalClassic, ReceiptPaper.roll80),
  _Setup(ReceiptDesign.thermalClassic, ReceiptPaper.roll58),
  _Setup(ReceiptDesign.thermalCompact, ReceiptPaper.roll80),
  _Setup(ReceiptDesign.a4TaxInvoice, ReceiptPaper.a4),
  _Setup(ReceiptDesign.a4Elegant, ReceiptPaper.a4),
];

ReceiptLayout _layout(
  _Setup s,
  ReceiptLanguage language, {
  ReceiptLayoutConfig Function(ReceiptLayoutConfig c)? tweak,
}) {
  var config = ReceiptLayoutConfig.defaultsFor(s.design, pharmacy: true)
      .withValue('footer', 'text_en', 'Thank you for shopping with us.')
      .withValue('footer', 'text_ur', 'ہماری دکان پر آنے کا شکریہ')
      .withLanguage(language);
  if (tweak != null) config = tweak(config);
  return ReceiptLayout(
    id: 'l-${s.design.code}-${s.paper.code}',
    name: s.design.title,
    design: s.design,
    paper: s.paper,
    config: config,
  );
}

ReceiptModel _model(ReceiptLayout l) => ReceiptModelBuilder.build(
      ReceiptSamples.sale(),
      l,
      ReceiptChannel.print,
      context: ReceiptSamples.context(),
      now: DateTime(2026, 11, 17, 10, 30),
    );

/// Every caption the model prints (not product names or values).
List<String> _captions(ReceiptModel m) => [
      m.title,
      for (final r in m.meta) r.label,
      for (final c in m.columns) c.label,
      // The tax row carries the tax's own name (e.g. "GST 17%"), not a caption.
      for (final t in m.totals) if (t.key != 'tax') t.label,
      for (final p in m.payments) p.label,
    ];

List<String> _altCaptions(ReceiptModel m) => [
      if (m.titleAlt != null) m.titleAlt!,
      for (final r in m.meta) if (r.labelAlt != null) r.labelAlt!,
      for (final c in m.columns) if (c.labelAlt != null) c.labelAlt!,
      for (final t in m.totals) if (t.labelAlt != null) t.labelAlt!,
      for (final p in m.payments) if (p.labelAlt != null) p.labelAlt!,
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('default label sets are complete', () {
    test('every caption has English and Urdu text', () {
      expect(ReceiptLabelDefaults.all, isNotEmpty);
      for (final e in ReceiptLabelDefaults.all.entries) {
        expect(e.value.en.trim(), isNotEmpty, reason: '${e.key} en');
        expect(e.value.ur.trim(), isNotEmpty, reason: '${e.key} ur');
        expect(_hasUrdu(e.value.ur), isTrue, reason: '${e.key} ur is Urdu script');
        expect(_hasUrdu(e.value.en), isFalse, reason: '${e.key} en is English');
      }
    });

    test('a fresh layout carries all of them', () {
      final c = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic);
      for (final k in ReceiptLabelDefaults.all.keys) {
        expect(c.label(k).en, isNotEmpty, reason: k);
        expect(c.label(k).ur, isNotEmpty, reason: k);
      }
      expect(c.language, ReceiptLanguage.en);
    });
  });

  for (final s in _setups) {
    group('$s', () {
      test('English: no Urdu caption or footer anywhere', () {
        final m = _model(_layout(s, ReceiptLanguage.en));
        expect(m.language, ReceiptLanguage.en);
        expect(m.rtl, isFalse);
        expect(_altCaptions(m), isEmpty);
        for (final c in _captions(m)) {
          expect(_hasUrdu(c), isFalse, reason: c);
        }
        expect(m.footerLines, ['Thank you for shopping with us.']);
        expect(m.taxNoteAlt, isNull);
        expect(m.voidAlt, isNull);
        // Customer and product names are data (the sample has Urdu ones); no
        // built-in Urdu caption may appear.
        final all = m.allTexts.join('\n');
        for (final l in ReceiptLabelDefaults.all.values) {
          expect(all, isNot(contains(l.ur)), reason: l.ur);
        }
      });

      test('English captions are the English words', () {
        final m = _model(_layout(s, ReceiptLanguage.en));
        final labels = [for (final r in m.meta) r.label];
        expect(labels.any((l) => l.contains('Receipt #') || l.contains('Invoice')), isTrue);
        expect(labels, contains('Date'));
        expect([for (final t in m.totals) t.label], contains('Total'));
      });

      test('Urdu: every caption and the footer are Urdu, none are English', () {
        final m = _model(_layout(s, ReceiptLanguage.ur));
        expect(m.language, ReceiptLanguage.ur);
        expect(m.rtl, isTrue);
        expect(_altCaptions(m), isEmpty, reason: 'one language only');
        for (final c in _captions(m)) {
          expect(_hasUrdu(c), isTrue, reason: 'caption "$c" is Urdu');
        }
        expect(m.footerLines, ['ہماری دکان پر آنے کا شکریہ']);
        final labels = [for (final r in m.meta) r.label];
        expect(labels, contains('تاریخ'));
        expect([for (final t in m.totals) t.label], contains('کل'));
        expect(m.allTexts.join('\n'), isNot(contains('Receipt #')));
      });

      test('Both: English caption with the Urdu one under it, footer in two lines', () {
        final m = _model(_layout(s, ReceiptLanguage.both));
        expect(m.language, ReceiptLanguage.both);
        expect(m.rtl, isFalse);
        expect(m.footerLines, ['Thank you for shopping with us.', 'ہماری دکان پر آنے کا شکریہ']);
        final total = m.totals.firstWhere((t) => t.key == 'total');
        expect(total.label, 'Total');
        expect(total.labelAlt, 'کل');
        final date = m.meta.firstWhere((r) => r.key == 'date');
        expect(date.label, 'Date');
        expect(date.labelAlt, 'تاریخ');
        expect(m.titleAlt, isNotNull);
      });

      test('Both with a single-language footer prints just that line', () {
        final m = _model(_layout(s, ReceiptLanguage.both,
            tweak: (c) => c.withValue('footer', 'text_ur', '')));
        expect(m.footerLines, ['Thank you for shopping with us.']);
      });

      test('product names print as entered in every language', () {
        final sale = ReceiptSamples.sale();
        final names = [for (final l in sale.lines) l.productName];
        for (final lang in ReceiptLanguage.values) {
          final m = _model(_layout(s, lang));
          final printed = [for (final i in m.items) i.name].join('\n');
          for (final n in names) {
            expect(printed, contains(n), reason: '$lang: $n');
          }
        }
      });

      test('WhatsApp text: English has no Urdu and no right-to-left marks', () {
        final text = ReceiptPlainText.render(_model(_layout(s, ReceiptLanguage.en)));
        for (final l in ReceiptLabelDefaults.all.values) {
          expect(text, isNot(contains(l.ur)), reason: l.ur);
        }
        expect(text, isNot(contains('ہماری دکان')));
        expect(text, isNot(contains(ReceiptPlainText.rlm)));
        expect(text, contains('Total'));
        expect(text, contains('Thank you for shopping with us.'));
      });

      test('WhatsApp text: Urdu starts every line right-to-left', () {
        final text = ReceiptPlainText.render(_model(_layout(s, ReceiptLanguage.ur)));
        // The public link is left bare so WhatsApp keeps it tappable.
        final lines = text.split('\n').where((l) => l.trim().isNotEmpty && !l.startsWith('http'));
        expect(lines, isNotEmpty);
        for (final l in lines) {
          expect(l.startsWith(ReceiptPlainText.rlm), isTrue, reason: l);
        }
        expect(text, contains('کل'));
        expect(text, contains('ہماری دکان پر آنے کا شکریہ'));
        expect(text, isNot(contains('Receipt #')));
        expect(text, isNot(contains('Thank you')));
      });

      test('WhatsApp text: both puts the Urdu caption under the English one', () {
        final text = ReceiptPlainText.render(_model(_layout(s, ReceiptLanguage.both)));
        final lines = text.split('\n');
        final i = lines.indexWhere((l) => l.contains('Total'));
        expect(i, isNonNegative);
        expect(lines[i + 1], contains('کل'));
        expect(text, contains('Thank you for shopping with us.'));
        expect(text, contains('ہماری دکان پر آنے کا شکریہ'));
      });

      test('PDF renders in every language', () async {
        for (final lang in ReceiptLanguage.values) {
          final doc = await ReceiptPdfRenderer.build(_model(_layout(s, lang)));
          final bytes = await doc.save();
          expect(String.fromCharCodes(bytes.take(5)), '%PDF-', reason: '$lang');
          expect(doc.document.pdfPageList.pages, isNotEmpty, reason: '$lang');
        }
      });
    });
  }

  group('preview', () {
    Future<void> show(WidgetTester t, ReceiptModel m) async {
      t.view.physicalSize = const Size(900, 2600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ReceiptView(model: m))),
      ));
      await t.pumpAndSettle();
    }

    List<String> shown(WidgetTester t) => [
          for (final w in t.widgetList<Text>(find.byType(Text)))
            if (w.data != null) w.data!,
        ];

    for (final s in _setups) {
      testWidgets('$s English shows no Urdu text', (t) async {
        await show(t, _model(_layout(s, ReceiptLanguage.en)));
        // Names of customers and products are data; captions and footer must be English.
        final urdu = shown(t).where(_hasUrdu).toList();
        for (final l in ReceiptLabelDefaults.all.values) {
          expect(urdu, isNot(contains(l.ur)), reason: l.ur);
        }
        expect(urdu, isNot(contains('ہماری دکان پر آنے کا شکریہ')));
        expect(find.text('Total'), findsWidgets);
      });

      testWidgets('$s Urdu shows Urdu captions, no English ones', (t) async {
        await show(t, _model(_layout(s, ReceiptLanguage.ur)));
        final texts = shown(t);
        expect(texts, contains('ہماری دکان پر آنے کا شکریہ'));
        expect(texts, isNot(contains('Total')));
        expect(texts.any((x) => x.contains('Receipt #')), isFalse);
      });

      testWidgets('$s Both shows each caption twice (English and Urdu)', (t) async {
        await show(t, _model(_layout(s, ReceiptLanguage.both)));
        final texts = shown(t);
        expect(texts, contains('Total'));
        expect(texts, contains('کل'));
      });
    }

    testWidgets('Urdu mirrors the layout right-to-left; English stays left-to-right', (t) async {
      final s = _setups.first;
      await show(t, _model(_layout(s, ReceiptLanguage.ur)));
      TextDirection dir() =>
          Directionality.of(t.element(find.text('ہماری دکان پر آنے کا شکریہ').first));
      expect(dir(), TextDirection.rtl);

      // A caption sits on the right of its value in Urdu...
      final label = t.getTopRight(find.text('کل').first);
      final rowValue = t.getTopLeft(find.text('کل').first);
      expect(label.dx, greaterThan(rowValue.dx));

      await show(t, _model(_layout(s, ReceiptLanguage.en)));
      final total = t.getTopLeft(find.text('Total').first);
      // ... and on the left in English: the caption starts at the sheet's left edge.
      final sheet = t.getTopLeft(find.byType(ReceiptView));
      final sheetRight = t.getTopRight(find.byType(ReceiptView));
      expect(total.dx - sheet.dx, lessThan(sheetRight.dx - total.dx));
    });
  });

  group('migration of layouts saved before the language setting', () {
    Map<String, dynamic> old({Map<String, dynamic>? labels, Map<String, dynamic>? footer, bool both = false}) => {
          if (labels != null) 'labels': labels,
          if (footer != null) 'footer': footer,
          if (both) 'style': {'language': 'both'},
        };

    test('plain old layout becomes English', () {
      expect(ReceiptLayoutConfig.fromJson(old()).language, ReceiptLanguage.en);
      expect(ReceiptLayoutConfig.fromJson(null).language, ReceiptLanguage.en);
    });

    test('built-in Urdu captions alone do not make it bilingual', () {
      final c = ReceiptLayoutConfig.fromJson(old(labels: {
        'total': {'en': 'Total', 'ur': ReceiptLabelDefaults.all['total']!.ur},
      }));
      expect(c.language, ReceiptLanguage.en);
    });

    test('an Urdu caption the owner edited makes it "both"', () {
      final c = ReceiptLayoutConfig.fromJson(old(labels: {
        'total': {'en': 'Total', 'ur': 'میزان'},
      }));
      expect(c.language, ReceiptLanguage.both);
      expect(c.label('total').ur, 'میزان');
    });

    test('an Urdu footer makes it "both"', () {
      final c = ReceiptLayoutConfig.fromJson(old(footer: {'text_en': 'Thanks', 'text_ur': 'شکریہ'}));
      expect(c.language, ReceiptLanguage.both);
    });

    test('an English-only footer stays English', () {
      final c = ReceiptLayoutConfig.fromJson(old(footer: {'text_en': 'Thanks'}));
      expect(c.language, ReceiptLanguage.en);
    });

    test('a saved language is never overridden', () {
      for (final lang in ReceiptLanguage.values) {
        final c = ReceiptLayoutConfig.fromJson({
          'style': {'language': lang.code},
          'footer': {'text_ur': 'شکریہ'},
        });
        expect(c.language, lang);
      }
    });

    test('the language survives a round trip and the old name_language is gone', () {
      final c = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic)
          .withLanguage(ReceiptLanguage.ur);
      final json = c.toJson();
      expect((json['style'] as Map)['language'], 'ur');
      expect((json['items'] as Map).containsKey('name_language'), isFalse);
      expect(ReceiptLayoutConfig.fromJson(json).language, ReceiptLanguage.ur);
    });
  });

  group('the old footer setting is only a fallback', () {
    final sale = ReceiptSamples.sale();

    ReceiptService service(ReceiptLayout layout, {Future<String?> Function(String?)? legacy}) =>
        ReceiptService(
          layouts: _Store(layout),
          contexts: _NoContexts(),
          legacyFooter: legacy,
        );

    ReceiptLayout blank() => ReceiptLayout(
          id: 'l',
          name: 'n',
          design: ReceiptDesign.thermalClassic,
          paper: ReceiptPaper.roll80,
          config: ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic)
              .withValue('footer', 'text_en', '')
              .withValue('footer', 'text_ur', ''),
        );

    test('a layout without footer text uses the old one', () async {
      final p = await service(blank(), legacy: (_) async => 'Old footer')
          .prepare(sale, ReceiptChannel.print, context: ReceiptSamples.context());
      expect(p.model.footerLines, ['Old footer']);
    });

    test('a layout with its own footer ignores the old one', () async {
      final own = blank().copyWith(config: blank().config.withValue('footer', 'text_en', 'Own'));
      final p = await service(own, legacy: (_) async => 'Old footer')
          .prepare(sale, ReceiptChannel.print, context: ReceiptSamples.context());
      expect(p.model.footerLines, ['Own']);
    });

    test('an error reading the old footer is ignored', () async {
      final p = await service(blank(), legacy: (_) async => throw StateError('boom'))
          .prepare(sale, ReceiptChannel.print, context: ReceiptSamples.context());
      expect(p.model.footerLines, isEmpty);
    });
  });

  group('footer lines per language', () {
    final f = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic)
        .withValue('footer', 'text_en', 'Thanks')
        .withValue('footer', 'text_ur', 'شکریہ')
        .footer;

    test('one language shows one line, both shows two', () {
      expect(f.linesFor(ReceiptLanguage.en), ['Thanks']);
      expect(f.linesFor(ReceiptLanguage.ur), ['شکریہ']);
      expect(f.linesFor(ReceiptLanguage.both), ['Thanks', 'شکریہ']);
    });

    test('a language without its own text prints nothing (no borrowing)', () {
      final onlyEn = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic)
          .withValue('footer', 'text_en', 'Thanks')
          .withValue('footer', 'text_ur', '')
          .footer;
      expect(onlyEn.linesFor(ReceiptLanguage.ur), isEmpty);
    });
  });
}
