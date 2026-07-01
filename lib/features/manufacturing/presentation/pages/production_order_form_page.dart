import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_order_form_cubit.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_order_form_state.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/ingredient_availability_table.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class ProductionOrderFormPage extends StatelessWidget {
  const ProductionOrderFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductionOrderFormCubit>()..init(),
      child: const _ProductionOrderFormView(),
    );
  }
}

class _ProductionOrderFormView extends StatelessWidget {
  const _ProductionOrderFormView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductionOrderFormCubit, ProductionOrderFormState>(
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
              padding: const EdgeInsets.only(bottom: 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New Production Order',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _FormCard(
                    title: 'Order Details',
                    child: Column(
                      children: [
                        DropdownButtonFormField<String?>(
                          initialValue: state.bomHeaderId,
                          decoration: InputDecoration(
                            labelText: 'BOM (recipe) *',
                            errorText: state.errors['bom'],
                          ),
                          items: state.activeBoms
                              .map(
                                (bom) => DropdownMenuItem(
                                  value: bom.id,
                                  child: Text(
                                    '${bom.productName} — ${bom.name} v${bom.version}',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: context
                              .read<ProductionOrderFormCubit>()
                              .selectBom,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Qty to produce *',
                            errorText: state.errors['qty'],
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: TextEditingController(
                            text: state.qtyToProduce,
                          )..selection = TextSelection.collapsed(
                              offset: state.qtyToProduce.length,
                            ),
                          onChanged: context
                              .read<ProductionOrderFormCubit>()
                              .updateQtyToProduce,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Notes'),
                          controller: TextEditingController(text: state.notes)
                            ..selection = TextSelection.collapsed(
                              offset: state.notes.length,
                            ),
                          onChanged: context
                              .read<ProductionOrderFormCubit>()
                              .updateNotes,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _FormCard(
                    title: 'Ingredient Availability',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.hasShortfall && !state.allowNegativeStock)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.warning.withValues(alpha: 0.35),
                              ),
                            ),
                            child: const Text(
                              'Insufficient stock for one or more ingredients. '
                              'You can still create this order, but completion may fail.',
                            ),
                          ),
                        IngredientAvailabilityTable(
                          rows: state.availability,
                          isLoading: state.isPreviewLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
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
                      label: 'Create order',
                      isLoading: state.isSubmitting,
                      fullWidth: false,
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              final err = await context
                                  .read<ProductionOrderFormCubit>()
                                  .submit();
                              if (!context.mounted) return;
                              if (err != null) {
                                AppAlerts.showErrorMessage(context, err);
                              } else {
                                AppAlerts.showSuccessMessage(
                                  context,
                                  'Production order created',
                                );
                                context.pop(true);
                              }
                            },
                    ),
                  ],
                ),
              ),
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
