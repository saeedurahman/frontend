import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/account_type_subtype_map.dart';

void main() {
  group('account_type_subtype_map', () {
    test('asset includes cash and inventory subtypes', () {
      final subtypes = subtypesForAccountType(AccountType.asset);
      expect(subtypes, contains(AccountSubtype.cash));
      expect(subtypes, contains(AccountSubtype.inventory));
    });

    test('expense includes cogs', () {
      expect(
        subtypesForAccountType(AccountType.expense),
        contains(AccountSubtype.cogs),
      );
    });

    test('income includes sales_revenue', () {
      expect(
        subtypesForAccountType(AccountType.income),
        contains(AccountSubtype.salesRevenue),
      );
    });

    test('isSubtypeValidForType rejects invalid pairing', () {
      expect(
        isSubtypeValidForType(AccountType.asset, AccountSubtype.cogs),
        isFalse,
      );
      expect(
        isSubtypeValidForType(AccountType.expense, AccountSubtype.cogs),
        isTrue,
      );
    });

    test('defaultSubtypeForType returns first option', () {
      expect(
        defaultSubtypeForType(AccountType.liability),
        AccountSubtype.accountsPayable,
      );
    });
  });
}
