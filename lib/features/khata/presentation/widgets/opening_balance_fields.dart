import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/utils/currency_label.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';
import 'package:frantend/shared/widgets/inputs/synced_text_field.dart';

/// Amount, direction and "as of" day of an opening balance, with a short
/// explanation. Used in the new customer / supplier forms and on the account.
class OpeningBalanceFields extends StatelessWidget {
  const OpeningBalanceFields({
    super.key,
    required this.type,
    required this.value,
    required this.onChanged,
    this.amountError,
    this.enabled = true,
    this.autofocus = false,
    this.clock = DateTime.now,
  });

  final PartyType type;
  final OpeningBalanceDraft value;
  final ValueChanged<OpeningBalanceDraft> onChanged;
  final String? amountError;
  final bool enabled;
  final bool autofocus;
  final DateTime Function() clock;

  Future<void> _pickDate(BuildContext context) async {
    final now = clock();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: value.date.isAfter(today) ? today : value.date,
      firstDate: DateTime(today.year - 20),
      lastDate: today,
    );
    if (picked != null) onChanged(value.copyWith(date: picked));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          EntryText.openingHelp(type),
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SyncedTextField(
          key: const Key('opening-amount'),
          value: value.amountText,
          enabled: enabled,
          autofocus: autofocus,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [NumberInputFormatter()],
          decoration: InputDecoration(
            labelText: EntryText.amount,
            prefixText: '$currencyLabel ',
            errorText: amountError,
            border: const OutlineInputBorder(),
          ),
          onChanged: (text) => onChanged(value.copyWith(amountText: text)),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Wrap(
          spacing: AppDimensions.spacing12,
          runSpacing: AppDimensions.spacingSm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IgnorePointer(
              ignoring: !enabled,
              child: SizedBox(
                width: 280,
                child: KhataSegmented<OpeningDirection>(
                  key: const Key('opening-direction'),
                  options: [
                    for (final d in OpeningDirection.values)
                      (d, EntryText.directionLabel(d)),
                  ],
                  selected: value.direction,
                  onChanged: (d) => onChanged(value.copyWith(direction: d)),
                ),
              ),
            ),
            Tooltip(
              message: EntryText.asOfHelp,
              child: OutlinedButton.icon(
                key: const Key('opening-date'),
                onPressed: enabled ? () => _pickDate(context) : null,
                icon: const Icon(Icons.event_outlined, size: 16),
                label: Text(
                  '${EntryText.asOf} ${KhataFormat.fullDay(value.date)}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
