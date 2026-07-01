import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';

ChartOfAccountModel _account({
  required String id,
  required String code,
  required String name,
  List<ChartOfAccountModel> children = const [],
}) =>
    ChartOfAccountModel(
      id: id,
      businessId: 'biz-1',
      accountCode: code,
      accountName: name,
      accountType: AccountType.asset,
      createdAt: '2026-01-01T00:00:00Z',
      updatedAt: '2026-01-01T00:00:00Z',
      children: children,
    );

void main() {
  group('coa_tree_utils', () {
    late List<ChartOfAccountModel> tree;

    setUp(() {
      tree = [
        _account(
          id: 'a1',
          code: '1000',
          name: 'Cash',
          children: [
            _account(id: 'a2', code: '1010', name: 'Petty Cash'),
          ],
        ),
        _account(id: 'a3', code: '2000', name: 'Payable'),
      ];
    });

    test('flattenCoaTree preserves depth-first order with depth', () {
      final flat = flattenCoaTree(tree);
      expect(flat.map((n) => n.account.id).toList(), ['a1', 'a2', 'a3']);
      expect(flat.map((n) => n.depth).toList(), [0, 1, 0]);
    });

    test('coaIndentLabel adds em-dash prefix by depth', () {
      expect(
        coaIndentLabel(accountCode: '1000', accountName: 'Cash', depth: 0),
        '1000 · Cash',
      );
      expect(
        coaIndentLabel(accountCode: '1010', accountName: 'Petty', depth: 2),
        '— — 1010 · Petty',
      );
    });

    test('descendantIds includes root and all children', () {
      final ids = descendantIds('a1', tree);
      expect(ids, {'a1', 'a2'});
    });

    test('coaParentPickerOptions excludes self and descendants', () {
      final options = coaParentPickerOptions(
        roots: tree,
        excludeIds: descendantIds('a1', tree),
      );
      expect(options.map((n) => n.account.id).toList(), ['a3']);
    });
  });
}
