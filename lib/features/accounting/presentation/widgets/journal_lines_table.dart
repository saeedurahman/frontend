import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/accounting/data/models/journal_line_model.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';

class JournalLinesTable extends StatelessWidget {
  const JournalLinesTable({
    super.key,
    required this.lines,
    this.totalDebit,
    this.totalCredit,
  });

  final List<JournalLineModel> lines;
  final String? totalDebit;
  final String? totalCredit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const _HeaderRow(),
              ...lines.asMap().entries.map(
                (entry) => _DataRow(
                  index: entry.key + 1,
                  line: entry.value,
                ),
              ),
            ],
          ),
        ),
        if (totalDebit != null && totalCredit != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total debits: ${formatPKR(double.tryParse(totalDebit!) ?? 0)}',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(width: 16),
              Text(
                'Total credits: ${formatPKR(double.tryParse(totalCredit!) ?? 0)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class JournalLinesTableFromDrafts extends StatelessWidget {
  const JournalLinesTableFromDrafts({
    super.key,
    required this.lines,
    required this.accountLabels,
  });

  final List<JournalLineDraft> lines;
  final Map<String, String> accountLabels;

  @override
  Widget build(BuildContext context) {
    final summary = computeJournalBalance(lines);
    final validLines = lines.where((l) => l.accountId != null && l.hasPositiveAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const _HeaderRow(),
              ...validLines.map(
                (line) {
                  final amount = double.tryParse(line.amount.trim()) ?? 0;
                  final isDebit = line.side == JournalLineSide.debit;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            accountLabels[line.accountId] ?? line.accountId ?? '—',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isDebit ? formatPKR(amount) : '—',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            !isDebit ? formatPKR(amount) : '—',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Total debits: ${formatPKR(double.tryParse(DecimalUtils.format(summary.totalDebit)) ?? 0)}',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(width: 16),
            Text(
              'Total credits: ${formatPKR(double.tryParse(DecimalUtils.format(summary.totalCredit)) ?? 0)}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Account', style: AppTextStyles.labelLarge),
          ),
          Expanded(
            child: Text('Debit', textAlign: TextAlign.right, style: AppTextStyles.labelLarge),
          ),
          Expanded(
            child: Text('Credit', textAlign: TextAlign.right, style: AppTextStyles.labelLarge),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.index, required this.line});

  final int index;
  final JournalLineModel line;

  @override
  Widget build(BuildContext context) {
    final debit = double.tryParse(line.debitAmount) ?? 0;
    final credit = double.tryParse(line.creditAmount) ?? 0;

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${line.accountCode} · ${line.accountName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (line.description != null && line.description!.isNotEmpty)
                  Text(
                    line.description!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              debit > 0 ? formatPKR(debit) : '—',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              credit > 0 ? formatPKR(credit) : '—',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
