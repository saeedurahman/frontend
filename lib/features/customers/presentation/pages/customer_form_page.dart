import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_form_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_form_state.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class CustomerFormPage extends StatelessWidget {
  const CustomerFormPage({super.key, this.customerId});

  final String? customerId;

  bool get isEdit => customerId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<CustomerFormCubit>();
        if (customerId != null) {
          cubit.loadForEdit(customerId!);
        } else {
          cubit.initCreate();
        }
        return cubit;
      },
      child: _CustomerFormView(isEdit: isEdit),
    );
  }
}

class _CustomerFormView extends StatelessWidget {
  const _CustomerFormView({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerFormCubit, CustomerFormState>(
      listenWhen: (p, c) => c.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEdit ? 'Edit Customer' : 'Add Customer',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      _FormCard(
                        title: 'Customer Details',
                        child: _CustomerFields(state: state, isEdit: isEdit),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(state: state, isEdit: isEdit),
            ),
          ],
        );
      },
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}

class _CustomerFields extends StatelessWidget {
  const _CustomerFields({required this.state, required this.isEdit});

  final CustomerFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomerFormCubit>();

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Name *',
            errorText: state.errors['name'],
          ),
          controller: TextEditingController(text: state.name)
            ..selection = TextSelection.collapsed(offset: state.name.length),
          onChanged: cubit.updateName,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Phone'),
                controller: TextEditingController(text: state.phone)
                  ..selection =
                      TextSelection.collapsed(offset: state.phone.length),
                onChanged: cubit.updatePhone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: state.email)
                  ..selection =
                      TextSelection.collapsed(offset: state.email.length),
                onChanged: cubit.updateEmail,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Address'),
          enabled: !isEdit,
          controller: TextEditingController(text: state.addressLine1)
            ..selection =
                TextSelection.collapsed(offset: state.addressLine1.length),
          onChanged: isEdit ? null : cubit.updateAddressLine1,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'City'),
                enabled: !isEdit,
                controller: TextEditingController(text: state.city)
                  ..selection =
                      TextSelection.collapsed(offset: state.city.length),
                onChanged: isEdit ? null : cubit.updateCity,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Credit Limit'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: TextEditingController(text: state.creditLimit)
                  ..selection = TextSelection.collapsed(
                    offset: state.creditLimit.length,
                  ),
                onChanged: cubit.updateCreditLimit,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Tax ID'),
          enabled: !isEdit,
          controller: TextEditingController(text: state.taxId)
            ..selection = TextSelection.collapsed(offset: state.taxId.length),
          onChanged: isEdit ? null : cubit.updateTaxId,
        ),
        if (isEdit) ...[
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
            value: state.isActive,
            activeThumbColor: AppColors.primary,
            onChanged: cubit.updateIsActive,
          ),
        ],
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.isEdit});

  final CustomerFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomerFormCubit>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SecondaryButton(
            label: 'Cancel',
            onPressed: state.isSubmitting ? null : () => context.pop(),
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            label: isEdit ? 'Save Changes' : 'Create Customer',
            isLoading: state.isSubmitting,
            fullWidth: false,
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final err = await cubit.submit();
                    if (!context.mounted) return;
                    if (err != null) {
                      AppAlerts.showErrorMessage(context, err);
                    } else {
                      AppAlerts.showSuccessMessage(
                        context,
                        isEdit ? 'Customer updated' : 'Customer created',
                      );
                      context.pop(true);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
