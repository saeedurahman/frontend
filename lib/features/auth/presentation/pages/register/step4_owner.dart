import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/presentation/cubit/register_cubit.dart';
import 'package:frantend/features/register/presentation/cubit/register_state.dart';
import 'package:frantend/features/register/presentation/widgets/password_strength_indicator.dart';
import 'package:frantend/features/register/presentation/widgets/plan_selection_card.dart';
import 'package:frantend/features/register/presentation/widgets/register_scaffold.dart';
import 'package:frantend/shared/widgets/inputs/app_text_field.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/app_form_field_validator.dart';
import 'package:frantend/utils/app_phone_no_field.dart';
import 'package:go_router/go_router.dart';

class Step4OwnerPage extends StatefulWidget {
  const Step4OwnerPage({super.key});

  @override
  State<Step4OwnerPage> createState() => _Step4OwnerPageState();
}

class _Step4OwnerPageState extends State<Step4OwnerPage> {
  static const _mobileLabels = [
    'Business',
    'Location',
    'Tax Info',
    'Owner',
    'Done',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        debugPrint('[Step4] BlocListener — state=${state.runtimeType}');
        if (state is RegisterFailure) {
          debugPrint('[Step4] RegisterFailure — message="${state.message}"');
          AppAlerts.showErrorMessage(context, state.message);
        } else if (state is RegisterSuccess) {
          debugPrint('[Step4] RegisterSuccess — navigating to ${RouteNames.registerSuccess}');
          context.go(RouteNames.registerSuccess);
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        debugPrint(
          '[Step4] build — state=${state.runtimeType}, isLoading=$isLoading, '
          'plan=${cubit.data.plan.name}, '
          'formKeyAttached=${cubit.step4FormKey.currentState != null}',
        );
        debugPrint(
          '[Step4] build — wizard data: businessName="${cubit.businessNameController.text}", '
          'city=${cubit.selectedCity}, businessType=${cubit.data.businessType}, '
          'branchName="${cubit.branchNameController.text}"',
        );

        return RegisterScaffold(
          currentStep: 4,
          maxWidth: 560,
          stepLabels: _mobileLabels,
          child: RegisterFormCard(
            child: Form(
              key: cubit.step4FormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Owner Account',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will use this to login to your POS dashboard',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    labelText: 'Full Name',
                    hintText: 'Muhammad Ali',
                    controller: cubit.ownerNameController,
                    enableBorder: true,
                    validator: (v) => AppFormFieldValidator.emptyFieldValidator(
                      v,
                      'Full name is required',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppPhoneNoField(
                    labelText: 'Phone Number (Login ID) *',
                    controller: cubit.ownerPhoneController,
                    initialCountryCode: 'PK',
                    disableLengthCheck: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (v) {
                      cubit.ownerPhoneNumber = v;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      '*This will be your login ID*',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    labelText: 'Password',
                    controller: cubit.passwordController,
                    isPassword: true,
                    enableBorder: true,
                    validator: AppFormFieldValidator.registerPasswordValidator,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use uppercase, lowercase, and numbers (e.g. Abc12345)',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PasswordStrengthIndicator(password: cubit.passwordController.text),
                  const SizedBox(height: 16),
                  AppTextField(
                    labelText: 'Confirm Password',
                    controller: cubit.confirmPasswordController,
                    isPassword: true,
                    enableBorder: true,
                    validator: (v) => AppFormFieldValidator.confirmPasswordValidator(
                      cubit.passwordController.text,
                      v,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Select Your Plan',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, _) {
                      final plan = cubit.data.plan;
                      return Column(
                        children: RegisterPlan.values.map((p) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PlanSelectionCard(
                              plan: p,
                              isSelected: plan == p,
                              onTap: () {
                                debugPrint('[Step4] plan selected — ${p.name}');
                                cubit.setPlan(p);
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: AppDimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _onSubmit(context, cubit),
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
                                  'Complete Registration',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: isLoading ? null : () => context.go(RouteNames.registerStep3),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      text: 'By continuing you agree to ',
                      style: AppTextStyles.bodySmall,
                      children: const [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSubmit(BuildContext context, RegisterCubit cubit) {
    final ownerName = cubit.ownerNameController.text.trim();
    final ownerPhone = cubit.ownerPhoneController.text.trim();
    final password = cubit.passwordController.text;
    final confirm = cubit.confirmPasswordController.text;
    final formState = cubit.step4FormKey.currentState;

    debugPrint('[Step4] onSubmit tapped — button="Complete Registration"');
    debugPrint(
      '[Step4] wizard — businessName="${cubit.businessNameController.text}", '
      'city=${cubit.selectedCity}, businessType=${cubit.data.businessType}, '
      'branchName="${cubit.branchNameController.text}", plan=${cubit.data.plan.name}',
    );
    debugPrint(
      '[Step4] form — currentState=${formState != null ? "attached" : "NULL"}',
    );

    if (ownerName.isEmpty) {
      debugPrint('[Step4] onSubmit BLOCKED — full name empty');
      AppAlerts.showErrorMessage(context, 'Full name is required');
      return;
    }
    if (ownerPhone.isEmpty) {
      debugPrint('[Step4] onSubmit BLOCKED — phone empty');
      AppAlerts.showErrorMessage(context, 'Phone no is required');
      return;
    }
    if (password.isEmpty) {
      debugPrint('[Step4] onSubmit BLOCKED — password empty');
      AppAlerts.showErrorMessage(context, 'Password is required');
      return;
    }
    final passwordError =
        AppFormFieldValidator.registerPasswordValidator(password);
    if (passwordError != null) {
      debugPrint('[Step4] onSubmit BLOCKED — $passwordError');
      AppAlerts.showErrorMessage(context, passwordError);
      return;
    }
    if (password != confirm) {
      debugPrint('[Step4] onSubmit BLOCKED — passwords do not match');
      AppAlerts.showErrorMessage(context, 'Passwords do not match');
      return;
    }

    if (formState != null) {
      final isValid = formState.validate();
      debugPrint('[Step4] formState.validate() => $isValid (logged only, not blocking)');
    } else {
      debugPrint('[Step4] formState is null');
    }

    debugPrint('[Step4] onSubmit calling cubit.submitRegistration()');
    cubit.submitRegistration();
  }
}
