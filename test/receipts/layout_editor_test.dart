import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_switches.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layout_editor_cubit.dart';
import 'package:frantend/features/receipts/presentation/pages/receipt_layout_editor_page.dart';
import 'package:go_router/go_router.dart';

import '../sync/sync_rig.dart';
import 'fake_layout_api.dart';

void main() {
  late SyncRig rig;
  late ReceiptLayoutStore store;
  late FakeLayoutApi api;
  late String id;
  var online = true;

  setUp(() async {
    rig = SyncRig();
    store = ReceiptLayoutStore(rig.store);
    api = FakeLayoutApi();
    online = true;
    final json = api.seed('Counter receipt', ReceiptDesign.thermalClassic, pharmacy: true);
    id = '${json['id']}';
    await store.putLayout(json);
  });

  tearDown(() => rig.dispose());

  Future<void> open(WidgetTester t, {double width = 1500}) async {
    t.view.physicalSize = Size(width, 1100);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final router = GoRouter(
      initialLocation: '/editor',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const Scaffold(body: Text('home'))),
        GoRoute(
          path: '/settings/receipt-layouts',
          builder: (_, __) => const Scaffold(body: Text('layouts-list-page')),
        ),
        GoRoute(
          path: '/settings/receipt-layouts/:id',
          builder: (_, s) => Scaffold(body: Text('editor ${s.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/settings/business',
          builder: (_, __) => const Scaffold(body: Text('business-profile-page')),
        ),
        GoRoute(
          path: '/editor',
          builder: (_, __) => ReceiptLayoutEditorPage(
            layoutId: id,
            store: store,
            api: api,
            isOnline: () => online,
          ),
        ),
      ],
    );
    await t.pumpWidget(MaterialApp.router(routerConfig: router));
    await t.pumpAndSettle();
  }

  FilledButton saveButton(WidgetTester t) =>
      t.widget<FilledButton>(find.byKey(const Key('editor-save')));

  Future<void> tapKey(WidgetTester t, String key) async {
    await t.ensureVisible(find.byKey(Key(key)));
    await t.pumpAndSettle();
    await t.tap(find.byKey(Key(key)));
    await t.pumpAndSettle();
  }

  Finder inPreview(Finder f) =>
      find.descendant(of: find.byKey(const Key('layout-live-preview')), matching: f);

  testWidgets('shows the controls and a live preview of the sample sale', (t) async {
    await open(t);
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
    expect(find.byKey(const Key('switch-header-show_ntn')), findsOneWidget);
    expect(find.byKey(const Key('editor-test-print')), findsOneWidget);
    expect(find.byKey(const Key('editor-save-pdf')), findsOneWidget);
    expect(find.byKey(const Key('editor-discard')), findsOneWidget);
    expect(inPreview(find.textContaining('NTN: 1234567-8')), findsOneWidget);
    // Save stays off until something changes.
    expect(saveButton(t).onPressed, isNull);
    expect(find.text('All changes saved'), findsOneWidget);
  });

  testWidgets('sections collapse and open again; the Footer (multi-line fields) does not throw',
      (t) async {
    await open(t);
    // Header starts open, the others closed.
    expect(find.byKey(const Key('section-body-header')), findsOneWidget);
    expect(find.byKey(const Key('section-body-footer')), findsNothing);

    await t.tap(find.byKey(const Key('section-header-header')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('section-body-header')), findsNothing);
    expect(find.byKey(const Key('switch-header-show_ntn')), findsNothing);

    await t.ensureVisible(find.byKey(const Key('section-header-footer')));
    await t.tap(find.byKey(const Key('section-header-footer')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('section-body-footer')), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
    expect(t.takeException(), isNull);

    await t.tap(find.byKey(const Key('section-header-footer')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('section-header-footer')));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  testWidgets('a switch changes the live preview at once and enables Save', (t) async {
    await open(t);
    expect(inPreview(find.textContaining('NTN: 1234567-8')), findsOneWidget);

    await tapKey(t, 'switch-header-show_ntn');
    await t.pumpAndSettle();

    expect(inPreview(find.textContaining('NTN: 1234567-8')), findsNothing);
    expect(saveButton(t).onPressed, isNotNull);
    expect(find.text('Unsaved changes'), findsOneWidget);

    await tapKey(t, 'switch-header-show_ntn');
    await t.pumpAndSettle();
    expect(inPreview(find.textContaining('NTN: 1234567-8')), findsOneWidget);
    expect(saveButton(t).onPressed, isNull); // back to what is saved
  });

  testWidgets('the language selector switches the preview between English, Urdu and both',
      (t) async {
    await open(t);
    final saved = ReceiptLayout.fromJson(api.layouts[id]!).config;
    final enTotal = saved.label('total').en;
    final urTotal = saved.label('total').ur;
    expect(urTotal, isNotEmpty);

    // English: no Urdu caption anywhere in the receipt.
    expect(inPreview(find.text(enTotal)), findsWidgets);
    expect(inPreview(find.text(urTotal)), findsNothing);

    await t.ensureVisible(find.byKey(const Key('section-header-language-style')));
    await t.tap(find.byKey(const Key('section-header-language-style')));
    await t.pumpAndSettle();

    await t.ensureVisible(find.byKey(const Key('language-ur')));
    await t.tap(find.byKey(const Key('language-ur')));
    await t.pumpAndSettle();
    expect(inPreview(find.text(urTotal)), findsWidgets);
    expect(inPreview(find.text(enTotal)), findsNothing);
    expect(find.text('Paper size'), findsOneWidget);
    expect(saveButton(t).onPressed, isNotNull);

    await t.tap(find.byKey(const Key('language-both')));
    await t.pumpAndSettle();
    expect(inPreview(find.text(urTotal)), findsWidgets);
    expect(inPreview(find.text(enTotal)), findsWidgets);

    await t.tap(find.byKey(const Key('language-en')));
    await t.pumpAndSettle();
    expect(inPreview(find.text(urTotal)), findsNothing);
    expect(saveButton(t).onPressed, isNull);
  });

  testWidgets('caption fields follow the chosen language; the other one is behind an expander',
      (t) async {
    await open(t);
    await t.ensureVisible(find.byKey(const Key('section-header-language-style')));
    await t.tap(find.byKey(const Key('section-header-language-style')));
    await t.pumpAndSettle();

    Finder field(String lang) => find.byWidgetPredicate(
        (w) => w.key is ValueKey && '${(w.key as ValueKey).value}'.startsWith('label-total-$lang-'));

    expect(field('en'), findsOneWidget);
    expect(field('ur'), findsNothing);

    await t.ensureVisible(find.byKey(const Key('show-other-language')));
    await t.tap(find.byKey(const Key('show-other-language')));
    await t.pumpAndSettle();
    expect(field('ur'), findsOneWidget);
    expect(find.text('Hide other language fields'), findsOneWidget);

    await t.ensureVisible(find.byKey(const Key('language-ur')));
    await t.tap(find.byKey(const Key('language-ur')));
    await t.pumpAndSettle();
    // Urdu is now the main set; the expander offers the English ones.
    expect(field('ur'), findsOneWidget);
  });

  testWidgets('paper size is a segmented choice limited to the design', (t) async {
    await open(t);
    await t.ensureVisible(find.byKey(const Key('section-header-language-style')));
    await t.tap(find.byKey(const Key('section-header-language-style')));
    await t.pumpAndSettle();
    final seg = t.widget<SegmentedButton<ReceiptPaper>>(find.byKey(const Key('paper-size')));
    expect(seg.segments.map((s) => s.value), ReceiptPaper.values);
    // A thermal design cannot be set to A4.
    expect(seg.segments.firstWhere((s) => s.value == ReceiptPaper.a4).enabled, isFalse);

    await t.ensureVisible(find.byKey(const Key('paper-roll58')));
    await t.tap(find.byKey(const Key('paper-roll58')));
    await t.pumpAndSettle();
    expect(find.text('58 mm roll · English'), findsOneWidget);
  });

  testWidgets('the design picker shows four designs with a check on the current one', (t) async {
    await open(t);
    for (final d in ReceiptDesign.values) {
      expect(find.byKey(Key('design-card-${d.code}')), findsOneWidget, reason: d.code);
    }
    expect(find.byKey(const Key('design-selected-check')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('design-card-thermal_classic')),
        matching: find.byKey(const Key('design-selected-check')),
      ),
      findsOneWidget,
    );
  });

  testWidgets('choosing another design makes a new layout after a confirmation', (t) async {
    await open(t);
    await t.tap(find.byKey(const Key('design-card-a4_elegant')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('design-switch-dialog')), findsOneWidget);
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    expect(api.calls, isNot(contains('create')));

    await t.tap(find.byKey(const Key('design-card-a4_elegant')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('design-switch-confirm')));
    await t.pumpAndSettle();
    expect(api.calls, contains('create'));
    expect(find.textContaining('editor lay-'), findsOneWidget);
    // The original layout is untouched.
    expect(api.layouts[id]!['design'], 'thermal_classic');
  });

  testWidgets('the logo switch has a link to the Business Profile', (t) async {
    await open(t);
    await t.ensureVisible(find.byKey(const Key('change-logo-link')));
    await t.tap(find.byKey(const Key('change-logo-link')));
    await t.pumpAndSettle();
    expect(find.text('business-profile-page'), findsOneWidget);
  });

  testWidgets('leaving with unsaved changes asks first', (t) async {
    await open(t);
    await tapKey(t, 'switch-header-show_ntn');
    await t.pumpAndSettle();
    expect(find.byKey(const Key('editor-unsaved-dot')), findsOneWidget);

    await t.tap(find.byKey(const Key('editor-back')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('leave-dialog')), findsOneWidget);

    await t.tap(find.byKey(const Key('leave-keep')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('leave-dialog')), findsNothing);
    expect(find.byKey(const Key('editor-form')), findsOneWidget);

    await t.tap(find.byKey(const Key('editor-back')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('leave-discard')));
    await t.pumpAndSettle();
    expect(find.text('layouts-list-page'), findsOneWidget);
  });

  testWidgets('leaving without changes goes straight back', (t) async {
    await open(t);
    await t.tap(find.byKey(const Key('editor-back')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('leave-dialog')), findsNothing);
    expect(find.text('layouts-list-page'), findsOneWidget);
  });

  testWidgets('Discard throws the changes away', (t) async {
    await open(t);
    await tapKey(t, 'switch-header-show_ntn');
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('editor-discard')));
    await t.pumpAndSettle();
    expect(saveButton(t).onPressed, isNull);
    expect(inPreview(find.textContaining('NTN: 1234567-8')), findsOneWidget);
  });

  testWidgets('Save sends the change to the server, then into the device copy', (t) async {
    await open(t);
    await tapKey(t, 'switch-header-show_ntn');
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('editor-save')));
    await t.pumpAndSettle();

    final onServer = ReceiptLayout.fromJson(api.layouts[id]!);
    expect(onServer.config.header.showNtn, isFalse);
    expect((await store.layout(id))!.config.header.showNtn, isFalse);
    expect(find.text('Layout saved.'), findsOneWidget);
    expect(saveButton(t).onPressed, isNull);
  });

  testWidgets('offline: a notice shows, edits are disabled and nothing is sent', (t) async {
    online = false;
    await open(t);
    expect(find.byKey(const Key('editor-offline-notice')), findsOneWidget);
    expect(saveButton(t).onPressed, isNull);

    await t.tap(find.byKey(const Key('switch-header-show_ntn')), warnIfMissed: false);
    await t.pumpAndSettle();
    expect(inPreview(find.textContaining('NTN: 1234567-8')), findsOneWidget);
    expect(api.calls, isNot(contains('update')));
    // The preview and printing still work offline.
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
    expect(find.byKey(const Key('editor-test-print')), findsOneWidget);
  });

  testWidgets('a preset applies its switches', (t) async {
    await open(t);
    final simple = ReceiptPreset.all.firstWhere((p) => !p.design.isA4);
    await t.ensureVisible(find.byKey(Key('preset-${simple.id}')));
    await t.tap(find.byKey(Key('preset-${simple.id}')));
    await t.pumpAndSettle();
    expect(saveButton(t).onPressed, isNotNull);
  });

  testWidgets('a missing layout shows a plain message', (t) async {
    id = 'does-not-exist';
    await open(t);
    expect(find.text('This layout was not found on this device.'), findsOneWidget);
  });

  testWidgets('zoom changes the preview size', (t) async {
    await open(t);
    expect(find.text('100%'), findsOneWidget);
    final before = t.getSize(find.byKey(const Key('layout-live-preview'))).width;
    await t.tap(find.byKey(const Key('preview-zoom-in')));
    await t.pumpAndSettle();
    expect(find.text('125%'), findsOneWidget);
    await t.tap(find.byKey(const Key('preview-zoom-out')));
    await t.tap(find.byKey(const Key('preview-zoom-out')));
    await t.pumpAndSettle();
    expect(find.text('75%'), findsOneWidget);
    expect(t.getSize(find.byKey(const Key('layout-live-preview'))).width, before);
  });

  testWidgets('wide window: editor and preview side by side, no tabs (1024 px)', (t) async {
    await open(t, width: 1024);
    expect(find.byKey(const Key('editor-tabs')), findsNothing);
    expect(find.byKey(const Key('editor-form')), findsOneWidget);
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('narrow window: Edit | Preview tabs and the action bar still fits (600 px)',
      (t) async {
    await open(t, width: 600);
    expect(find.byKey(const Key('editor-tabs')), findsOneWidget);
    expect(find.byKey(const Key('editor-form')), findsOneWidget);
    expect(find.byKey(const Key('layout-live-preview')), findsNothing);

    await t.tap(find.byKey(const Key('tab-preview')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
    expect(find.byKey(const Key('editor-form')), findsNothing);

    await t.tap(find.byKey(const Key('tab-edit')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('editor-form')), findsOneWidget);
    expect(find.byKey(const Key('editor-save')), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('very narrow window (400 px) does not overflow', (t) async {
    await open(t, width: 400);
    expect(t.takeException(), isNull);
    await t.tap(find.byKey(const Key('tab-preview')));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  group('cubit', () {
    ReceiptLayoutEditorCubit make({bool builtIn = false}) {
      final layout = builtIn
          ? ReceiptLayout.builtIn()
          : ReceiptLayout.fromJson(api.layouts[id]!);
      return ReceiptLayoutEditorCubit(
        layout: layout,
        api: api,
        store: store,
        isOnline: () => online,
      );
    }

    test('edits are local until Save and can be discarded', () async {
      final c = make();
      c.setSwitch('footer', 'show_powered_by', false);
      c.setName('Renamed');
      expect(c.state.dirty, isTrue);
      expect(api.calls, isNot(contains('update')));
      c.discard();
      expect(c.state.dirty, isFalse);
      expect(c.state.draft.name, 'Counter receipt');
      await c.close();
    });

    test('labels are editable per language', () async {
      final c = make();
      c.setLabel('total', en: 'Grand total', ur: 'میزان');
      final label = c.state.draft.config.label('total');
      expect(label.en, 'Grand total');
      expect(label.ur, 'میزان');
      await c.close();
    });

    test('font scale is kept inside its range', () async {
      final c = make();
      c.setFontScale(9);
      expect(c.state.draft.config.style.fontScale, 1.4);
      c.setFontScale(0.1);
      expect(c.state.draft.config.style.fontScale, 0.8);
      await c.close();
    });

    test('at most three extra header lines, blanks dropped', () async {
      final c = make();
      c.setExtraLines(['a', ' ', 'b', 'c', 'd']);
      expect(c.state.draft.config.header.extraLines, ['a', 'b', 'c']);
      await c.close();
    });

    test('paper size can be changed and saved', () async {
      final c = make();
      c.setPaper(ReceiptPaper.roll58);
      expect(await c.save(), isTrue);
      expect(api.layouts[id]!['paper'], 'roll58');
      await c.close();
    });

    test('a blank name is refused', () async {
      final c = make();
      c.setName('  ');
      expect(await c.save(), isFalse);
      expect(c.state.error, contains('name'));
      await c.close();
    });

    test('the built-in layout cannot be saved', () async {
      final c = make(builtIn: true);
      c.setName('Changed');
      expect(await c.save(), isFalse);
      expect(c.state.error, contains('built-in'));
      await c.close();
    });

    test('reset goes back to the design defaults', () async {
      final c = make();
      c.setSwitch('header', 'show_ntn', false);
      c.resetToDefaults();
      expect(c.state.draft.config.header.showNtn, ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic).header.showNtn);
      await c.close();
    });

    test('a server refusal keeps the draft and shows the message', () async {
      final c = make();
      c.setName('Changed');
      api.layouts.remove(id); // the server no longer has it
      expect(await c.save(), isFalse);
      expect(c.state.error, 'Not found');
      expect(c.state.dirty, isTrue);
      await c.close();
    });
  });
}
