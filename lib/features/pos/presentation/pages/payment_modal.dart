import 'package:frantend/core/tax/tax_settings.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/presentation/widgets/customer_credit_strip.dart';
import 'package:frantend/features/khata/presentation/widgets/payment_source_cards.dart' show KhataNotice;
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
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

  /// Set when the server refused the sale for the customer's credit limit.
  _CreditBlock? _creditBlock;

  bool get _canSeeBalance => hasPermission(context, Perm.customersBalanceView);

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
        canSeeBalance: _canSeeBalance,
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
      _creditBlock = null;
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

  /// [overrideCredit]: "Allow anyway" after a credit-limit refusal. The paid
  /// part goes without the credit tender; the server puts the rest on the
  /// customer's account and records who allowed it.
  Future<void> _completeSale(
    PosState state, {
    bool overrideCredit = false,
  }) async {
    setState(() {
      _error = null;
      _creditBlock = null;
    });
    final allocation = _allocation(state);
    if (!allocation.canComplete) return;
    final lines = overrideCredit
        ? [
            for (final l in allocation.lines)
              if (l.paymentMethod != PaymentMethods.credit) l,
          ]
        : allocation.lines;

    try {
      final cubit = context.read<PosCubit>();
      SaleResponseModel sale;
      try {
        sale = await cubit.submitSale(
          lines,
          allowCreditOverride: overrideCredit,
        );
      } on ExpiredStockWarningException catch (warning) {
        if (!mounted) return;
        final sell = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            key: const Key('expired-sale-confirm'),
            title: const Text('Expired stock in this sale'),
            content: Text(warning.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Go back'),
              ),
              FilledButton(
                key: const Key('expired-sale-confirm-sell'),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Sell anyway'),
              ),
            ],
          ),
        );
        if (sell != true) return;
        sale = await cubit.submitSale(
          lines,
          confirmExpired: true,
          allowCreditOverride: overrideCredit,
        );
      }
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
    } on CreditLimitExceededException catch (e) {
      if (!mounted) return;
      final credit = PaymentPlanner.creditContext(
        state.selectedCustomer,
        canSeeBalance: _canSeeBalance,
      );
      setState(() {
        _creditBlock = _CreditBlock(
          message: e.message,
          credit: credit,
          needed: allocation.creditAmount,
        );
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = UserErrorMessage.from(e));
      }
    }
  }

  Future<void> _showChangeDialog(Decimal change) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Give change'),
        content: Text(
          formatPKR(change),
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
                formatPKR(state.displayGrandTotal),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              // How the total was reached: tax by rate and rounding.
              for (final g in state.displayTaxGroups)
                Text(
                  '${TaxSettingsHolder.current.inclusive ? 'Includes ' : ''}'
                  '${g.title(TaxSettingsHolder.current.label)}: ${formatPKR(g.tax)}',
                  key: const Key('pay-tax-line'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (state.displayRounding != Decimal.zero)
                Text(
                  'Rounding ${formatSignedMoney(state.displayRounding)}',
                  key: const Key('pay-rounding-line'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (state.selectedCustomer != null) ...[
                const SizedBox(height: 10),
                CustomerCreditStrip(customer: state.selectedCustomer!),
              ],
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
                    _creditBlock = null;
                    line.dispose();
                    _lines.removeAt(i);
                  }),
                  onAmountChanged: () => setState(() => _creditBlock = null),
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
                formatPKR(state.displayGrandTotal),
              ),
              _SummaryRow(
                'Paid',
                formatPKR(allocation.applied),
              ),
              if (allocation.remaining > Decimal.zero)
                _SummaryRow(
                  'Remaining',
                  formatPKR(allocation.remaining),
                  valueColor: AppColors.warning,
                ),
              if (allocation.creditAmount > Decimal.zero)
                _SummaryRow(
                  'On customer account',
                  formatPKR(allocation.creditAmount),
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
              if (_creditBlock != null) ...[
                const SizedBox(height: 8),
                _CreditBlockedNotice(
                  block: _creditBlock!,
                  busy: state.isSubmittingSale,
                  onAllowAnyway: () =>
                      _completeSale(state, overrideCredit: true),
                ),
                const _CreditNoOverrideHint(),
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

/// The server refused the sale for the customer's credit limit.
class _CreditBlock {
  const _CreditBlock({
    required this.message,
    required this.credit,
    required this.needed,
  });

  final String message;
  final CreditContext credit;

  /// The part of the sale that was going on credit.
  final Decimal needed;
}

/// "Credit limit reached" with the customer's numbers. People who may
/// override (`customers.credit.override`) get "Allow anyway"; everybody else
/// is told to ask the owner or take more money now.
class _CreditBlockedNotice extends StatelessWidget {
  const _CreditBlockedNotice({
    required this.block,
    required this.busy,
    required this.onAllowAnyway,
  });

  final _CreditBlock block;
  final bool busy;
  final VoidCallback onAllowAnyway;

  @override
  Widget build(BuildContext context) {
    final limit = block.credit.creditLimit;
    final available = block.credit.available;
    final knowsNumbers = !block.credit.serverChecksLimit &&
        block.credit.balance != null &&
        limit != null &&
        limit > Decimal.zero &&
        available != null;
    final body = knowsNumbers
        ? KhataText.creditBlockedBody(
            limit: formatPKR(limit),
            owed: formatPKR(block.credit.alreadyOwed),
            available: formatPKR(available),
            needed: formatPKR(block.needed),
          )
        : block.message;
    return KhataNotice(
      key: const ValueKey('credit-blocked'),
      icon: Icons.credit_score_outlined,
      title: KhataText.creditBlockedTitle,
      body: body,
      action: PermissionGate(
        permission: Perm.customersCreditOverride,
        child: FilledButton(
          key: const ValueKey('credit-allow-anyway'),
          onPressed: busy ? null : onAllowAnyway,
          child: const Text(KhataText.allowAnyway),
        ),
      ),
    );
  }
}

/// Shown under the notice for people who cannot override.
class _CreditNoOverrideHint extends StatelessWidget {
  const _CreditNoOverrideHint();

  @override
  Widget build(BuildContext context) {
    if (hasPermission(context, Perm.customersCreditOverride)) {
      return const SizedBox.shrink();
    }
    return const Padding(
      padding: EdgeInsets.only(top: 6),
      child: Text(
        KhataText.creditBlockedNoOverride,
        key: ValueKey('credit-no-override'),
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
            formatPKR(change),
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
                '${formatPKR(creditAmount)}',
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
