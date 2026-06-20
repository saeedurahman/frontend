import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';

class RecordPaymentDialog extends StatefulWidget {
  const RecordPaymentDialog({
    super.key,
    required this.customerName,
    required this.currentBalance,
  });

  final String customerName;
  final String currentBalance;

  static Future<bool> show(
    BuildContext context, {
    required String customerName,
    required String currentBalance,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CustomerLedgerCubit>(),
        child: RecordPaymentDialog(
          customerName: customerName,
          currentBalance: currentBalance,
        ),
      ),
    ).then((value) => value ?? false);
  }

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  String _paymentMethod = PaymentMethods.cash;
  String? _localError;

  Decimal get _balanceParsed =>
      CustomerBalanceUtils.parseBalance(widget.currentBalance);

  Decimal get _amountParsed =>
      Decimal.tryParse(_amountController.text.trim()) ?? Decimal.zero;

  bool get _isValidAmount => _amountParsed > Decimal.zero;

  bool get _showReferenceField => _paymentMethod != PaymentMethods.cash;

  bool get _hasOutstanding => _balanceParsed < Decimal.zero;

  Decimal get _amountOwed =>
      _hasOutstanding ? _balanceParsed.abs() : Decimal.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerLedgerCubit>().checkPaymentShift();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isValidAmount) return;

    setState(() => _localError = null);
    context.read<CustomerLedgerCubit>().clearPaymentError();

    final response = await context.read<CustomerLedgerCubit>().recordPayment(
          amount: _amountParsed,
          paymentMethod: _paymentMethod,
          referenceNo: _referenceController.text.trim().isEmpty
              ? null
              : _referenceController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (!mounted) return;

    if (response != null) {
      Navigator.of(context).pop(true);
      final newBalanceText =
          CustomerBalanceUtils.formatBalanceDisplay(response.newBalance).text;
      AppAlerts.showSuccessMessage(
        context,
        'Payment of Rs. ${DecimalUtils.format(_amountParsed)} recorded. '
        'New balance: $newBalanceText',
      );
      return;
    }

    final paymentError = switch (context.read<CustomerLedgerCubit>().state) {
      CustomerLedgerLoaded(:final paymentError) => paymentError,
      _ => null,
    };
    setState(() => _localError = paymentError ?? 'Failed to record payment');
  }

  @override
  Widget build(BuildContext context) {
    final ledgerState = context.watch<CustomerLedgerCubit>().state;
    final isSubmitting = ledgerState is CustomerLedgerLoaded &&
        ledgerState.isRecordingPayment;
    final isCheckingShift = ledgerState is CustomerLedgerLoaded &&
        ledgerState.isCheckingPaymentShift;
    final showNoShiftWarning = _paymentMethod == PaymentMethods.cash &&
        ledgerState is CustomerLedgerLoaded &&
        !ledgerState.isCheckingPaymentShift &&
        ledgerState.activePaymentShiftId == null;
    final excess = _hasOutstanding && _isValidAmount
        ? _amountParsed - _amountOwed
        : Decimal.zero;

    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Record Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.customerName,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _hasOutstanding
                      ? AppColors.error.withValues(alpha: 0.08)
                      : AppColors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _hasOutstanding
                      ? 'Current Outstanding: Rs. ${DecimalUtils.format(_amountOwed)}'
                      : 'No outstanding balance',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _hasOutstanding
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (_hasOutstanding) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ActionChip(
                    label: Text(
                      'Pay Full Amount (Rs. ${DecimalUtils.format(_amountOwed)})',
                    ),
                    onPressed: () {
                      _amountController.text =
                          DecimalUtils.format(_amountOwed);
                      setState(() {});
                    },
                  ),
                ),
              ],
              if (excess > Decimal.zero) ...[
                const SizedBox(height: 8),
                Text(
                  'This is more than the outstanding balance — '
                  'Rs. ${DecimalUtils.format(excess)} will be recorded as customer credit',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Payment Method *',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _methodOptions.map((option) {
                  final selected = _paymentMethod == option.method;
                  return SizedBox(
                    width: 140,
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _paymentMethod = option.method;
                        if (option.method == PaymentMethods.cash) {
                          _referenceController.clear();
                        }
                      }),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selected
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : null,
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                          width: selected ? 2 : 1,
                        ),
                      ),
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
              if (_paymentMethod == PaymentMethods.cash && isCheckingShift) ...[
                const SizedBox(height: 8),
                const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Checking active shift…',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              if (showNoShiftWarning) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Text(
                    '⚠ No active shift open — this cash payment '
                    "won't appear in today's drawer reconciliation",
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (_showReferenceField) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference No',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLength: 200,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_localError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _localError!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  SecondaryButton(
                    label: 'Cancel',
                    onPressed:
                        isSubmitting ? null : () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Record Payment',
                      isLoading: isSubmitting,
                      onPressed: _isValidAmount && !isSubmitting ? _submit : null,
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

class _PaymentMethodOption {
  const _PaymentMethodOption({
    required this.method,
    required this.label,
    required this.icon,
  });

  final String method;
  final String label;
  final String icon;
}

const _methodOptions = [
  _PaymentMethodOption(method: PaymentMethods.cash, label: 'Cash', icon: '💵'),
  _PaymentMethodOption(method: PaymentMethods.card, label: 'Card', icon: '💳'),
  _PaymentMethodOption(method: PaymentMethods.wallet, label: 'Wallet', icon: '📱'),
  _PaymentMethodOption(
    method: PaymentMethods.bankTransfer,
    label: 'Bank Transfer',
    icon: '🏦',
  ),
  _PaymentMethodOption(
    method: PaymentMethods.cheque,
    label: 'Cheque',
    icon: '📝',
  ),
  _PaymentMethodOption(method: PaymentMethods.other, label: 'Other', icon: '•••'),
];
