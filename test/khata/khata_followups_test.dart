// The Khata follow-ups of the backend: coded refusals, "Allow anyway" by
// permission, cash from customers in the caller's own shift, the shift's cash
// movements, and the texts of the new sync flags.

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/currency_label.dart';
import 'package:frantend/core/utils/currency_label_store.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/cash_register/data/models/shift_cash_movement.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/widgets/credit_blocked_notice.dart';
import 'package:frantend/features/khata/presentation/widgets/payment_source_cards.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/sync/presentation/pages/flags_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_http.dart';
import '../helpers/fake_rest.dart';
import '../helpers/session_fixtures.dart';
import '../sync/fake_sync_server.dart';
import '../sync/sync_rig.dart';

const _errors = ErrorHandler();

Map<String, dynamic> _coded(String code, [Map<String, dynamic>? more]) => {
      'detail': {'code': code, 'message': 'server words for $code', ...?more},
    };

Widget _signedIn(Widget child, User user) => BlocProvider(
      // A new person on screen gets a new session.
      key: ValueKey(user.id),
      create: (_) => AccessCubit(
        fetchCurrentUser: () async => user,
        loadCachedUser: () async => user,
      )..apply(user),
      child: MaterialApp(home: Scaffold(body: child)),
    );

class _SalesFlags extends FakeSyncServer {
  _SalesFlags(this.sales);

  final List<FlaggedSale> sales;

  @override
  Future<List<FlaggedSale>> flags({
    String? flag,
    int skip = 0,
    int limit = 100,
  }) async =>
      sales;
}

void main() {
  group('coded refusals', () {
    final cases = <String, (int, String)>{
      'no_open_shift': (400, KhataText.needsShiftBody),
      'credit_limit_exceeded': (400, KhataText.creditBlockedNoNumbers),
      'credit_override_forbidden': (403, KhataText.creditOverrideForbidden),
      'payment_exceeds_receipt_total': (400, KhataText.paidMoreThanTotal),
      'open_shift_required_to_reverse': (409, KhataText.needsShiftToReverse),
    };

    for (final c in cases.entries) {
      test('${c.key} keeps its code and gets plain words', () {
        final (status, words) = c.value;
        final failure = _errors.mapStatus(status, _coded(c.key));
        expect(failure.code, c.key);
        expect(failure.message, 'server words for ${c.key}');
        expect(KhataText.forCode(failure.code), words);
      });
    }

    test('credit_limit_exceeded carries limit, balance and would_be', () {
      final failure = _errors.mapStatus(
        400,
        _coded('credit_limit_exceeded', {
          'limit': '2000.00',
          'balance': '-1500.00',
          'would_be': '-2500.00',
        }),
      );
      expect(
        (failure as ServerFailure).credit,
        CreditNumbers(
          limit: Decimal.parse('2000'),
          balance: Decimal.parse('-1500'),
          wouldBe: Decimal.parse('-2500'),
        ),
      );
    });

    test('credit_override_forbidden is a permission failure', () {
      expect(
        _errors.mapStatus(403, _coded('credit_override_forbidden')),
        isA<PermissionDeniedFailure>(),
      );
    });

    test('a sentence without a code is not guessed at', () {
      for (final sentence in [
        'No open shift found',
        'Credit limit exceeded: limit 5',
        'That shift belongs to another user',
      ]) {
        final failure = _errors.mapStatus(400, {'detail': sentence});
        expect(failure.code, isNull);
        expect(KhataText.forCode(failure.code), isNull);
        expect(failure.message, sentence);
      }
    });

    test('both shift codes need the "Open shift first" prompt', () {
      expect(KhataText.needsOwnShift('no_open_shift'), isTrue);
      expect(KhataText.needsOwnShift('shift_not_yours'), isTrue);
      expect(KhataText.needsOwnShift('credit_limit_exceeded'), isFalse);
      expect(KhataText.needsOwnShift(null), isFalse);
    });
  });

  group('"Allow anyway" needs customers.credit.override', () {
    final numbers = CreditNumbers(
      limit: Decimal.parse('2000'),
      balance: Decimal.parse('-1500'),
      wouldBe: Decimal.parse('-2500'),
    );

    Future<int> show(WidgetTester tester, User user) async {
      var allowed = 0;
      await tester.pumpWidget(_signedIn(
        CreditBlockedNotice(
          message: KhataText.creditBlockedNoNumbers,
          numbers: numbers,
          onAllowAnyway: () => allowed++,
        ),
        user,
      ));
      final button = find.byKey(const ValueKey('credit-allow-anyway'));
      if (button.evaluate().isNotEmpty) {
        await tester.tap(button);
        await tester.pump();
      }
      return allowed;
    }

    for (final role in const ['cashier', 'manager', 'owner']) {
      testWidgets('$role holding it gets the button and the numbers',
          (tester) async {
        final taps = await show(
          tester,
          makeUser(
            role: role,
            keys: const [Perm.customersCreditOverride],
          ),
        );
        expect(taps, 1);
        expect(find.byKey(const ValueKey('credit-no-override')), findsNothing);
        expect(find.textContaining(formatPKR(Decimal.parse('2000'))),
            findsOneWidget);
        expect(
          find.textContaining(
              KhataText.balanceTheyOwe(formatPKR(Decimal.parse('1500')))),
          findsOneWidget,
        );
        expect(
          find.textContaining(
              KhataText.balanceTheyOwe(formatPKR(Decimal.parse('2500')))),
          findsOneWidget,
        );
      });
    }

    // The role name alone must never be enough, not even "owner".
    for (final role in const ['cashier', 'manager', 'owner']) {
      testWidgets('$role without it is told to ask', (tester) async {
        final taps = await show(
          tester,
          makeUser(role: role, keys: cashierKeys),
        );
        expect(taps, 0);
        expect(
          find.byKey(const ValueKey('credit-allow-anyway')),
          findsNothing,
        );
        expect(find.byKey(const ValueKey('credit-no-override')), findsOneWidget);
      });
    }

    testWidgets('without it, the numbers need customers.balance.view',
        (tester) async {
      await show(tester, makeUser(keys: cashierKeys));
      expect(find.textContaining(formatPKR(Decimal.parse('2000'))),
          findsNothing);
      expect(find.text(KhataText.creditBlockedNoNumbers), findsOneWidget);

      await show(
        tester,
        makeUser(
          id: 'u2',
          keys: [...cashierKeys, Perm.customersBalanceView],
        ),
      );
      await tester.pump();
      expect(find.textContaining(formatPKR(Decimal.parse('2000'))),
          findsOneWidget);
      expect(find.byKey(const ValueKey('credit-allow-anyway')), findsNothing);
    });
  });

  group('customer payment request', () {
    late FakeRest server;
    late List<FakeCall> sent;

    setUp(() {
      server = FakeRest();
      sent = [];
      server.on('POST', '/customers/{id}/payments', (call) {
        sent.add(call);
        return {
          'ledger_entry_id': 'l1',
          'customer_id': 'c1',
          'amount': '100.00',
          'new_balance': '0.00',
        };
      });
    });

    CustomersRepositoryImpl repo() => CustomersRepositoryImpl(
          remoteDataSource: CustomersRemoteDataSourceImpl(server.client),
          errorHandler: _errors,
        );

    test('sends payment_source, and a shift only when one is given', () async {
      await repo().recordPayment(
        'c1',
        amount: Decimal.parse('100'),
        paymentSource: PaymentSource.drawer.apiValue,
        registerShiftId: 'shift-1',
      );
      await repo().recordPayment(
        'c1',
        amount: Decimal.parse('100'),
        paymentSource: PaymentSource.easypaisa.apiValue,
        referenceNo: 'TX-9',
      );
      expect(sent[0].body['payment_source'], 'drawer');
      expect(sent[0].body['register_shift_id'], 'shift-1');
      expect(sent[0].body, isNot(contains('payment_method')));
      expect(sent[1].body['payment_source'], 'easypaisa');
      expect(sent[1].body['reference_no'], 'TX-9');
      expect(sent[1].body, isNot(contains('register_shift_id')));
    });

    test('no_open_shift and "another user\'s shift" come back readable',
        () async {
      server.on(
        'POST',
        '/customers/{id}/payments',
        (_) => jsonResponse(_coded('no_open_shift'), status: 400),
      );
      final noShift = await repo().recordPayment(
        'c1',
        amount: Decimal.one,
        paymentSource: 'drawer',
      );
      expect(noShift.fold((f) => f.code, (_) => null), 'no_open_shift');

      server.on(
        'POST',
        '/customers/{id}/payments',
        (_) => jsonResponse(_coded('shift_not_yours'), status: 403),
      );
      final other = await repo().recordPayment(
        'c1',
        amount: Decimal.one,
        paymentSource: 'drawer',
        registerShiftId: 'not-mine',
      );
      final failure = other.fold((f) => f, (_) => null)!;
      expect(failure, isA<PermissionDeniedFailure>());
      expect(KhataText.forCode(failure.code), KhataText.shiftNotYours);
    });
  });

  group('customer payment source cards', () {
    testWidgets('are Cash, Bank, Easypaisa, JazzCash, Cheque and Card',
        (tester) async {
      PaymentSource? picked;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PaymentSourceCards(
            sources: PaymentSource.customerSources,
            incoming: true,
            selected: PaymentSource.drawer,
            onSelected: (s) => picked = s,
          ),
        ),
      ));
      for (final value in const [
        'drawer', 'bank', 'easypaisa', 'jazzcash', 'cheque', 'card', //
      ]) {
        expect(find.byKey(ValueKey('source_$value')), findsOneWidget);
      }
      for (final value in const ['owner_pocket', 'wallet', 'other']) {
        expect(find.byKey(ValueKey('source_$value')), findsNothing);
      }
      expect(find.text('Cash into the till'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('source_card')));
      expect(picked, PaymentSource.card);
    });

    test('only cash touches the drawer', () {
      expect(
        PaymentSource.customerSources.where((s) => s.touchesDrawer),
        [PaymentSource.drawer],
      );
    });
  });

  group('shift summary cash movements', () {
    Map<String, dynamic> movement(
      String id, {
      String type = 'cash_out',
      String source = 'supplier_payment',
      String? party = 'Ali Traders',
      bool reversed = false,
      String amount = '300.00',
    }) =>
        {
          'id': id,
          'type': type,
          'amount': amount,
          'source': source,
          'party_type': party == null ? null : 'supplier',
          'party_name': party,
          'reference': 'REF-$id',
          'time': '2026-11-20T10:00:00Z',
          'reversed': reversed,
        };

    test('the summary reads cash_movements from the server', () {
      final summary = ShiftSummaryModel.fromJson({
        'shift_id': 's1',
        'cash_movements': [movement('m1', reversed: true)],
      });
      final m = summary.cashMovements.single;
      expect(m.source, 'supplier_payment');
      expect(m.partyName, 'Ali Traders');
      expect(m.reference, 'REF-m1');
      expect(m.reversed, isTrue);
    });

    testWidgets('lists them, with the reversed one struck through',
        (tester) async {
      final movements = [
        ShiftCashMovement.fromJson(movement('m1', reversed: true)),
        ShiftCashMovement.fromJson(movement(
          'm2',
          type: 'cash_in',
          source: 'supplier_payment_reversal',
        )),
        ShiftCashMovement.fromJson(movement(
          'm3',
          type: 'cash_in',
          source: 'customer_payment',
          party: 'Sana',
          amount: '450.00',
        )),
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ShiftCashMovements(movements: movements)),
      ));

      TextStyle styleOf(String id, String text) => tester
          .widget<Text>(find.descendant(
            of: find.byKey(ValueKey('cash-movement-$id')),
            matching: find.text(text),
          ))
          .style!;

      expect(
        styleOf('m1', 'Paid to Ali Traders').decoration,
        TextDecoration.lineThrough,
      );
      expect(
        styleOf('m2', 'Reversal: payment to Ali Traders').decoration,
        isNot(TextDecoration.lineThrough),
      );
      expect(
        styleOf('m3', 'Received from Sana').decoration,
        isNot(TextDecoration.lineThrough),
      );
      expect(
        find.text('+ ${formatPKR(Decimal.parse('450'))}'),
        findsOneWidget,
      );
      expect(
        find.text('− ${formatPKR(Decimal.parse('300'))}'),
        findsOneWidget,
      );
      expect(
        find.textContaining(KhataText.reversedTag),
        findsWidgets,
      );
    });
  });

  group('money label (business.currency_label)', () {
    AppSettingModel setting(String label, {String? branch}) => AppSettingModel(
          id: 's-$label',
          businessId: 'b1',
          branchId: branch,
          settingKey: 'business.currency_label',
          settingValue: {'value': label},
        );

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      addTearDown(
        () => CurrencyLabelHolder.current = CurrencyLabelHolder.fallback,
      );
    });

    test('the business-wide setting names the money, also offline', () async {
      final preferences =
          PreferencesStorage(await SharedPreferences.getInstance());
      var online = true;
      final store = CurrencyLabelStore(
        fetch: () async {
          if (!online) throw Exception('offline');
          return [setting('XX', branch: 'br'), setting('PKR')];
        },
        businessId: () async => 'b1',
        preferences: preferences,
      );
      await store.refresh();
      expect(formatPKR(Decimal.parse('5')), startsWith('PKR'));

      // After a restart with no connection the remembered label is used.
      CurrencyLabelHolder.current = CurrencyLabelHolder.fallback;
      online = false;
      await store.loadRemembered();
      await store.refresh();
      expect(currencyLabel, 'PKR');
    });

    test('another business does not inherit it', () async {
      final preferences =
          PreferencesStorage(await SharedPreferences.getInstance());
      await preferences.setCurrencyLabel('b1', 'PKR');
      CurrencyLabelHolder.current = 'PKR';
      await CurrencyLabelStore(
        fetch: () async => const [],
        businessId: () async => 'b2',
        preferences: preferences,
      ).loadRemembered();
      expect(currencyLabel, CurrencyLabelHolder.fallback);
    });
  });

  group('sync flags', () {
    test('the new flags are explained in plain words', () {
      for (final code in const [
        'credit_limit_overridden',
        'credit_override_denied',
      ]) {
        expect(SyncErrorText.flagText[code], isNotNull, reason: code);
        expect(SyncErrorText.flagTitle[code], isNotNull, reason: code);
        expect(SyncErrorText.flag(code), isNot(contains('_')), reason: code);
      }
      final cash = SyncErrorText.paymentFlag('shift_mismatch');
      expect(cash, contains('no open shift'));
      expect(cash, isNot(contains('_')));
      expect(cash, isNot(SyncErrorText.flag('shift_mismatch')));
      expect(SyncErrorText.flagTitle['shift_mismatch'], isNotNull);
    });

    Future<void> openFlags(WidgetTester tester, Widget page) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }

    testWidgets('the page shows flagged sales and this device\'s payments',
        (tester) async {
      await openFlags(
        tester,
        FlagsPage(
          allowed: true,
          api: _SalesFlags(const [
            FlaggedSale(
              id: 's1',
              saleNumber: 'S-1',
              flags: ['credit_limit_overridden', 'credit_override_denied'],
              totalAmount: '500',
              cashierName: 'Sana',
            ),
          ]),
          payments: () async => const [
            FlaggedPayment(
              opId: 'op-1',
              amount: '250',
              flags: ['shift_mismatch'],
              customerName: 'Ali',
            ),
          ],
        ),
      );
      expect(find.byKey(const Key('flagged-payment-op-1')), findsOneWidget);
      expect(find.textContaining('from Ali'), findsOneWidget);
      expect(
        find.text(SyncErrorText.paymentFlag('shift_mismatch')),
        findsOneWidget,
      );
      expect(
        find.text(SyncErrorText.flag('credit_limit_overridden')),
        findsOneWidget,
      );
      expect(
        find.text(SyncErrorText.flag('credit_override_denied')),
        findsOneWidget,
      );
    });

    testWidgets('a flagged payment shows even with no flagged sales',
        (tester) async {
      await openFlags(
        tester,
        FlagsPage(
          allowed: true,
          api: _SalesFlags(const []),
          payments: () async => const [
            FlaggedPayment(
              opId: 'op-1',
              amount: '250',
              flags: ['shift_mismatch'],
            ),
          ],
        ),
      );
      expect(find.byKey(const Key('flagged-payment-op-1')), findsOneWidget);
      expect(find.byKey(const Key('no-flags')), findsOneWidget);
    });

    test('an allowed override travels with the sale made offline', () async {
      final rig = SyncRig()..seedServer();
      addTearDown(rig.dispose);
      await rig.sync();
      final body = rig.cartBody(
        customerId: 'c1',
        payments: [
          {'payment_method': 'credit', 'amount': '210.00'},
        ],
      );
      await rig.writer.saveSale({...body});
      await rig.writer.saveSale({...body, 'credit_override': true});
      await rig.sync();

      final sent = [
        for (final op in rig.server.receivedOps)
          if (op['type'] == 'sale.create') op['payload'] as Map,
      ];
      expect(sent, hasLength(2));
      expect(sent.first, isNot(contains('credit_override')));
      expect(sent.last['credit_override'], isTrue);
    });

    test('a pushed cash payment flagged by the server is remembered', () async {
      final rig = SyncRig()..seedServer();
      addTearDown(rig.dispose);
      rig.server.paymentFlags = const ['shift_mismatch'];
      await rig.sync();
      await rig.writer.recordCustomerPayment(
        customerId: 'c1',
        amount: Decimal.parse('250'),
        paymentSource: 'drawer',
      );
      await rig.sync();
      await rig.sync();

      final kept = (await rig.store.flaggedPayments()).single;
      expect(kept.flags, ['shift_mismatch']);
      expect(Decimal.parse(kept.amount), Decimal.parse('250'));
    });
  });
}
