import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';


import '../helpers/supplier_payment_rig.dart';

void main() {
  group('opening the screen', () {
    test('shows what is owed and defaults to the drawer with a shift open',
        () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      expect(r.cubit.state.owed, Decimal.parse('1000'));
      expect(r.cubit.state.source, PaymentSource.drawer);
      expect(r.cubit.state.shiftId, 'shift-1');
      expect(r.balance.lastBranch, 'branch-9');
    });

    test('with no shift it falls back to the last source used', () async {
      final r = PayRig();
      r.store.value = PaymentSource.bank;
      await r.start();
      expect(r.cubit.state.source, PaymentSource.bank);
    });

    test('with no shift and no history it picks the owner\'s pocket', () async {
      final r = PayRig();
      await r.start();
      expect(r.cubit.state.source, PaymentSource.ownerPocket);
    });

    test('offline: says so and keeps the screen usable for a draft', () async {
      final r = PayRig(shiftId: 'shift-1');
      r.balance.result = const Left(NetworkFailure());
      await r.start();
      expect(r.cubit.state.offline, isTrue);
    });
  });

  group('amount helpers and the advance notice', () {
    test('Pay full and Pay half fill the amount from what is owed', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.payFull();
      expect(r.cubit.state.amount, Decimal.parse('1000'));
      r.cubit.payHalf();
      expect(r.cubit.state.amount, Decimal.parse('500'));
    });

    test('paying more than owed is allowed and becomes an advance', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('1500');
      expect(r.cubit.state.canSubmit, isTrue);
      expect(r.cubit.state.owedAfter, Decimal.zero);
      expect(r.cubit.state.balanceAfter, Decimal.parse('500'));
    });

    test('zero or empty is not payable', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('0');
      expect(r.cubit.state.canSubmit, isFalse);
      r.cubit.setAmount('');
      expect(r.cubit.state.canSubmit, isFalse);
    });
  });

  group('shift needed for drawer cash', () {
    test('drawer with no shift blocks the send and sends nothing', () async {
      final r = PayRig();
      await r.start();
      r.cubit.setSource(PaymentSource.drawer);
      r.cubit.setAmount('100');
      // Blocked even while the shift check is still in flight.
      expect(r.cubit.state.canSubmit, isFalse);
      expect(await r.cubit.submit(), isFalse);
      await Future<void>.delayed(Duration.zero);
      expect(r.cubit.state.needsShift, isTrue);
      expect(r.pay.bodies, isEmpty);
    });

    test('one-tap Open shift unlocks it', () async {
      final r = PayRig();
      await r.start();
      r.cubit.setSource(PaymentSource.drawer);
      r.cubit.setAmount('100');
      expect(await r.cubit.openShift(), isTrue);
      expect(r.shifts.openCalls, 1);
      expect(r.cubit.state.needsShift, isFalse);
      expect(await r.cubit.submit(), isTrue);
    });

    test('a failed Open shift shows why and stays blocked', () async {
      final r = PayRig();
      r.shifts.openResult = const Left(ServerFailure('Register is busy'));
      await r.start();
      r.cubit.setSource(PaymentSource.drawer);
      r.cubit.setAmount('100');
      expect(await r.cubit.openShift(), isFalse);
      expect(r.cubit.state.error, 'Register is busy');
      expect(r.cubit.state.needsShift, isTrue);
    });

    test('bank / wallet / pocket never need a shift', () async {
      for (final source in [
        PaymentSource.bank,
        PaymentSource.easypaisa,
        PaymentSource.jazzcash,
        PaymentSource.cheque,
        PaymentSource.ownerPocket,
      ]) {
        final r = PayRig();
        await r.start();
        r.cubit.setSource(source);
        r.cubit.setAmount('100');
        expect(r.cubit.state.needsShift, isFalse, reason: '$source');
      }
    });

    test('the server saying no_open_shift clears the cached shift', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('100');
      r.pay.result = const Left(ServerFailure('x', 'no_open_shift'));
      expect(await r.cubit.submit(), isFalse);
      expect(r.cubit.state.shiftId, isNull);
      expect(r.cubit.state.error, KhataText.forCode('no_open_shift'));
    });
  });

  group('what is sent', () {
    test('always carries the active branch and the chosen source', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit
        ..setAmount('250')
        ..setSource(PaymentSource.bank)
        ..setReference(' TX-77 ')
        ..setNote('March bill');
      expect(await r.cubit.submit(), isTrue);
      final body = r.pay.bodies.single;
      expect(body['branch_id'], 'branch-9');
      expect(body['supplier_id'], 's1');
      expect(body['amount'], '250.00');
      expect(body['payment_source'], 'bank');
      expect(body['reference'], 'TX-77');
      expect(body['note'], 'March bill');
      expect(body.containsKey('paid_at'), isFalse);
    });

    test('a past date is sent; today is not', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('10');
      r.cubit.setDate(DateTime.now().subtract(const Duration(days: 3)));
      await r.cubit.submit();
      expect(r.pay.bodies.single.containsKey('paid_at'), isTrue);
    });

    test('a future date is refused', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('10');
      r.cubit.setDate(DateTime.now().add(const Duration(days: 3)));
      expect(r.cubit.state.canSubmit, isFalse);
    });

    test('success remembers the source and tells other screens', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('100');
      r.cubit.setSource(PaymentSource.jazzcash);
      await r.cubit.submit();
      expect(r.store.value, PaymentSource.jazzcash);
      expect(r.events.notified, 1);
      expect(r.cubit.state.result, isNotNull);
    });
  });

  group('retrying safely', () {
    test('a lost answer re-sends the SAME Idempotency-Key', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('100');
      r.pay.result = const Left(NetworkFailure());
      expect(await r.cubit.submit(), isFalse);
      expect(r.cubit.state.offline, isTrue);
      expect(r.cubit.state.amountText, '100', reason: 'the draft is kept');
      r.pay.result = null;
      expect(await r.cubit.submit(), isTrue);
      expect(r.pay.keys, hasLength(2));
      expect(r.pay.keys[0], isNotNull);
      expect(r.pay.keys[0], r.pay.keys[1]);
    });

    test('a changed amount is a NEW payment with a new key', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('100');
      r.pay.result = const Left(NetworkFailure());
      await r.cubit.submit();
      r.cubit.setAmount('120');
      r.pay.result = null;
      await r.cubit.submit();
      expect(r.pay.keys[0], isNot(r.pay.keys[1]));
    });

    test('a clear server "no" frees the key for the next try', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('100');
      r.pay.result = const Left(ServerFailure('x', 'no_open_shift'));
      await r.cubit.submit();
      expect(r.cubit.attemptKey, isNull);
    });

    test('after success nothing can be sent twice', () async {
      final r = PayRig(shiftId: 'shift-1');
      await r.start();
      r.cubit.setAmount('100');
      await r.cubit.submit();
      expect(await r.cubit.submit(), isFalse);
      expect(r.pay.bodies, hasLength(1));
    });
  });

  group('KhataText.forCode', () {
    test('knows the no-shift code', () {
      expect(KhataText.forCode('no_open_shift'), KhataText.needsShiftBody);
      expect(KhataText.forCode('something_else'), isNull);
      expect(KhataText.forCode(null), isNull);
    });
  });
}
