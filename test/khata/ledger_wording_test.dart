// What the two account tables say: who owes (in words, never a minus sign),
// what happened, which way each amount moved, where the money came from, and
// the newest row first.

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/pages/customer_ledger_page.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_wording.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ledger_table.dart';

import '../helpers/fake_rest.dart';
import '../helpers/khata_fakes.dart';
import '../refresh/refresh_fixtures.dart';
import '../sync/sync_rig.dart';

const _red = AppColors.error;
const _green = AppColors.success;

Decimal _d(String v) => Decimal.parse(v);

SupplierLedgerEntry _supplierRow(
  String id,
  String type,
  String amount,
  String running, {
  required int day,
  String? source,
  String? referenceType,
}) =>
    SupplierLedgerEntry(
      id: id,
      supplierId: 's1',
      entryType: type,
      amount: _d(amount),
      runningBalance: _d(running),
      entryAt: DateTime(2026, 11, day, 12),
      paymentSource: source,
      referenceType: referenceType,
    );

/// The one [Text] showing exactly [text].
Text _text(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text));

void _expectColor(WidgetTester tester, String text, Color color) =>
    expect(_text(tester, text).style?.color, color, reason: text);

double _top(WidgetTester tester, String text) =>
    tester.getTopLeft(find.text(text)).dy;

/// No amount of money on screen carries a plus or minus sign.
void _expectNoSignedMoney(WidgetTester tester) {
  final all = tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.data ?? '')
      .toList();
  expect(
    all.where((s) => RegExp(r'(^|\s)[+-]\s*(Rs|\d)|Rs\.\s*[+-]').hasMatch(s)),
    isEmpty,
  );
}

void _bigWindow(WidgetTester tester) {
  final previous = FlutterError.onError;
  FlutterError.onError = (d) {
    if (d.exceptionAsString().contains('overflowed')) return;
    previous?.call(d);
  };
  addTearDown(() => FlutterError.onError = previous);
  tester.view.physicalSize = const Size(2200, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() {
    TaxSettingsHolder.current = const TaxSettings(hideZeroDecimals: true);
  });
  tearDown(() => TaxSettingsHolder.current = TaxSettings.defaults);

  group('balance words', () {
    test('supplier: we owe in red, advance in green, settled', () {
      expect(
        LedgerWording.balance(_d('-600'), LedgerParty.supplier),
        (text: 'Rs. 600 we owe', color: _red),
      );
      expect(
        LedgerWording.balance(_d('200'), LedgerParty.supplier),
        (text: 'Rs. 200 advance', color: _green),
      );
      expect(
        LedgerWording.balance(Decimal.zero, LedgerParty.supplier).text,
        'Settled',
      );
    });

    test('customer: they owe in red, advance in green', () {
      expect(
        LedgerWording.balance(_d('-117'), LedgerParty.customer),
        (text: 'Rs. 117 they owe', color: _red),
      );
      expect(
        LedgerWording.balance(_d('50'), LedgerParty.customer),
        (text: 'Rs. 50 advance', color: _green),
      );
    });

    test('paisa are kept', () {
      expect(
        LedgerWording.balance(_d('-117.5'), LedgerParty.customer).text,
        'Rs. 117.50 they owe',
      );
    });
  });

  group('amount words and colours', () {
    ({String text, Color color}) amount(
      String type,
      String value,
      LedgerParty party,
    ) =>
        LedgerWording.amount(type: type, amount: _d(value), party: party);

    test('supplier: goods add to what we owe, payments take from it', () {
      expect(
        amount('sale', '-1000', LedgerParty.supplier),
        (text: 'Goods received 1,000', color: _red),
      );
      expect(
        amount('payment', '300', LedgerParty.supplier),
        (text: 'Paid 300', color: _green),
      );
      expect(
        amount('reversal', '-300', LedgerParty.supplier),
        (text: 'Reversed 300', color: _red),
      );
      expect(
        amount('return', '100', LedgerParty.supplier),
        (text: 'Returned 100', color: _green),
      );
    });

    test('customer: the same, seen from the customer', () {
      expect(
        amount('sale', '-1000', LedgerParty.customer),
        (text: 'Credit sale 1,000', color: _red),
      );
      expect(
        amount('payment', '300', LedgerParty.customer),
        (text: 'Received 300', color: _green),
      );
      expect(
        amount('reversal', '-300', LedgerParty.customer),
        (text: 'Reversed 300', color: _red),
      );
    });

    test('a correction goes either way', () {
      expect(
        amount('adjustment', '-5', LedgerParty.supplier).text,
        'Added 5',
      );
      expect(
        amount('adjustment', '5', LedgerParty.supplier).text,
        'Reduced 5',
      );
    });
  });

  group('wording from the fields, not the stored description', () {
    LedgerLine customer(Map<String, dynamic> row) => LedgerLine.fromCustomer(
          CustomerLedgerEntryModel.fromJson({
            'id': 'r1',
            'business_id': 'b1',
            'customer_id': 'c1',
            'amount': '50',
            'entry_type': 'payment',
            ...row,
          }),
        );

    test('every source has one label', () {
      expect(
        {
          for (final s in [
            'drawer',
            'owner_pocket',
            'bank',
            'bank_transfer',
            'easypaisa',
            'jazzcash',
            'cheque',
            'card',
          ])
            s: PaymentSource.describe(s),
        },
        {
          'drawer': 'Cash drawer',
          'owner_pocket': "Owner's pocket",
          'bank': 'Bank',
          'bank_transfer': 'Bank',
          'easypaisa': 'Easypaisa',
          'jazzcash': 'JazzCash',
          'cheque': 'Cheque',
          'card': 'Card',
        },
      );
    });

    test("a customer's account uses the words of their statement", () {
      expect(
        {
          for (final s in [
            'drawer',
            'cash',
            'owner_pocket',
            'bank',
            'bank_transfer',
            'easypaisa',
            'jazzcash',
            'cheque',
            'card',
            'something_new',
          ])
            s: customer({'payment_source': s}).sourceLabel,
        },
        {
          'drawer': 'Cash',
          'cash': 'Cash',
          'owner_pocket': 'Cash',
          'bank': 'Bank transfer',
          'bank_transfer': 'Bank transfer',
          'easypaisa': 'Easypaisa',
          'jazzcash': 'JazzCash',
          'cheque': 'Cheque',
          'card': 'Card',
          'something_new': 'Other',
        },
      );
      expect(
        customer({'payment_source': 'cash', 'register_shift_id': 's1'})
            .sourceLabel,
        'Cash',
      );
      expect(customer({}).sourceLabel, '');
    });

    test('an old generated description is not shown', () {
      final line = customer({
        'payment_source': 'bank',
        'reference_no': 'TX-9',
        'notes': 'Payment received via bank_transfer | Ref: TX-9 | for May',
      });
      expect(line.detail, 'Bank transfer · #TX-9');
      expect(line.note, 'for May');
    });

    test('a reference kept only in the old text is still shown', () {
      final line = customer({
        'payment_source': 'cheque',
        'notes': 'Payment received via cheque | Ref: 000123',
      });
      expect(line.detail, 'Cheque · #000123');
      expect(line.note, isNull);
    });

    test('old reversal text leaves the reason', () {
      final line = customer({
        'entry_type': 'reversal',
        'amount': '-50',
        'notes': 'Reversal of payment: typed twice',
      });
      expect(line.note, 'typed twice');
    });

    test("the user's own words and goods receipt text stay", () {
      expect(
        customer({'notes': 'Payment received via my brother'}).note,
        'Payment received via my brother',
      );
      final paid = LedgerLine.fromSupplier(
        SupplierLedgerEntry(
          id: 's',
          supplierId: 's1',
          entryType: 'payment',
          amount: _d('300'),
          runningBalance: _d('0'),
          entryAt: DateTime(2026, 11, 1),
          paymentSource: 'drawer',
          notes: 'Paid at goods receipt GRN-7',
        ),
      );
      expect(paid.note, 'Paid at goods receipt GRN-7');
      expect(paid.detail, 'Cash drawer');
    });
  });

  group('what happened', () {
    test('goods received from a supplier is never called a sale', () {
      expect(LedgerLine.supplierTypeLabel('sale'), 'Goods received');
      expect(LedgerLine.supplierTypeLabel('purchase'), 'Goods received');
      expect(
        LedgerLine.supplierTypeLabel('sale', isExpense: true),
        'Expense on credit',
      );
      expect(LedgerLine.supplierTypeLabel('payment'), 'Payment made');
      expect(LedgerLine.supplierTypeLabel('reversal'), 'Payment reversed');
    });

    test('customer rows', () {
      expect(LedgerLine.customerTypeLabel('sale'), 'Credit sale');
      expect(LedgerLine.customerTypeLabel('payment'), 'Payment received');
      expect(LedgerLine.customerTypeLabel('reversal'), 'Payment reversed');
      expect(LedgerLine.customerTypeLabel('return_'), 'Goods returned');
      expect(LedgerLine.customerTypeLabel('refund'), 'Credit sale cancelled');
      expect(LedgerLine.customerTypeLabel('correction'), 'Adjustment');
    });
  });

  testWidgets('the supplier table, newest first', (tester) async {
    _bigWindow(tester);
    // As the server sends them: newest first.
    final lines = [
      _supplierRow('r8', 'payment', '1300', '200', day: 8, source: 'cheque'),
      _supplierRow('r7', 'payment', '100', '-1100', day: 7, source: 'jazzcash'),
      _supplierRow('r6', 'payment', '90', '-1200', day: 6, source: 'easypaisa'),
      _supplierRow('r5', 'payment', '80', '-1290', day: 5, source: 'bank'),
      _supplierRow(
        'r4',
        'payment',
        '70',
        '-1370',
        day: 4,
        source: 'owner_pocket',
      ),
      _supplierRow('r3', 'payment', '60', '-1440', day: 3, source: 'drawer'),
      _supplierRow(
        'r2',
        'sale',
        '-500',
        '-1500',
        day: 2,
        referenceType: 'expense',
      ),
      _supplierRow(
        'r1',
        'sale',
        '-1000',
        '-1000',
        day: 1,
        referenceType: 'purchase_receipt_line',
      ),
    ].map(LedgerLine.fromSupplier).toList();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: KhataLedgerTable(lines: lines)),
        ),
      ),
    );

    for (final header in ['What happened', 'Paid from', 'Amount', 'Balance']) {
      expect(find.text(header), findsOneWidget);
    }

    expect(find.text('Goods received'), findsOneWidget);
    expect(find.text('Expense on credit'), findsOneWidget);
    expect(find.text('Payment made'), findsNWidgets(6));
    expect(find.textContaining('Sale'), findsNothing);

    for (final source in [
      'Cash drawer',
      "Owner's pocket",
      'Bank',
      'Easypaisa',
      'JazzCash',
      'Cheque',
    ]) {
      expect(find.text(source), findsOneWidget, reason: source);
    }

    _expectColor(tester, 'Goods received 1,000', _red);
    _expectColor(tester, 'Expense 500', _red);
    _expectColor(tester, 'Paid 60', _green);
    _expectColor(tester, 'Rs. 1,000 we owe', _red);
    _expectColor(tester, 'Rs. 200 advance', _green);
    _expectNoSignedMoney(tester);

    final tops = [
      for (final balance in [
        'Rs. 200 advance',
        'Rs. 1,100 we owe',
        'Rs. 1,200 we owe',
        'Rs. 1,290 we owe',
        'Rs. 1,370 we owe',
        'Rs. 1,440 we owe',
        'Rs. 1,500 we owe',
        'Rs. 1,000 we owe',
      ])
        _top(tester, balance),
    ];
    expect(tops, [...tops]..sort());
  });

  group('the customer table', () {
    useActiveBranch();

    Map<String, dynamic> row(
      String id,
      String type,
      String amount,
      String running, {
      required int day,
      String? source,
      String? shift,
    }) =>
        {
          'id': id,
          'business_id': kBusiness,
          'customer_id': 'c1',
          'entry_type': type,
          'amount': amount,
          'running_balance': running,
          'entry_at': '2026-11-${'$day'.padLeft(2, '0')}T10:00:00Z',
          'payment_source': source,
          'register_shift_id': shift,
          'branch_id': kBranch,
        };

    testWidgets('words, colours, sources and order', (tester) async {
      _bigWindow(tester);
      final server = FakeRest();
      server.on(
        'GET',
        '/customers/{id}',
        (_) => {
          'id': 'c1',
          'business_id': kBusiness,
          'name': 'Ali Khan',
          'is_active': true,
        },
      );
      server.on(
        'GET',
        '/customers/{id}/balance',
        (_) => {'customer_id': 'c1', 'balance': '-117'},
      );
      server.on(
        'GET',
        '/customers/{id}/ledger',
        (_) => [
          row('r5', 'reversal', '-40', '-117', day: 5, source: 'bank'),
          row(
            'r4',
            'payment',
            '1000',
            '-77',
            day: 4,
            source: 'cash',
            shift: 'shift-1',
          ),
          row('r3', 'sale', '-1127', '-1077', day: 3),
          row('r2', 'payment', '40', '50', day: 2, source: 'easypaisa'),
          row('r1', 'adjustment', '10', '10', day: 1),
        ],
      );
      final repo = CustomersRepositoryImpl(
        remoteDataSource: CustomersRemoteDataSourceImpl(server.client),
        errorHandler: const ErrorHandler(),
      );
      sl.registerFactory(
        () => CustomerLedgerCubit(
          getCustomerUseCase: GetCustomerUseCase(repo),
          getCustomerBalanceUseCase: GetCustomerBalanceUseCase(repo),
          getCustomerLedgerUseCase: GetCustomerLedgerUseCase(repo),
          recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(repo),
          reverseCustomerPaymentUseCase: ReverseCustomerPaymentUseCase(repo),
          shiftGuard: FakeShiftGuard(shiftId: 'shift-1'),
          branchResolver: FakeBranchResolver(kBranch),
          khataEvents: KhataEvents(),
        ),
      );
      addTearDown(() => sl.unregister<CustomerLedgerCubit>());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CustomerLedgerPage(customerId: 'c1')),
        ),
      );
      await tester.pumpAndSettle();

      for (final header in ['What happened', 'Paid from']) {
        expect(find.text(header), findsOneWidget);
      }
      expect(find.text('Credit sale'), findsOneWidget);
      expect(find.text('Payment received'), findsNWidgets(2));
      expect(find.text('Payment reversed'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.textContaining('drawer'), findsNothing);
      expect(find.text('Easypaisa'), findsOneWidget);

      _expectColor(tester, 'Credit sale 1,127', _red);
      _expectColor(tester, 'Received 1,000', _green);
      _expectColor(tester, 'Reversed 40', _red);
      _expectColor(tester, 'Rs. 1,077 they owe', _red);
      _expectColor(tester, 'Rs. 50 advance', _green);
      _expectNoSignedMoney(tester);

      final tops = [
        for (final amount in [
          'Reversed 40',
          'Received 1,000',
          'Credit sale 1,127',
          'Received 40',
          'Reduced 10',
        ])
          _top(tester, amount),
      ];
      expect(tops, [...tops]..sort(), reason: 'newest first');
    });
  });
}
