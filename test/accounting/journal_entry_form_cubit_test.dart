import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';
import 'package:frantend/features/accounting/data/models/journal_line_model.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';
import 'package:frantend/features/accounting/domain/utils/journal_entry_payload.dart';
import 'package:frantend/features/accounting/presentation/widgets/post_journal_entry_dialog.dart';

JournalEntryModel _sampleEntry() => JournalEntryModel(
      id: 'entry-1',
      businessId: 'biz-1',
      entryNumber: 'JE-00001',
      status: JournalEntryStatus.draft,
      entryDate: '2026-06-30',
      description: 'Test entry',
      lines: const [
        JournalLineModel(
          id: 'line-1',
          accountId: 'acc-1',
          accountCode: '1000',
          accountName: 'Cash',
          debitAmount: '500.00',
          creditAmount: '0',
        ),
        JournalLineModel(
          id: 'line-2',
          accountId: 'acc-2',
          accountCode: '4000',
          accountName: 'Sales Revenue',
          debitAmount: '0',
          creditAmount: '500.00',
        ),
      ],
      totalDebit: '500.00',
      totalCredit: '500.00',
      createdAt: '2026-06-30T00:00:00Z',
      updatedAt: '2026-06-30T00:00:00Z',
    );

void main() {
  group('journal_entry_payload', () {
    test('journalLinesForApi maps debit XOR credit', () {
      final json = journalLinesForApi([
        const JournalLineDraft(
          accountId: 'a1',
          side: JournalLineSide.debit,
          amount: '100',
        ),
      ]).single;

      expect(json['debit_amount'], '100.00');
      expect(json['credit_amount'], '0');
    });

    test('validateJournalLineDrafts requires paired account and amount', () {
      final errors = validateJournalLineDrafts([
        const JournalLineDraft(accountId: 'a1'),
        const JournalLineDraft(amount: '50'),
      ]);
      expect(errors.containsKey('line_0'), isTrue);
      expect(errors.containsKey('line_1'), isTrue);
      expect(errors['lines'], isNotNull);
    });

    test('validateJournalLineDrafts passes balanced lines', () {
      final errors = validateJournalLineDrafts([
        const JournalLineDraft(
          accountId: 'a1',
          side: JournalLineSide.debit,
          amount: '100',
        ),
        const JournalLineDraft(
          accountId: 'a2',
          side: JournalLineSide.credit,
          amount: '100',
        ),
      ]);
      expect(errors, isEmpty);
    });
  });

  group('PostJournalEntryDialog', () {
    testWidgets('post disabled without checkbox', (tester) async {
      final entry = _sampleEntry();
      final balance = computeJournalBalanceFromResponseLines(entry.lines);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostJournalEntryDialog(
              entry: entry,
              balanceSummary: balance,
            ),
          ),
        ),
      );

      final postButton = find.widgetWithText(FilledButton, 'Post entry');
      expect(tester.widget<FilledButton>(postButton).onPressed, isNull);

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      expect(tester.widget<FilledButton>(postButton).onPressed, isNotNull);
    });

    testWidgets('post disabled when unbalanced', (tester) async {
      final entry = _sampleEntry().copyWith(
        lines: [
          const JournalLineModel(
            id: 'line-1',
            accountId: 'acc-1',
            accountCode: '1000',
            accountName: 'Cash',
            debitAmount: '500.00',
            creditAmount: '0',
          ),
        ],
        totalDebit: '500.00',
        totalCredit: '0',
      );
      final balance = computeJournalBalanceFromResponseLines(entry.lines);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostJournalEntryDialog(
              entry: entry,
              balanceSummary: balance,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      final postButton = find.widgetWithText(FilledButton, 'Post entry');
      expect(tester.widget<FilledButton>(postButton).onPressed, isNull);
    });
  });
}
