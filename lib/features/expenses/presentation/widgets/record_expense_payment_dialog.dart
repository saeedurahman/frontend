import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';

class RecordExpensePaymentDialog extends StatefulWidget {
  const RecordExpensePaymentDialog({
    super.key,
    required this.expenseDescription,
    required this.remainingBalance,
  });

  final String expenseDescription;
  final String remainingBalance;

  static Future<bool> show(
    BuildContext context, {
    required String expenseDescription,
    required String remainingBalance,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ExpenseDetailCubit>(),
        child: RecordExpensePaymentDialog(
          expenseDescription: expenseDescription,
          remainingBalance: remainingBalance,
        ),
      ),
    ).then((value) => value ?? false);
  }

  @override
  State<RecordExpensePaymentDialog> createState() =>
      _RecordExpensePaymentDialogState();
}

class _RecordExpensePaymentDialogState extends State<RecordExpensePaymentDialog> {
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();

  String _paymentMethod = PaymentMethods.cash;
  String? _localError;

  Decimal get _remainingParsed =>
      Decimal.tryParse(widget.remainingBalance) ?? Decimal.zero;

  Decimal get _amountParsed =>
      Decimal.tryParse(_amountController.text.trim()) ?? Decimal.zero;

  bool get _isValidAmount =>
      _amountParsed > Decimal.zero && _amountParsed <= _remainingParsed;

  bool get _exceedsRemaining =>
      _amountParsed > Decimal.zero && _amountParsed > _remainingParsed;

  bool get _showReferenceField => _paymentMethod != PaymentMethods.cash;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseDetailCubit>().checkPaymentShift();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isValidAmount) return;

    setState(() => _localError = null);
    context.read<ExpenseDetailCubit>().clearPaymentError();

    final success = await context.read<ExpenseDetailCubit>().recordPayment(
          amount: _amountParsed,
          paymentMethod: _paymentMethod,
          referenceNo: _referenceController.text.trim().isEmpty
              ? null
              : _referenceController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      final remaining = switch (context.read<ExpenseDetailCubit>().state) {
        ExpenseDetailLoaded(:final expense) =>
          DecimalUtils.format(ExpenseCalculations.remainingBalance(expense)),
        _ => widget.remainingBalance,
      };
      Navigator.of(context).pop(true);
      AppAlerts.showSuccessMessage(
        context,
        'Payment of Rs. ${DecimalUtils.format(_amountParsed)} recorded. '
        'Remaining: Rs. $remaining',
      );
      return;
    }

    final paymentError = switch (context.read<ExpenseDetailCubit>().state) {
      ExpenseDetailLoaded(:final paymentError) => paymentError,
      _ => null,
    };
    setState(() => _localError = paymentError ?? 'Failed to record payment');
  }

  @override
  Widget build(BuildContext context) {
    final detailState = context.watch<ExpenseDetailCubit>().state;
    final isSubmitting = detailState is ExpenseDetailLoaded &&
        detailState.isRecordingPayment;
    final isCheckingShift = detailState is ExpenseDetailLoaded &&
        detailState.isCheckingPaymentShift;
    final showNoShiftWarning = _paymentMethod == PaymentMethods.cash &&
        detailState is ExpenseDetailLoaded &&
        !detailState.isCheckingPaymentShift &&
        detailState.activePaymentShiftId == null;

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
                widget.expenseDescription,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Remaining Balance: Rs. ${DecimalUtils.format(_remainingParsed)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
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
                decoration: InputDecoration(
                  labelText: 'Amount *',
                  border: const OutlineInputBorder(),
                  errorText: _exceedsRemaining
                      ? 'Cannot exceed remaining balance of Rs. '
                          '${DecimalUtils.format(_remainingParsed)}'
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (_remainingParsed > Decimal.zero) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ActionChip(
                    label: Text(
                      'Pay Full Amount (Rs. ${DecimalUtils.format(_remainingParsed)})',
                    ),
                    onPressed: () {
                      _amountController.text =
                          DecimalUtils.format(_remainingParsed);
                      setState(() {});
                    },
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
                        if (option.method == PaymentMethods.cash) {
                          context.read<ExpenseDetailCubit>().checkPaymentShift();
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
                      onPressed:
                          _isValidAmount && !isSubmitting ? _submit : null,
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
  _PaymentMethodOption(
    method: PaymentMethods.wallet,
    label: 'Wallet',
    icon: '📱',
  ),
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
