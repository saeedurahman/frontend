import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/restaurant/presentation/cubit/kitchen_display_cubit.dart';
import 'package:frantend/features/restaurant/presentation/cubit/kitchen_display_state.dart';
import 'package:frantend/features/restaurant/presentation/widgets/kot_kanban_board.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class KitchenDisplayPage extends StatelessWidget {
  const KitchenDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KitchenDisplayCubit>()..init(),
      child: BlocListener<BranchSelectorCubit, BranchSelectorState>(
        bloc: sl<BranchSelectorCubit>(),
        listenWhen: (previous, current) =>
            previous.selectedBranchId != current.selectedBranchId,
        listener: (context, state) {
          context.read<KitchenDisplayCubit>().onBranchChanged(
                state.selectedBranchId,
              );
        },
        child: const _KitchenDisplayView(),
      ),
    );
  }
}

class _KitchenDisplayView extends StatelessWidget {
  const _KitchenDisplayView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KitchenDisplayCubit, KitchenDisplayState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppAlerts.showErrorMessage(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        if (state.accessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view the kitchen display",
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _KitchenToolbar(
              isRefreshing: state.isRefreshing,
              lastRefreshedAt: state.lastRefreshedAt,
              onRefresh: () => context.read<KitchenDisplayCubit>().refresh(),
            ),
            Expanded(
              child: switch (state.status) {
                KitchenDisplayStatus.initial ||
                KitchenDisplayStatus.loading =>
                  const _KitchenLoadingPlaceholder(),
                KitchenDisplayStatus.error => EmptyState(
                    icon: Icons.error_outline,
                    message: state.errorMessage ?? 'Failed to load tickets',
                  ),
                KitchenDisplayStatus.loaded => KotKanbanBoard(state: state),
              },
            ),
          ],
        );
      },
    );
  }
}

class _KitchenToolbar extends StatelessWidget {
  const _KitchenToolbar({
    required this.isRefreshing,
    required this.lastRefreshedAt,
    required this.onRefresh,
  });

  final bool isRefreshing;
  final DateTime? lastRefreshedAt;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final refreshedLabel = lastRefreshedAt == null
        ? 'Auto-refresh every 30s'
        : 'Updated ${_formatTime(lastRefreshedAt!)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              refreshedLabel,
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: isRefreshing ? null : onRefresh,
            icon: isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _KitchenLoadingPlaceholder extends StatelessWidget {
  const _KitchenLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E293B),
      highlightColor: const Color(0xFF334155),
      child: Row(
        children: List.generate(
          3,
          (_) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: List.generate(
                  2,
                  (_) => Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
