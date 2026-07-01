import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';
import 'package:frantend/features/accounting/presentation/widgets/journal_lines_table.dart';

class PostJournalEntryDialog extends StatefulWidget {
  const PostJournalEntryDialog({
    super.key,
    required this.entry,
    required this.balanceSummary,
  });

  final JournalEntryModel entry;
  final JournalBalanceSummary balanceSummary;

  static Future<bool?> show(
    BuildContext context, {
    required JournalEntryModel entry,
    required JournalBalanceSummary balanceSummary,
  }) =>
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => PostJournalEntryDialog(
          entry: entry,
          balanceSummary: balanceSummary,
        ),
      );

  @override
  State<PostJournalEntryDialog> createState() => _PostJournalEntryDialogState();
}

class _PostJournalEntryDialogState extends State<PostJournalEntryDialog> {
  var _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final canPost = widget.balanceSummary.canPost && _confirmed;
    final entryDate = DateTime.tryParse(widget.entry.entryDate);

    return AlertDialog(
      title: Text('Post ${widget.entry.entryNumber}?'),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: const Text(
                  'Posted journal entries are permanent and cannot be edited or deleted.',
                  style: TextStyle(height: 1.4, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                entryDate != null
                    ? DateFormatter.formatDate(entryDate)
                    : widget.entry.entryDate,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (widget.entry.description != null &&
                  widget.entry.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(widget.entry.description!, style: AppTextStyles.bodyMedium),
              ],
              const SizedBox(height: 16),
              JournalLinesTable(
                lines: widget.entry.lines,
                totalDebit: widget.entry.totalDebit,
                totalCredit: widget.entry.totalCredit,
              ),
              if (!widget.balanceSummary.canPost) ...[
                const SizedBox(height: 12),
                Text(
                  'Entry must have at least 2 lines and balanced debits/credits before posting.',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _confirmed,
                onChanged: widget.balanceSummary.canPost
                    ? (value) => setState(() => _confirmed = value ?? false)
                    : null,
                title: const Text(
                  'I understand this entry cannot be changed after posting',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: canPost ? () => Navigator.pop(context, true) : null,
          child: const Text('Post entry'),
        ),
      ],
    );
  }
}
