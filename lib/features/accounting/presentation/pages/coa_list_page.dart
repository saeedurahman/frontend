import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_list_cubit.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_list_state.dart';
import 'package:frantend/features/accounting/presentation/utils/accounting_navigation.dart';
import 'package:frantend/features/accounting/presentation/widgets/coa_tree_list.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class CoaListPage extends StatelessWidget {
  const CoaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CoaListCubit>()..init(),
      child: const _CoaListView(),
    );
  }
}

class _CoaListView extends StatefulWidget {
  const _CoaListView();

  @override
  State<_CoaListView> createState() => _CoaListViewState();
}

class _CoaListViewState extends State<_CoaListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoaListCubit, CoaListState>(
      listener: (context, state) {
        if (state is CoaListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is CoaListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view the chart of accounts",
          );
        }

        final count = switch (state) {
          CoaListLoaded(:final filteredNodes) => filteredNodes.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(
              total: count,
              canManage: state is CoaListLoaded && state.canManage,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is CoaListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                CoaListInitial() || CoaListLoading() => Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => Container(
                        height: 64,
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.white,
                      ),
                    ),
                  ),
                CoaListLoaded(:final filteredNodes, :final treeRoots)
                    when filteredNodes.isEmpty =>
                  const EmptyState(
                    icon: Icons.account_tree_outlined,
                    message: 'No accounts found',
                  ),
                CoaListLoaded loaded => CoaTreeList(
                    roots: loaded.treeRoots,
                    filteredNodes: loaded.searchQuery.trim().isNotEmpty
                        ? loaded.filteredNodes
                        : null,
                    canManage: loaded.canManage,
                    onAccountTap: (account) => _openAccount(context, account),
                    onDelete: loaded.canManage ? (account) => _confirmDelete(context, account) : null,
                  ),
                CoaListError(:final message) => Center(child: Text(message)),
                CoaListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAccount(BuildContext context, ChartOfAccountModel account) async {
    final saved = await openCoaForm(context, accountId: account.id);
    if (saved == true && context.mounted) {
      await context.read<CoaListCubit>().refresh();
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ChartOfAccountModel account,
  ) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete account?',
      message:
          'Delete "${account.accountCode} · ${account.accountName}"? Child accounts or journal lines will block deletion.',
    );
    if (ok != true || !context.mounted) return;

    final err = await context.read<CoaListCubit>().deleteAccount(account.id);
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Account deleted');
    }
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.total, required this.canManage});

  final int total;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => openAccountingHome(context),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Back to Journal Entries'),
        ),
        const SizedBox(width: 8),
        Text('Chart of Accounts', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total accounts)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        if (canManage)
          ElevatedButton.icon(
            onPressed: () async {
              final created = await openCoaForm(context);
              if (created == true && context.mounted) {
                await context.read<CoaListCubit>().refresh();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Account'),
          ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final CoaListLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CoaListCubit>();
    final view = context.findAncestorStateOfType<_CoaListViewState>();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 280,
          child: TextField(
            controller: view?._searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search code or name',
              isDense: true,
            ),
            onChanged: cubit.setSearchQuery,
          ),
        ),
        FilterChip(
          label: const Text('Active only'),
          selected: state.activeOnlyFilter,
          onSelected: cubit.setActiveOnlyFilter,
        ),
      ],
    );
  }
}
