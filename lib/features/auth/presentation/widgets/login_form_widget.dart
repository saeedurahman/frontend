import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frantend/shared/widgets/inputs/app_text_field.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/app_form_field_validator.dart';
import 'package:frantend/utils/app_phone_no_field.dart';
import 'package:go_router/go_router.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  void _handleLogin(AuthCubit cubit) {
    final complete = cubit.phoneNumber?.completeNumber;
    final hasPhone = cubit.phoneController.text.trim().isNotEmpty ||
        (complete != null && complete.isNotEmpty);
    if (!hasPhone) {
      AppAlerts.showErrorMessage(context, 'Phone no is required');
      return;
    }
    if (cubit.passwordController.text.isEmpty) {
      AppAlerts.showErrorMessage(context, 'Password is required');
      return;
    }
    cubit.login();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final isLoading = context.watch<AuthCubit>().state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _FormHeader(),
          const SizedBox(height: AppDimensions.spacingXl),
          Text(
            ' WELCOME BACK',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            'Apne account mein login karein',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          AppPhoneNoField(
            labelText: 'Mobile No. *',
            controller: cubit.phoneController,
            initialCountryCode: 'PK',
            disableLengthCheck: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => cubit.phoneNumber = value,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          AppTextField(
            labelText: 'Password *',
            hintText: 'Enter Password',
            controller: cubit.passwordController,
            isPassword: true,
            enableBorder: true,
            maxLine: 1,
            validator: AppFormFieldValidator.passwordValidator,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: cubit.rememberMe,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() => cubit.setRememberMe(value ?? false));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Yaad rakhein',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Password bhool gaye?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          SizedBox(
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => _handleLogin(cubit),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
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
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.login_rounded, size: 20),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppDimensions.spacingLg),
          Material(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: InkWell(
              onTap: () => context.go(RouteNames.pinLogin),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingMd,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.dialpad_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(
                      child: Text(
                        'PIN se Login Karein',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Naya business? ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(RouteNames.register),
                child: Text(
                  'Register karein',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

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
