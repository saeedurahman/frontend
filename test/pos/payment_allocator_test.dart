import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';

Decimal d(String v) => Decimal.parse(v);

PaymentInput cash(String v) =>
    PaymentInput(method: PaymentMethods.cash, entered: d(v));
PaymentInput card(String v) =>
    PaymentInput(method: PaymentMethods.card, entered: d(v));
PaymentInput wallet(String v) =>
    PaymentInput(method: PaymentMethods.wallet, entered: d(v));
PaymentInput credit() =>
    PaymentInput(method: PaymentMethods.credit, entered: Decimal.zero);

void main() {
  group('exact payment', () {
    test('cash == total completes with no change', () {
      final a = PaymentAllocator.allocate(total: d('100'), inputs: [cash('100')]);
      expect(a.canComplete, isTrue);
      expect(a.change, Decimal.zero);
      expect(a.applied, d('100'));
    });

    test('split cash + card + wallet that sums to total completes', () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [cash('40'), card('35'), wallet('25')],
      );
      expect(a.canComplete, isTrue);
      expect(a.applied, d('100'));
      expect(a.lines.map((l) => l.paymentMethod),
          [PaymentMethods.cash, PaymentMethods.card, PaymentMethods.wallet]);
    });
  });

  group('under-payment', () {
    test('less than total cannot complete', () {
      final a = PaymentAllocator.allocate(total: d('100'), inputs: [cash('99.99')]);
      expect(a.canComplete, isFalse);
      expect(a.remaining, d('0.01'));
    });

    test('no lines cannot complete', () {
      final a = PaymentAllocator.allocate(total: d('100'), inputs: const []);
      expect(a.canComplete, isFalse);
    });

    test('zero total cannot complete through the modal', () {
      final a = PaymentAllocator.allocate(total: Decimal.zero, inputs: [cash('0')]);
      expect(a.canComplete, isFalse);
    });
  });

  group('cash overpayment', () {
    test('cash is capped at the amount due and change is reported', () {
      final a = PaymentAllocator.allocate(total: d('730'), inputs: [cash('1000')]);
      expect(a.canComplete, isTrue);
      expect(a.lines.single.amount, d('730'));
      expect(a.change, d('270'));
      expect(a.lines.single.tendered, d('1000'));
      expect(a.lines.single.change, d('270'));
    });

    test('card is applied first, cash only covers the rest', () {
      final a = PaymentAllocator.allocate(
        total: d('700'),
        inputs: [card('300'), cash('1000')],
      );
      expect(a.lines[0].amount, d('300'));
      expect(a.lines[1].amount, d('400'));
      expect(a.change, d('600'));
      expect(a.applied, d('700'));
    });

    test('non-cash overpayment is capped and flagged, never turned into change',
        () {
      final a = PaymentAllocator.allocate(total: d('100'), inputs: [card('150')]);
      expect(a.lines.single.amount, d('100'));
      expect(a.change, Decimal.zero);
      expect(a.cappedInputIndexes, {0});
      expect(a.canComplete, isTrue);
    });

    test('sent amounts never exceed the total', () {
      final a = PaymentAllocator.allocate(
        total: d('50'),
        inputs: [cash('80'), card('20'), wallet('30')],
      );
      expect(a.applied, d('50'));
    });
  });

  group('credit', () {
    const customer = CreditContext(hasCustomer: true);

    test('credit takes exactly the remainder', () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [cash('30'), credit()],
        credit: customer,
      );
      expect(a.creditAmount, d('70'));
      expect(a.lines.last.amount, d('70'));
      expect(a.applied, d('100'));
      expect(a.canComplete, isTrue);
    });

    test('credit-only sells the whole total on account', () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [credit()],
        credit: customer,
      );
      expect(a.creditAmount, d('100'));
      expect(a.canComplete, isTrue);
    });

    test('credit without a customer blocks completion', () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [credit()],
      );
      expect(a.canComplete, isFalse);
      expect(a.error, contains('customer'));
    });

    test('credit above the customer limit blocks completion', () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [credit()],
        credit: CreditContext(
          hasCustomer: true,
          creditLimit: d('150'),
          balance: d('-80'),
        ),
      );
      expect(a.canComplete, isFalse);
      expect(a.error, contains('Credit limit exceeded'));
      expect(a.error, contains('70.00'));
    });

    test('credit exactly at the available limit is allowed', () {
      final a = PaymentAllocator.allocate(
        total: d('70'),
        inputs: [credit()],
        credit: CreditContext(
          hasCustomer: true,
          creditLimit: d('150'),
          balance: d('-80'),
        ),
      );
      expect(a.canComplete, isTrue);
    });

    test('a limit with an unknown balance blocks credit', () {
      final a = PaymentAllocator.allocate(
        total: d('10'),
        inputs: [credit()],
        credit: CreditContext(hasCustomer: true, creditLimit: d('100')),
      );
      expect(a.canComplete, isFalse);
      expect(a.error, contains('balance'));
    });

    test('limit 0 means unlimited (backend rule)', () {
      final a = PaymentAllocator.allocate(
        total: d('1000000'),
        inputs: [credit()],
        credit: CreditContext(
          hasCustomer: true,
          creditLimit: Decimal.zero,
          balance: d('-500'),
        ),
      );
      expect(a.canComplete, isTrue);
    });

    test('a positive balance (customer in credit) does not reduce the limit',
        () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [credit()],
        credit: CreditContext(
          hasCustomer: true,
          creditLimit: d('100'),
          balance: d('40'),
        ),
      );
      expect(a.canComplete, isTrue);
    });

    test('credit line is dropped when other methods already cover the total',
        () {
      final a = PaymentAllocator.allocate(
        total: d('100'),
        inputs: [cash('100'), credit()],
        credit: customer,
      );
      expect(a.lines, hasLength(1));
      expect(a.creditAmount, Decimal.zero);
      expect(a.canComplete, isTrue);
    });
  });
}
