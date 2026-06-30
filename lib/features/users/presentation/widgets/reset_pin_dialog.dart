import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';

class ResetPinDialog extends StatefulWidget {
  const ResetPinDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ResetPinDialog(),
    );
  }

  @override
  State<ResetPinDialog> createState() => _ResetPinDialogState();
}

class _ResetPinDialogState extends State<ResetPinDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pin.length < 4 || pin.length > 6) {
      setState(() => _error = 'PIN must be 4–6 digits');
      return;
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      setState(() => _error = 'PIN must contain digits only');
      return;
    }
    if (pin != confirm) {
      setState(() => _error = 'PINs do not match');
      return;
    }

    Navigator.of(context).pop(pin);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Set a new PIN for this staff member. They will use it at the PIN login screen.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            decoration: const InputDecoration(
              labelText: 'New PIN',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmController,
            decoration: const InputDecoration(
              labelText: 'Confirm PIN',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Reset PIN'),
        ),
      ],
    );
  }
}
