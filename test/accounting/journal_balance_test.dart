import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';

void main() {
  group('journal_balance', () {
    test('empty lines yield zero totals and cannot post', () {
      final summary = computeJournalBalance(const []);
      expect(summary.totalDebit, Decimal.zero);
      expect(summary.totalCredit, Decimal.zero);
      expect(summary.isBalanced, isFalse);
      expect(summary.meetsMinLinesForPost, isFalse);
      expect(summary.canPost, isFalse);
    });

    test('single line is not balanced and cannot post', () {
      final summary = computeJournalBalance([
        const JournalLineDraft(
          accountId: 'a1',
          side: JournalLineSide.debit,
          amount: '100',
        ),
      ]);
      expect(summary.linesWithAmount, 1);
      expect(summary.isBalanced, isFalse);
      expect(summary.meetsMinLinesForPost, isFalse);
      expect(summary.canPost, isFalse);
    });

    test('balanced multi-line entry can post', () {
      final summary = computeJournalBalance([
        const JournalLineDraft(
          accountId: 'a1',
          side: JournalLineSide.debit,
          amount: '500',
        ),
        const JournalLineDraft(
          accountId: 'a2',
          side: JournalLineSide.credit,
          amount: '500',
        ),
      ]);
      expect(summary.totalDebit, Decimal.parse('500'));
      expect(summary.totalCredit, Decimal.parse('500'));
      expect(summary.difference, Decimal.zero);
      expect(summary.isBalanced, isTrue);
      expect(summary.meetsMinLinesForPost, isTrue);
      expect(summary.canPost, isTrue);
    });

    test('unbalanced entry reports positive difference', () {
      final summary = computeJournalBalance([
        const JournalLineDraft(
          accountId: 'a1',
          side: JournalLineSide.debit,
          amount: '1500',
        ),
        const JournalLineDraft(
          accountId: 'a2',
          side: JournalLineSide.credit,
          amount: '1200',
        ),
      ]);
      expect(summary.isBalanced, isFalse);
      expect(summary.difference, Decimal.parse('300'));
      expect(summary.canPost, isFalse);
    });

    test('journalLineDraftToJson maps debit side only', () {
      final json = journalLineDraftToJson(
        const JournalLineDraft(
          accountId: 'acc-1',
          side: JournalLineSide.debit,
          amount: '250.50',
          lineOrder: 1,
        ),
      );
      expect(json['account_id'], 'acc-1');
      expect(json['debit_amount'], '250.50');
      expect(json['credit_amount'], '0');
      expect(json['line_order'], 1);
    });

    test('journalLineDraftToJson maps credit side only', () {
      final json = journalLineDraftToJson(
        const JournalLineDraft(
          accountId: 'acc-2',
          side: JournalLineSide.credit,
          amount: '100',
        ),
      );
      expect(json['debit_amount'], '0');
      expect(json['credit_amount'], '100.00');
    });
  });
}
