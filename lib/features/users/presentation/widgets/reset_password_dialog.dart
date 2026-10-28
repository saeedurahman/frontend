import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

/// Minimum length enforced client-side; the server stays the authority.
const kMinStaffPasswordLength = 8;

/// Returns an error message for an invalid new password, or null when valid.
String? validateNewStaffPassword(String password, String confirm) {
  if (password.isEmpty) return 'Enter a new password';
  if (password.length < kMinStaffPasswordLength) {
    return 'Password must be at least $kMinStaffPasswordLength characters';
  }
  if (password != confirm) return 'Passwords do not match';
  return null;
}

/// Owner/manager sets a new password for a staff member. Pops the password.
class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ResetPasswordDialog(),
    );
  }

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = validateNewStaffPassword(
      _passwordController.text,
      _confirmController.text,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set a new password for this staff member. Share it with them '
              'securely; they can change it after signing in.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'New password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Reset password')),
      ],
    );
  }
}
