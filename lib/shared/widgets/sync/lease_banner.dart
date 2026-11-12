import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/sync/lease_service.dart';

/// Warns while the offline lease has expired but the grace window still lets
/// the POS work, and when the device clock looks wrong.
class LeaseBanner extends StatelessWidget {
  const LeaseBanner({super.key, this.service});
  final LeaseService? service;

  @override
  Widget build(BuildContext context) {
    final s = service ?? sl<LeaseService>();
    return StreamBuilder<LeaseVerdict>(
      stream: s.verdicts,
      initialData: s.last,
      builder: (context, snapshot) =>
          LeaseBannerView(verdict: snapshot.data ?? s.last, now: DateTime.now()),
    );
  }
}

class LeaseBannerView extends StatelessWidget {
  const LeaseBannerView({super.key, required this.verdict, required this.now});

  final LeaseVerdict verdict;
  final DateTime now;

  static String? messageFor(LeaseVerdict v, DateTime now) {
    switch (v.state) {
      case LeaseState.grace:
        final left = v.graceLeft(now.toUtc());
        final days = left == null ? 0 : (left.inHours / 24).ceil().clamp(0, 99);
        return 'Your subscription check is overdue. Connect to the internet '
            'within $days day(s) or the POS will lock.';
      case LeaseState.clockRolledBack:
        return "This device's clock is behind. Fix the date and time, then "
            'connect to the internet.';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = messageFor(verdict, now);
    if (message == null) return const SizedBox.shrink();
    return Container(
      key: const Key('lease-banner'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.warning.withValues(alpha: 0.14),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 18, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
