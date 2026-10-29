import 'package:flutter/material.dart';
import 'package:frantend/features/branches/presentation/widgets/branch_selector_chip.dart';
import 'package:frantend/shared/widgets/layout/sign_out_flow.dart';
import 'package:frantend/shared/widgets/sync/sync_status_chip.dart';

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
          const SyncStatusChip(),
          const SizedBox(width: 8),
          const BranchSelectorChip(),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => signOutWithGuard(context),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
    );
  }
}
