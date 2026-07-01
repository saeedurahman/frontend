import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/account_type_subtype_map.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_form_state.dart';

void main() {
  group('CoaFormState', () {
    test('isEdit is true when accountId is set', () {
      expect(const CoaFormState().isEdit, isFalse);
      expect(const CoaFormState(accountId: 'acc-1').isEdit, isTrue);
    });

    test('isReadOnly when canManage is false', () {
      expect(const CoaFormState(canManage: false).isReadOnly, isTrue);
      expect(const CoaFormState(canManage: true).isReadOnly, isFalse);
    });
  });

  group('Coa form subtype rules', () {
    test('changing type resets invalid subtype', () {
      const state = CoaFormState(
        accountType: AccountType.asset,
        accountSubtype: AccountSubtype.cash,
      );
      expect(
        isSubtypeValidForType(AccountType.expense, state.accountSubtype),
        isFalse,
      );
      expect(
        defaultSubtypeForType(AccountType.expense),
        AccountSubtype.cogs,
      );
    });
  });
}
