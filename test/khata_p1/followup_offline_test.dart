// Promises, reminders and notes without internet: the real repository, the
// real outbox and the sync engine against the fake server.
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';

import '../sync/sync_rig.dart';

/// Nothing is reachable: any direct request would fail the test.
class _NoRemote extends Fake implements KhataRemoteDataSource {}

class _NoSettings extends Fake implements SettingsRemoteDataSource {}

void main() {
  late SyncRig rig;
  late KhataRepository repo;

  setUp(() async {
    rig = SyncRig()..seedServer();
    await rig.sync();
    repo = KhataRepository(
      remote: _NoRemote(),
      store: rig.store,
      writer: rig.writer,
      catalog: rig.catalog,
      settingsRemote: _NoSettings(),
      isReachable: () => false,
    );
    rig.server.offline = true;
  });

  tearDown(() => rig.dispose());

  Future<List<Followup>> timeline() =>
      repo.followups(PartyType.customer, 'c1');

  test('a promise saved offline shows at once and is sent later', () async {
    final result = await repo.addFollowup(
      PartyType.customer,
      'c1',
      kind: FollowupKind.promise,
      promiseDate: DateTime(2026, 12, 15),
      promiseAmount: '500.00',
      message: '  After salary  ',
    );
    expect(result.isRight(), isTrue);

    var rows = await timeline();
    expect(rows.single.pending, isTrue);
    expect(rows.single.promiseDate, DateTime(2026, 12, 15));
    expect(rows.single.message, 'After salary');
    final op = (await rig.store.ops(statuses: OutboxStatus.unfinished)).single;
    expect(op.type, OpTypes.followupCreate);

    // Still offline: it stays in the queue.
    await rig.sync();
    expect((await timeline()).single.pending, isTrue);

    rig.server.offline = false;
    await rig.sync();
    rows = await timeline();
    expect(rows, hasLength(1));
    expect(rows.single.pending, isFalse);
    final sent = rig.server.receivedOps.singleWhere(
      (o) => o['type'] == 'followup.create',
    );
    expect(
      sent['payload'],
      allOf(
        containsPair('party_type', 'customer'),
        containsPair('party_id', 'c1'),
        containsPair('kind', 'promise'),
        containsPair('promise_date', '2026-12-15'),
        containsPair('promise_amount', '500.00'),
      ),
    );
  });

  test('a reminder keeps its channel and text; sending twice books once',
      () async {
    await repo.addFollowup(
      PartyType.customer,
      'c1',
      kind: FollowupKind.reminder,
      channel: 'whatsapp',
      message: 'x' * 1500,
    );
    expect((await timeline()).single.message, hasLength(1000));
    rig.server.offline = false;
    await rig.sync();
    await rig.sync();
    final sent = rig.server.receivedOps.where(
      (o) => o['type'] == 'followup.create',
    );
    expect(sent, hasLength(1));
    expect((sent.single['payload'] as Map)['channel'], 'whatsapp');
    expect(await timeline(), hasLength(1));
  });

  test('the queue survives an app restart', () async {
    await repo.addFollowup(
      PartyType.customer,
      'c1',
      kind: FollowupKind.note,
      message: 'Came by',
    );
    rig.restart();
    repo = KhataRepository(
      remote: _NoRemote(),
      store: rig.store,
      writer: rig.writer,
      catalog: rig.catalog,
      settingsRemote: _NoSettings(),
      isReachable: () => false,
    );
    expect((await timeline()).single.pending, isTrue);
    rig.server.offline = false;
    await rig.sync();
    expect((await timeline()).single.pending, isFalse);
  });

  test('a refused one is marked, and discarding it removes it', () async {
    rig.server
      ..offline = false
      ..errors['followup.create'] =
          const OpError(code: 'permission_denied', message: 'Not allowed');
    await repo.addFollowup(
      PartyType.customer,
      'c1',
      kind: FollowupKind.note,
      message: 'No',
    );
    await rig.sync();
    final row = (await timeline()).single;
    expect(row.needsAttention, isTrue);
    final op = (await rig.store.ops(statuses: OutboxStatus.unfinished)).single;
    await rig.store.discardOp(op.opId, reason: 'test');
    expect(await timeline(), isEmpty);
  });

  test('a customer created offline is sent before its follow-up', () async {
    final customer = await rig.writer.createCustomer({'name': 'New Person'});
    await repo.addFollowup(
      PartyType.customer,
      '${customer['id']}',
      kind: FollowupKind.note,
      message: 'First visit',
    );
    rig.server.offline = false;
    await rig.sync();
    final types = [for (final o in rig.server.receivedOps) o['type']];
    expect(
      types.indexOf('customer.create'),
      lessThan(types.indexOf('followup.create')),
    );
    expect(
      (await repo.followups(PartyType.customer, '${customer['id']}'))
          .single
          .pending,
      isFalse,
    );
  });

  test('another party does not see it', () async {
    await repo.addFollowup(
      PartyType.supplier,
      'c1',
      kind: FollowupKind.note,
      message: 'Supplier note',
    );
    expect(await timeline(), isEmpty);
    expect(await repo.followups(PartyType.supplier, 'c1'), hasLength(1));
  });
}
