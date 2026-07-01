import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/domain/utils/coa_form_payload.dart';

void main() {
  group('buildUpdateCoaPayload', () {
    test('omits account_code for system accounts', () {
      final payload = buildUpdateCoaPayload(
        accountCode: '1000',
        accountName: 'Cash',
        accountType: 'asset',
        accountSubtype: 'cash',
        parentId: null,
        description: null,
        isActive: true,
        isSystem: true,
      );

      expect(payload.containsKey('account_code'), isFalse);
      expect(payload['account_name'], 'Cash');
    });

    test('includes account_code for non-system accounts', () {
      final payload = buildUpdateCoaPayload(
        accountCode: '7999',
        accountName: 'Custom',
        accountType: 'expense',
        accountSubtype: 'other',
        parentId: null,
        description: 'Test',
        isActive: false,
        isSystem: false,
      );

      expect(payload['account_code'], '7999');
      expect(payload['is_active'], isFalse);
    });
  });

  group('buildCreateCoaPayload', () {
    test('trims code and name', () {
      final payload = buildCreateCoaPayload(
        accountCode: ' 7100 ',
        accountName: '  Misc ',
        accountType: 'expense',
        accountSubtype: 'other',
        parentId: null,
        description: null,
        isActive: true,
      );

      expect(payload['account_code'], '7100');
      expect(payload['account_name'], 'Misc');
    });
  });
}
