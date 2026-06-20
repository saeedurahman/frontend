import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
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

  Decimal get _grandTotal => context.read<PosCubit>().state.grandTotal;

  Decimal get _enteredTotal => _lines.fold(
        Decimal.zero,
        (sum, line) =>
            sum + (Decimal.tryParse(line.amountController.text) ?? Decimal.zero),
      );

  bool get _hasCredit =>
      _lines.any((l) => l.method == PaymentMethods.credit);

  bool get _canComplete {
    if (_lines.isEmpty) return false;
    if (_hasCredit) return true;
    return _enteredTotal >= _grandTotal;
  }

  void _addMethod(_PaymentMethodOption option) {
    if (option.method == PaymentMethods.credit &&
        context.read<PosCubit>().state.selectedCustomer == null) {
      return;
    }
    setState(() {
      final remaining = _grandTotal - _enteredTotal;
      final prefill = remaining > Decimal.zero ? remaining : Decimal.zero;
      _lines.add(_PaymentLineEntry(
        method: option.method,
        label: option.label,
        icon: option.icon,
        walletLabel: option.walletLabel,
        amountController: TextEditingController(
          text: prefill > Decimal.zero ? DecimalUtils.format(prefill) : '',
        ),
        referenceController: TextEditingController(),
      ));
    });
  }

  Future<void> _completeSale() async {
    setState(() => _error = null);
    final payments = _lines
        .map((l) {
          final amount =
              Decimal.tryParse(l.amountController.text) ?? Decimal.zero;
          if (amount <= Decimal.zero) return null;
          return PaymentLineModel(
            paymentMethod: l.method,
            amount: amount,
            referenceNo: l.referenceController.text.trim().isEmpty
                ? null
                : l.referenceController.text.trim(),
            walletLabel: l.walletLabel,
          );
        })
        .whereType<PaymentLineModel>()
        .toList();

    if (payments.isEmpty) {
      setState(() => _error = 'Add at least one payment');
      return;
    }

    try {
      final sale = await context.read<PosCubit>().submitSale(payments);
      if (!mounted) return;
      Navigator.pop(context);
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => ReceiptPreviewPage(sale: sale),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PosCubit>().state;
    final difference = _enteredTotal - _grandTotal;
    final hasCustomer = state.selectedCustomer != null;

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
                formatPKR(_grandTotal.toDouble()),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _methodOptions.map((option) {
                  final disabled = option.method == PaymentMethods.credit &&
                      !hasCustomer;
                  return SizedBox(
                    width: 140,
                    child: OutlinedButton(
                      onPressed: disabled ? null : () => _addMethod(option),
                      child: Column(
                        children: [
                          Text(option.icon, style: const TextStyle(fontSize: 20)),
                          Text(option.label, textAlign: TextAlign.center),
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
                  onRemove: () => setState(() {
                    line.amountController.dispose();
                    line.referenceController.dispose();
                    _lines.removeAt(i);
                  }),
                  onQuickCash: line.method == PaymentMethods.cash
                      ? (amount) => setState(() {
                            line.amountController.text =
                                DecimalUtils.format(amount);
                          })
                      : null,
                  grandTotal: _grandTotal,
                );
              }),
              _SummaryRow('Total Due', formatPKR(_grandTotal.toDouble())),
              _SummaryRow(
                'Amount Entered',
                formatPKR(_enteredTotal.toDouble()),
              ),
              _SummaryRow(
                _enteredTotal >= _grandTotal ? 'Change Due' : 'Remaining',
                formatPKR(difference.abs().toDouble()),
                valueColor: _enteredTotal >= _grandTotal
                    ? AppColors.success
                    : AppColors.warning,
              ),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: state.isSubmittingSale || !_canComplete
                          ? null
                          : _completeSale,
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
    required this.grandTotal,
    this.onQuickCash,
  });

  final _PaymentLineEntry line;
  final VoidCallback onRemove;
  final void Function(Decimal amount)? onQuickCash;
  final Decimal grandTotal;

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: line.amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
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
              ),
            ],
            if (onQuickCash != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  ActionChip(
                    label: const Text('Exact'),
                    onPressed: () => onQuickCash!(grandTotal),
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
