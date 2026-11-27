import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/khata/domain/balance_filter.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/widgets/balance_filter_bar.dart';

class CustomersListFilterBar extends StatelessWidget {
  const CustomersListFilterBar({
    super.key,
    required this.searchController,
    required this.activeFilter,
    required this.balanceFilter,
    required this.balanceSort,
  });

  final TextEditingController searchController;
  final CustomerActiveFilter activeFilter;
  final BalanceFilter balanceFilter;
  final BalanceSort balanceSort;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomersListCubit>();

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            controller: searchController,
            onChanged: cubit.search,
            decoration: InputDecoration(
              hintText: 'Search customers',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
        _ActiveFilterChip(
          label: 'All',
          selected: activeFilter == CustomerActiveFilter.all,
          onSelected: () => cubit.setActiveFilter(CustomerActiveFilter.all),
        ),
        _ActiveFilterChip(
          label: 'Active',
          selected: activeFilter == CustomerActiveFilter.active,
          onSelected: () => cubit.setActiveFilter(CustomerActiveFilter.active),
        ),
        _ActiveFilterChip(
          label: 'Inactive',
          selected: activeFilter == CustomerActiveFilter.inactive,
          onSelected: () => cubit.setActiveFilter(CustomerActiveFilter.inactive),
        ),
        BalanceFilterBar(
          type: PartyType.customer,
          filter: balanceFilter,
          sort: balanceSort,
          onFilter: cubit.setBalanceFilter,
          onSort: cubit.setBalanceSort,
        ),
      ],
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
    );
  }
}
