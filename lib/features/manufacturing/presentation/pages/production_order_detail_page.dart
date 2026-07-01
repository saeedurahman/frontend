import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_order_detail_cubit.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_order_detail_state.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/complete_production_dialog.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/production_lines_table.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/production_order_summary_card.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class ProductionOrderDetailPage extends StatelessWidget {
  const ProductionOrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductionOrderDetailCubit>()..load(orderId),
      child: _ProductionOrderDetailView(orderId: orderId),
    );
  }
}

class _ProductionOrderDetailView extends StatelessWidget {
  const _ProductionOrderDetailView({required this.orderId});

  final String orderId;

  String? _branchName(ProductionOrderDetailState state) {
    final order = state.order;
    if (order == null) return null;
    final branches = sl<BranchSelectorCubit>().state.availableBranches;
    for (final branch in branches) {
      if (branch.id == order.branchId) return branch.name;
    }
    return null;
  }

  Future<void> _start(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Start production?',
      message:
          'Mark this order as in progress. Stock is not consumed until completion.',
    );
    if (ok != true || !context.mounted) return;

    final err = await context.read<ProductionOrderDetailCubit>().start();
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Production started');
    }
  }

  Future<void> _cancel(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Cancel production order?',
      message: 'This production order will be cancelled.',
    );
    if (ok != true || !context.mounted) return;

    final err = await context.read<ProductionOrderDetailCubit>().cancel();
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Production order cancelled');
    }
  }

  Future<void> _complete(BuildContext context, ProductionOrderDetailState state) async {
    final order = state.order;
    if (order == null) return;
    final cubit = context.read<ProductionOrderDetailCubit>();

    final qty = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<ProductionOrderDetailCubit, ProductionOrderDetailState>(
          builder: (_, dialogState) => CompleteProductionDialog(
            productionNumber: order.productionNumber,
            defaultQtyProduced: order.qtyToProduce,
            maxQtyProduced: order.qtyToProduce,
            availability: dialogState.completionAvailability,
            isLoadingPreview: dialogState.isPreviewLoading,
            onQtyChanged: cubit.prepareCompletionPreview,
          ),
        ),
      ),
    );

    if (qty == null || !context.mounted) return;

    final err = await cubit.complete(qty);
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Production completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionOrderDetailCubit, ProductionOrderDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.loadError != null) {
          return Center(child: Text(state.loadError!));
        }
        final order = state.order;
        if (order == null) {
          return const Center(child: Text('Production order not found'));
        }

        final cubit = context.read<ProductionOrderDetailCubit>();
        final isDraft = order.status == ProductionOrderStatus.draft;
        final isInProgress = order.status == ProductionOrderStatus.inProgress;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to Production Orders'),
                  ),
                  const Spacer(),
                  if (isDraft && state.canCreate && !state.isEditingDraft)
                    OutlinedButton(
                      onPressed: state.isUpdating ? null : cubit.startEditingDraft,
                      child: const Text('Edit'),
                    ),
                  if (isDraft && state.isEditingDraft) ...[
                    OutlinedButton(
                      onPressed: state.isUpdating ? null : cubit.cancelEditingDraft,
                      child: const Text('Cancel edit'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: state.isUpdating
                          ? null
                          : () async {
                              final err = await cubit.saveDraft();
                              if (!context.mounted) return;
                              if (err != null) {
                                AppAlerts.showErrorMessage(context, err);
                              } else {
                                AppAlerts.showSuccessMessage(
                                  context,
                                  'Draft updated',
                                );
                              }
                            },
                      child: const Text('Save draft'),
                    ),
                  ],
                  if (isDraft && state.canCreate && !state.isEditingDraft) ...[
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: state.isUpdating ? null : () => _start(context),
                      child: const Text('Start'),
                    ),
                  ],
                  if (isInProgress && state.canComplete) ...[
                    FilledButton(
                      onPressed: state.isUpdating
                          ? null
                          : () => _complete(context, state),
                      child: const Text('Complete'),
                    ),
                  ],
                  if ((isDraft || isInProgress) && state.canCancel) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: state.isUpdating ? null : () => _cancel(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              if (state.isEditingDraft) _DraftEditCard(state: state),
              ProductionOrderSummaryCard(
                order: order,
                branchName: _branchName(state),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              _FormCard(
                title: 'Consumed ingredients',
                child: ProductionLinesTable(lines: order.lines),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DraftEditCard extends StatelessWidget {
  const _DraftEditCard({required this.state});

  final ProductionOrderDetailState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductionOrderDetailCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: _FormCard(
        title: 'Edit draft',
        child: Column(
          children: [
            DropdownButtonFormField<String?>(
              initialValue: state.draftBomHeaderId,
              decoration: InputDecoration(
                labelText: 'BOM',
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
              onChanged: cubit.updateDraftBom,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Qty to produce',
                errorText: state.errors['qty'],
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              controller: TextEditingController(text: state.draftQtyToProduce)
                ..selection = TextSelection.collapsed(
                  offset: state.draftQtyToProduce.length,
                ),
              onChanged: cubit.updateDraftQty,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Notes'),
              controller: TextEditingController(text: state.draftNotes)
                ..selection =
                    TextSelection.collapsed(offset: state.draftNotes.length),
              onChanged: cubit.updateDraftNotes,
              maxLines: 2,
            ),
          ],
        ),
      ),
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
