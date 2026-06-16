import 'package:injectable/injectable.dart';

/// Last-write-wins conflict resolution strategy.
@lazySingleton
class ConflictResolver {
  Map<String, dynamic> resolve({
    required Map<String, dynamic> local,
    required Map<String, dynamic> remote,
  }) {
    final localUpdatedAt = _parseDate(local['updated_at']);
    final remoteUpdatedAt = _parseDate(remote['updated_at']);

    if (localUpdatedAt == null && remoteUpdatedAt == null) return remote;
    if (localUpdatedAt == null) return remote;
    if (remoteUpdatedAt == null) return local;

    return localUpdatedAt.isAfter(remoteUpdatedAt) ? local : remote;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
