import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/accounting/data/models/journal_line_model.dart';

enum JournalLineSide { debit, credit }

/// Draft journal line for form state and client-side balance checks.
class JournalLineDraft {
  const JournalLineDraft({
    this.accountId,
    this.side = JournalLineSide.debit,
    this.amount = '',
    this.description,
    this.lineOrder = 0,
  });

  final String? accountId;
  final JournalLineSide side;
  final String amount;
  final String? description;
  final int lineOrder;

  JournalLineDraft copyWith({
    String? accountId,
    JournalLineSide? side,
    String? amount,
    String? description,
    int? lineOrder,
  }) =>
      JournalLineDraft(
        accountId: accountId ?? this.accountId,
        side: side ?? this.side,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        lineOrder: lineOrder ?? this.lineOrder,
      );

  bool get hasPositiveAmount {
    final parsed = Decimal.tryParse(amount.trim());
    return parsed != null && parsed > Decimal.zero;
  }
}

class JournalBalanceSummary {
  const JournalBalanceSummary({
    required this.totalDebit,
    required this.totalCredit,
    required this.difference,
    required this.lineCount,
    required this.linesWithAmount,
    required this.isBalanced,
    required this.meetsMinLinesForPost,
    required this.canPost,
  });

  final Decimal totalDebit;
  final Decimal totalCredit;
  final Decimal difference;
  final int lineCount;
  final int linesWithAmount;
  final bool isBalanced;
  final bool meetsMinLinesForPost;
  final bool canPost;
}

JournalBalanceSummary computeJournalBalance(List<JournalLineDraft> lines) {
  var totalDebit = Decimal.zero;
  var totalCredit = Decimal.zero;
  var linesWithAmount = 0;

  for (final line in lines) {
    final parsed = Decimal.tryParse(line.amount.trim());
    if (parsed == null || parsed <= Decimal.zero) continue;
    linesWithAmount++;
    final rounded = DecimalUtils.roundMoney(parsed);
    if (line.side == JournalLineSide.debit) {
      totalDebit += rounded;
    } else {
      totalCredit += rounded;
    }
  }

  totalDebit = DecimalUtils.roundMoney(totalDebit);
  totalCredit = DecimalUtils.roundMoney(totalCredit);
  final difference = DecimalUtils.roundMoney((totalDebit - totalCredit).abs());
  final isBalanced = totalDebit == totalCredit && linesWithAmount > 0;
  final meetsMinLinesForPost = linesWithAmount >= 2;

  return JournalBalanceSummary(
    totalDebit: totalDebit,
    totalCredit: totalCredit,
    difference: difference,
    lineCount: lines.length,
    linesWithAmount: linesWithAmount,
    isBalanced: isBalanced,
    meetsMinLinesForPost: meetsMinLinesForPost,
    canPost: isBalanced && meetsMinLinesForPost,
  );
}

JournalBalanceSummary computeJournalBalanceFromResponseLines(
  List<JournalLineModel> lines,
) {
  final drafts = lines.map((line) {
    final debit = Decimal.tryParse(line.debitAmount.trim()) ?? Decimal.zero;
    final isDebit = debit > Decimal.zero;
    return JournalLineDraft(
      accountId: line.accountId,
      side: isDebit ? JournalLineSide.debit : JournalLineSide.credit,
      amount: isDebit ? line.debitAmount : line.creditAmount,
      description: line.description,
      lineOrder: line.lineOrder,
    );
  }).toList();
  return computeJournalBalance(drafts);
}

/// Maps a draft line to API journal line input JSON.
Map<String, dynamic> journalLineDraftToJson(JournalLineDraft line) {
  final parsed = Decimal.tryParse(line.amount.trim()) ?? Decimal.zero;
  final amount = DecimalUtils.format(DecimalUtils.roundMoney(parsed));
  return {
    if (line.accountId != null) 'account_id': line.accountId,
    'debit_amount': line.side == JournalLineSide.debit ? amount : '0',
    'credit_amount': line.side == JournalLineSide.credit ? amount : '0',
    if (line.description != null && line.description!.trim().isNotEmpty)
      'description': line.description!.trim(),
    'line_order': line.lineOrder,
  };
}
