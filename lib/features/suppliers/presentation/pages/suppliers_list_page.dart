import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/khata/domain/balance_filter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/domain/text/list_filter_text.dart';
import 'package:frantend/features/khata/presentation/widgets/balance_filter_bar.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/features/suppliers/presentation/widgets/suppliers_data_table.dart';
import 'package:frantend/features/suppliers/presentation/widgets/suppliers_empty_state.dart';
import 'package:frantend/features/suppliers/presentation/widgets/suppliers_list_toolbar.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class SuppliersListPage extends StatelessWidget {
  const SuppliersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<SuppliersListCubit>();
        if (sl.isRegistered<ConnectivityProbe>()) {
          cubit.watchConnectivity(sl<ConnectivityProbe>());
        }
        return cubit..load();
      },
      child: BlocListener<BranchSelectorCubit, BranchSelectorState>(
        bloc: sl.isRegistered<BranchSelectorCubit>()
            ? sl<BranchSelectorCubit>()
            : null,
        listener: (context, branchState) {
          context
              .read<SuppliersListCubit>()
              .onBranchChanged(branchState.selectedBranchId);
        },
        child: const _SuppliersListView(),
      ),
    );
  }
}

class _SuppliersListView extends StatefulWidget {
  const _SuppliersListView();

  @override
  State<_SuppliersListView> createState() => _SuppliersListViewState();
}

class _SuppliersListViewState extends State<_SuppliersListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuppliersListCubit, SuppliersListState>(
      listener: (context, state) {
        if (state is SuppliersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final count = switch (state) {
          SuppliersListLoaded(:final filteredItems) => filteredItems.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SuppliersListToolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            Wrap(
              spacing: AppDimensions.spacingMd,
              runSpacing: AppDimensions.spacingSm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    onChanged: context.read<SuppliersListCubit>().search,
                    decoration: InputDecoration(
                      hintText: 'Search suppliers',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                BalanceFilterBar(
                  type: PartyType.supplier,
                  filter: switch (state) {
                    SuppliersListLoaded(:final balanceFilter) =>
                      balanceFilter,
                    _ => BalanceFilter.all,
                  },
                  sort: switch (state) {
                    SuppliersListLoaded(:final balanceSort) => balanceSort,
                    _ => BalanceSort.none,
                  },
                  onFilter:
                      context.read<SuppliersListCubit>().setBalanceFilter,
                  onSort: context.read<SuppliersListCubit>().setBalanceSort,
                ),
                if (state case SuppliersListLoaded(:final asOf?)) ...[
                  AsOfLabel(
                    key: const Key('suppliers-as-of'),
                    asOf: asOf,
                  ),
                  const Text(
                    KhataText.offlineAllBranches,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                SuppliersListInitial() || SuppliersListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                SuppliersListLoaded(
                  :final filteredItems,
                  :final balanceFilter,
                )
                    when filteredItems.isEmpty &&
                        balanceFilter != BalanceFilter.all =>
                  KhataEmptyState(
                    icon: Icons.filter_alt_off_outlined,
                    title: ListFilterText.nobodyMatches,
                    actionLabel: HubText.clearFilters,
                    onAction: () => context
                        .read<SuppliersListCubit>()
                        .setBalanceFilter(BalanceFilter.all),
                  ),
                SuppliersListLoaded(:final filteredItems)
                    when filteredItems.isEmpty =>
                  SuppliersEmptyState(
                    hasSearch: _searchController.text.isNotEmpty,
                    onClear: () {
                      _searchController.clear();
                      context.read<SuppliersListCubit>().search('');
                    },
                  ),
                SuppliersListLoaded(:final filteredItems) =>
                  SuppliersDataTable(items: filteredItems),
                SuppliersListError(:final message) => Center(
                    child: Text(message, style: AppTextStyles.bodyMedium),
                  ),
              },
            ),
          ],
        );
      },
    );
  }
}
