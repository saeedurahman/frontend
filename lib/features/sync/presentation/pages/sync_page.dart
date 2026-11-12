import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/offline/offline_policy.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/sync/domain/op_describer.dart';
import 'package:frantend/features/sync/domain/sync_access.dart';
import 'package:go_router/go_router.dart';

/// "Sync" screen: what is waiting, what failed, when it last worked, and a
/// **Sync now** button.
class SyncPage extends StatefulWidget {
  const SyncPage({
    super.key,
    this.store,
    this.engine,
    this.showDetails,
    this.canReviewFlags,
  });

  final SyncStore? store;
  final SyncEngine? engine;
  final bool? showDetails;
  final bool? canReviewFlags;

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  late final SyncStore _store = widget.store ?? sl<SyncStore>();
  late final SyncEngine _engine = widget.engine ?? sl<SyncEngine>();
  StreamSubscription<void>? _sub;
  StreamSubscription<SyncEngineState>? _engineSub;
  List<OutboxOp> _pending = const [];
  int _failed = 0;

  @override
  void initState() {
    super.initState();
    _sub = _store.changes.listen((_) => _load());
    _engineSub = _engine.states.listen((_) {
      if (mounted) setState(() {});
    });
    unawaited(_load());
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    unawaited(_engineSub?.cancel());
    super.dispose();
  }

  Future<void> _load() async {
    final pending = await _store.ops(
      statuses: [OutboxStatus.pending, OutboxStatus.sending],
    );
    final failed = (await _store.counts()).failed;
    if (mounted) {
      setState(() {
        _pending = pending;
        _failed = failed;
      });
    }
  }

  static String _ago(DateTime? t) {
    if (t == null) return 'never';
    final d = DateTime.now().difference(t);
    if (d.inSeconds < 60) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} h ago';
    return '${d.inDays} d ago';
  }

  bool get _details =>
      widget.showDetails ?? sl<OfflinePolicy>().showSyncDetails;

  @override
  Widget build(BuildContext context) {
    final state = _engine.state;
    final canFlags = widget.canReviewFlags ??
        SyncAccess.canReviewFlags(sl<AccessCubit>().state.access);
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  state.syncing ? Icons.sync : Icons.cloud_done_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.syncing ? 'Syncing...' : 'Last synced ${_ago(state.lastSyncedAt)}',
                        key: const Key('sync-last'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${_pending.length} waiting to send, $_failed need attention',
                        key: const Key('sync-counts'),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      if (state.lastError != null)
                        Text(
                          'Last problem: ${state.lastError}',
                          style: const TextStyle(color: AppColors.warning),
                        ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  key: const Key('sync-now'),
                  onPressed: state.syncing
                      ? null
                      : () => unawaited(_engine.syncNow(manual: true)),
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync now'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_failed > 0)
          ListTile(
            key: const Key('open-failed'),
            leading: const Icon(Icons.error_outline, color: AppColors.error),
            title: Text('$_failed item(s) need attention'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(RouteNames.syncFailed),
          ),
        if (canFlags)
          ListTile(
            key: const Key('open-flags'),
            leading: const Icon(Icons.flag_outlined, color: AppColors.warning),
            title: const Text('Flagged sales'),
            subtitle: const Text('Offline sales the server accepted but wants checked'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(RouteNames.syncFlags),
          ),
        const SizedBox(height: 8),
        Text('Waiting to send', style: Theme.of(context).textTheme.titleMedium),
        if (_pending.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Nothing is waiting - everything has been sent.'),
          ),
        for (final op in _pending)
          ListTile(
            dense: true,
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text(OpDescriber.describe(op).title),
            subtitle: Text(
              _details
                  ? '${OpDescriber.describe(op).subtitle} - ${OpDescriber.statusLabel(op)}'
                      ' - tries: ${op.attempts} - ${op.opId}'
                  : '${OpDescriber.describe(op).subtitle} - ${OpDescriber.statusLabel(op)}',
            ),
          ),
      ],
    );
  }
}
