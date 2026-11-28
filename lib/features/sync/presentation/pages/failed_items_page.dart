import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/suppliers/domain/supplier_text.dart';
import 'package:frantend/features/sync/domain/op_describer.dart';
import 'package:frantend/features/sync/domain/sync_access.dart';

/// Items the server did not accept (or that ran out of retries), each with
/// the reason in plain words, **Retry**, and **Discard** (owner/manager only,
/// after a confirmation; every discard is logged).
class FailedItemsPage extends StatefulWidget {
  const FailedItemsPage({super.key, this.store, this.engine, this.canDiscard});

  /// Defaults to the registered store / engine / current user's rights.
  final SyncStore? store;
  final SyncEngine? engine;
  final bool? canDiscard;

  @override
  State<FailedItemsPage> createState() => _FailedItemsPageState();
}

class _FailedItemsPageState extends State<FailedItemsPage> {
  late final SyncStore _store = widget.store ?? sl<SyncStore>();
  late final SyncEngine _engine = widget.engine ?? sl<SyncEngine>();
  StreamSubscription<void>? _sub;
  List<OutboxOp> _items = const [];

  /// New suppliers refused because one already exists: op id to its name.
  Map<String, String> _existing = const {};

  @override
  void initState() {
    super.initState();
    _sub = _store.changes.listen((_) => _load());
    unawaited(_load());
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  Future<void> _load() async {
    final items = await _store.ops(statuses: OutboxStatus.needsAttention);
    final existing = <String, String>{};
    for (final o in items) {
      if (o.type != OpTypes.supplierCreate) continue;
      final found = await _store.duplicateSupplier(o.opId);
      if (found == null) continue;
      final row = await _store.entity('supplier', found.existingId);
      existing[o.opId] = '${row?['name'] ?? SupplierText.theExistingOne}';
    }
    if (!mounted) return;
    setState(() {
      _items = items;
      _existing = existing;
    });
  }

  Future<void> _useExisting(OutboxOp op, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('use-existing-dialog'),
        title: const Text(SupplierText.useExisting),
        content: Text(
          SupplierText.useExistingBody('${op.payload['name']}', name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            key: const Key('confirm-use-existing'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(SupplierText.useExisting),
          ),
        ],
      ),
    );
    if (ok != true) return;
    AppLogger.info('Using the existing supplier instead of ${op.opId}');
    await _store.transaction(() => _store.useExistingSupplier(op.opId));
    unawaited(_engine.syncNow(manual: true));
  }

  bool get _canDiscard =>
      widget.canDiscard ??
      SyncAccess.canDiscard(sl<AccessCubit>().state.access);

  Future<void> _retry(OutboxOp op) async {
    await _store.transaction(() => _store.retryOp(op.opId));
    unawaited(_engine.syncNow(manual: true));
  }

  Future<void> _retryAll() async {
    await _store.transaction(() => _store.retryAllFailed());
    unawaited(_engine.syncNow(manual: true));
  }

  Future<void> _discard(OutboxOp op) async {
    final d = OpDescriber.describe(op);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('discard-dialog'),
        title: const Text('Discard this item?'),
        content: Text(
          '"${d.title}" will never be sent to the server. '
          'This cannot be undone.\n\n'
          '${switch (op.type) {
            OpTypes.supplierCreate => SupplierText.discardNewSupplier,
            OpTypes.supplierUpdate => SupplierText.discardEdit,
            _ => 'A discarded sale stays on this device marked "discarded", '
                'but the server will not know about it.',
          }}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    AppLogger.info('Discarding ${op.type} ${op.opId} (${op.errorCode})');
    await _store.transaction(
      () => _store.discardOp(op.opId, reason: 'Discarded by the user'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
            const SizedBox(height: 12),
            Text(
              'Nothing needs attention',
              key: const Key('failed-items-headline'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Items the server could not accept will be listed here.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${_items.length} item(s) need attention',
                key: const Key('failed-items-headline'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            OutlinedButton.icon(
              key: const Key('retry-all'),
              onPressed: _retryAll,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final op = _items[i];
              final existing = _existing[op.opId];
              return _FailedTile(
                op: op,
                canDiscard: _canDiscard,
                onRetry: () => _retry(op),
                onDiscard: () => _discard(op),
                existingSupplier: existing,
                onUseExisting: existing == null
                    ? null
                    : () => _useExisting(op, existing),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FailedTile extends StatelessWidget {
  const _FailedTile({
    required this.op,
    required this.canDiscard,
    required this.onRetry,
    required this.onDiscard,
    this.existingSupplier,
    this.onUseExisting,
  });

  final OutboxOp op;
  final bool canDiscard;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  /// The supplier that already has the refused one's name or phone.
  final String? existingSupplier;
  final VoidCallback? onUseExisting;

  @override
  Widget build(BuildContext context) {
    final d = OpDescriber.describe(op);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(d.subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(
                    op.errorMessage ?? 'The server did not accept this item.',
                    key: const Key('failed-reason'),
                    style: const TextStyle(color: AppColors.error),
                  ),
                  if (existingSupplier != null)
                    Text(
                      SupplierText.existingIs(existingSupplier!),
                      key: const Key('existing-supplier'),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                if (canDiscard && onUseExisting != null) ...[
                  FilledButton(
                    key: const Key('use-existing-supplier'),
                    onPressed: onUseExisting,
                    child: const Text(SupplierText.useExisting),
                  ),
                  const SizedBox(height: 4),
                ],
                FilledButton.tonal(
                  key: const Key('retry-op'),
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
                if (canDiscard)
                  TextButton(
                    key: const Key('discard-op'),
                    onPressed: onDiscard,
                    child: const Text('Discard'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
