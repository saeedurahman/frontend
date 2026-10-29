import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';
import 'package:frantend/features/pos/domain/utils/payment_planner.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/features/pos/presentation/pages/receipt_preview_page.dart';

class PaymentModal extends StatefulWidget {
  const PaymentModal({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<PosCubit>(),
        child: const PaymentModal(),
      ),
    );
  }

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  final List<_PaymentLineEntry> _lines = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    // Credit decisions need the customer's real limit and balance.
    context.read<PosCubit>().refreshSelectedCustomer();
  }

  @override
  void dispose() {
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  Decimal _entered(_PaymentLineEntry line) =>
      Decimal.tryParse(line.amountController.text) ?? Decimal.zero;

  PaymentInput _input(_PaymentLineEntry line) => PaymentInput(
        method: line.method,
        entered: _entered(line),
        referenceNo: line.referenceController.text,
        walletLabel: line.walletLabel,
      );

  PaymentAllocation _allocation(PosState state) => PaymentPlanner.allocate(
        total: state.displayGrandTotal,
        inputs: _lines.map(_input),
        customer: state.selectedCustomer,
      );

  /// What is still unpaid by every line except [except].
  Decimal _dueExcluding(PosState state, _PaymentLineEntry except) =>
      PaymentPlanner.dueExcluding(
        total: state.displayGrandTotal,
        others: _lines.where((l) => !identical(l, except)).map(_input),
      );

  void _addMethod(PosState state, _PaymentMethodOption option) {
    final isCredit = option.method == PaymentMethods.credit;
    if (!PaymentPlanner.canAddMethod(
      method: option.method,
      hasCustomer: state.selectedCustomer != null,
      existingMethods: _lines.map((l) => l.method),
    )) {
      return;
    }
    setState(() {
      final prefill = PaymentPlanner.prefill(_allocation(state));
      _lines.add(_PaymentLineEntry(
        method: option.method,
        label: option.label,
        icon: option.icon,
        walletLabel: option.walletLabel,
        amountController: TextEditingController(
          text: !isCredit && prefill > Decimal.zero
              ? DecimalUtils.format(prefill)
              : '',
        ),
        referenceController: TextEditingController(),
      ));
    });
  }

  Future<void> _openShift() async {
    final cubit = context.read<PosCubit>();
    final ok = await cubit.openShift(Decimal.zero, null);
    if (!ok && mounted) {
      setState(() => _error = cubit.state.openShiftError ??
          'Could not open a shift');
    }
  }

  Future<void> _completeSale(PosState state) async {
    setState(() => _error = null);
    final allocation = _allocation(state);
    if (!allocation.canComplete) return;

    try {
      final sale = await context.read<PosCubit>().submitSale(allocation.lines);
      if (!mounted) return;
      Navigator.pop(context);
      if (allocation.hasChange) {
        await _showChangeDialog(allocation.change);
      }
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => ReceiptPreviewPage(sale: sale),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _showChangeDialog(Decimal change) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Give change'),
        content: Text(
          formatPKR(change.toDouble()),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PosCubit>().state;
    final allocation = _allocation(state);
    final hasCustomer = state.selectedCustomer != null;
    final hasShift = state.activeShift != null;
    final canComplete = hasShift &&
        state.canProceedToPayment &&
        !state.isSubmittingSale &&
        allocation.canComplete;

    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Complete Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                formatPKR(state.displayGrandTotal.toDouble()),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (!hasShift) ...[
                const SizedBox(height: 12),
                _ShiftRequiredBanner(
                  isOpening: state.isOpeningShift,
                  canOpen: state.canOpenShift,
                  onOpen: _openShift,
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _methodOptions.map((option) {
                  final isCredit = option.method == PaymentMethods.credit;
                  final disabled = isCredit && !hasCustomer;
                  return SizedBox(
                    width: 140,
                    child: OutlinedButton(
                      onPressed:
                          disabled ? null : () => _addMethod(state, option),
                      child: Column(
                        children: [
                          Text(option.icon, style: const TextStyle(fontSize: 20)),
                          Text(option.label, textAlign: TextAlign.center),
                          if (disabled)
                            const Text(
                              'needs customer',
                              style: TextStyle(fontSize: 10),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ..._lines.asMap().entries.map((entry) {
                final i = entry.key;
                final line = entry.value;
                return _PaymentLineEditor(
                  line: line,
                  capped: allocation.cappedInputIndexes.contains(i),
                  creditAmount: allocation.creditAmount,
                  onRemove: () => setState(() {
                    line.dispose();
                    _lines.removeAt(i);
                  }),
                  onAmountChanged: () => setState(() {}),
                  onQuickCash: line.method == PaymentMethods.cash
                      ? (amount) => setState(() {
                            line.amountController.text =
                                DecimalUtils.format(amount);
                          })
                      : null,
                  exactAmount: _dueExcluding(state, line),
                );
              }),
              _SummaryRow(
                'Total Due',
                formatPKR(state.displayGrandTotal.toDouble()),
              ),
              _SummaryRow(
                'Paid',
                formatPKR(allocation.applied.toDouble()),
              ),
              if (allocation.remaining > Decimal.zero)
                _SummaryRow(
                  'Remaining',
                  formatPKR(allocation.remaining.toDouble()),
                  valueColor: AppColors.warning,
                ),
              if (allocation.creditAmount > Decimal.zero)
                _SummaryRow(
                  'On customer account',
                  formatPKR(allocation.creditAmount.toDouble()),
                ),
              if (allocation.hasChange) ...[
                const SizedBox(height: 8),
                _ChangeBanner(change: allocation.change),
              ],
              if (allocation.error != null) ...[
                const SizedBox(height: 8),
                Text(
                  allocation.error!,
                  style: const TextStyle(color: AppColors.error),
                ),
                if (allocation.error!.contains('balance'))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => context
                          .read<PosCubit>()
                          .refreshSelectedCustomer(),
                      child: const Text('Retry'),
                    ),
                  ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: state.isSubmittingSale
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          canComplete ? () => _completeSale(state) : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: state.isSubmittingSale
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Complete Sale'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShiftRequiredBanner extends StatelessWidget {
  const _ShiftRequiredBanner({
    required this.isOpening,
    required this.canOpen,
    required this.onOpen,
  });

  final bool isOpening;
  final bool canOpen;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_clock, color: AppColors.warning),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Open shift first. Sales need an open register shift.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            onPressed: canOpen && !isOpening ? onOpen : null,
            child: isOpening
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Open shift'),
          ),
        ],
      ),
    );
  }
}

class _ChangeBanner extends StatelessWidget {
  const _ChangeBanner({required this.change});

  final Decimal change;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        children: [
          const Text(
            'Change',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            formatPKR(change.toDouble()),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentLineEntry {
  _PaymentLineEntry({
    required this.method,
    required this.label,
    required this.icon,
    required this.amountController,
    required this.referenceController,
    this.walletLabel,
  });

  final String method;
  final String label;
  final String icon;
  final String? walletLabel;
  final TextEditingController amountController;
  final TextEditingController referenceController;

  void dispose() {
    amountController.dispose();
    referenceController.dispose();
  }
}

class _PaymentMethodOption {
  const _PaymentMethodOption({
    required this.method,
    required this.label,
    required this.icon,
    this.walletLabel,
  });

  final String method;
  final String label;
  final String icon;
  final String? walletLabel;
}

const _methodOptions = [
  _PaymentMethodOption(method: PaymentMethods.cash, label: 'Cash', icon: '💵'),
  _PaymentMethodOption(method: PaymentMethods.card, label: 'Card', icon: '💳'),
  _PaymentMethodOption(
    method: PaymentMethods.wallet,
    label: 'Easypaisa',
    icon: '📱',
    walletLabel: 'Easypaisa',
  ),
  _PaymentMethodOption(
    method: PaymentMethods.wallet,
    label: 'JazzCash',
    icon: '📱',
    walletLabel: 'JazzCash',
  ),
  _PaymentMethodOption(
    method: PaymentMethods.bankTransfer,
    label: 'Bank Transfer',
    icon: '🏦',
  ),
  _PaymentMethodOption(
    method: PaymentMethods.credit,
    label: 'Credit (Udhaar)',
    icon: '📝',
  ),
];

class _PaymentLineEditor extends StatelessWidget {
  const _PaymentLineEditor({
    required this.line,
    required this.onRemove,
    required this.onAmountChanged,
    required this.exactAmount,
    required this.capped,
    required this.creditAmount,
    this.onQuickCash,
  });

  final _PaymentLineEntry line;
  final VoidCallback onRemove;
  final VoidCallback onAmountChanged;
  final void Function(Decimal amount)? onQuickCash;

  /// What this line would have to be to settle the sale exactly.
  final Decimal exactAmount;

  /// The typed amount was reduced to the amount due (non-cash overpayment).
  final bool capped;

  /// Computed credit (udhaar) amount; the credit line has no input.
  final Decimal creditAmount;

  @override
  Widget build(BuildContext context) {
    final isCredit = line.method == PaymentMethods.credit;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('${line.icon} ${line.label}'),
                const Spacer(),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            if (isCredit)
              Text(
                'Remainder goes on the customer\'s account: '
                '${formatPKR(creditAmount.toDouble())}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              )
            else
              TextField(
                controller: line.amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: line.method == PaymentMethods.cash
                      ? 'Cash received'
                      : 'Amount',
                  helperText: capped ? 'Reduced to the amount due' : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => onAmountChanged(),
              ),
            if (line.method == PaymentMethods.wallet ||
                line.method == PaymentMethods.card ||
                line.method == PaymentMethods.bankTransfer) ...[
              const SizedBox(height: 8),
              TextField(
                controller: line.referenceController,
                decoration: InputDecoration(
                  labelText: line.method == PaymentMethods.wallet
                      ? 'Transaction ID'
                      : 'Reference No.',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => onAmountChanged(),
              ),
            ],
            if (onQuickCash != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  ActionChip(
                    label: const Text('Exact'),
                    onPressed: () => onQuickCash!(exactAmount),
                  ),
                  for (final amount in [500, 1000, 5000])
                    ActionChip(
                      label: Text('Rs. $amount'),
                      onPressed: () =>
                          onQuickCash!(Decimal.fromInt(amount)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}
