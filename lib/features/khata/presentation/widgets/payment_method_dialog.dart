import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/text/khata_settings_text.dart';
import 'package:frantend/features/khata/presentation/widgets/followup_dialogs.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';

IconData paymentKindIcon(PaymentKind kind) => switch (kind) {
      PaymentKind.bank => Icons.account_balance_outlined,
      PaymentKind.easypaisa ||
      PaymentKind.jazzcash =>
        Icons.smartphone_outlined,
      PaymentKind.cheque => Icons.receipt_outlined,
    };

/// Add or change one way of paying. Null when cancelled.
Future<PaymentInstruction?> showPaymentMethodDialog(
  BuildContext context, {
  PaymentInstruction? initial,
}) =>
    showDialog<PaymentInstruction>(
      context: context,
      builder: (_) => _PaymentMethodDialog(initial: initial),
    );

class _PaymentMethodDialog extends StatefulWidget {
  const _PaymentMethodDialog({this.initial});

  final PaymentInstruction? initial;

  @override
  State<_PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<_PaymentMethodDialog> {
  late PaymentKind _kind = widget.initial?.kind ?? PaymentKind.bank;
  late final _title = TextEditingController(text: widget.initial?.title);
  late final _number =
      TextEditingController(text: widget.initial?.accountNumber);
  late final _bank = TextEditingController(text: widget.initial?.bankName);
  late final _note = TextEditingController(text: widget.initial?.note);
  String? _titleError;
  String? _numberError;

  @override
  void dispose() {
    _title.dispose();
    _number.dispose();
    _bank.dispose();
    _note.dispose();
    super.dispose();
  }

  static String? _value(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty ? null : text;
  }

  void _submit() {
    final title = _value(_title);
    final number = _value(_number);
    setState(() {
      _titleError = title == null ? KhataSettingsText.titleRequired : null;
      _numberError = number == null && _kind.needsAccountNumber
          ? KhataSettingsText.numberRequired
          : null;
    });
    if (_titleError != null || _numberError != null) return;
    Navigator.of(context).pop(
      PaymentInstruction(
        kind: _kind,
        title: title!,
        accountNumber: number,
        // A bank name only belongs to bank and cheque details.
        bankName: _kind == PaymentKind.bank || _kind == PaymentKind.cheque
            ? _value(_bank)
            : null,
        note: _value(_note),
      ),
    );
  }

  Widget _field(
    String id,
    TextEditingController controller,
    String label,
    int maxLength, {
    String? error,
    bool autofocus = false,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: AppDimensions.spacing12),
        child: TextField(
          key: Key('payment-$id'),
          controller: controller,
          autofocus: autofocus,
          maxLength: maxLength,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: label,
            errorText: error,
            counterText: '',
            border: const OutlineInputBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bank = _kind == PaymentKind.bank;
    final cheque = _kind == PaymentKind.cheque;
    return KhataFormDialog(
      title: widget.initial == null
          ? KhataSettingsText.addTitle
          : KhataSettingsText.editTitle,
      submitLabel: KhataSettingsText.done,
      onSubmit: _submit,
      busy: false,
      width: 480,
      children: [
        KhataSegmented<PaymentKind>(
          key: const Key('payment-kind'),
          maxWidth: 480,
          options: [for (final k in PaymentKind.values) (k, k.label)],
          selected: _kind,
          onChanged: (k) => setState(() {
            _kind = k;
            _numberError = null;
          }),
        ),
        _field(
          'title',
          _title,
          cheque
              ? KhataSettingsText.chequeTitle
              : KhataSettingsText.accountTitle,
          100,
          error: _titleError,
          autofocus: true,
        ),
        if (!cheque)
          _field(
            'number',
            _number,
            bank
                ? KhataSettingsText.accountNumber
                : KhataSettingsText.mobileNumber,
            64,
            error: _numberError,
          ),
        if (bank || cheque)
          _field('bank', _bank, KhataSettingsText.bankName, 100),
        _field('note', _note, KhataSettingsText.note, 200),
      ],
    );
  }
}
