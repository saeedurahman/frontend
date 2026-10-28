import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:go_router/go_router.dart';

/// The text of the banner for [state], or null when no banner is needed.
String? subscriptionBannerText(SubscriptionState state) {
  if (state.isBlocked) return null;
  if (state.isGraceReadOnly) {
    return 'Read-only mode: your subscription has ended. You can look at your '
        'data but cannot make changes. Contact us to renew.';
  }
  if (state.showExpiryBanner) {
    final days = state.daysLeft!;
    final when = switch (days) {
      0 => 'today',
      1 => 'in 1 day',
      _ => 'in $days days',
    };
    return 'Your subscription ends $when. Contact us to renew.';
  }
  return null;
}

/// Strip under the top bar: expiry warning (7 days or less) or read-only mode.
class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionState state;
    try {
      state = context.watch<SubscriptionCubit>().state;
    } catch (_) {
      return const SizedBox.shrink();
    }
    final text = subscriptionBannerText(state);
    if (text == null) return const SizedBox.shrink();

    final readOnly = state.isGraceReadOnly;
    final color = readOnly ? const Color(0xFFB91C1C) : const Color(0xFFB45309);
    final background =
        readOnly ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7);

    return Material(
      color: background,
      child: Container(
        key: Key(readOnly ? 'banner-read-only' : 'banner-expiry'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              readOnly ? Icons.lock_outline : Icons.warning_amber_rounded,
              color: color,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go(RouteNames.settingsSubscription),
              child: const Text('How to renew'),
            ),
          ],
        ),
      ),
    );
  }
}
