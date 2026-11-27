import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/presentation/widgets/customer_credit_strip.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';
import 'package:frantend/features/pos/domain/utils/payment_planner.dart';
import 'package:frantend/features/sync/presentation/pages/flags_page.dart';

import '../helpers/session_fixtures.dart';
import '../sync/fake_sync_server.dart';

AccessCubit _access(User user) => AccessCubit(
      fetchCurrentUser: () async => user,
      loadCachedUser: () async => user,
    )..apply(user);

Widget _host(Widget child, {User? user}) {
  final page = MaterialApp(home: Scaffold(body: child));
  if (user == null) return page;
  return BlocProvider.value(value: _access(user), child: page);
}

CustomerModel _customer({String? balance, String limit = '2000'}) =>
    CustomerModel(
      id: 'c1',
      businessId: 'b1',
      name: 'Ali',
      creditLimit: limit,
      balance: balance,
    );

PaymentInput _in(String method, String amount) =>
    PaymentInput(method: method, entered: Decimal.parse(amount));

class _FlagsServer extends FakeSyncServer {
  @override
  Future<List<FlaggedSale>> flags({
    String? flag,
    int skip = 0,
    int limit = 100,
  }) async =>
      const [
        FlaggedSale(
          id: 's1',
          saleNumber: 'S-1',
          flags: ['underpaid_unreconciled'],
          totalAmount: '500',
          cashierName: 'Sana',
        ),
      ];
}

void main() {
  final withView = makeUser(
    role: 'cashier',
    keys: [...cashierKeys, Perm.customersBalanceView],
  );
  final withoutView = makeUser(role: 'cashier', keys: cashierKeys);

  group('cashier credit strip (customers.balance.view)', () {
    testWidgets('shows owes, limit and what is left', (tester) async {
      await tester.pumpWidget(_host(
        CustomerCreditStrip(customer: _customer(balance: '-500')),
        user: withView,
      ));
      expect(find.byKey(const ValueKey('customer-credit-strip')), findsOne);
      expect(find.textContaining('500'), findsWidgets);
      expect(find.byKey(const ValueKey('credit-owes')), findsOneWidget);
      expect(find.byKey(const ValueKey('credit-limit')), findsOneWidget);
      // 2000 limit - 500 owed = 1,500 left
      final left = tester.widget<Row>(
        find.byKey(const ValueKey('credit-available')),
      );
      expect(
        left.children.whereType<Text>().last.data,
        contains('1,500'),
      );
    });

    testWidgets('a cashier without the permission sees nothing',
        (tester) async {
      await tester.pumpWidget(_host(
        CustomerCreditStrip(customer: _customer(balance: '-500')),
        user: withoutView,
      ));
      expect(find.byKey(const ValueKey('customer-credit-strip')), findsNothing);
    });

    testWidgets('no limit set says "No limit" and shows no "left" figure',
        (tester) async {
      await tester.pumpWidget(_host(
        CustomerCreditStrip(customer: _customer(balance: '0', limit: '0')),
        user: withView,
      ));
      expect(find.text(KhataText.noLimit), findsOneWidget);
      expect(find.byKey(const ValueKey('credit-available')), findsNothing);
    });

    testWidgets('nothing is shown until the balance is known', (tester) async {
      await tester.pumpWidget(_host(
        CustomerCreditStrip(customer: _customer()),
        user: withView,
      ));
      expect(find.byKey(const ValueKey('customer-credit-strip')), findsNothing);
    });
  });

  group('credit pre-check follows the permission', () {
    test('with balance access, an over-limit sale is stopped here', () {
      final a = PaymentPlanner.allocate(
        total: Decimal.parse('1000'),
        inputs: [_in(PaymentMethods.credit, '1000')],
        customer: _customer(balance: '-1500'),
      );
      expect(a.error, isNotNull);
      expect(a.canComplete, isFalse);
    });

    test('without balance access, the server decides (no local block)', () {
      final a = PaymentPlanner.allocate(
        total: Decimal.parse('1000'),
        inputs: [_in(PaymentMethods.credit, '1000')],
        customer: _customer(balance: '-1500'),
        canSeeBalance: false,
      );
      expect(a.error, isNull);
      expect(a.canComplete, isTrue);
    });

    test('credit still needs a customer, whatever the permission', () {
      final a = PaymentPlanner.allocate(
        total: Decimal.parse('100'),
        inputs: [_in(PaymentMethods.credit, '100')],
        customer: null,
        canSeeBalance: false,
      );
      expect(a.error, isNotNull);
    });

    test('balance_owed convention: negative balance is what they owe', () {
      final c = PaymentPlanner.creditContext(_customer(balance: '-750'));
      expect(c.alreadyOwed, Decimal.parse('750'));
      expect(c.available, Decimal.parse('1250'));
    });
  });

  group('SaleFailureMapper', () {
    test('credit limit', () {
      expect(
        SaleFailureMapper.map(
          const ValidationFailure('Credit limit exceeded: limit 5'),
          hasCustomer: true,
        ),
        isNull,
        reason: 'the code decides, not the sentence',
      );
      expect(
        SaleFailureMapper.map(
          const ServerFailure('x', 'credit_limit_exceeded'),
          hasCustomer: true,
        ),
        isA<CreditLimitExceededException>(),
      );
    });

    test('under-paid with and without a customer', () {
      final none = SaleFailureMapper.map(
        const ValidationFailure('payment is less than total'),
        hasCustomer: false,
      ) as PaymentMismatchException;
      final some = SaleFailureMapper.map(
        const ValidationFailure('payment is less than total'),
        hasCustomer: true,
      ) as PaymentMismatchException;
      expect(none.message, KhataText.underpaidNoCustomer);
      expect(some.message, KhataText.underpaidWithCustomer);
    });

    test('credit without a customer', () {
      final e = SaleFailureMapper.map(
        const ValidationFailure('customer_id is required for credit payments'),
        hasCustomer: false,
      ) as PaymentMismatchException;
      expect(e.message, KhataText.underpaidNeedsCustomer);
    });

    test('anything else is left to the caller', () {
      expect(
        SaleFailureMapper.map(const ServerFailure('boom'), hasCustomer: true),
        isNull,
      );
    });

    test('messages are plain words, no codes or jargon', () {
      for (final m in [
        KhataText.underpaidNoCustomer,
        KhataText.underpaidWithCustomer,
        KhataText.underpaidNeedsCustomer,
        KhataText.creditBlockedNoNumbers,
        KhataText.creditBlockedNoOverride,
      ]) {
        expect(m, isNot(contains('_')), reason: m);
        expect(m, isNot(contains('400')), reason: m);
      }
    });
  });

  group('Sync > Flags explains under-paid sales', () {
    test('the flag has a title and a plain sentence', () {
      expect(SyncErrorText.flagText['underpaid_unreconciled'],
          KhataText.underpaidFlagExplain);
      expect(SyncErrorText.flagTitle['underpaid_unreconciled'],
          KhataText.underpaidFlagTitle);
      expect(SyncErrorText.flag('underpaid_unreconciled'),
          isNot(contains('underpaid_unreconciled')));
    });

    testWidgets('FlagsPage shows both', (tester) async {
      await tester.pumpWidget(
        _host(FlagsPage(api: _FlagsServer(), allowed: true)),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      expect(
        find.byKey(const Key('flag-title-underpaid_unreconciled')),
        findsOneWidget,
      );
      expect(find.text(KhataText.underpaidFlagTitle), findsOneWidget);
      expect(find.text(KhataText.underpaidFlagExplain), findsOneWidget);
    });
  });
}
