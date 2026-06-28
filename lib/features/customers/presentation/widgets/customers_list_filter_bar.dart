import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';

class CustomersListFilterBar extends StatelessWidget {
  const CustomersListFilterBar({
    super.key,
    required this.searchController,
    required this.activeFilter,
    required this.hasOutstandingOnly,
  });

  final TextEditingController searchController;
  final CustomerActiveFilter activeFilter;
  final bool hasOutstandingOnly;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomersListCubit>();

    return Row(
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
        const SizedBox(width: AppDimensions.spacingMd),
        _ActiveFilterChip(
          label: 'All',
          selected: activeFilter == CustomerActiveFilter.all,
          onSelected: () => cubit.setActiveFilter(CustomerActiveFilter.all),
        ),
        const SizedBox(width: 8),
        _ActiveFilterChip(
          label: 'Active',
          selected: activeFilter == CustomerActiveFilter.active,
          onSelected: () => cubit.setActiveFilter(CustomerActiveFilter.active),
        ),
        const SizedBox(width: 8),
        _ActiveFilterChip(
          label: 'Inactive',
          selected: activeFilter == CustomerActiveFilter.inactive,
          onSelected: () => cubit.setActiveFilter(CustomerActiveFilter.inactive),
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Outstanding'),
          selected: hasOutstandingOnly,
          onSelected: cubit.setHasOutstandingFilter,
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          checkmarkColor: AppColors.primary,
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
