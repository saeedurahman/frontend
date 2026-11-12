import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/sync/lease_service.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_status.dart';
import 'package:frantend/features/sync/domain/op_describer.dart';
import 'package:frantend/features/sync/domain/sync_access.dart';
import 'package:frantend/features/sync/presentation/pages/failed_items_page.dart';
import 'package:frantend/features/sync/presentation/pages/flags_page.dart';
import 'package:frantend/features/sync/presentation/pages/sync_page.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/shared/widgets/layout/sign_out_flow.dart';
import 'package:frantend/shared/widgets/sync/data_preparation_gate.dart';
import 'package:frantend/shared/widgets/sync/lease_banner.dart';
import 'package:frantend/shared/widgets/sync/sync_status_chip.dart';

import 'sync_rig.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  late SyncRig rig;

  setUp(() async {
    rig = SyncRig();
    rig.seedServer();
    await rig.sync();
  });

  tearDown(() async {
    try {
      await rig.dispose();
    } catch (e, st) {
      // ignore: avoid_print
      print('TEARDOWN: $e $st');
    }
  });

  Future<void> rejectedSale(WidgetTester tester) async {
    await tester.runAsync(() async {
      rig.server.errors['sale.create'] =
          const OpError(code: 'unknown_product', message: 'x');
      await rig.sell();
      await rig.sync();
    });
  }

  group('FailedItemsPage', () {
    testWidgets('lists the item with the reason in plain language', (tester) async {
      await rejectedSale(tester);
      await tester.pumpWidget(_host(FailedItemsPage(
        store: rig.store, engine: rig.engine, canDiscard: true,
      )));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();

      expect(find.text('1 item(s) need attention'), findsOneWidget);
      expect(find.textContaining('Sale DA1B2-0001'), findsOneWidget);
      expect(find.textContaining('no longer exists on the server'), findsOneWidget);
      expect(find.byKey(const Key('retry-op')), findsOneWidget);
    });

    testWidgets('Retry re-queues the item', (tester) async {
      await rejectedSale(tester);
      await tester.pumpWidget(_host(FailedItemsPage(
        store: rig.store, engine: rig.engine, canDiscard: true,
      )));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();

      rig.server.errors.clear();
      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key('retry-op')));
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await tester.pump();
      expect((await tester.runAsync(() => rig.store.counts()))!.failed, 0);
      // Dispose the page, then let any in-flight sync finish before teardown.
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() => rig.engine.syncNow(manual: true));
    });

    testWidgets('Discard needs the right and a confirmation, and is logged',
        (tester) async {
      await rejectedSale(tester);
      await tester.pumpWidget(_host(FailedItemsPage(
        store: rig.store, engine: rig.engine, canDiscard: true,
      )));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();

      await tester.tap(find.byKey(const Key('discard-op')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('discard-dialog')), findsOneWidget);

      // "Keep it" changes nothing.
      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();
      expect((await tester.runAsync(() => rig.store.ops()))!, hasLength(1));

      await tester.tap(find.byKey(const Key('discard-op')));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await tester.tap(find.text('Discard').last);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      expect((await tester.runAsync(() => rig.store.ops()))!, isEmpty);
      expect((await tester.runAsync(() => rig.store.discardLog()))!, hasLength(1));
    });

    testWidgets('without the right there is no Discard button', (tester) async {
      await rejectedSale(tester);
      await tester.pumpWidget(_host(FailedItemsPage(
        store: rig.store, engine: rig.engine, canDiscard: false,
      )));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
      expect(find.byKey(const Key('discard-op')), findsNothing);
      expect(find.byKey(const Key('retry-op')), findsOneWidget);
    });

    testWidgets('empty state', (tester) async {
      await tester.pumpWidget(_host(FailedItemsPage(
        store: rig.store, engine: rig.engine, canDiscard: true,
      )));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
      expect(find.text('Nothing needs attention'), findsOneWidget);
    });

    test('who may discard / review flags', () {
      const owner = UserAccess(role: 'owner');
      const manager = UserAccess(role: 'Manager');
      const cashier = UserAccess(role: 'cashier', permissionKeys: ['sales.create']);
      expect(SyncAccess.canDiscard(owner), isTrue);
      expect(SyncAccess.canDiscard(manager), isTrue);
      expect(SyncAccess.canDiscard(cashier), isFalse);
      expect(SyncAccess.canReviewFlags(cashier), isFalse);
    });
  });

  group('SyncPage', () {
    testWidgets('shows counts and "Sync now" runs a cycle', (tester) async {
      await tester.runAsync(() async {
        rig.server.offline = true;
        await rig.sell();
        await rig.sync();
        rig.server.offline = false;
      });
      await tester.pumpWidget(_host(SyncPage(
        store: rig.store, engine: rig.engine, showDetails: false, canReviewFlags: false,
      )));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
      expect(find.textContaining('1 waiting to send'), findsOneWidget);
      expect(find.textContaining('Sale DA1B2-0001'), findsOneWidget);

      await tester.tap(find.byKey(const Key('sync-now')));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 400)));
      await tester.pump();
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pump();
      expect(find.textContaining('0 waiting to send'), findsOneWidget);
      expect(find.byKey(const Key('open-flags')), findsNothing);
    });
  });

  group('FlagsPage', () {
    testWidgets('explains each flag in plain language', (tester) async {
      await tester.runAsync(() async {
        await rig.sell(qty: '15');
        await rig.sync();
      });
      await tester.pumpWidget(_host(FlagsPage(api: rig.server, allowed: true)));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
      expect(find.textContaining('Stock went below zero'), findsOneWidget);
    });

    testWidgets('only owner / manager', (tester) async {
      await tester.pumpWidget(_host(FlagsPage(api: rig.server, allowed: false)));
      expect(find.textContaining('Only the owner or a manager'), findsOneWidget);
    });

    test('every documented flag has a sentence', () {
      for (final f in [
        'price_mismatch', 'tax_mismatch', 'oversold', 'credit_limit_exceeded',
        'cost_estimated', 'shift_mismatch', 'subscription_expired',
      ]) {
        expect(SyncErrorText.flagText.containsKey(f), isTrue, reason: f);
      }
      expect(SyncErrorText.flag('brand_new'), contains('brand_new'));
    });
  });

  group('status chip with the real source', () {
    testWidgets('Online -> N pending -> Offline', (tester) async {
      final source = EngineSyncStatusSource(rig.engine, rig.probe);
      await tester.pumpWidget(_host(SyncStatusChip(source: source)));
      expect(find.text('Online'), findsOneWidget);

      await tester.runAsync(() async {
        rig.server.offline = true;
        await rig.sell();
        await rig.sell();
        await rig.sync();
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
      expect(find.text('2 pending'), findsOneWidget);

      rig.probe.set(ReachabilityStatus.offline);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump();
      expect(find.text('Offline'), findsOneWidget);
      unawaited(source.dispose());
    });

    testWidgets('failed items show as "N failed"', (tester) async {
      await rejectedSale(tester);
      final source = EngineSyncStatusSource(rig.engine, rig.probe);
      expect(source.current.failed, 1);
      await tester.pumpWidget(_host(SyncStatusChip(source: source)));
      expect(find.text('1 failed'), findsOneWidget);
      unawaited(source.dispose());
    });
  });

  group('DataPreparationGate', () {
    testWidgets('shows "Preparing your data" with progress, then the app',
        (tester) async {
      const empty = SyncEngineState(hasData: false);
      await tester.pumpWidget(_host(
        PreparingDataView(state: empty, onRetry: () {}),
      ));
      expect(find.text('Preparing your data'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(_host(PreparingDataView(
        state: const SyncEngineState(
          hasData: false,
          progress: SnapshotProgress(pages: 2, rows: 1000),
        ),
        onRetry: () {},
      )));
      expect(find.text('1000 records downloaded'), findsOneWidget);
    });

    testWidgets('stuck offline on first install: explains and offers a retry',
        (tester) async {
      var retried = 0;
      await tester.pumpWidget(_host(PreparingDataView(
        state: const SyncEngineState(hasData: false, lastError: 'offline'),
        onRetry: () => retried++,
      )));
      expect(find.textContaining('Connect to the internet once'), findsOneWidget);
      await tester.tap(find.byKey(const Key('preparing-retry')));
      expect(retried, 1);
    });
  });

  group('LeaseBanner', () {
    final now = DateTime.utc(2026, 11, 1);

    testWidgets('warns during grace and says how long is left', (tester) async {
      await tester.pumpWidget(_host(LeaseBannerView(
        verdict: LeaseVerdict(
          LeaseState.grace,
          validUntil: now.subtract(const Duration(days: 1)),
          graceEndsAt: now.add(const Duration(days: 2)),
        ),
        now: now,
      )));
      expect(find.byKey(const Key('lease-banner')), findsOneWidget);
      expect(find.textContaining('within 2 day(s)'), findsOneWidget);
    });

    testWidgets('clock problems get a message; healthy leases show nothing',
        (tester) async {
      await tester.pumpWidget(_host(LeaseBannerView(
        verdict: const LeaseVerdict(LeaseState.clockRolledBack),
        now: now,
      )));
      expect(find.textContaining('clock is behind'), findsOneWidget);

      await tester.pumpWidget(_host(LeaseBannerView(
        verdict: const LeaseVerdict(LeaseState.valid),
        now: now,
      )));
      expect(find.byKey(const Key('lease-banner')), findsNothing);
    });
  });

  group('sign-out dialog', () {
    const failure = PendingWorkFailure(6, unsynced: 3, failed: 1, held: 2);

    testWidgets('shows exactly what would be lost', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showPendingWorkDialog(context, failure),
              child: const Text('go'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('pending-work-dialog')), findsOneWidget);
      expect(find.textContaining('3 change(s) waiting to be sent'), findsOneWidget);
      expect(find.textContaining('1 rejected by the server'), findsOneWidget);
      expect(find.textContaining('2 parked order(s)'), findsOneWidget);
      expect(find.byKey(const Key('force-sign-out')), findsNothing,
          reason: 'only the owner may force');
    });

    testWidgets('owner can force, after a second confirmation', (tester) async {
      bool? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async => result =
                  await showPendingWorkDialog(context, failure, canForce: true),
              child: const Text('go'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('force-sign-out')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('force-confirm')), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('pending-work-dialog')), findsOneWidget);

      await tester.tap(find.byKey(const Key('force-sign-out')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete and sign out'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });
  });

  group('plain-language text', () {
    test('every server error code has an explanation', () {
      for (final code in [
        'malformed_op', 'malformed_payload', 'payload_too_large', 'unsupported_op_type',
        'occurred_too_old', 'occurred_in_future', 'permission_denied', 'branch_forbidden',
        'unknown_product', 'unknown_branch', 'unknown_register', 'unknown_customer',
        'unknown_shift', 'sale_not_synced', 'duplicate_receipt', 'idempotency_key_reused',
        'id_conflict', 'id_exists', 'shift_conflict', 'shift_already_closed',
        'sale_not_voidable', 'return_rejected', 'insufficient_stock', 'dependency_missing',
        'dependency_failed', 'dependency_cycle', 'subscription_grace_readonly',
        'subscription_expired', 'subscription_suspended', 'subscription_cancelled',
        'no_open_shift', 'internal_error',
      ]) {
        final text = SyncErrorText.explain(code, 'raw server text');
        expect(text, isNot('raw server text'), reason: code);
        expect(text, isNot(contains(code)), reason: 'no codes in user text: $code');
      }
    });

    test('unknown codes fall back to the server message', () {
      expect(SyncErrorText.explain('weird', 'Something odd'), 'Something odd');
    });

    test('op descriptions', () async {
      await rig.sell();
      final d = OpDescriber.describe((await rig.store.ops()).single);
      expect(d.title, 'Sale DA1B2-0001');
      expect(d.subtitle, startsWith('1 item(s)'));
    });
  });
}
