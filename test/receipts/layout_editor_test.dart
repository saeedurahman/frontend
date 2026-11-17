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

  testWidgets('shows the controls and a live preview of the sample sale', (t) async {
    await open(t);
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
    expect(find.byKey(const Key('switch-header-show_ntn')), findsOneWidget);
    expect(find.byKey(const Key('editor-test-print')), findsOneWidget);
    expect(find.byKey(const Key('editor-save-pdf')), findsOneWidget);
    expect(find.textContaining('NTN: 1234567-8'), findsOneWidget);
    // Save stays off until something changes.
    expect(saveButton(t).onPressed, isNull);
  });

  testWidgets('a switch changes the live preview at once and enables Save', (t) async {
    await open(t);
    expect(find.textContaining('NTN: 1234567-8'), findsOneWidget);

    await t.tap(find.byKey(const Key('switch-header-show_ntn')));
    await t.pumpAndSettle();

    expect(find.textContaining('NTN: 1234567-8'), findsNothing);
    expect(saveButton(t).onPressed, isNotNull);

    await t.tap(find.byKey(const Key('switch-header-show_ntn')));
    await t.pumpAndSettle();
    expect(find.textContaining('NTN: 1234567-8'), findsOneWidget);
    expect(saveButton(t).onPressed, isNull); // back to what is saved
  });

  testWidgets('Save sends the change to the server, then into the device copy', (t) async {
    await open(t);
    await t.tap(find.byKey(const Key('switch-header-show_ntn')));
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
    expect(find.textContaining('NTN: 1234567-8'), findsOneWidget);
    expect(api.calls, isNot(contains('update')));
    // The preview and printing still work offline.
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
    expect(find.byKey(const Key('editor-test-print')), findsOneWidget);
  });

  testWidgets('a preset applies its switches', (t) async {
    await open(t);
    final simple = ReceiptPreset.all.firstWhere((p) => !p.design.isA4);
    await t.tap(find.byKey(Key('preset-${simple.id}')));
    await t.pumpAndSettle();
    expect(saveButton(t).onPressed, isNotNull);
  });

  testWidgets('a missing layout shows a plain message', (t) async {
    id = 'does-not-exist';
    await open(t);
    expect(find.text('This layout was not found on this device.'), findsOneWidget);
  });

  testWidgets('works on a narrow window (preview above the controls)', (t) async {
    await open(t, width: 700);
    expect(find.byKey(const Key('layout-live-preview')), findsOneWidget);
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
