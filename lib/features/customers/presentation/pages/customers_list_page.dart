import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/customers/presentation/widgets/customers_data_table.dart';
import 'package:frantend/features/customers/presentation/widgets/customers_empty_state.dart';
import 'package:frantend/features/customers/presentation/widgets/customers_list_filter_bar.dart';
import 'package:frantend/features/customers/presentation/widgets/customers_list_toolbar.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class CustomersListPage extends StatelessWidget {
  const CustomersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomersListCubit>()..load(),
      child: const _CustomersListView(),
    );
  }
}

class _CustomersListView extends StatefulWidget {
  const _CustomersListView();

  @override
  State<_CustomersListView> createState() => _CustomersListViewState();
}

class _CustomersListViewState extends State<_CustomersListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomersListCubit, CustomersListState>(
      listener: (context, state) {
        if (state is CustomersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final count = switch (state) {
          CustomersListLoaded(:final filteredItems) => filteredItems.length,
          _ => 0,
        };

        final activeFilter = switch (state) {
          CustomersListLoaded(:final activeFilter) => activeFilter,
          _ => CustomerActiveFilter.all,
        };

        final hasOutstandingOnly = switch (state) {
          CustomersListLoaded(:final hasOutstandingOnly) => hasOutstandingOnly,
          _ => false,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomersListToolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            CustomersListFilterBar(
              searchController: _searchController,
              activeFilter: activeFilter,
              hasOutstandingOnly: hasOutstandingOnly,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                CustomersListInitial() || CustomersListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                CustomersListLoaded(:final filteredItems)
                    when filteredItems.isEmpty =>
                  CustomersEmptyState(
                    hasSearch: _searchController.text.isNotEmpty,
                    onClear: () {
                      _searchController.clear();
                      context.read<CustomersListCubit>().search('');
                    },
                  ),
                CustomersListLoaded(:final filteredItems) =>
                  CustomersDataTable(items: filteredItems),
                CustomersListError(:final message) => Center(
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
