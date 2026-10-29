import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/sync/sync_status.dart';
import 'package:frantend/features/sync/presentation/pages/failed_items_page.dart';
import 'package:frantend/shared/widgets/sync/offline_banner.dart';
import 'package:frantend/shared/widgets/sync/sync_status_chip.dart';
import 'package:frantend/utils/responsive/adaptive_layout.dart';

class _Source implements SyncStatusSource {
  _Source(this.current);
  final _c = StreamController<SyncStatus>.broadcast(sync: true);

  @override
  SyncStatus current;

  @override
  Stream<SyncStatus> get changes => _c.stream;

  void push(SyncStatus s) {
    current = s;
    _c.add(s);
  }
}

Widget _host(Widget child, {Size size = const Size(1200, 800)}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: Center(child: child)),
      ),
    );

void main() {
  group('SyncStatus', () {
    test('stub sources report "online, 0 pending"', () {
      final status = const StubSyncStatusSource().current;
      expect(status.kind, SyncStatusKind.online);
      expect(status.label, 'Online');
      expect(status.pending, 0);
      expect(status.failed, 0);
    });

    test('labels', () {
      expect(const SyncStatus(isOnline: false).label, 'Offline');
      expect(const SyncStatus(isSyncing: true).label, 'Syncing');
      expect(const SyncStatus(pending: 3).label, '3 pending');
      expect(const SyncStatus(failed: 2).label, '2 failed');
    });

    test('priority: offline > failed > syncing > pending > online', () {
      expect(
        const SyncStatus(isOnline: false, failed: 1, pending: 1).kind,
        SyncStatusKind.offline,
      );
      expect(
        const SyncStatus(failed: 1, isSyncing: true, pending: 1).kind,
        SyncStatusKind.failed,
      );
      expect(
        const SyncStatus(isSyncing: true, pending: 4).kind,
        SyncStatusKind.syncing,
      );
      expect(const SyncStatus(pending: 4).kind, SyncStatusKind.pending);
    });

    test('the probe-backed source mirrors reachability, counters stay 0',
        () async {
      final probe = FixedConnectivityProbe();
      final source = ProbeBackedSyncStatusSource(probe);
      expect(source.current.isOnline, isTrue);

      final next = source.changes.first;
      probe.set(ReachabilityStatus.offline);
      expect((await next).kind, SyncStatusKind.offline);
      expect(source.current.pending, 0);

      probe.set(ReachabilityStatus.degraded);
      expect(source.current.isOnline, isTrue, reason: 'degraded still tries');
      await source.dispose();
    });
  });

  group('SyncStatusChip', () {
    testWidgets('shows Online for the stub', (tester) async {
      await tester.pumpWidget(
        _host(const SyncStatusChip(source: StubSyncStatusSource())),
      );
      expect(find.text('Online'), findsOneWidget);
    });

    testWidgets('follows the source', (tester) async {
      final source = _Source(SyncStatus.idleOnline);
      await tester.pumpWidget(_host(SyncStatusChip(source: source)));

      source.push(const SyncStatus(isOnline: false));
      await tester.pump();
      expect(find.text('Offline'), findsOneWidget);

      source.push(const SyncStatus(pending: 5));
      await tester.pump();
      expect(find.text('5 pending'), findsOneWidget);

      source.push(const SyncStatus(isSyncing: true));
      await tester.pump();
      expect(find.text('Syncing'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('only the failed state is tappable', (tester) async {
      var taps = 0;
      final source = _Source(const SyncStatus(failed: 2));
      await tester.pumpWidget(
        _host(SyncStatusChip(source: source, onFailedTap: () => taps++)),
      );
      await tester.tap(find.text('2 failed'));
      expect(taps, 1);

      source.push(const SyncStatus(pending: 2));
      await tester.pump();
      await tester.tap(find.text('2 pending'));
      expect(taps, 1);
    });
  });

  group('OfflineBanner', () {
    testWidgets('hidden while online', (tester) async {
      await tester.pumpWidget(
        _host(OfflineBanner(probe: FixedConnectivityProbe())),
      );
      expect(find.byKey(const Key('offline-banner')), findsNothing);
    });

    testWidgets('appears offline and says changes will fail', (tester) async {
      final probe = FixedConnectivityProbe();
      await tester.pumpWidget(_host(OfflineBanner(probe: probe)));

      probe.set(ReachabilityStatus.offline);
      await tester.pump();

      expect(find.byKey(const Key('offline-banner')), findsOneWidget);
      expect(find.textContaining('You are offline'), findsOneWidget);
      expect(find.textContaining('will fail'), findsOneWidget);

      probe.set(ReachabilityStatus.online);
      await tester.pump();
      expect(find.byKey(const Key('offline-banner')), findsNothing);
    });

    testWidgets('degraded gets its own wording', (tester) async {
      await tester.pumpWidget(
        _host(OfflineBanner(
          probe: FixedConnectivityProbe(ReachabilityStatus.degraded),
        )),
      );
      expect(find.textContaining('slow or unstable'), findsOneWidget);
    });
  });

  group('FailedItemsPage skeleton', () {
    testWidgets('says nothing needs attention for the stub', (tester) async {
      await tester.pumpWidget(
        _host(const FailedItemsPage(source: StubSyncStatusSource())),
      );
      expect(find.text('Nothing needs attention'), findsOneWidget);
    });

    testWidgets('shows the failed count when there is one', (tester) async {
      await tester.pumpWidget(
        _host(FailedItemsPage(
          source: StubSyncStatusSource(const SyncStatus(failed: 3)),
        )),
      );
      expect(find.text('3 change(s) need attention'), findsOneWidget);
    });
  });

  group('Breakpoints', () {
    test('classification', () {
      expect(Breakpoints.classify(360), LayoutClass.compact);
      expect(Breakpoints.classify(599.9), LayoutClass.compact);
      expect(Breakpoints.classify(600), LayoutClass.medium);
      expect(Breakpoints.classify(1023), LayoutClass.medium);
      expect(Breakpoints.classify(1024), LayoutClass.expanded);
    });

    test('sidebar on wide, bottom nav only on phones', () {
      expect(Breakpoints.usesSidebar(1280), isTrue);
      expect(Breakpoints.usesSidebar(800), isFalse);
      expect(Breakpoints.usesBottomNav(400), isTrue);
      expect(Breakpoints.usesBottomNav(800), isFalse);
    });
  });

  group('AdaptiveLayout', () {
    Widget layout() => AdaptiveLayout(
          compact: (_) => const Text('compact'),
          expanded: (_) => const Text('expanded'),
        );

    testWidgets('picks by the available width', (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      tester.view.physicalSize = const Size(1280, 800);
      await tester.pumpWidget(MaterialApp(home: layout()));
      expect(find.text('expanded'), findsOneWidget);

      tester.view.physicalSize = const Size(390, 800);
      await tester.pumpWidget(MaterialApp(home: layout()));
      expect(find.text('compact'), findsOneWidget);
    });

    testWidgets('medium falls back to compact unless given', (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      tester.view.physicalSize = const Size(800, 800);

      await tester.pumpWidget(MaterialApp(home: layout()));
      expect(find.text('compact'), findsOneWidget);

      await tester.pumpWidget(MaterialApp(
        home: AdaptiveLayout(
          compact: (_) => const Text('compact'),
          medium: (_) => const Text('medium'),
          expanded: (_) => const Text('expanded'),
        ),
      ));
      expect(find.text('medium'), findsOneWidget);
    });
  });
}
