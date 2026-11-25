import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_receipt_service.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_state.dart';
import 'package:frantend/features/khata/presentation/utils/money_input.dart';
import 'package:frantend/features/khata/presentation/widgets/money_keypad.dart';
import 'package:frantend/features/khata/presentation/widgets/payment_source_cards.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:intl/intl.dart';

/// "Pay supplier": opened from the supplier list, the supplier account and the
/// purchases list. Resolves with true when a payment was recorded.
class PaySupplierDialog extends StatelessWidget {
  const PaySupplierDialog({super.key});

  static Future<bool> show(
    BuildContext context, {
    required String supplierId,
    String? supplierName,
    String? supplierPhone,
  }) async {
    final paid = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) => sl<SupplierPaymentCubit>()
          ..init(
            supplierId: supplierId,
            supplierName: supplierName,
            supplierPhone: supplierPhone,
          ),
        child: const PaySupplierDialog(),
      ),
    );
    return paid ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 940, maxHeight: 760),
        child: const PaySupplierContent(),
      ),
    );
  }
}

/// The body of the dialog. Needs a [SupplierPaymentCubit] above it.
class PaySupplierContent extends StatefulWidget {
  const PaySupplierContent({super.key, this.receipts});

  /// Receipt actions; defaults to the app's service.
  final PaymentReceiptService? receipts;

  @override
  State<PaySupplierContent> createState() => _PaySupplierContentState();
}

class _PaySupplierContentState extends State<PaySupplierContent> {
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    _note.dispose();
    super.dispose();
  }

  SupplierPaymentCubit get _cubit => context.read<SupplierPaymentCubit>();

  void _onAmountChanged(String raw) {
    if (raw.trim().isEmpty) {
      _cubit.setAmount('');
      return;
    }
    final resolved = MoneyInput.resolve(raw);
    if (resolved != null) {
      _cubit.setAmount(resolved);
    } else if (!MoneyInput.hasOperator(raw)) {
      _cubit.setAmount(raw);
    }
  }

  void _setAmountText(String text) {
    _amount.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _onAmountChanged(text);
  }

  void _equals() {
    final resolved = MoneyInput.resolve(_amount.text);
    if (resolved == null) return;
    final value = Decimal.tryParse(resolved);
    if (value != null) _setAmountText(MoneyInput.plain(value));
  }

  Future<void> _pickDate(SupplierPaymentState state) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.paidOn ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) _cubit.setDate(picked);
  }

  Future<void> _pay() async {
    final ok = await _cubit.submit();
    if (ok && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierPaymentCubit, SupplierPaymentState>(
      builder: (context, state) {
        if (state.result != null) {
          return _Done(state: state, receipts: widget.receipts);
        }
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(state: state),
              const SizedBox(height: 16),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 330, child: _amountColumn(state)),
                        const SizedBox(width: 24),
                        Expanded(child: _detailsColumn(state)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _amountColumn(SupplierPaymentState state) {
    final problem = state.amountProblem;
    final typedSum = MoneyInput.hasOperator(_amount.text)
        ? MoneyInput.resolve(_amount.text)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          KhataText.amountLabel,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('pay_amount'),
          controller: _amount,
          autofocus: true,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.+\-×÷]')),
          ],
          decoration: InputDecoration(
            prefixText: 'Rs. ',
            hintText: '0',
            errorText: problem,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            helperText: typedSum != null ? '= Rs. $typedSum' : null,
          ),
          onChanged: _onAmountChanged,
          onSubmitted: (_) => _equals(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            if (state.owed > Decimal.zero) ...[
              ActionChip(
                key: const ValueKey('chip_full'),
                label: Text('${KhataText.payFull} ${formatPKR(state.owed)}'),
                onPressed: () {
                  _cubit.payFull();
                  _setAmountText(state.owed.toStringAsFixed(2));
                },
              ),
              ActionChip(
                key: const ValueKey('chip_half'),
                label: const Text(KhataText.payHalf),
                onPressed: () {
                  _cubit.payHalf();
                  _amount.text = _cubit.state.amountText;
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        MoneyKeypad(
          controller: _amount,
          onChanged: (text) {
            _onAmountChanged(text);
            setState(() {});
          },
          onEquals: _equals,
        ),
      ],
    );
  }

  Widget _detailsColumn(SupplierPaymentState state) {
    final source = state.source;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          KhataText.sourceQuestion,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        PaymentSourceCards(
          selected: source,
          enabled: !state.submitting,
          onSelected: _cubit.setSource,
        ),
        if (state.checkingShift && source.touchesDrawer) ...[
          const SizedBox(height: 10),
          const Text(
            KhataText.checkingShift,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
        if (state.needsShift) ...[
          const SizedBox(height: 12),
          _NeedsShiftNotice(state: state),
        ],
        if (source.needsReference) ...[
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('pay_reference'),
            controller: _reference,
            onChanged: _cubit.setReference,
            decoration: InputDecoration(
              labelText: source.referenceLabel,
              hintText: KhataText.referenceHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('pay_note'),
                controller: _note,
                onChanged: _cubit.setNote,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: KhataText.noteHint,
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              key: const ValueKey('pay_date'),
              onPressed: () => _pickDate(state),
              icon: const Icon(Icons.event_outlined, size: 18),
              label: Text(
                state.paidOn == null
                    ? 'Today'
                    : DateFormat('dd MMM yyyy').format(state.paidOn!),
              ),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Summary(state: state),
        if (state.isAdvance) ...[
          const SizedBox(height: 12),
          KhataNotice(
            key: const ValueKey('advance_notice'),
            icon: Icons.savings_outlined,
            color: AppColors.info,
            title: KhataText.advanceTitle,
            body: KhataText.advanceBody(formatPKR(state.advanceAfter)),
          ),
        ],
        if (state.offline) ...[
          const SizedBox(height: 12),
          const KhataNotice(
            key: ValueKey('offline_notice'),
            icon: Icons.wifi_off_outlined,
            color: AppColors.offline,
            title: KhataText.offlineTitle,
            body: KhataText.offlineBody,
          ),
        ],
        if (state.error != null && !state.offline && !state.needsShift) ...[
          const SizedBox(height: 12),
          Text(
            state.error!,
            key: const ValueKey('pay_error'),
            style: const TextStyle(color: AppColors.error, fontSize: 13),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:
                  state.submitting ? null : () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            PermissionGate(
              permission: Perm.suppliersPaymentsCreate,
              mode: GateMode.disable,
              mutating: true,
              builder: (context, enabled) => FilledButton.icon(
                key: const ValueKey('pay_submit'),
                onPressed: enabled && state.canSubmit ? _pay : null,
                icon: state.submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.payments_outlined, size: 18),
                label: Text(
                  state.amount == null
                      ? KhataText.payNow
                      : '${KhataText.payNow} ${formatPKR(state.amount)}',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(190, 50),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final SupplierPaymentState state;

  @override
  Widget build(BuildContext context) {
    final owed = state.owed;
    final advance = state.balance > Decimal.zero ? state.balance : Decimal.zero;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.payments_outlined, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                KhataText.paySupplierTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(
                state.supplierName,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (!state.loading)
          Container(
            key: const ValueKey('payable_now'),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: (owed > Decimal.zero ? AppColors.error : AppColors.success)
                  .withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  owed > Decimal.zero
                      ? KhataText.youOweNow
                      : (advance > Decimal.zero
                          ? KhataText.advanceTag
                          : KhataText.nothingOwed),
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                Text(
                  formatPKR(owed > Decimal.zero ? owed : advance),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: owed > Decimal.zero ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final SupplierPaymentState state;

  @override
  Widget build(BuildContext context) {
    final hasAmount = state.amount != null;
    final after = state.owedAfter;
    final advance = state.advanceAfter;
    final text = !hasAmount
        ? '—'
        : advance > Decimal.zero
            ? KhataText.youHaveAdvance(formatPKR(advance))
            : after > Decimal.zero
                ? KhataText.youOwe(formatPKR(after))
                : KhataText.settled;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Text(
            KhataText.afterPayment,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            text,
            key: const ValueKey('balance_after'),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _NeedsShiftNotice extends StatelessWidget {
  const _NeedsShiftNotice({required this.state});

  final SupplierPaymentState state;

  @override
  Widget build(BuildContext context) {
    final canOpen = hasPermission(context, Perm.shiftsOpen);
    return KhataNotice(
      key: const ValueKey('needs_shift_notice'),
      icon: Icons.lock_clock_outlined,
      title: KhataText.needsShiftTitle,
      body: KhataText.needsShiftBody,
      action: canOpen
          ? FilledButton(
              key: const ValueKey('open_shift_button'),
              onPressed: state.openingShift
                  ? null
                  : () => context.read<SupplierPaymentCubit>().openShift(),
              child: Text(
                state.openingShift ? KhataText.openingShift : KhataText.openShift,
              ),
            )
          : null,
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.state, this.receipts});

  final SupplierPaymentState state;
  final PaymentReceiptService? receipts;

  PaymentReceiptData get _data {
    final r = state.result!;
    final advance = r.balance > Decimal.zero ? r.balance : Decimal.zero;
    return PaymentReceiptData(
      partyName: state.supplierName,
      amountText: formatPKR(r.amount),
      source: r.paymentSource,
      reference: r.reference,
      note: r.note,
      when: r.entryAt,
      partyPhone: state.supplierPhone,
      balanceLine: advance > Decimal.zero
          ? 'Advance with supplier: ${formatPKR(advance)}'
          : (r.owedAfter > Decimal.zero
              ? 'Still owed: ${formatPKR(r.owedAfter)}'
              : 'All settled'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = state.result!;
    final data = _data;
    final service = receipts ?? sl<PaymentReceiptService>();
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 56),
          const SizedBox(height: 8),
          const Text(
            KhataText.paymentDone,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Container(
            key: const ValueKey('payment_receipt'),
            width: 380,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _line(KhataText.paidTo, state.supplierName),
                _line('Amount', formatPKR(r.amount), bold: true),
                _line('Paid from', r.paymentSource.label),
                if (r.reference != null) _line('Reference', r.reference!),
                if (r.note != null) _line('Note', r.note!),
                const Divider(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    data.balanceLine,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                key: const ValueKey('receipt_share'),
                onPressed: () => service.shareOnWhatsApp(data),
                icon: const Icon(Icons.share_outlined, size: 18),
                label: const Text(KhataText.share),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                key: const ValueKey('receipt_print'),
                onPressed: () => service.print(data),
                icon: const Icon(Icons.print_outlined, size: 18),
                label: const Text(KhataText.print),
              ),
              const SizedBox(width: 10),
              FilledButton(
                key: const ValueKey('receipt_done'),
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text(KhataText.done),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  fontSize: bold ? 17 : 14,
                ),
              ),
            ),
          ],
        ),
      );
}
