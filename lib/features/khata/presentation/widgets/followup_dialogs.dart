import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/utils/currency_label.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_amount.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/utils/app_alerts.dart';

/// "They said they'll pay on Friday." Works offline. True once saved.
Future<bool> showPromiseDialog(
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
      builder: (_) => PromiseDialog(
        repository: repository,
        partyType: partyType,
        partyId: partyId,
        name: name,
        branchId: branchId,
        clock: clock,
      ),
    ) ??
    false;

/// A free note on the account. Works offline. True once saved.
Future<bool> showNoteDialog(
  BuildContext context, {
  required KhataRepository repository,
  required PartyType partyType,
  required String partyId,
  required String name,
  String? branchId,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => NoteDialog(
        repository: repository,
        partyType: partyType,
        partyId: partyId,
        name: name,
        branchId: branchId,
      ),
    ) ??
    false;

/// The frame of the small khata forms: title, who it is about, Cancel and a
/// primary button. Enter saves, Esc closes.
class KhataFormDialog extends StatelessWidget {
  const KhataFormDialog({
    super.key,
    required this.title,
    required this.children,
    required this.submitLabel,
    required this.onSubmit,
    this.subtitle,
    this.busy = false,
    this.error,
    this.width = 440,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final String submitLabel;

  /// Null disables the button.
  final VoidCallback? onSubmit;
  final bool busy;
  final String? error;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppDimensions.spacingLg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.enter, control: true):
                () {
              if (!busy) onSubmit?.call();
            },
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
                const SizedBox(height: AppDimensions.spacingMd),
                ...children,
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: error == null
                      ? const SizedBox(width: double.infinity)
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: AppDimensions.spacing12,
                          ),
                          child: Text(
                            error!,
                            key: const Key('khata-form-error'),
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          busy ? null : () => Navigator.of(context).pop(false),
                      child: const Text(KhataUiText.cancel),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Flexible(
                      child: FilledButton(
                        key: const Key('khata-form-submit'),
                        onPressed: busy ? null : onSubmit,
                        child: busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                submitLabel,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PromiseDialog extends StatefulWidget {
  const PromiseDialog({
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
  State<PromiseDialog> createState() => _PromiseDialogState();
}

class _PromiseDialogState extends State<PromiseDialog> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  DateTime? _date;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  DateTime get _today {
    final now = widget.clock();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _inDays(int days) =>
      DateTime(_today.year, _today.month, _today.day + days);

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? _inDays(7),
      firstDate: _today,
      lastDate: _inDays(730),
    );
    if (picked != null && mounted) {
      setState(() {
        _date = picked;
        _error = null;
      });
    }
  }

  Future<void> _save() async {
    final date = _date;
    if (date == null) {
      setState(() => _error = FollowupText.dateRequired);
      return;
    }
    final typed = _amount.text.trim();
    final amount = typed.isEmpty ? null : KhataAmount.parse(typed);
    if (typed.isNotEmpty && amount == null) {
      setState(() => _error = FollowupText.amountInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final saved = await widget.repository.addFollowup(
      widget.partyType,
      widget.partyId,
      kind: FollowupKind.promise,
      promiseDate: date,
      promiseAmount: amount,
      message: _note.text,
      branchId: widget.branchId,
    );
    if (!mounted) return;
    saved.fold(
      (f) => setState(() {
        _busy = false;
        _error = f.message;
      }),
      (_) {
        AppAlerts.showSuccessMessage(
          context,
          widget.repository.isOnline
              ? FollowupText.promiseSaved
              : FollowupText.savedOffline,
        );
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quick = [
      (FollowupText.tomorrow, _inDays(1)),
      (FollowupText.inAWeek, _inDays(7)),
      (FollowupText.inAMonth, _inDays(30)),
    ];
    return KhataFormDialog(
      title: FollowupText.promiseTitle,
      subtitle: widget.name,
      submitLabel: FollowupText.savePromise,
      busy: _busy,
      error: _error,
      onSubmit: _save,
      children: [
        const Text(FollowupText.promiseHelp),
        const SizedBox(height: AppDimensions.spacingSm),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            for (final (label, date) in quick)
              ChoiceChip(
                label: Text(label),
                selected: _date == date,
                onSelected: (_) => setState(() {
                  _date = date;
                  _error = null;
                }),
              ),
            ActionChip(
              key: const Key('promise-pick-date'),
              avatar: const Icon(Icons.event_outlined, size: 16),
              label: Text(
                _date == null
                    ? FollowupText.pickDate
                    : KhataFormat.fullDay(_date!),
              ),
              onPressed: _pick,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        TextField(
          key: const Key('promise-amount'),
          controller: _amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: FollowupText.amountOptional,
            prefixText: '$currencyLabel ',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        TextField(
          key: const Key('promise-note'),
          controller: _note,
          maxLength: 1000,
          onSubmitted: (_) => _save(),
          decoration: const InputDecoration(
            labelText: FollowupText.noteOptional,
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class NoteDialog extends StatefulWidget {
  const NoteDialog({
    super.key,
    required this.repository,
    required this.partyType,
    required this.partyId,
    required this.name,
    this.branchId,
  });

  final KhataRepository repository;
  final PartyType partyType;
  final String partyId;
  final String name;
  final String? branchId;

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _note = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_note.text.trim().isEmpty) {
      setState(() => _error = FollowupText.noteRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final saved = await widget.repository.addFollowup(
      widget.partyType,
      widget.partyId,
      kind: FollowupKind.note,
      message: _note.text,
      branchId: widget.branchId,
    );
    if (!mounted) return;
    saved.fold(
      (f) => setState(() {
        _busy = false;
        _error = f.message;
      }),
      (_) {
        AppAlerts.showSuccessMessage(
          context,
          widget.repository.isOnline
              ? FollowupText.noteSaved
              : FollowupText.savedOffline,
        );
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) => KhataFormDialog(
        title: FollowupText.noteTitle,
        subtitle: widget.name,
        submitLabel: FollowupText.saveNote,
        busy: _busy,
        error: _error,
        onSubmit: _save,
        children: [
          TextField(
            key: const Key('note-text'),
            controller: _note,
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            maxLength: 1000,
            decoration: const InputDecoration(
              labelText: FollowupText.noteLabel,
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
}
