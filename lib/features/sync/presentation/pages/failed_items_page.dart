import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/logger.dart';
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
    if (mounted) setState(() => _items = items);
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
          'A discarded sale stays on this device marked "discarded", but the '
          'server will not know about it.',
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
            itemBuilder: (context, i) => _FailedTile(
              op: _items[i],
              canDiscard: _canDiscard,
              onRetry: () => _retry(_items[i]),
              onDiscard: () => _discard(_items[i]),
            ),
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
  });

  final OutboxOp op;
  final bool canDiscard;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

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
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
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
