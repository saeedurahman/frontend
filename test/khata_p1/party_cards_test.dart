// Pending bills, promise to pay and the reminders timeline on a party page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/domain/text/party_text.dart';
import 'package:frantend/features/khata/presentation/cubit/party_khata_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_cards.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_layout.dart';

import '../helpers/khata_p1_fakes.dart';

Followup _followup(
  String id,
  FollowupKind kind, {
  int daysAgo = 0,
  DateTime? promiseDate,
  String? promiseAmount,
  String? message,
  bool pending = false,
  bool needsAttention = false,
}) =>
    Followup(
      id: id,
      partyType: PartyType.customer,
      partyId: 'c1',
      kind: kind,
      createdAt: khataNow.subtract(Duration(days: daysAgo)),
      promiseDate: promiseDate,
      promiseAmount: promiseAmount == null ? null : dec(promiseAmount),
      message: message,
      channel: kind == FollowupKind.reminder ? 'whatsapp' : null,
      pending: pending,
      needsAttention: needsAttention,
    );

Future<PartyKhataCubit> _pumpCards(
  WidgetTester tester,
  FakeKhataRepository repo, {
  List<String>? keys,
  Size size = const Size(520, 1600),
}) async {
  final cubit = PartyKhataCubit(
    repo,
    partyType: PartyType.customer,
    partyId: 'c1',
  );
  addTearDown(cubit.close);
  await pumpKhata(
    tester,
    BlocProvider.value(
      value: cubit,
      child: SingleChildScrollView(
        child: Column(
          children: [
            PendingBillsCard(clock: () => khataNow),
            PromiseCard(name: 'Ahmed Khan', clock: () => khataNow),
            FollowupTimelineCard(name: 'Ahmed Khan', clock: () => khataNow),
          ],
        ),
      ),
    ),
    user: keys == null ? null : userWith(keys),
    size: size,
  );
  cubit.load();
  await settle(tester, 10);
  return cubit;
}

void main() {
  group('pending bills', () {
    testWidgets('lists number, total, paid, remaining, age and overdue',
        (tester) async {
      final repo = FakeKhataRepository()
        ..bills = openItemsOf([
          openItem(
            's1',
            number: 'INV-0012',
            total: '6500',
            paid: '1500',
            age: 45,
            overdue: 15,
          ),
          openItem('o1', type: 'opening_balance', total: '800', age: 3),
        ], termsDays: 30);
      await _pumpCards(tester, repo);
      final row = find.byKey(const ValueKey('bill-s1'));
      Finder inRow(String text) =>
          find.descendant(of: row, matching: find.textContaining(text));
      expect(inRow('INV-0012'), findsOneWidget);
      expect(inRow('6,500'), findsOneWidget);
      expect(inRow('1,500'), findsOneWidget);
      expect(inRow('5,000'), findsOneWidget);
      expect(inRow('45 days'), findsWidgets);
      expect(inRow(PartyText.overdue('15 days')), findsOneWidget);
      expect(find.byKey(const ValueKey('bill-o1')), findsOneWidget);
      expect(find.text(PartyText.billsTerms(30)), findsOneWidget);
      expect(find.byKey(const Key('bills-show-all')), findsNothing);
    });

    testWidgets('long lists open on request', (tester) async {
      final repo = FakeKhataRepository()
        ..bills = openItemsOf([
          for (var i = 0; i < 9; i++) openItem('s$i', number: 'INV-$i'),
        ]);
      await _pumpCards(tester, repo);
      expect(find.byKey(const ValueKey('bill-s5')), findsOneWidget);
      expect(find.byKey(const ValueKey('bill-s6')), findsNothing);
      await tester.tap(find.byKey(const Key('bills-show-all')));
      await settle(tester);
      expect(find.byKey(const ValueKey('bill-s8')), findsOneWidget);
    });

    testWidgets('nothing to pay shows any advance held', (tester) async {
      final repo = FakeKhataRepository()
        ..bills = openItemsOf(const [], advance: '250');
      await _pumpCards(tester, repo);
      expect(find.byKey(const Key('bills-empty')), findsOneWidget);
      expect(find.textContaining('250'), findsOneWidget);
    });

    testWidgets('a kept copy says when it is from', (tester) async {
      final repo = FakeKhataRepository()
        ..bills = openItemsOf([openItem('s1')])
        ..offlineSince = DateTime(2026, 11, 27, 8, 5);
      await _pumpCards(tester, repo);
      expect(find.byKey(const Key('bills-as-of')), findsOneWidget);
      expect(find.textContaining('08:05'), findsOneWidget);
    });

    testWidgets('no copy at all explains and retries', (tester) async {
      final repo = FakeKhataRepository()
        ..billsFailure = const NetworkFailure('No saved copy yet.');
      await _pumpCards(tester, repo);
      expect(find.byKey(const Key('bills-error')), findsOneWidget);
      expect(find.text('No saved copy yet.'), findsOneWidget);
      repo
        ..billsFailure = null
        ..bills = openItemsOf([openItem('s1')]);
      await tester.tap(find.text('Try again'));
      await settle(tester, 10);
      expect(find.byKey(const ValueKey('bill-s1')), findsOneWidget);
    });
  });

  group('promise to pay', () {
    testWidgets('shows the latest one and flags a passed day', (tester) async {
      final repo = FakeKhataRepository()
        ..timeline.addAll([
          _followup(
            'new',
            FollowupKind.promise,
            daysAgo: 1,
            promiseDate: DateTime(2026, 11, 20),
            promiseAmount: '5000',
            pending: true,
          ),
          _followup(
            'old',
            FollowupKind.promise,
            daysAgo: 9,
            promiseDate: DateTime(2026, 12, 30),
          ),
        ]);
      await _pumpCards(tester, repo);
      final card = find.byKey(const Key('promise-card'));
      expect(
        find.descendant(of: card, matching: find.textContaining('20 Nov 2026')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('promise-passed')), findsOneWidget);
      expect(
        find.descendant(of: card, matching: find.text(PartyText.waiting)),
        findsOneWidget,
      );
    });

    testWidgets('a date is needed; the quick chips pick one', (tester) async {
      final repo = FakeKhataRepository();
      await _pumpCards(tester, repo);
      expect(find.text(PartyText.noPromise), findsOneWidget);
      await tester.tap(find.byKey(const Key('party-add-promise')));
      await settle(tester);
      await tester.tap(find.byKey(const Key('khata-form-submit')));
      await settle(tester);
      expect(repo.followupCalls, isEmpty);
      await tester.tap(find.text(FollowupText.inAWeek));
      await tester.pump();
      await tester.enterText(find.byKey(const Key('promise-amount')), '1,500');
      await tester.pump();
      await tester.tap(find.byKey(const Key('khata-form-submit')));
      await settle(tester, 10);
      final call = repo.followupCalls.single;
      expect(call.kind, FollowupKind.promise);
      expect(call.promiseDate, DateTime(2026, 12, 4));
      expect(call.promiseAmount, '1500.00');
    });
  });

  group('reminders and notes', () {
    testWidgets('newest first, with what is still waiting or refused',
        (tester) async {
      final repo = FakeKhataRepository()
        ..timeline.addAll([
          _followup('r', FollowupKind.reminder, daysAgo: 3, message: 'Salam'),
          _followup('n', FollowupKind.note, message: 'Came by', pending: true),
          _followup(
            'x',
            FollowupKind.note,
            daysAgo: 8,
            message: 'Bad',
            needsAttention: true,
          ),
        ]);
      await _pumpCards(tester, repo);
      final top = tester.getTopLeft(find.byKey(const ValueKey('followup-n')));
      final next = tester.getTopLeft(find.byKey(const ValueKey('followup-r')));
      expect(top.dy, lessThan(next.dy));
      expect(find.text(PartyText.waiting), findsOneWidget);
      expect(find.text(PartyText.refused), findsOneWidget);
    });

    testWidgets('a note needs text', (tester) async {
      final repo = FakeKhataRepository();
      await _pumpCards(tester, repo);
      expect(find.byKey(const Key('timeline-empty')), findsOneWidget);
      await tester.tap(find.byKey(const Key('party-add-note')));
      await settle(tester);
      await tester.tap(find.byKey(const Key('khata-form-submit')));
      await settle(tester);
      expect(repo.followupCalls, isEmpty);
      await tester.enterText(
        find.byKey(const Key('note-text')),
        'Will visit Friday',
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('khata-form-submit')));
      await settle(tester, 10);
      expect(repo.followupCalls.single.kind, FollowupKind.note);
      expect(repo.followupCalls.single.message, 'Will visit Friday');
    });

    testWidgets('adding needs khata.followups.create', (tester) async {
      await _pumpCards(tester, FakeKhataRepository(), keys: [Perm.khataView]);
      for (final key in ['party-add-note', 'party-add-promise']) {
        final button = tester.widget<TextButton>(
          find.byWidgetPredicate((w) => w.key == Key(key)),
        );
        expect(button.onPressed, isNull, reason: key);
      }
      expect(
        find.byTooltip('Requires permission ${Perm.khataFollowupsCreate}'),
        findsNWidgets(2),
      );
    });
  });

  group('party page layout', () {
    Future<void> pumpLayout(
      WidgetTester tester,
      double width, {
      List<String>? keys,
    }) async {
      final repo = FakeKhataRepository()
        ..bills = openItemsOf([
          openItem(
            's1',
            number: 'INV-2026-000012345',
            total: '98765432.55',
            age: 120,
            overdue: 90,
          ),
        ]);
      await pumpKhata(
        tester,
        PartyKhataLayout(
          type: PartyType.customer,
          partyId: 'c1',
          name: 'Ahmed Khan',
          account: const Center(child: Text('the account')),
          repository: repo,
          clock: () => khataNow,
        ),
        user: keys == null ? null : userWith(keys),
        size: Size(width, 800),
      );
      await settle(tester, 10);
    }

    testWidgets('wide: account with a side panel', (tester) async {
      await pumpLayout(tester, 1440);
      expect(find.byKey(const Key('party-side-panel')), findsOneWidget);
      expect(find.text('the account'), findsOneWidget);
      expect(find.byKey(const Key('pending-bills-card')), findsOneWidget);
    });

    testWidgets('narrow: tabs', (tester) async {
      await pumpLayout(tester, 800);
      expect(find.byKey(const Key('party-tabs')), findsOneWidget);
      expect(find.text('the account'), findsOneWidget);
      await tester.tap(find.text(PartyText.billsTab));
      await settle(tester, 10);
      expect(find.byKey(const Key('pending-bills-card')), findsOneWidget);
      await tester.tap(find.text(PartyText.followupsTab));
      await settle(tester, 10);
      expect(find.byKey(const Key('promise-card')), findsOneWidget);
      expect(find.byKey(const Key('timeline-card')), findsOneWidget);
    });

    testWidgets('without khata.view only the account shows', (tester) async {
      await pumpLayout(tester, 1440, keys: [Perm.customersView]);
      expect(find.text('the account'), findsOneWidget);
      expect(find.byKey(const Key('party-side-panel')), findsNothing);
      expect(find.byKey(const Key('party-tabs')), findsNothing);
    });

    for (final width in [700.0, 1099.0, 1100.0, 1920.0]) {
      testWidgets('no overflow at ${width.toInt()} px', (tester) async {
        await pumpLayout(tester, width);
        expect(tester.takeException(), isNull);
        if (width < 1100) {
          await tester.tap(find.text(PartyText.billsTab));
          await settle(tester, 10);
          expect(tester.takeException(), isNull);
        }
      });
    }
  });
}
