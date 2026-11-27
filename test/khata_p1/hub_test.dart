import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/khata_hub_page.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';

import '../helpers/khata_p1_fakes.dart';

FakeKhataRepository _repository() => FakeKhataRepository(
      customers: [
        hubRow('c1', 'Ahmed Khan', '45000', age: 45, remindedAt: khataNow.subtract(const Duration(days: 3))),
        hubRow('c2', 'Bilal Traders', '120000', age: 12, promiseDate: DateTime(2026, 12, 15), promiseAmount: '50000'),
        hubRow('c3', 'Zahid', '8000', age: 130, phone: null),
      ],
      suppliers: [hubRow('s1', 'National Foods', '62300', age: 33)],
    );

class _Spy {
  final calls = <String>[];

  HubAction _record(String name) => (context, type, row, branchId) =>
      calls.add('$name ${type.apiValue} ${row.id}');

  KhataHubActions get actions => KhataHubActions(
        open: _record('open'),
        remind: _record('remind'),
        pay: _record('pay'),
        statement: _record('statement'),
        promise: _record('promise'),
      );
}

Future<(FakeKhataRepository, _Spy)> _pump(
  WidgetTester tester, {
  FakeKhataRepository? repository,
  Size size = const Size(1440, 900),
  List<String>? keys,
  PartyType tab = PartyType.customer,
}) async {
  final repo = repository ?? _repository();
  final spy = _Spy();
  await pumpKhata(
    tester,
    KhataHubPage(
      initialTab: tab,
      createCubit: () => KhataHubCubit(repo, initialTab: tab),
      actions: spy.actions,
      clock: () => khataNow,
    ),
    size: size,
    user: keys == null ? null : userWith(keys),
  );
  await settle(tester);
  return (repo, spy);
}

/// The row names from top to bottom.
List<String> _names(WidgetTester tester) {
  const names = ['Ahmed Khan', 'Bilal Traders', 'Zahid'];
  final found = [
    for (final n in names)
      if (find.text(n).evaluate().isNotEmpty)
        (name: n, y: tester.getTopLeft(find.text(n)).dy),
  ]..sort((a, b) => a.y.compareTo(b.y));
  return [for (final f in found) f.name];
}

void main() {
  group('hub cubit', () {
    test('loads both header figures and the rows of its tab', () async {
      final repo = _repository();
      final cubit = KhataHubCubit(repo);
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.loading, isFalse);
      expect(cubit.state.overview!.value.receivable.count, 14);
      expect(
        cubit.state.list!.rows.map((r) => r.id),
        ['c2', 'c1', 'c3'],
        reason: 'biggest amount first',
      );
    });

    test('tab, bucket, sort and search each ask the server again', () async {
      final repo = _repository();
      final cubit = KhataHubCubit(repo);
      addTearDown(cubit.close);
      await cubit.load();

      await cubit.setSort(HubSort.age);
      expect(cubit.state.list!.rows.map((r) => r.id), ['c3', 'c1', 'c2']);
      await cubit.setBucket(AgeBucket.over90);
      expect(repo.hubCalls.last.query.bucket, AgeBucket.over90);
      expect(cubit.state.list!.rows.map((r) => r.id), ['c3']);
      await cubit.setBucket(null);
      await cubit.setSearch('bil');
      expect(cubit.state.list!.rows.map((r) => r.id), ['c2']);
      await cubit.clearFilters();
      expect(cubit.state.hasFilters, isFalse);
      expect(cubit.state.list!.rows, hasLength(3));

      await cubit.setTab(PartyType.supplier);
      expect(repo.hubCalls.last.query.party, PartyType.supplier);
      expect(cubit.state.bucket, isNull);
      expect(cubit.state.list!.rows.single.id, 's1');
    });

    test('pages through a long list and keeps that depth on refresh', () async {
      final repo = FakeKhataRepository(
        customers: [
          for (var i = 0; i < 12; i++)
            hubRow('c$i', 'Customer $i', '${1000 - i}'),
        ],
      );
      final cubit = KhataHubCubit(repo, pageSize: 5);
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.list!.rows, hasLength(5));
      expect(cubit.state.list!.hasMore, isTrue);
      await cubit.loadMore();
      expect(repo.hubCalls.last.skip, 5);
      expect(cubit.state.list!.rows, hasLength(10));
      await cubit.refresh();
      expect(repo.hubCalls.last.limit, 10);
      expect(cubit.state.list!.rows, hasLength(10));
      await cubit.loadMore();
      expect(cubit.state.list!.rows, hasLength(12));
      expect(cubit.state.list!.hasMore, isFalse);
    });

    test('a failed next page keeps the rows and can be retried', () async {
      final repo = FakeKhataRepository(
        customers: [
          for (var i = 0; i < 8; i++) hubRow('c$i', 'Customer $i', '100'),
        ],
      );
      final cubit = KhataHubCubit(repo, pageSize: 5);
      addTearDown(cubit.close);
      await cubit.load();
      repo.hubFailure = const ServerFailure('Server trouble');
      await cubit.loadMore();
      expect(cubit.state.loadMoreFailed, isTrue);
      expect(cubit.state.list!.rows, hasLength(5));
      repo.hubFailure = null;
      await cubit.loadMore();
      expect(cubit.state.list!.rows, hasLength(8));
    });

    test('a refresh that fails keeps the rows; a new filter does not',
        () async {
      final repo = _repository();
      final cubit = KhataHubCubit(repo);
      addTearDown(cubit.close);
      await cubit.load();
      repo.hubFailure = const ServerFailure('Server trouble');
      await cubit.refresh();
      expect(cubit.state.list, isNotNull);
      expect(cubit.state.error, isNull);
      await cubit.setSearch('x');
      expect(cubit.state.list, isNull);
      expect(cubit.state.error, 'Server trouble');
    });

    test('another branch is asked for by id and old figures are dropped',
        () async {
      final repo = _repository();
      final cubit = KhataHubCubit(repo, branchId: 'b1');
      addTearDown(cubit.close);
      await cubit.load();
      await cubit.onBranchChanged('b2');
      expect(repo.overviewCalls.last, 'b2');
      expect(repo.hubCalls.last.query.branchId, 'b2');
    });

    test('reloads when the connection comes back', () async {
      final repo = _repository()..offlineSince = khataNow;
      final probe = FakeProbe(ReachabilityStatus.offline);
      final cubit = KhataHubCubit(repo, probe: probe);
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.offlineAsOf, khataNow);
      repo.offlineSince = null;
      probe.set(ReachabilityStatus.online);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(cubit.state.offlineAsOf, isNull);
    });
  });

  group('hub screen', () {
    testWidgets('shows the totals, party counts and rich rows', (tester) async {
      await _pump(tester);
      expect(find.text(KhataUiText.toReceive), findsOneWidget);
      expect(find.text(KhataUiText.toPay), findsOneWidget);
      expect(find.text('14 customers'), findsOneWidget);
      expect(find.text('5 suppliers'), findsOneWidget);
      expect(find.textContaining('184,500'), findsOneWidget);
      expect(find.byType(AgingBar), findsNWidgets(2));
      expect(_names(tester), ['Bilal Traders', 'Ahmed Khan', 'Zahid']);
      expect(find.text('Oldest bill 45 days'), findsOneWidget);
      expect(find.text('Reminded 3 days ago'), findsOneWidget);
      expect(find.text('Promised 15 Dec'), findsOneWidget);
      expect(find.byKey(const Key('khata-as-of')), findsNothing);
    });

    testWidgets('the tabs switch between customers and suppliers',
        (tester) async {
      await _pump(tester);
      await tester.tap(find.text(HubText.tabSuppliers));
      await settle(tester);
      expect(find.text('National Foods'), findsOneWidget);
      expect(find.text('Ahmed Khan'), findsNothing);
      // The header card is a second way to switch.
      await tester.tap(find.byKey(const ValueKey('khata-total-customer')));
      await settle(tester);
      expect(find.text('Ahmed Khan'), findsOneWidget);
    });

    testWidgets('age chips filter the list and show their amounts',
        (tester) async {
      final (repo, _) = await _pump(tester);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('bucket-90+')),
          matching: find.textContaining('8,000'),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('bucket-90+')));
      await settle(tester);
      expect(repo.hubCalls.last.query.bucket, AgeBucket.over90);
      expect(_names(tester), ['Zahid']);
      await tester.tap(find.byKey(const ValueKey('bucket-all')));
      await settle(tester);
      expect(_names(tester), hasLength(3));
    });

    testWidgets('search waits for typing to stop; no match offers a way back',
        (tester) async {
      final (repo, _) = await _pump(tester);
      final before = repo.hubCalls.length;
      await tester.enterText(find.byKey(const Key('khata-search')), 'za');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byKey(const Key('khata-search')), 'zah');
      await tester.pump(const Duration(milliseconds: 100));
      expect(repo.hubCalls.length, before);
      await settle(tester);
      expect(repo.hubCalls.length, before + 1);
      expect(_names(tester), ['Zahid']);

      await tester.enterText(find.byKey(const Key('khata-search')), 'nobody');
      await settle(tester);
      expect(find.byKey(const Key('khata-empty')), findsOneWidget);
      expect(find.text(HubText.emptyFilterTitle), findsOneWidget);
      await tester.tap(find.text(HubText.clearFilters));
      await settle(tester);
      expect(_names(tester), hasLength(3));
    });

    testWidgets('sorts by name or by the oldest bill', (tester) async {
      await _pump(tester);
      await tester.tap(find.byKey(const Key('khata-sort')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('sort-name')));
      await settle(tester);
      expect(_names(tester), ['Ahmed Khan', 'Bilal Traders', 'Zahid']);
      await tester.tap(find.byKey(const Key('khata-sort')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('sort-age')));
      await settle(tester);
      expect(_names(tester), ['Zahid', 'Ahmed Khan', 'Bilal Traders']);
    });

    testWidgets('F5 refreshes', (tester) async {
      final (repo, _) = await _pump(tester);
      final before = repo.hubCalls.length;
      await tester.sendKeyEvent(LogicalKeyboardKey.f5);
      await settle(tester);
      expect(repo.hubCalls.length, before + 1);
    });

    testWidgets('wide rows always show their actions, quietly, and run them',
        (tester) async {
      final (_, spy) = await _pump(tester);
      // No pointer on any row: everything is there and fully painted.
      for (final row in ['c1', 'c2', 'c3']) {
        for (final id in ['remind', 'pay', 'statement', 'promise']) {
          final button = find.byKey(ValueKey('hub-$id-$row'));
          expect(button.hitTestable(), findsOneWidget, reason: '$id $row');
          expect(
            find.ancestor(of: button, matching: find.byType(AnimatedOpacity)),
            findsNothing,
          );
        }
      }
      expect(find.byIcon(Icons.more_vert), findsNothing);
      final remind = tester.widget<IconButton>(
        find.byKey(const ValueKey('hub-remind-c1')),
      );
      expect(remind.tooltip, HubText.remind);
      expect(
        remind.style!.foregroundColor!.resolve({}),
        AppColors.textSecondary,
      );
      for (final id in ['remind', 'pay', 'statement', 'promise']) {
        await tester.tap(find.byKey(ValueKey('hub-$id-c1')));
        await tester.pump();
      }
      await tester.tap(find.text('Ahmed Khan'));
      expect(spy.calls, [
        'remind customer c1',
        'pay customer c1',
        'statement customer c1',
        'promise customer c1',
        'open customer c1',
      ]);
    });

    testWidgets('actions stay visible at every wide width', (tester) async {
      for (final width in [1000.0, 1100.0, 1920.0]) {
        await _pump(tester, size: Size(width, 900));
        expect(
          find.byKey(const ValueKey('hub-statement-c1')).hitTestable(),
          findsOneWidget,
          reason: '$width',
        );
        expect(tester.takeException(), isNull, reason: '$width');
      }
    });

    testWidgets('an action without permission is visible but off',
        (tester) async {
      final (_, spy) = await _pump(tester, keys: [Perm.khataView]);
      final remind = find.byKey(const ValueKey('hub-remind-c1'));
      expect(remind.hitTestable(), findsOneWidget);
      expect(tester.widget<IconButton>(remind).onPressed, isNull);
      await tester.tap(remind);
      expect(spy.calls, isEmpty);
    });

    testWidgets('narrow rows keep the actions in a menu', (tester) async {
      final (_, spy) = await _pump(tester, size: const Size(760, 900));
      expect(find.byKey(const ValueKey('hub-actions-c1')), findsNothing);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('hub-row-c2')),
          matching: find.byIcon(Icons.more_vert),
        ),
      );
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('hub-menu-statement')));
      await settle(tester);
      expect(spy.calls, ['statement customer c2']);
    });

    testWidgets('the supplier side says Pay supplier', (tester) async {
      await _pump(tester, tab: PartyType.supplier, size: const Size(760, 900));
      await tester.tap(find.byIcon(Icons.more_vert));
      await settle(tester);
      expect(find.text(HubText.paySupplier), findsOneWidget);
      expect(find.text(HubText.recordPayment), findsNothing);
    });

    testWidgets('actions without permission are off and say which one',
        (tester) async {
      final (_, spy) = await _pump(tester, keys: [Perm.khataView]);
      IconButton button(String id) =>
          tester.widget<IconButton>(find.byKey(ValueKey('hub-$id-c1')));
      expect(button('statement').onPressed, isNotNull);
      expect(button('remind').onPressed, isNull);
      expect(button('promise').onPressed, isNull);
      expect(button('pay').onPressed, isNull);
      expect(
        find.byTooltip('Requires permission ${Perm.khataFollowupsCreate}'),
        findsWidgets,
      );
      expect(spy.calls, isEmpty);
    });

    testWidgets('offline shows the saved list with its time', (tester) async {
      final repo = _repository()
        ..offlineSince = DateTime(2026, 11, 27, 9, 15)
        ..isOnline = false;
      await _pump(tester, repository: repo);
      expect(find.byKey(const Key('khata-as-of')), findsOneWidget);
      expect(find.text('Offline · as of 09:15'), findsOneWidget);
      expect(_names(tester), hasLength(3));
    });

    testWidgets('offline with nothing saved explains itself and retries',
        (tester) async {
      final repo = _repository()
        ..hubFailure = const NetworkFailure('You are offline.')
        ..overviewFailure = const NetworkFailure('You are offline.');
      await _pump(tester, repository: repo);
      expect(find.byKey(const Key('khata-error')), findsOneWidget);
      expect(find.text(HubText.offlineNoCopy), findsOneWidget);
      repo
        ..hubFailure = null
        ..overviewFailure = null;
      await tester.tap(find.text(KhataUiText.retry));
      await settle(tester);
      expect(_names(tester), hasLength(3));
    });

    testWidgets('each side has its own happy empty state', (tester) async {
      await _pump(tester, repository: FakeKhataRepository());
      expect(find.text(HubText.emptyCustomersTitle), findsOneWidget);
      await tester.tap(find.text(HubText.tabSuppliers));
      await settle(tester);
      expect(find.text(HubText.emptySuppliersTitle), findsOneWidget);
    });

    testWidgets('scrolling to the end loads the next page', (tester) async {
      final repo = FakeKhataRepository(
        customers: [
          for (var i = 0; i < 80; i++)
            hubRow('c$i', 'Customer $i', '${5000 - i}'),
        ],
      );
      await _pump(tester, repository: repo);
      expect(repo.hubCalls.map((c) => c.skip), [0]);
      for (var i = 0; i < 6; i++) {
        await tester.drag(
          find.byKey(const Key('khata-hub-scroll')),
          const Offset(0, -2000),
        );
        await settle(tester);
      }
      expect(repo.hubCalls.map((c) => c.skip), contains(50));
      expect(find.text('80 shown'), findsOneWidget);
    });

    for (final width in [700.0, 900.0, 1024.0, 1280.0, 1920.0]) {
      testWidgets('nothing overflows at ${width.toInt()} px', (tester) async {
        final repo = _repository()..offlineSince = khataNow;
        repo.rows[PartyType.customer]!.add(
          hubRow(
            'long',
            'Muhammad Abdul Rehman and Sons Wholesale Traders Peshawar',
            '987654321.50',
            age: 400,
            phone: '+92 300 123456789',
            remindedAt: khataNow.subtract(const Duration(days: 200)),
            promiseDate: DateTime(2025, 1, 15),
          ),
        );
        repo.figures = overviewOf(receive: '9876543210', pay: '1234567890.55');
        await _pump(tester, repository: repo, size: Size(width, 800));
        expect(tester.takeException(), isNull);
      });
    }
  });
}
