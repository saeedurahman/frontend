import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_cubit.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_state.dart';
import 'package:frantend/features/restaurant/presentation/widgets/floor_plan_grid.dart';
import 'package:frantend/features/restaurant/presentation/widgets/floor_plan_selector_bar.dart';
import 'package:frantend/features/restaurant/presentation/widgets/table_detail_sheet.dart';
import 'package:frantend/features/restaurant/presentation/widgets/table_status_legend.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class TablesFloorPage extends StatelessWidget {
  const TablesFloorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TablesFloorCubit>()..init(),
      child: const _TablesFloorView(),
    );
  }
}

class _TablesFloorView extends StatelessWidget {
  const _TablesFloorView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TablesFloorCubit, TablesFloorState>(
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
            message: "You don't have permission to view tables",
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TablesToolbar(
              isRefreshing: state.isRefreshing,
              onRefresh: () => context.read<TablesFloorCubit>().refresh(),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const TableStatusLegend(),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state.status == TablesFloorStatus.loaded &&
                state.hasMultipleFloorPlans)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                child: FloorPlanSelectorBar(
                  floorPlans: state.layout!.floorPlans,
                  selectedFloorPlanId: state.selectedFloorPlanId,
                  onSelected: context.read<TablesFloorCubit>().selectFloorPlan,
                ),
              ),
            Expanded(
              child: switch (state.status) {
                TablesFloorStatus.initial ||
                TablesFloorStatus.loading =>
                  const _TablesLoadingPlaceholder(),
                TablesFloorStatus.error => EmptyState(
                    icon: Icons.error_outline,
                    message: state.errorMessage ?? 'Failed to load tables',
                  ),
                TablesFloorStatus.loaded => _TablesBody(state: state),
              },
            ),
          ],
        );
      },
    );
  }
}

class _TablesToolbar extends StatelessWidget {
  const _TablesToolbar({
    required this.isRefreshing,
    required this.onRefresh,
  });

  final bool isRefreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Tap a table to open or resume an order',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: isRefreshing ? null : onRefresh,
          icon: isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

class _TablesBody extends StatelessWidget {
  const _TablesBody({required this.state});

  final TablesFloorState state;

  @override
  Widget build(BuildContext context) {
    final tables = state.visibleTables;
    final unassigned = state.layout?.unassignedTables ?? const [];

    if (tables.isEmpty && unassigned.isEmpty) {
      return const EmptyState(
        icon: Icons.table_restaurant_outlined,
        message: 'No tables configured for this branch yet',
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TablesFloorCubit>().refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          FloorPlanGrid(
            tables: tables,
            onTableTap: (table) => showTableDetailSheet(context, table),
          ),
          if (unassigned.isNotEmpty &&
              state.selectedFloorPlan != null &&
              tables.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Unassigned tables',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (unassigned.isNotEmpty)
            FloorPlanGrid(
              tables: unassigned,
              onTableTap: (table) => showTableDetailSheet(context, table),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TablesLoadingPlaceholder extends StatelessWidget {
  const _TablesLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(
          8,
          (_) => Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
