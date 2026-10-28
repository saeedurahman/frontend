import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:go_router/go_router.dart';

/// Settings > Security: change password and the idle auto-lock timeout.
class SecuritySettingsSection extends StatefulWidget {
  const SecuritySettingsSection({super.key});

  @override
  State<SecuritySettingsSection> createState() =>
      _SecuritySettingsSectionState();
}

class _SecuritySettingsSectionState extends State<SecuritySettingsSection> {
  late int _minutes = sl<IdleLockService>().timeoutMinutes;

  static String _label(int minutes) =>
      minutes == 0 ? 'Off' : (minutes == 60 ? '1 hour' : '$minutes min');

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
                leading: const Icon(Icons.lock_clock_outlined,
                    color: AppColors.primary),
                title: const Text('Auto-lock'),
                subtitle: const Text(
                  'Ask for your PIN after inactivity. Cart and held orders are kept.',
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
