import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';

class HoldSaleDialog extends StatefulWidget {
  const HoldSaleDialog({super.key, required this.defaultLabel});

  final String defaultLabel;

  /// Returns `null` if cancelled, empty string for auto label, or custom label.
  static Future<String?> show(
    BuildContext context, {
    required String defaultLabel,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => HoldSaleDialog(defaultLabel: defaultLabel),
    );
  }

  @override
  State<HoldSaleDialog> createState() => _HoldSaleDialogState();
}

class _HoldSaleDialogState extends State<HoldSaleDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hold this order'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '${widget.defaultLabel} (auto)',
          border: const OutlineInputBorder(),
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Hold Order'),
        ),
      ],
    );
  }
}

class HeldOrdersDialog extends StatelessWidget {
  const HeldOrdersDialog({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const HeldOrdersDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        final orders = state.heldOrders;
        return AlertDialog(
          title: Text('Held Orders (${orders.length})'),
          content: SizedBox(
            width: 420,
            child: orders.isEmpty
                ? const Text('No held orders')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (context, index) => _HeldOrderTile(
                      order: orders[index],
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

class _HeldOrderTile extends StatelessWidget {
  const _HeldOrderTile({required this.order});

  final HeldOrderModel order;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          'Held ${_timeAgo(order.createdAt)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${order.itemCount} items — ${formatPKR(order.totalAmount.toDouble())}',
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            FilledButton(
              onPressed: () => _resume(context, cubit),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Resume', style: TextStyle(fontSize: 13)),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Discard',
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _discard(context, cubit),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _resume(BuildContext context, PosCubit cubit) async {
    final state = cubit.state;
    if (state.cartItems.isNotEmpty) {
      final ok = await ConfirmDialog.show(
        context,
        title: 'Replace current cart?',
        message:
            'Resuming this order will replace your current cart (${state.cartItems.length} items). Continue?',
      );
      if (ok != true) return;
      if (!context.mounted) return;
      final resumed = await cubit.resumeHeldOrder(
        order.id,
        forceOverwrite: true,
      );
      if (resumed && context.mounted) {
        Navigator.pop(context);
      }
      return;
    }

    final resumed = await cubit.resumeHeldOrder(order.id);
    if (resumed && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _discard(BuildContext context, PosCubit cubit) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Discard held order?',
      message: 'Discard this held order? This cannot be undone.',
    );
    if (ok != true) return;
    await cubit.discardHeldOrder(order.id);
  }
}

String _timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
