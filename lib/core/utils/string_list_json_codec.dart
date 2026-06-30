import 'dart:convert';

/// Encodes a string list for SQLite TEXT storage (Drift has no native list type).
String? encodeStringListJson(List<String> values) {
  if (values.isEmpty) return '[]';
  return jsonEncode(values);
}

/// Decodes a string list from SQLite TEXT storage.
///
/// Returns an empty list for null, empty, or malformed JSON.
List<String> decodeStringListJson(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.whereType<String>().toList();
  } catch (_) {
    return const [];
  }
}
