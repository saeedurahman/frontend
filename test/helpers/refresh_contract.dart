// The two promises every form/list pair in the app has to keep, as reusable
// checks. Neither of them navigates, reloads or waits for a timer: after the
// write, the list has to get the news by itself.

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';

/// Lets queued events and the re-reads they started finish.
Future<void> settle(Cubit<Object?> cubit) async {
  final Object watcher = cubit;
  for (var i = 0; i < 4; i++) {
    await pumpEventQueue();
    if (watcher is AutoRefresh) await watcher.refreshSettled;
  }
  await pumpEventQueue();
}

/// "Create through the real form or cubit: the open list shows it."
///
/// * [open] is what the list screen does when it appears.
/// * [create] saves the record the way the form does and returns its id.
/// * [rows] are the ids the list shows in a state, null when it shows no list.
///
/// With [onTop] the new row must also be the first one. Returns its id.
Future<String> expectCreatedShowsInList<S>({
  required Cubit<S> list,
  required Future<void> Function() open,
  required Future<String?> Function() create,
  required List<String>? Function(S state) rows,
  bool onTop = true,
}) async {
  await open();
  await settle(list);
  final before = rows(list.state);
  expect(before, isNotNull, reason: 'the list did not load: ${list.state}');

  final seen = <S>[];
  final subscription = list.stream.listen(seen.add);
  final id = await create();
  expect(id, isNotNull, reason: 'the form did not save');
  await settle(list);
  await subscription.cancel();

  final after = rows(list.state);
  expect(after, isNotNull, reason: 'the list is gone: ${list.state}');
  expect(after, contains(id), reason: 'the new row is not in the list');
  if (onTop) expect(after!.first, id, reason: 'the new row is not on top');
  expect(after, containsAll(before!), reason: 'rows disappeared');
  for (final state in seen) {
    expect(rows(state), isNotNull, reason: 'the list blanked while updating');
  }
  return id!;
}

/// What a ledger screen shows: its row ids and the balance above them.
typedef LedgerView = ({List<String> rows, Decimal balance});

/// "Record a payment: the new row and the new balance show at once, together."
///
/// [balanceAfter] is what the balance card must read afterwards. Returns the
/// view after the payment.
Future<LedgerView> expectPaymentShowsAtOnce<S>({
  required Cubit<S> ledger,
  required Future<void> Function() open,
  required Future<void> Function() pay,
  required LedgerView? Function(S state) read,
  required Decimal balanceAfter,
}) async {
  await open();
  await settle(ledger);
  final before = read(ledger.state);
  expect(before, isNotNull, reason: 'the ledger did not load: ${ledger.state}');

  final seen = <S>[];
  final subscription = ledger.stream.listen(seen.add);
  await pay();
  await settle(ledger);
  await subscription.cancel();

  final after = read(ledger.state);
  expect(after, isNotNull, reason: 'the ledger is gone: ${ledger.state}');
  expect(
    after!.rows.length,
    before!.rows.length + 1,
    reason: 'rows before ${before.rows}, after ${after.rows}',
  );
  expect(after.rows, containsAll(before.rows));
  expect(after.balance, balanceAfter, reason: 'the balance did not move');
  // Rows and balance never disagree on the way.
  for (final state in seen) {
    final view = read(state);
    expect(view, isNotNull, reason: 'the ledger blanked while updating');
    final paid = view!.rows.length != before.rows.length;
    expect(
      view.balance,
      paid ? balanceAfter : before.balance,
      reason: 'rows ${view.rows} shown with balance ${view.balance}',
    );
  }
  return after;
}
