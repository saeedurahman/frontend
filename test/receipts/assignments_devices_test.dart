import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/pages/receipt_assignments_page.dart';
import 'package:frantend/features/settings/presentation/pages/devices_page.dart';
import 'package:go_router/go_router.dart';

import '../sync/sync_rig.dart';
import 'fake_layout_api.dart';

class FakeDevicesApi extends DevicesApi {
  FakeDevicesApi(this.devices) : super(Dio());

  final List<Map<String, dynamic>> devices;
  final List<String> saved = [];
  ReceiptApiException? failWith;
  bool offline = false;

  @override
  Future<List<Map<String, dynamic>>> list() async {
    if (offline) throw const ReceiptApiException('offline', offline: true);
    return [for (final d in devices) Map<String, dynamic>.from(d)];
  }

  @override
  Future<Map<String, dynamic>> setShortCode(String deviceId, String code) async {
    final err = failWith;
    if (err != null) throw err;
    saved.add('$deviceId=$code');
    final d = devices.firstWhere((x) => x['id'] == deviceId);
    d['short_code'] = code;
    return Map<String, dynamic>.from(d);
  }
}

void main() {
  group('assignments page', () {
    late SyncRig rig;
    late ReceiptLayoutStore store;
    late FakeLayoutApi api;
    late Map<String, dynamic> classic;
    late Map<String, dynamic> a4;
    var online = true;

    setUp(() {
      rig = SyncRig();
      store = ReceiptLayoutStore(rig.store);
      api = FakeLayoutApi();
      classic = api.seed('Counter receipt', ReceiptDesign.thermalClassic);
      a4 = api.seed('Tax invoice', ReceiptDesign.a4TaxInvoice);
      online = true;
    });
    tearDown(() => rig.dispose());

    Future<void> open(WidgetTester t) async {
      t.view.physicalSize = const Size(1200, 1600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(
        MaterialApp(
          home: ReceiptAssignmentsPage(
            store: store,
            api: api,
            isOnline: () => online,
            branches: () async => [
              {'id': 'branch-1', 'name': 'Main branch'},
            ],
          ),
        ),
      );
      await t.pumpAndSettle();
    }

    testWidgets('lists every channel with a business pick and a branch pick', (t) async {
      await open(t);
      for (final c in ReceiptChannel.values) {
        expect(find.byKey(Key('assign-${c.code}')), findsOneWidget, reason: c.code);
        // The per-branch list is collapsed until opened.
        expect(find.byKey(Key('assign-${c.code}-branch-1')), findsNothing, reason: c.code);
        await t.tap(find.byKey(Key('override-toggle-${c.code}')));
        await t.pumpAndSettle();
        expect(find.byKey(Key('assign-${c.code}-branch-1')), findsOneWidget, reason: c.code);
      }
    });

    testWidgets('choosing a business default saves it on the server', (t) async {
      await open(t);
      await t.tap(find.byKey(const Key('assign-print')));
      await t.pumpAndSettle();
      await t.tap(find.text('Tax invoice').last);
      await t.pumpAndSettle();

      expect(api.assigned['as-print-biz']!['layout_id'], a4['id']);
      expect((await store.resolve(ReceiptChannel.print)).id, a4['id']);
    });

    testWidgets('a branch can use its own layout, and go back to the business one', (t) async {
      api.assign(ReceiptChannel.print, '${classic['id']}');
      await open(t);
      await t.tap(find.byKey(const Key('override-toggle-print')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('assign-print-branch-1')));
      await t.pumpAndSettle();
      await t.tap(find.text('Tax invoice').last);
      await t.pumpAndSettle();
      expect(api.assigned['as-print-branch-1']!['layout_id'], a4['id']);
      expect((await store.resolve(ReceiptChannel.print, branchId: 'branch-1')).id, a4['id']);

      await t.tap(find.byKey(const Key('assign-print-branch-1')));
      await t.pumpAndSettle();
      await t.tap(find.text('Same as the business').last);
      await t.pumpAndSettle();
      expect(api.assigned.containsKey('as-print-branch-1'), isFalse);
      expect((await store.resolve(ReceiptChannel.print, branchId: 'branch-1')).id, classic['id']);
    });

    testWidgets('offline: notice shown and the pickers are disabled', (t) async {
      // Layouts already on the device (pulled while online) stay usable.
      final seeded = ReceiptLayoutsCubit(store: store, api: api, isOnline: () => true);
      await seeded.load();
      await seeded.close();
      online = false;
      await open(t);
      expect(find.byKey(const Key('assignments-offline-notice')), findsOneWidget);
      final dd = t.widget<DropdownButtonFormField<String?>>(
        find.descendant(
          of: find.byKey(const Key('assign-print')),
          matching: find.byType(DropdownButtonFormField<String?>),
        ),
      );
      expect(dd.onChanged, isNull);
    });
  });

  group('devices page', () {
    Future<void> open(WidgetTester t, FakeDevicesApi api) async {
      t.view.physicalSize = const Size(1000, 900);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final router = GoRouter(routes: [
        GoRoute(path: '/', builder: (_, __) => DevicesPage(api: api)),
      ]);
      await t.pumpWidget(MaterialApp.router(routerConfig: router));
      await t.pumpAndSettle();
    }

    FakeDevicesApi make() => FakeDevicesApi([
          {'id': 'd1', 'name': 'Front counter', 'short_code': 'C1'},
          {'id': 'd2', 'name': 'Back counter', 'short_code': 'C2'},
          {'id': 'd3', 'name': 'Old laptop', 'short_code': 'C3', 'revoked_at': '2026-01-01'},
        ]);

    testWidgets('shows each device with its code', (t) async {
      await open(t, make());
      expect(find.text('Front counter'), findsOneWidget);
      expect(find.text('Code: C1'), findsOneWidget);
      expect(find.textContaining('removed'), findsOneWidget);
    });

    testWidgets('the owner can change a code', (t) async {
      final api = make();
      await open(t, api);
      await t.tap(find.byKey(const Key('edit-code-d1')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('short-code-field')), 'main');
      await t.tap(find.byKey(const Key('short-code-save')));
      await t.pumpAndSettle();
      expect(api.saved, ['d1=MAIN']);
      expect(find.text('Code: MAIN'), findsOneWidget);
    });

    testWidgets('a code that is taken gets a friendly message', (t) async {
      final api = make()
        ..failWith = const ReceiptApiException('x', status: 409, code: 'short_code_taken');
      await open(t, api);
      await t.tap(find.byKey(const Key('edit-code-d1')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('short-code-field')), 'C2');
      await t.tap(find.byKey(const Key('short-code-save')));
      await t.pumpAndSettle();
      expect(find.textContaining('Another counter already uses "C2"'), findsOneWidget);
      expect(find.text('Code: C1'), findsOneWidget);
    });

    testWidgets('a code with spaces or symbols is refused before asking the server', (t) async {
      final api = make();
      await open(t, api);
      await t.tap(find.byKey(const Key('edit-code-d1')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('short-code-field')), 'A-B');
      await t.tap(find.byKey(const Key('short-code-save')));
      await t.pumpAndSettle();
      expect(api.saved, isEmpty);
      expect(find.textContaining('letters and numbers'), findsWidgets);
    });

    testWidgets('a removed device cannot be edited', (t) async {
      await open(t, make());
      final button = t.widget<TextButton>(find.byKey(const Key('edit-code-d3')));
      expect(button.onPressed, isNull);
    });

    testWidgets('offline shows a plain message and can retry', (t) async {
      final api = make()..offline = true;
      await open(t, api);
      expect(find.byKey(const Key('devices-error')), findsOneWidget);
      api.offline = false;
      await t.tap(find.text('Try again'));
      await t.pumpAndSettle();
      expect(find.text('Front counter'), findsOneWidget);
    });
  });
}
