import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/presentation/cubit/register_cubit.dart';
import 'package:frantend/features/register/presentation/widgets/register_scaffold.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/app_form_field_validator.dart';
import 'package:frantend/features/register/presentation/cubit/register_state.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class Step1BusinessInfoPage extends StatelessWidget {
  const Step1BusinessInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return RegisterScaffold(
      currentStep: 1,
      maxWidth: 560,
      child: RegisterFormCard(
        child: Form(
          key: cubit.step1FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Business Profile',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about your venture to customize your PakPOS workspace.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              const _Label('Business Name'),
              TextFormField(
                controller: cubit.businessNameController,
                validator: (v) =>
                    AppFormFieldValidator.emptyFieldValidator(v, 'Business name is required'),
                decoration: _inputDecoration(
                  hint: 'e.g., Al-Makkah General Store',
                  prefix: Icons.storefront_outlined,
                ),
              ),
              const SizedBox(height: 20),
              const _Label('Operational City'),
              DropdownButtonFormField<String>(
                initialValue: cubit.selectedCity,
                decoration: _inputDecoration(
                  hint: 'Select your city',
                  prefix: Icons.location_on_outlined,
                ),
                items: kPakistaniCities
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: cubit.setCity,
                validator: (v) =>
                    v == null ? 'Please select your city' : null,
              ),
              const SizedBox(height: 20),
              const _Label('Base Currency'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  children: [
                    const Text('🇵🇰', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'PKR Pakistani Rupee',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.verified_rounded, color: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Currencies are locked per regional regulations.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 20),
              const _Label('Business Logo'),
              _LogoUploadArea(cubit: cubit),
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
                      Text('Continue to Step 2', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'By continuing, you agree to our Terms of Service.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue(BuildContext context, RegisterCubit cubit) {
    if (cubit.businessNameController.text.trim().isEmpty) {
      AppAlerts.showErrorMessage(context, 'Business name is required');
      return;
    }
    if (cubit.selectedCity == null) {
      AppAlerts.showErrorMessage(context, 'Please select your city');
      return;
    }
    if (cubit.step1FormKey.currentState?.validate() ?? false) {
      context.go(RouteNames.registerStep2);
    }
  }
}

class _LogoUploadArea extends StatelessWidget {
  const _LogoUploadArea({required this.cubit});

  final RegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (prev, curr) => curr is RegisterFormState,
      builder: (context, _) {
        final path = cubit.logoPath;
        return InkWell(
          onTap: () async {
            final picker = ImagePicker();
            final file = await picker.pickImage(source: ImageSource.gallery);
            if (file != null) cubit.setLogoPath(file.path);
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid,
              ),
              color: AppColors.inputFill,
            ),
            child: path != null
                ? const Center(child: Text('Logo selected', style: AppTextStyles.bodyMedium))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Icon(Icons.upload_file_rounded, color: AppColors.primary, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Drag and drop your logo',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'PNG, JPG or SVG (Max. 2MB)',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
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

InputDecoration _inputDecoration({required String hint, required IconData prefix}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppColors.inputFill,
    prefixIcon: Icon(prefix, color: AppColors.textSecondary, size: 20),
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
