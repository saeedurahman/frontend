import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/suppliers/domain/repositories/suppliers_repository.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_cubit.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/cubit/opening_balance_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/opening_balance_section.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_state.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:frantend/shared/widgets/inputs/synced_text_field.dart';

class SupplierFormPage extends StatelessWidget {
  const SupplierFormPage({super.key, this.supplierId});

  final String? supplierId;

  bool get isEdit => supplierId != null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = sl<SupplierFormCubit>();
            if (supplierId != null) {
              cubit.loadForEdit(supplierId!);
            } else {
              cubit.initCreate();
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => OpeningBalanceCubit(
            khataRepositoryIfAny(),
            type: PartyType.supplier,
            saveOffline: sl.isRegistered<SuppliersRepository>()
                ? sl<SuppliersRepository>().createSupplier
                : null,
          ),
        ),
      ],
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
                      if (!isEdit &&
                          context.read<OpeningBalanceCubit>().available)
                        const PermissionGate(
                          permission: Perm.suppliersLedgerManage,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppDimensions.spacingMd,
                            ),
                            child: _FormCard(
                              title: EntryText.openingOptional,
                              child: OpeningBalanceSection(),
                            ),
                          ),
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
        SyncedTextField(
          value: state.name,
          decoration: InputDecoration(
            labelText: 'Name *',
            errorText: state.errors['name'],
          ),

          onChanged: cubit.updateName,
        ),
        const SizedBox(height: 12),
        SyncedTextField(
          value: state.contactPerson,
          decoration: const InputDecoration(labelText: 'Contact Person'),

          onChanged: cubit.updateContactPerson,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SyncedTextField(
                value: state.email,
                decoration: const InputDecoration(labelText: 'Email'),

                onChanged: cubit.updateEmail,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SyncedTextField(
                value: state.phone,
                decoration: const InputDecoration(labelText: 'Phone'),

                onChanged: cubit.updatePhone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SyncedTextField(
          value: state.taxId,
          decoration: const InputDecoration(labelText: 'Tax ID'),

          onChanged: cubit.updateTaxId,
        ),
        const SizedBox(height: 12),
        SyncedTextField(
          value: state.addressLine1,
          decoration: const InputDecoration(labelText: 'Address'),

          onChanged: cubit.updateAddressLine1,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SyncedTextField(
                value: state.city,
                decoration: const InputDecoration(labelText: 'City'),

                onChanged: cubit.updateCity,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SyncedTextField(
                value: state.paymentTermsDays,
                decoration: const InputDecoration(
                  labelText: 'Payment Terms (days)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                inputFormatters: const [
                  NumberInputFormatter(allowDecimal: false),
                ],

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
    final opening = context.watch<OpeningBalanceCubit>();
    final busy = state.isSubmitting || opening.state.submitting;

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
            onPressed: busy ? null : () => context.pop(),
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            label: isEdit ? 'Save Changes' : 'Create Supplier',
            isLoading: busy,
            fullWidth: false,
            onPressed: busy
                ? null
                : () async {
                    // With an opening balance, both are created together.
                    final err = !isEdit && opening.isFilled
                        ? cubit.validate()
                            ? await opening.create(cubit.createBody())
                            : 'Validation failed'
                        : await cubit.submit();
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
