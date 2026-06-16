import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/presentation/cubit/register_cubit.dart';
import 'package:frantend/features/register/presentation/cubit/register_state.dart';
import 'package:frantend/features/register/presentation/widgets/register_scaffold.dart';
import 'package:go_router/go_router.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

  static const _finishLabels = [
    'BUSINESS',
    'BRANCH',
    'PLAN',
    'OWNER',
    'FINISH',
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterCubit>().state;
    final data = state is RegisterSuccess
        ? state.data
        : context.read<RegisterCubit>().data;

    String? businessTypeTitle;
    for (final t in kBusinessTypes) {
      if (t.id == data.businessType) {
        businessTypeTitle = t.title;
        break;
      }
    }

    return RegisterScaffold(
      currentStep: 5,
      maxWidth: 520,
      stepLabels: _finishLabels,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.branchColor.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 12),
            const Text('🌙 ⭐', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text(
              'Mubarak Ho! 🎉',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${data.businessName.isNotEmpty ? data.businessName : 'Your business'} is now live on PakPOS',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.branchColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                children: [
                  _SummaryRow('Business', data.businessName),
                  const Divider(height: 20),
                  _SummaryRow(
                    'Branch',
                    data.branchName.isNotEmpty ? data.branchName : 'Main Branch',
                  ),
                  const Divider(height: 20),
                  _SummaryRow(
                    'Plan',
                    data.plan.label,
                    trailing: const Icon(
                      Icons.workspace_premium_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                  ),
                  const Divider(height: 20),
                  _SummaryRow('Owner', data.ownerName),
                  if (businessTypeTitle != null) ...[
                    const Divider(height: 20),
                    _SummaryRow('Type', businessTypeTitle),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () => context.go(RouteNames.dashboard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Go to Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Text('Take a Quick Tour'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sms_rounded, color: AppColors.info, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Setup guide sent to your phone via SMS',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.point_of_sale_rounded, color: AppColors.primary, size: 28),
                const SizedBox(width: 8),
                Text(
                  'PakPOS',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ENTERPRISE RETAIL SOLUTIONS',
              style: AppTextStyles.bodySmall.copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          )),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        if (trailing != null) ...[const SizedBox(width: 6), trailing!],
      ],
    );
  }
}
