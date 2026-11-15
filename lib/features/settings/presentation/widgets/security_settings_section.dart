import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/security/pin_security_service.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/presentation/widgets/pin_keypad.dart';
import 'package:frantend/features/users/domain/repositories/users_repository.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

/// Settings > Security: change password, set terminal PIN, and idle auto-lock timeout.
class SecuritySettingsSection extends StatefulWidget {
  const SecuritySettingsSection({super.key});

  @override
  State<SecuritySettingsSection> createState() =>
      _SecuritySettingsSectionState();
}

class _SecuritySettingsSectionState extends State<SecuritySettingsSection> {
  late int _minutes = sl<IdleLockService>().timeoutMinutes;
  bool _hasPin = false;
  bool _loadingPin = true;

  @override
  void initState() {
    super.initState();
    _loadPinStatus();
  }

  Future<void> _loadPinStatus() async {
    final userId = await sl<SecureStorage>().getUserId();
    final cache = sl.isRegistered<PinDeviceCache>()
        ? await sl<PinDeviceCache>().read()
        : null;
    final slug = cache?.businessSlug.trim() ?? '';
    if (userId != null && sl.isRegistered<PinSecurityService>()) {
      final hasPin =
          await sl<PinSecurityService>().hasPin(userId: userId, slug: slug);
      if (mounted) {
        setState(() {
          _hasPin = hasPin;
          _loadingPin = false;
        });
      }
    } else {
      if (mounted) setState(() => _loadingPin = false);
    }
  }

  static String _label(int minutes) =>
      minutes == 0 ? 'Off' : (minutes == 60 ? '1 hour' : '$minutes min');

  Future<void> _showSetPinDialog() async {
    final currentPasswordController = TextEditingController();
    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    bool obscurePassword = true;
    bool obscurePin = true;
    bool busy = false;
    String? dialogError;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(_hasPin ? 'Change Terminal PIN' : 'Set Terminal PIN'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your current account password is required to set or change your terminal PIN.',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: currentPasswordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Current Password *',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setDialogState(
                            () => obscurePassword = !obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pinController,
                    obscureText: obscurePin,
                    keyboardType: TextInputType.number,
                    maxLength: kMaxPinLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'New 6-digit PIN *',
                      prefixIcon: const Icon(Icons.dialpad_outlined),
                      counterText: '',
                      suffixIcon: IconButton(
                        icon: Icon(obscurePin
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setDialogState(() => obscurePin = !obscurePin),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmController,
                    obscureText: obscurePin,
                    keyboardType: TextInputType.number,
                    maxLength: kMaxPinLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Confirm New PIN *',
                      prefixIcon: const Icon(Icons.dialpad_outlined),
                      counterText: '',
                    ),
                  ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      dialogError!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: busy
                  ? null
                  : () async {
                      final currentPassword =
                          currentPasswordController.text.trim();
                      final pin = pinController.text.trim();
                      final confirm = confirmController.text.trim();

                      if (currentPassword.isEmpty) {
                        setDialogState(() => dialogError =
                            'Please enter your current account password');
                        return;
                      }

                      final pinValidation = validateNewPin(pin);
                      if (pinValidation != null) {
                        setDialogState(() => dialogError = pinValidation);
                        return;
                      }

                      if (pin != confirm) {
                        setDialogState(
                            () => dialogError = 'PINs do not match');
                        return;
                      }

                      setDialogState(() {
                        busy = true;
                        dialogError = null;
                      });

                      final userId = await sl<SecureStorage>().getUserId();
                      if (userId == null) {
                        setDialogState(() {
                          busy = false;
                          dialogError = 'User session not found';
                        });
                        return;
                      }

                      final result =
                          await sl<UsersRepository>().resetUserPin(
                        id: userId,
                        pinCode: pin,
                        currentPassword: currentPassword,
                      );

                      if (!ctx.mounted) return;

                      if (result.isLeft()) {
                        final failure = result
                            .swap()
                            .getOrElse(() => AuthFailure('Failed to set PIN'));
                        setDialogState(() {
                          busy = false;
                          dialogError = failure.message;
                        });
                        return;
                      }

                      Navigator.of(ctx).pop();
                      await _loadPinStatus();
                      if (mounted) {
                        AppAlerts.showSuccessMessage(
                          context,
                          'PIN set successfully. Auto-lock is now active.',
                        );
                      }
                    },
              child: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save PIN'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.border),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Security', style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              ListTile(
                shape: border,
                leading: const Icon(Icons.password_outlined,
                    color: AppColors.primary),
                title: const Text('Change password'),
                subtitle: const Text('Requires your current password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.changePassword),
              ),
              ListTile(
                shape: border,
                leading: const Icon(Icons.pin_outlined,
                    color: AppColors.primary),
                title: const Text('Terminal PIN'),
                subtitle: Text(
                  _loadingPin
                      ? 'Checking PIN status...'
                      : (_hasPin
                          ? 'PIN is set for quick terminal unlock.'
                          : 'No PIN set. Set a PIN to enable idle auto-lock.'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _hasPin
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _hasPin ? 'Set' : 'Not set',
                        style: TextStyle(
                          color: _hasPin
                              ? AppColors.success
                              : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _loadingPin ? null : _showSetPinDialog,
                      child: Text(_hasPin ? 'Change PIN' : 'Set PIN'),
                    ),
                  ],
                ),
              ),
              ListTile(
                shape: border,
                leading: const Icon(Icons.lock_clock_outlined,
                    color: AppColors.primary),
                title: const Text('Auto-lock'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Protects your terminal when you step away. If inactive, the screen locks so unauthorized staff or customers cannot tamper with your registers. Your open cart, held orders, and work are kept safe.',
                      style: TextStyle(fontSize: 13),
                    ),
                    if (!_hasPin && !_loadingPin) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Note: Auto-lock is disabled until you set a PIN above, so you will never be locked out.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: DropdownButton<int>(
                  value: IdleLockService.timeoutChoices.contains(_minutes)
                      ? _minutes
                      : null,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final m in IdleLockService.timeoutChoices)
                      DropdownMenuItem(value: m, child: Text(_label(m))),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    setState(() => _minutes = value);
                    await sl<IdleLockService>().setTimeoutMinutes(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

