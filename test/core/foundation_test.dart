import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/identity/client_ids.dart';
import 'package:frantend/core/identity/device_identity.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/platform/barcode_scanner_service.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/secure_key_store.dart';

void main() {
  group('AppBrand', () {
    tearDown(AppBrand.reset);

    test('defaults to PakPOS for the desktop build', () {
      expect(AppBrand.current.appName, 'PakPOS');
      expect(AppBrand.current.shortName, 'PakPOS');
      expect(AppBrand.current.supportLabel, 'PakPOS Support');
    });

    test('is switchable to Pak Khata', () {
      AppBrand.use(AppBrand.pakKhata);
      expect(AppBrand.current.appName, 'Pak Khata');
      expect(AppBrand.current.receiptPoweredBy, 'Powered by Pak Khata');
    });

    test('fromKey is case-insensitive and falls back to PakPOS', () {
      expect(AppBrand.fromKey('PakKhata'), AppBrand.pakKhata);
      expect(AppBrand.fromKey('nonsense'), AppBrand.pakPos);
      expect(AppBrand.fromKey(null), AppBrand.pakPos);
    });

    test('package / exe names are placeholders per brand', () {
      expect(AppBrand.pakPos.executableName, 'pakpos');
      expect(AppBrand.pakKhata.executableName, 'pakkhata');
      expect(AppBrand.pakPos.packageName, isNot(AppBrand.pakKhata.packageName));
    });

    test('no source file still hard-codes the old product name', () {
      final offenders = <String>[];
      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        if (entity.path.endsWith('.g.dart') ||
            entity.path.endsWith('.freezed.dart')) {
          continue;
        }
        // The SQLite file name is on-disk compatibility, not branding;
        // renaming it would orphan every existing install's local data.
        final text = entity.readAsStringSync().replaceAll('frantend_pos.db', '');
        if (RegExp('Frantend', caseSensitive: false)
            .allMatches(text.replaceAll('package:frantend', ''))
            .isNotEmpty) {
          offenders.add(entity.path);
        }
      }
      expect(offenders, isEmpty);
    });
  });

  group('IdGenerator', () {
    test('produces unique, well-formed UUIDv4 values', () {
      final ids = UuidIdGenerator();
      final seen = <String>{};
      for (var i = 0; i < 500; i++) {
        final id = ids.newId();
        expect(isUuidV4(id), isTrue, reason: id);
        seen.add(id);
      }
      expect(seen, hasLength(500));
    });

    test('every named factory mints a fresh id', () {
      final ids = UuidIdGenerator();
      final all = {
        ids.saleId(),
        ids.paymentId(),
        ids.customerId(),
        ids.expenseId(),
        ids.shiftId(),
        ids.returnId(),
        ids.opId(),
      };
      expect(all, hasLength(7));
    });

    test('isUuidV4 rejects other shapes', () {
      expect(isUuidV4('not-a-uuid'), isFalse);
      expect(isUuidV4('123e4567-e89b-12d3-a456-426614174000'), isFalse); // v1
    });
  });

  group('ClientIds.stamp', () {
    test('adds a UUID id and leaves the input untouched', () {
      final body = {'name': 'Ali'};
      final stamped = ClientIds.stamp(body);
      expect(isUuidV4(stamped['id'] as String), isTrue);
      expect(body.containsKey('id'), isFalse);
      expect(stamped['name'], 'Ali');
    });

    test('keeps an id that is already there (a retried sale)', () {
      final stamped = ClientIds.stamp({'id': 'abc', 'x': 1});
      expect(stamped['id'], 'abc');
    });
  });

  group('DeviceIdentity', () {
    test('device id is created once and survives a restart', () async {
      final store = InMemorySecureKeyStore();
      final first = DeviceIdentity(store: store, ids: UuidIdGenerator());
      final id = await first.deviceId();
      expect(isUuidV4(id), isTrue);
      expect(await first.deviceId(), id);

      // New instance == app restart: same secure store, same id.
      final second = DeviceIdentity(store: store, ids: UuidIdGenerator());
      expect(await second.deviceId(), id);
    });

    test('concurrent first calls do not mint two ids', () async {
      final identity = DeviceIdentity(
        store: InMemorySecureKeyStore(),
        ids: UuidIdGenerator(),
      );
      final ids = await Future.wait([
        identity.deviceId(),
        identity.deviceId(),
        identity.deviceId(),
      ]);
      expect(ids.toSet(), hasLength(1));
    });

    test('a corrupt stored id is replaced', () async {
      final store = InMemorySecureKeyStore()
        ..values[DeviceIdentity.deviceIdKey] = 'garbage';
      final id = await DeviceIdentity(store: store, ids: UuidIdGenerator())
          .deviceId();
      expect(isUuidV4(id), isTrue);
      expect(store.values[DeviceIdentity.deviceIdKey], id);
    });

    test('device name defaults to the host and can be overridden', () async {
      final identity = DeviceIdentity(
        store: InMemorySecureKeyStore(),
        ids: UuidIdGenerator(),
        hostName: () => 'FRONT-PC',
      );
      expect(await identity.deviceName(), 'FRONT-PC');
      await identity.setDeviceName('  Counter 2 ');
      expect(await identity.deviceName(), 'Counter 2');
    });
  });

  group('WedgeDecoder (keyboard-wedge barcode scanner)', () {
    Duration ms(int v) => Duration(milliseconds: v);

    String? scan(WedgeDecoder d, String code, {int gap = 10, int start = 0}) {
      var t = start;
      for (final c in code.split('')) {
        d.addChar(c, ms(t));
        t += gap;
      }
      return d.submit(ms(t));
    }

    test('fast burst + Enter is a scan', () {
      expect(scan(WedgeDecoder(), '8964000123456'), '8964000123456');
    });

    test('human-speed typing is not a scan', () {
      expect(scan(WedgeDecoder(), '8964000123456', gap: 300), isNull);
    });

    test('too-short bursts are ignored', () {
      expect(scan(WedgeDecoder(), '12'), isNull);
    });

    test('a slow prefix is discarded, the fast tail still scans', () {
      final d = WedgeDecoder();
      d.addChar('x', ms(0));
      d.addChar('y', ms(500)); // human pause restarts the burst
      final code = scan(d, '12345', start: 510);
      expect(code, 'y12345');
    });
  });

  group('FileSaver', () {
    test('file names cannot escape the folder or hold forbidden characters', () {
      expect(
        WindowsFileSaverService.sanitizeFileName(r'..\..\evil:name?.pdf'),
        '.._.._evil_name_.pdf',
      );
      expect(WindowsFileSaverService.sanitizeFileName('  '), 'file');
      expect(
        WindowsFileSaverService.sanitizeFileName('receipt_INV-1.pdf'),
        'receipt_INV-1.pdf',
      );
    });
  });
}
