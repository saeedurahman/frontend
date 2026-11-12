import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/sync_engine.dart';

/// Covers the app with "Preparing your data" until the first snapshot has
/// fully arrived (new install, or after "Resync all data"). Without data the
/// POS would be an empty shell, so nothing else is usable meanwhile.
class DataPreparationGate extends StatelessWidget {
  const DataPreparationGate({super.key, required this.child, this.engine, this.guard});

  final Widget child;
  final SyncEngine? engine;
  final AuthGuard? guard;

  @override
  Widget build(BuildContext context) {
    final e = engine ?? sl<SyncEngine>();
    final g = guard ?? sl<AuthGuard>();
    return ListenableBuilder(
      listenable: g,
      builder: (context, _) => StreamBuilder<SyncEngineState>(
        stream: e.states,
        initialData: e.state,
        builder: (context, snapshot) {
          final state = snapshot.data ?? e.state;
          final show = g.isAuthenticated && (!state.hasData || state.progress != null);
          return Stack(
            fit: StackFit.expand,
            children: [
              child,
              if (show)
                Positioned.fill(
                  child: PreparingDataView(
                    state: state,
                    onRetry: () => e.syncNow(manual: true),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class PreparingDataView extends StatelessWidget {
  const PreparingDataView({super.key, required this.state, required this.onRetry});

  final SyncEngineState state;
  final VoidCallback onRetry;

  static String progressText(SnapshotProgress? p) {
    if (p == null || p.rows == 0) return 'Getting started...';
    return '${p.rows} records downloaded';
  }

  @override
  Widget build(BuildContext context) {
    final stuck = !state.syncing && state.lastError != null;
    return Material(
      key: const Key('preparing-data'),
      color: AppColors.loginBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!stuck) const CircularProgressIndicator(),
              if (stuck)
                const Icon(Icons.cloud_off, size: 40, color: AppColors.offline),
              const SizedBox(height: 20),
              Text(
                'Preparing your data',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                stuck
                    ? 'Connect to the internet once so your products, prices '
                        'and customers can be downloaded. After that the POS '
                        'works without a connection.'
                    : progressText(state.progress),
                textAlign: TextAlign.center,
                key: const Key('preparing-progress'),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              if (stuck) ...[
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('preparing-retry'),
                  onPressed: onRetry,
                  child: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
