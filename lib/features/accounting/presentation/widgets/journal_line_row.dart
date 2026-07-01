import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';

class JournalLineRow extends StatelessWidget {
  const JournalLineRow({
    super.key,
    required this.index,
    required this.line,
    required this.accounts,
    required this.onAccountChanged,
    required this.onSideChanged,
    required this.onAmountChanged,
    required this.onDescriptionChanged,
    required this.onRemove,
    this.error,
    this.readOnly = false,
  });

  final int index;
  final JournalLineDraft line;
  final List<ChartOfAccountModel> accounts;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<JournalLineSide> onSideChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String?> onDescriptionChanged;
  final VoidCallback onRemove;
  final String? error;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: error != null ? AppColors.error : AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String?>(
                  value: _resolveAccountValue(),
                  decoration: InputDecoration(
                    labelText: 'Account',
                    errorText: error,
                  ),
                  items: accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(
                            coaIndentLabel(
                              accountCode: account.accountCode,
                              accountName: account.accountName,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: readOnly ? null : onAccountChanged,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: SegmentedButton<JournalLineSide>(
                  segments: const [
                    ButtonSegment(
                      value: JournalLineSide.debit,
                      label: Text('Debit'),
                    ),
                    ButtonSegment(
                      value: JournalLineSide.credit,
                      label: Text('Credit'),
                    ),
                  ],
                  selected: {line.side},
                  onSelectionChanged: readOnly
                      ? null
                      : (selection) => onSideChanged(selection.first),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: TextFormField(
                  initialValue: line.amount,
                  enabled: !readOnly,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: onAmountChanged,
                ),
              ),
              if (!readOnly)
                IconButton(
                  tooltip: 'Remove line',
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: line.description,
            enabled: !readOnly,
            decoration: const InputDecoration(
              labelText: 'Line description (optional)',
              isDense: true,
            ),
            onChanged: (value) => onDescriptionChanged(value.isEmpty ? null : value),
          ),
        ],
      ),
    );
  }

  String? _resolveAccountValue() {
    if (line.accountId == null) return null;
    if (accounts.any((a) => a.id == line.accountId)) return line.accountId;
    return null;
  }
}
