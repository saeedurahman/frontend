import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

/// The numbers sent with `credit_limit_exceeded`. [balance] and [wouldBe] use
/// the ledger sign: negative means the customer owes.
class CreditNumbers extends Equatable {
  const CreditNumbers({
    required this.limit,
    required this.balance,
    required this.wouldBe,
  });

  final Decimal limit;
  final Decimal balance;
  final Decimal wouldBe;

  @override
  List<Object?> get props => [limit, balance, wouldBe];
}

/// Turns FastAPI error bodies into readable messages.
///
/// FastAPI returns 422 as `{"detail": [{"loc": ["body", "phone"], "msg": ...}]}`
/// and other errors as `{"detail": "text"}`.
abstract final class ApiErrorParser {
  static const _ignoredLocPrefixes = {'body', 'query', 'path', 'header'};

  /// Field path -> message for a 422 `detail` list. Empty when [detail] is not
  /// a validation list.
  static Map<String, String> fieldErrors(dynamic detail) {
    if (detail is! List) return const {};
    final result = <String, String>{};
    for (final item in detail) {
      if (item is! Map) continue;
      final msg = item['msg']?.toString();
      if (msg == null || msg.isEmpty) continue;
      final key = _fieldKey(item['loc']);
      // Keep the first message per field.
      result.putIfAbsent(key.isEmpty ? '_general' : key, () => _clean(msg));
    }
    return result;
  }

  /// Human-readable text for the whole body.
  static String message(dynamic data, {String fallback = 'Server error occurred'}) {
    if (data is Map) {
      final detail = data['detail'];
      final fields = fieldErrors(detail);
      if (fields.isNotEmpty) return describeFields(fields);
      if (detail is String && detail.isNotEmpty) return detail;
      if (detail is Map) {
        final text = detail['message'];
        if (text is String && text.isNotEmpty) return text;
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return fallback;
  }

  /// The machine code of a `detail: {"code": ..., "message": ...}` body.
  static String? code(dynamic data) {
    if (data is! Map) return null;
    final detail = data['detail'];
    if (detail is Map) {
      final code = detail['code'];
      if (code is String && code.isNotEmpty) return code;
    }
    return null;
  }

  /// `limit`, `balance` and `would_be` of a credit-limit refusal; null unless
  /// all three are there.
  static CreditNumbers? creditNumbers(dynamic data) {
    if (data is! Map) return null;
    final detail = data['detail'];
    if (detail is! Map) return null;
    final limit = Decimal.tryParse('${detail['limit']}');
    final balance = Decimal.tryParse('${detail['balance']}');
    final wouldBe = Decimal.tryParse('${detail['would_be']}');
    if (limit == null || balance == null || wouldBe == null) return null;
    return CreditNumbers(limit: limit, balance: balance, wouldBe: wouldBe);
  }

  /// One line per field: `Phone: field required`.
  static String describeFields(Map<String, String> fields) {
    return fields.entries.map((e) {
      if (e.key == '_general') return e.value;
      return '${label(e.key)}: ${e.value}';
    }).join('\n');
  }

  /// `lines.0.qty` -> `Lines #1 › Qty`; `owner_phone` -> `Owner phone`.
  static String label(String key) {
    final parts = key.split('.').map((part) {
      final index = int.tryParse(part);
      if (index != null) return '#${index + 1}';
      final spaced = part.replaceAll('_', ' ').trim();
      if (spaced.isEmpty) return spaced;
      return spaced[0].toUpperCase() + spaced.substring(1);
    });
    return parts.join(' › ');
  }

  static String _fieldKey(dynamic loc) {
    if (loc is! List) return '';
    final parts = <String>[];
    for (var i = 0; i < loc.length; i++) {
      final segment = loc[i].toString();
      if (i == 0 && _ignoredLocPrefixes.contains(segment)) continue;
      parts.add(segment);
    }
    return parts.join('.');
  }

  static String _clean(String msg) {
    var text = msg.trim();
    // Pydantic prefixes custom validator errors with "Value error, ".
    const prefix = 'Value error, ';
    if (text.startsWith(prefix)) text = text.substring(prefix.length);
    return text;
  }
}
