import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_state.dart';
import 'package:frantend/features/auth/presentation/cubit/pin_login_cubit.dart';
import 'package:frantend/features/auth/presentation/cubit/pin_login_state.dart';
import 'package:frantend/features/auth/presentation/widgets/pin_keypad.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class PinLoginPage extends StatelessWidget {
  const PinLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocProvider(
        create: (_) => sl<PinLoginCubit>()..init(),
        child: const _PinLoginView(),
      ),
    );
  }
}

class _PinLoginView extends StatefulWidget {
  const _PinLoginView();

  @override
  State<_PinLoginView> createState() => _PinLoginViewState();
}

class _PinLoginViewState extends State<_PinLoginView> {
  String _pin = '';

  void _resetPin() => setState(() => _pin = '');

  void _onDigit(String digit) {
    if (_pin.length >= 6) return;
    setState(() => _pin += digit);
    if (_pin.length == 6) {
      _trySubmit();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _trySubmit() {
    if (!isValidPin(_pin)) return;

    final pinState = context.read<PinLoginCubit>().state;
    if (pinState is! PinLoginReady) return;

    context.read<AuthCubit>().pinLogin(
          businessSlug: pinState.businessSlug,
          userId: pinState.selectedStaffId,
          pin: _pin,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authLoading = context.watch<AuthCubit>().state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) {
              sl<NotificationsCubit>().startSession();
              sl<BranchSelectorCubit>().startSession();
              context.go(RouteNames.dashboard);
            },
            error: (message) {
              AppAlerts.showErrorMessage(context, message);
              _resetPin();
            },
            orElse: () {},
          );
        },
        builder: (context, authState) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: BlocBuilder<PinLoginCubit, PinLoginState>(
                  builder: (context, pinState) {
                    return switch (pinState) {
                      PinLoginInitial() || PinLoginLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      PinLoginNeedsSetup() => const _NeedsSetupView(),
                      PinLoginReady ready => _ReadyView(
                          state: ready,
                          pin: _pin,
                          isLoading: authLoading,
                          onDigit: _onDigit,
                          onBackspace: _onBackspace,
                          onSubmit: _trySubmit,
                        ),
                    };
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NeedsSetupView extends StatelessWidget {
  const _NeedsSetupView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PinHeader(),
        const SizedBox(height: AppDimensions.spacingXl),
        Icon(
          Icons.dialpad_rounded,
          size: 56,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Text(
          'PIN login not set up',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        const Text(
          'Sign in with your password first to set up PIN login on this device.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: () => context.go(RouteNames.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Back to password login'),
          ),
        ),
      ],
    );
  }
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({
    required this.state,
    required this.pin,
    required this.isLoading,
    required this.onDigit,
    required this.onBackspace,
    required this.onSubmit,
  });

  final PinLoginReady state;
  final String pin;
  final bool isLoading;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PinHeader(),
        const SizedBox(height: AppDimensions.spacingXl),
        Text(
          'Quick PIN Login',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Select your name and enter your PIN',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        _BusinessSlugTile(slug: state.businessSlug),
        const SizedBox(height: AppDimensions.spacingMd),
        DropdownButtonFormField<String>(
          value: state.selectedStaffId,
          decoration: const InputDecoration(
            labelText: 'Staff member',
            border: OutlineInputBorder(),
          ),
          items: state.staff
              .map(
                (member) => DropdownMenuItem<String>(
                  value: member.id,
                  child: Text(member.fullName),
                ),
              )
              .toList(),
          onChanged: isLoading
              ? null
              : (value) {
                  if (value != null) {
                    context.read<PinLoginCubit>().selectStaff(value);
                  }
                },
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        PinKeypad(
          pinLength: pin.length,
          enabled: !isLoading,
          onDigit: onDigit,
          onBackspace: onBackspace,
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: isLoading || !isValidPin(pin) ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textOnPrimary,
                    ),
                  )
                : const Text('Login with PIN'),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        TextButton(
          onPressed: isLoading ? null : () => context.go(RouteNames.login),
          child: const Text('Back to password login'),
        ),
      ],
    );
  }
}

class _BusinessSlugTile extends StatelessWidget {
  const _BusinessSlugTile({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.store_outlined, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Business',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  slug,
                  style: AppTextStyles.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PinHeader extends StatelessWidget {
  const _PinHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.star_rounded,
            color: AppColors.textOnPrimary,
            size: 42,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'PakPOS',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
      ],
    );
  }
}
