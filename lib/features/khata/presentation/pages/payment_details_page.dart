import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/text/khata_settings_text.dart';
import 'package:frantend/features/khata/presentation/cubit/payment_details_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/features/khata/presentation/widgets/payment_method_dialog.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:frantend/utils/app_alerts.dart';

/// Settings > Payment details.
class PaymentDetailsPage extends StatelessWidget {
  const PaymentDetailsPage({super.key, this.createCubit, this.probe});

  /// Tests supply their own cubit (not yet loaded).
  final PaymentDetailsCubit Function()? createCubit;
  final ConnectivityProbe? probe;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) =>
            (createCubit?.call() ?? PaymentDetailsCubit(sl<KhataRepository>()))
              ..load(),
        child: _View(probe: probe),
      );
}

class _View extends StatelessWidget {
  const _View({this.probe});

  final ConnectivityProbe? probe;

  @override
  Widget build(BuildContext context) => OfflineAwareBuilder(
        probe: probe,
        builder: (context, offline) => PermissionGate(
          permission: Perm.settingsManage,
          mode: GateMode.disable,
          mutating: true,
          builder: (context, allowed) =>
              BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
            builder: (context, state) => Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: _body(context, state, offline, allowed),
              ),
            ),
          ),
        ),
      );

  Widget _body(
    BuildContext context,
    PaymentDetailsState state,
    bool offline,
    bool allowed,
  ) {
    final cubit = context.read<PaymentDetailsCubit>();
    final editable = allowed && !offline && !state.saving;
    final why = offline
        ? KhataSettingsText.offline
        : allowed
            ? ''
            : KhataSettingsText.noPermission;

    Future<void> report(Future<String?> change) async {
      final error = await change;
      if (error != null && context.mounted) {
        AppAlerts.showErrorMessage(context, error);
      }
    }

    Future<void> add() async {
      final item = await showPaymentMethodDialog(context);
      if (item != null) await report(cubit.add(item));
    }

    if (state.loading) {
      return const SingleChildScrollView(
        child: SkeletonRows(count: 3, height: 88),
      );
    }
    if (state.error != null) {
      return KhataEmptyState(
        icon: Icons.error_outline,
        title: KhataSettingsText.loadFailed,
        message: state.error,
        actionLabel: KhataSettingsText.retry,
        onAction: cubit.load,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (offline) ...[
          const OnlineOnlyBanner(message: OfflineMessages.editingNotice),
          const SizedBox(height: AppDimensions.spacing12),
        ],
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDimensions.spacingMd,
          runSpacing: AppDimensions.spacingSm,
          children: [
            const Text(
              KhataSettingsText.paymentsTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            if (state.items.isNotEmpty)
              Tooltip(
                message: state.isFull
                    ? KhataSettingsText.limit(state.items.length)
                    : why,
                child: FilledButton.icon(
                  key: const Key('payment-add'),
                  onPressed: editable && !state.isFull ? add : null,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(KhataSettingsText.add),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        const Text(
          KhataSettingsText.paymentsSubtitle,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(
          height: 2,
          child: state.saving ? const LinearProgressIndicator() : null,
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Expanded(
          child: state.items.isEmpty
              ? KhataEmptyState(
                  key: const Key('payments-empty'),
                  icon: Icons.account_balance_wallet_outlined,
                  title: KhataSettingsText.emptyTitle,
                  message: KhataSettingsText.emptyMessage,
                  actionLabel: KhataSettingsText.add,
                  onAction: editable ? add : null,
                )
              : ReorderableListView.builder(
                  key: const Key('payments-list'),
                  buildDefaultDragHandles: false,
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingMd,
                  ),
                  itemCount: state.items.length,
                  onReorderItem: (from, to) => report(cubit.move(from, to)),
                  itemBuilder: (context, i) {
                    final item = state.items[i];
                    return Padding(
                      key: ValueKey('payment-$i-${item.line}'),
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingSm,
                      ),
                      child: _Card(
                        index: i,
                        item: item,
                        editable: editable,
                        onUp: editable && i > 0
                            ? () => report(cubit.move(i, i - 1))
                            : null,
                        onDown: editable && i < state.items.length - 1
                            ? () => report(cubit.move(i, i + 1))
                            : null,
                        onEdit: editable
                            ? () async {
                                final changed = await showPaymentMethodDialog(
                                  context,
                                  initial: item,
                                );
                                if (changed != null) {
                                  await report(cubit.replace(i, changed));
                                }
                              }
                            : null,
                        onRemove: editable
                            ? () async {
                                if (await _confirmRemove(context, item)) {
                                  await report(cubit.remove(i));
                                }
                              }
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  static Future<bool> _confirmRemove(
    BuildContext context,
    PaymentInstruction item,
  ) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(KhataSettingsText.removeTitle(item.title)),
          content: const Text(KhataSettingsText.removeMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text(KhataSettingsText.cancel),
            ),
            FilledButton(
              key: const Key('payment-remove-confirm'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text(KhataSettingsText.remove),
            ),
          ],
        ),
      ) ??
      false;
}

class _Card extends StatelessWidget {
  const _Card({
    required this.index,
    required this.item,
    required this.editable,
    required this.onUp,
    required this.onDown,
    required this.onEdit,
    required this.onRemove,
  });

  final int index;
  final PaymentInstruction item;
  final bool editable;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (item.accountNumber != null) item.accountNumber!,
      if (item.bankName != null) item.bankName!,
    ].join('  ·  ');
    Widget button(String id, IconData icon, String tip, VoidCallback? tap) =>
        IconButton(
          key: Key('payment-$id-$index'),
          tooltip: tip,
          icon: Icon(icon, size: 18),
          visualDensity: VisualDensity.compact,
          onPressed: tap,
        );
    return KhataCard(
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      child: Row(
        children: [
          if (editable)
            ReorderableDragStartListener(
              index: index,
              child: const Tooltip(
                message: KhataSettingsText.drag,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: Padding(
                    padding: EdgeInsets.only(right: AppDimensions.spacingSm),
                    child: Icon(
                      Icons.drag_indicator,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppDimensions.spacingSm,
                  runSpacing: AppDimensions.spacingXs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    KhataChip(
                      label: item.kind.label,
                      color: AppColors.primary,
                      icon: paymentKindIcon(item.kind),
                    ),
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                if (details.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: AppDimensions.spacingXs),
                    child: Text(details, style: KhataStyle.money),
                  ),
                if (item.note != null)
                  Text(
                    item.note!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Wrap(
            children: [
              button(
                'up',
                Icons.arrow_upward,
                KhataSettingsText.moveUp,
                onUp,
              ),
              button(
                'down',
                Icons.arrow_downward,
                KhataSettingsText.moveDown,
                onDown,
              ),
              button(
                'edit',
                Icons.edit_outlined,
                KhataSettingsText.edit,
                onEdit,
              ),
              button(
                'remove',
                Icons.delete_outline,
                KhataSettingsText.remove,
                onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
