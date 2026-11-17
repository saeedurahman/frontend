import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/receipts/presentation/pages/receipt_layouts_page.dart';

import '../sync/sync_rig.dart';
import 'fake_layout_api.dart';

void main() {
  late SyncRig rig;
  late ReceiptLayoutStore store;
  late FakeLayoutApi api;
  var online = true;

  setUp(() {
    rig = SyncRig();
    store = ReceiptLayoutStore(rig.store);
    api = FakeLayoutApi();
    online = true;
  });

  tearDown(() => rig.dispose());

  ReceiptLayoutsCubit cubit() => ReceiptLayoutsCubit(
        store: store,
        api: api,
        isOnline: () => online,
      );

  group('defaults when nothing was pulled', () {
    test('resolve gives the built-in classic receipt for every channel', () async {
      for (final c in ReceiptChannel.values) {
        final l = await store.resolve(c, branchId: kBranch);
        expect(l.isBuiltIn, isTrue, reason: c.code);
        expect(l.design, ReceiptDesign.thermalClassic);
      }
    });

    test('the built-in layout never shows pending/sync text and keeps Powered by', () {
      final l = ReceiptLayout.builtIn();
      expect(l.config.toJson().toString().toLowerCase(), isNot(contains('pending')));
      expect(l.config.toJson().toString().toLowerCase(), isNot(contains('sync')));
    });

    testWidgets('the page says so when the list is empty', (t) async {
      online = false;
      await _pump(rig, store, api, () => online, tester: t);
      expect(find.byKey(const Key('layouts-empty')), findsOneWidget);
    });
  });

  group('assignment resolution', () {
    test('branch override beats the business default beats the first classic', () async {
      final a = api.seed('Counter', ReceiptDesign.thermalClassic);
      final b = api.seed('Tax', ReceiptDesign.a4TaxInvoice);
      final c = api.seed('Branch special', ReceiptDesign.thermalCompact);
      api.assign(ReceiptChannel.print, '${b['id']}');
      api.assign(ReceiptChannel.print, '${c['id']}', branchId: kBranch);
      final cb = cubit();
      await cb.load();
      await cb.close();

      expect((await store.resolve(ReceiptChannel.print, branchId: kBranch)).id, c['id']);
      expect((await store.resolve(ReceiptChannel.print, branchId: 'other')).id, b['id']);
      // Nothing assigned for WhatsApp: the classic layout is used.
      expect((await store.resolve(ReceiptChannel.whatsapp)).id, a['id']);
    });
  });

  group('cubit CRUD against the fake server', () {
    test('load copies the server layouts into the device and drops removed ones', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      api.seed('Two', ReceiptDesign.a4Elegant);
      final cb = cubit();
      await cb.load();
      expect(cb.state.layouts.map((l) => l.name), ['One', 'Two']);

      api.layouts.remove(a['id']);
      await cb.load();
      expect(cb.state.layouts.map((l) => l.name), ['Two']);
      expect(await store.layout('${a['id']}'), isNull);
      await cb.close();
    });

    test('create from a design saves on the server, then locally', () async {
      final cb = cubit();
      await cb.load();
      final made = await cb.create(design: ReceiptDesign.a4Elegant, name: '  Fancy  ');
      expect(made!.name, 'Fancy');
      expect(made.design, ReceiptDesign.a4Elegant);
      expect(api.layouts.containsKey(made.id), isTrue);
      expect((await store.layout(made.id))!.name, 'Fancy');
      expect(cb.state.layouts, hasLength(1));
      expect(cb.state.notice, 'Layout created.');
      await cb.close();
    });

    test('create with a blank name uses the design name', () async {
      final cb = cubit();
      await cb.load();
      final made = await cb.create(design: ReceiptDesign.thermalCompact, name: ' ');
      expect(made!.name, ReceiptDesign.thermalCompact.title);
      await cb.close();
    });

    test('duplicate makes a copy with its own id', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      final cb = cubit();
      await cb.load();
      final copy = await cb.duplicate('${a['id']}', name: 'One copy');
      expect(copy!.id, isNot(a['id']));
      expect(cb.state.layouts.map((l) => l.name), containsAll(['One', 'One copy']));
      await cb.close();
    });

    test('rename changes the name; an empty name is refused without a call', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      api.seed('Two', ReceiptDesign.thermalCompact);
      final cb = cubit();
      await cb.load();
      expect(await cb.rename('${a['id']}', 'Front desk'), isTrue);
      expect((await store.layout('${a['id']}'))!.name, 'Front desk');

      api.calls.clear();
      expect(await cb.rename('${a['id']}', '   '), isFalse);
      expect(api.calls, isEmpty);
      expect(cb.state.error, contains('name'));
      await cb.close();
    });

    test('delete removes the layout', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      api.seed('Two', ReceiptDesign.thermalCompact);
      final cb = cubit();
      await cb.load();
      expect(await cb.delete('${a['id']}'), isTrue);
      expect(api.layouts.containsKey(a['id']), isFalse);
      expect(cb.state.layouts, hasLength(1));
      await cb.close();
    });

    test('the last layout cannot be deleted and the server is not asked', () async {
      final a = api.seed('Only', ReceiptDesign.thermalClassic);
      final cb = cubit();
      await cb.load();
      api.calls.clear();
      expect(await cb.delete('${a['id']}'), isFalse);
      expect(api.calls, isEmpty);
      expect(cb.state.error, contains('at least one'));
      await cb.close();
    });

    test('a layout that is a default is refused by the server with its own words', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      api.seed('Two', ReceiptDesign.thermalCompact);
      api.assign(ReceiptChannel.print, '${a['id']}');
      final cb = cubit();
      await cb.load();
      expect(await cb.delete('${a['id']}'), isFalse);
      expect(cb.state.error, contains('used as a default'));
      expect(await store.layout('${a['id']}'), isNotNull);
      await cb.close();
    });

    test('assign saves the default and branch overrides can be removed', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      final b = api.seed('Two', ReceiptDesign.thermalCompact);
      final cb = cubit();
      await cb.load();

      expect(await cb.assign(ReceiptChannel.print, '${a['id']}'), isTrue);
      expect(await cb.assign(ReceiptChannel.print, '${b['id']}', branchId: kBranch), isTrue);
      expect(cb.state.defaultFor(ReceiptChannel.print)!.id, a['id']);
      expect(cb.state.overrideFor(ReceiptChannel.print, kBranch)!.id, b['id']);
      expect(cb.state.usedBy('${a['id']}'), [ReceiptChannel.print]);

      expect(await cb.assign(ReceiptChannel.print, null, branchId: kBranch), isTrue);
      expect(cb.state.overrideFor(ReceiptChannel.print, kBranch), isNull);
      await cb.close();
    });
  });

  group('offline', () {
    test('changes are refused with a friendly message and nothing is sent', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      final cb = cubit();
      await cb.load();
      online = false;
      api.calls.clear();

      expect(await cb.create(design: ReceiptDesign.thermalClassic, name: 'x'), isNull);
      expect(await cb.rename('${a['id']}', 'y'), isFalse);
      expect(api.calls, isEmpty);
      expect(cb.state.error, ReceiptLayoutsCubit.offlineMessage);
      expect(cb.state.online, isFalse);
      await cb.close();
    });

    test('layouts already on the device still load while offline', () async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      final first = cubit();
      await first.load();
      await first.close();

      online = false;
      final cb = cubit();
      await cb.load();
      expect(cb.state.layouts.single.id, a['id']);
      expect(cb.state.online, isFalse);
      await cb.close();
    });
  });

  group('list page', () {
    testWidgets('shows each layout with where it is used', (t) async {
      final a = api.seed('Counter receipt', ReceiptDesign.thermalClassic);
      api.seed('Tax invoice', ReceiptDesign.a4TaxInvoice);
      api.assign(ReceiptChannel.print, '${a['id']}');
      await _pump(rig, store, api, () => online, tester: t);

      expect(find.text('Counter receipt'), findsOneWidget);
      expect(find.text('Tax invoice'), findsOneWidget);
      expect(find.byKey(Key('used-by-${a['id']}-print')), findsOneWidget);
    });

    testWidgets('offline shows the notice and keeps the list', (t) async {
      api.seed('Counter receipt', ReceiptDesign.thermalClassic);
      final seeded = cubit();
      await seeded.load();
      await seeded.close();
      online = false;
      await _pump(rig, store, api, () => online, tester: t);

      expect(find.byKey(const Key('layouts-offline-notice')), findsOneWidget);
      expect(find.text('Counter receipt'), findsOneWidget);
    });

    testWidgets('New layout > design > Create adds a layout on the server', (t) async {
      await _pump(rig, store, api, () => online, tester: t);
      await t.tap(find.byKey(const Key('new-layout')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('new-layout-name')), 'Elegant A4');
      await t.tap(find.byKey(const Key('new-design-a4_elegant')));
      await t.pump();
      await t.tap(find.byKey(const Key('create-layout-confirm')));
      await t.pumpAndSettle();

      expect(api.layouts.values.map((l) => l['name']), ['Elegant A4']);
      expect(api.layouts.values.single['design'], 'a4_elegant');
      // After creating, the editor opens on the new layout.
      expect(find.textContaining('editor lay-'), findsOneWidget);
    });

    testWidgets('delete asks first, then removes', (t) async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      api.seed('Two', ReceiptDesign.thermalCompact);
      await _pump(rig, store, api, () => online, tester: t);

      await t.tap(find.byKey(Key('layout-menu-${a['id']}')));
      await t.pumpAndSettle();
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();
      expect(api.layouts, hasLength(2)); // nothing yet: confirm first
      await t.tap(find.byKey(const Key('confirm-delete-layout')));
      await t.pumpAndSettle();
      expect(api.layouts, hasLength(1));
      expect(find.text('One'), findsNothing);
    });

    testWidgets('the last layout cannot be deleted from the menu', (t) async {
      final a = api.seed('Only', ReceiptDesign.thermalClassic);
      await _pump(rig, store, api, () => online, tester: t);
      await t.tap(find.byKey(Key('layout-menu-${a['id']}')));
      await t.pumpAndSettle();
      expect(find.text('Delete (keep at least one)'), findsOneWidget);
      await t.tap(find.text('Delete (keep at least one)'), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(api.layouts, hasLength(1));
    });

    testWidgets('rename through the dialog', (t) async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      await _pump(rig, store, api, () => online, tester: t);
      await t.tap(find.byKey(Key('layout-menu-${a['id']}')));
      await t.pumpAndSettle();
      await t.tap(find.text('Rename'));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('rename-field')), 'Front counter');
      await t.tap(find.byKey(const Key('rename-confirm')));
      await t.pumpAndSettle();
      expect(api.layouts[a['id']]!['name'], 'Front counter');
      expect(find.text('Front counter'), findsOneWidget);
    });

    testWidgets('duplicate adds a copy', (t) async {
      final a = api.seed('One', ReceiptDesign.thermalClassic);
      await _pump(rig, store, api, () => online, tester: t);
      await t.tap(find.byKey(Key('layout-menu-${a['id']}')));
      await t.pumpAndSettle();
      await t.tap(find.text('Duplicate'));
      await t.pumpAndSettle();
      expect(api.layouts.values.map((l) => l['name']), containsAll(['One', 'One copy']));
    });
  });
}

Future<void> _pump(
  SyncRig rig,
  ReceiptLayoutStore store,
  FakeLayoutApi api,
  bool Function() isOnline, {
  required WidgetTester tester,
}) async {
  Future<void> body(WidgetTester t) async {
    t.view.physicalSize = const Size(1400, 1000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => ReceiptLayoutsPage(store: store, api: api, isOnline: isOnline),
        ),
        GoRoute(
          path: '/settings/receipt-layouts/:id',
          builder: (_, s) => Scaffold(body: Text('editor ${s.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/settings/receipt-layouts/assignments',
          builder: (_, __) => const Scaffold(body: Text('assignments')),
        ),
        GoRoute(path: '/settings', builder: (_, __) => const Scaffold(body: Text('settings'))),
      ],
    );
    await t.pumpWidget(MaterialApp.router(routerConfig: router));
    await t.pumpAndSettle();
  }

  await body(tester);
}
