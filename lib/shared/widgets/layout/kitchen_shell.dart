import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/widgets/branch_selector_chip.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:go_router/go_router.dart';

/// Minimal full-screen shell for kitchen staff — no POS sidebar.
class KitchenShell extends StatelessWidget {
  const KitchenShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        title: const Text(
          'Kitchen Display',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          const BranchSelectorChip(),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              sl<NotificationsCubit>().stopSession();
              sl<BranchSelectorCubit>().stopSession();
              await sl<AuthRepository>().logout();
              sl<AuthGuard>().setAuthenticated(false);
              if (context.mounted) context.go(RouteNames.login);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
    );
  }
}
