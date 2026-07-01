import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/bom_form_cubit.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/bom_form_state.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/bom_ingredient_preview_table.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/bom_line_row.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class BomFormPage extends StatelessWidget {
  const BomFormPage({super.key, this.bomId});

  final String? bomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<BomFormCubit>();
        if (bomId == null) {
          cubit.loadForCreate();
        } else {
          cubit.loadForEdit(bomId!);
        }
        return cubit;
      },
      child: _BomFormView(isEdit: bomId != null),
    );
  }
}

class _BomFormView extends StatelessWidget {
  const _BomFormView({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BomFormCubit, BomFormState>(
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
                    isEdit ? 'Edit BOM' : 'New BOM',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _HeaderCard(state: state),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _LinesCard(state: state),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _PreviewCard(state: state),
                ],
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.state});

  final BomFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BomFormCubit>();

    return _FormCard(
      title: 'Recipe Details',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String?>(
                  initialValue: state.productId,
                  decoration: InputDecoration(
                    labelText: 'Finished product *',
                    errorText: state.errors['product'],
                  ),
                  items: state.manufacturedProducts
                      .map(
                        (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                      )
                      .toList(),
                  onChanged: state.isEdit
                      ? null
                      : (id) {
                          if (id != null) cubit.selectFinishedProduct(id);
                        },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: state.variationId,
                  decoration: const InputDecoration(labelText: 'Variation'),
                  items: state.finishedVariations
                      .map(
                        (v) => DropdownMenuItem(value: v.id, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: state.isEdit ? null : cubit.selectFinishedVariation,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Recipe name *',
                    errorText: state.errors['name'],
                  ),
                  controller: TextEditingController(text: state.name)
                    ..selection = TextSelection.collapsed(offset: state.name.length),
                  onChanged: cubit.updateName,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Output qty *',
                    errorText: state.errors['output_qty'],
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(text: state.outputQty)
                    ..selection =
                        TextSelection.collapsed(offset: state.outputQty.length),
                  onChanged: cubit.updateOutputQty,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: state.isActive,
                  onChanged: cubit.updateIsActive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({required this.state});

  final BomFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BomFormCubit>();

    return _FormCard(
      title: 'Ingredient Lines',
      trailing: TextButton.icon(
        onPressed: cubit.addLine,
        icon: const Icon(Icons.add),
        label: const Text('Add Line'),
      ),
      child: Column(
        children: [
          if (state.errors['lines'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.errors['lines']!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          ...state.lines.asMap().entries.map(
            (entry) => BomLineRow(
              index: entry.key,
              line: entry.value,
              products: state.ingredientProducts,
              error: state.errors['line_${entry.key}'],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.state});

  final BomFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BomFormCubit>();

    return _FormCard(
      title: 'Batch Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Preview batch qty',
                helperText: 'Ingredient totals for this production batch size',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              controller: TextEditingController(text: state.previewBatchQty)
                ..selection = TextSelection.collapsed(
                  offset: state.previewBatchQty.length,
                ),
              onChanged: cubit.updatePreviewBatchQty,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          BomIngredientPreviewTable(lines: state.previewLines),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

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
          Row(
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.isEdit});

  final BomFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BomFormCubit>();
    final busy = state.isSubmitting || state.isDeleting;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isEdit)
            TextButton(
              onPressed: busy
                  ? null
                  : () async {
                      final ok = await ConfirmDialog.show(
                        context,
                        title: 'Delete BOM?',
                        message:
                            'Delete "${state.name}"? This cannot be undone.',
                      );
                      if (ok != true || !context.mounted) return;
                      final err = await cubit.delete();
                      if (!context.mounted) return;
                      if (err != null) {
                        AppAlerts.showErrorMessage(context, err);
                      } else {
                        AppAlerts.showSuccessMessage(context, 'BOM deleted');
                        context.pop(true);
                      }
                    },
              child: Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          const SizedBox(width: 12),
          SecondaryButton(
            label: 'Cancel',
            onPressed: busy ? null : () => context.pop(),
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            label: isEdit ? 'Save changes' : 'Create BOM',
            isLoading: state.isSubmitting,
            fullWidth: false,
            onPressed: busy
                ? null
                : () async {
                    final err = await cubit.submit();
                    if (!context.mounted) return;
                    if (err != null) {
                      AppAlerts.showErrorMessage(context, err);
                    } else {
                      AppAlerts.showSuccessMessage(
                        context,
                        isEdit ? 'BOM updated' : 'BOM created',
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
