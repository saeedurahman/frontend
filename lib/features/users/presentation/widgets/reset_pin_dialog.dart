import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/auth/presentation/widgets/pin_keypad.dart';

/// Result of [ResetPinDialog]: the new PIN plus the re-authentication proof.
class ResetPinResult {
  const ResetPinResult({
    required this.newPin,
    required this.currentPassword,
    this.currentPin,
  });

  final String newPin;
  final String currentPassword;

  /// Only collected when the user is changing their own PIN.
  final String? currentPin;
}

class ResetPinDialog extends StatefulWidget {
  const ResetPinDialog({super.key, this.askCurrentPin = false});

  /// True when changing your own PIN (also asks for the existing PIN).
  final bool askCurrentPin;

  static Future<ResetPinResult?> show(
    BuildContext context, {
    bool askCurrentPin = false,
  }) {
    return showDialog<ResetPinResult>(
      context: context,
      builder: (_) => ResetPinDialog(askCurrentPin: askCurrentPin),
    );
  }

  @override
  State<ResetPinDialog> createState() => _ResetPinDialogState();
}

class _ResetPinDialogState extends State<ResetPinDialog> {
  final _passwordController = TextEditingController();
  final _currentPinController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _currentPinController.dispose();
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _passwordController.text;
    final currentPin = _currentPinController.text.trim();
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty) {
      setState(() => _error = 'Enter your current password');
      return;
    }
    if (widget.askCurrentPin && currentPin.isEmpty) {
      setState(() => _error = 'Enter your current PIN');
      return;
    }
    final pinError = validateNewPin(pin);
    if (pinError != null) {
      setState(() => _error = pinError);
      return;
    }
    if (pin != confirm) {
      setState(() => _error = 'PINs do not match');
      return;
    }

    Navigator.of(context).pop(
      ResetPinResult(
        newPin: pin,
        currentPassword: password,
        currentPin: widget.askCurrentPin ? currentPin : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset PIN'),
      content: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Set a new PIN for this staff member. They will use it at the PIN login screen.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Your current password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          if (widget.askCurrentPin) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _currentPinController,
              decoration: const InputDecoration(
                labelText: 'Your current PIN',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(kMaxPinLength),
              ],
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _pinController,
            decoration: const InputDecoration(
              labelText: 'New PIN (min 6 digits)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(kMaxPinLength),
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
              LengthLimitingTextInputFormatter(kMaxPinLength),
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
      )),
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
