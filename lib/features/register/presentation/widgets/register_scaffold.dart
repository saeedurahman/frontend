import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/register/presentation/widgets/register_stepper.dart';
import 'package:frantend/utils/responsive/responsive.dart';

/// Shared layout shell for all registration wizard steps.
class RegisterScaffold extends StatelessWidget {
  const RegisterScaffold({
    super.key,
    required this.currentStep,
    required this.child,
    this.title,
    this.subtitle,
    this.showHeaderActions = false,
    this.bottomNavigation,
    this.stepLabels,
    this.maxWidth = 720,
  });

  final int currentStep;
  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showHeaderActions;
  final Widget? bottomNavigation;
  final List<String>? stepLabels;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _RegisterHeader(
              showActions: showHeaderActions,
              isMobile: isMobile,
            ),
            RegisterStepper(
              currentStep: currentStep,
              compactLabels: stepLabels,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      children: [
                        if (title != null) ...[
                          Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontSize: isMobile ? 24 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              subtitle!,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (bottomNavigation != null) bottomNavigation!,
            _RegisterFooter(isMobile: isMobile),
          ],
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader({
    required this.showActions,
    required this.isMobile,
  });

  final bool showActions;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 12,
      ),
      child: Row(
        children: [
          Text(
            'PakPOS',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 22 : 26,
            ),
          ),
          if (!isMobile && showActions) ...[
            Container(
              height: 24,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColors.border,
            ),
            Text(
              'REGISTER BUSINESS',
              style: AppTextStyles.bodySmall.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const Spacer(),
          if (showActions) ...[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.help_outline_rounded),
              color: AppColors.textSecondary,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Save & Exit'),
            ),
          ] else
            TextButton(
              onPressed: () {},
              child: const Text('Support'),
            ),
        ],
      ),
    );
  }
}

class _RegisterFooter extends StatelessWidget {
  const _RegisterFooter({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.surface,
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  '© 2024 PakPOS Solutions • Security Verified',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'END-TO-END ENCRYPTED REGISTRATION',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 9,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PakPOS — Empowering Pakistani Businesses with Enterprise-Grade SaaS.',
                  style: AppTextStyles.bodySmall,
                ),
                Row(
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Privacy Policy')),
                    TextButton(onPressed: () {}, child: const Text('Support')),
                    TextButton(onPressed: () {}, child: const Text('Terms of Service')),
                  ],
                ),
              ],
            ),
    );
  }
}

/// Bottom navigation bar with Back / Next buttons used on steps 2–4.
class RegisterBottomNav extends StatelessWidget {
  const RegisterBottomNav({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.stepLabel,
    this.nextLabel = 'Next Step',
    this.isLoading = false,
  });

  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String stepLabel;
  final String nextLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NextButton(
                  label: nextLabel,
                  onPressed: isLoading ? null : onNext,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 12),
                _BackButton(onPressed: onBack),
              ],
            )
          : Row(
              children: [
                _BackButton(onPressed: onBack),
                const Spacer(),
                Text(
                  stepLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 24),
                _NextButton(
                  label: nextLabel,
                  onPressed: isLoading ? null : onNext,
                  isLoading: isLoading,
                ),
              ],
            ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
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
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_rounded, size: 18),
          SizedBox(width: 6),
          Text('Back'),
        ],
      ),
    );
  }
}

/// White card container used for form steps.
class RegisterFormCard extends StatelessWidget {
  const RegisterFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: const Border(
          top: BorderSide(color: AppColors.primary, width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: child,
    );
  }
}
