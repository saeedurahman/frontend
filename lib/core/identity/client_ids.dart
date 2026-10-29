import 'package:frantend/core/identity/id_generator.dart';

/// Stamps request bodies with a client-generated id.
///
/// A record created from this device gets its UUID *before* it is sent, so a
/// retry (or, later, a queued replay by the sync engine) addresses the same
/// record instead of creating a duplicate. Bodies that already carry an `id`
/// (a retried sale) are left untouched.
abstract final class ClientIds {
  /// Replaceable in tests; production uses random UUIDv4s.
  static IdGenerator generator = UuidIdGenerator();

  static Map<String, dynamic> stamp(Map<String, dynamic> body) {
    if (body['id'] is String && (body['id'] as String).isNotEmpty) return body;
    return {...body, 'id': generator.newId()};
  }
}
