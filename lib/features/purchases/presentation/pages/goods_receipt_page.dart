import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/presentation/cubit/paid_now_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/paid_now_section.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_state.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:frantend/shared/widgets/inputs/synced_text_field.dart';

/// Paying a supplier while receiving needs the supplier-payment permission.
bool _canPay(BuildContext context) =>
    hasPermission(context, Perm.suppliersPaymentsCreate);

class GoodsReceiptPage extends StatelessWidget {
  const GoodsReceiptPage({super.key, required this.purchaseOrderId});

  final String purchaseOrderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<GoodsReceiptCubit>()..load(purchaseOrderId),
        ),
        BlocProvider(create: (_) => sl<PaidNowCubit>()..init()),
      ],
      child: const _GoodsReceiptView(),
    );
  }
}

class _GoodsReceiptView extends StatelessWidget {
  const _GoodsReceiptView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodsReceiptCubit, GoodsReceiptState>(
      listenWhen: (p, c) => c.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = state.order;
        if (order == null) {
          return const Center(child: Text('Purchase order not found'));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Receive Goods', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'PO ${order.poNumber} — ${order.supplier?.name ?? order.supplierId}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _MetaCard(state: state),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _LinesCard(state: state),
                  if (_canPay(context)) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    PaidNowSection(
                      total: state.total,
                      enabled: !state.isSubmitting,
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(state: state),
            ),
          ],
        );
      },
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.state});

  final GoodsReceiptState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GoodsReceiptCubit>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Received Date'),
              subtitle: Text(
                (state.receivedAt ?? DateTime.now())
                    .toString()
                    .split(' ')
                    .first,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today, size: 18),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDate: state.receivedAt ?? DateTime.now(),
                  );
                  if (picked != null) cubit.updateReceivedAt(picked);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SyncedTextField(
              value: state.supplierInvoiceNo,
              decoration: const InputDecoration(
                labelText: 'Supplier Invoice No',
              ),

              onChanged: cubit.updateSupplierInvoiceNo,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SyncedTextField(
              value: state.notes,
              decoration: const InputDecoration(labelText: 'Notes'),

              onChanged: cubit.updateNotes,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({required this.state});

  final GoodsReceiptState state;

  @override
  Widget build(BuildContext context) {
    if (state.lines.isEmpty) {
      return const Center(child: Text('No items to receive'));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: state.lines.asMap().entries.map((entry) {
          return _ReceiptLineRow(
            index: entry.key,
            item: entry.value,
            error: state.errors['line_${entry.key}'],
          );
        }).toList(),
      ),
    );
  }
}

class _ReceiptLineRow extends StatelessWidget {
  const _ReceiptLineRow({required this.index, required this.item, this.error});

  final int index;
  final GoodsReceiptLineItem item;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GoodsReceiptCubit>();
    final line = item.line;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.productName ?? line.productId,
            style: AppTextStyles.titleMedium,
          ),
          if (line.variationName != null && line.variationName!.isNotEmpty)
            Text(
              line.variationName!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          Text(
            'Remaining: ${line.qtyToReceive}',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SyncedTextField(
                  value: item.qtyReceived,
                  decoration: const InputDecoration(labelText: 'Qty Receiving'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: const [NumberInputFormatter()],

                  onChanged: (v) =>
                      cubit.updateLine(index, item.copyWith(qtyReceived: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SyncedTextField(
                  value: item.costPerUnit,
                  decoration: const InputDecoration(labelText: 'Cost/Unit'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: const [NumberInputFormatter()],

                  onChanged: (v) =>
                      cubit.updateLine(index, item.copyWith(costPerUnit: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SyncedTextField(
                  value: item.batchNumber,
                  key: Key('grn-batch-$index'),
                  decoration: InputDecoration(
                    labelText: item.trackExpiry ? 'Batch No *' : 'Batch No',
                  ),

                  onChanged: (v) =>
                      cubit.updateLine(index, item.copyWith(batchNumber: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.trackExpiry ? 'Expiry *' : 'Expiry'),
                  subtitle: Text(
                    item.expiryDate?.toString().split(' ').first ?? 'Not set',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        initialDate:
                            item.expiryDate != null &&
                                item.expiryDate!.isAfter(DateTime.now())
                            ? item.expiryDate!
                            : DateTime.now(),
                      );
                      if (picked != null) {
                        cubit.updateLine(
                          index,
                          item.copyWith(expiryDate: picked),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          if (error != null)
            Text(
              error!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state});

  final GoodsReceiptState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GoodsReceiptCubit>();

    return Container(
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
          PermissionGate(
            permission: Perm.purchasesReceive,
            mutating: true,
            child: PrimaryButton(
              label: 'Confirm Receipt',
              isLoading: state.isSubmitting,
              fullWidth: false,
              onPressed: state.isSubmitting
                  ? null
                  : () async {
                      final paid = context.read<PaidNowCubit>();
                      final total = state.total;
                      final canPay = _canPay(context);
                      final block =
                          canPay ? paid.blockingProblem(total) : null;
                      if (block != null) {
                        AppAlerts.showErrorMessage(context, block);
                        return;
                      }
                      final payment = canPay ? paid.inputFor(total) : null;
                      final err = await cubit.confirmReceipt(payment: payment);
                      if (!context.mounted) return;
                      if (err != null) {
                        if (payment != null) {
                          paid.explain(cubit.lastErrorCode, err);
                        }
                        AppAlerts.showErrorMessage(context, err);
                      } else {
                        final result = cubit.lastPayment;
                        await paid.saved(paid: result != null, result: result);
                        if (!context.mounted) return;
                        AppAlerts.showSuccessMessage(
                          context,
                          receivedMessage(result, total),
                        );
                        context.pop(true);
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
