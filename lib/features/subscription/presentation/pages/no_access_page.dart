import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

/// Shown instead of a page the user is not allowed to open. The user stays
/// signed in.
class NoAccessPage extends StatelessWidget {
  const NoAccessPage({super.key, this.onGoHome});

  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text(
            'No access',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'You do not have permission to open this page.\n'
            'Ask the business owner if you need it.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('no-access-home'),
            onPressed: onGoHome ?? () => context.go(RouteNames.dashboard),
            child: const Text('Go to dashboard'),
          ),
        ],
      ),
    );
  }
}
