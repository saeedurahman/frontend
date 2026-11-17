import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/sync/sync_schema.dart';
import 'package:frantend/core/sync/sync_store.dart';

import '../sync/sync_rig.dart';

void main() {
  const device = 'a1b2c3d4-0000-4000-8000-000000000000';

  group('number format', () {
    test('short code + 4-digit counter', () {
      expect(OfflineWriter.receiptNumber(device, 42, shortCode: 'c1'), 'C1-0042');
      expect(OfflineWriter.receiptNumber(device, 1, shortCode: 'FRONT'), 'FRONT-0001');
    });

    test('the business prefix goes in front', () {
      expect(OfflineWriter.receiptNumber(device, 7, shortCode: 'C1', prefix: 'RX-'), 'RX-C1-0007');
    });

    test('the counter grows past four digits without cutting', () {
      expect(OfflineWriter.receiptNumber(device, 12345, shortCode: 'C1'), 'C1-12345');
    });

    test('before the device knows its code it uses the old hash-like prefix', () {
      expect(OfflineWriter.receiptNumber(device, 3), 'DA1B2-0003');
      expect(OfflineWriter.receiptNumber(device, 3, shortCode: '  '), 'DA1B2-0003');
    });
  });

  group('counter and migration', () {
    late SyncRig rig;
    setUp(() {
      rig = SyncRig();
      rig.seedServer();
    });
    tearDown(() => rig.dispose());

    Future<String> sellOne() async => (await rig.sell())['receipt_no']! as String;

    test('numbers count up one by one', () async {
      await rig.store.rememberNumbering(shortCode: 'C1');
      expect(await sellOne(), 'C1-0001');
      expect(await sellOne(), 'C1-0002');
      expect(await sellOne(), 'C1-0003');
    });

    test('old sales keep their number; new ones continue with the server code, no repeats', () async {
      final old1 = await sellOne();
      final old2 = await sellOne();
      expect(old1, startsWith('DA1B2-'));

      await rig.store.rememberNumbering(shortCode: 'C1');
      final fresh = await sellOne();

      expect(fresh, 'C1-0003');
      expect({old1, old2, fresh}, hasLength(3));
    });

    test('the counter survives an app restart', () async {
      await rig.store.rememberNumbering(shortCode: 'C1');
      await sellOne();
      await sellOne();
      rig.restart();
      expect(await sellOne(), 'C1-0003');
    });

    test('the counter survives a data wipe', () async {
      await rig.store.rememberNumbering(shortCode: 'C1');
      await sellOne();
      await sellOne();
      await SyncSchema.wipe(rig.db);
      await rig.store.rememberNumbering(shortCode: 'C1');
      expect(await sellOne(), 'C1-0003');
    });

    test('a code that comes back never repeats a number already used', () async {
      await rig.store.rememberNumbering(shortCode: 'C1');
      final a = await sellOne(); // C1-0001
      await rig.store.rememberNumbering(shortCode: 'C2');
      await sellOne(); // C2-0002
      // Owner changes the code back to C1: the counter is at 2, so C1-0003.
      await rig.store.rememberNumbering(shortCode: 'C1');
      final c = await sellOne();
      expect(c, isNot(a));
      expect(c, 'C1-0003');
    });

    test('the business prefix from the server is applied', () async {
      await rig.store.rememberNumbering(shortCode: 'C1', prefix: 'AB-');
      expect(await sellOne(), 'AB-C1-0001');
    });

    test('an empty code from the server never wipes the stored one', () async {
      await rig.store.rememberNumbering(shortCode: 'C1');
      await rig.store.rememberNumbering(shortCode: '');
      await rig.store.rememberNumbering(shortCode: null);
      expect(await rig.store.meta(SyncStore.deviceShortCodeKey), 'C1');
    });

    test('the number is sent to the server unchanged', () async {
      await rig.store.rememberNumbering(shortCode: 'C1');
      await sellOne();
      await rig.sync();
      final op = rig.server.receivedOps.firstWhere((o) => o['type'] == 'sale.create');
      expect((op['payload'] as Map)['client_receipt_no'], 'C1-0001');
    });
  });
}
