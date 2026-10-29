import 'package:flutter/material.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';

/// Thin strip shown while the backend cannot be reached (or answers badly).
/// Says plainly what that means: nothing is queued yet, so changes made now
/// will fail rather than wait.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.probe});

  final ConnectivityProbe? probe;

  @override
  Widget build(BuildContext context) {
    final p = probe ?? sl<ConnectivityProbe>();
    return StreamBuilder<ReachabilityStatus>(
      stream: p.status,
      initialData: p.current,
      builder: (context, snapshot) =>
          OfflineBannerView(status: snapshot.data ?? p.current),
    );
  }
}

class OfflineBannerView extends StatelessWidget {
  const OfflineBannerView({super.key, required this.status});

  final ReachabilityStatus status;

  static String? messageFor(ReachabilityStatus status) => switch (status) {
        ReachabilityStatus.online => null,
        ReachabilityStatus.offline =>
          'You are offline. Saving sales and other changes will fail until '
              'the connection returns.',
        ReachabilityStatus.degraded =>
          'The connection is slow or unstable. Saving may take longer or '
              'fail; retry if it does.',
      };

  @override
  Widget build(BuildContext context) {
    final message = messageFor(status);
    if (message == null) return const SizedBox.shrink();
    final offline = status == ReachabilityStatus.offline;
    final color = offline ? AppColors.offline : AppColors.warning;
    return Container(
      key: const Key('offline-banner'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(offline ? Icons.cloud_off : Icons.wifi_tethering_error,
              size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
