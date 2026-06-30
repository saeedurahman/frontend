import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/domain/usecases/branches_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_cubit.dart';
import 'package:frantend/features/returns/presentation/cubit/returns_list_state.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frantend/features/returns/presentation/widgets/returns_data_table.dart';

class ReturnsListPage extends StatelessWidget {
  const ReturnsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReturnsListCubit>()..init(),
      child: const _ReturnsListView(),
    );
  }
}

class _ReturnsListView extends StatelessWidget {
  const _ReturnsListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnsListCubit, ReturnsListState>(
      listener: (context, state) {
        if (state is ReturnsListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ReturnsListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view returns",
          );
        }

        final count = switch (state) {
          ReturnsListLoaded(:final items) => items.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ReturnsToolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is ReturnsListLoaded)
              _BranchFilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                ReturnsListInitial() || ReturnsListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                ReturnsListLoaded(:final items) when items.isEmpty =>
                  const _ReturnsEmptyState(),
                ReturnsListLoaded loaded => Column(
                    children: [
                      Expanded(child: ReturnsDataTable(items: loaded.items)),
                      if (loaded.hasMore || loaded.isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: OutlinedButton.icon(
                            onPressed: loaded.isLoadingMore
                                ? null
                                : () => context
                                    .read<ReturnsListCubit>()
                                    .loadMore(),
                            icon: loaded.isLoadingMore
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.expand_more),
                            label: Text(
                              loaded.isLoadingMore
                                  ? 'Loading…'
                                  : 'Load more returns',
                            ),
                          ),
                        ),
                    ],
                  ),
                ReturnsListError(:final message) => Center(
                    child: Text(message, style: AppTextStyles.bodyMedium),
                  ),
                ReturnsListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}

class _ReturnsToolbar extends StatelessWidget {
  const _ReturnsToolbar({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Returns', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total loaded)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _BranchFilterBar extends StatefulWidget {
  const _BranchFilterBar({required this.state});

  final ReturnsListLoaded state;

  @override
  State<_BranchFilterBar> createState() => _BranchFilterBarState();
}

class _BranchFilterBarState extends State<_BranchFilterBar> {
  List<BranchModel> _branches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    final result = await sl<BranchesUseCases>().getBranches();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (branches) => setState(() {
        _branches = branches;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _branches.length <= 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 280,
      child: DropdownButtonFormField<String?>(
        value: widget.state.branchIdFilter,
        decoration: const InputDecoration(
          labelText: 'Branch',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All branches'),
          ),
          ..._branches.map(
            (b) => DropdownMenuItem<String?>(
              value: b.id,
              child: Text(b.name),
            ),
          ),
        ],
        onChanged: (value) =>
            context.read<ReturnsListCubit>().applyBranchFilter(value),
      ),
    );
  }
}

class _ReturnsEmptyState extends StatelessWidget {
  const _ReturnsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_return_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No returns found',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Processed returns will appear here',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
