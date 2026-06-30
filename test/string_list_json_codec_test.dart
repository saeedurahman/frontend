import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/utils/string_list_json_codec.dart';

void main() {
  group('encodeStringListJson / decodeStringListJson', () {
    test('round-trips a non-empty list', () {
      const values = ['users.view', 'sales.returns.view', 'sales.cancel'];
      final encoded = encodeStringListJson(values);
      expect(encoded, isNotNull);
      expect(decodeStringListJson(encoded), values);
    });

    test('empty list encodes as [] and decodes to empty', () {
      expect(encodeStringListJson(const []), '[]');
      expect(decodeStringListJson('[]'), isEmpty);
    });

    test('null and empty raw decode to empty list', () {
      expect(decodeStringListJson(null), isEmpty);
      expect(decodeStringListJson(''), isEmpty);
      expect(decodeStringListJson('   '), isEmpty);
    });

    test('malformed JSON decodes to empty list', () {
      expect(decodeStringListJson('not-json'), isEmpty);
      expect(decodeStringListJson('{"a":1}'), isEmpty);
    });

    test('non-string list elements are filtered out', () {
      expect(decodeStringListJson('["ok", 1, "also"]'), ['ok', 'also']);
    });
  });
}
