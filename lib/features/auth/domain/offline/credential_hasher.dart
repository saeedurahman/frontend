import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// One-way, salted, deliberately slow hashing of a secret (password / PIN).
abstract class CredentialHasher {
  /// Iteration count recorded next to every hash so it can be raised later.
  int get iterations;

  Uint8List newSalt();

  /// Base64 of the derived key.
  Future<String> hash(String secret, Uint8List salt, {int? iterations});
}

/// PBKDF2-HMAC-SHA256, computed in a short-lived isolate so the UI thread
/// never stalls on the ~100k iterations.
class Pbkdf2CredentialHasher implements CredentialHasher {
  Pbkdf2CredentialHasher({
    this.iterations = defaultIterations,
    this.keyLength = 32,
    Random? random,
  }) : _random = random ?? Random.secure();

  static const defaultIterations = 100000;

  @override
  final int iterations;
  final int keyLength;
  final Random _random;

  @override
  Uint8List newSalt() =>
      Uint8List.fromList(List<int>.generate(16, (_) => _random.nextInt(256)));

  @override
  Future<String> hash(String secret, Uint8List salt, {int? iterations}) {
    final rounds = iterations ?? this.iterations;
    final length = keyLength;
    return Isolate.run(() => base64Encode(pbkdf2(secret, salt, rounds, length)));
  }
}

/// PBKDF2 (RFC 8018) with HMAC-SHA256. Top-level so it can run in an isolate.
Uint8List pbkdf2(String secret, Uint8List salt, int iterations, int length) {
  final hmac = Hmac(sha256, utf8.encode(secret));
  const hashLen = 32;
  final blocks = (length / hashLen).ceil();
  final out = BytesBuilder();
  for (var block = 1; block <= blocks; block++) {
    final input = Uint8List(salt.length + 4)
      ..setRange(0, salt.length, salt)
      ..buffer.asByteData().setUint32(salt.length, block);
    var u = Uint8List.fromList(hmac.convert(input).bytes);
    final t = Uint8List.fromList(u);
    for (var i = 1; i < iterations; i++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (var j = 0; j < t.length; j++) {
        t[j] ^= u[j];
      }
    }
    out.add(t);
  }
  return Uint8List.fromList(out.toBytes().sublist(0, length));
}

/// Compares in time independent of where the first difference is.
bool constantTimeEquals(String a, String b) {
  final x = utf8.encode(a);
  final y = utf8.encode(b);
  var diff = x.length ^ y.length;
  for (var i = 0; i < x.length && i < y.length; i++) {
    diff |= x[i] ^ y[i];
  }
  return diff == 0;
}
