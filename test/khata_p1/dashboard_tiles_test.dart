import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_overview_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_dashboard_tiles.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';

import '../helpers/khata_p1_fakes.dart';

Future<List<PartyType>> _pump(
  WidgetTester tester,
  FakeKhataRepository repo, {
  Size size = const Size(1280, 700),
  String? branchId,
}) async {
  final opened = <PartyType>[];
  await pumpKhata(
    tester,
    SingleChildScrollView(
      child: KhataDashboardTiles(
        createCubit: () => KhataOverviewCubit(repo, branchId: branchId),
        onOpen: (_, type) => opened.add(type),
      ),
    ),
    size: size,
  );
  await settle(tester);
  return opened;
}

void main() {
  testWidgets('two cards: total, party count and aging bar', (tester) async {
    await _pump(tester, FakeKhataRepository());
    expect(find.text(KhataUiText.toReceive), findsOneWidget);
    expect(find.text(KhataUiText.toPay), findsOneWidget);
    expect(find.textContaining('184,500'), findsOneWidget);
    expect(find.textContaining('62,300'), findsOneWidget);
    expect(find.text('14 customers'), findsOneWidget);
    expect(find.text('5 suppliers'), findsOneWidget);
    expect(find.byType(AgingBar), findsNWidgets(2));
  });

  testWidgets('a tap opens the hub on the matching tab', (tester) async {
    final opened = await _pump(tester, FakeKhataRepository());
    await tester.tap(find.byKey(const ValueKey('dashboard-khata-supplier')));
    await tester.tap(find.byKey(const ValueKey('dashboard-khata-customer')));
    expect(opened, [PartyType.supplier, PartyType.customer]);
    expect(khataHubLocation(PartyType.supplier), '/khata?tab=supplier');
  });

  testWidgets('asks for the selected branch', (tester) async {
    final repo = FakeKhataRepository();
    await _pump(tester, repo, branchId: 'branch-2');
    expect(repo.overviewCalls, ['branch-2']);
  });

  testWidgets('offline marks the saved figures with their time',
      (tester) async {
    final repo = FakeKhataRepository()..offlineSince = DateTime(2026, 1, 5, 8, 30);
    await _pump(tester, repo);
    expect(find.byType(AsOfLabel), findsOneWidget);
    expect(find.textContaining('08:30'), findsOneWidget);
  });

  testWidgets('with nothing to show it says why and retries', (tester) async {
    final repo = FakeKhataRepository()
      ..overviewFailure = const NetworkFailure('You are offline.');
    await _pump(tester, repo);
    expect(find.text('You are offline.'), findsOneWidget);
    repo.overviewFailure = null;
    await tester.tap(find.text(KhataUiText.retry));
    await settle(tester);
    expect(find.byType(AgingBar), findsNWidgets(2));
  });

  test('another branch clears the old figures before asking', () async {
    final repo = FakeKhataRepository();
    final cubit = KhataOverviewCubit(repo, branchId: 'a');
    addTearDown(cubit.close);
    await cubit.load();
    final states = <bool>[];
    final sub = cubit.stream.listen((s) => states.add(s.data == null));
    await cubit.onBranchChanged('b');
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(states, [true, false]);
    expect(repo.overviewCalls, ['a', 'b']);
  });

  for (final width in [700.0, 760.0, 1920.0, 400.0]) {
    testWidgets('fits at ${width.toInt()} px', (tester) async {
      final repo = FakeKhataRepository()
        ..figures = overviewOf(receive: '9876543210.55', customers: 12345);
      await _pump(tester, repo, size: Size(width, 700));
      expect(tester.takeException(), isNull);
    });
  }
}
