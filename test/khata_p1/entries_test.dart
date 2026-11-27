// Opening balances, manual entries and their reversal.
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/domain/khata_amount.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/cubit/opening_balance_cubit.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_wording.dart';
import 'package:frantend/features/khata/presentation/widgets/entry_dialogs.dart';
import 'package:frantend/features/khata/presentation/widgets/opening_balance_section.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';

import '../helpers/khata_p1_fakes.dart';

/// A button that opens what is being tested.
Future<void> _launch(
  WidgetTester tester,
  Future<void> Function(BuildContext context) open, {
  List<String>? keys,
}) async {
  await pumpKhata(
    tester,
    Builder(
      builder: (context) => TextButton(
        onPressed: () => open(context),
        child: const Text('open'),
      ),
    ),
    user: keys == null ? null : userWith(keys),
  );
  await tester.tap(find.text('open'));
  await settle(tester);
}

Future<void> _submit(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('khata-form-submit')));
  await settle(tester);
}

OpeningBalanceCubit _opening(
  FakeKhataRepository repo, [
  PartyType type = PartyType.customer,
]) =>
    OpeningBalanceCubit(
      repo,
      type: type,
      resolveBranch: () async => 'branch-1',
      clock: () => khataNow,
    );

void main() {
  group('amounts', () {
    test('accepts up to two decimals and thousands separators', () {
      expect(KhataAmount.parse('1,250'), '1250.00');
      expect(KhataAmount.parse(' 99.5 '), '99.50');
      for (final bad in ['', '0', '-5', '1.234', 'ten', '1e3']) {
        expect(KhataAmount.parse(bad), isNull, reason: bad);
      }
    });

    test('a customer starts as owing, a supplier as owed', () {
      expect(
        OpeningBalanceDraft.empty(PartyType.customer, khataNow).direction,
        OpeningDirection.theyOweUs,
      );
      expect(
        OpeningBalanceDraft.empty(PartyType.supplier, khataNow).direction,
        OpeningDirection.weOweThem,
      );
    });
  });

  group('opening balance on a new customer or supplier', () {
    test('creates the party and its balance in one request', () async {
      final repo = FakeKhataRepository();
      final cubit = _opening(repo);
      addTearDown(cubit.close);
      expect(cubit.isFilled, isFalse);
      cubit.update(cubit.state.draft.copyWith(amountText: '2,500'));
      expect(await cubit.create({'name': 'Ali'}), isNull);
      final call = repo.createCalls.single;
      expect(call.body, {
        'name': 'Ali',
        'opening_balance': {
          'amount': '2500.00',
          'direction': 'they_owe_us',
          'as_of_date': '2026-11-27',
          'branch_id': 'branch-1',
        },
      });
      expect(call.key, isNotEmpty);
    });

    test('a wrong amount is refused before anything is sent', () async {
      final repo = FakeKhataRepository();
      final cubit = _opening(repo);
      addTearDown(cubit.close);
      cubit.update(cubit.state.draft.copyWith(amountText: '0'));
      expect(await cubit.create({'name': 'Ali'}), EntryText.amountInvalid);
      expect(cubit.state.amountError, EntryText.amountInvalid);
      expect(repo.createCalls, isEmpty);
    });

    test('offline it asks to connect', () async {
      final repo = FakeKhataRepository()..isOnline = false;
      final cubit = _opening(repo, PartyType.supplier);
      addTearDown(cubit.close);
      cubit.update(cubit.state.draft.copyWith(amountText: '10'));
      expect(
        await cubit.create({'name': 'Mill'}),
        EntryText.openingNeedsInternet,
      );
      expect(repo.createCalls, isEmpty);
    });

    test('a lost answer is retried with the same key, so it books once',
        () async {
      final repo = FakeKhataRepository()
        ..writeFailures.add(const NetworkFailure('lost'));
      final cubit = _opening(repo);
      addTearDown(cubit.close);
      cubit.update(cubit.state.draft.copyWith(amountText: '10'));
      expect(await cubit.create({'name': 'Ali'}), isNotNull);
      expect(await cubit.create({'name': 'Ali'}), isNull);
      expect(repo.createCalls[0].key, repo.createCalls[1].key);
    });

    testWidgets('the form section types into the draft', (tester) async {
      final cubit = _opening(FakeKhataRepository());
      addTearDown(cubit.close);
      await pumpKhata(
        tester,
        BlocProvider.value(
          value: cubit,
          child: const SingleChildScrollView(child: OpeningBalanceSection()),
        ),
      );
      expect(
        find.text(EntryText.openingHelp(PartyType.customer)),
        findsOneWidget,
      );
      await tester.enterText(find.byKey(const Key('opening-amount')), '750');
      await tester.pump();
      await tester.tap(find.text('We owe them'));
      await settle(tester);
      expect(cubit.state.draft.amount, '750.00');
      expect(cubit.state.draft.direction, OpeningDirection.weOweThem);
      expect(find.textContaining('27 Nov 2026'), findsOneWidget);
    });

    testWidgets('"Add opening balance" on an existing account', (tester) async {
      final repo = FakeKhataRepository();
      await _launch(
        tester,
        (c) => showOpeningBalanceDialog(
          c,
          repository: repo,
          partyType: PartyType.supplier,
          partyId: 's1',
          name: 'National Foods',
          branchId: 'b1',
          clock: () => khataNow,
        ),
      );
      await _submit(tester);
      expect(find.text(EntryText.amountRequired), findsOneWidget);
      await tester.enterText(find.byKey(const Key('opening-amount')), '900');
      repo.writeFailures.add(
        const ServerFailure('exists', 'opening_balance_exists'),
      );
      await _submit(tester);
      expect(find.text(EntryText.openingExists), findsOneWidget);
      await _submit(tester);
      expect(repo.openingCalls.last.body['amount'], '900.00');
      expect(repo.openingCalls.last.body['direction'], 'we_owe_them');
      expect(find.byType(OpeningBalanceDialog), findsNothing);
    });
  });

  group('manual entries', () {
    Future<FakeKhataRepository> open(
      WidgetTester tester,
      ManualKind kind, {
      PartyType type = PartyType.customer,
      List<String>? keys,
      FakeKhataRepository? repository,
    }) async {
      final repo = repository ?? FakeKhataRepository();
      await _launch(
        tester,
        (c) => showManualEntryDialog(
          c,
          repository: repo,
          partyType: type,
          partyId: 'p1',
          name: 'Ahmed Khan',
          kind: kind,
          branchId: 'b1',
          clock: () => khataNow,
        ),
        keys: keys,
      );
      return repo;
    }

    Future<void> fill(WidgetTester tester, String amount, String note) async {
      await tester.enterText(find.byKey(const Key('entry-amount')), amount);
      await tester.enterText(find.byKey(const Key('entry-note')), note);
    }

    testWidgets('udhaar needs an amount and a note', (tester) async {
      final repo = await open(tester, ManualKind.udhaarGiven);
      expect(find.text(EntryText.giveUdhaar), findsOneWidget);
      await _submit(tester);
      expect(find.text(EntryText.amountRequired), findsOneWidget);
      expect(find.text(EntryText.noteRequired), findsOneWidget);
      expect(repo.entryCalls, isEmpty);
      await fill(tester, '500', '  Cash for medicine  ');
      await _submit(tester);
      expect(repo.entryCalls.single.body, {
        'kind': 'udhaar_given',
        'amount': '500.00',
        'note': 'Cash for medicine',
        'branch_id': 'b1',
      });
      expect(find.byType(ManualEntryDialog), findsNothing);
    });

    testWidgets('goods on credit for a supplier', (tester) async {
      final repo = await open(
        tester,
        ManualKind.goodsOnCredit,
        type: PartyType.supplier,
      );
      await fill(tester, '1200', 'Loading charges');
      await _submit(tester);
      expect(repo.entryCalls.single.body['kind'], 'goods_on_credit_manual');
    });

    testWidgets('an adjustment can go either way', (tester) async {
      final repo = await open(tester, ManualKind.adjustmentIncrease);
      await tester.tap(
        find.text(EntryText.decrease(PartyType.customer)),
      );
      await settle(tester);
      await fill(tester, '50', 'Rounding');
      await _submit(tester);
      expect(repo.entryCalls.single.body['kind'], 'adjustment_decrease');
    });

    final overLimit = ServerFailure(
      'over',
      'credit_limit_exceeded',
      CreditNumbers(
        limit: Decimal.parse('5000'),
        balance: Decimal.parse('-4800'),
        wouldBe: Decimal.parse('-5300'),
      ),
    );

    testWidgets('over the credit limit, an allowed user can go on',
        (tester) async {
      final repo = FakeKhataRepository()..writeFailures.add(overLimit);
      await open(
        tester,
        ManualKind.udhaarGiven,
        repository: repo,
        keys: [Perm.customersCreditOverride, Perm.customersLedgerManage],
      );
      await fill(tester, '500', 'Eid shopping');
      await _submit(tester);
      expect(find.byKey(const ValueKey('credit-blocked')), findsOneWidget);
      expect(find.textContaining('Credit limit:'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(const ValueKey('credit-allow-anyway')),
      );
      await tester.tap(find.byKey(const ValueKey('credit-allow-anyway')));
      await settle(tester);
      expect(repo.entryCalls.last.body['credit_override'], isTrue);
      expect(repo.entryCalls.first.key, isNot(repo.entryCalls.last.key));
      expect(find.byType(ManualEntryDialog), findsNothing);
    });

    testWidgets('over the limit without the permission it stops',
        (tester) async {
      final repo = FakeKhataRepository()..writeFailures.add(overLimit);
      await open(
        tester,
        ManualKind.udhaarGiven,
        repository: repo,
        keys: [Perm.customersLedgerManage],
      );
      await fill(tester, '500', 'Eid shopping');
      await _submit(tester);
      expect(find.byKey(const ValueKey('credit-no-override')), findsOneWidget);
      expect(find.byKey(const ValueKey('credit-allow-anyway')), findsNothing);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('khata-form-submit')))
            .onPressed,
        isNull,
      );
      // A smaller amount asks again.
      await tester.enterText(find.byKey(const Key('entry-amount')), '100');
      await settle(tester);
      await _submit(tester);
      expect(repo.entryCalls, hasLength(2));
    });

    testWidgets('a lost connection is explained and nothing closes',
        (tester) async {
      final repo = FakeKhataRepository()
        ..writeFailures.add(const NetworkFailure('lost'));
      await open(tester, ManualKind.udhaarGiven, repository: repo);
      await fill(tester, '20', 'Tea');
      await _submit(tester);
      expect(find.text(EntryText.offline), findsOneWidget);
      await _submit(tester);
      expect(repo.entryCalls[0].key, repo.entryCalls[1].key);
    });

    testWidgets('an entry is undone with a reason', (tester) async {
      final repo = FakeKhataRepository();
      await _launch(
        tester,
        (c) => reverseKhataEntry(
          c,
          repository: repo,
          type: PartyType.customer,
          line: LedgerLine(
            id: 'e9',
            party: LedgerParty.customer,
            type: 'sale',
            typeLabel: EntryText.udhaarLine,
            amount: Decimal.parse('-500'),
            when: khataNow,
            source: 'manual',
            canReverseEntry: true,
          ),
          name: 'Ahmed Khan',
        ),
      );
      expect(find.text(EntryText.reverseEntryExplain), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('reverse_reason')),
        'Wrong customer',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('reverse_confirm')));
      await settle(tester);
      expect(repo.reverseCalls.single.id, 'e9');
      expect(repo.reverseCalls.single.body['reason'], 'Wrong customer');
      expect(find.text(EntryText.entryReversed), findsOneWidget);
    });
  });

  group('the "Add entry" menu', () {
    Future<void> pumpActions(
      WidgetTester tester, {
      PartyType type = PartyType.customer,
      bool hasOpening = false,
      List<String>? keys,
    }) async {
      await pumpKhata(
        tester,
        PartyKhataActions(
          type: type,
          partyId: 'p1',
          name: 'Ahmed Khan',
          hasOpening: hasOpening,
          repository: FakeKhataRepository(),
        ),
        user: keys == null ? null : userWith(keys),
      );
    }

    testWidgets('offers an opening balance only once', (tester) async {
      await pumpActions(tester);
      await tester.tap(find.byKey(const Key('party-entry-menu')));
      await settle(tester);
      expect(find.byKey(const Key('entry-opening')), findsOneWidget);
      expect(find.text(EntryText.giveUdhaar), findsOneWidget);
      expect(find.text(EntryText.adjustment), findsOneWidget);

      await tester.tapAt(Offset.zero);
      await settle(tester);
      await pumpActions(tester, hasOpening: true, type: PartyType.supplier);
      await tester.tap(find.byKey(const Key('party-entry-menu')));
      await settle(tester);
      expect(find.byKey(const Key('entry-opening')), findsNothing);
      expect(find.text(EntryText.goodsOnCredit), findsOneWidget);
    });

    testWidgets('is off without the ledger permission', (tester) async {
      await pumpActions(tester, keys: [Perm.khataView]);
      expect(find.byKey(const Key('party-statement')), findsOneWidget);
      expect(
        find.byTooltip(
          'Requires permission ${Perm.customersLedgerManage}',
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<OutlinedButton>(
              find.byWidgetPredicate((w) => w.key == const Key('party-remind')),
            )
            .onPressed,
        isNull,
      );
    });

    testWidgets('nothing of the khata shows without khata.view',
        (tester) async {
      await pumpActions(tester, keys: [Perm.customersView]);
      expect(find.byKey(const Key('party-statement')), findsNothing);
      expect(find.byKey(const Key('party-remind')), findsNothing);
    });
  });
}
