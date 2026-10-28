import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

/// Settings > Security > Change password (current + new password).
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(sl<AuthRepository>()),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.succeeded) {
          AppAlerts.showSuccessMessage(context, 'Password changed');
          if (context.canPop()) context.pop();
        } else if (state.error != null && state.fieldErrors.isEmpty) {
          AppAlerts.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Change password', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your current password, then choose a new one.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    controller: _current,
                    label: 'Current password',
                    error: state.fieldErrors['current_password'],
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _next,
                    label: 'New password',
                    error: state.fieldErrors['new_password'],
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _confirm,
                    label: 'Confirm new password',
                    error: state.fieldErrors['confirm_password'],
                    onSubmitted: (_) => _submit(context),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: state.isSubmitting ? null : () => _submit(context),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Change password'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? error,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<ChangePasswordCubit>().submit(
          current: _current.text,
          next: _next.text,
          confirm: _confirm.text,
        );
  }
}
