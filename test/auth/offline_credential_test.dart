import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';

String _hex(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

void main() {
  group('PBKDF2-HMAC-SHA256', () {
    final salt = Uint8List.fromList(utf8.encode('salt'));

    test('matches the published test vectors', () {
      expect(
        _hex(pbkdf2('password', salt, 1, 32)),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
      expect(
        _hex(pbkdf2('password', salt, 2, 32)),
        'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
      );
      expect(
        _hex(pbkdf2('password', salt, 4096, 32)),
        'c5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a',
      );
    });

    test('hash() (isolate) agrees with the direct computation', () async {
      final hasher = Pbkdf2CredentialHasher(iterations: 50);
      expect(
        await hasher.hash('pw', salt),
        base64Encode(pbkdf2('pw', salt, 50, 32)),
      );
    });

    test('salts are random and 16 bytes', () {
      final hasher = Pbkdf2CredentialHasher();
      final a = hasher.newSalt();
      final b = hasher.newSalt();
      expect(a, hasLength(16));
      expect(a, isNot(b));
    });

    test('defaults to a slow (>= 100k) iteration count', () {
      expect(Pbkdf2CredentialHasher().iterations, greaterThanOrEqualTo(100000));
    });

    test('constantTimeEquals', () {
      expect(constantTimeEquals('abc', 'abc'), isTrue);
      expect(constantTimeEquals('abc', 'abd'), isFalse);
      expect(constantTimeEquals('abc', 'abcd'), isFalse);
    });
  });

  group('OfflineCredentialVerifier', () {
    late InMemorySecureKeyStore store;
    late OfflineCredentialVerifier verifier;

    setUp(() {
      store = InMemorySecureKeyStore();
      verifier = OfflineCredentialVerifier(
        store: store,
        hasher: Pbkdf2CredentialHasher(iterations: 200),
      );
    });

    Future<void> enroll({
      String secret = 'Secret#1',
      OfflineCredentialKind kind = OfflineCredentialKind.password,
      String tenant = 'acme',
      String identity = '+923001234567',
      String userId = 'u1',
    }) =>
        verifier.enroll(
          kind: kind,
          tenantKey: tenant,
          identity: identity,
          userId: userId,
          secret: secret,
        );

    Future<OfflineVerifyResult> verify(
      String secret, {
      String? tenant = 'acme',
      OfflineCredentialKind kind = OfflineCredentialKind.password,
      String identity = '+923001234567',
    }) =>
        verifier.verify(
          kind: kind,
          identity: identity,
          tenantKey: tenant,
          secret: secret,
        );

    test('a user never seen online is not enrolled', () async {
      expect(await verify('anything'), isA<OfflineNotEnrolled>());
    });

    test('verifies the password used at the last online login', () async {
      await enroll();
      final result = await verify('Secret#1');
      expect(result, isA<OfflineVerified>());
      expect((result as OfflineVerified).userId, 'u1');
    });

    test('a wrong password is refused and counts down the attempts', () async {
      await enroll();
      final r = await verify('nope');
      expect(r, isA<OfflineWrongSecret>());
      expect((r as OfflineWrongSecret).attemptsLeft, 4);
      expect((await verify('nope') as OfflineWrongSecret).attemptsLeft, 3);
    });

    test('locks out after 5 failures, even for the right password', () async {
      await enroll();
      for (var i = 0; i < 4; i++) {
        expect(await verify('bad$i'), isA<OfflineWrongSecret>());
      }
      expect(await verify('bad4'), isA<OfflineLockedOut>());
      expect(await verify('Secret#1'), isA<OfflineLockedOut>());
    });

    test('the lockout survives a restart (it is persisted)', () async {
      await enroll();
      for (var i = 0; i < 5; i++) {
        await verify('bad$i');
      }
      final restarted = OfflineCredentialVerifier(
        store: store,
        hasher: Pbkdf2CredentialHasher(iterations: 200),
      );
      expect(
        await restarted.verify(
          kind: OfflineCredentialKind.password,
          identity: '+923001234567',
          tenantKey: 'acme',
          secret: 'Secret#1',
        ),
        isA<OfflineLockedOut>(),
      );
    });

    test('only an online login (re-enroll) clears the lockout', () async {
      await enroll();
      for (var i = 0; i < 5; i++) {
        await verify('bad$i');
      }
      await enroll(secret: 'NewSecret#2');
      expect(await verify('NewSecret#2'), isA<OfflineVerified>());
      expect(await verify('Secret#1'), isA<OfflineWrongSecret>());
    });

    test('a correct login resets the failure counter', () async {
      await enroll();
      await verify('bad');
      await verify('bad');
      expect(await verify('Secret#1'), isA<OfflineVerified>());
      expect((await verify('bad') as OfflineWrongSecret).attemptsLeft, 4);
    });

    test('wipe() removes every verifier (logout / tenant switch)', () async {
      await enroll();
      await enroll(kind: OfflineCredentialKind.pin, secret: '1234', identity: 'u1');
      await verifier.wipe();
      expect(await verify('Secret#1'), isA<OfflineNotEnrolled>());
      expect(
        await verify('1234',
            kind: OfflineCredentialKind.pin, identity: 'u1'),
        isA<OfflineNotEnrolled>(),
      );
      expect(store.values.containsKey(OfflineCredentialVerifier.storageKey),
          isFalse);
    });

    test('nothing reversible is stored: no plaintext, salted hash only',
        () async {
      await enroll(secret: 'Hunter2-unique-marker');
      final raw = store.values[OfflineCredentialVerifier.storageKey]!;
      expect(raw.contains('Hunter2-unique-marker'), isFalse);
      final record = (jsonDecode(raw) as Map).values.single as Map;
      expect(record.keys, containsAll(['salt', 'hash', 'iterations']));
    });

    test('the same password gets a different salt/hash each enrollment',
        () async {
      await enroll();
      final first = store.values[OfflineCredentialVerifier.storageKey];
      await enroll();
      expect(store.values[OfflineCredentialVerifier.storageKey], isNot(first));
    });

    test('password and PIN verifiers are independent', () async {
      await enroll(secret: '1234');
      expect(
        await verify('1234', kind: OfflineCredentialKind.pin),
        isA<OfflineNotEnrolled>(),
      );
    });

    test('another tenant or phone does not match', () async {
      await enroll();
      expect(await verify('Secret#1', tenant: 'other'),
          isA<OfflineNotEnrolled>());
      expect(await verify('Secret#1', identity: '+920000000000'),
          isA<OfflineNotEnrolled>());
    });

    test('tenant is optional when exactly one business matches the phone',
        () async {
      await enroll();
      expect(await verify('Secret#1', tenant: null), isA<OfflineVerified>());
    });

    test('an ambiguous phone without a tenant is refused', () async {
      await enroll(tenant: 'acme');
      await enroll(tenant: 'globex', userId: 'u2');
      expect(await verify('Secret#1', tenant: null), isA<OfflineNotEnrolled>());
      expect(await verify('Secret#1', tenant: 'globex'), isA<OfflineVerified>());
    });

    test('a corrupt store is treated as not enrolled, not a crash', () async {
      store.values[OfflineCredentialVerifier.storageKey] = '{not json';
      expect(await verify('x'), isA<OfflineNotEnrolled>());
    });
  });
}
