import 'package:flutter/material.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';

/// The sentences every online-only screen uses. One place, so the wording
/// never drifts between Tables, Kitchen, Tabs, Products, Inventory...
abstract final class OfflineMessages {
  /// Dine-in tabs, tables and the kitchen need the server by design.
  static const tableService =
      'Table service needs internet. You can still make a Counter sale.';

  /// Master data (products, stock, categories) is readable but not editable.
  static const editingNeedsInternet = 'Editing needs internet.';

  static const editingNotice =
      'Editing needs internet. You can view this offline.';

  static const fullDetailsNeedInternet = 'Full details need internet';

  static const goToCounterSale = 'Go to Counter sale';

  /// Anything else that only the server has.
  static const needsInternet = 'This needs internet.';
}

/// Tells its [builder] whether the server is currently unreachable and
/// rebuilds when that changes.
///
/// Uses the app's [ConnectivityProbe]; tests (and previews) pass their own.
class OfflineAwareBuilder extends StatelessWidget {
  const OfflineAwareBuilder({super.key, required this.builder, this.probe});

  final Widget Function(BuildContext context, bool offline) builder;
  final ConnectivityProbe? probe;

  static ConnectivityProbe? resolve(ConnectivityProbe? probe) =>
      probe ?? (sl.isRegistered<ConnectivityProbe>() ? sl<ConnectivityProbe>() : null);

  @override
  Widget build(BuildContext context) {
    final p = resolve(probe);
    if (p == null) return builder(context, false);
    return StreamBuilder<ReachabilityStatus>(
      stream: p.status,
      initialData: p.current,
      builder: (context, snapshot) => builder(
        context,
        (snapshot.data ?? p.current) == ReachabilityStatus.offline,
      ),
    );
  }
}

/// The plain notice shown on screens that need the server: an icon, one
/// sentence and an optional way out. Never carries error text.
class OnlineOnlyBanner extends StatelessWidget {
  const OnlineOnlyBanner({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.offline;
    return Container(
      key: const Key('online-only-banner'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 12),
            FilledButton(
              key: const Key('online-only-action'),
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Wraps a screen that needs the server.
///
/// * Online: shows [child] untouched.
/// * Offline: shows the [OnlineOnlyBanner] with [message] (and the optional
///   action). With [replaceChildWhenOffline] the screen's own content is
///   not shown at all (nothing to load, nothing to fail); otherwise the
///   child stays below the banner (read-only screens).
///
/// Every online-only screen uses this one widget, so the wording and the
/// look are the same everywhere and no raw network error ever reaches the UI.
class OfflineAwareScaffold extends StatelessWidget {
  const OfflineAwareScaffold({
    super.key,
    required this.child,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.replaceChildWhenOffline = false,
    this.probe,
  });

  final Widget child;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool replaceChildWhenOffline;
  final ConnectivityProbe? probe;

  @override
  Widget build(BuildContext context) {
    return OfflineAwareBuilder(
      probe: probe,
      builder: (context, offline) {
        if (!offline) return child;
        final banner = OnlineOnlyBanner(
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        );
        if (replaceChildWhenOffline) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(padding: const EdgeInsets.all(16), child: banner),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: banner,
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
