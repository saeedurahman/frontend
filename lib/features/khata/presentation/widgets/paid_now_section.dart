import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/presentation/cubit/paid_now_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/payment_source_cards.dart';
import 'package:frantend/core/utils/currency_label.dart';

/// "Paid now" while receiving goods: None (credit) / Half / Full or a typed
/// amount, where the money came from, and what stays on credit.
///
/// Needs a [PaidNowCubit] above it. [total] is the live bill total, so Full and
/// Half follow the bill while it is edited.
class PaidNowSection extends StatelessWidget {
  const PaidNowSection({super.key, required this.total, this.enabled = true});

  final Decimal total;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaidNowCubit, PaidNowState>(
      builder: (context, state) {
        final cubit = context.read<PaidNowCubit>();
        final paid = state.amountFor(total);
        final hasPayment = paid > Decimal.zero;
        final problem = state.problem(total);
        return Container(
          key: const ValueKey('paid_now_section'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    KhataText.paidNowTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    KhataText.onCredit(formatPKR(state.onCredit(total))),
                    key: const ValueKey('on_credit_text'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _chip(
                    'paid_chip_none',
                    KhataText.paidNowNone,
                    state.chip == PaidChip.none,
                    enabled ? () => cubit.setChip(PaidChip.none) : null,
                  ),
                  _chip(
                    'paid_chip_half',
                    KhataText.paidNowHalf,
                    state.chip == PaidChip.half,
                    enabled && total > Decimal.zero
                        ? () => cubit.setChip(PaidChip.half)
                        : null,
                  ),
                  _chip(
                    'paid_chip_full',
                    KhataText.paidNowFull,
                    state.chip == PaidChip.full,
                    enabled && total > Decimal.zero
                        ? () => cubit.setChip(PaidChip.full)
                        : null,
                  ),
                  SizedBox(
                    width: 160,
                    child: _AmountField(
                      enabled: enabled,
                      shownText: state.chip == PaidChip.custom
                          ? null
                          : (paid > Decimal.zero
                              ? paid.toStringAsFixed(2)
                              : ''),
                      onChanged: cubit.setAmount,
                    ),
                  ),
                ],
              ),
              if (problem != null) ...[
                const SizedBox(height: 8),
                Text(
                  problem,
                  key: const ValueKey('paid_problem'),
                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                ),
              ],
              if (hasPayment) ...[
                const SizedBox(height: 14),
                const Text(
                  KhataText.sourceQuestion,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                PaymentSourceCards(
                  selected: state.source,
                  enabled: enabled,
                  cardWidth: 170,
                  onSelected: cubit.setSource,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const ValueKey('paid_reference_field'),
                  enabled: enabled,
                  initialValue: state.reference,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: KhataText.referenceHint,
                  ),
                  onChanged: cubit.setReference,
                ),
                if (state.showShiftNotice(total)) ...[
                  const SizedBox(height: 12),
                  KhataNotice(
                    key: const ValueKey('paid_needs_shift'),
                    icon: Icons.lock_clock_outlined,
                    title: KhataText.needsShiftTitle,
                    body: KhataText.needsShiftBody,
                    action: FilledButton.icon(
                      key: const ValueKey('paid_open_shift'),
                      onPressed: state.openingShift ? null : cubit.openShift,
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: Text(
                        state.openingShift
                            ? KhataText.openingShift
                            : KhataText.openShift,
                      ),
                    ),
                  ),
                ],
              ],
              if (state.error != null) ...[
                const SizedBox(height: 10),
                Text(
                  state.error!,
                  key: const ValueKey('paid_error'),
                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String key, String label, bool selected, VoidCallback? onTap) {
    return ChoiceChip(
      key: ValueKey(key),
      label: Text(label),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.14),
    );
  }

}

/// The "other amount" box. While a chip is chosen it shows the chip's amount;
/// while the owner types, the typed text is left alone.
class _AmountField extends StatefulWidget {
  const _AmountField({
    required this.enabled,
    required this.shownText,
    required this.onChanged,
  });

  final bool enabled;

  /// Text to show for a chip choice, or null while the owner is typing.
  final String? shownText;
  final ValueChanged<String> onChanged;

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.shownText ?? '');

  @override
  void didUpdateWidget(covariant _AmountField old) {
    super.didUpdateWidget(old);
    final shown = widget.shownText;
    if (shown != null && shown != _controller.text) {
      _controller.value = TextEditingValue(
        text: shown,
        selection: TextSelection.collapsed(offset: shown.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const ValueKey('paid_amount_field'),
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.+]')),
      ],
      decoration: InputDecoration(
        isDense: true,
        prefixText: '$currencyLabel ',
        hintText: KhataText.otherAmountHint,
      ),
      onChanged: widget.onChanged,
    );
  }
}
