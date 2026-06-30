import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/register/presentation/cubit/register_cubit.dart';
import 'package:frantend/features/register/presentation/widgets/register_scaffold.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/app_form_field_validator.dart';
import 'package:frantend/utils/app_phone_no_field.dart';
import 'package:go_router/go_router.dart';

class Step3BranchPage extends StatelessWidget {
  const Step3BranchPage({super.key});

  static const _mobileLabels = [
    'Identity',
    'Business',
    'Branch Info',
    'Staffing',
    'Done',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    debugPrint(
      '[Step3] build — branchName="${cubit.branchNameController.text}", '
      'formKeyAttached=${cubit.step3FormKey.currentState != null}',
    );

    return RegisterScaffold(
      currentStep: 3,
      maxWidth: 560,
      stepLabels: _mobileLabels,
      child: RegisterFormCard(
        child: Form(
          key: cubit.step3FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your First Branch',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This is where your business operates',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              _FieldLabel('Branch Name'),
              TextFormField(
                controller: cubit.branchNameController,
                validator: (v) {
                  final error = AppFormFieldValidator.emptyFieldValidator(
                    v,
                    'Branch name is required',
                  );
                  debugPrint('[Step3] branchName validator — value="$v", error=$error');
                  return error;
                },
                decoration: _decoration('e.g., Main Branch, Gulberg Branch'),
              ),
              const SizedBox(height: 20),
              _FieldLabel('Address (optional)'),
              TextFormField(
                controller: cubit.addressController,
                decoration: _decoration(
                  'Street address',
                  prefix: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(height: 20),
              AppPhoneNoField(
                labelText: 'Branch Phone (optional)',
                controller: cubit.branchPhoneController,
                initialCountryCode: 'PK',
                disableLengthCheck: true,
                autovalidateMode: AutovalidateMode.disabled,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                child: Container(
                  height: 140,
                  color: AppColors.inputFill,
                  alignment: Alignment.center,
                  child: Text(
                    'BUSINESS ENVIRONMENT PREVIEW',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => _onContinue(context, cubit),
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
                      Text('Continue to Step 4', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(RouteNames.registerStep2),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Text(
                  'PAKPOS ENTERPRISE SOLUTIONS • SECURE CLOUD INFRASTRUCTURE',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue(BuildContext context, RegisterCubit cubit) {
    final branchName = cubit.branchNameController.text;
    final branchNameTrimmed = branchName.trim();
    final formState = cubit.step3FormKey.currentState;

    debugPrint('[Step3] onContinue tapped — button="Continue to Step 4"');
    debugPrint(
      '[Step3] fields — branchName="$branchName", trimmed="$branchNameTrimmed"',
    );
    debugPrint(
      '[Step3] form — currentState=${formState != null ? "attached" : "NULL"}, '
      'cubit.data.branchName="${cubit.data.branchName}"',
    );

    if (branchNameTrimmed.isEmpty) {
      debugPrint('[Step3] onContinue BLOCKED — manual check: branch name empty');
      AppAlerts.showErrorMessage(context, 'Branch name is required');
      return;
    }

    if (formState == null) {
      debugPrint('[Step3] onContinue BLOCKED — step3FormKey.currentState is null');
      return;
    }

    final isValid = formState.validate();
    debugPrint('[Step3] formState.validate() => $isValid');

    if (isValid) {
      debugPrint('[Step3] onContinue proceeding to ${RouteNames.registerStep4}');
      context.go(RouteNames.registerStep4);
    } else {
      debugPrint('[Step3] onContinue BLOCKED — form validation failed (no snackbar shown)');
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

InputDecoration _decoration(String hint, {IconData? prefix}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppColors.inputFill,
    prefixIcon: prefix != null
        ? Icon(prefix, color: AppColors.textSecondary, size: 20)
        : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}
