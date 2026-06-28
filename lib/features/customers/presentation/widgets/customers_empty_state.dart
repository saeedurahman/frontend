import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/customers/presentation/utils/customer_list_navigation.dart';

class CustomersEmptyState extends StatelessWidget {
  const CustomersEmptyState({
    super.key,
    required this.hasSearch,
    required this.onClear,
  });

  final bool hasSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (hasSearch) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No customers match your search',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onClear,
              child: const Text('Clear Search'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('No customers yet', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => openCustomerForm(context, RouteNames.customerNew),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Customer'),
          ),
        ],
      ),
    );
  }
}
