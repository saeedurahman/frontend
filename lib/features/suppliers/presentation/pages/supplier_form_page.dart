import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_state.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class SupplierFormPage extends StatelessWidget {
  const SupplierFormPage({super.key, this.supplierId});

  final String? supplierId;

  bool get isEdit => supplierId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<SupplierFormCubit>();
        if (supplierId != null) {
          cubit.loadForEdit(supplierId!);
        } else {
          cubit.initCreate();
        }
        return cubit;
      },
      child: _SupplierFormView(isEdit: isEdit),
    );
  }
}

class _SupplierFormView extends StatelessWidget {
  const _SupplierFormView({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupplierFormCubit, SupplierFormState>(
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
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEdit ? 'Edit Supplier' : 'Add Supplier',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      _FormCard(
                        title: 'Supplier Details',
                        child: _SupplierFields(state: state),
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

class _SupplierFields extends StatelessWidget {
  const _SupplierFields({required this.state});

  final SupplierFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupplierFormCubit>();

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
        TextField(
          decoration: const InputDecoration(labelText: 'Contact Person'),
          controller: TextEditingController(text: state.contactPerson)
            ..selection =
                TextSelection.collapsed(offset: state.contactPerson.length),
          onChanged: cubit.updateContactPerson,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: state.email)
                  ..selection =
                      TextSelection.collapsed(offset: state.email.length),
                onChanged: cubit.updateEmail,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Phone'),
                controller: TextEditingController(text: state.phone)
                  ..selection =
                      TextSelection.collapsed(offset: state.phone.length),
                onChanged: cubit.updatePhone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Tax ID'),
          controller: TextEditingController(text: state.taxId)
            ..selection = TextSelection.collapsed(offset: state.taxId.length),
          onChanged: cubit.updateTaxId,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Address'),
          controller: TextEditingController(text: state.addressLine1)
            ..selection =
                TextSelection.collapsed(offset: state.addressLine1.length),
          onChanged: cubit.updateAddressLine1,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'City'),
                controller: TextEditingController(text: state.city)
                  ..selection =
                      TextSelection.collapsed(offset: state.city.length),
                onChanged: cubit.updateCity,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Payment Terms (days)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: state.paymentTermsDays)
                  ..selection = TextSelection.collapsed(
                    offset: state.paymentTermsDays.length,
                  ),
                onChanged: cubit.updatePaymentTermsDays,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.isEdit});

  final SupplierFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupplierFormCubit>();

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
            label: isEdit ? 'Save Changes' : 'Create Supplier',
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
                        isEdit ? 'Supplier updated' : 'Supplier created',
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
