import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/currency_label.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart'
    show khataIsoDay;
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/khata_amount.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/retry_key.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/widgets/credit_blocked_notice.dart';
import 'package:frantend/features/khata/presentation/widgets/followup_dialogs.dart'
    show KhataFormDialog;
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';
import 'package:frantend/features/khata/presentation/widgets/opening_balance_fields.dart';
import 'package:frantend/shared/widgets/inputs/synced_text_field.dart';
import 'package:frantend/utils/app_alerts.dart';

/// "Add opening balance" for an existing account. True once saved.
Future<bool> showOpeningBalanceDialog(
  BuildContext context, {
  required KhataRepository repository,
  required PartyType partyType,
  required String partyId,
  required String name,
  String? branchId,
  DateTime Function() clock = DateTime.now,
}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => OpeningBalanceDialog(
        repository: repository,
        partyType: partyType,
        partyId: partyId,
        name: name,
        branchId: branchId,
        clock: clock,
      ),
    ) ??
    false;

/// Udhaar, goods on credit or an adjustment. True once saved.
Future<bool> showManualEntryDialog(
  BuildContext context, {
  required KhataRepository repository,
  required PartyType partyType,
  required String partyId,
  required String name,
  required ManualKind kind,
  String? branchId,
  DateTime Function() clock = DateTime.now,
}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ManualEntryDialog(
        repository: repository,
        partyType: partyType,
        partyId: partyId,
        name: name,
        kind: kind,
        branchId: branchId,
        clock: clock,
      ),
    ) ??
    false;

String _words(Failure failure) {
  if (failure is NetworkFailure) return EntryText.offline;
  return EntryText.forCode(failure.code) ??
      KhataText.forCode(failure.code) ??
      failure.message;
}

class OpeningBalanceDialog extends StatefulWidget {
  const OpeningBalanceDialog({
    super.key,
    required this.repository,
    required this.partyType,
    required this.partyId,
    required this.name,
    this.branchId,
    this.clock = DateTime.now,
  });

  final KhataRepository repository;
  final PartyType partyType;
  final String partyId;
  final String name;
  final String? branchId;
  final DateTime Function() clock;

  @override
  State<OpeningBalanceDialog> createState() => _OpeningBalanceDialogState();
}

class _OpeningBalanceDialogState extends State<OpeningBalanceDialog> {
  late OpeningBalanceDraft _draft =
      OpeningBalanceDraft.empty(widget.partyType, widget.clock());
  final _key = RetryKey();
  String? _amountError;
  String? _error;
  bool _busy = false;

  Future<void> _save() async {
    if (_busy) return;
    if (_draft.amount == null) {
      setState(() => _amountError = EntryText.amountRequired);
      return;
    }
    setState(() {
      _busy = true;
      _amountError = null;
      _error = null;
    });
    final body = _draft.toJson(branchId: widget.branchId);
    final result = await widget.repository.openingBalance(
      widget.partyType,
      widget.partyId,
      body,
      idempotencyKey: _key.keyFor(body),
    );
    _key.settle(result.fold((f) => f, (_) => null));
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _busy = false;
        _error = _words(failure);
      }),
      (_) {
        AppAlerts.showSuccessMessage(context, EntryText.openingSaved);
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) => KhataFormDialog(
        title: EntryText.addOpening,
        subtitle: widget.name,
        submitLabel: EntryText.saveOpening,
        busy: _busy,
        error: _error,
        onSubmit: _save,
        width: 480,
        children: [
          OpeningBalanceFields(
            type: widget.partyType,
            value: _draft,
            amountError: _amountError,
            autofocus: true,
            clock: widget.clock,
            onChanged: (draft) => setState(() {
              _draft = draft;
              _amountError = null;
            }),
          ),
        ],
      );
}

class ManualEntryDialog extends StatefulWidget {
  const ManualEntryDialog({
    super.key,
    required this.repository,
    required this.partyType,
    required this.partyId,
    required this.name,
    required this.kind,
    this.branchId,
    this.clock = DateTime.now,
  });

  final KhataRepository repository;
  final PartyType partyType;
  final String partyId;
  final String name;

  /// An adjustment kind opens with the "more / less" choice.
  final ManualKind kind;
  final String? branchId;
  final DateTime Function() clock;

  @override
  State<ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<ManualEntryDialog> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _key = RetryKey();
  late ManualKind _kind = widget.kind;

  /// Null means today.
  DateTime? _date;
  String? _amountError;
  String? _noteError;
  String? _error;
  CreditNumbers? _credit;
  bool _overLimit = false;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = widget.clock();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: today,
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  /// A changed amount is a new question for the credit limit.
  void _changed() => setState(() {
        _amountError = null;
        _noteError = null;
        _error = null;
        _overLimit = false;
        _credit = null;
      });

  Future<void> _save({bool creditOverride = false}) async {
    if (_busy) return;
    final amount = KhataAmount.parse(_amount.text);
    final note = _note.text.trim();
    setState(() {
      _amountError = amount == null ? EntryText.amountRequired : null;
      _noteError = note.isEmpty ? EntryText.noteRequired : null;
    });
    if (amount == null || note.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'kind': _kind.apiValue,
      'amount': amount,
      'note': note,
      if (_date != null) 'date': khataIsoDay(_date!),
      if (widget.branchId != null) 'branch_id': widget.branchId,
      if (creditOverride) 'credit_override': true,
    };
    final result = await widget.repository.manualEntry(
      widget.partyType,
      widget.partyId,
      body,
      idempotencyKey: _key.keyFor(body),
    );
    _key.settle(result.fold((f) => f, (_) => null));
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _busy = false;
        if (failure.code == KhataText.creditLimitCode) {
          _overLimit = true;
          _credit = failure is ServerFailure ? failure.credit : null;
          _error = null;
        } else {
          _error = _words(failure);
        }
      }),
      (_) {
        AppAlerts.showSuccessMessage(context, EntryText.saved);
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final credit = _credit;
    return KhataFormDialog(
      title: EntryText.title(_kind),
      subtitle: widget.name,
      submitLabel: EntryText.save,
      busy: _busy,
      error: _error,
      // Over the limit, only "Allow anyway" (or a smaller amount) goes on.
      onSubmit: _overLimit ? null : _save,
      width: 480,
      children: [
        Text(EntryText.help(widget.partyType, _kind)),
        const SizedBox(height: AppDimensions.spacingMd),
        if (_kind.isAdjustment) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: KhataSegmented<ManualKind>(
              key: const Key('entry-direction'),
              maxWidth: 320,
              options: [
                (
                  ManualKind.adjustmentIncrease,
                  EntryText.increase(widget.partyType),
                ),
                (
                  ManualKind.adjustmentDecrease,
                  EntryText.decrease(widget.partyType),
                ),
              ],
              selected: _kind,
              onChanged: (kind) => setState(() => _kind = kind),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
        ],
        TextField(
          key: const Key('entry-amount'),
          controller: _amount,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [NumberInputFormatter()],
          textInputAction: TextInputAction.next,
          onChanged: (_) => _changed(),
          decoration: InputDecoration(
            labelText: EntryText.amount,
            prefixText: '$currencyLabel ',
            errorText: _amountError,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        TextField(
          key: const Key('entry-note'),
          controller: _note,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() => _noteError = null),
          onSubmitted: (_) {
            if (!_overLimit) _save();
          },
          decoration: InputDecoration(
            labelText: EntryText.note,
            hintText: EntryText.noteHint,
            errorText: _noteError,
            border: const OutlineInputBorder(),
            counterText: '',
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            key: const Key('entry-date'),
            onPressed: _busy ? null : _pickDate,
            icon: const Icon(Icons.event_outlined, size: 16),
            label: Text(
              '${EntryText.date}: '
              '${_date == null ? EntryText.today : KhataFormat.fullDay(_date!)}',
            ),
          ),
        ),
        if (_overLimit) ...[
          const SizedBox(height: AppDimensions.spacing12),
          CreditBlockedNotice(
            message: KhataText.creditBlockedNoNumbers,
            numbers: credit,
            describe: (n) => EntryText.creditBody(
              limit: formatPKR(n.limit),
              balance: CreditBlockedNotice.balanceWords(n.balance),
              wouldBe: CreditBlockedNotice.balanceWords(n.wouldBe),
            ),
            noOverrideText: EntryText.creditNoOverride,
            onAllowAnyway: _busy ? null : () => _save(creditOverride: true),
          ),
        ],
      ],
    );
  }
}
