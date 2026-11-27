import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';

/// Asks why a payment is being reversed, then calls [onSubmit].
///
/// [onSubmit] returns null on success or a plain-words error to show in the
/// dialog (the dialog stays open so the reason is not lost). A payment is never
/// deleted: the money is returned in the books and the original row stays.
class ReversePaymentDialog extends StatefulWidget {
  const ReversePaymentDialog({
    super.key,
    required this.summary,
    required this.onSubmit,
    this.title = KhataText.reverseTitle,
    this.explain = KhataText.reverseExplain,
    this.keepLabel = 'Keep payment',
    this.confirmLabel = KhataText.reverseConfirm,
  });

  final String title;
  final String explain;
  final String keepLabel;
  final String confirmLabel;

  /// "Rs. 500.00 paid to Al Shifa on 25 Nov".
  final String summary;
  final Future<String?> Function(String reason) onSubmit;

  static Future<bool> show(
    BuildContext context, {
    required String summary,
    required Future<String?> Function(String reason) onSubmit,
    String title = KhataText.reverseTitle,
    String explain = KhataText.reverseExplain,
    String keepLabel = 'Keep payment',
    String confirmLabel = KhataText.reverseConfirm,
  }) async {
    final done = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ReversePaymentDialog(
        summary: summary,
        onSubmit: onSubmit,
        title: title,
        explain: explain,
        keepLabel: keepLabel,
        confirmLabel: confirmLabel,
      ),
    );
    return done ?? false;
  }

  @override
  State<ReversePaymentDialog> createState() => _ReversePaymentDialogState();
}

class _ReversePaymentDialogState extends State<ReversePaymentDialog> {
  final _reason = TextEditingController();
  bool _busy = false;
  bool _touched = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  bool get _reasonOk => _reason.text.trim().length >= 3;

  Future<void> _submit() async {
    setState(() {
      _touched = true;
      _error = null;
    });
    if (!_reasonOk) return;
    setState(() => _busy = true);
    final error = await widget.onSubmit(_reason.text.trim());
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          const Icon(Icons.undo, color: AppColors.warning),
          const SizedBox(width: 10),
          Flexible(child: Text(widget.title)),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.summary,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              widget.explain,
              key: const ValueKey('reverse_explain'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('reverse_reason'),
              controller: _reason,
              autofocus: true,
              maxLines: 2,
              maxLength: 500,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: KhataText.reasonLabel,
                errorText: _touched && !_reasonOk ? KhataText.reasonRequired : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (_error != null)
              Container(
                key: const ValueKey('reverse_error'),
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.error)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: Text(widget.keepLabel),
        ),
        FilledButton(
          key: const ValueKey('reverse_confirm'),
          onPressed: _busy ? null : _submit,
          style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
